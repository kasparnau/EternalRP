local playerPropertyList = {}
local sql = exports['jp-sql2']

RPC.register("housing:getCurrentOwned", function(pSource)
    local character = exports['players']:getCharacter(pSource)
    if not character then return {} end

    local query = [[
        SELECT property_id 
        FROM _housing_properties 
        WHERE owner=?
    ]]
    local queryData = {character.cid}
    local owned = sql:executeSync(query, queryData)
    
    playerPropertyList[pSource] = owned

    return owned
end)

local currentLockdown = {}
RPC.register("housing:getCurrentLockdown", function(pSource)
    return currentLockdown
end)

local currentBeingRobbed = {}
local robLocations = {}

RPC.register('housing:getCurrentBeingRobbed', function(pSource)
    return currentBeingRobbed
end)

RPC.register("housing:lockpickProperty", function(pSource, propertyId)
    if not currentBeingRobbed[propertyId] then
        currentBeingRobbed[propertyId] = true
        CreateThread(function()
            Wait(1000*60*30) --* 30 MINUTES?
            currentBeingRobbed[propertyId] = nil
            robLocations[propertyId] = nil
            TriggerClientEvent("currentBeingRobbed", -1, currentBeingRobbed)
        end)
    end

    TriggerClientEvent("currentBeingRobbed", -1, currentBeingRobbed)
    return currentBeingRobbed[propertyId]
end)

--[[
    function GenerateRobLocations(propertyId)
        local locations = {}

        local model = Housing.info[propertyId].model
        for i,v in pairs (Housing.robInformation.staticLocations[model].staticPositions) do
            table.insert(locations, i)
        end

        return locations
    end
]]

function GenerateRobLocations(propertyId)
    local locations = {}

    local model = Housing.info[propertyId].model
    local data = Housing.robInformation.staticLocations[model]
    if not data then return {} end

    local max = data.maxLocations

    local available = {}
    for i,v in pairs (Housing.robInformation.staticLocations[model].staticPositions) do
        v.id = i
        table.insert(available, v)
    end

    for i = 1, max do
        local rand = math.random(1, #available)
        local chosen = available[rand].id
        table.insert(locations, chosen)
        table.remove(available, rand)
    end

    return locations
end

RPC.register('jp-housing:getRobLocations', function(pSource, propertyId)
    if not robLocations[propertyId] then
        robLocations[propertyId] = GenerateRobLocations(propertyId)
    end
    return robLocations[propertyId]
end)

function chooseRandomItems(itemOptions)
    local maxItemsToGet = itemOptions.maxItems
    local items = {}

    for i = 1, maxItemsToGet do
        local chanceSum = 0

        for i,v in pairs (itemOptions.items) do
            chanceSum = chanceSum + v.chance
        end
    
        math.randomseed(os.clock()+(i*13))
        local selection = math.random(1, chanceSum)

        local found = false
        for k,v in pairs (itemOptions.items) do
            if not found then
                selection = selection - v.chance
                if (selection <= 0) then
                    found = true
                    table.insert(items, v)
                end
            end
        end
    end

    return items
end

RPC.register('jp-housing:robLocation', function(pSource, propertyId, locationId)
    local found = false
    for i,v in pairs (robLocations[propertyId]) do
        if v == locationId then
            found = true

            local thing = robLocations[propertyId][i]
            table.remove(robLocations[propertyId], i)
            
            local model = Housing.info[propertyId].model
            local staticLocation = Housing.robInformation.staticLocations[model]
    
            local itemOptions = Housing.robCat[staticLocation.staticPositions[locationId].itemCat]
            local items = chooseRandomItems(itemOptions)
    
            for i,v in pairs (items) do
                exports['inventory']:addItem(pSource, v.name, 1)
            end    
        end
    end

    if not found then
        TriggerClientEvent('DoLongHudText', pSource, "Selles kohas pole midagi!", 'red')
    end

    TriggerClientEvent("jp-housing:updateRobLocations", -1, propertyId, robLocations[propertyId])

    return true
end)

function doesPlayerOwnProperty(pSource, propertyId)
    if not playerPropertyList[pSource] then return false end
    for i,v in pairs (playerPropertyList[pSource]) do
        if v.property_id == propertyId then
            return true
        end
    end
    return false
end

RPC.register("housing:toggleLock", function(pSource, propertyId)
    if doesPlayerOwnProperty(pSource, propertyId) then
        if currentLockdown[propertyId] == nil then
            currentLockdown[propertyId] = false
        elseif currentLockdown[propertyId] == false then
            currentLockdown[propertyId] = true
        elseif currentLockdown[propertyId] == true then
            currentLockdown[propertyId] = false
        end
        TriggerClientEvent("updateLockdown", -1, currentLockdown)
    else
        print 'DOESNT EVEN OWN?'
    end

    return currentLockdown[propertyId]
end)

AddEventHandler("login:server:selectedCharacter", function(source)
    TriggerClientEvent("jp-housing:forceUpdate", source)
end)