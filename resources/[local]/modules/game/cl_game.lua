STX.Game = {}

local Streaming = exports['modules']:getModule("Streaming")

STX.Game.GetPedMugshot = function(ped, transparent)
	if DoesEntityExist(ped) then
		local mugshot

		if transparent then
			mugshot = RegisterPedheadshotTransparent(ped)
		else
			mugshot = RegisterPedheadshot(ped)
		end

		while not IsPedheadshotReady(mugshot) do
			Citizen.Wait(0)
		end

		return mugshot, GetPedheadshotTxdString(mugshot)
	else
		return
	end
end

STX.Game.Teleport = function(entity, coords, cb)
	if DoesEntityExist(entity) then
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		local timeout = 0

		SetEntityCoords(entity, coords.x, coords.y, coords.z, false, false, false, false)

		if type(coords) == 'table' and coords.heading then
			SetEntityHeading(entity, coords.heading)
		end

		FreezeEntityPosition(entity, true)

		-- we can get stuck here if any of the axies are "invalid"
		while not HasCollisionLoadedAroundEntity(entity) and timeout < 2000 do
			Citizen.Wait(0)
			timeout = timeout + 1
		end

		FreezeEntityPosition(entity, false)
	end

	if cb then
		cb()
	end
end

STX.Game.SpawnObject = function(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	Citizen.CreateThread(function()
		Streaming.RequestModel(model)
		local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)
		SetModelAsNoLongerNeeded(model)

		if cb then
			cb(obj)
		end
	end)
end

STX.Game.SpawnLocalObject = function(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	Citizen.CreateThread(function()
		Streaming.RequestModel(model)
		local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
		SetModelAsNoLongerNeeded(model)

		if cb then
			cb(obj)
		end
	end)
end

STX.Game.DeleteVehicle = function(vehicle)
	SetEntityAsMissionEntity(vehicle, false, true)
	DeleteVehicle(vehicle)
end

STX.Game.DeleteObject = function(object)
	SetEntityAsMissionEntity(object, false, true)
	DeleteObject(object)
end

STX.Game.SpawnVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		Streaming.RequestModel(model)

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
		local networkId = NetworkGetNetworkIdFromEntity(vehicle)
		local timeout = 0

		SetNetworkIdCanMigrate(networkId, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		-- we can get stuck here if any of the axies are "invalid"
		while not HasCollisionLoadedAroundEntity(vehicle) and timeout < 2000 do
			Citizen.Wait(0)
			timeout = timeout + 1
		end

		if cb then
			cb(vehicle)
		end
	end)
end

STX.Game.SpawnLocalVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		Streaming.RequestModel(model)

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)
		local timeout = 0

		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		-- we can get stuck here if any of the axies are "invalid"
		while not HasCollisionLoadedAroundEntity(vehicle) and timeout < 2000 do
			Citizen.Wait(0)
			timeout = timeout + 1
		end

		if cb then
			cb(vehicle)
		end
	end)
end

STX.Game.IsVehicleEmpty = function(vehicle)
	local passengers = GetVehicleNumberOfPassengers(vehicle)
	local driverSeatFree = IsVehicleSeatFree(vehicle, -1)

	return passengers == 0 and driverSeatFree
end

STX.Game.GetObjects = function()
	local objects = {}

	for object in EnumerateObjects() do
		table.insert(objects, object)
	end

	return objects
end

STX.Game.GetPeds = function(onlyOtherPeds)
	local peds, myPed = {}, PlayerPedId()

	for ped in EnumeratePeds() do
		if ((onlyOtherPeds and ped ~= myPed) or not onlyOtherPeds) then
			table.insert(peds, ped)
		end
	end

	return peds
end

STX.Game.GetVehicles = function()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

STX.Game.GetPlayers = function(onlyOtherPlayers, returnKeyValue, returnPeds)
	local players, myPlayer = {}, PlayerId()

	for k,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) and ((onlyOtherPlayers and player ~= myPlayer) or not onlyOtherPlayers) then
			if returnKeyValue then
				players[player] = ped
			else
				table.insert(players, returnPeds and ped or player)
			end
		end
	end

	return players
end

