local sql = exports['jp-sql2']

function getPlayerLicenses(citizen_id)
    local licenses

    local query = [[
        SELECT id, license_id
        FROM _licenses
        WHERE citizen_id=?
    ]]
    
    local queryData = {citizen_id}
    local result = sql:executeSync(query, queryData)
    local licenses = {}

    for i,v in pairs (result) do
        table.insert(licenses, {license_id = v.license_id, license_name = GetLicenseName(v.license_id) or "Unknown", id = v.id})
    end

    return licenses 
end

function addLicense(citizen_id, license)
    local license_id = type(license) == 'number' and license or GetLicenseId(license)
    if not license_id then return false end

    local data = {citizen_id, license_id}
    local result = sql:executeSync('INSERT INTO _licenses(citizen_id, license_id) VALUES (?, ?)', data)

    local source = exports['players']:getPlayerWithCID(citizen_id)
    if source then
        refreshPlayerLicenses(source)
    end

    return result.warningStatus == 0
end

function removeLicense(citizen_id, license_id)
    local data = {citizen_id, license_id}
    local result = sql:executeSync('DELETE FROM _licenses WHERE citizen_id=? and id=?', data)

    local source = exports['players']:getPlayerWithCID(citizen_id)
    if source then
        refreshPlayerLicenses(source)
    end

    return result.warningStatus == 0
end

function refreshPlayerLicenses(source)
    local character = exports['players']:getCharacter(source)
    local licenses = getPlayerLicenses(character.cid)
    exports['players']:modifyPlayerCurrentCharacter(source, 'licenses', licenses)
end

AddEventHandler('login:server:selectedCharacter', refreshPlayerLicenses)


exports('addLicense',  addLicense)
exports('removeLicense', removeLicense)
exports('getPlayerLicenses', getPlayerLicenses)
