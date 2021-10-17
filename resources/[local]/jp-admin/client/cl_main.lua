local enabled = false

function showUi(admin_level)
    enabled = true
    SetNuiFocus(true, true)

    SendNUIMessage({
        show = true,
        admin_level = admin_level
    })
end

function hideUi()
    enabled = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        show = false
    })
end

RegisterCommand('adminn', function()
    if enabled then
        hideUi() 
    else
        local admin_level = RPC.execute("getLevel")
        if admin_level then
            showUi(admin_level) 
        end
    end
end)

RegisterCommand('+adminMenu', function()
    local admin_level = RPC.execute("getLevel")
    if admin_level then
        showUi(admin_level) 
    end
end, false)
RegisterCommand('-adminMenu', function()
end)
exports['jp-keybinds']:registerKeyMapping("adminMenu", "ӿAdmin", "Ava Admin Menu", "+adminMenu", "-adminMenu", "")

RegisterNUICallback('nuiAction', function(data, cb)
    local content = data.data
    local action = data.action

    print ("NuiAction | "..json.encode(data))
    if (action == 'closeNui') then
        hideUi()
    elseif (action == 'fetchPlayersList') then
        local list = RPC.execute("fetchPlayersList")
        cb(list)     
    elseif (action == 'selectCharacterFromCID') then
        local data = RPC.execute("selectCharacterFromCID", content.cid)
        cb(data)
    elseif (action == 'openInventory') then
        TriggerEvent("admin:openInventory", {invType = "player", invId = content.selectedPlayer.citizen_id})
    elseif (action == 'giveItem') then
        local success = RPC.execute("giveItem", content.amount, content.itemId, content.selectedPlayer.source)
        cb(success)
    elseif (action == 'revivePlayer') then
        TriggerServerEvent("death:reviveSomeone", content.selectedPlayer.source)
    elseif (action == 'openClothes') then
        local success = RPC.execute("openClothes", content.selectedPlayer.source)
        cb(success)
    elseif (action == 'openBarber') then
        local success = RPC.execute("openBarber", content.selectedPlayer.source)
        cb(success)
    elseif (action == 'maxHungerAndThirst') then
        local success = RPC.execute("maxHungerAndThirst", content.selectedPlayer.source)
        cb(success)
    elseif (action == 'giveVehicle') then
        content.model = content.model:lower()
        local vehicleName = GetDisplayNameFromVehicleModel(content.model)
    
        if (vehicleName == 'CARNOTFOUND') then
            TriggerEvent("DoLongHudText", "Model is incorrect?", "red")
            return false
        end
    
        local success = RPC.execute("giveVehicle", content.selectedPlayer, content.model, content.plate)

        cb(success)
    elseif (action == 'banPlayer') then
        content.hours = content.hours and tonumber(content.hours) or 0
        content.days = content.days and tonumber(content.days) or 0
        content.minutes = content.minutes and tonumber(content.minutes) or 0
        content.reason = content.reason or ''
        content.secret_reason = content.secret_reason or ''

        local time = 0

        time = (time + content.days * 86400)
        time = (time + content.hours * 3600)
        time = (time + content.minutes * 60)

        local success = RPC.execute("banPlayer", content.selectedPlayer, time, content.reason, content.secret_reason)

        cb(success)
    elseif (action == 'kickPlayer') then
        content.reason = content.reason or ''

        local success = RPC.execute("kickPlayer", content.selectedPlayer, content.reason)
        cb(success)
    elseif (action == 'unjailPlayer') then
        local success = RPC.execute("unjailPlayer", content.selectedPlayer)
        cb(success)
    elseif (action == 'giveLicense') then
        print "1"
        local success = RPC.execute("giveLicense", content.selectedPlayer, content.license)
        print "2"
        cb(success)
    elseif (action == 'teleportToPlayer') then
        local success = RPC.execute("teleportToPlayer", content.selectedPlayer.source)
        cb(success)
    elseif (action == 'bringPlayer') then
        local success = RPC.execute("bringPlayer", content.selectedPlayer.source)
        cb(success)

    --// * VEHICLE STUFF
    elseif (action == 'spawnVehicle') then
        local networkId, entity = RPC.execute("spawnVehicle", content.model)

        while not NetworkDoesEntityExistWithNetworkId(networkId) do Wait(0) end
        local entity = NetworkGetEntityFromNetworkId(networkId)
        while not DoesEntityExist(entity) do Wait(0) end

        SetPedIntoVehicle(PlayerPedId(), entity, -1)
        SetVehicleEngineOn(entity, true, true, false)
        exports['keys']:addKeys(entity)

        cb(true)
    elseif (action == 'giveKeys') then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if (DoesEntityExist(vehicle)) then
            exports['keys']:addKeys(vehicle)
        end
    elseif (action == 'fixVehicle') then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if (DoesEntityExist(vehicle)) then
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleUndriveable(vehicle, false)
        end
    elseif (action == 'deleteVehicle') then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if (DoesEntityExist(vehicle)) then
            Sync.DeleteVehicle(vehicle)
        end
    end
end)