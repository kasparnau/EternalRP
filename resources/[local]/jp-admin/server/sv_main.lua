local sql = exports['jp-sql2']

function formatSourceForList(source)
    local character = exports['players']:getCharacter(source)
    local player = exports['players']:getPlayer(source)

    return {
        source = source,
        citizen_id = character and character.cid,
        display_name = GetPlayerName(source),
        character_name = character and (("%s %s"):format(character.first_name, character.last_name)),
        phone = character and character.phone_number,
        hex = player and player.steam,
        play_time = player and player.play_time,
        last_played = player and player.last_played,
        faction = character and character.faction
    }
end

RPC.register("fetchPlayersList", function(source) 
    local player = exports['players']:getPlayer(source)
    if not player.admin_level then return end

    local players = {}
    for i,v in pairs (GetPlayers()) do
        table.insert(players, formatSourceForList(v))
    end
    return players
end)

RPC.register("getLevel", function(source)
    local player = exports['players']:getPlayer(source)
    if not player.admin_level then return false end

    return player.admin_level
end)

RPC.register("selectCharacterFromCID", function(source, CID)
    local player = exports['players']:getPlayer(source)
    if not player.admin_level then return false end

    local playerSource = exports['players']:getPlayerWithCID(tonumber(CID))
    if playerSource then
        return formatSourceForList(playerSource)
    else
        local character = sql:executeSync("SELECT pid, first_name, last_name, phone_number FROM characters WHERE cid=?", {CID})[1]
        if not character then return nil end
        local player = sql:executeSync("SELECT steam, display_name, play_time, last_played FROM players WHERE pid=?", {character.pid})[1]
        if not player then return nil end

        return {
            source = nil,
            citizen_id = CID,
            display_name = player.display_name,
            character_name = ("%s %s"):format(character.first_name, character.last_name),
            phone = character.phone_number,
            hex = player.steam,
            play_time = player.play_time,
            last_played = player.last_played
        }
    end

    return nil
end)

RPC.register("giveItem", function(source, amount, itemId, target)
    local player = exports['players']:getPlayer(source)
    if not player.admin_level then return false end

    if (exports['inventory']:getItemData(itemId) and exports['inventory']:addItem(target, itemId, tonumber(amount), false, "ADMIN")) then
        TriggerClientEvent("DoLongHudText", source, ("Gave %s of %s to CID: %s"):format(amount, itemId, target))
        return true
    else
        TriggerClientEvent("DoLongHudText", source, ("Failed to give item"):format(target), "red")
        return false
    end
end)

RPC.register("openClothes", function(source, target)
    local player = exports['players']:getPlayer(source)
    if not player.admin_level then return false end

    local targetChar = exports['players']:getCharacter(target)
    if not targetChar then return end

    TriggerClientEvent("admin:forceOpenClothesMenu", target)
    TriggerClientEvent("DoLongHudText", source, ("Opened clothes menu for %s"):format(target))
    return true
end)

RPC.register("openBarber", function(source, target)
    local player = exports['players']:getPlayer(source)
    if not player.admin_level then return false end

    local targetChar = exports['players']:getCharacter(target)
    if not targetChar then return end

    TriggerClientEvent("admin:forceOpenBarberMenu", target)
    TriggerClientEvent("DoLongHudText", source, ("Opened barber menu for %s"):format(target))
    return true
end)

RPC.register('maxHungerAndThirst', function(source, target)
    local player = exports['players']:getPlayer(source)
    if not player.admin_level then return false end

    local targetChar = exports['players']:getCharacter(target)
    if not targetChar then return end

    TriggerClientEvent("admin:maxHungerAndThirst", target)
    TriggerClientEvent("DoLongHudText", source, ("Successfully maxed %s's hunger and thirst"):format(target))
    return true
end)


RPC.register("giveVehicle", function(source, target, model, plate)
    local player = exports['players']:getPlayer(source)
    if not player.admin_level then return false end

    exports['jp-garages']:AddVehicleToPlayer(model, target.citizen_id)
    TriggerClientEvent("DoLongHudText", source, ("Successfully gave %s to CID: %s"):format(model, target.citizen_id))
    return true
end)

