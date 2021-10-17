local FACTION_GROUPS = {}
local sql = exports['jp-sql2']

function _fetchFactionGroups()
    local query = [[
        SELECT * FROM _faction_groups
    ]]
    local data = {}
    return sql:executeSync(query, data)
end

function _fetchFactionRanks(faction_id)
    local query = [[
        SELECT id, rank_name, rank_level FROM _faction_ranks WHERE faction_id = ?
    ]]
    local data = {faction_id}
    return sql:executeSync(query, data)
end

function _fetchFactionMembers(faction_id)
    local query = [[
        SELECT * FROM _faction_members WHERE faction_id = ?
    ]]
    local data = {faction_id}
    return sql:executeSync(query, data)
end

function _getRankData(faction_id, rank_name)
    local ranks = _fetchFactionRanks(faction_id)

    local rankData = nil

    for i = 1, #ranks do
        local rank = ranks[i]
        if rank.rank_name == rank_name then
            rankData = {}
            rankData.rank_level = rank.rank_level
            rankData.rank_name = rank.rank_name
            break
        end
    end

    return rankData
end

function getFactionFromName(name)
    for i = 1, #FACTION_GROUPS do
        local group = FACTION_GROUPS[i]
        if group.faction_name == name then return group end
    end
end

function getFactionFromId(id)
    for i = 1, #FACTION_GROUPS do
        local group = FACTION_GROUPS[i]
        if group.faction_id == id then return group end
    end
end

function getPlayerRoleInFaction(faction_id, character_id)
    local query = [[
        SELECT
            _faction_members.faction_id,
            _faction_members.alias,
            _faction_ranks.rank_level,
            _faction_ranks.rank_name 
        FROM
            _faction_members 
        LEFT JOIN
            _faction_ranks 
                ON _faction_ranks.rank_name = _faction_members.rank_name 
        WHERE
            _faction_members.faction_id = ? 
            AND _faction_members.character_id = ?
        GROUP BY _faction_members.character_id, _faction_ranks.rank_name
        ]]
    local data = {faction_id, character_id}

    local playerRoleRaw = sql:executeSync(query, data)
    local playerRole = playerRoleRaw[1]

    if (playerRole and not playerRole.rank_level) then playerRole.rank_level = -1 end
    if (playerRole and not playerRole.rank_name) then playerRole.rank_name = '' end

    return playerRole or false
end

function doFactionLog(faction_id, character_id, action, content)
    local query = [[
        INSERT INTO _faction_logs (faction_id, character_id, action, content)
        VALUES (?, ?, ?, ?)
    ]]
    local data = {faction_id, character_id, action, content}
    sql:execute(query, data)
end

-- ! INFO PAGE
RPC.register("factions:getFactionInfo", function(source)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole then
        TriggerClientEvent("DoLongHudText", source, "Sa ei ole grupeeringus!", 'red')
        return
    end

    local query = [[
        SELECT COUNT(*) AS member_count FROM _faction_members WHERE faction_id=?
    ]]
    local data = {srcRole.group.faction_id}
    local member_count = sql:executeSync(query, data)[1].member_count
    
    local faction = getFactionFromId(srcRole.group.faction_id)

    local factionInfo = {
        faction_name = faction.faction_name,
        member_count = member_count,
        max_members = faction.max_members
    }
    return factionInfo
end)

