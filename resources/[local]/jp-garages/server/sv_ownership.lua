local sql = exports['jp-sql2']

local letters = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Y', 'Z'}
for i = 0, 9 do
    table.insert(letters, i)
end

function GenerateUniquePlate()
    local plate = ""
    for i = 1,8 do
        plate = (plate..letters[math.random(1, #letters)])
    end

    local query = [[
        SELECT COUNT(*) AS amount
        FROM vehicles
        WHERE plate=?
    ]]

    local queryData = {plate}
    local amount = sql:executeSync(query, queryData)[1].amount

    if amount == 0 then
        return plate
    else
        return GenerateUniquePlate()
    end
end

function AddVehicle(model, cid, faction)
    local query = [[
        INSERT INTO vehicles (cid, faction, model, plate)
        VALUES (?, ?, ?, ?)
    ]]

    local plate = GenerateUniquePlate()
    local queryData = {cid, faction, model, plate}
    local info = sql:executeSync(query, queryData)

    return info
end

function AddVehicleToPlayer(model, cid)
    return AddVehicle(model, cid, 0)
end

function AddVehicleToFaction(model, faction_id)
    return AddVehicle(model, 0, faction_id)
end

exports('AddVehicleToPlayer', AddVehicleToPlayer)
exports('AddVehicleToFaction', AddVehicleToFaction)