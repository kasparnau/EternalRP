local cashRegisters = {}
local lastRobbedRegister = {}

RPC.register('jp-heists:registers:startRob', function(source, registerId) 
    if not cashRegisters[registerId] then cashRegisters[registerId] = 0 end

    local timeSinceLast = os.time() - cashRegisters[registerId]

    if timeSinceLast > 1800 then
        cashRegisters[registerId] = os.time()
        return true
    else
        TriggerClientEvent('DoLongHudText', source, 'Seda kassaregistrit ei saa praegu röövida!', 'red')
        return false
    end
end)

RegisterNetEvent("jp-heists:registers:finishRob")
AddEventHandler("jp-heists:registers:finishRob", function(registerId)
    local character = exports['players']:getCharacter(source)
    if not lastRobbedRegister[character.cid] then lastRobbedRegister[character.cid] = 0 end

    local timeSinceLast = os.time() - lastRobbedRegister[character.cid]
    if timeSinceLast < 3 then
        exports['admin']:banPlayerFromSource(source, "Automaatne Ban - Cheating", "System", 7776000, ("Time since last register: %s"):format(timeSinceLast))
        return
    end
    if not cashRegisters[registerId] then
        exports['admin']:banPlayerFromSource(source, "Automaatne Ban - Cheating", "System", 7776000, ("Tried to rob registerId: %s"):format(registerId))
        return
    end
    
    local randomAmount = math.random(90, 145)
    print (("%s %s (CID: %s) just robbed registerId: %s and got $%s"):format(character.first_name, character.last_name, character.cid, registerId, randomAmount))

    exports['inventory']:addItem(source, 'cash', randomAmount, false, "ROB CASH REGISTER")
end)