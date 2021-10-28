local sql = exports['jp-sql2']

RPC.register("addContact", function(source, data)
    local character = exports['players']:getCharacter(source)
    
    local query = [[
        INSERT INTO phone_contacts (citizen_id, number, name)
        VALUES (?, ?, ?)
    ]]
    
    local queryData = {character.cid, data.number, data.name}

    print (json.encode(queryData))

    local result = sql:executeSync(query, queryData)

    return result.insertId
end)

RPC.register("getContacts", function(source)
    local character = exports['players']:getCharacter(source)
    
    local query = [[
        SELECT number, name, id
        FROM phone_contacts
        WHERE citizen_id=?
    ]]

    local queryData = {character.cid}
    local contacts = sql:executeSync(query, queryData)

    return contacts
end)

RPC.register("removeContact", function(source, id)
    local character = exports['players']:getCharacter(source)
        
    local query = [[
        DELETE FROM phone_contacts
        WHERE citizen_id=? AND id=?
    ]]

    local queryData = {character.cid, id}
    local contacts = sql:executeSync(query, queryData)

    return contacts
end)

RPC.register("fetchTweets", function(source)
    local query = [[
        SELECT * FROM phone_tweets
        ORDER BY date DESC
        LIMIT 20
    ]]

    local queryData = {}
    local tweets = sql:executeSync(query, {})

    return tweets
end)

RPC.register("addTweet", function(source, text)
    local character = exports['players']:getCharacter(source)

    local query = [[
        INSERT INTO phone_tweets (citizen_id, text, poster)
        VALUES (?, ?, ?)
    ]]

    local poster = ("@%s_%s"):format(character.first_name, character.last_name)
    local queryData = {character.cid, text, poster}
    local contacts = sql:executeSync(query, queryData)

    for i,v in pairs (GetPlayers()) do
        local char = exports['players']:getCharacter(v)
        if char then
            TriggerClientEvent("jp-phone:enableCircleNoti", v, "twitter")
            
            local formated = ("%s: %s%s"):format(poster, text:sub(1, 30), (text:len() >= 30 and "..." or ''))
            TriggerClientEvent("jp-phone:doPhoneNoti", v, "Twitter", formated, 3000, 3)
        end
    end

    return contacts
end)

RPC.register("sendPing", function(source, target)
    local targetChar = exports['players']:getCharacter(target)
    if not targetChar then
        TriggerClientEvent("DoLongHudText", source, "Sellise ID-ga isikut ei ole linnas!", "red")
        return false
    end

    TriggerClientEvent("jp-phone:pingRequest", target, source)
    TriggerClientEvent("DoLongHudText", source, "Pingisid isikut!", "green")
    return true
end)

RPC.register("acceptPing", function(source, target)
    local coords = GetEntityCoords(GetPlayerPed(source))
    TriggerClientEvent("jp-phone:acceptedPing", target, coords)
end)

local calls = {}
local currCallChannel = 0

function getPlayerCall(source)
    for i,v in pairs (calls) do
        if v.from == source or v.to == source then
            return v, i
        end
    end
    return false
end

RPC.register("callPlayer", function(source, number, name)
    local target
    for i,v in pairs (GetPlayers()) do
        local character = exports['players']:getCharacter(v)
        if character then
            if tonumber(character.phone_number) == tonumber(number) then
                target = tonumber(v)
                break
            end
        end
    end

    if not target or getPlayerCall(target) or getPlayerCall(source) then
        -- TriggerClientEvent("DoLongHudText", source, "Isik ei ole hetkel kättesaadaval", "red")
        TriggerClientEvent("jp-phone:calls:stop", source, "Isik ei ole hetkel kättesaadaval...")
        return false
    end

    currCallChannel = currCallChannel + 1
    table.insert(calls, {from = source, to = target, status = "pending", channel = currCallChannel})
    CreateThread(function()
        local ind = #calls
        Wait(30*1000)
        if calls[ind] and calls[ind].status == 'pending' then
            -- TriggerClientEvent("DoLongHudText", source, "Isik ei vastand sinu kõnele!", "red")
            TriggerClientEvent("jp-phone:calls:stop", source, "Isik ei vastand sinu kõnele...")
            TriggerClientEvent("jp-phone:calls:stop", target)       
            table.remove(calls, ind) 
        end
    end)

    local srcCharacter = exports['players']:getCharacter(source)
    TriggerClientEvent("jp-phone:callRequest", target, srcCharacter.phone_number, currCallChannel)

    return true
end)

RPC.register("answerCall", function(source, answer)
    local call, ind = getPlayerCall(tonumber(source))
    if not call then return end

    if not answer then
        table.remove(calls, ind)

        if source == call.from then
            TriggerClientEvent("jp-phone:calls:stop", call.to)
        end
    end

    TriggerClientEvent("jp-phone:callRequest:answer", call.from, answer, call.channel)

    if calls[ind] then
        calls[ind].status = 'ongoing'
    end

    return call.channel
end)

RPC.register("stopCall", function(source)
    local call, ind = getPlayerCall(tonumber(source))
    if not call then return end

    table.remove(calls, ind)

    TriggerClientEvent("jp-phone:calls:stop", call.from)
    TriggerClientEvent("jp-phone:calls:stop", call.to)

    exports['pma-voice']:setPlayerCall(call.from, 0)
    exports['pma-voice']:setPlayerCall(call.to, 0)

    return true
end)

AddEventHandler("playerDropped", function()
    local call, ind = getPlayerCall(tonumber(source))
    if not call then return end

    table.remove(calls, ind)

    local otherPlayer = call.from ~= source and call.from or call.to

    TriggerClientEvent("jp-phone:calls:stop", otherPlayer)
    exports['pma-voice']:setPlayerCall(otherPlayer, 0)
end)