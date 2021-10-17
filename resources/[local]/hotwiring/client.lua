local isDead = false
AddEventHandler("players:ClientVarChanged", function(name, old, new)
    if name == "isDead" then
        isDead = new
    end
end)
local playerPed = PlayerPedId()
AddEventHandler("jp:onPedChange", function(ped)
	playerPed = ped
end)

local config = {
    carTimers = {
        [20] = 30 * 1000, -- VANS?
        [19] = 120 * 1000, -- MILITARY
        [18] = 30 * 1000, -- EMERGENCY
        [17] = 15 * 1000, -- SERVICE
        [16] = 120 * 1000, -- PLANE
        [15] = 120 * 1000, -- HELICOPTER
        [14] = 20 * 1000, -- BOATS
        [12] = 15 * 1000, -- VANS
        [11] = 15 * 1000, -- UTILITY
        [10] = 15 * 1000, -- INDUSTRIAL
        [9] = 20 * 1000, -- OFFORAD
        [8] = 20 * 1000, -- MOTORCYCLES
        [7] = 60 * 1000, -- SUPER
        [6] = 40 * 1000, -- SPORTS
        [5] = 35 * 1000, -- SPORTS CLASSIC
        [4] = 25 * 1000, -- MUSCLE
        [3] = 30 * 1000, -- COUPES
        [2] = 20 * 1000, -- SUV's
        [1] = 25 * 1000, -- SEDANS
        [0] = 20 * 1000, -- COMPACTS
    }
}

local hwire = {
    name = "hotwiring",duration = 1000,label = 'Hotwiring Stage 1',useWhileDead = false,canCancel = true,
    controlDisables = {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,},
    animation = {animDict = "veh@handler@base",anim = "hotwire", flags = 49},
}

function startHotwiring(item)
    if not (exports['inventory']:hasEnoughOfItem(item, 1)) then return end

    local amountToDo = item == 'advanced-lockpick' and 4 or 5
    Citizen.CreateThread(function()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed)

            if not GetIsVehicleEngineRunning(vehicle) and config["carTimers"][GetVehicleClass(vehicle)] and exports['skill-checks']:canDo() then
                SetVehicleAlarm(vehicle, true)
                SetVehicleAlarmTimeLeft(vehicle, 240*1000)
                StartVehicleAlarm(vehicle)

                local doneIteration = 0
                local amountToDo = 5
                local failed = false

                for i = 1, amountToDo do
                    local success = exports['skill-checks']:start(math.random(10, 80)/1000, math.random(150, 270))
                    if IsPedInAnyVehicle(playerPed, false) and not isDead and exports['skill-checks']:canDo() then
                        if success then
                            if i == amountToDo then
                                toggleEngine(true)
                            end
                        else
                            -- BREAK LOCKPICK
                            failed = true
                        end
                    else
                        TriggerEvent("DoLongHudText", "Sinu lockpick läks katki!", 'red')
                        exports['inventory']:removeItem(item, 1)
                        return
                    end
                    if failed then 
                        TriggerEvent("DoLongHudText", "Sinu lockpick läks katki!", 'red')
                        exports['inventory']:removeItem(item, 1)
                        return 
                    end
                end

                -- exports['skill-checks']:start(math.random(1, 40)/100, math.random(150, 270), function(success)
                --     print (tostring(success).. " | "..tostring(exports['skill-checks']:canDo()))
                --     if success and IsPedInAnyVehicle(playerPed, false) and not isDead and exports['skill-checks']:canDo() then
                --         exports['skill-checks']:start(math.random(1, 40)/100, math.random(150, 270), function(success)
                --             if success and IsPedInAnyVehicle(playerPed, false) and not isDead and exports['skill-checks']:canDo() then
                --                 exports['skill-checks']:start(math.random(1, 40)/100, math.random(150, 270), function(success)
                --                     if success and IsPedInAnyVehicle(playerPed, false) and not isDead then
                --                         SetVehicleAlarm(vehicle, false)
                --                         toggleEngine(true)
                --                     end
                --                 end)
                --             end
                --         end)
                --     end
                -- end)
            end
        end
    end)
end

