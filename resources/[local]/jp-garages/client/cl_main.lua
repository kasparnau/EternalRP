garages = {
    ['Pillbox Garage'] = {
        BlipCoords = vector3(211.79,-808.38,30.833),
        SpawnLocation = {vector3(235.70109558105,-785.47253417969,30.610961914062), 150.23622131348},
    },
}

Impound = {
    BlipCoords = vector3(375.50769042969,-1615.6878662109,29.279907226562),
    SpawnLocation = {vector3(394.8395690918,-1626.0263671875,28.824951171875), 48.188972473145},
    BlipId = 67,
    DisplayName = "Impound Lot",
    Scale = 0.8,
    Colour = 5
}

function getVehicleMeta(entity)
    local ent = Entity(entity)
    if ent.state.cid and ent.state.vin then
        local fac = ent.state.faction_id or nil
        return {vin = ent.state.vin, cid = ent.state.cid, faction_id = fac}
    end
    return false
end

exports("getVehicleMeta", getVehicleMeta)

function getVehicleStats(entity)
    local stats = {}
    stats.engineHealth = GetVehicleEngineHealth(entity)
    stats.bodyHealth = GetVehicleBodyHealth(entity)
    stats.fuel = math.floor(exports['fuel']:GetFuel(entity) + 0.5)
    return stats
end

--////

function doCarDamages(engine, body, veh)
	if engine < 200.0 then
		engine = 200.0
	end

	if body < 150.0 then
		body = 150.0
	end

    SetVehicleEngineHealth(veh, engine)
    SetVehicleBodyHealth(veh, body)

	if body < 950.0 then
		SmashVehicleWindow(veh, 0)
		SmashVehicleWindow(veh, 1)
		SmashVehicleWindow(veh, 2)
		SmashVehicleWindow(veh, 3)
		SmashVehicleWindow(veh, 4)
	end

    if body < 920.0 then
        SetVehicleDoorBroken(veh, 1, true)
		SetVehicleDoorBroken(veh, 6, true)
		SetVehicleDoorBroken(veh, 4, true)
	end
end

function takeVehicleOut(vehicle, garage)
    TriggerEvent("DoLongHudText", "Palun oota natuke.", "green")

    local networkId, data = RPC.execute('jp-garages:takeVehicleOut', vehicle.vin, garage)

    if networkId and data then
        while not NetworkDoesEntityExistWithNetworkId(networkId) do Wait(0) end
        local entity = NetworkGetEntityFromNetworkId(networkId)
        while not DoesEntityExist(entity) do Wait(0) end

        exports['jp-flags']:SetVehicleFlag(entity, "isPlayerVehicle", true)

        local mods = json.decode(data.mods)
        exports['tuner']:setTunes(entity, mods)

        SetVehicleNumberPlateText(entity, data.plate)
        SetVehRadioStation(entity, "OFF")

        local stats = json.decode(data.stats) or {}
        if not stats.fuel or not stats.engineHealth or not stats.bodyHealth then
            stats = {fuel=100.0,engineHealth=1000.0,bodyHealth=1000.0}
        end

        exports['fuel']:SetFuel(entity, stats.fuel)
        doCarDamages(stats.engineHealth, stats.bodyHealth, entity)

        SetPedIntoVehicle(PlayerPedId(), entity, -1)
        SetVehicleEngineOn(entity, true, true, false)
        exports['keys']:addKeys(entity)
    end
end

RegisterCommand("mods", function(source)
    local entity = GetVehiclePedIsIn(PlayerPedId(), false)
    local mods = json.encode(exports['tuner']:getTunes(entity))
    print (mods)
    TriggerServerEvent("serverprint", mods)
end)