RPC.register("banPlayer", function(source, target, time, reason, secret_reason)
    local player = exports['players']:getPlayer(source)
    if not player.admin_level then return false end

    print ("Ban Time: ".. time)

    if target.source then
        exports['admin']:banPlayerFromSource(target.source, reason, GetPlayerName(source), time, secret_reason)
    else
        local info = sql:executeSync("INSERT INTO bans (steam, length, reason, banner, secret_reason) VALUES (?, ?, ?, ?, ?)", {target.hex, time, reason, GetPlayerName(source), secret_reason})
        if info.warningStatus ~= 0 then
            TriggerClientEvent("DoLongHudText", source, ("Error banning person"))
            return
        end
    end

    TriggerClientEvent("DoLongHudText", source, ("Successfully banned %s for %s seconds. Reason: %s"):format(target.hex, time, reason))

    return true
end)

RPC.register("kickPlayer", function(source, target, reason)
    local player = exports['players']:getPlayer(source)
    if not player.admin_level then return false end

    DropPlayer(target.source, ("Sind kickiti serverist põhjusega: %s"):format(reason))

    TriggerClientEvent("DoLongHudText", source, ("Successfully kicked %s for %s"):format(target.hex, reason))
    return true
end)

RPC.register("unjailPlayer", function(source, target, reason)
    local player = exports['players']:getPlayer(source)
    if not player.admin_level then return false end

    local character = exports['players']:getCharacter(target.source)
    if not character then TriggerClientEvent("DoLongHudText", source, ("%s isn't in the city!"):format(target.hex)) return end

    if character.jail_time <= 0 then TriggerClientEvent("DoLongHudText", source, ("%s isn't in jail!"):format(target.hex)) return end

    exports['players']:modifyPlayerCurrentCharacter(target.source, 'jail_time', 0.1)
    TriggerClientEvent("DoLongHudText", target.source, ("Admin lasi teid varem vanglast välja! Vabanete kohe"), "green", 5000)

    TriggerClientEvent("DoLongHudText", source, ("Successfully unjailed %s"):format(target.hex))
    return true
end)

RPC.register("giveLicense", function(source, target, license)
    print "wtf1"
    local player = exports['players']:getPlayer(source)
    if not player.admin_level then return false end

    print "wtf"
    if not exports['jp-licenses']:GetLicenseId(license) then
        TriggerClientEvent("DoLongHudText", source, ("License %s is invalid!"):format(license), "red")
        return false
    end
    print "wtf2"
    exports['jp-licenses']:addLicense(target.citizen_id, license)
    
    TriggerClientEvent("DoLongHudText", source, ("Successfully gave %s license %s"):format(target.citizen_id, license))
    return true
end)

RPC.register("teleportToPlayer", function(source, target)
    local player = exports['players']:getPlayer(source)
    if not player.admin_level then return false end

    local coords = GetEntityCoords(GetPlayerPed(target))
    SetEntityCoords(GetPlayerPed(source), coords, true, false, false, false)
    return true
end)

RPC.register("bringPlayer", function(source, target)
    local player = exports['players']:getPlayer(source)
    if not player.admin_level then return false end

    local coords = GetEntityCoords(GetPlayerPed(source))
    SetEntityCoords(GetPlayerPed(target), coords, true, false, false, false)
end)

RPC.register("spawnVehicle", function(source, model)
    local player = exports['players']:getPlayer(source)
    if not player.admin_level then return false end

    local coords = GetEntityCoords(GetPlayerPed(source))
    local coords = vector4(coords.x, coords.y, coords.z, GetEntityHeading(GetPlayerPed(source)))

    return exports['jp-garages']:spawnVehiclePersistent(model, coords)
end)

RPC.register("setWeather", function(source, weather)
    return exports['jp-weather']:forceWeather(weather)
end)

RPC.register("noclip", function(source, enable)
    TriggerClientEvent("player_list:hidePlayer", -1, source, enable)

    return true
end)

RPC.register("setTime", function(source, hours)
    hours = tonumber(hours)

    exports['jp-weather']:forceTime(hours)

    return true
end)