RPC.register('factions:getFactionMembers', function(source)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole then
        TriggerClientEvent("DoLongHudText", source, "Sa ei ole grupeeringus!", 'red')
        return
    end

    local query = [[
        SELECT
            _faction_members.character_id,
            _faction_members.alias,
            characters.first_name,
            characters.last_name,
            players.last_played,
            _faction_ranks.rank_level,
            _faction_ranks.rank_name         
        FROM
            _faction_members 
        INNER JOIN
            characters 
                ON characters.cid = _faction_members.character_id 
        INNER JOIN
            players 
                ON players.pid = characters.pid 
        LEFT JOIN
            _faction_ranks 
                ON _faction_ranks.rank_name = _faction_members.rank_name
        WHERE
            _faction_members.faction_id = ?
        GROUP BY _faction_ranks.rank_name, _faction_members.character_id
    ]]

    local data = {srcRole.group.faction_id}
    local members = sql:executeSync(query, data)
    local factionMembers = {}

    for i = 1, #members do
        local member = members[i]
        factionMembers[i] = {
            character_id = member.character_id,
            character_name = ("%s %s"):format(member.first_name, member.last_name),
            rank_name = member.rank_name or '',
            rank_level = member.rank_level or -1,
            alias = member.alias,
            lastLive = member.last_played
        }
    end

    return factionMembers
end)

-- ! MEMBER PAGE
RPC.register('factions:removeMember', function(source, target)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole then
        TriggerClientEvent("DoLongHudText", source, "Sa ei ole grupeeringus!", 'red')
        return
    end

    local trgRole = getPlayerFaction(target.cid)

    if (not trgRole or trgRole.group.faction_id ~= srcRole.group.faction_id) then
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
        return
    end

    local isAdmin = (srcRole.member.rank_level >= Permissions.IS_ADMIN)

    if (isAdmin and srcRole.member.rank_level > trgRole.member.rank_level) then
        local query = [[
            DELETE FROM _faction_members WHERE faction_id=? AND character_id=?
        ]]
        local data = {srcRole.group.faction_id, target.cid}
        sql:executeSync(query, data)

        local trgSrc = exports['players']:getPlayerWithCID(target.cid)
        if trgSrc then refreshPlayerFaction(trgSrc) end

        local log = ('CID: %s | Rank: [%s] %s'):format(target.cid, trgRole.member.rank_level, trgRole.member.rank_name)
        doFactionLog(srcRole.group.faction_id, srcChar.cid, 'REMOVE MEMBER', log)

        TriggerClientEvent("DoLongHudText", source, log, 'green')
        return true
    else
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
        return false
    end
end)

RPC.register('factions:setAlias', function(source, target, alias)
    if (alias == '') then
        TriggerClientEvent("DoLongHudText", source, "Sa pead sättima Alias!", 'red')
        return false
    end

    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole then
        TriggerClientEvent("DoLongHudText", source, "Sa ei ole grupeeringus!", 'red')
        return
    end
    
    local trgRole = getPlayerFaction(target.cid)

    if (not trgRole or trgRole.group.faction_id ~= srcRole.group.faction_id) then
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
        return
    end

    local oldAlias = trgRole.member.alias

    local isAdmin = (srcRole.member.rank_level >= Permissions.IS_ADMIN)

    if (isAdmin and srcRole.member.rank_level >= trgRole.member.rank_level) then
        local query = [[
            UPDATE _faction_members
            SET alias=?
            WHERE faction_id=? AND character_id=?
        ]]
        local data = {alias, srcRole.group.faction_id, target.cid}
        sql:executeSync(query, data)

        local trgSrc = exports['players']:getPlayerWithCID(target.cid)
        if trgSrc then refreshPlayerFaction(trgSrc) end

        local log = ('CID: %s | %s => %s'):format(target.cid, oldAlias, alias)
        doFactionLog(srcRole.group.faction_id, srcChar.cid, 'CHANGE MEMBER ALIAS', log)

        TriggerClientEvent("DoLongHudText", source, log, 'green')
        return true
    else
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
        return false
    end
end)

