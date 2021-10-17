local effects = {
    [1] = {['text'] = "Breath smells like alcohol", ['status'] = false, ['timer'] = 0},
    [2] = {['text'] = "Dilated eyes", ['status'] = false, ['timer'] = 0},
    [3] = {['text'] = "Bloodshot eyes", ['status'] = false, ['timer'] = 0},
    [4] = {['text'] = "Smells like marijuana", ['status'] = false, ['timer'] = 0},
    [5] = {['text'] = "Fresh bandaging", ['status'] = false, ['timer'] = 0},
}


function DrugsEffect1()
	StartScreenEffect("DrugsMichaelAliensFightIn", 3.0, 0)
	Citizen.Wait(math.random(2000, 4000))
	StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
	Citizen.Wait(math.random(2000, 4000))
	StartScreenEffect("DrugsMichaelAliensFightOut", 3.0, 1)
end

function DrugsEffect2()
	StartScreenEffect("DrugsTrevorClownsFightIn", 3.0, 0)
	Citizen.Wait(math.random(2000, 4000))
	StartScreenEffect("DrugsTrevorClownsFight", 3.0, 0)
	Citizen.Wait(math.random(200, 4000))
	StartScreenEffect("DrugsTrevorClownsFightOut", 3.0, 1)
end

exports('addEffect', function(name, amount)
    if not effects[name] then
        if name == "speed" then
            CreateThread(function()
                effects[name].timer = effects[name].timer + amount

                if effects[name].status == true then return end
                effects[name].status = true

                Citizen.Wait(math.random(5, 15)*1000)
                if math.random(100) > 50 then DrugsEffect1() else DrugsEffect2() end

                SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
                while effects[name].timer > 0 do
                    RestorePlayerStamina(PlayerId(), 1.0)
                    if IsPedRagdoll(PlayerPedId()) then
                        SetPedToRagdoll(PlayerPedId(), math.random(5), math.random(5), 3, 0, 0, 0)
                    end
                    local armor = GetPedArmour(PlayerPedId())
                    SetPedArmour(PlayerPedId(),armor+3)

                    if math.random(500) < 3 then
                        if math.random(100) > 50 then
                            DrugsEffect1()
                        else
                            DrugsEffect2()
                        end
                        Citizen.Wait(math.random(30000))
                    end
        
                    if math.random(100) > 91 and IsPedRunning(PlayerPedId()) then
                        SetPedToRagdoll(PlayerPedId(), math.random(1000), math.random(1000), 3, 0, 0, 0)
                    end

                    Wait(1000)
                end

                SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)

                StopScreenEffect("DrugsMichaelAliensFightIn")
                StopScreenEffect("DrugsMichaelAliensFight")
                StopScreenEffect("DrugsMichaelAliensFightOut")
        
                StopScreenEffect("DrugsTrevorClownsFight")
                StopScreenEffect("DrugsTrevorClownsFightIn")
                StopScreenEffect("DrugsTrevorClownsFightOut")

                effects[name].status = false
            end)
        elseif name == "drunk" then
            CreateThread(function()
                effects[name].timer = effects[name].timer + amount

                while effects[name].timer > 0 do
                    local set = effects[name].timer > 100 and "MOVE_M@DRUNK@VERYDRUNK" or "MOVE_M@DRUNK@SLIGHTLYDRUNK"
                    
                    SetTimecycleModifier("spectator5")
                    SetPedMotionBlur(PlayerPedId(), true)
                    SetPedMovementClipset(PlayerPedId(), set, true)
                    SetPedIsDrunk(PlayerPedId(), true)
                    SetPedAccuracy(PlayerPedId(), 0)
                    
                    Wait(1000)
                end
                ClearTimecycleModifier()
                ResetScenarioTypesEnabled()
                ResetPedMovementClipset(PlayerPedId(), 0)
                SetPedIsDrunk(PlayerPedId(), false)
                SetPedMotionBlur(PlayerPedId(), false)    

                effects[name].status = false
            end)
        end    
    else
        effects[name] = effects[name] + amount
    end
end)

exports('reduceEffect', function(name, amount)
    if effects[name] then
        effects[name].timer = effects[name].timer - amount
        if effects[name].timer < 0 then effects[name].timer = 0 end
    end
end)

CreateThread(function()
    while true do
        for _, v in pairs (effects) do
            if v.timer > 0 then
                v.timer = v.timer - 1
            end
        end
        Wait(1000)
    end
end)
