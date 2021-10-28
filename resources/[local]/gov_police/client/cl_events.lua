local players = exports['players']

AddEventHandler("police:reviveNearest", function()
    local faction = players:GetClientVar("character").faction
    local faction_name = faction and faction.group.faction_name

	if faction and (faction_name == 'LSPD' or faction_name == 'EMS') then
		local closestPlayer, closestPlayerDistance = exports['modules']:getModule("Game").GetClosestPlayer()
		local targetPed = GetPlayerPed(closestPlayer)
		if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
			local trgPlayer = Player(GetPlayerServerId(closestPlayer))
			if trgPlayer.state.isDead then
				TriggerServerEvent("death:reviveSomeone", GetPlayerServerId(closestPlayer))
			end
		end
	end
end)

AddEventHandler("police:fingerprintNearest", function()
    local faction = players:GetClientVar("character").faction
    local faction_name = faction and faction.group.faction_name

	if faction and (faction_name == 'LSPD' or faction_name == 'EMS') then
		local closestPlayer, closestPlayerDistance = exports['modules']:getModule("Game").GetClosestPlayer()
		local targetPed = GetPlayerPed(closestPlayer)

		if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
			local retval = RPC.execute("police:fingerprintNearest", GetPlayerServerId(closestPlayer))
			TriggerEvent("DoLongHudText", ("Andmebaasist tuli tagasi '"..retval.name.."'. (CID: "..retval.cid..")"), "green", 10000)
		end
	end
end)

--* MISC DRAGGING SHIT
local playerPed = PlayerPedId()
AddEventHandler("jp:onPedChange", function(ped)
	playerPed = ped
end)

local playerVehicle = IsPedInAnyVehicle(playerPed) and GetVehiclePedIsIn(playerPed, false) or nil
AddEventHandler('baseevents:enteredVehicle', function(pCurrentVehicle, currentSeat, vehicleDisplayName)
	playerVehicle = pCurrentVehicle
end)

AddEventHandler('baseevents:leftVehicle', function(pCurrentVehicle, pCurrentSeat, vehicleDisplayName)
	playerVehicle = nil
end)  

function canDrag()
    local inGame = players:GetClientVar('inGame')
    local isDead = players:GetClientVar('isDead')
    local isCuffed = players:GetClientVar('isCuffed')
    local paused = IsPauseMenuActive()
    return not isDead and not isCuffed and not paused and inGame
end

local Drag = {
	Distance = 3,
	Dragging = false,
	Dragger = -1,
	Dragged = false,
}

function Drag:GetClosestPlayer()
    local Players = GetActivePlayers()
    local ClosestDistance = -1
    local ClosestPlayer = -1
    local PlayerPed = PlayerPedId()
    local PlayerPosition = GetEntityCoords(PlayerPed, false)

    for Index = 1, #Players do
    	local TargetPed = GetPlayerPed(Players[Index])
    	if PlayerPed ~= TargetPed then
    		local TargetCoords = GetEntityCoords(TargetPed, false)
    		local Distance = #(PlayerPosition - TargetCoords)

    		if ClosestDistance == -1 or ClosestDistance > Distance then
    			ClosestPlayer = Players[Index]
    			ClosestDistance = Distance
    		end
    	end
    end

    return ClosestPlayer, ClosestDistance
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if Drag.Dragging then
			local PlayerPed = PlayerPedId()
			if IsEntityDead(GetPlayerPed(GetPlayerFromServerId(Drag.Dragger))) then
				Drag.Dragging = not Drag.Dragging
				Drag.Dragger = Dragger
			else
				Drag.Dragged = true
				AttachEntityToEntity(PlayerPed, GetPlayerPed(GetPlayerFromServerId(Drag.Dragger)), 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			end
		else
			if Drag.Dragged then
				local PlayerPed = PlayerPedId()

				if not IsPedInParachuteFreeFall(PlayerPed) then
					Drag.Dragged = false
					DetachEntity(PlayerPed, true, false)
				end
			end
		end
	end
end)

RegisterNetEvent("police:escort")
AddEventHandler("police:escort", function(Dragger)
	Drag.Dragging = not Drag.Dragging
	Drag.Dragger = Dragger
end)

