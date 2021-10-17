local currentTarget = nil
local currentTargetCoords = nil
local currentTargetModel = nil

function loopSkill(amountToDo)
    local doneIteration = 0
    local failed = false

    for i = 1, amountToDo do
        local success = exports['skill-checks']:start(math.random(50, 75)/1000, math.random(150, 270))
        doneIteration = i
        if not isDead and exports['skill-checks']:canDo() then
            if success then
                if i == amountToDo then
                    failed = false
                    return true
                end
            else
                -- BREAK LOCKPICK
                failed = true
                return false
            end
        else
            failed = true
            return false
        end
        while (doneIteration ~= i) do
            Wait(1)
        end
        if failed then return false end
    end

    return not failed
end

function loadAnimDict( dict )  
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function breakInToRegister()
    if exports['skill-checks']:canDo() then
        skilling = true

        local registerId = string.format("%.2f", currentTargetCoords.x) .. "_"
        .. string.format("%.2f", currentTargetCoords.y) .. "_"
        .. string.format("%.2f", currentTargetCoords.z)

        print ("Register ID: "..registerId)
        local canRob = RPC.execute("jp-heists:registers:startRob", registerId)
        if canRob then
            print ("Alert police!")
    
            TaskTurnPedToFaceEntity(PlayerPedId(), currentTarget, -1)
            Wait(1000)
            ClearPedTasksImmediately(PlayerPedId())
            Wait(0)
    
            loadAnimDict( "missheist_jewel" ) 
            TaskPlayAnim(PlayerPedId(), 'missheist_jewel', 'smash_case', 8.0, 8.0, -1, 17, 1, false, false, false)

            local skillResult = loopSkill(5)

            ClearPedTasksImmediately(GetPlayerPed(-1))

            skilling = false
            if not skillResult then
                return
            end
    
            TriggerServerEvent("jp-heists:registers:finishRob", registerId)      
        else
            skilling = false
        end
    end
end

AddEventHandler("jp-heists:shops:breakInToRegister", function(pEntity, pContext, pParameters)
    if skilling then return end
    if not exports['inventory']:canCarryItem('cash', 500) then
        TriggerEvent("DoLongHudText", "Sul pole piisavalt ruumi et sularaha võtta!", 'red')
        return
    end

    currentTarget = pEntity
    currentTargetCoords = GetEntityCoords(pEntity)
    breakInToRegister()
end)