local safes = {}

RPC.register('jp-heists:safes:startCrack', function(source, safeId) 
    if not safes[safeId] then 
        safes[safeId] = {
            isOpen = false,
            isLooted = false,
            isOpening = false
        } 
    end

    if safes[safeId].isOpening then
        TriggerClientEvent("DoLongHudText", source, "Seda seifi juba muugitakse! Oodake paar minutit", 'red')
        return false
    end

    if not safes[safeId].isOpen then
        if exports['inventory']:hasEnoughOfItem(source, "safe-cracking-tool", 1) then
            return true
        else
            TriggerClientEvent("DoLongHudText", source, "Sul pole vajalikku tööriista!", 'red')
            return false
        end
    else
        TriggerClientEvent('DoLongHudText', source, 'Se seif on juba muugitud lahti.', 'red')
        return false
    end
end)

RPC.register("jp-heists:safes:crackSuccessful", function(source, safeId)
    if not safes[safeId] then
        exports['admin']:banPlayerFromSource(source, "Automaatne Ban - (Cheating)", "System", 2628288, ("Tried to crack non-started safe (safeId: "..safeId))
        return
    end

    if not safes[safeId].isOpen then
        safes[safeId].isOpening = true
        TriggerClientEvent("DoLongHudText", source, "Muukimistööriista seadistamine õnnestus. Seif avaneb mõne minuti pärast", 'green', 6000)

        local timeToOpen = math.random(260, 420)
        CreateThread(function()
            Wait(timeToOpen*1000)
            safes[safeId].isOpen = true
            safes[safeId].isOpening = false

            TriggerClientEvent("DoLongHudText", source, "Seif on lahti.", 'green')
        end)
    end
end)

RPC.register("jp-heists:safes:openSafe", function(source, safeId)
    if not safes[safeId] then
        TriggerClientEvent('DoLongHudText', source, 'See seif ei ole muugitud.', 'red')
        return
    end

    if safes[safeId].isOpen then
        if safes[safeId].isLooted then
            TriggerClientEvent('DoLongHudText', source, 'See seif on juba tühi.', 'red')
            return false
        else
            TriggerClientEvent('DoLongHudText', source, 'Röövisite selle seifi.', 'green')

            local randomCash = math.random(45, 65)
            exports['inventory']:addItem(source, 'cash-stack', randomCash)
            local gotGreen = math.random(1, 10) >= 2
            if gotGreen then
                exports['inventory']:addItem(source, 'heist-usb-green', 1)
            end
            safes[safeId].isLooted = true

            CreateThread(function()
                Wait(3600*1000)
                safes[safeId].isOpen = false
                safes[safeId].isLooted = false
            end)
            return true
        end
    else

        if safes[safeId].isOpening then
            TriggerClientEvent("DoLongHudText", source, "See seif pole veel muugitud! Oodake paar minutit.", 'red')
            return false
        else
            TriggerClientEvent('DoLongHudText', source, 'Peate selle seifi kõigepealt lahti muukima.', 'red')
        end

        return false
    end
end)