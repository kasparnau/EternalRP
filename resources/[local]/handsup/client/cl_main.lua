local handsUp = false

RegisterNetEvent('jp-binds:keyEvent')
AddEventHandler('jp-binds:keyEvent', function(name, onDown) 
    if exports['progress']:doingAction() or exports['jp-phone']:isInCall() then return end
    if not exports['inventory']:canViewInventory() then return end
    if name == "toggleHandsUp" then
        handsUp = onDown
        if handsUp then
            exports['dpemotes']:cancel()
        end
    end
end)

Citizen.CreateThread(function()
    local dict = "missminuteman_1ig_2"
    
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end

    local handsup = false
    while true do
		Citizen.Wait(0)
		if handsUp then
            if not handsup then
                TaskPlayAnim(GetPlayerPed(-1), dict, "handsup_base", 8.0, 8.0, -1, 50, 0, false, false, false)
                handsup = true
            end
        else
            if handsup then
                handsup = false
                ClearPedTasks(GetPlayerPed(-1))
            end
        end
    end
end)
