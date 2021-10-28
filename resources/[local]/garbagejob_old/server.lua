local players = exports['players']
local events = exports['events']

local trashContainers = {}

events:Register('garbagejob:sv_pickupTrash', function(source, cb, trashId) 
    if not trashContainers[trashId] then trashContainers[trashId] = 0 end

    local timeSinceLast = os.time() - trashContainers[trashId]
    
    if timeSinceLast > 1200 then
        trashContainers[trashId] = os.time()
        cb(true)
    else
        TriggerClientEvent('DoLongHudText', source, 'Se on tühi.', 'red')
        cb(false)
    end
end)