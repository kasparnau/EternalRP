local events = exports['events']
local players = exports['players']
local sql = exports['jp-sql2']

local currentDrops = {} --// FOR SENDING DROPS TO NEW PLAYERS

local MAX_PLAYER_WEIGHT = 250

exports("getItemList", function()
    return itemsList or {}
end)

function getItemData(itemId)
    local result = itemsList[itemId] and itemsList[itemId] or false
    if result and result.isWeapon then result.nonStackable = true end
    return result
end
exports('getItemData', getItemData)

function doInventoryLog(cid, orig_inv_type, orig_inv_id, dest_inv_type, dest_inv_id, log_type, item_id, item_amount, content)
    if not content then content = '' end

    -- local query = [[
    --     INSERT INTO _inventory_log (citizen_id, orig_inv_type, orig_inv_id, dest_inv_type, dest_inv_id, log_type, item_id, item_amount, content)
    --     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    -- ]]
    -- local data = {cid, orig_inv_type, orig_inv_id, dest_inv_type, dest_inv_id, log_type, item_id, item_amount, content}
    -- if #data < 9 then
    --     return false
    -- end
    -- sql:execute(query, data)
    if log_type ~= 'MOVE' then
        local query = [[
            INSERT INTO inventory_economy (citizen_id, action, item_id, item_qty, content)
            VALUES (?, ?, ?, ?, ?)
        ]]
        local queryData = {cid, log_type, item_id, item_amount, content}
        sql:execute(query, queryData)
    end
end

local invInfos = {
    ['player']   = {slots = 50,  weight = 250},
    ['glovebox'] = {slots = 5,   weight = 50}, 
    ['drop']     = {slots = 60,  weight = 1000},
    ['locker']   = {slots = 120, weight = 5000},
    ['custom']   = {slots = 20,  weight = 1000},
    ['stash']    = {slots = 100, weight = 1000},
}

local inventorys = {
    ["player"] = {},
    ['glovebox'] = {},
    ['plyglovebox'] = {},
    ['trunk'] = {},
    ['plytrunk'] = {},
    ['drop'] = {},
    ['locker'] = {},
    ['shop'] = {},
    ['housestash'] = {}
}

function canStackItem(item)
    local stack = true
    if itemsList[item].isWeapon then stack = false end
    if itemsList[item].nonStackable then stack = false end
    return stack
end

function ItemToFullItem(item, slot)
    local stack = canStackItem(item.itemId)

    local x = {
        id = item.itemId,
        itemId = item.itemId,
        qty = item.qty,
        slot = tonumber(slot),
        label = itemsList[item.itemId].label or "Undefined",
        max = 2e9,
        stackable = stack,
        nonUsable = itemsList[item.itemId].nonUsable,
        description = itemsList[item.itemId].description,
        metadata = item.metadata or {},
        hiddenMeta = item.hiddenMeta or {},
        canRemove = itemsList[item.itemId].canRemove or true,
        price = item.price or 0,
        closeUi = itemsList[item.itemId].closeUi or true,
        isWeapon = itemsList[item.itemId].isWeapon or false,
        dontRemoveOnUse = itemsList[item.itemId].dontRemoveOnUse or false,
        weight = itemsList[item.itemId].weight or 0
    }
    return x
end

