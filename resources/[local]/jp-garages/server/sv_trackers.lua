VehiclesOutside = {}
VehicleStats = {}

RegisterNetEvent("garages:updateVehicleStats")
AddEventHandler("garages:updateVehicleStats", function(vehicleMeta, vehicleStats)
    local playerData = exports['players']:getPlayerDataFromSource(source)
    local character = exports['players']:getCharacter(source)

    VehicleStats[vehicleMeta.vin] = VehicleStats[vehicleMeta.vin] or {iteration = 0, stats = {}}
    VehicleStats[vehicleMeta.vin].stats = stats
    VehicleStats[vehicleMeta.vin].iteration = VehicleStats[vehicleMeta.vin].iteration + 1

    if (VehicleStats[vehicleMeta.vin].iteration % 15 == 0) then
        --print ('[GARAGE] [LOG] PID: '..playerData.pid.." License: "..playerData.license.." | Updated vehicle stats. VIN: "..vehicleMeta.vin)
        sql:executeSync([[
            UPDATE vehicles 
            SET stats = ?
            WHERE vin = ?
        ]], {vehicleStats, vehicleMeta.vin})
    end
end)

RegisterNetEvent("garages:vehicleDestroyed")
AddEventHandler("garages:vehicleDestroyed", function(vehicleMeta)
    local playerData = exports['players']:getPlayerDataFromSource(source)
    local character = exports['players']:getCharacter(source)

    print('[GARAGES] [VEHICLE DESTROYED] CID: '..character.cid.." | License: "..playerData.license.." | VIN: "..vehicleMeta.vin.." | VEH_OWNER_CID: "..vehicleMeta.cid)
    
    if not (VehiclesOutside[vehicleMeta.vin]) then return end

    if VehiclesOutside[vehicleMeta.vin] ~= nil then
        VehiclesOutside[vehicleMeta.vin] = nil
    end

    if VehicleStats[vehicleMeta.vin] ~= nil then
        VehicleStats[vehicleMeta.vin] = nil
    end

    sql:executeSync([[
        UPDATE vehicles
        SET inGarage=4
        WHERE vin=?
    ]], {vehicleMeta.vin})
end)

