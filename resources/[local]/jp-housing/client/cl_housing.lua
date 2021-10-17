Housing.currentOwned = {}
Housing.currentLockdown = {}
Housing.currentBeingRobbed = {}

Housing.currentlyInsideBuilding = false

Housing.isRobbingHouse = false
Housing.robLocations = nil

Housing.isPlayerHouse = false
Housing.propertyId = 0

Housing.justLeftBuilding = false

exports('isRobbing', function()
    return Housing.isRobbingHouse
end)

exports('isInside', function()
    return Housing.currentlyInsideBuilding
end)

local inGame = exports['players']:GetClientVar("inGame") 
local isDead = exports['players']:GetClientVar("isDead") 
AddEventHandler("players:ClientVarChanged", function(name, old, new)
    if name == 'inGame' then
        inGame = new
    elseif name == 'isDead' then
        isDead = new
    end
end)

function Housing.func.calculatePropertyPrice(propertyId,zone)
    local basePrice = Housing.zoningPrices[zone].baseSellPrice
    local housingType = Housing.info[propertyId].model

    local percent = Housing.typeInfo[housingType].percentage

    if Housing.zoningPrices[zone][housingType] ~= nil then
        percent = percent + Housing.zoningPrices[zone][housingType]
    end
    
    return basePrice + ((basePrice*percent)/100)
end

function Housing.func.findClosestProperty()
    local playerCoords = GetEntityCoords(PlayerPedId())
    
    local zone = GetZoneAtCoords(playerCoords)
    local zoneName = GetNameOfZone(playerCoords)

    if Housing.zone[zoneName] == nil then return "No zone found",nil end

    local closest = nil
    local closestDist = 9999

    for k,v in pairs(Housing.zone[zoneName].locations) do
        local distance = #(playerCoords - v)
        if distance <= closestDist then
            closestDist = distance
            closest = k
        end
    end
    return closest,closestDist,zoneName
end

function Housing.func.enterBuilding(propertyID, info)
    if not Housing.info[propertyID].enabled then return end

    Housing.propertyId = propertyID
    DoScreenFadeOut(1)
    
    exports['jp-weather']:toggle(false)

    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist('CLEAR')
    SetWeatherTypeNow('CLEAR')
    SetWeatherTypeNowPersist('CLEAR')
    NetworkOverrideClockTime(21, 0, 0)

    local IS_ROBBING = info == 'robbery'
    local IS_PLAYER = info == 'player'

    local spawnBuildingLocation = vector3(Housing.info[propertyID][1].x,Housing.info[propertyID][1].y,Housing.info[propertyID][1].z-60.0)
    local model = Housing.info[propertyID].model
    local entry = vector3(Housing.info[propertyID][1].x,Housing.info[propertyID][1].y,Housing.info[propertyID][1].z)

    local isBuiltCoords = exports["jp-build"]:buildRoom(model, spawnBuildingLocation, false, false, entry)

    if isBuiltCoords then
        DoScreenFadeIn(1000)

        SetEntityInvincible(PlayerPedId(), false)
        FreezeEntityPosition(PlayerPedId(),false)

        Housing.currentlyInsideBuilding = true

        Housing.isRobbingHouse = IS_ROBBING
        Housing.isPlayerHouse = IS_PLAYER
        
        if Housing.isRobbingHouse then
            Housing.robLocations = RPC.execute('jp-housing:getRobLocations', propertyID)
            buildRobLocations(propertyID)    
        end
    else
        Housing.currentlyInsideBuilding = false

        Housing.isRobbingHouse = false
        Housing.isPlayerHouse = false
    end
end

RegisterNetEvent("jp-housing:updateRobLocations", function(propertyId, locations)
    if Housing.currentlyInsideBuilding and Housing.propertyId == propertyId and Housing.isRobbingHouse then
        Housing.robLocations = locations
        buildRobLocations(propertyId)
    end
end)

function Housing.func.leaveBuilding()
    if Housing.currentlyInsideBuilding then
        DoScreenFadeOut(1)
        exports['jp-weather']:toggle(true)
        exports['jp-weather']:forceUpdate()

        Housing.justLeftBuilding = true
        exports['jp-build']:exitBuilding()
        DoScreenFadeIn(1000)
        
        Housing.currentlyInsideBuilding = false
        Housing.isRobbingHouse = false
        Housing.isPlayerHouse = false
        Housing.robLocations = nil

        CreateThread(function()
            Wait(500)
            Housing.justLeftBuilding = false
        end)
    end
end

AddEventHandler("jp-housing:leave", Housing.func.leaveBuilding)

AddEventHandler("jp-housing:swapCharacter", function()
    if Housing.currentlyInsideBuilding and Housing.isPlayerHouse then
        Housing.func.leaveBuilding()
        exports['login-menu']:openMenu()
    else
        TriggerEvent("DoLongHudText", "Sa ei saa seda praegu teha!", 'red')
    end
end)

AddEventHandler("jp-housing:stash", function()
    if Housing.currentlyInsideBuilding and Housing.isPlayerHouse then
        houseStash = {
            invType = "housestash",
            invId = Housing.propertyId
        }
        exports['inventory']:openInventory(houseStash)
    else
        TriggerEvent("DoLongHudText", "Sa ei saa seda praegu teha!", 'red')
    end
end)