RPC.register('factions:addMember', function(source, trgCid)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole then
        TriggerClientEvent("DoLongHudText", source, "Sa ei ole grupeeringus!", 'red')
        return
    end

    if (trgCid == '') then
        TriggerClientEvent("DoLongHudText", source, "Sa pead valima CID!", 'red')
        return false
    end
    
    trgCid = tonumber(trgCid)

    local trgSrc = exports['players']:getPlayerWithCID(trgCid)

    if not trgSrc then 
        TriggerClientEvent("DoLongHudText", source, "Sellise CID-ga isikut ei ole sees!", 'red')
        return false 
    end

    local trgChar = exports['players']:getCharacter(trgSrc)
    
    if trgChar.faction then
        TriggerClientEvent("DoLongHudText", source, "See isik on juba grupeeringus!", 'red')
        return false
    end

    local isAdmin = (srcRole.member.rank_level >= Permissions.IS_ADMIN)

    if (isAdmin) then
        local query = [[
            INSERT INTO _faction_members (character_id, faction_id)
            VALUES (?, ?)
        ]]

        local data = {trgCid, srcRole.group.faction_id}
        sql:executeSync(query, data)

        if trgSrc then refreshPlayerFaction(trgSrc) end

        local log = ('CID: %s'):format(trgCid)
        doFactionLog(srcRole.group.faction_id, srcChar.cid, 'ADD MEMBER', log)

        TriggerClientEvent("DoLongHudText", source, log, 'green')
        return true
    else
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
        return false
    end
end)

RPC.register('factions:changeRank', function(source, target, rank)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole then
        TriggerClientEvent("DoLongHudText", source, "Sa ei ole grupeeringus!", 'red')
        return
    end

    local rankData = _getRankData(srcRole.group.faction_id, rank)

    local trgRole = getPlayerFaction(target.cid)

    if (not trgRole or trgRole.group.faction_id ~= srcRole.group.faction_id) then
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
        return
    end

    if (not rankData) then
        TriggerClientEvent("DoLongHudText", source, "Sa pead valima ranki!", 'red')
        return false
    end

    local oldRank = ("["..trgRole.member.rank_level.."] "..trgRole.member.rank_name)
    local newRank = ("["..rankData.rank_level.."] "..rankData.rank_name)

    local isAdmin = (srcRole.member.rank_level >= Permissions.IS_ADMIN)
    local isHigherRank = (srcRole.member.rank_level > rankData.rank_level) and (srcRole.member.rank_level > trgRole.member.rank_level)

    if isAdmin and isHigherRank then
        local query = [[
            UPDATE _faction_members
            SET rank_name=?
            WHERE faction_id=? AND character_id=?
        ]]

        local data = {rankData.rank_name, srcRole.group.faction_id, target.cid}
        sql:executeSync(query, data)

        local trgSrc = exports['players']:getPlayerWithCID(target.cid)
        if trgSrc then refreshPlayerFaction(trgSrc) end

        local log = ('CID: %s | %s => %s'):format(target.cid, oldRank, newRank)
        TriggerClientEvent("DoLongHudText", source, log, 'green')
        doFactionLog(srcRole.group.faction_id, srcChar.cid, 'CHANGE MEMBER RANK', log)
        return true
    else
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
        return false
    end
end)

RPC.register('factions:getFactionRanks', function(source)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole then
        TriggerClientEvent("DoLongHudText", source, "Sa ei ole grupeeringus!", 'red')
        return
    end

    return _fetchFactionRanks(srcRole.group.faction_id)
end)

--! RANKS PAGE

