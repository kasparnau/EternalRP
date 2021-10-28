local events = exports['events']
local sql = exports['jp-sql2']

local lastAction = {}

events:RegisterServerCallback("jobs:doAction", function(source, cb, pointId)
    local character = exports['players']:getCharacter(source)
    if not character then return end

    if not lastAction[source] then lastAction[source] = 0 end
    if (os.time() - lastAction[source]) < 0.5 then
        print "Hacker"
    else
        local point = jobPoints[character.job][pointId]
        if jobPoints[character.job][pointId] then
            if point.addItem then
                local str = ('NPC JOB - '..character.job)
                if point.removeItem then
                    if exports['inventory']:canCarryItem(source, point.addItem.itemId, point.addItem.qty) then
                        if exports['inventory']:removeItem(source, point.removeItem.itemId, point.removeItem.qty, false, str) then
                            exports['inventory']:addItem(source, point.addItem.itemId, point.addItem.qty, false, str)
                        end
                    else
                        TriggerClientEvent("DoLongHudText", source, "Sul pole piisavalt ruumi!", 'green')
                    end
                else
                    exports['inventory']:addItem(source, point.addItem.itemId, point.addItem.qty, false, str)
                end
            end

            lastAction[source] = os.time()
        end
    end
end)

RPC.register("chooseJob", function(source, job)
    local character = exports['players']:getCharacter(source)

    exports['players']:modifyPlayerCurrentCharacter(source, "job", job)
    sql:executeSync('UPDATE characters SET job=? WHERE cid=?', {job, character.cid})

    TriggerClientEvent("DoLongHudText", source, "Sa võtsid töökoha! Oma praegust töökohta saad näha telefonist, 'Detailid' appist.", 'green', 5000)
    return true
end)