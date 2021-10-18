function getLicense(src)
    for k,v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 7) == "license" then
            return v
        end
    end
end

function getLicense2(src)
    for k,v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 8) == "license2" then
            return v
        end
    end
end

function getSteam(src)
    for k,v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 5) == "steam" then
            return v
        end
    end
end

function getDiscord(src)
    for k,v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 7) == "discord" then
            return v
        end
    end
end

function getFivem(src)
    for k,v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 5) == "fivem" then
            return v
        end
    end
end

function getIp(src)
    for k,v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 2) == "ip" then
            return v
        end
    end
end

function getIdentifier(src, identifier)
    for k,v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len(identifier)) == identifier then
            return v
        end
    end
end

exports('getLicense', getLicense)
exports('getLicense2', getLicense2)
exports('getSteam', getSteam)
exports('getDiscord', getDiscord)
exports('getFivem', getFivem)
exports('getIp', getIp)

exports('getIdentifier', getIdentifier)

local BanDB = {}
local Date = getDate()
local sql = exports['jp-sql2']

local function ToInteger(number)
    if type(number) ~= "number" then return 315569520 end
    return math.floor(tonumber(number) + 0.5 or 315569520)
end

exports("checkBanFromSource", function(source)
    local license = getLicense(source) or ''
    local license2 = getLicense2(source) or ''
    local steam = getSteam(source) or ''
    local discord = getDiscord(source) or ''
    local fivem = getFivem(source) or ''

    local query = [[
        SELECT * FROM bans
        WHERE license=? OR license2=? OR steam=? OR discord=? OR fivem=?
    ]]
    local data = {license, license2, steam, discord, fivem}
    local result = sql:executeSync(query, data)

    for i=1,#result do
        local ban = result[i]
        if ban.enabled == 1 and ban.date + ban.length > os.time() then
            return ban
        end
    end
    
    return false
end)

exports("banPlayerFromSource", function(player, reason, banner, length, secret_reason)
    print "TRIED TO BAN"
    if true then return end

    local license, license2, steam, discord, fivem, source
    if type(player) == "table" then
        license = player.license
        license2 = playear.license
        steam = player.steam
        discord = player.discord
        fivem = player.fivem
        source = player.source
    else
        license = getLicense(player) or ""
        license2 = getLicense2(player) or ""
        steam = getSteam(player) or ""
        discord = getDiscord(player) or ""
        fivem = getFivem(player) or ""
        source = player
    end

    length = ToInteger(length)
    reason = reason or "Unknown"
    banner = banner or "Unknown"
    secret_reason = secret_reason or "Unknown, banned from source"

    local query = [[
        INSERT INTO bans (license, license2, steam, discord, fivem, length, reason, banner, secret_reason)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]]
    local queryData = {license, license2, steam, discord, fivem, length, reason, banner, secret_reason}
    sql:execute(query, queryData)
    
    if source ~= nil then 
        DropPlayer(source, "Sind keelustati serverist. Reconnecti lisainfo jaoks.")
    else
        for _,v in pairs (GetPlayers()) do
            local xLicense2 = getLicense2(v)
            if xLicense2 == license2 then
                DropPlayer(source, "Sind keelustati serverist. Reconnecti lisainfo jaoks.")
            end
        end    
    end
end)

-- -- ANTICHEAT
-- local blockedItems = {
--     [`blimp3`] = true,
--     [`blimp2`] = true,
--     [`blimp`] = true,
-- }

-- local alreadySent = {}

-- local spawnedEntitiesIn10s = {}
-- AddEventHandler('entityCreating', function(entity)
--     local model = GetEntityModel(entity)
--     if blockedItems[model] then
--         local source = NetworkGetEntityOwner(entity)
--         if source > 0 then
--             spawnedEntitiesIn10s[source] = spawnedEntitiesIn10s[source] and spawnedEntitiesIn10s[source] + 1 or 1
--             CreateThread(function()
--                 Wait(5*1000)
--                 spawnedEntitiesIn10s[source] = spawnedEntitiesIn10s[source] - 1
--             end)
--             if spawnedEntitiesIn10s[source] >= 15 then
--                 if alreadySent[license] then return end
--                 alreadySent[license] = true
--                 exports['admin']:banPlayerFromSource(source, "Automaatne Ban - Cheating", "System", 2592000, "Entity creation spam")
--             end
--         end
--         CancelEvent()
--     end
-- end)

-- local explosionsIn10s = {}
-- AddEventHandler('explosionEvent', function(sender, ev)
--     sender = tonumber(sender)
--     if sender > 0 then
--         local license = exports['admin']:getLicense(sender)
--         print ("License: "..license.. " | "..sender)
--         explosionsIn10s[sender] = explosionsIn10s[sender] and explosionsIn10s[sender] + 1 or 1
--         print ("Explosions: "..explosionsIn10s[sender])

--         CreateThread(function()
--             Wait(5*1000)
--             explosionsIn10s[sender] = explosionsIn10s[sender] - 1
--         end)
--         if explosionsIn10s[sender] >= 15 then
--             if alreadySent[license] then return end
--             alreadySent[license] = true
--             exports['admin']:banPlayerFromSource(sender, "Automaatne Ban - Cheating", "System", 2592000, "Explosion event spam")
--         end
--     end
--     CancelEvent()
-- end)
-- --[[
-- local x,y,z = table.unpack(GetEntityCoords(PlayerPedId())) 
-- AddExplosion(x+1, y+1, z+1, 4, 100.0, true, false, 0.0)
-- ]]

