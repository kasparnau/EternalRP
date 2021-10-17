AddEventHandler("updateBeltStatus", function(a)
    SendNUIMessage({
        belt = a
    })	
end)

AddEventHandler("updateSpeedometer", function(a)
    SendNUIMessage({
        speed = a
    })	
end)

AddEventHandler("updateClock", function(a, b)
    SendNUIMessage({
        type = "time",
        hours = a,
        minutes = b
    })	
end)

AddEventHandler("updateFuel", function(a)
    SendNUIMessage({
        fuel = tostring(a)
    })	
end)

AddEventHandler('baseevents:enteredVehicle', function(pCurrentVehicle, currentSeat, vehicleDisplayName)
	SendNUIMessage({
		display = "true"
	})
end)
AddEventHandler('baseevents:leftVehicle', function(pCurrentVehicle, pCurrentSeat, vehicleDisplayName)
	SendNUIMessage({
		display = "false"
	})
end)  