RegisterNetEvent("police:seatPlayer")
AddEventHandler("police:seatPlayer", function(Vehicle, inTrunk)
	Drag.Dragging = false

	local vehicle = NetworkGetEntityFromNetworkId(Vehicle)

	if vehicle then
		if inTrunk then
			exports['hideintrunk']:getInTrunk(vehicle)
		else
			for i=1,math.max(GetVehicleMaxNumberOfPassengers(vehicle),3) do
				if IsVehicleSeatFree(vehicle,i) then
					SetPedIntoVehicle(PlayerPedId(),vehicle,i)
				end
			end
		end
	end
end)

RegisterNetEvent("police:unseatPlayer")
AddEventHandler("police:unseatPlayer", function(Dragger)
	if playerVehicle then
		if not exports['players']:GetClientVar('isDead') then
			TaskLeaveVehicle(playerPed, GetVehiclePedIsIn(playerPed, false), 1)
		else
			SetEntityCoords(playerPed, GetEntityCoords(playerPed))
		end
	elseif exports['players']:GetClientVar('inTrunk') then
		exports['players']:SetClientVar("inTrunk", false)
		SetEntityCoords(playerPed, GetEntityCoords(playerPed))
	end
	Drag.Dragging = true
	Drag.Dragger = Dragger
end)

AddEventHandler("general:unseatPlayer", function()
	if beingEscorted or not canDrag() then
        TriggerEvent("DoLongHudText", "Sa ei saa seda praegu teha!", 'red')
		return
	end

	local closestPlayer, closestPlayerDistance = exports['modules']:getModule("Game").GetClosestPlayer()
	local vehInDirection = exports['modules']:getModule("Game").GetVehicleInDirection()

	if vehInDirection and GetVehicleDoorLockStatus(vehInDirection) ~= 2 then
		if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
			TriggerServerEvent("police:unseatPlayer", GetPlayerServerId(closestPlayer), NetworkGetNetworkIdFromEntity(vehInDirection))
		end
	end
end)

AddEventHandler('general:seatPlayer', function()
	if beingEscorted or not canDrag() then
        TriggerEvent("DoLongHudText", "Sa ei saa seda praegu teha!", 'red')
        return
	end

	local closestPlayer, closestPlayerDistance = exports['modules']:getModule("Game").GetClosestPlayer()
	local vehInDirection = exports['modules']:getModule("Game").GetVehicleInDirection()

	local model = GetEntityModel(vehInDirection)
	local coords = GetModelDimensions(model)

	local startPosition = GetOffsetFromEntityInWorldCoords(playerPed, 0, 0.5, 0);
	local back = GetOffsetFromEntityInWorldCoords(vehInDirection, 0.0, coords[2] - 0.5, 0.0);
	local distanceRear = GetDistanceBetweenCoords(startPosition[1],startPosition[2],startPosition[3], back[1], back[2], back[3]);

	if vehInDirection and GetVehicleDoorLockStatus(vehInDirection) ~= 2 then
		local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(vehInDirection))
		if dist < 3.0 and closestPlayer ~= -1 and closestPlayerDistance < 2.0 then
			TriggerServerEvent("police:seatPlayer", GetPlayerServerId(closestPlayer), NetworkGetNetworkIdFromEntity(vehInDirection), (distanceRear < 1.5))
		end
	end
end)

AddEventHandler('police:escortClosestPlayer', function()
	if not canDrag() then
		TriggerEvent("DoLongHudText", "Sa ei saa seda praegu teha!", 'red')
		return
    end

	if Drag.Dragging and Drag.Dragger then
		Drag.Dragging = false
		Drag.Dragger = nil
		return
	end

    local closestPlayer, closestPlayerDistance = exports['modules']:getModule("Game").GetClosestPlayer()

	if closestPlayer ~= -1 and closestPlayerDistance < 5.0 then
        TriggerServerEvent("police:askToEscort", GetPlayerServerId(closestPlayer))
    end
end)

AddEventHandler("police:makePrisonFood", function()
	local character = exports['players']:GetClientVar("character")
	if character and character.jail_time > 0 then
		if exports['inventory']:canCarryItem('prison-food', 1) then
			exports['progress']:Progress({
				name = "prison_food",
				duration = 30*1000,
				label = ('Võtad Vangla Toitu...'),
				useWhileDead = false,
				canCancel = true,
				controlDisables = {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true},
				animation = {animDict = "anim@move_m@trash", anim = "pickup"},
			}, function(cancelled)
				ClearPedTasks(PlayerPedId())
				if not cancelled then
					TriggerServerEvent("police:givePrisonFood")
				end
			end)
		end
	end
end)