RPC.register('factions:addRank', function(source, name, level)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole then
        TriggerClientEvent("DoLongHudText", source, "Sa ei ole grupeeringus!", 'red')
        return
    end

    local level = tonumber(level) or nil
    
    if (not name or string.len(name) < 3 or not level) then
        TriggerClientEvent("DoLongHudText", source, "Sa pead sättima nime ja leveli!", 'red')
        return false
    end

    if (level < 0) then
        TriggerClientEvent("DoLongHudText", source, "Level peab olema kõrgem kui 0!", 'red')
        return false
    end

    local srcChar = exports['players']:getCharacter(source)

    local srcRole = srcChar.faction

    if (not srcRole) then
        TriggerClientEvent("DoLongHudText", source, "Wat", 'red')
        return false
    end

    local isAdmin = (srcRole.member.rank_level >= Permissions.IS_ADMIN)
    local isHigherRank = (srcRole.member.rank_level > level)

    if isAdmin and isHigherRank then
        local query = [[
            SELECT COUNT(*) as amount
            FROM _faction_ranks
            WHERE faction_id=? AND rank_name=?
        ]]

        local queryData = {srcRole.group.faction_id, name}
        local result = sql:executeSync(query, queryData)[1]

        if result.amount > 0 then
            TriggerClientEvent("DoLongHudText", source, "Selle nimega on juba rank olemas!", 'red')
            return false
        end

        local query = [[
            INSERT INTO _faction_ranks (faction_id, rank_name, rank_level)
            VALUES (?, ?, ?)
        ]]

        local queryData = {srcRole.group.faction_id, name, level}
        sql:executeSync(query, queryData)

        local log = ('[%s] %s'):format(level, name)
        doFactionLog(srcRole.group.faction_id, srcChar.cid, 'ADD RANK', log)
        return true
    else
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
        return false
    end
end)

RPC.register('factions:removeRank', function(source, name)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole then
        TriggerClientEvent("DoLongHudText", source, "Sa ei ole grupeeringus!", 'red')
        return
    end

    local rankData = _getRankData(srcRole.group.faction_id, name)

    local isAdmin = (srcRole.member.rank_level >= Permissions.IS_ADMIN)
    local isHigherRank = (srcRole.member.rank_level > rankData.rank_level)

    if isAdmin and isHigherRank then
        local query = [[
            UPDATE _faction_members
            SET rank_name=''
            WHERE rank_name=?
            AND faction_id=?
        ]]

        local queryData = {name, srcRole.group.faction_id}
        sql:executeSync(query, queryData)

        local query = [[
            DELETE FROM _faction_ranks
            WHERE faction_id=? AND rank_name=?
        ]]

        local queryData = {srcRole.group.faction_id, name}
        sql:executeSync(query, queryData)

        local log = ('[%s] %s'):format(rankData.rank_level, rankData.rank_name)
        doFactionLog(srcRole.group.faction_id, srcChar.cid, 'REMOVE RANK', log)

        for i,v in pairs (GetPlayers()) do
            local char = exports['players']:getCharacter(v)
            if char and char.faction then
                if char.faction.member.rank_name == name then
                    refreshPlayerFaction(v)
                end
            end
        end

        return true
    else
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
        return false
    end
end)

RPC.register('factions:changeRankName', function(source, rank, name)
    if (name == '') then
        TriggerClientEvent("DoLongHudText", source, "Sa pead sättima rankile nime!", 'red')
        return false
    end

    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole then
        TriggerClientEvent("DoLongHudText", source, "Sa ei ole grupeeringus!", 'red')
        return
    end

    local rankData = _getRankData(srcRole.group.faction_id, rank.rank_name)

    local isAdmin = (srcRole.member.rank_level >= Permissions.IS_ADMIN)
    local isHigherRank = (srcRole.member.rank_level > rankData.rank_level)

    if isAdmin and isHigherRank then
        local query = [[
            UPDATE _faction_ranks
            SET rank_name=?
            WHERE faction_id=? AND rank_name=?
        ]]

        local queryData = {name, srcRole.group.faction_id, rank.rank_name}
        sql:executeSync(query, queryData)

        local query = [[
            UPDATE _faction_members
            SET rank_name=?
            WHERE rank_name=? AND faction_id=?
        ]]

        local queryData = {name, rank.rank_name, srcRole.group.faction_id}
        sql:executeSync(query, queryData)

        local log = ('%s => %s'):format(rank.rank_name, name)
        doFactionLog(srcRole.group.faction_id, srcChar.cid, 'CHANGE RANK NAME', log)

        for i,v in pairs (GetPlayers()) do
            local char = exports['players']:getCharacter(v)
            if char and char.faction then
                if char.faction.member.rank_name == rank.rank_name then
                    refreshPlayerFaction(v)
                end
            end
        end

        return true
    else
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
        return false
    end
end)

