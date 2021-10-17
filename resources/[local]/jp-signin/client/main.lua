local events = exports['events']

AddEventHandler("jp-signin:peekAction", function(pEnt, pArgs)
	TriggerServerEvent("jp-signin:duty")
end)

AddEventHandler("jp-signoff:peekAction", function(pEnt, pArgs)
	TriggerServerEvent("jp-signoff:duty")
end)