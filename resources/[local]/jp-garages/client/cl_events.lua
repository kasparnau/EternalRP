Game = exports['modules']:getModule("Game")

AddEventHandler("garages:cl_spawnVehicle", function(pArgs) -- * MENU BUTTON TO SPAWN
    local v = json.decode(pArgs)
    
    local currentGarage = garages[closestGarage.name]

    local spawn = currentGarage.SpawnLocation
    if (v.faction ~= 0) then
        local garage = json.decode(exports['players']:GetClientVar("character").faction.group.garage)
        spawn = {
            vector3(garage[1], garage[2], garage[3]),
            garage[4]
        }

        local vehicleName = GetDisplayNameFromVehicleModel(v.model)
        local localizedName = GetLabelText(vehicleName)
        v.displayName = localizedName

        local success = RPC.execute('factions:tookOutVehicle', v) 
        if not success then return end
    end

    local spawnPointClear = Game.IsSpawnPointClear(spawn[1], 3.0)

    --! 1 = outside, 2 = in garage, 3 = impounded, 4 = destroyed
    if spawnPointClear and v.inGarage == 2 or spawnPointClear and v.inGarage == 4 then
        takeVehicleOut(v, spawn)
    elseif v.inGarage ~= 2 and spawnPointClear then
        if v.inGarage == 1 and v.networkId then
            local coords = RPC.execute('garages:getCoords', v.vin)
            
            if coords then
                SetNewWaypoint(coords.x, coords.y)
                TriggerEvent("DoLongHudText", "Panid markeri sõidukile!", "green")
            end
        else
            TriggerEvent("DoLongHudText", "Seda sõidukit ei saa välja võtta! See on arestitud. (Mine osta impoundist välja)", "red")
        end
    elseif not spawnPointClear then
        TriggerEvent("DoLongHudText", "Seda sõidukit ei saa välja võtta! Midagi on ees.", "red")
    end
end)

AddEventHandler("garages:cl_unimpoundVehicle", function(pParams)
    local cash = exports['inventory']:amountOfItem("cash")
    local currentGarage = Impound

    local spawnPointClear = Game.IsSpawnPointClear(currentGarage.SpawnLocation[1], 3)
    if not spawnPointClear then
        TriggerEvent("DoLongHudText", "Seda sõidukit ei saa välja võtta! Midagi on ees.", "red")
        return
    end

    local cost = 500
    if cash >= cost then
        if exports['inventory']:removeItem('cash', cost) then
            takeVehicleOut(json.decode(pParams), currentGarage.SpawnLocation)
        end
    else
        TriggerEvent("DoLongHudText", "Sul pole piisavalt raha selle jaoks.", "red")
    end
end)

AddEventHandler("jp-garages:browseImpound", function(pEntity, pContext, pParams)
    local vehicles = RPC.execute('jp-garages:getPersonalVehicles') or {}
    local MenuData = {}

    for i,v in pairs (vehicles) do
        if v.inGarage == 3 then
            local vehicleName = GetDisplayNameFromVehicleModel(v.model)
            local localizedName = GetLabelText(vehicleName)

            local status = v.inGarage == 2 and "Garaažis" or v.inGarage == 1 and "Väljas" or v.inGarage == 3 and "Arestitud" or v.inGarage == 4 and "Hävitatud" or "Unknown??"

            local stats = json.decode(v.stats)

            local engine, body = 0, 0
            engine = math.floor(stats.engineHealth/10 + 0.5) or 100
            body = math.floor(stats.bodyHealth/10 + 0.5) or 100

            MenuData[#MenuData+1] = {
                title = localizedName,
                desc = ("Plate: %s"):format(v.plate),
                children = {
                    {
                        title = "Vehicle Status",
                        desc = ("%s | Engine: %s%% | Body: %s%%"):format(status, engine, body)
                    },
                    {
                        title = ("Take Out Vehicle ($%s)"):format(500),
                        event = "garages:cl_unimpoundVehicle",
                        params = json.encode(v)
                    },
                }
            }
        end
    end

    if (#MenuData) == 0 then
        MenuData = {
            {
                title = "Teil pole yhtegi arestitud sõidukit"
            }
        } 
    end

    exports['jp-menu']:showContextMenu(MenuData, "Arestitud sõidukid")
end)