RPC.register('factions:changeRankLevel', function(source, rank, level)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole then
        TriggerClientEvent("DoLongHudText", source, "Sa ei ole grupeeringus!", 'red')
        return
    end

    local level = tonumber(level) or nil

    if (not level) then
        TriggerClientEvent("DoLongHudText", source, "Sa pead sättima leveli!", 'red')
        return false
    end

    if (level < 0) then
        TriggerClientEvent("DoLongHudText", source, "Level peab olema kõrgem kui 0!", 'red')
        return false
    end

    local isAdmin = (srcRole.member.rank_level >= Permissions.IS_ADMIN)
    local isHigherRank = (srcRole.member.rank_level > level) and (srcRole.member.rank_level > rank.rank_level)

    if isAdmin and isHigherRank then
        local query = [[
            UPDATE _faction_ranks
            SET rank_level=?
            WHERE faction_id=? AND rank_name=?
        ]]

        local queryData = {level, srcRole.group.faction_id, rank.rank_name}
        sql:executeSync(query, queryData)

        local log = ('%s => %s'):format(rank.rank_level, level)
        doFactionLog(srcRole.group.faction_id, srcChar.cid, 'CHANGE RANK NAME', log)

        for i,v in pairs (GetPlayers()) do
            local char = exports['players']:getCharacter(v)
            if char and char.faction then
                if char.faction.member.rank_name == rank.rank_name then
                    refreshPlayerFaction(v)
                end
            end
        end

        return true
    else
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
        return false
    end
end)

--! LOGS PAGE
RPC.register('factions:getFactionLogs', function(source)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole then
        TriggerClientEvent("DoLongHudText", source, "Sa ei ole grupeeringus!", 'red')
        return
    end

    local query = [[
        SELECT
            log.id,
            log.character_id,
            log.action,
            log.content,
            log.timestamp,
            characters.first_name,
            characters.last_name
        FROM
            _faction_logs log
        INNER JOIN characters ON characters.cid = log.character_id
        WHERE
            log.faction_id = ?
        ORDER BY log.id DESC
        LIMIT 1000
    ]]

    local data = {srcRole.group.faction_id}
    local logs = sql:executeSync(query, data)
    for i,v in pairs (logs) do
        v.character_name = (v.first_name.." "..v.last_name)
    end
    return logs
end)

--! VEHICLE PAGE

RPC.register('factions:getVehicleOptions', function(source)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole then
        TriggerClientEvent("DoLongHudText", source, "Sa ei ole grupeeringus!", 'red')
        return
    end

    local query = [[
        SELECT id, cost, model 
        FROM _faction_vehicle_options
        WHERE faction_id = ?
    ]]

    local data = {srcRole.group.faction_id}
    local data = sql:executeSync(query, data)
    
    return data
end)

RPC.register('factions:getVehicles', function(source)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole then
        TriggerClientEvent("DoLongHudText", source, "Sa ei ole grupeeringus!", 'red')
        return
    end

    local query = [[
        SELECT *
        FROM vehicles
        WHERE faction=?
    ]]

    local data = {srcRole.group.faction_id}
    local data = sql:executeSync(query, data)
    
    return data
end)

