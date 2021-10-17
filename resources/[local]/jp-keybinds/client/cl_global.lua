-- Binds that are used globaly and do not fit in a single resouce
-- All Binds should use the event name and bool

Citizen.CreateThread(function()
    RegisterCommand('+showPlayerList', function() end, false)
    RegisterCommand('-showPlayerList', function() end, false)
    exports["jp-keybinds"]:registerKeyMapping("PlayerList", "Mängija", "Vaata Mängijaid", "+showPlayerList", "-showPlayerList", "U", true)

    RegisterCommand('+toggleHandsUp', function() end, false)
    RegisterCommand('-toggleHandsUp', function() end, false)
    exports["jp-keybinds"]:registerKeyMapping("toggleHandsUp", "Mängija", "Käed Üles", "+toggleHandsUp", "-toggleHandsUp", "X", true)

    RegisterCommand('+propertyInteract', function() end, false)
    RegisterCommand('-propertyInteract', function() end, false)
    exports['jp-keybinds']:registerKeyMapping("housingMain", "Kinnisvara", "Housing Main", "+propertyInteract", "-propertyInteract", "G", true)    

    RegisterCommand('+propertyInteract2', function() end, false)
    RegisterCommand('-propertyInteract2', function() end, false)
    exports['jp-keybinds']:registerKeyMapping("housingSecondary", "Kinnisvara", "Housing Secondary", "+propertyInteract2", "-propertyInteract2", "H", true)    

    RegisterCommand('+cycleproximity', function() end, false)
    RegisterCommand('-cycleproximity', function() end, false)
    exports['jp-keybinds']:registerKeyMapping("cycleProximity", "Voice Chat", "Muuda Hääle Tugevust", "+cycleproximity", "-cycleproximity", "Z", true)
end)

-- disable pause
Citizen.CreateThread(function()
	while true do
		DisableControlAction(1, 199, true)
		Wait(5)
	end
end)
