local sql = exports['jp-sql2']

RPC.register('mdt:fetchDashboardPage', function(pSource)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole or (srcRole and not WhitelistedFactions[srcRole.group.faction_name]) then
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
    end

    local result = {}

    local query = [[
            SELECT id, citizen_id, reason, last_update, characters.first_name, characters.last_name
            FROM _mdt_warrants
            INNER JOIN characters ON characters.cid = citizen_id
            WHERE enabled=1
        ]]
    local warrantsRaw = sql:executeSync(query, {})
    local warrants = {}
    for i,v in pairs (warrantsRaw) do
        table.insert(warrants, {
            id = v.id,
            timestamp = v.last_update,
            character_id = v.citizen_id,
            character_name = (v.first_name.." "..v.last_name),
            reason = v.reason
        })
    end

    local query = [[
        SELECT id, timestamp, title, description
        FROM _mdt_bulletins
    ]]
    local bulletins = sql:executeSync(query, {})

    result.bulletins = bulletins
    result.warrants = warrants

    return result
end)

RPC.register('mdt:getProfileResults', function(pSource, queryStr)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole or (srcRole and not WhitelistedFactions[srcRole.group.faction_name]) then
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
    end

    local results = {}

    local query = [[
            SELECT cid, first_name, last_name 
            FROM characters
            WHERE CONCAT(first_name, " ", last_name) LIKE ?
        ]]
    local queryStr = ("%"..queryStr.."%")
    local queryData = {queryStr}

    local resp = sql:executeSync(query, queryData)

    for i,v in pairs (resp) do
        local parsed = {
            character_id = v.cid,
            character_name = (v.first_name.." "..v.last_name)
        }
        table.insert(results, parsed)
    end

    return results
end)

function parsePriors(priorsData)
    local priorsRaw = {}
    local priors = {}

    for i,v in pairs (priorsData) do
        for i,name in pairs (json.decode(v.charges)) do
            priorsRaw[name] = priorsRaw[name] and priorsRaw[name] + 1 or 1
        end
    end

    for i,v in pairs (priorsRaw) do
        table.insert(priors, {name = i, count = v})
    end

    return priors
end

RPC.register('mdt:fetchProfileData', function(pSource, character_id)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole or (srcRole and not WhitelistedFactions[srcRole.group.faction_name]) then
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
    end

    local result

    local query = [[
        SELECT characters.cid, characters.first_name, characters.last_name, characters.dob, _mdt_profile_data.profile_image_url, _mdt_profile_data.description
        FROM characters
        LEFT JOIN _mdt_profile_data
            ON _mdt_profile_data.citizen_id = characters.cid
        WHERE cid=?
        GROUP BY _mdt_profile_data.citizen_id, characters.cid
    ]]
    local queryData = {character_id}
    local resp = sql:executeSync(query, queryData)[1]

    if resp then
        result = {}

        result.character_id = resp.cid
        result.born = resp.dob
        result.character_name = (resp.first_name.." "..resp.last_name)
        result.profile_image_url = resp.profile_image_url or ''
        result.description = resp.description or nil

        local plrFaction = exports['jp-factions']:getPlayerFaction(resp.cid)
        if plrFaction then
            result.faction_name = plrFaction.group.faction_name
        end

        local warrant = sql:executeSync('SELECT id, reason, last_update FROM _mdt_warrants WHERE citizen_id=? AND enabled=1 ORDER BY last_update DESC', {character_id})[1]
        if warrant then
            result.warrant = warrant
        end

        local data = sql:executeSync('SELECT charges FROM _mdt_charges WHERE citizen_id=?', {character_id})
        result.priors = parsePriors(data)

        result.licenses = exports['jp-licenses']:getPlayerLicenses(character_id)

        result.vehicles = sql:executeSync('SELECT plate, model FROM vehicles WHERE cid=?', {character_id})
        result.housing = sql:executeSync('SELECT property_id FROM _housing_properties WHERE owner=?', {character_id})
    end

    return result
end)

RPC.register('mdt:updateProfile', function(pSource, character_id, data)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole or (srcRole and not WhitelistedFactions[srcRole.group.faction_name]) then
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
    end

    local query = [[
        SELECT profile_image_url, description
        FROM _mdt_profile_data
        WHERE citizen_id=?
    ]]
    local queryData = {character_id}

    local existingProfileData = sql:executeSync(query, queryData)[1]
    local updated_by = srcChar.cid

    if existingProfileData then
        local query = [[
            UPDATE _mdt_profile_data
            SET profile_image_url=?, description=?, updated_by=?
            WHERE citizen_id=?
        ]]

        sql:executeSync(query, {data.profile_image_url, data.description, updated_by, character_id})
        return true
    else
        local query = [[
            INSERT INTO _mdt_profile_data (citizen_id, profile_image_url, description, updated_by)
            VALUES (?, ?, ?, ?)
        ]]    

        sql:executeSync(query, {character_id, data.profile_image_url, data.description, updated_by})
        return true
    end

    return true
end)