RPC.register('factions:buyVehicle', function(source, id)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole then
        TriggerClientEvent("DoLongHudText", source, "Sa ei ole grupeeringus!", 'red')
        return
    end

    local query = [[
        SELECT *
        FROM _faction_vehicle_options
        WHERE faction_id=? AND id=?
        LIMIT 1
    ]]

    local data = {srcRole.group.faction_id, id}
    local vehOption = sql:executeSync(query, data)[1]

    if vehOption then
        local info = exports['jp-garages']:AddVehicleToFaction(vehOption.model, srcRole.group.faction_id)
        if info.warningStatus == 0 then
            local query = [[
                UPDATE vehicles
                SET mods=?
                WHERE vin=?
            ]]
        
            local data = {vehOption.mods, info.insertId}
            sql:executeSync(query, data)     
        end
    end
    
    local log = ('[$%s] %s'):format(vehOption.cost, vehOption.model)
    doFactionLog(srcRole.group.faction_id, srcChar.cid, 'BUY VEHICLE', log)
    return data
end)

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end
  
function cleanStatsString(stats)
    local tbl = json.decode(stats)

    for i,v in pairs (tbl) do
        if type(v) == 'number' then
            tbl[i] = round(v, 2)
        end
    end

    return json.encode(tbl)
end

RPC.register('factions:tookOutVehicle', function(source, data)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole then
        TriggerClientEvent("DoLongHudText", source, "Sa ei ole grupeeringus!", 'red')
        return false
    end

    local log = ('TAKE VEHICLE OUT - [%s] %s (%s)'):format(data.plate, data.displayName, cleanStatsString(data.stats))
    doFactionLog(srcRole.group.faction_id, srcChar.cid, 'GARAGE', log)

    return true
end)

RPC.register('factions:storedVehicle', function(source, data, stats)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole then
        TriggerClientEvent("DoLongHudText", source, "Sa ei ole grupeeringus!", 'red')
        return false
    end

    local log = ('STORED VEHICLE - [%s] %s (%s)'):format(data.plate, data.model, cleanStatsString(stats))
    doFactionLog(data.faction_id, srcChar.cid, 'GARAGE', log)
    
    return true
end)

RPC.register("unimpound", function(source, car)
    if car.faction == 0 then return false end
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole or srcRole.group.faction_id ~= car.faction then
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha?", 'red')
        return false
    end

    if exports['inventory']:removeItem(source, 'cash', 750) then
        sql:executeSync('UPDATE vehicles SET inGarage=2 WHERE vin=?', {car.vin})

        local log = ('UNIMPOUNDED VEHICLE $750 - [%s] %s'):format(car.plate, car.model)
        doFactionLog(car.faction, srcChar.cid, 'GARAGE', log)    
        TriggerClientEvent("DoLongHudText", source, "Ostsid auto impoundist välja.", 'green')
        return true
    else
        TriggerClientEvent("DoLongHudText", source, "Sul ei ole piisavalt sularaha.", 'red')
        return false
    end
end)

-- ** MISC
function getPlayerFaction(cid)
    local myFaction

    local query = [[
        SELECT faction_id
        FROM _faction_members
        WHERE character_id=?
        LIMIT 1
    ]]
    local queryData = {cid}
    local faction = sql:executeSync(query, queryData)[1]

    if faction then
        local faction_id = faction.faction_id
        myFaction = {}
        
        local factionData = getFactionFromId(faction_id)
        local playerRole = getPlayerRoleInFaction(faction_id, cid)

        myFaction.group = factionData
        myFaction.member = playerRole
    end

    return myFaction
end

exports('getPlayerFaction', getPlayerFaction)

function refreshPlayerFaction(source)
    local character = exports['players']:getCharacter(source)
    if not character then return end

    local fac = getPlayerFaction(character.cid)
    exports['players']:modifyPlayerCurrentCharacter(source, 'faction', fac)
    exports['players']:modifyPlayerCurrentCharacter(source, 'onDuty', false)
end

AddEventHandler('login:server:selectedCharacter', refreshPlayerFaction)

CreateThread(function()
    FACTION_GROUPS = _fetchFactionGroups()
end)

RegisterCommand("factions:forceUpdate", function(source)
    if source == 0 then
        FACTION_GROUPS = _fetchFactionGroups()
    else
        refreshPlayerFaction(source)
    end
end)