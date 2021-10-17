local Data = {}
Data.ServerCallbacks = {}

Data.TriggerServerCallback = function(name, requestId, source, cb, ...)
    if Data.ServerCallbacks[name] then
		Data.ServerCallbacks[name](source, cb, ...)
	else
		print(('[events] [^3WARNING^7] Server callback "%s" does not exist.'):format(name))
	end
end

exports("RegisterServerCallback", function(name, cb)
    Data.ServerCallbacks[name] = cb
end)

exports("Register", function(name, cb)
    Data.ServerCallbacks[name] = cb
end)

RegisterServerEvent('events:triggerServerCallback')
AddEventHandler('events:triggerServerCallback', function(name, requestId, ...)
	local playerId = source

	Data.TriggerServerCallback(name, requestId, playerId, function(...)
		TriggerClientEvent('events:serverCallback', playerId, requestId, ...)
	end, ...)
end)