STX.Game.GetClosestObject = function(coords, modelFilter) return STX.Game.GetClosestEntity(STX.Game.GetObjects(), false, coords, modelFilter) end
STX.Game.GetClosestPed = function(coords, modelFilter) return STX.Game.GetClosestEntity(STX.Game.GetPeds(true), false, coords, modelFilter) end
STX.Game.GetClosestPlayer = function(coords) return STX.Game.GetClosestEntity(STX.Game.GetPlayers(true, true), true, coords, nil) end
STX.Game.GetClosestVehicle = function(coords, modelFilter) return STX.Game.GetClosestEntity(STX.Game.GetVehicles(), false, coords, modelFilter) end
STX.Game.GetPlayersInArea = function(coords, maxDistance) return EnumerateEntitiesWithinDistance(STX.Game.GetPlayers(true, true), true, coords, maxDistance) end
STX.Game.GetVehiclesInArea = function(coords, maxDistance) return EnumerateEntitiesWithinDistance(STX.Game.GetVehicles(), false, coords, maxDistance) end
STX.Game.IsSpawnPointClear = function(coords, maxDistance) return #STX.Game.GetVehiclesInArea(coords, maxDistance) == 0 end

STX.Game.GetClosestEntity = function(entities, isPlayerEntities, coords, modelFilter)
	local closestEntity, closestEntityDistance, filteredEntities = -1, -1, nil

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	if modelFilter then
		filteredEntities = {}

		for k,entity in pairs(entities) do
			if modelFilter[GetEntityModel(entity)] then
				table.insert(filteredEntities, entity)
			end
		end
	end

	for k,entity in pairs(filteredEntities or entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if closestEntityDistance == -1 or distance < closestEntityDistance then
			closestEntity, closestEntityDistance = isPlayerEntities and k or entity, distance
		end
	end

	return closestEntity, closestEntityDistance
end

STX.Game.GetVehicleInDirection = function()
	local playerPed    = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local inDirection  = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
	local rayHandle    = StartShapeTestRay(playerCoords, inDirection, 10, playerPed, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	if hit == 1 and GetEntityType(entityHit) == 2 then
		return entityHit
	end

	return nil
end

STX.Game.GetVehicleProperties = function(vehicle)
	if DoesEntityExist(vehicle) then
		currentTunes = {}
		SetVehicleModKit(vehicle, 0)
	
		currentTunes['PerleascentColour'], currentTunes['WheelColour'] = GetVehicleExtraColours(vehicle)
		currentTunes['Livery'] = GetVehicleLivery(vehicle)
		currentTunes['Spoilers'] = GetVehicleMod(vehicle, 0)
		currentTunes['FrontBumper'] = GetVehicleMod(vehicle, 1)
		currentTunes['RearBumper'] = GetVehicleMod(vehicle, 2)
		currentTunes['SideSkirt'] = GetVehicleMod(vehicle, 3)
		currentTunes['Exhaust'] = GetVehicleMod(vehicle, 4)
		currentTunes['Frame'] = GetVehicleMod(vehicle, 5)
		currentTunes['Grille'] = GetVehicleMod(vehicle, 6)
		currentTunes['Hood'] = GetVehicleMod(vehicle, 7)
		currentTunes['Fender'] = GetVehicleMod(vehicle, 8)
		currentTunes['RightFender'] = GetVehicleMod(vehicle, 9)
		currentTunes['Roof'] = GetVehicleMod(vehicle, 10)
		
		currentTunes['Engine'] = GetVehicleMod(vehicle, 11)
		currentTunes['Brakes'] = GetVehicleMod(vehicle, 12)
		currentTunes['Transmission'] = GetVehicleMod(vehicle, 13)
		currentTunes['Horns'] = GetVehicleMod(vehicle, 14)
		currentTunes['Suspension'] = GetVehicleMod(vehicle, 15)
		currentTunes['Armor'] = GetVehicleMod(vehicle, 16)
	
		currentTunes['Turbo'] = GetVehicleMod(vehicle, 18)
		currentTunes['Xenon'] = GetVehicleMod(vehicle, 22)
		currentTunes['WheelType'] = GetVehicleWheelType(vehicle)
		currentTunes['FrontWheels'] = GetVehicleMod(vehicle, 23)
		currentTunes['BackWheels'] = GetVehicleMod(vehicle, 24)
		currentTunes['PlateHolder'] = GetVehicleMod(vehicle, 25)
		currentTunes['VanityPlate'] = GetVehicleMod(vehicle, 26)
		currentTunes['TrimA'] = GetVehicleMod(vehicle, 27)
		currentTunes['Ornaments'] = GetVehicleMod(vehicle, 28)
		currentTunes['Dashboard'] = GetVehicleMod(vehicle, 29)
		currentTunes['Dial'] = GetVehicleMod(vehicle, 30)
		currentTunes['DoorSpeaker'] = GetVehicleMod(vehicle, 31)
		currentTunes['Seats'] = GetVehicleMod(vehicle, 32)
		currentTunes['SteeringWheel'] = GetVehicleMod(vehicle, 33)
		currentTunes['ShifterLeavers'] = GetVehicleMod(vehicle, 34)
		
		currentTunes['APlate'] = GetVehicleMod(vehicle, 35)
		currentTunes['Speakers'] = GetVehicleMod(vehicle, 36)
		currentTunes['Trunk'] = GetVehicleMod(vehicle, 37)
		currentTunes['Hydrolic'] = GetVehicleMod(vehicle, 38)
		currentTunes['EngineBlock'] = GetVehicleMod(vehicle, 39)
		currentTunes['AirFilter'] = GetVehicleMod(vehicle, 40)
		currentTunes['Struts'] = GetVehicleMod(vehicle, 41)
		currentTunes['ArchCover'] = GetVehicleMod(vehicle, 42)
		currentTunes['Aerials'] = GetVehicleMod(vehicle, 43)
		currentTunes['TrimB'] = GetVehicleMod(vehicle, 44)
		currentTunes['Tank'] = GetVehicleMod(vehicle, 45)
		currentTunes['Windows'] = GetVehicleMod(vehicle, 46)
		currentTunes['PrimaryColour'], currentTunes['SecondaryColour'] = GetVehicleColours(vehicle)
		
		currentTunes['Turbo'] = IsToggleModOn(vehicle, 18)
		currentTunes['Smoke'] = IsToggleModOn(vehicle, 20)
		currentTunes['Xenon'] = IsToggleModOn(vehicle, 22)
		currentTunes['WindowTint'] = GetVehicleWindowTint(vehicle)
	
		currentTunes['XenonColor'] = GetVehicleXenonLightsColour(vehicle)
		
		currentTunes['Extras'] = {}
		for extraId=0, 12 do
			if DoesExtraExist(vehicle, extraId) then
				if IsVehicleExtraTurnedOn(vehicle, extraId) then
					table.insert(currentTunes['Extras'], extraId)
				end
			end
		end

		return currentTunes
	end
	return {}
end

STX.Game.SetVehicleProperties = function(vehicle, mods)
	if DoesEntityExist(vehicle) and mods then
		print (mods)
		SetVehicleModKit(vehicle, 0)
		
		SetVehicleColours(vehicle, mods['PrimaryColour'], mods['SecondaryColour'])

		if mods['Livery'] then SetVehicleLivery(vehicle, mods['Livery']) else SetVehicleLivery(vehicle, 0) end

		SetVehicleExtraColours(vehicle, 0, 0)

		if mods['PerleascentColour'] then
			local wheelColor = mods['WheelColour'] or 0
			SetVehicleExtraColours(vehicle, mods['PerleascentColour'], wheelColor)
		end

		if mods['WheelType'] then 
			SetVehicleWheelType(vehicle, mods['WheelType']) 
		end

		if mods['WheelColour'] then
			local perleascentColor = mods['PerleascentColour'] or 0
			SetVehicleExtraColours(vehicle, perleascentColor, mods['WheelColour'])
		end

		if mods['Spoilers'] then SetVehicleMod(vehicle, 0, mods['Spoilers'], false) end
		if mods['FrontBumper'] then SetVehicleMod(vehicle, 1, mods['FrontBumper'], false) end
		if mods['RearBumper'] then SetVehicleMod(vehicle, 2, mods['RearBumper'], false) end
		if mods['SideSkirt'] then SetVehicleMod(vehicle, 3, mods['SideSkirt'], false) end
		if mods['Exhaust'] then SetVehicleMod(vehicle, 4, mods['Exhaust'], false) end
		if mods['Frame'] then SetVehicleMod(vehicle, 5, mods['Frame'], false) end
		if mods['Grille'] then SetVehicleMod(vehicle, 6, mods['Grille'], false) end
		if mods['Hood'] then SetVehicleMod(vehicle, 7, mods['Hood'], false) end
		if mods['Fender'] then SetVehicleMod(vehicle, 8, mods['Fender'], false) end
		if mods['RightFender'] then SetVehicleMod(vehicle, 9, mods['RightFender'], false) end
		if mods['Roof'] then SetVehicleMod(vehicle, 10, mods['Roof'], false) end

		if mods['Engine'] then SetVehicleMod(vehicle, 11, mods['Engine'], false) end
		if mods['Brakes'] then SetVehicleMod(vehicle, 12, mods['Brakes'], false) end
		if mods['Transmission'] then SetVehicleMod(vehicle, 13, mods['Transmission'], false) end
		if mods['Horns'] then SetVehicleMod(vehicle, 14, mods['Horns'], false) end
		if mods['Suspension'] then SetVehicleMod(vehicle, 15, mods['Suspension'], false) end
		if mods['Armor'] then SetVehicleMod(vehicle, 16, mods['Armor'], false) end

		if mods['Turbo'] then ToggleVehicleMod(vehicle,  18, mods['Turbo']) end
		if mods['Smoke'] then ToggleVehicleMod(vehicle, 20, mods['Smoke']) end
		if mods['Xenon'] then ToggleVehicleMod(vehicle,  22, mods['Xenon']) end
		if mods['XenonColor'] then SetVehicleXenonLightsColour(vehicle, mods['XenonColor']) end

		if mods['FrontWheels'] then SetVehicleMod(vehicle, 23, mods['FrontWheels'], false) end
		if mods['BackWheels'] then SetVehicleMod(vehicle, 24, mods['BackWheels'], false) end
		if mods['PlateHolder'] then SetVehicleMod(vehicle, 25, mods['PlateHolder'], false) end
		if mods['VanityPlate'] then SetVehicleMod(vehicle, 26, mods['VanityPlate'], false) end
		if mods['TrimA'] then SetVehicleMod(vehicle, 27, mods['TrimA'], false) end
		if mods['Ornaments'] then SetVehicleMod(vehicle, 28, mods['Ornaments'], false) end
		if mods['Dashboard'] then SetVehicleMod(vehicle, 29, mods['Dashboard'], false) end
		if mods['Dial'] then SetVehicleMod(vehicle, 30, mods['Dial'], false) end
		if mods['DoorSpeaker'] then SetVehicleMod(vehicle, 31, mods['DoorSpeaker'], false) end
		if mods['Seats'] then SetVehicleMod(vehicle, 32, mods['Seats'], false) end
		if mods['SteeringWheel'] then SetVehicleMod(vehicle, 33, mods['SteeringWheel'], false) end
		if mods['ShifterLeavers'] then SetVehicleMod(vehicle, 34, mods['ShifterLeavers'], false) end
		if mods['APlate'] then SetVehicleMod(vehicle, 35, mods['APlate'], false) end
		if mods['Speakers'] then SetVehicleMod(vehicle, 36, mods['Speakers'], false) end
		if mods['Trunk'] then SetVehicleMod(vehicle, 37, mods['Trunk'], false) end
		if mods['Hydrolic'] then SetVehicleMod(vehicle, 38, mods['Hydrolic'], false) end
		if mods['EngineBlock'] then SetVehicleMod(vehicle, 39, mods['EngineBlock'], false) end
		if mods['AirFilter'] then SetVehicleMod(vehicle, 40, mods['AirFilter'], false) end
		if mods['Struts'] then SetVehicleMod(vehicle, 41, mods['Struts'], false) end
		if mods['ArchCover'] then SetVehicleMod(vehicle, 42, mods['ArchCover'], false) end
		if mods['Aerials'] then SetVehicleMod(vehicle, 43, mods['Aerials'], false) end
		if mods['TrimB'] then SetVehicleMod(vehicle, 44, mods['TrimB'], false) end
		if mods['Tank'] then SetVehicleMod(vehicle, 45, mods['Tank'], false) end
		if mods['Windows'] then SetVehicleMod(vehicle, 46, mods['Windows'], false) end      
		if mods['WindowTint'] then SetVehicleWindowTint(vehicle, mods['WindowTint']) end

		for extraId = 0, 20 do
			if DoesExtraExist(vehicle, extraId) then
				SetVehicleExtra(vehicle, extraId, 1)
			end
		end

		if mods['Extras'] then
			for _, v in pairs (mods['Extras']) do
				if DoesExtraExist(vehicle, v) then
					SetVehicleExtra(vehicle, v, 0)
				end
			end
		end

	end
end

STX.Game.DrawText3D = function(coords, text, size, font)
	coords = vector3(coords.x, coords.y, coords.z)

	local camCoords = GetGameplayCamCoords()
	local distance = #(coords - camCoords)

	if not size then size = 1 end
	if not font then font = 0 end

	local scale = (size / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.55 * scale)
	SetTextFont(font)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	SetDrawOrigin(coords, 0)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.0, 0.0)
	ClearDrawOrigin()
end
