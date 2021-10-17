function SpawnVehiclePersistent(hash, coords, heading)
    local entity = Citizen.InvokeNative(`CREATE_AUTOMOBILE`, hash, coords, heading)
            
    Wait(10)

    if not DoesEntityExist(entity) then
        return false
    end

    local networkId = NetworkGetNetworkIdFromEntity(entity)
    return networkId, entity
end