RPC.register('mdt:makeWanted', function(pSource, character_id, reason)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole or (srcRole and not WhitelistedFactions[srcRole.group.faction_name]) then
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
    end

    local query = [[
        INSERT INTO _mdt_warrants (citizen_id, reason)
        VALUES (?, ?)
    ]]
    local queryData = {character_id, reason}

    sql:executeSync(query, queryData)

    return true
end)

RPC.register('mdt:removeWarrant', function(pSource, character_id)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole or (srcRole and not WhitelistedFactions[srcRole.group.faction_name]) then
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
    end

    local query = [[
        UPDATE _mdt_warrants
        SET enabled=0
        WHERE citizen_id=?
    ]]
    local queryData = {character_id}

    sql:executeSync(query, queryData)

    return true
end)

RPC.register('mdt:getVehicleResults', function(pSource, queryStr)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole or (srcRole and not WhitelistedFactions[srcRole.group.faction_name]) then
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
    end

    local results = {}

    local query = [[
            SELECT plate, model, vin
            FROM vehicles
            WHERE plate LIKE ?
        ]]

    local queryStr = ("%"..queryStr.."%")
    local queryData = {queryStr}

    local resp = sql:executeSync(query, queryData)

    return resp
end)

RPC.register('mdt:getVehicleData', function(pSource, vin)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole or (srcRole and not WhitelistedFactions[srcRole.group.faction_name]) then
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
    end

    local query = [[
        SELECT vehicles.cid AS owner_id, model, plate, created_at, 
        CONCAT(characters.first_name, ' ', characters.last_name) AS owner_name
        FROM vehicles
        LEFT JOIN characters ON characters.cid = vehicles.cid
        WHERE vin=?
        GROUP BY characters.cid, vehicles.cid
        LIMIT 1
    ]]

    local queryData = {vin}

    local data = sql:executeSync(query, queryData)

    local vehicle = data[1]
    vehicle.vin = vin
    
    return vehicle
end)

RPC.register('mdt:chargePlayer', function(pSource, citizen_id, charges, totalFine, totalJail)
    local srcChar = exports['players']:getCharacter(pSource)
    local srcRole = srcChar and srcChar.faction

    local samePerson = false and srcChar.cid == citizen_id
    if not srcRole or not WhitelistedFactions[srcRole.group.faction_name] or samePerson then
        TriggerClientEvent("DoLongHudText", pSource, "Sa ei saa seda teha!", 'red')
        return false
    end

    local trgSrc = exports['players']:getPlayerWithCID(citizen_id)
    if trgSrc then
        local dist = #(GetEntityCoords(GetPlayerPed(pSource)) - GetEntityCoords(GetPlayerPed(trgSrc)))
        if (dist > 10.0) then
            TriggerClientEvent("DoLongHudText", pSource, "See isik on liiga kaugel!", 'red')
            return false
        end
    else
        TriggerClientEvent("DoLongHudText", pSource, "See isik pole linnas!", 'red')
        return false
    end

    -- add charges to mdt
    local query = [[
        INSERT INTO _mdt_charges(citizen_id, charges, totalFine, totalJail, issued_by) 
        VALUES(?, ?, ?, ?, ?)
    ]]

    local queryData = {citizen_id, json.encode(charges), totalFine, totalJail, srcChar.cid}
    sql:executeSync(query, queryData)
    
    -- put in prison
    exports['players']:modifyPlayerCurrentCharacter(trgSrc, 'jail_time', totalJail)

    local query = [[
        UPDATE characters SET jail_time=? WHERE cid=?
    ]]
    local queryData = {totalJail, citizen_id}
    sql:executeSync(query, queryData)
    
    TriggerClientEvent("DoLongHudText", pSource, "Isikut karistati edukalt!", 'green')
    return true
end)

RPC.register("mdt:removeLicense", function(pSource, citizen_id, license_id)
    local srcChar = exports['players']:getCharacter(source)
    local srcRole = srcChar and srcChar.faction

    if not srcRole or not WhitelistedFactions[srcRole.group.faction_name] then
        TriggerClientEvent("DoLongHudText", source, "Sa ei saa seda teha!", 'red')
        return false
    end

    if srcRole.member.rank_level < 90 then
        TriggerClientEvent("DoLongHudText", source, "Sa ei ole piisavalt kõrge auaste et seda teha!", 'red')
        return false
    end

    return exports['jp-licenses']:removeLicense(citizen_id, license_id)
end)