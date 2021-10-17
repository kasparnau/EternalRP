local ind = {l = false, r = false}

local ped = PlayerPedId()
local car = GetVehiclePedIsIn(ped, false)

AddEventHandler('baseevents:enteredVehicle', function(pCurrentVehicle, currentSeat, vehicleDisplayName)
    car = pCurrentVehicle
end)
AddEventHandler('baseevents:leftVehicle', function(pCurrentVehicle, pCurrentSeat, vehicleDisplayName)
    car = nil
    print "left"
    SendNUIMessage({
      showhud = false
    })
end)  

AddEventHandler("updateBeltStatus", function(enable)
	SendNUIMessage({
		seatbelt = true,
		enable = tostring(enable),
	})
end)

Citizen.CreateThread(function()
	while true do
		if car and car ~= 0 then
			-- Speed
			carSpeed = math.ceil(GetEntitySpeed(car) * 3.6)
			SendNUIMessage({
				showhud = true,
				speed = carSpeed
			})
			local fuel = exports['fuel']:GetFuel(car)
			SendNUIMessage({
				showfuel = true,
				fuel = fuel
			})
			Wait(50)
		else
			Wait(10)
		end
	end
end)

local useMph = false -- if false, it will display speed in kph

Citizen.CreateThread(function()
  local resetSpeedOnEnter = true
  while true do
    Citizen.Wait(0)
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed,false)
    if GetPedInVehicleSeat(vehicle, -1) == playerPed and IsPedInAnyVehicle(playerPed, false) then

      -- This should only happen on vehicle first entry to disable any old values
      if resetSpeedOnEnter then
        maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
        SetEntityMaxSpeed(vehicle, maxSpeed)
        resetSpeedOnEnter = false
      end
      -- Disable speed limiter
      if IsControlJustReleased(0,246) and IsControlPressed(0,131) then
        maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
        SetEntityMaxSpeed(vehicle, maxSpeed)
      -- Enable speed limiter
      elseif IsControlJustReleased(0,246) then
        cruise = GetEntitySpeed(vehicle)
        SetEntityMaxSpeed(vehicle, cruise)
        if useMph then
          cruise = math.floor(cruise * 2.23694 + 0.5)
        else
          cruise = math.floor(cruise * 3.6 + 0.5)
        end
      end
    else
      resetSpeedOnEnter = true
    end
  end
end)