exports('start', startHotwiring)

local vehicles = {}
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(100)
        local ped = playerPed
		if GetSeatPedIsTryingToEnter(ped) == -1 and not table.contains(vehicles, GetVehiclePedIsTryingToEnter(ped)) then
			table.insert(vehicles, {GetVehiclePedIsTryingToEnter(ped), IsVehicleEngineOn(GetVehiclePedIsTryingToEnter(ped))})
		elseif IsPedInAnyVehicle(ped, false) and not table.contains(vehicles, GetVehiclePedIsIn(ped, false)) then
			table.insert(vehicles, {GetVehiclePedIsIn(ped, false), IsVehicleEngineOn(GetVehiclePedIsIn(ped, false))})
		end
		for i, vehicle in ipairs(vehicles) do
			if DoesEntityExist(vehicle[1]) then
				if (GetPedInVehicleSeat(vehicle[1], -1) == ped) or IsVehicleSeatFree(vehicle[1], -1) then
                    if GetEntitySubmergedLevel(vehicle[1]) < 1.0 then
                        SetVehicleEngineOn(vehicle[1], vehicle[2], true, false)
                        SetVehicleNeedsToBeHotwired(vehicle[1], false)
						SetVehicleJetEngineOn(vehicle[1], vehicle[2])
						if not IsPedInAnyVehicle(ped, false) or (IsPedInAnyVehicle(ped, false) and vehicle[1]~= GetVehiclePedIsIn(ped, false)) then
							if IsThisModelAHeli(GetEntityModel(vehicle[1])) or IsThisModelAPlane(GetEntityModel(vehicle[1])) then
								if vehicle[2] then
									SetHeliBladesFullSpeed(vehicle[1])
								end
							end
                        end
					end
				end
			else
				table.remove(vehicles, i)
			end
		end
	end
end)

function toggleEngine(exception)
	local veh
	local StateIndex
	for i, vehicle in ipairs(vehicles) do
		if vehicle[1] == GetVehiclePedIsIn(playerPed, false) then
			veh = vehicle[1]
			StateIndex = i
		end
	end
    if IsPedInAnyVehicle(playerPed, false) then
        if (GetPedInVehicleSeat(veh, -1) == playerPed) then
            if exception == true or exports['keys']:hasKeys(veh) then
                vehicles[StateIndex][2] = not GetIsVehicleEngineRunning(veh)
                if vehicles[StateIndex][2] then
                    TriggerEvent("DoLongHudText", "Lülitasid mootori sisse", 'green', 3000)
                else
                    TriggerEvent("DoLongHudText", "Lülitasid mootori välja", 'red', 3000)
                end
            end
		end
    end
end

AddEventHandler("engine:toggleEngine", function()
    toggleEngine()
end)

RegisterCommand('+toggleEngine', function()
    if IsPedInAnyVehicle(playerPed, false) then
        local veh = GetVehiclePedIsIn(playerPed, false)
        if exports['keys']:hasKeys(veh) then
            local toggleString = GetIsVehicleEngineRunning(veh) and "Lülitab mootorit välja" or 'Lülitab mootorit sisse'
            local toggleTime = GetIsVehicleEngineRunning(veh) and 400 or 750

            toggleEngine()
            -- exports['progress']:Progress({
            --     name = "ToggleEngine",
            --     duration = toggleTime,
            --     label = (toggleString),
            --     useWhileDead = false,
            --     canCancel = true,
            --     controlDisables = {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true},
            -- }, function(cancelled)
            --     if not cancelled and not exports['players']:GetClientVar("isDead") then
            --         toggleEngine()
            --     end
            -- end)
        else
            TriggerEvent("DoLongHudText", "Teil pole selle sõiduki võtmeid!", 'red', 4000)
        end
    end
end, false)

RegisterCommand('-toggleEngine', function() end, false)
exports['jp-keybinds']:registerKeyMapping("toggleEngine", "Sõidukid", "Toggle Auto Mootor", "+toggleEngine", "-toggleEngine", "K")

function table.contains(table, element)
    for _, value in pairs(table) do
      if value[1] == element then
        return true
      end
    end
    return false
end