function GetDisplayInventory(rawInventory)
    local itemsObject = {}
    local RawInventory = rawInventory

    for k, v in pairs(RawInventory) do
        if itemsList[v.itemId] then
            local item = ItemToFullItem(v, k)
            if item.qty > 0 then
                itemsObject[#itemsObject+1] = item
            end
        end
    end

    return itemsObject
end

local InventorysOpened = {}

local saveRecents = {}

local saveFunctions = {
    ['locker'] = function(invId)
        local inventory = inventorys['locker'][tostring(invId)]
        if inventory == nil then return end
        updateInventorys('locker', invId)
        
        local saveLockerInventoryId = [[
            UPDATE lockers SET inventory=? WHERE owner=?
        ]]

        sql:execute(saveLockerInventoryId, {json.encode(inventory), invId})
    end,
    ['player'] = function(invId)
        local inventory = inventorys['player'][tostring(invId)]
        if inventory == nil then return end

        updateInventorys('player', invId)

        saveRecents['player-'..invId] = saveRecents['player-'..invId] and saveRecents['player-'..invId] + 1 or 1
        local old = saveRecents['player-'..invId]
        CreateThread(function()
            Wait(5) -- TO PREVENT SAVING MANY TIMES WHEN ADDING MULTIPLE ITEMS FAST USING ADDITEM
            if old == saveRecents['player-'..invId] then
                local savePlayerInventoryId = [[
                    UPDATE characters SET inventory=? WHERE cid=?
                ]]
                
                sql:execute(savePlayerInventoryId, {json.encode(inventory), invId})
            end
        end)
    end,
    ['plyglovebox'] = function(invId)
        local inventory = inventorys['plyglovebox'][tostring(invId)]
        if inventory == nil then return end

        updateInventorys('plyglovebox', invId)

        local saveGloveboxInventoryId = [[
            UPDATE vehicles SET glovebox=? WHERE vin=?
        ]]
        
        sql:execute(saveGloveboxInventoryId, {json.encode(inventory), invId})
    end,
    ['plytrunk'] = function(invId)
        local inventory = inventorys['plytrunk'][tostring(invId)]
        if inventory == nil then return end

        updateInventorys('plytrunk', invId)

        local saveTrunkInventoryId = [[
            UPDATE vehicles SET trunk=? WHERE vin=?
        ]]
        
        sql:execute(saveTrunkInventoryId, {json.encode(inventory), invId})
    end,
    ['housestash'] = function(invId)
        local inventory = inventorys['housestash'][tostring(invId)]
        if inventory == nil then return end

        updateInventorys('housestash', invId)

        local query = [[
            UPDATE _housing_properties SET stash=? WHERE property_id=?
        ]]
        
        sql:execute(query, {json.encode(inventory), invId})
    end,
    ['drop'] = function(invId)
        local inventory = inventorys['drop'][tostring(invId)]
        if inventory == nil then return end
        updateInventorys('drop', invId)

        local children = 0
        for i,v in pairs (inventory) do children = children + 1 end
        if children == 0 then
            currentDrops[tostring(invId)] = nil
            TriggerClientEvent("inventory:removeDrop", -1, invId)
        end
    end,
    ['glovebox'] = function(invId)
        updateInventorys('glovebox', invId)
    end,
    ['trunk'] = function(invId)
        updateInventorys('trunk', invId)
    end
}

AddEventHandler('playerDropped', function(reason)
    local source = source
    local character = players:getCharacter(source)
    if character then
        local cid = character.cid
        saveFunctions['player'](cid)

        if InventorysOpened[source] then
            InventorysOpened[source] = nil
        end
    end
end)

function getInventoryWeight(source)
    local character = players:getCharacter(source)
    local inventory = inventorys['player'][tostring(character.cid)]

    local totalWeight = 0

    for i = 1, invInfos['player'].slots do
        if inventory[tostring(i)] then
            totalWeight = totalWeight + (inventory[tostring(i)].qty * itemsList[inventory[tostring(i)].itemId].weight)
        end
    end

    return totalWeight
end

exports('getInventoryWeight', getInventoryWeight)

function canCarryItem(source, pItemId, pAmount)
    local character = players:getCharacter(source)
    local inventory = inventorys['player'][tostring(character.cid)]

    local totalWeight = getInventoryWeight(source)

    local freeSlots = 0
    local existing = false

    for i = 1, invInfos['player'].slots do
        if not inventory[tostring(i)] then
            freeSlots = freeSlots + 1
        elseif inventory[tostring(i)] and inventory[tostring(i)].itemId == pItemId then
            existing = true
        end
    end

    local pItemWeight = (itemsList[pItemId].weight*pAmount)
    return (totalWeight+pItemWeight <= MAX_PLAYER_WEIGHT) and (freeSlots > 0 or existing)
end

function hasEnoughOfItem(source, itemId, amount)
    local character = players:getCharacter(source)

    local inventory = inventorys['player'][tostring(character.cid)]

    local quantity = 0
    for i,v in pairs (inventory) do
        if v.itemId == itemId then
            quantity = quantity + v.qty
        end
    end

    return (quantity >= amount)
end

function amountOfItem(source, itemId)
    local character = players:getCharacter(source)
    local inventory = inventorys['player'][tostring(character.cid)]

    local quantity = 0
    for i,v in pairs (inventory) do
        if v.itemId == itemId then
            quantity = quantity + v.qty
        end
    end

    return quantity
end    

function getInventory(source)
    local character = players:getCharacter(source)
    local inventory = inventorys['player'][tostring(character.cid)]

    return inventory
end

exports('getInventory', getInventory)

function beingViewed(inv)
    for plr,v in pairs (InventorysOpened) do
        for j, k in pairs (v) do
            if k == inv then
                return true
            end
        end
    end
    return false
end

exports('beingViewed', beingViewed)

function updateInventorys(owner, id)
    id = tostring(id)

    if owner == 'player' then
        for i,v in pairs (GetPlayers()) do
            local character = exports['players']:getCharacter(v)
            if character then
                if tostring(character.cid) == id then
                    inventorys['player'][tostring(character.cid)] = inventorys['player'][tostring(character.cid)] or {}
                    TriggerClientEvent('inventory:updateMain', v, GetDisplayInventory(inventorys['player'][tostring(character.cid)]))
                end
            end
        end
    end

    for plr,v in pairs (InventorysOpened) do
        local character = exports['players']:getCharacter(plr)
        if character then
            for j, k in pairs (v) do
                if k == (owner..'-'..id) then
                    if owner ~= 'player' or (owner == 'player' and tostring(character.cid) ~= id) then
                        TriggerClientEvent('inventory:updateSecondary', plr, GetDisplayInventory(inventorys[owner][id]))
                    end

                end
            end
        else
            InventorysOpened[v] = nil
        end
    end
end

function removeItem(source, itemId, amount, skipSave)
    local character = players:getCharacter(source)
    local inventory = inventorys['player'][tostring(character.cid)]

    if not hasEnoughOfItem(source, itemId, amount) then return false end

    local amountLeft = amount
    for i,v in pairs (inventory) do
        if v.itemId == itemId then
            if v.qty >= amountLeft then
                v.qty = v.qty - amountLeft
                if v.qty == 0 then inventory[i] = nil end

                saveFunctions['player'](tostring(character.cid))

                local alert = {
                    item = {label = itemsList[itemId].label, itemId = itemId},
                    qty = amount,
                    message = 'Eemaldatud',
                }

                TriggerClientEvent("inventory:showItemsReceived", source, {[1] = alert})
                doInventoryLog(character.cid, 0, 0, 'player', character.cid, 'REMOVE ITEM', itemId, amount)
                return true
            else
                amountLeft = amountLeft - v.qty
                inventory[i] = nil
            end
        end
    end
end

local currentDropId = 0
function makeDrop(player)
    currentDropId = currentDropId + 1
    local dropId = currentDropId

    local coords = GetEntityCoords(GetPlayerPed(player))

    currentDrops[tostring(dropId)] = coords
    TriggerClientEvent("inventory:addDrop", -1, dropId, coords)
    return dropId
end
exports('makeDrop', makeDrop)

events:RegisterServerCallback("inventory:makeDrop", function(source, cb)
    local dropId = makeDrop(source)
    cb(dropId)
end)

function addItem(source, itemId, amount, metas, reason)
    local character = players:getCharacter(source)
    local inventory = inventorys['player'][tostring(character.cid)]

    if not inventory or not canCarryItem(source, itemId, amount) then 
        TriggerClientEvent("DoLongHudText", source, "Sul polnud piisavalt ruumi ja midagi kukkus maha!", 'red', 5000)

        local drop = makeDrop(source)
        inventorys['drop'][tostring(drop)] = {['1'] = {qty = amount, itemId = itemId}}
        doInventoryLog(character.cid, 0, 0, 'player', character.cid, '[ERROR] ADD ITEM FAIL | DROPPED TO GROUND', itemId, amount, reason)
        return false 
    end

    local itemData = getItemData(itemId)

    local stackable = canStackItem(itemId)

    local amountLeft = amount
    for i = 1, invInfos['player'].slots do
        if not inventory[tostring(i)] then
            local amountToAddHere = not stackable and 1 or amountLeft
            inventory[tostring(i)] = {
                itemId = itemId,
                qty = amountToAddHere
            }
            if metas and metas.metadata then inventory[tostring(i)].metadata = metas.metadata end
            if metas and metas.hiddenMeta then inventory[tostring(i)].hiddenMeta = metas.hiddenMeta end
            amountLeft = amountLeft - amountToAddHere
        elseif inventory[tostring(i)].itemId == itemId and stackable then
            local amountToAddHere = amountLeft

            inventory[tostring(i)].qty = inventory[tostring(i)].qty + amountToAddHere
            amountLeft = amountLeft - amountToAddHere
        end
        if amountLeft <= 0 then
            saveFunctions['player'](tostring(character.cid))

            local alert = {
                item = {label = itemsList[itemId].label, itemId = itemId},
                qty = amount,
                message = 'Said',
            }

            TriggerClientEvent("inventory:showItemsReceived", source, {[1] = alert})
            doInventoryLog(character.cid, 0, 0, 'player', character.cid, 'ADD ITEM', itemId, amount, reason)
            return true
        end
    end

    return false
end

RPC.register("inventory:useItemFromSlot", function(pSource, pData)
    if pData.owner == 'shop' then return false end

    local inventory = inventorys[pData.owner][tostring(pData.id)]

    local itemAtSlot = inventory[tostring(pData.slot)]
    if itemAtSlot and itemAtSlot.itemId == pData.item.itemId then
        if itemAtSlot.qty >= 1 then
            if not itemsList[itemAtSlot.itemId].dontRemoveOnUse then
                itemAtSlot.qty = itemAtSlot.qty - 1
                if itemAtSlot.qty == 0 then
                    inventory[tostring(pData.slot)] = nil
                end

                if saveFunctions[pData.owner] then saveFunctions[pData.owner](tostring(pData.id)) end
            end

            local character = exports['players']:getCharacter(source)
            doInventoryLog(character.cid, pData.owner, pData.id, 0, 0, 'USE ITEM', itemAtSlot.itemId, 1)
            return true
        else
            itemAtSlot = nil

            if saveFunctions[pData.owner] then saveFunctions[pData.owner](tostring(pData.id)) end
            return false
        end
    else --* IF NOT IN SLOT, JUST REMOVE FROM ANY SLOT
        return removeItem(source, pData.item.itemId, 1)
    end
end)

RegisterNetEvent("closeInventory")
AddEventHandler("closeInventory", function()
    local source = source
    local sourceChar = exports['players']:getCharacter(source)
    if InventorysOpened[source] then
        for _,v in pairs (InventorysOpened[source]) do
            local owner = string.split(v, "-")[1]
            local id = string.split(v, "-")[2]
    
            if saveFunctions[owner] then
                saveFunctions[owner](id)
            end
        end
        InventorysOpened[source] = nil
    end
end)

events:RegisterServerCallback("inventory:getCID", function(source, cb, target)
    local cid = players:getCharacter(target).cid
    cb(cid)
end)

events:RegisterServerCallback("inventory:getInventory", function(source, cb, inventoryType, inventoryId, dontOpen, extras)
    local character = exports['players']:getCharacter(source)

    if not dontOpen then
        for i,v in pairs (InventorysOpened) do
            for i,v in pairs (v) do
                if v == (inventoryType.."-"..inventoryId) then
                    cb(false)
                    return
                end
            end
        end
    end

    if not dontOpen then
        InventorysOpened[source] = InventorysOpened[source] or {}
        InventorysOpened[source][#InventorysOpened[source]+1] = (inventoryType.."-"..inventoryId)
    end

    local displayInv = {}
    local slotType = 'player'
    
    local slots = invInfos[inventoryType] and invInfos[inventoryType].slots or 0
    local maxWeight = invInfos[inventoryType] and invInfos[inventoryType].weight or 0
    
    if inventoryType == "player" then        
        if inventorys[inventoryType][tostring(inventoryId)] then
            displayInv = GetDisplayInventory(inventorys[inventoryType][tostring(inventoryId)])
        else
            local result = sql:executeSync('SELECT inventory FROM characters WHERE cid=? LIMIT 1', {inventoryId})
            if not result[1] or result[1] == "null" then result[1] = '{}' end

            inventorys[inventoryType][tostring(inventoryId)] = json.decode(result[1].inventory)
            displayInv = GetDisplayInventory(inventorys[inventoryType][tostring(inventoryId)])
        end
    elseif inventoryType == "glovebox" then
        inventorys[inventoryType][tostring(inventoryId)] = inventorys[inventoryType][tostring(inventoryId)] or {}
        displayInv = GetDisplayInventory(inventorys[inventoryType][tostring(inventoryId)])
    elseif inventoryType == "plyglovebox" then
        slots = invInfos['glovebox'].slots
        maxWeight = invInfos['glovebox'].weight

        if inventorys[inventoryType][tostring(inventoryId)] then
            displayInv = GetDisplayInventory(inventorys[inventoryType][tostring(inventoryId)])
        else
            local query = [[
                SELECT glovebox FROM vehicles WHERE vin=? LIMIT 1
            ]]
            local result = sql:executeSync(query, {inventoryId})

            if not result[1] or result[1] == "null" then result[1] = '{}' end

            inventorys[inventoryType][tostring(inventoryId)] = json.decode(result[1].glovebox)
            displayInv = GetDisplayInventory(inventorys[inventoryType][tostring(inventoryId)])
        end
    elseif inventoryType == "trunk" then
        slots = 50
        maxWeight = extras.slots or 0

        inventorys[inventoryType][tostring(inventoryId)] = inventorys[inventoryType][tostring(inventoryId)] or {}
        displayInv = GetDisplayInventory(inventorys[inventoryType][tostring(inventoryId)])
    elseif inventoryType == "plytrunk" then
        slots = 50
        maxWeight = extras.slots or 0

        if inventorys[inventoryType][tostring(inventoryId)] then
            displayInv = GetDisplayInventory(inventorys[inventoryType][tostring(inventoryId)])
        else
            local query = [[
                SELECT trunk FROM vehicles WHERE vin=? LIMIT 1
            ]]
            local result = sql:executeSync(query, {inventoryId})
            if not result[1] or result[1] == "null" then result[1] = '{}' end
            inventorys[inventoryType][tostring(inventoryId)] = json.decode(result[1].trunk)
            displayInv = GetDisplayInventory(inventorys[inventoryType][tostring(inventoryId)])
        end
    elseif inventoryType == "drop" then
        inventorys[inventoryType][tostring(inventoryId)] = inventorys[inventoryType][tostring(inventoryId)] or {}
        displayInv = GetDisplayInventory(inventorys[inventoryType][tostring(inventoryId)])
    elseif inventoryType == "locker" then
        if inventorys[inventoryType][tostring(inventoryId)] then
            displayInv = GetDisplayInventory(inventorys[inventoryType][tostring(inventoryId)])
        else
            local query = [[
                SELECT inventory FROM lockers WHERE owner=? LIMIT 1
            ]]
            local result = sql:executeSync(query, {inventoryId})
            if not result[1] or result[1] == "null" then result[1] = '{}' end
            inventorys[inventoryType][tostring(inventoryId)] = json.decode(result[1].inventory)
            displayInv = GetDisplayInventory(inventorys[inventoryType][tostring(inventoryId)])
        end
    elseif inventoryType == "shop" then
        slots = #shops[inventoryId]
        maxWeight = 0
        
        local temp = {}
        for i,v in pairs (shops[inventoryId]) do
            v.qty = 999999

            local itemData = exports['inventory']:getItemData(v.itemId)

            if itemData.isWeapon then
                local issuer = "Unknown"
                if inventoryId == 1 then issuer = 'LSPD' elseif inventoryId == 2 then issuer = "Ammunation" end
                v.metadata = {['Välja Antud'] = (character.first_name.." "..character.last_name), ['Välja Andnud'] = issuer, ['Päeval Antud'] = os.date("%x")}
            end
            temp[tostring(i)] = v
        end
        inventorys[inventoryType][tostring(character.cid).."/"..tostring(inventoryId)] = temp

        displayInv = GetDisplayInventory(shops[inventoryId])
    elseif inventoryType == 'housestash' then
        slots = invInfos['stash'].slots
        maxWeight = invInfos['stash'].weight

        if inventorys[inventoryType][tostring(inventoryId)] then
            displayInv = GetDisplayInventory(inventorys[inventoryType][tostring(inventoryId)])
        else
            local query = [[
                SELECT stash FROM _housing_properties WHERE property_id=? LIMIT 1
            ]]
            local result = sql:executeSync(query, {inventoryId})
            if not result[1] or result[1] == "null" then result[1] = '{}' end

            inventorys[inventoryType][tostring(inventoryId)] = json.decode(result[1].stash)
            displayInv = GetDisplayInventory(inventorys[inventoryType][tostring(inventoryId)])
        end
    else
        slots = invInfos['custom'].slots
        maxWeight = invInfos['custom'].weight
        
        inventorys[inventoryType] = inventorys[inventoryType] or {}
        inventorys[inventoryType][tostring(inventoryId)] = inventorys[inventoryType][tostring(inventoryId)] or {}

        displayInv = GetDisplayInventory(inventorys[inventoryType][tostring(inventoryId)])
    end

    cb({
        items = displayInv,
        invType = inventoryType, 
        id = inventoryId,
        invSlots = slots,
        maxWeight = maxWeight
    })
end)

RegisterNetEvent('death:respawned')
AddEventHandler('death:respawned', function()
    local source = source
    local cid = players:getCharacter(source).cid
    for plr,v in pairs (InventorysOpened) do
        for i,v in pairs (v) do
            if v == ("player-"..cid) then
                TriggerClientEvent('inventory:forceClose', plr, {})
            end
        end
    end

    local canReset = false
    while not canReset do
        local found = false

        for plr,v in pairs (InventorysOpened) do
            for i,v in pairs (v) do
                if v == ("player-"..cid) then
                    found = true
                end
            end
        end

        if not found then canReset = true end
        Wait(100)
    end

    if inventorys['player'][tostring(cid)] then
        inventorys['player'][tostring(cid)] = {}
    end

    saveFunctions['player'](tostring(cid))
end)

RegisterNetEvent("inventory:server:requestDrops")
AddEventHandler("inventory:server:requestDrops", function()
    TriggerClientEvent("inventory:addDropsInitial", source, currentDrops)
end)

function shopCheck(source, data)
    local character = exports['players']:getCharacter(source)
    if not character then return false end

    if data.destinationOwner == 'shop' then
        return false
    elseif data.originOwner == 'shop' then
        local inventoryOriginId = data.originId

        data.originId = tostring(character.cid.."/"..data.originId)
        local origInv = inventorys[data.originOwner][tostring(data.originId)]
        local item = origInv[tostring(data.originSlot)]

        data.moveQty = data.moveQty or 0
        if data.moveQty <= 0 then
            if data.moveQty < 0 then
                doInventoryLog(character.cid, data.originOwner, data.originId, data.destinationOwner, data.destinationId, "[ERROR] DUPLICATE ATTEMPT", item.itemId, data.moveQty)
            end
            return false
        end

        if inventoryOriginId == 2 then --//WEAPON SHOP
            local licenses = character.licenses
            local canBuy
            for _,v in pairs (licenses) do
                if v.license_id == 2 then --// WEAPON'S LICENSE
                    canBuy = true
                    break
                end
            end
            if not canBuy then
                TriggerClientEvent("DoLongHudText", source, "Sul pole relvaluba!", "red")
                return
            end
        elseif inventoryOriginId == 1 then --//LSPD SHOP
            if not character.faction or character.faction.group.faction_name ~= "LSPD" then
                exports['admin']:banPlayerFromSource(source, "Automaatne Ban - Cheating", "System", 7776000, ("Tried to buy from LSPD shop. Faction: %s"):format(json.encode(character.faction)))
            end
        end

        if not item.price or item.price < 0 or not data.moveQty then return false end
        local totalCost = item.price * data.moveQty

        if exports['inventory']:hasEnoughOfItem(source, "cash", totalCost) then
            doInventoryLog(character.cid, data.originOwner, data.originId, data.destinationOwner, data.destinationId, "SHOP PURCHASE", item.itemId, data.moveQty, totalCost)

            CreateThread(function()
                if not exports['inventory']:removeItem(source, 'cash', totalCost) then
                    doInventoryLog(character.cid, data.originOwner, data.originId, data.destinationOwner, data.destinationId, "[ERROR] SHOP PURCHASE FAIL", item.itemId, data.moveQty, totalCost)
                    exports['inventory']:removeItem(source, item.itemId, data.moveQty)    
                end
            end)

            return true
        else
            TriggerClientEvent('DoLongHudText', source, "Sul pole piisavalt raha selle jaoks!", 'red')
            return false
        end
    else
        return true
    end
end

function isSameInventory(data)
    local destInv = inventorys[data.destinationOwner][tostring(data.destinationId)]
    local origInv = inventorys[data.originOwner][tostring(data.originId)]

    return (data.destinationOwner.."-"..tostring(data.destinationId)) == (data.originOwner.."-"..tostring(data.originId))
end

events:RegisterServerCallback('inventory:MoveToEmpty', function(source, cb, data)
    if not shopCheck(source, data) then cb(false) return end

    local destInv = inventorys[data.destinationOwner][tostring(data.destinationId)]
    local origInv = inventorys[data.originOwner][tostring(data.originId)]

    if destInv[tostring(data.destinationSlot)] ~= nil or origInv[tostring(data.originSlot)] == nil then cb(false) return end
    
    if not isSameInventory(data) then
        local item = origInv[tostring(data.originSlot)]
        doInventoryLog(exports['players']:getCharacter(source).cid, data.originOwner, data.originId, data.destinationOwner, data.destinationId, "MOVE", item.itemId, item.qty)
    end

    destInv[tostring(data.destinationSlot)] = origInv[tostring(data.originSlot)]
    origInv[tostring(data.originSlot)] = nil

    cb(true)
end)

events:RegisterServerCallback('inventory:SwapItems', function(source, cb, data)
    if not shopCheck(source, data) then cb(false) return end

    local destInv = inventorys[data.destinationOwner][tostring(data.destinationId)]
    local origInv = inventorys[data.originOwner][tostring(data.originId)]

    if destInv[tostring(data.destinationSlot)] == nil or origInv[tostring(data.originSlot)] == nil then cb(false) return end

    if not isSameInventory(data) then
        local item = origInv[tostring(data.originSlot)]
        doInventoryLog(exports['players']:getCharacter(source).cid, data.originOwner, data.originId, data.destinationOwner, data.destinationId, "MOVE", item.itemId, item.qty)
    end

    local tempItem = destInv[tostring(data.destinationSlot)]
    destInv[tostring(data.destinationSlot)] = origInv[tostring(data.originSlot)]
    origInv[tostring(data.originSlot)] = tempItem

    if not isSameInventory(data) then
        doInventoryLog(exports['players']:getCharacter(source).cid, data.destinationOwner, data.destinationId, data.originOwner, data.originId, "MOVE", tempItem.itemId, tempItem.qty)
    end

    cb(true)
end)

events:RegisterServerCallback('inventory:EmptySplitStack', function(source, cb, data)
    if not shopCheck(source, data) then cb(false) return end

    local destInv = inventorys[data.destinationOwner][tostring(data.destinationId)]
    local origInv = inventorys[data.originOwner][tostring(data.originId)]

    local item = origInv[tostring(data.originSlot)]

    if data.moveQty < 0 then
        local character = exports['players']:getCharacter(source)
        doInventoryLog(character.cid, data.originOwner, data.originId, data.destinationOwner, data.destinationId, "[ERROR] DUPLICATE ATTEMPT", item.itemId, data.moveQty)
        cb(false)
        return
    end

    if destInv[tostring(data.destinationSlot)] ~= nil then cb(false) return end
    if origInv[tostring(data.originSlot)].qty < data.moveQty then cb(false) return end

    origInv[tostring(data.originSlot)].qty = origInv[tostring(data.originSlot)].qty - data.moveQty
    
    destInv[tostring(data.destinationSlot)] = {
        itemId = item.itemId,
        qty = data.moveQty,
        metadata = item.metadata,
        hiddenMeta = item.hiddenMeta
    }

    if not isSameInventory(data) then
        local item = origInv[tostring(data.originSlot)]
        doInventoryLog(exports['players']:getCharacter(source).cid, data.originOwner, data.originId, data.destinationOwner, data.destinationId, "MOVE", item.itemId, data.moveQty)
    end

    cb(true)
end)

events:RegisterServerCallback('inventory:SplitStack', function(source, cb, data)
    if not shopCheck(source, data) then cb(false) return end
    local destInv = inventorys[data.destinationOwner][tostring(data.destinationId)]
    local origInv = inventorys[data.originOwner][tostring(data.originId)]

    local item = origInv[tostring(data.originSlot)]

    if data.moveQty < 0 then
        local character = exports['players']:getCharacter(source)
        doInventoryLog(character.cid, data.originOwner, data.originId, data.destinationOwner, data.destinationId, "[ERROR] DUPLICATE ATTEMPT", item.itemId, data.moveQty)
        cb(false)
        return
    end

    if origInv[tostring(data.originSlot)].itemId ~= destInv[tostring(data.destinationSlot)].itemId then cb(false) return end

    if origInv[tostring(data.originSlot)].qty < data.moveQty then cb(false) return end
    origInv[tostring(data.originSlot)].qty = origInv[tostring(data.originSlot)].qty - data.moveQty
    destInv[tostring(data.destinationSlot)].qty = destInv[tostring(data.destinationSlot)].qty + data.moveQty

    if not isSameInventory(data) then
        local item = origInv[tostring(data.originSlot)]
        doInventoryLog(exports['players']:getCharacter(source).cid, data.originOwner, data.originId, data.destinationOwner, data.destinationId, "MOVE", item.itemId, data.moveQty)
    end

    cb(true)
end)

events:RegisterServerCallback('inventory:CombineStack', function(source, cb, data)
    if not shopCheck(source, data) then cb(false) return end
    local destInv = inventorys[data.destinationOwner][tostring(data.destinationId)]
    local origInv = inventorys[data.originOwner][tostring(data.originId)]

    if origInv[tostring(data.originSlot)].itemId ~= destInv[tostring(data.destinationSlot)].itemId then cb(false) return end

    if not isSameInventory(data) then
        local item = origInv[tostring(data.originSlot)]
        doInventoryLog(exports['players']:getCharacter(source).cid, data.originOwner, data.originId, data.destinationOwner, data.destinationId, "MOVE", item.itemId, origInv[tostring(data.originSlot)].qty)
    end

    local newQty = origInv[tostring(data.originSlot)].qty + destInv[tostring(data.destinationSlot)].qty
    origInv[tostring(data.originSlot)] = nil
    destInv[tostring(data.destinationSlot)].qty = newQty   
    
    cb(true)
end)

events:RegisterServerCallback('inventory:TopoffStack', function(source, cb, data)
    cb(false)
    --! DEPRECATED, NOW CAN HAVE INFINITE AMOUNT OF ITEM IN 1 SLOT
    -- if not shopCheck(source, data) then cb(false) return end

    -- local destInv = inventorys[data.destinationOwner][tostring(data.destinationId)]
    -- local origInv = inventorys[data.originOwner][tostring(data.originId)]

    -- if origInv[tostring(data.originSlot)].itemId ~= destInv[tostring(data.destinationSlot)].itemId then cb(false) return end
    
    -- destInv[tostring(data.destinationSlot)].qty = data.destinationItem.qty     
    -- origInv[tostring(data.originSlot)].qty = data.originItem.qty

    -- cb(true)
end)

RPC.register("inventory:removeItem", function(pSource, pItemId, pAmount)
    if pAmount < 0 then
        DropPlayer(pSource, "wow..")
        return false
    end
    if pAmount == 0 then return true end

    return exports['inventory']:removeItem(pSource, pItemId, pAmount)
end)

exports('removeItem', removeItem) --* itemId, qty
exports('addItem', addItem) --* item (table)

exports('hasEnoughOfItem', hasEnoughOfItem) --* itemId, qty
exports('amountOfItem', amountOfItem) --* itemId
exports('canCarryItem', canCarryItem) --* itemId, amount

function string.split(s, sep)
    local fields = {}
    
    local sep = sep or " "
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(s, pattern, function(c) fields[#fields + 1] = c end)
    
    return fields
end

local ammoCache = {}

function getPlayerAmmo(source)
    local char = exports['players']:getCharacter(source)
    return ammoCache[char.cid] or {}
end

function refreshPlayerAmmo(source)
    local char = exports['players']:getCharacter(source)
    local ammo = sql:executeSync('SELECT hash, ammo FROM _weapon_ammo WHERE citizen_id=?', {char.cid})
    TriggerClientEvent("inventory:weapons:refreshAmmo", source, ammo)

    ammoCache[char.cid] = {}
    for i,v in pairs (ammo) do
        ammoCache[char.cid][tostring(v.hash)] = {
            hash = v.hash,
            ammo = v.ammo
        }
    end
end

AddEventHandler('login:server:selectedCharacter', refreshPlayerAmmo)

RegisterNetEvent("inventory:weapons:requestAmmo")
AddEventHandler("inventory:weapons:requestAmmo", function()
    refreshPlayerAmmo(source)
end)

RegisterNetEvent("inventory:weapons:updateAmmo")
AddEventHandler("inventory:weapons:updateAmmo", function(hash, new)
    local char = exports['players']:getCharacter(source)

    if ammoCache[char.cid][tostring(hash)] then
        -- * UPDATE EXISTING
        ammoCache[char.cid][tostring(hash)].ammo = new

        CreateThread(function()
            Wait(5000)
            if ammoCache[char.cid][tostring(hash)].ammo == new then
                sql:executeSync('UPDATE _weapon_ammo SET ammo=? WHERE hash=? AND citizen_id=?', {new, hash, char.cid})
            end
        end)
    else
        ammoCache[char.cid][tostring(hash)] = {
            hash = hash,
            ammo = new
        }
        sql:executeSync('INSERT INTO _weapon_ammo (citizen_id, hash, ammo) VALUES (?, ?, ?)', {char.cid, hash, new})
    end
end)

RegisterNetEvent("inventory:weapons:addAmmo")
AddEventHandler("inventory:weapons:addAmmo", function(hash, amount)
    local char = exports['players']:getCharacter(source)

    if ammoCache[char.cid][tostring(hash)] then
        -- * UPDATE EXISTING
        ammoCache[char.cid][tostring(hash)].ammo = ammoCache[char.cid][tostring(hash)].ammo + amount
        if ammoCache[char.cid][tostring(hash)].ammo > 150 then ammoCache[char.cid][tostring(hash)].ammo = 150 end

        CreateThread(function()
            Wait(5000)
            if ammoCache[char.cid][tostring(hash)].ammo == amount then
                sql:executeSync('UPDATE _weapon_ammo SET ammo=ammo+? WHERE hash=? AND citizen_id=?', {amount, hash, char.cid})
            end
        end)
    else
        ammoCache[char.cid][tostring(hash)] = {
            hash = hash,
            ammo = amount
        }
        sql:executeSync('INSERT INTO _weapon_ammo (citizen_id, hash, ammo) VALUES (?, ?, ?)', {char.cid, hash, amount})
    end
end)

RPC.register("use:cash-stack", function(source, slot)
    local character = players:getCharacter(source)
    local inventory = inventorys['player'][tostring(character.cid)]

    if not inventory[tostring(slot)] or inventory[tostring(slot)].itemId ~= "cash-stack" then return false end
    local amount = inventorys['player'][tostring(character.cid)][tostring(slot)].qty

    inventorys['player'][tostring(character.cid)][tostring(slot)] = nil

    updateInventorys('player', tostring(character.cid))

    addItem(source, 'cash', amount*250)
    -- if hasEnoughOfItem(source, 'cash-stack', 1) then
    --     if canCarryItem(source, 'cash', 250) and removeItem(source, 'cash-stack', 1) then
    --         addItem(source, 'cash', 250)
    --     else
    --         TriggerClientEvent("DoLongHudText", source, "Sul pole piisavalt ruumi!", "red", 2500)
    --     end
    -- end
end)