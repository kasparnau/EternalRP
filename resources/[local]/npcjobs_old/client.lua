local events = exports['events']

local playerJob = exports['players']:GetClientVar("character") and exports['players']:GetClientVar("character").job or "Unemployed"
local myBlips = {}

local currentPoint = nil
local currentDistance = math.huge

local jobBlipSprites = {
    ['Sewer'] = 366,
    ['Miner'] = 498,
}

local itemList = exports['inventory']:getItemList()

CreateThread(function()
    while true do
        if jobPoints[playerJob] then
            if (#myBlips) == 0 then
                for i,v in pairs (jobPoints[playerJob]) do
                    currentBlip = AddBlipForCoord(type(v.coords) == 'vector3' and v.coords or v.coords[1])

                    SetBlipSprite(currentBlip, jobBlipSprites[playerJob])
                    SetBlipColour(currentBlip, 44)
                    SetBlipScale(currentBlip, 1.0)
                    SetBlipAsShortRange(currentBlip, true)

                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString(getJobEstonian(playerJob)..' - '..v.name)
                    EndTextCommandSetBlipName(currentBlip)

                    myBlips[#myBlips+1] = currentBlip
                end
            end

            if currentPoint ~= nil and currentDistance < 3.0 then
                DrawText3D(currentPoint.coords.x, currentPoint.coords.y, currentPoint.coords.z, ('~g~[E]~w~ '..currentPoint.worldText))

                if IsControlJustPressed(0, 38) and not IsPedInAnyVehicle(PlayerPedId()) then
                    local doing = true
                    TriggerEvent("DoLongHudText", "Hakkasid tööd tegema.", "green", 4000)
                    while currentPoint ~= nil and currentDistance < 2.5 and doing do
                        Wait(currentPoint.cooldown)
                        if currentPoint then
                            local canDoAction = true
                            if currentPoint.addItem then
                                if not exports['inventory']:canCarryItem(currentPoint.addItem.itemId, currentPoint.addItem.qty) then
                                    TriggerEvent("DoLongHudText", "Sul pole piisavalt ruumi et seda asja kanda!", "red")
                                    canDoAction = false
                                end
                                if currentPoint.max then
                                    if exports['inventory']:hasEnoughOfItem(currentPoint.addItem.itemId, currentPoint.max) then
                                        local itemName = itemList[currentPoint.addItem.itemId].label
                                        TriggerEvent("DoLongHudText", ("Sul on juba "..currentPoint.max.."x "..itemName.."."), "red")
                                        canDoAction = false
                                    end
                                end
                            end
                            if currentPoint.removeItem then
                                if not exports['inventory']:hasEnoughOfItem(currentPoint.removeItem.itemId, currentPoint.removeItem.qty) then
                                    local itemName = itemList[currentPoint.removeItem.itemId].label
                                    TriggerEvent("DoLongHudText", ("Sul pole piisavalt "..itemName.."."), "red")
                                    canDoAction = false
                                end
                            end
                            if currentPoint.giveCash then
                                if not exports['inventory']:canCarryItem('cash', currentPoint.giveCash) then
                                    TriggerEvent("DoLongHudText", ("Sul pole piisavalt ruumi et kanda "..currentPoint.giveCash.." sularaha."), "red")
                                    canDoAction = false
                                end
                            end
                            if canDoAction then
                                events:Trigger("jobs:doAction", function()
                                    print "Did action"
                                end, currentPointId)
                            else
                                doing = false
                            end
                        else
                            doing = false
                            TriggerEvent("DoLongHudText", ("Sa liikusid eemale!"), "red")
                        end
                    end
                end
            end
            Wait(1)
        else
            Wait(1000)
        end
    end
end)

AddEventHandler("login:firstSpawn", function(newChar)
	playerJob = newChar.job
    for i,v in pairs (myBlips) do
        RemoveBlip(v)
    end
    myBlips = {}
end)

AddEventHandler("players:CharacterVarChanged", function(name, old, new)
	if name == 'job' then
		playerJob = new
	end

    if name == 'job' then
        for i,v in pairs (myBlips) do
            RemoveBlip(v)
        end
        myBlips = {}
    end
end)

CreateThread(function()
    while true do
        if jobPoints[playerJob]  then
            currentPoint = nil
            currentPointId = 0
            currentDistance = math.huge
            for i,v in pairs (jobPoints[playerJob] ) do
                if type(v.coords) == 'table' then
                    for j, k in pairs (v.coords) do
                        local distance = #(GetEntityCoords(PlayerPedId()) - k)
                        v.coords = k
                        if distance < 3.0 then
                            currentPoint = v
                            currentPointId = i
                            currentDistance = distance
                        end
                    end
                else
                    local distance = #(GetEntityCoords(PlayerPedId()) - v.coords)
                    if distance < 3.0 then
                        currentPoint = v
                        currentPointId = i
                        currentDistance = distance
                    end
                end
            end
            Wait(200)
        else
            Wait(1000)
        end
    end
end)

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.5, 0.5)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

function findMax(tbl) 
    for i = 1, #tbl do
        if tbl[i].max then
            return tbl[i].max 
        end
    end
    return 0
end

function calculateMeta(job)
    local totalDist, totalTime, totalCash = 0, 0, 0
    for i = 1, #jobPoints[job] do
        local jobPoint = jobPoints[job][i]
        local str = ''
    
        local max = findMax(jobPoints[job])
    
        if jobPoint.addItem then
            str = (jobPoint.addItem.qty*max.." "..jobPoint.addItem.itemId)

            if jobPoint.addItem.itemId == 'cash' then
                totalCash = jobPoint.addItem.qty*max
            end
        end
    
        if jobPoint.removeItem then
            str = (max.." "..jobPoint.removeItem.itemId.." => "..str)
        end
    
        local lastPoint = jobPoints[job][i-1] or jobPoint

        local lastCoords, nextCoords
        if type(lastPoint['coords']) == 'table' then
            lastCoords = lastPoint['coords'][1]
        else
            lastCoords = lastPoint['coords']
        end

        if type(jobPoint['coords']) == 'table' then
            nextCoords = jobPoint['coords'][1]
        else
            nextCoords = jobPoint['coords']
        end
    
        local time = (jobPoint.cooldown*max)/1000

        local dist = #(lastCoords - nextCoords)
        str = (str.." | "..time.."s | "..dist.."m")

        totalTime = totalTime + time
        totalDist = totalDist + dist
        
        print (str)
    end

    print (" ")
    print ("Total Dist: "..totalDist.."m")
    print ("Total Time: "..totalTime.."s ("..(totalTime/60).."min)")
    print ("Total Cash: $"..totalCash)
    print (" ")
    print ("Cash per second: $"..totalCash/totalTime)
    print ("Cash per meter:  $"..totalCash/totalDist)
end

calculateMeta('Sewer')

function contains(list, x)
	for _, v in pairs(list) do
		if v == x then return true end
	end
	return false
end

local jobs = {
    {"Õmbleja", "Sewer"},
    {"Kaevandaja", "Miner"},
    {"Prügimees", "Sanitation"},
}

function getJobEstonian(job)
    if not job then return end
    for i,v in pairs (jobs) do
        if v[2] == job then return v[1] end
    end
    return nil
end

exports('getJobEstonian', getJobEstonian)

AddEventHandler("npcjobs:choose", function(pParams)
    print ("pParams[1]: "..json.encode(pParams[1]))
    RPC.execute("chooseJob", pParams[1])
end)

AddEventHandler("npcjobs:openMenu", function()
    local MenuData = {}
    for i,v in pairs (jobs) do
        table.insert(MenuData, {
            title = v[1],
            
            children = {
                {
                    title = v[1],
                },
                {
                    title = "Võta Töökoht",
                    event = "npcjobs:choose",
                    params = {v[2]},        
                },
            }
        })
    end

    exports['jp-menu']:showContextMenu(MenuData, "Töökohad")
end)

--[[
    HUNTING 13K/h
    FISHING 10K/h
]]