local events = exports['events']
events:RegisterServerCallback('cuffs:cuff', function(source, cb, target, playerHeading, playerCoords, playerLocation, hard)
    TriggerClientEvent('handcuffs:cuff', target, playerHeading, playerCoords, playerLocation, hard)
    cb(true)
end)
events:RegisterServerCallback('cuffs:uncuff', function(source, cb, target, playerHeading, playerCoords, playerLocation)
    TriggerClientEvent('handcuffs:uncuff', target, playerHeading, playerCoords, playerLocation)
    cb(true)
end)

events:RegisterServerCallback('cuffs:makeHard', function(source, cb, target, hard)
    TriggerClientEvent('handcuffs:makeHard', target, hard)
    cb(true)
end)