function addKeys(vehicle)
    assert(vehicle ~= nil, 'missing vehicle')

    Entity(vehicle).state.keys = true
end

function removeKeys(vehicle)
    assert(vehicle ~= nil, 'missing vehicle')

    Entity(vehicle).state.keys = nil
end

function hasKeys(vehicle)
    assert(vehicle ~= nil, 'missing vehicle')

    return Entity(vehicle).state.keys == true
end

exports('addKeys', addKeys)
exports('removeKeys', removeKeys)
exports('hasKeys', hasKeys)

RegisterCommand('addKeys', function()
    addKeys(GetVehiclePedIsIn(PlayerPedId(), false))
end)

RegisterCommand('removeKeys', function()
    removeKeys(GetVehiclePedIsIn(PlayerPedId(), false))
end)

RegisterCommand('hasKeys', function()
    print(tostring(hasKeys(GetVehiclePedIsIn(PlayerPedId(), false))))
end)

AddEventHandler("vehicles:giveVehicleKeys", function()
    if not IsPedInAnyVehicle(PlayerPedId()) then
        exports['alerts']:notify('Sõidukid', "Te pole sõidukis.", 'errorAlert')
    else
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if hasKeys(vehicle) then
            local closestPlayer, closestPlayerDistance = exports['modules']:getModule("Game").GetClosestPlayer()
            local targetPed = GetPlayerPed(closestPlayer)

            if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
                removeKeys(vehicle)
                RPC.execute("transferKeys", GetPlayerServerId(closestPlayer), NetworkGetNetworkIdFromEntity(vehicle))
            end
        else
            exports['alerts']:notify('Sõidukid', "Teil pole selle sõiduki võtmeid.", 'errorAlert')
        end
    end
end)

RegisterNetEvent("vehicles:transferKeysTo")
AddEventHandler("vehicles:transferKeysTo", function(netId)
    addKeys(NetworkGetEntityFromNetworkId(netId))
end)