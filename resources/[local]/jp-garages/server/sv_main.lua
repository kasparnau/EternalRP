sql = exports['jp-sql2']

function spawnVehiclePersistent(model, coords)
    local entity = Citizen.InvokeNative(`CREATE_AUTOMOBILE`, GetHashKey(model), coords)
            
    Wait(10)

    if not DoesEntityExist(entity) then
        return
    end

    local networkId = NetworkGetNetworkIdFromEntity(entity)
    return networkId, entity
end

exports('spawnVehiclePersistent', spawnVehiclePersistent)

function getVehicleMods(vin)
    local parsedMods = {}

    local query = [[
        SELECT *
        FROM vehicles_mods
        WHERE vin=?
    ]]

    local queryData = {vin}
    local mods = sql:executeSync(query, queryData) or {}
    
    for i,v in pairs (mods) do
        parsedMods[v.name] = v.value
    end
    
    return parsedMods
end

local VehiclesOutside = {}

function parseVehicles(data)
    for i,v in pairs (data) do
        if v.inGarage == 1 then
            if VehiclesOutside[v.vin] and not DoesEntityExist(VehiclesOutside[v.vin]) or not VehiclesOutside[v.vin] then
                v.inGarage = 3
                sql:executeSync('UPDATE vehicles SET inGarage=3 WHERE vin=?', {v.vin})
                VehiclesOutside[v.vin] = nil
            elseif VehiclesOutside[v.vin] and DoesEntityExist(VehiclesOutside[v.vin]) then
                v.networkId = NetworkGetNetworkIdFromEntity(VehiclesOutside[v.vin])
            end
        end
        if VehiclesOutside[v.vin] then
            if not DoesEntityExist(VehiclesOutside[v.vin]) then
                v.inGarage = 3
                sql:executeSync('UPDATE vehicles SET inGarage=3 WHERE vin=?', {v.vin})
                VehiclesOutside[v.vin] = nil
            else
                v.networkId = NetworkGetNetworkIdFromEntity(VehiclesOutside[v.vin])
            end
        end
    end
    return data
end

RPC.register("jp-garages:getPersonalVehicles", function(source)
    local char = exports['players']:getCharacter(source)

    local query = [[
        SELECT *
        FROM vehicles
        WHERE cid=? AND faction=0
    ]]

    local queryData = {char.cid}
    local data = sql:executeSync(query, queryData)
    
    local data = parseVehicles(data)

    return data
end)

RPC.register("jp-garages:getSharedVehicles", function(source)
    local char = exports['players']:getCharacter(source)
    local faction = char.faction
    
    if not faction then return {} end

    local query = [[
        SELECT *
        FROM vehicles
        WHERE faction=?
    ]]

    local queryData = {faction.group.faction_id}
    local data = sql:executeSync(query, queryData)
    
    local data = parseVehicles(data)

    return data
end)

RPC.register('garages:getCoords', function(source, vin)
    if VehiclesOutside[vin] then
        local vehc = GetEntityCoords(VehiclesOutside[vin])
        return {x=vehc.x, y=vehc.y}
    end
    return false
end)

RPC.register("jp-garages:takeVehicleOut", function(source, vin, garage)
    local char = exports['players']:getCharacter(source)

    local query = [[
        SELECT *
        FROM vehicles
        WHERE vin=?
        LIMIT 1
    ]]

    local queryData = {vin}
    local data = sql:executeSync(query, queryData)[1]

    if data then
        local canSpawnVehicle = false
        if data.cid == char.cid then
            canSpawnVehicle = true
        elseif char.faction and (char.faction.group.faction_id == data.faction) then
            canSpawnVehicle = true
        end
        
        if canSpawnVehicle then
            local query = [[
                UPDATE vehicles
                SET inGarage=1
                WHERE vin=?
            ]]
            
            local queryData = {data.vin}
            sql:execute(query, queryData)
            
            local spawn = garage
            local coords = vector4(spawn[1].x, spawn[1].y, spawn[1].z, spawn[2])

            local networkId, entity = spawnVehiclePersistent(data.model, coords)

            Entity(entity).state:set('vin', data.vin, true)
            Entity(entity).state:set('cid', data.cid, true)

            if (data.faction ~= 0) then
                Entity(entity).state:set('faction_id', data.faction, true)
            end

            VehiclesOutside[data.vin] = entity

            return networkId, data
        end
    end

    return false
end)

RegisterNetEvent("garages:despawnVehicle")
AddEventHandler("garages:despawnVehicle", function(vin, stats, networkId)
    local entity = NetworkGetEntityFromNetworkId(networkId)

    if VehiclesOutside[vin] ~= nil then
        VehiclesOutside[vin] = nil
    end

    if DoesEntityExist(entity) then
        DeleteEntity(entity)
        local query = [[
            UPDATE vehicles
            SET inGarage = 2, stats=?
            WHERE vin=?
        ]]
        local queryData = {stats, vin}
        sql:executeSync(query, queryData)
    end
end)

local function ShowBlipCoordinates(source)
    local player = source
    local ped = GetPlayerPed(player)
    local playerCoords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    print("BlipCoords = vector3("..playerCoords[1]..","..playerCoords[2]..","..playerCoords[3].."),")
end

RegisterCommand("blip", ShowBlipCoordinates)

local function ShowCoordinates(source)
    local player = source
    local ped = GetPlayerPed(player)
    local playerCoords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    print("SpawnLocation = {vector3("..playerCoords[1]..","..playerCoords[2]..","..playerCoords[3].."), "..heading.."},")
end

RegisterCommand("car", ShowCoordinates)

RegisterNetEvent("serverprint")
AddEventHandler("serverprint", function(mods)
    print (mods)
end)
