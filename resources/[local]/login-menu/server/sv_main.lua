local sql = exports['jp-sql2']
local admin = exports['admin']

function RegisterPlayerData(source)
    local license = admin:getLicense(source)
    local license2 = admin:getLicense2(source)
    local steam = admin:getSteam(source)

    local query = [[
        SELECT players.*, admins.level AS admin_level FROM players LEFT JOIN admins ON admins.hex=players.steam WHERE players.steam=? LIMIT 1
    ]]
    local queryData = {steam}
    local result = sql:executeSync(query, queryData)[1]

    if not result then        
        local query = [[
            INSERT INTO players (license, license2, steam, display_name) 
            VALUES (?, ?, ?, ?)
        ]]
        local queryData = {license, license2, steam, GetPlayerName(source)}
        local info = sql:executeSync(query, queryData)

        if (info.warningStatus == 0) then
            local query = [[
                SELECT * FROM players
                WHERE pid=?    
            ]]
            local queryData = {info.insertId}
            local newData = sql:executeSync(query, queryData)[1]
            exports['players']:_setPlayerDataFromSource(source, newData)
            return newData
        else
            DropPlayer(source, 'Failed creating data?')
        end        
    else
        exports['players']:_setPlayerDataFromSource(source, result)
        return result
    end
end

RPC.register('login:fetchCharacters', function(source)
    local data = exports['players']:getPlayerDataFromSource(source) or RegisterPlayerData(source)

    local display_name = GetPlayerName(source)
    if display_name ~= data.display_name then
        sql:execute([[UPDATE players SET display_name=? WHERE pid=?]], {display_name, data.pid})
    end

    local query = [[
        SELECT
            cid AS character_id,
            first_name,
            last_name,
            gender,
            dob as date_of_birth,
            phone_number,
            dead,
            outfit
        FROM characters
        WHERE pid=?
    ]]

    local queryData = {data.pid}
    local result = sql:executeSync(query, queryData)

    for i,v in pairs(result) do
        v.faction = exports['jp-factions']:getPlayerFaction(v.character_id)
        v.character_name = (v.first_name.." "..v.last_name)

        v.dead = v.dead == 1 and true or nil
        v.prison = false
    end

    return result
end)

function getUniquePhoneNumber()
    local number = ""
    for i = 1,7 do
        number = (number..tostring(math.random(1,9)))
    end

    local query = [[
        SELECT COUNT(*) AS amount
        FROM characters
        WHERE phone_number=?
    ]]
    local queryData = {number}
    local amount = sql:executeSync(query, queryData)[1].amount
    if amount == 0 then
        return tonumber(number)
    else
        return getUniquePhoneNumber()
    end
end

RPC.register('login:createCharacter', function(source, pData)
    local data = exports['players']:getPlayerDataFromSource(source)

    if not data then
        return false
    end

    local char = sql:executeSync('SELECT COUNT(*) as count FROM characters WHERE CONCAT(first_name, " ", last_name)=?', {pData.first_name.." "..pData.last_name})
    local existing = char and char[1].count > 0 or false

    if existing then
        TriggerClientEvent("DoLongHudText", source, "See nimi on juba võetud!", 'red')
        return false
    end

    local phone_number = getUniquePhoneNumber()
    pData.gender = pData.gender == 'male' and 0 or 1

    --* NEW CHARACTER ROW
    local query = [[
        INSERT INTO characters (pid, first_name, last_name, gender, dob, phone_number)
        VALUES (?, ?, ?, ?, ?, ?)
    ]]

    local queryData = {data.pid, pData.first_name, pData.last_name, pData.gender, pData.born, phone_number}

    local info = sql:executeSync(query, queryData)
    if (info.warningStatus ~= 0) then
        return false
    end

    --* CONSTRUCT DEFAULT INVENTORY
    local inventory = {
        ['7'] = {
            ["itemId"] = "phone",
            ["qty"] = 1,
        },
        ['9'] = {
            ["itemId"] = "citizen-card",
            ["qty"] = 1,
            ["metadata"] = {
                ['Full Name'] = (pData.first_name.." "..pData.last_name),
                ['Citizen ID'] = info.insertId,
                ['Date of Birth'] = pData.born,
                ['Sex'] = pData.gender == 0 and "Male" or "Female"
            }
        }
    }

    local query = [[
        UPDATE characters
        SET inventory=?
        WHERE cid=?
    ]]
    
    local queryData =  {json.encode(inventory), info.insertId}
    sql:executeSync(query, queryData)

    --* GENERATE BANK ACCOUNT
    local query = [[
        INSERT INTO bank_accounts (character_id, account_name)
        VALUES (?, ?)
    ]]

    local queryData = {info.insertId, 'Personal Account'}
    sql:executeSync(query, queryData)

    return true
end)

RPC.register('login:selectCharacter', function(source, citizen_id)
    local data = exports['players']:getPlayerDataFromSource(source)
    if not data then return false end

    local query = [[
        SELECT * FROM characters 
        WHERE pid=? AND cid=? LIMIT 1
    ]]

    local queryData = {data.pid, citizen_id}

    local result = sql:executeSync(query, queryData)
    if (result[1]) then
        print ("^5[Login]^7 | PID: "..data.pid.." | License: "..data.license.." | Selected Character: "..result[1].cid)
        exports['players']:setPlayerCurrentCharacter(source, result[1])
        SetPlayerRoutingBucket(source, 0)

        TriggerEvent("login:server:selectedCharacter", source, result[1])
        
        return result[1]
    else
        return false
    end

    return true
end)

RPC.register("inMenu", function(source)
    if exports['players']:getCharacter(source) then
        exports['players']:setPlayerCurrentCharacter(source, nil)
    end
    SetPlayerRoutingBucket(source, 1)
end)