closestGarage = {
    ['name'] = "none",
    ['distance'] = math.huge,
}

local playerPed = PlayerPedId()
local playerPos = GetEntityCoords(playerPed)
local isPedInAnyVehicle = IsPedInAnyVehicle(playerPed)
local vehiclePlayerIsIn = GetVehiclePedIsIn(playerPed, false)

CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        playerPos = GetEntityCoords(playerPed)
        isPedInAnyVehicle = IsPedInAnyVehicle(playerPed, false)
        if isPedInAnyVehicle then vehiclePlayerIsIn = GetVehiclePedIsIn(playerPed, false) end

        local closest = math.huge
        local garName = "none"
        for name, data in pairs(garages) do
            local distance = #(playerPos - data.BlipCoords)

            if closest > distance then
                closest = distance
                garName = name
            end
        end

        closestGarage.name = garName
        closestGarage.distance = closest
        Wait(100)
    end
end)

local lastDestroyedVehicle = nil

CreateThread(function()
    while true do
        if isPedInAnyVehicle then
            local meta = getVehicleMeta(vehiclePlayerIsIn)
            if meta then -- TRACK OTHER PLAYER VEHICLES 
                local stats = getVehicleStats(vehiclePlayerIsIn)
                if stats then
                    stats = json.encode(stats)
                    TriggerServerEvent("garages:updateVehicleStats", meta, stats)
                    Wait(1000)
                end

                if lastDestroyedVehicle ~= vehiclePlayerIsIn then
                    local engineDestroyed = GetVehicleEngineHealth(vehiclePlayerIsIn) < -200.0
                    local isSubmerged = GetEntitySubmergedLevel(vehiclePlayerIsIn) == 1.0

                    if engineDestroyed or isSubmerged then
                        lastDestroyedVehicle = vehiclePlayerIsIn
                        SetVehicleUndriveable(vehiclePlayerIsIn)
                        SetVehicleEngineHealth(vehiclePlayerIsIn, 0)
                        SetVehicleBodyHealth(vehiclePlayerIsIn, 0)
                        TriggerServerEvent("garages:vehicleDestroyed", meta)
                    end
                end
            else
                if lastDestroyedVehicle ~= vehiclePlayerIsIn then
                    local engineDestroyed = GetVehicleEngineHealth(vehiclePlayerIsIn) < -200.0
                    local isSubmerged = GetEntitySubmergedLevel(vehiclePlayerIsIn) == 1.0
                    if engineDestroyed or isSubmerged then
                        lastDestroyedVehicle = vehiclePlayerIsIn
                        SetVehicleEngineHealth(vehiclePlayerIsIn, 0)
                        SetVehicleBodyHealth(vehiclePlayerIsIn, 0)
                        SetVehicleUndriveable(vehiclePlayerIsIn)
                    end
                end
            end
        end
        Wait(100)
    end
end)

