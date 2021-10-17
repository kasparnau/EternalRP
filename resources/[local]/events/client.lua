Data = {}
Data.ServerCallbacks = {}
Data.CurrentRequestId = 0

exports("Trigger", function(name, cb, ...)
    Data.ServerCallbacks[Data.CurrentRequestId] = cb

	TriggerServerEvent('events:triggerServerCallback', name, Data.CurrentRequestId, ...)

	if Data.CurrentRequestId < 65535 then
		Data.CurrentRequestId = Data.CurrentRequestId + 1
	else
		Data.CurrentRequestId = 0
	end

end)

RegisterNetEvent('events:serverCallback')
AddEventHandler('events:serverCallback', function(requestId, ...)
	Data.ServerCallbacks[requestId](...)
	Data.ServerCallbacks[requestId] = nil
end)
