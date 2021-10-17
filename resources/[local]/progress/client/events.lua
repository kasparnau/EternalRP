RegisterNetEvent("progress:client:progress")
AddEventHandler("progress:client:progress", function(action, finish)
	Process(action, nil, nil, finish)
end)

RegisterNetEvent("progress:client:ProgressWithStartEvent")
AddEventHandler("progress:client:ProgressWithStartEvent", function(action, start, finish)
	Process(action, start, nil, finish)
end)

RegisterNetEvent("progress:client:ProgressWithTickEvent")
AddEventHandler("progress:client:ProgressWithTickEvent", function(action, tick, finish)
	Process(action, nil, tick, finish)
end)

RegisterNetEvent("progress:client:ProgressWithStartAndTick")
AddEventHandler("progress:client:ProgressWithStartAndTick", function(action, start, tick, finish)
	Process(action, start, tick, finish)
end)

RegisterNetEvent("progress:client:cancel")
AddEventHandler("progress:client:cancel", function()
	Cancel()
end)

RegisterNUICallback('actionFinish', function(data, cb)
	Finish()
end)