function makeVehicleMenuList(vehicles)
    local MenuData = {}

    for i,v in pairs (vehicles) do
        local vehicleName = GetDisplayNameFromVehicleModel(v.model)
        local localizedName = GetLabelText(vehicleName)
        local tit = "Võta sõiduk välja"

        local status = v.inGarage == 2 and "Garaažis" or v.inGarage == 1 and "Väljas" or v.inGarage == 3 and "Arestitud" or v.inGarage == 4 and "Hävitatud" or "Unknown"
        
        if v.inGarage == 4 then
            tit = ("Võta Sõiduk välja ($%s)"):format(1000)
        elseif v.inGarage == 3 then
            tit = ("Seda sõidukit ei saa välja võtta. (Arestitud)")
        elseif (v.inGarage == 1) then
            tit = ("Pane marker sõidukile. (Väljas)")
        end

        local unimpoundButton

        if v.faction ~= 0 and v.inGarage == 3 then
            unimpoundButton = {
                title = "Osta Impoundist Välja ($750)",
                params = json.encode(v),
                event = "jp-factions:retrieveFromImpound"
            }
        end

        local stats = json.decode(v.stats)
        
        local engine, body = 0, 0
        engine = math.floor(stats.engineHealth/10 + 0.5) or 100
        body = math.floor(stats.bodyHealth/10 + 0.5) or 100
        
        local children = {
            {
                title = "Sõiduki Staatus",
                desc = ("%s | Mootor: %s%% | Kere: %s%%"):format(status, engine, body)
            },
            {
                title = tit,
                event = "garages:cl_spawnVehicle",
                params = json.encode(v)
            },
        }
        
        if unimpoundButton then table.insert(children, 2, unimpoundButton) end

        MenuData[#MenuData+1] = {
            title = localizedName,
            desc = ("Numbrimärk: %s"):format(v.plate),
            children = children
        }
    end

    if (#MenuData) == 0 then
        MenuData = {
            {
                title = "Sul pole ühtegi sõidukit!"
            }
        } 
    end

    return MenuData
end

exports('makeVehicleMenuList', makeVehicleMenuList)

function storeVehicle(vehicle)
    local vehicleMeta = getVehicleMeta(vehicle)
    if vehicleMeta then
        local character = exports['players']:GetClientVar("character")
        local stats = getVehicleStats(vehicle)

        if vehicleMeta.faction_id then
            vehicleMeta.plate = GetVehicleNumberPlateText(vehicle) --* ADD FOR LOGGING

            local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            local localizedName = GetLabelText(vehicleName)
            vehicleMeta.model = localizedName

            local success = RPC.execute('factions:storedVehicle', vehicleMeta, json.encode(stats)) 
            if not success then return end
        end

        TriggerServerEvent("garages:despawnVehicle", vehicleMeta.vin, json.encode(stats), NetworkGetNetworkIdFromEntity(vehiclePlayerIsIn))
        TriggerEvent("DoLongHudText", "Panid sõiduki garaaži.", "green")
    else --//NOT PLAYER VEHICLE
        TriggerEvent("DoLongHudText", "Seda sõidukit ei saa siin hoiustada!", "red")
    end
end

exports('storeVehicle', storeVehicle)

CreateThread(function()
    while true do
        if closestGarage.distance < 3 and not isDead then
            if not isPedInAnyVehicle then
                BeginTextCommandDisplayHelp("STRING")
                AddTextComponentSubstringPlayerName("Vajuta ~INPUT_CONTEXT~ et avada oma garaaž.")
                EndTextCommandDisplayHelp(0, 0, 1, -1)
            else
                BeginTextCommandDisplayHelp("STRING")
                AddTextComponentSubstringPlayerName("Vajuta ~INPUT_CONTEXT~ et panna sõiduk garaaži.")
                EndTextCommandDisplayHelp(0, 0, 1, -1)
            end

            if IsControlJustPressed(1, 51) then
                playerPed = PlayerPedId()
                if GetEntitySpeed(PlayerPedId()) > 5.0 then
                    TriggerEvent("DoLongHudText", "Aeglasemalt!", "red")
                else
                    if not isPedInAnyVehicle then -- OPEN VEHICLE MENU
                        local vehicles = RPC.execute('jp-garages:getPersonalVehicles')
                        local MenuData = makeVehicleMenuList(vehicles)

                        exports['jp-menu']:showContextMenu(MenuData, "Garaaž")
                    elseif isPedInAnyVehicle then
                        local vehicleMeta = getVehicleMeta(vehiclePlayerIsIn)
                        local char = exports['players']:GetClientVar("character")
                        if vehicleMeta and vehicleMeta.cid == char.cid then
                            storeVehicle(vehiclePlayerIsIn)
                        else --//NOT PLAYER VEHICLE
                            TriggerEvent("DoLongHudText", "Seda sõidukit ei saa siin hoiustada!", "red")
                        end
                    end
                end
            end
        end
        Wait(0)
    end
end)

CreateThread(function()
    local copy = {['Impound Lot'] = Impound}
    for i,v in pairs (garages) do
        copy[i] = v
    end -- WEIRD THING TO SHOW IMPOUND LOT ON MAP

    for name, item in pairs(copy) do
        item.BlipId = item.BlipId or 357
        item.Colour = item.Colour or 3
        item.Scale = item.Scale or 0.7

        item.blip = AddBlipForCoord(item.BlipCoords)
        SetBlipSprite(item.blip, item.BlipId)
        SetBlipColour(item.blip, item.Colour)
        SetBlipScale(item.blip, item.Scale)
        SetBlipAsShortRange(item.blip, true)

        if item.DisplayName then
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(item.DisplayName)
            EndTextCommandSetBlipName(item.blip)
        end
    end
end)    