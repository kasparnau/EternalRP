local SoundBanks = {
    { bank = 'dlc_nikez_sounds/general' },
    { bank = 'dlc_nikez_ros_general/ros_general' },
}

Citizen.CreateThread(function()
    while not NetworkIsSessionStarted() do Citizen.Wait(100) end

    for _, entry in ipairs(SoundBanks) do
        local timeout = false

        Citizen.SetTimeout(10000, function() timeout = true end)

        while not RequestScriptAudioBank(entry.bank, 0) and not timeout do
            Citizen.Wait(0)
        end
    end
end)