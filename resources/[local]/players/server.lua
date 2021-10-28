--[[
Player.getPlayer(steam) --> in cache
    {
        "pid" = 7,  
        "etc" = 0,
    } 
    CACHE ALL THAT

Player.getCharacter(cid, callback) --> find character in database
    {
        "cid" = 1,
        "owner" = 7,
        "bank" = {"cash" = 5000, "bank" = 0},
        "pos" = {"x", "y", "z"},
        "etc" = 0,
    }

Player.getVehicle(vin, callback) --> find vehicle in database
    {
        "vin" = 1,
        "owner" = 7,
        "model" = "Anus",
        "garage" = 3,
        "mods" = {}
    }

]]

local Cache = {}
Cache.Players = {}
Cache.Characters = {}

local admin = exports['admin']
local sql = exports['jp-sql2']

function getPlayerDataFromSource(source)
    local steam = exports['admin']:getSteam(source)
    if not steam then return false end

    return Cache.Players[steam] or false
end

exports("getPlayerDataFromSource", getPlayerDataFromSource)
exports("getPlayer", getPlayerDataFromSource)

function _setPlayerDataFromSource(source, data)
    Cache.Players[data.steam] = data
end
exports('_setPlayerDataFromSource', _setPlayerDataFromSource)

function getPlayerCurrentCharacter(source)
    local plr = exports['players']:getPlayerDataFromSource(source)
    if not plr then return false end

    return Cache.Characters[plr.pid] or false
end
exports("getPlayerCurrentCharacter", getPlayerCurrentCharacter)
exports("getCharacter", getPlayerCurrentCharacter)

exports("modifyPlayerCurrentCharacter", function(source, value, data)
    local pid = exports['players']:getPlayerDataFromSource(source).pid

    Cache.Characters[pid][value] = data
    TriggerClientEvent("players:networkCharacterVar", source, value, data)
end)

--

exports("setPlayerCurrentCharacter", function(source, charData)
    if not exports['players']:getPlayerDataFromSource(source) then
        DropPlayer(source, "hmmmm out of sync??? ytle klicerile kui juhtub")
    end
    local pid = exports['players']:getPlayerDataFromSource(source).pid

    Cache.Characters[pid] = charData
end)

local trackPlaytime = {}

AddEventHandler('login:server:selectedCharacter', function(source)
    if not trackPlaytime[source] then
        trackPlaytime[source] = os.time()

        local pData = getPlayerDataFromSource(source)
        local query = [[
            UPDATE players
            SET last_played=?
            WHERE pid=?
        ]]

        sql:execute(query, {os.time(), pData.pid})
    end
end)

AddEventHandler('playerDropped', function()
    if trackPlaytime[source] then
        local pData = getPlayerDataFromSource(source)
        local timePlayed = (os.time() - trackPlaytime[source])

        local query = [[
            UPDATE players
            SET play_time=+?, last_played=?
            WHERE pid=?
        ]]
        sql:execute(query, {pData.play_time+timePlayed, os.time(), pData.pid})

        trackPlaytime[source] = nil
    end
end)

function getPlayerWithCID(cid)
    if not cid then return end
    if type(cid) == 'string' then cid = tonumber(cid) end
    for i,v in pairs (GetPlayers()) do
        local char = getPlayerCurrentCharacter(v)
        if char and char.cid == cid then
            return v
        end
    end
    return false
end
exports('getPlayerWithCID', getPlayerWithCID)

---* IF RESTARTED
CreateThread(function()
    for i,v in pairs (GetPlayers()) do
        local steam = admin:getSteam(v)
        local query = [[
            SELECT players.*, admins.level AS admin_level FROM players LEFT JOIN admins ON admins.hex=players.steam WHERE players.steam=? LIMIT 1
        ]]
        local data = {steam}
        local result = sql:executeSync(query, data)[1]
        _setPlayerDataFromSource(v, result)
    end
end)