RegisterNetEvent("updateLockdown")
AddEventHandler("updateLockdown", function(currentLockdown)
    Housing.currentLockdown = currentLockdown

    if Housing.currentlyInsideBuilding and Housing.isPlayerHouse then
        if Housing.currentLockdown[Housing.propertyId] and not isOwnedHouse(Housing.propertyId) then
            Housing.func.leaveBuilding()
            TriggerEvent("DoLongHudText", "Sind visati majast välja!", 'red', 5000)
        end
    end
end)

local houseBlips = {}

function CreateBlip(coords, text, sprite, color, scale)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, scale)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)

    table.insert(houseBlips, blip)
end

function gatherPlayerInfo()
    Housing.currentOwned = RPC.execute("housing:getCurrentOwned")

    Housing.currentLockdown = RPC.execute("housing:getCurrentLockdown")
    Housing.currentBeingRobbed = RPC.execute("housing:getCurrentBeingRobbed")
    
    for i,v in pairs (houseBlips) do RemoveBlip(v) end
    if not Housing.currentOwned or type(Housing.currentOwned) ~= "table" then return end
    for i,v in pairs (Housing.currentOwned) do
        print ("1: "..json.encode(v).. " | "..json.encode(v.property_id))
        print (json.encode(Housing.info).." | "..json.encode(Housing.info[v.property_id]))
        local info = v and v.property_id and Housing.info[v.property_id]
        if info then
            CreateBlip(info[1], ("Omatud Kinnisvara | %s"):format(info.Street), 40, 33, 0.7)
        end
    end
end

RegisterNetEvent("currentBeingRobbed")
AddEventHandler("currentBeingRobbed", function(currentBeingRobbed)
    Housing.currentBeingRobbed = currentBeingRobbed

    if Housing.currentlyInsideBuilding and Housing.isRobbingHouse then
        if not Housing.currentBeingRobbed[Housing.propertyId] then
            Housing.func.leaveBuilding()
            TriggerEvent("DoLongHudText", "Sind visati majast välja!", 'red', 5000)
        end
    end
end)

RegisterNetEvent("jp-housing:forceUpdate")
AddEventHandler("jp-housing:forceUpdate", gatherPlayerInfo)

RegisterCommand("house", function()
    local closest,closestDist,zoneName = Housing.func.findClosestProperty()
    print (closest,closestDist,zoneName)
end)

local function isOwnProperty(propertyId)
    for i,v in pairs (Housing.currentOwned) do
        if v.property_id == propertyId then
            return true
        end
    end    
end

CreateThread(function()
    local isShowing = false
    local lastStr = ''

    local waitTime = 500
    local lastClosest = nil

    while true do
        if inGame and not isDead and not Housing.currentlyInsideBuilding and not Housing.justLeftBuilding then
            local closest,closestDist,zoneName = Housing.func.findClosestProperty()

            local found = false
            if closest and closestDist and zoneName then
                if closestDist < 1.5 then
                    found = true
                    local locked = Housing.currentLockdown[closest] == nil or Housing.currentLockdown[closest] == true
                    local isBeingRobbed = Housing.currentBeingRobbed[closest] ~= nil and Housing.currentBeingRobbed[closest] == true 
                    
                    local isOwnedHouse = isOwnProperty(closest)

                    if IsControlJustPressed(0, 47) then
                        if not locked or isOwnedHouse or isBeingRobbed then
                            exports['interaction']:hide()
                            isShowing = false

                            if isBeingRobbed then
                                Housing.func.enterBuilding(closest, 'robbery')
                            elseif isOwnedHouse then
                                Housing.func.enterBuilding(closest, 'player')
                            elseif not locked then
                                Housing.func.enterBuilding(closest, 'player')
                            end
                        end
                    else --! STOP THERE IF ENTERED
                        if isOwnedHouse and IsControlJustPressed(0, 74) then
                            local locked = RPC.execute("housing:toggleLock", closest)
    
                            local toggleLockText = locked and "Unlock" or "Lock"
                            if not locked then
                                exports['interaction']:show("[G] Mine Sisse / [H] Lukusta Korter")
                            else
                                exports['interaction']:show("[G] Mine Sisse / [H] Tee Lukust Lahti", 'red')
                            end
                        end
    
                        if isOwnedHouse then
                            local str = ''
                            local color = ''
                            if not isBeingRobbed then
                                if not locked then
                                    str = ("[G] Mine Sisse / [H] Lukusta Korter")
                                else
                                    str = ("[G] Mine Sisse / [H] Tee Lukust Lahti")
                                    color = 'red'
                                end
                            else
                                str = ("[G] Mine Sisse")
                            end

                            if not isShowing or (isShowing and lastStr ~= str) then
                                exports['interaction']:show(str, color)
                                lastStr = str

                                isShowing = true
                                waitTime = 1
                            end
                        else
                            if locked and not isBeingRobbed then
                                exports['interaction']:show("Lukustatud", 'red')
                                isShowing = true
                            else
                                exports['interaction']:show("[G] Mine Sisse")
                                isShowing = true
                                waitTime = 1
                            end
                        end    
                    end

                end
            end
            if (not found and isShowing) then
                exports['interaction']:hide()
                isShowing = false
                waitTime = 500
            end
        else
            if isShowing then
                exports['interaction']:hide()
                waitTime = 500
            end
        end
        Wait(waitTime)
    end
end)

RegisterCommand("lockpick", function()
    local closest,closestDist,zoneName = Housing.func.findClosestProperty()

    if closest and closestDist and zoneName then
        local beingRobbed = RPC.execute('housing:lockpickProperty', closest)
        if beingRobbed then
        end
    end
end)