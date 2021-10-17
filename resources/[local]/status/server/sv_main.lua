local sql = exports['jp-sql2']

RegisterNetEvent("status:updateStatus")
AddEventHandler("status:updateStatus", function(health, armor, thirst, hunger)
    local character = exports['players']:getCharacter(source)
    if character then
        local status = json.decode(character.status)
        local newStatus = {
            health = health or status.health,
            armor = armor or status.armor,
            thirst = thirst or status.thirst,
            hunger = hunger or status.hunger
        }
        local newStatus = json.encode(newStatus)
        exports['players']:modifyPlayerCurrentCharacter(source, 'status', newStatus)
        sql:executeSync('UPDATE characters SET status=? WHERE cid=?', {newStatus, character.cid})
    end
end)

RegisterNetEvent("status:updatePos")
AddEventHandler("status:updatePos", function(data)
    local character = exports['players']:getCharacter(source)
    if character then
        sql:executeSync('UPDATE characters SET position=? WHERE cid=? ', {json.encode(data), character.cid})
    end
end)