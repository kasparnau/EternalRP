local events = exports['events']
local players = exports['players']

local waitingForResponse = false
local currentlyUsingItem = false

exports("getItemList", function()
    return itemsList or {}
end)

local inventoryOpen = false
local mainInventory = nil
local secondInventory = nil

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

local playerPed = PlayerPedId()

AddEventHandler("jp:onPedChange", function(nPed)
	playerPed = nPed
end)

function randPickupAnim()
    SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, 1)
    local randAnim = math.random(7)
    if randAnim == 1 then
      loadAnimDict('missfbi_s4mop')
      TaskPlayAnim(playerPed,'missfbi_s4mop', 'pickup_bucket_0',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
    elseif randAnim == 2 then
      loadAnimDict('pickup_object')
      TaskPlayAnim(playerPed,'pickup_object', 'putdown_low',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
    elseif randAnim == 3 then
      loadAnimDict('missheist_agency2aig_13')
      TaskPlayAnim(playerPed,'missheist_agency2aig_13', 'pickup_briefcase',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
    elseif randAnim == 4 then
      loadAnimDict('pickup_object')
      TaskPlayAnim(playerPed,'pickup_object', 'pickup_low',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
    elseif randAnim == 5 then
      loadAnimDict('random@atmrobberygen')
      TaskPlayAnim(playerPed,'random@atmrobberygen', 'pickup_low',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
    elseif randAnim == 6 then
      loadAnimDict('pickup_object')
      TaskPlayAnim(playerPed,'pickup_object', 'putdown_low',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
    elseif randAnim == 7 then
      loadAnimDict('random@domestic')
      TaskPlayAnim(playerPed,'random@domestic', 'pickup_low',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
    end
end

local weaponList = {
    ['pistol'] = `WEAPON_PISTOL`,
    ['pistol2'] = `WEAPON_PISTOL_MK2`,
    ['combat-pistol'] = `WEAPON_COMBATPISTOL`,
    ['pistol-50'] = `WEAPON_PISTOL50`,
    ['stun-gun'] = `WEAPON_TASER`,

    ['special-carbine'] = `WEAPON_SPECIALCARBINE`,
    ['mini-smg'] = `WEAPON_MINISMG`,
    ['sniper-rifle'] = `WEAPON_SNIPERRIFLE`,
    ['mg'] = `WEAPON_MG`,
    ['heavy-pistol'] = `WEAPON_HEAVYPISTOL`,
    ['machine-pistol'] = `WEAPON_MACHINEPISTOL`,
    ['assault-rifle'] = `WEAPON_ASSAULTRIFLE`,
    ['assault-rifle2'] = `WEAPON_ASSAULTRIFLE_MK2`,
    ['pump-shotgun'] = `WEAPON_PUMPSHOTGUN`,

    ['m4'] = `WEAPON_M4`,
    ['glock'] = `WEAPON_GLOCK`,
    ['weapon-ltl'] = `WEAPON_LTL`,

    ['knife'] = `WEAPON_KNIFE`,
    ['flashlight'] = `WEAPON_FLASHLIGHT`,
    ['knuckle-dusters'] = `WEAPON_KNUCKLE`,
    ['nightstick'] = `WEAPON_NIGHTSTICK`,
    ['switchblade'] = `WEAPON_SWITCHBLADE`,
    ['baseball-bat'] = `WEAPON_BAT`,
    
    ['stun-grenade'] = `WEAPON_GRENADE`,
    ['weapon-brick'] = `WEAPON_BRICK`
}

local hashToItemId = {}
for i,v in pairs (weaponList) do
    hashToItemId[v] = i 
end

function getItemIdFromHash(hash)
    return hashToItemId[hash] or nil
end

function checkIfLegalWeapons()
    TriggerEvent("inventory:changed")
    
    local weaponName;
    for i,v in pairs (weaponList) do
        if v == GetSelectedPedWeapon(playerPed) then
            weaponName = i
            break
        end
    end
    for i,v in pairs (mainInventory.items) do
        if v.itemId == weaponName then return end
    end
    RemoveAllPedWeapons(playerPed)
end

function closeInventory(updateMain, newItems)
    SendNUIMessage({ action = "hide" })
    SetNuiFocus(false, false)
    TriggerServerEvent("closeInventory")

    if updateMain and not newItems then
        -- local character = players:GetClientVar("character")
        -- -- mainInventory = {}
        -- -- mainInventory.items = json.decode(exports['players']:GetClientVar("character").inventory)
        -- events:Trigger("inventory:getInventory", function(inventory)
        --     if inventory then
        --         mainInventory = inventory

        --         print ("Here: "..json.encode(mainInventory))
        --         -- print (exports['players']:GetClientVar("character").inventory)

        --         checkIfLegalWeapons()
        --     end
        -- end, "player", character.cid, true)
    elseif updateMain and newItems then
        mainInventory.items = newItems

        checkIfLegalWeapons()
    end

    inventoryOpen = false
end

AddEventHandler("login:firstSpawn", function()
    local character = players:GetClientVar("character") or false

    if character then
        events:Trigger("inventory:getInventory", function(inventory)
            mainInventory = inventory
        end, "player", character.cid, true)

        TriggerServerEvent("inventory:server:requestDrops")
    end
end)

function showItemRemoved(xlabel, xitemId, xqty)
    SendNUIMessage({
        action = 'itemUsed',
        alerts = {
            {
                item = {label = xlabel, itemId = xitemId},
                qty = xqty,
                message = 'Kasutasid',
            },
        }
    })
end

local showItemsReceivedQueue = {}
RegisterNetEvent("inventory:showItemsReceived")
AddEventHandler("inventory:showItemsReceived", function(xAlerts)
    for i,v in pairs (xAlerts) do
        showItemsReceivedQueue[#showItemsReceivedQueue+1] = v
        CreateThread(function()
            local lastQueueLength = #showItemsReceivedQueue
            Wait(100)
            if #showItemsReceivedQueue == lastQueueLength then
                SendNUIMessage({
                    action = 'itemUsed',
                    alerts = showItemsReceivedQueue
                })
                showItemsReceivedQueue = {}
            end
        end)
    end
end)

local currentlyHolstering = false

function doProgressBar(data, duration, cb, extras)
    RemoveAllPedWeapons(playerPed)
    currentlyUsingItem = true
    local extras = extras or {}
    exports['progress']:Progress({
        name = "UseItem",
        duration = duration,
        label = extras.lbl or ('KASUTAD '..data.item.label),
        useWhileDead = false,
        canCancel = true,
        controlDisables = extras.controlDisables or {disableMovement = false,disableCarMovement = false,disableMouse = false,disableCombat = true},
        animation = extras.anim or nil,
        prop = extras.prop or nil,
        propTwo = extras.propTwo or nil,
    }, function(cancelled)
        currentlyUsingItem = false
        ClearPedTasks(playerPed)

        local canStillUse = extras.canStillUse and extras.canStillUse() or true

        if not cancelled and canViewInventory() and canStillUse then
            local success = RPC.execute('inventory:useItemFromSlot', data)

            SendNUIMessage({
                action = "unlock"
            })

            waitingForResponse = false
            if success then
                cb()
            end
        else
            SendNUIMessage({
                action = "unlock"
            })

            waitingForResponse = false
        end
    end)
end

function doProgressBarManualRemove(duration, cb, extras)
    RemoveAllPedWeapons(playerPed)
    currentlyUsingItem = true
    local extras = extras or {}
    exports['progress']:Progress({
        name = "UseItem",
        duration = duration,
        label = extras.lbl or ('KASUTAD ASJA'),
        useWhileDead = false,
        canCancel = true,
        controlDisables = extras.controlDisables or {disableMovement = false,disableCarMovement = false,disableMouse = false,disableCombat = true},
        animation = extras.anim or nil,
        prop = extras.prop or nil,
        propTwo = extras.propTwo or nil,
    }, function(cancelled)
        currentlyUsingItem = false
        ClearPedTasks(playerPed)

        local canStillUse = extras.canStillUse and extras.canStillUse() or true

        if not cancelled and canViewInventory() and canStillUse then
            SendNUIMessage({
                action = "unlock"
            })

            waitingForResponse = false
            cb()
        else
            SendNUIMessage({
                action = "unlock"
            })

            waitingForResponse = false
        end
    end)
end

function getItemData(itemId)
    local result = itemsList[itemId] and itemsList[itemId] or false
    if result and result.isWeapon then result.nonStackable = true end
    return result
end
exports('getItemData', getItemData)

function notyFail()
    TriggerEvent("DoLongHudText", "Sa ei saa seda praegu kasutada!", 'red')
end

function hasEnoughOfItem(itemId, amount)
    if not mainInventory then return false end

    local inventory = mainInventory.items

    local quantity = 0
    for i,v in pairs (inventory) do
        if v.itemId == itemId then
            quantity = quantity + v.qty
        end
    end

    return (quantity >= amount)
end

local MAX_PLAYER_WEIGHT = 250
function canCarryItem(pItemId, pAmount)
    if not mainInventory then return false end
    
    local inventory = mainInventory.items

    local totalWeight = getInventoryWeight()
    local freeSlots = 0
    local existing = false

    for i = 1, 20 do
        if not inventory[tostring(i)] then
            freeSlots = freeSlots + 1
        elseif inventory[tostring(i)] and inventory[tostring(i)].itemId == pItemId then
            existing = true
        end
    end

    local pItemWeight = (itemsList[pItemId].weight*pAmount)
    return (totalWeight+pItemWeight <= MAX_PLAYER_WEIGHT) and (freeSlots > 0 or existing)
end

function getInventoryWeight()
    local totalWeight = 0

    for i,v in pairs (mainInventory.items) do
        totalWeight = totalWeight + (v.qty * v.weight)
    end

    return totalWeight
end

function amountOfItem(itemId)
    local inventory = mainInventory.items

    local quantity = 0
    for i,v in pairs (inventory) do
        if v.itemId == itemId then
            quantity = quantity + v.qty
        end
    end

    return quantity
end

function removeItem(itemId, amount)
    local success = RPC.execute("inventory:removeItem", itemId, amount)
    return success
end

local itemActions = {}
function addAction(pItems, pItemAction, pCanUseCheck)
    for i = 1, #pItems do
        local item = pItems[i]
        itemActions[item] = {
            itemAction = pItemAction,
            canUseCheck = pCanUseCheck or nil
        }
    end
end

lastEquippedThrowable = nil
function UseItem(data)
    if data.owner == 'shop' then return end
    if currentlyUsingItem == true or exports['progress']:doingAction() then
        print(tostring(currentlyUsingItem).." | "..tostring(waitingForResponse).." | "..tostring(exports['progress']:doingAction()))
        CreateThread(function()
            Wait(200)
            if waitingForResponse then waitingForResponse = false end
        end)
        return
    end
    if not canViewInventory() then return end
    local item = data.item
    if item.nonUsable then return end
    if item.isWeapon then
        if currentlyHolstering then return end

        local character = players:GetClientVar("character")
        local expectedName = ('player-'..character.cid)
        if (data.owner.."-"..data.id) ~= expectedName then return end

        currentlyHolstering = true

        CreateThread(function()
            while currentlyHolstering do
                DisablePlayerFiring(playerPed, true) -- Disable weapon firing
                DisableControlAction(0, 24, true) -- Attack
                DisableControlAction(0, 142, true) -- MeleeAttackAlternate

                Wait(1)
            end
        end)

        local dict = "reaction@intimidation@1h"
        loadAnimDict(dict)

        if GetSelectedPedWeapon(playerPed) ~= `WEAPON_UNARMED` then
            CreateThread(function()
                while `WEAPON_UNARMED` ~= GetSelectedPedWeapon(playerPed) do
                    DisplayAmmoThisFrame(true)

                    Wait(1)
                end
            end)

            SendNUIMessage({
                action = 'itemUsed',
                alerts = {
                    {
                        item = {label = getItemData(item.itemId).label, itemId = getItemIdFromHash(lastEquippedWeapon)},
                        qty = 1,
                        message = 'PANID ÄRA',
                    },
                }
            })

            exports['progress']:Progress({
                name = "EquipItem",
                duration = 1100,
                label = ('PANED RELVA ÄRA'),
                useWhileDead = false,
                canCancel = false,
                controlDisables = {disableMovement = false,disableCarMovement = false,disableMouse = false,disableCombat = true},
            }, function(cancelled)
                ClearPedTasks(playerPed)
            end)

            local anim = "outro"
            TaskPlayAnim(playerPed, dict, anim, 1.0, 1.0, -1, 50, 0, 0, 0, 0)
            local animLength = GetAnimDuration(dict, anim) * 1000
            Citizen.Wait(animLength - 2200)

            lastEquippedWeapon = nil
            SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, 1)
            RemoveAllPedWeapons(playerPed)
            ClearPedTasks(playerPed)
        else
            SendNUIMessage({
                action = 'itemUsed',
                alerts = {
                    {
                        item = {label = getItemData(item.itemId).label, itemId = item.itemId},
                        qty = 1,
                        message = 'VÕTSID VÄLJA',
                    },
                }
            })

            exports['progress']:Progress({
                name = "EquipItem",
                duration = 1500,
                label = ('VÕTAD RELVA VÄLJA'),
                useWhileDead = false,
                canCancel = false,
                controlDisables = {disableMovement = false,disableCarMovement = false,disableMouse = false,disableCombat = true},
            }, function(cancelled)
                ClearPedTasks(playerPed)
            end)

            local weaponHash = weaponList[item.itemId]
            RemoveAllPedWeapons(playerPed)
            local anim = "intro"

            TaskPlayAnim(playerPed, dict, anim, 1.0, 1.0, -1, 50, 0, 0, 0, 0)
            Citizen.Wait(1500)
            lastEquippedWeapon = weaponHash
            if (isThrowableWeapon(weaponHash)) then
                GiveWeaponToPed(playerPed, weaponHash, 1, 0, 1)
            else
                GiveWeaponToPed(playerPed, weaponHash, getWeaponAmmo(getAmmoTypeHash(weaponHash)), 0, 1)
            end        
            SetCurrentPedWeapon(playerPed, weaponHash, 1)
            ClearPedTasks(playerPed)
        end


        --Wait(800)

        currentlyHolstering = false
    else
        do
            -- if item.itemId == 'armor2' and (GetPedArmour(playerPed) == 100) then notyFail() return end
            -- if item.itemId == 'armor1' and (GetPedArmour(playerPed) > 50) then notyFail() return end
            -- if (item.itemId == 'bandage' or item.itemId == "ifak") and (GetEntityHealth(playerPed) == GetEntityMaxHealth(playerPed)) then notyFail() return end
            -- if (item.itemId == 'lockpick-set' or item.itemId == 'advanced-lockpick') and not IsPedInAnyVehicle(playerPed) then notyFail() return end
            -- if item.itemId == 'binoculars' and IsPedInAnyVehicle(playerPed) then notyFail() return end
            -- if item.itemId == 'plate' then
            --     local vehInDirection = exports['modules']:getModule("Game").GetVehicleInDirection()
            --     local distanceRear = math.huge

            --     if vehInDirection then
            --         local model = GetEntityModel(vehInDirection)
            --         local coords = GetModelDimensions(model)

            --         local playerPed = PlayerPedId()
            --         local startPosition = GetOffsetFromEntityInWorldCoords(playerPed, 0, 0.5, 0);
            --         local back = GetOffsetFromEntityInWorldCoords(vehInDirection, 0.0, coords[2] - 0.5, 0.0);
            --         distanceRear = GetDistanceBetweenCoords(startPosition[1],startPosition[2],startPosition[3], back[1], back[2], back[3]);
            --     end

            --     if not vehInDirection or distanceRear > 3 then notyFail() return end
            -- end
            -- local closestPlayer, closestPlayerDistance = exports['modules']:getModule("Game").GetClosestPlayer()
            -- if item.itemId == 'hand-cuffs' then
            --     if closestPlayer == -1 or closestPlayerDistance > 3.0 then notyFail() return end
            -- end
            -- if item.itemId == 'hamburger' or item.itemId == 'sandwich' or item.itemId == 'donut' or item.itemId == 'hot-dog' or item.itemId == 'pizza' then
            --     local status = json.decode(exports['players']:GetClientVar('character').status)
            --     if status.hunger and status.hunger >= 100 then notyFail() return end
            -- end
            -- if item.itemId == 'coffee' or item.itemId == 'cola' or item.itemId == 'water' or item.itemId == 'sprunk' or item.itemId == 'milk' then
            --     local status = json.decode(exports['players']:GetClientVar('character').status)
            --     if status.thirst and status.thirst >= 100 then notyFail() return end
            -- end
            -- if item.itemId == 'banana' or item.itemId == 'apple' or item.itemId == 'watermelon' then
            --     local status = json.decode(exports['players']:GetClientVar('character').status)
            --     if status.hunger and status.hunger >= 100 then notyFail() return end
            -- end
            -- if item.itemId == 'slushy' then
            --     local status = json.decode(exports['players']:GetClientVar('character').status)
            --     if (status.hunger and status.thirst) and (status.hunger >= 100 and status.thirst >= 100) then notyFail() return end
            -- end
        end

        print (json.encode(item))
        TriggerEvent("inventory:itemUsed", item)
        if not itemActions[item.itemId] then 
            -- exports['alerts']:notify('Inventory', "Sellel asjal ("..item.itemId..") pole veel kasutusts. klicer prolly teab", 'errorAlert', 2500)    
            return 
        end

        if itemActions[item.itemId].canUseCheck and not itemActions[item.itemId].canUseCheck(item, data) then notyFail() return end

        if not hasEnoughOfItem(item.itemId, 1) then return end

        SendNUIMessage({
            action = "lock"
        })

        waitingForResponse = true
        local dontRemoveOnUse = item.dontRemoveOnUse and true or false

        if not dontRemoveOnUse then showItemRemoved(item.label, item.itemId, 1) end

        RemoveAllPedWeapons(playerPed)

        itemActions[item.itemId].itemAction(item, data)

        do
            -- if item.itemId == 'armor1' then
            --     doProgressBar(data, 5000, function()
            --         SetPedArmour( playerPed, 60 )
            --     end, {lbl = "Applying light armor"})

            -- elseif item.itemId == 'armor2' then
            --     doProgressBar(data, 10000, function()
            --         SetPedArmour( playerPed, 100 )
            --     end, {lbl = "Applying heavy armor"})

            -- elseif item.itemId == 'bandage' then
            --     doProgressBar(data, 7500, function()
            --         ClearPedBloodDamage(playerPed)
            --         CreateThread(function()
            --             local healthToAdd = 30
            --             for i = 1, healthToAdd do
            --                 if GetEntityHealth(playerPed) == GetEntityMaxHealth(playerPed) then return end
            --                 SetEntityHealth(playerPed, (GetEntityHealth(playerPed) + 1))
            --                 Citizen.Wait(1000)
            --             end
            --         end)
            --     end, {anim = {animDict = "amb@world_human_clipboard@male@idle_a", anim = "idle_c", flags = 49}})

            -- elseif item.itemId == 'ifak' then
            --     doProgressBar(data, 7500, function()
            --         ClearPedBloodDamage(playerPed)
            --         CreateThread(function()
            --             local healthToAdd = 100
            --             for i = 1, healthToAdd do
            --                 if GetEntityHealth(playerPed) == GetEntityMaxHealth(playerPed) then return end
            --                 SetEntityHealth(playerPed, (GetEntityHealth(playerPed) + 1))
            --                 Citizen.Wait(500)
            --             end
            --         end)
            --     end, {anim = {animDict = "amb@world_human_clipboard@male@idle_a", anim = "idle_c", flags = 49}})
            -- elseif item.itemId == 'lockpick-set' or item.itemId == 'advanced-lockpick' then
            --     local amount = item.itemId == 'lockpick-set' and 5 or item.itemId == 'advanced-lockpick' and 4
            --     events:Trigger("inventory:useItem", function(success)
            --         if success then
            --             exports['hotwiring']:start(amount)
            --         end
            --     end, data)
            -- elseif item.itemId == 'binoculars' then
            --     TriggerEvent("binoculars:Activate")
            -- elseif item.itemId == 'plate' then
            --     doProgressBar(data, 15000, function()
            --         local vehInDirection = exports['modules']:getModule("Game").GetVehicleInDirection()
            --         local distanceRear = math.huge

            --         if vehInDirection then
            --             local model = GetEntityModel(vehInDirection)
            --             local coords = GetModelDimensions(model)

            --             local playerPed = PlayerPedId()
            --             local startPosition = GetOffsetFromEntityInWorldCoords(playerPed, 0, 0.5, 0);
            --             local back = GetOffsetFromEntityInWorldCoords(vehInDirection, 0.0, coords[2] - 0.5, 0.0);
            --             distanceRear = GetDistanceBetweenCoords(startPosition[1],startPosition[2],startPosition[3], back[1], back[2], back[3]);

            --             if distanceRear < 3 then
            --                 SetVehicleNumberPlateText(vehInDirection, exports['vehicle']:randomPlate())
            --                 exports['jp-flags']:SetVehicleFlag(vehInDirection, "fakePlate", true)
            --             end
            --         end
            --     end, {anim = {animDict = "mini@repair", anim = "fixing_a_player"}})
            -- elseif item.itemId == 'hamburger' or item.itemId == 'sandwich' or item.itemId == 'donut' or item.itemId == 'hot-dog' or item.itemId == 'pizza' then
            --     doProgressBar(data, 2000, function()
            --         local status = json.decode(exports['players']:GetClientVar('character').status)
            --         status.hunger = status.hunger + 25
            --         if status.hunger >= 100 then status.hunger = 100 end
            --         exports['players']:modifyCurrentCharacter('status', json.encode(status))
            --         TriggerServerEvent("status:updateStatus",GetEntityHealth(PlayerPedId()),GetPedArmour(PlayerPedId()),status.thirst,status.hunger)
            --     end, {lbl = ("Eating a "..item.label)})
            -- elseif item.itemId == 'banana' or item.itemId == 'apple' or item.itemId == 'watermelon' then
            --     doProgressBar(data, 2000, function()
            --         local status = json.decode(exports['players']:GetClientVar('character').status)
            --         status.hunger = status.hunger + 10
            --         if status.hunger >= 100 then status.hunger = 100 end
            --         exports['players']:modifyCurrentCharacter('status', json.encode(status))
            --         TriggerServerEvent("status:updateStatus",GetEntityHealth(PlayerPedId()),GetPedArmour(PlayerPedId()),status.thirst,status.hunger)
            --     end, {lbl = ("Eating a "..item.label)})
            -- elseif item.itemId == 'coffee' or item.itemId == 'cola' or item.itemId == 'water' or item.itemId == 'sprunk' or item.itemId == 'milk' then
            --     doProgressBar(data, 2000, function()
            --         local status = json.decode(exports['players']:GetClientVar('character').status)
            --         status.thirst = status.thirst + 25
            --         if status.thirst >= 100 then status.thirst = 100 end
            --         exports['players']:modifyCurrentCharacter('status', json.encode(status))
            --         TriggerServerEvent("status:updateStatus",GetEntityHealth(PlayerPedId()),GetPedArmour(PlayerPedId()),status.thirst,status.hunger)
            --     end, {lbl = ("Drinking "..item.label)})
            -- elseif item.itemId == 'slushy' then
            --     doProgressBar(data, 4000, function()
            --         local status = json.decode(exports['players']:GetClientVar('character').status)
            --         status.thirst = status.thirst + 25
            --         if status.thirst >= 100 then status.thirst = 100 end
            --         status.hunger = status.hunger + 25
            --         if status.hunger >= 100 then status.hunger = 100 end
            --         exports['players']:modifyCurrentCharacter('status', json.encode(status))
            --         TriggerServerEvent("status:updateStatus",GetEntityHealth(PlayerPedId()),GetPedArmour(PlayerPedId()),status.thirst,status.hunger)
            --     end, {lbl = ("Eating slushy")})
            -- elseif item.itemId == 'hand-cuffs' then
            --     doProgressBar(data, 2000, function()
            --         local playerHeading = GetEntityHeading(playerPed)
            --         local playerLocation = GetEntityForwardVector(playerPed)
            --         local playerCoords = GetEntityCoords(playerPed)

            --         events:Trigger("cuffs:cuff", function()
            --             loadAnimDict('mp_arrest_paired')
            --             TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
            --         end, GetPlayerServerId(closestPlayer), playerHeading, playerCoords, playerLocation)
            --     end, {lbl = ("Handcuffing person"), anim = {animDict = 'mp_arrest_paired', anim = 'crook_p2_back_right'}, canStillUse = function()
            --         return #(GetEntityCoords(GetPlayerPed(closestPlayer)) - GetEntityCoords(playerPed)) < 3.0
            --     end})
            -- elseif item.itemId == 'cocaine-baggy' then
            --     doProgressBar(data, 5000, function()
            --         local effects = {
            --             [1] = {
            --                 [1] = 'DrugsMichaelAliensFightIn',
            --                 [2] = 'DrugsMichaelAliensFight',
            --                 [3] = 'DrugsMichaelAliensFightOut'
            --             },
            --             [2] = {
            --                 [1] = 'DrugsTrevorClownsFightIn',
            --                 [2] = 'DrugsTrevorClownsFight',
            --                 [3] = 'DrugsTrevorClownsFightOut'
            --             }
            --         }

            --         local chosenEffect = math.random(100) > 50 and effects[1] or effects[2]

            --         StartScreenEffect(chosenEffect[1], 3.0, 0)
            --         Citizen.Wait(math.random(2000, 4000))
            --         StartScreenEffect(chosenEffect[2], 3.0, 0)
            --         Citizen.Wait(math.random(2000, 4000))
            --         StartScreenEffect(chosenEffect[3], 3.0, 1)

            --         local timer = math.random(120,240)
            --         while timer > 0 do
            --             timer = timer - 1

            --             SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)

            --             RestorePlayerStamina(PlayerId(), 1.0)
            --             if IsPedRagdoll(playerPed) then
            --                 SetPedToRagdoll(playerPed, math.random(5), math.random(5), 3, 0, 0, 0)
            --             end

            --             if math.random(500) < 3 then
            --                 if math.random(100) > 50 then
            --                     DrugsEffect1()
            --                 else
            --                     DrugsEffect2()
            --                 end
            --                 Citizen.Wait(math.random(30000))
            --             end

            --             if math.random(100) > 91 and IsPedRunning(playerPed) then
            --                 SetPedToRagdoll(playerPed, math.random(1000), math.random(1000), 3, 0, 0, 0)
            --             end

            --             Wait(1000)
            --         end

            --         SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)

            --         for i = 1, 3 do StopScreenEffect(chosenEffect[i]) end

            --     end, {lbl = "Snorting coke", anim = {animDict = "anim@amb@nightclub@peds@", anim = "missfbi3_party_snort_coke_b_male3", flags = 49}, prop = {model = "prop_meth_bag_01", bone = 28422, coords = {x=0.1,y=0.0,z=-0.01}, rotation = {x=135.0,y=-100.0,z=40.0}}})

            -- elseif item.itemId == 'meth-baggy' then
            --     doProgressBar(data, 5000, function()
            --         local effects = {
            --             [1] = {
            --                 [1] = 'DrugsMichaelAliensFightIn',
            --                 [2] = 'DrugsMichaelAliensFight',
            --                 [3] = 'DrugsMichaelAliensFightOut'
            --             },
            --             [2] = {
            --                 [1] = 'DrugsTrevorClownsFightIn',
            --                 [2] = 'DrugsTrevorClownsFight',
            --                 [3] = 'DrugsTrevorClownsFightOut'
            --             }
            --         }

            --         local chosenEffect = math.random(100) > 50 and effects[1] or effects[2]

            --         StartScreenEffect(chosenEffect[1], 3.0, 0)
            --         Citizen.Wait(math.random(2000, 4000))
            --         StartScreenEffect(chosenEffect[2], 3.0, 0)
            --         Citizen.Wait(math.random(2000, 4000))
            --         StartScreenEffect(chosenEffect[3], 3.0, 1)

            --         local timer = math.random(120,240)
            --         while timer > 0 do
            --             timer = timer - 1

            --             SetRunSprintMultiplierForPlayer(PlayerId(), 1.3)

            --             RestorePlayerStamina(PlayerId(), 1.0)
            --             if IsPedRagdoll(playerPed) then
            --                 SetPedToRagdoll(playerPed, math.random(5), math.random(5), 3, 0, 0, 0)
            --             end

            --             if math.random(500) < 3 then
            --                 if math.random(100) > 50 then
            --                     DrugsEffect1()
            --                 else
            --                     DrugsEffect2()
            --                 end
            --                 Citizen.Wait(math.random(30000))
            --             end

            --             if math.random(100) > 91 and IsPedRunning(playerPed) then
            --                 SetPedToRagdoll(playerPed, math.random(1000), math.random(1000), 3, 0, 0, 0)
            --             end

            --             Wait(1000)
            --         end

            --         SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)

            --         for i = 1, 3 do StopScreenEffect(chosenEffect[i]) end

            --     end, {anim = {animDict = "switch@trevor@trev_smoking_meth", anim = "trev_smoking_meth_loop", flags = 49}, prop = {["model"] = "prop_cs_crackpipe", ["bone"] = 28422, coords = {x=0.0,y=0.05,z=0.0}, rotation = {x=135.0,y=-100.0,z=0.0}}})

            -- elseif item.itemId == 'crack' then
            --     doProgressBar(data, 5000, function()
            --         local effects = {
            --             [1] = {
            --                 [1] = 'DrugsMichaelAliensFightIn',
            --                 [2] = 'DrugsMichaelAliensFight',
            --                 [3] = 'DrugsMichaelAliensFightOut'
            --             },
            --             [2] = {
            --                 [1] = 'DrugsTrevorClownsFightIn',
            --                 [2] = 'DrugsTrevorClownsFight',
            --                 [3] = 'DrugsTrevorClownsFightOut'
            --             }
            --         }

            --         local chosenEffect = math.random(100) > 50 and effects[1] or effects[2]

            --         StartScreenEffect(chosenEffect[1], 3.0, 0)
            --         Citizen.Wait(math.random(2000, 4000))
            --         StartScreenEffect(chosenEffect[2], 3.0, 0)
            --         Citizen.Wait(math.random(2000, 4000))
            --         StartScreenEffect(chosenEffect[3], 3.0, 1)

            --         local timer = math.random(120,240)
            --         while timer > 0 do
            --             timer = timer - 1

            --             SetRunSprintMultiplierForPlayer(PlayerId(), 1.1)

            --             RestorePlayerStamina(PlayerId(), 1.0)
            --             if IsPedRagdoll(playerPed) then
            --                 SetPedToRagdoll(playerPed, math.random(5), math.random(5), 3, 0, 0, 0)
            --             end

            --             if math.random(500) < 3 then
            --                 if math.random(100) > 50 then
            --                     DrugsEffect1()
            --                 else
            --                     DrugsEffect2()
            --                 end
            --                 Citizen.Wait(math.random(30000))
            --             end

            --             if math.random(100) > 91 and IsPedRunning(playerPed) then
            --                 SetPedToRagdoll(playerPed, math.random(1000), math.random(1000), 3, 0, 0, 0)
            --             end

            --             Wait(1000)
            --         end

            --         SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)

            --         for i = 1, 3 do StopScreenEffect(chosenEffect[i]) end

            --     end, {anim = {animDict = "switch@trevor@trev_smoking_meth", anim = "trev_smoking_meth_loop", flags = 49}, prop = {["model"] = "prop_cs_crackpipe", ["bone"] = 28422, coords = {x=0.0,y=0.05,z=0.0}, rotation = {x=135.0,y=-100.0,z=0.0}}})

            -- else
            --     exports['alerts']:notify('Inventory', "This item ("..item.itemId..") does not have a use. klicer probably knows lol", 'errorAlert', 2500)
            -- end

         end
         
    end
end

RegisterNUICallback('UseItem', UseItem)

function UseItemFromSlot(slot)
    if not mainInventory or not canOpenInventory() then return end
    local items = {}
    for i,v in pairs (mainInventory.items) do
        items[v.slot] = v
    end

    if items[slot] ~= nil then
        local character = players:GetClientVar("character")
        UseItem({
            item = items[slot],
            owner = 'player',
            id = character.cid,
            slot = slot
        })
    end
end

function ShowItemsInHotbar()
    if not mainInventory or not canOpenInventory() then return end

    SendNUIMessage({
        action = 'showActionBar',
        items = mainInventory.items
    })
end

RegisterNetEvent('inventory:forceClose')
AddEventHandler('inventory:forceClose', function(newInv)
    closeInventory(true, newInv)
end)

RegisterNetEvent('inventory:updateMain')
AddEventHandler('inventory:updateMain', function(newItems)
    mainInventory.items = newItems
    SendNUIMessage(
        {
        action = "setItems",
        invData = mainInventory,
        }
    )
    checkIfLegalWeapons()
end)

RegisterNetEvent('inventory:updateSecondary')
AddEventHandler('inventory:updateSecondary', function(newItems)
    if secondInventory then
        secondInventory.items = newItems
        SendNUIMessage(
            {
                action = "setSecondInventoryItems",
                invData = secondInventory,
            }
        )
    end
end)


function canOpenInventory()
    local inGame = players:GetClientVar('inGame')
    local character = players:GetClientVar('character')
    local isDead = players:GetClientVar('isDead')
    local isCuffed = players:GetClientVar('isCuffed')
    local paused = IsPauseMenuActive()
    return not inventoryOpen and not isDead and not isCuffed and not paused and inGame and character
end

function canViewInventory()
    local inGame = players:GetClientVar('inGame')
    local character = players:GetClientVar('character')
    local isDead = players:GetClientVar('isDead')
    local isCuffed = players:GetClientVar('isCuffed')
    local paused = IsPauseMenuActive()
    return not isDead and not isCuffed and not paused and inGame and character
end

exports('canViewInventory', canViewInventory)

local placeholderDisplayInv = {
    id = -1,
    invType = 'placeHolder',
    invSlots = 0,
    items = {}
}

function openInventory(SecondInventory)
    if not canOpenInventory() then return end
    inventoryOpen = true
    local character = players:GetClientVar("character")
    local gotMain = false

    SendNUIMessage({
        action = "lock"
    })

    SendNUIMessage(
        {
        action = "setItems",
        invData = placeholderDisplayInv,
        }
    )

    SendNUIMessage(
        {
        action = "setSecondInventoryItems",
        invData = placeholderDisplayInv,
        }
    )

    SendNUIMessage({
        action = "display",
        type = 'normal'
    })

    SetNuiFocus(true, true)

    events:Trigger("inventory:getInventory", function(inventory)
        if inventory == false then
            closeInventory()
            exports['alerts']:notify('Inventory', "Keegi vaatab juba sinu inventory", 'errorAlert', 2500)
            return
        end
        gotMain = true
        mainInventory = inventory

        SendNUIMessage(
            {
            action = "setItems",
            invData = inventory,
            }
        )

        CreateThread(function()
            while inventoryOpen do
                if not canViewInventory() then
                    closeInventory()
                    return
                end
                Wait(10)
            end
        end)

    end, "player", character.cid)

    if SecondInventory ~= nil then
        events:Trigger("inventory:getInventory", function(inventory)
            if inventory == false then
                SendNUIMessage({
                    action = "unlock"
                })
                exports['alerts']:notify('Inventory', "Keegi vaatab juba teist inventory", 'errorAlert', 2500)

                return
            end

            while not gotMain do
                Wait(0)
            end

            secondInventory = inventory

            SendNUIMessage(
                {
                action = "setSecondInventoryItems",
                invData = inventory,
                }
            )

            SendNUIMessage({
                action = "unlock"
            })

            SendNUIMessage({
                action = "display",
                type = 'secondary'
            })
        end, SecondInventory.invType, SecondInventory.invId, false, SecondInventory.extras)
    else
        SendNUIMessage({
            action = "unlock"
        })
    end
end

AddEventHandler("jp-shops:openShop", function(pEntity, pContext, pParams)
    if not pParams[1] then return end
    local character = exports['players']:GetClientVar("character")

    openInventory({
        invType = "shop",
        invId = pParams[1]
    })
end)

exports('openInventory', openInventory)

AddEventHandler("admin:openInventory", function(data)
    local admin_level = RPC.execute("getLevel")
    if admin_level then
        openInventory(data)
    else
        TriggerServerEvent("admin:banMyAss", "Tried to open inventory: "..json.encode(data), 5259492)
    end
end)

AddEventHandler("inventory:startSteal", function()
    if not canOpenInventory() then return end
    local closestPlayer, closestPlayerDistance = exports['modules']:getModule("Game").GetClosestPlayer()
    local targetPed = GetPlayerPed(closestPlayer)
    if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
        exports['progress']:Progress({
            name = "Stealing",
            duration = 3500,
            label = ('Röövib isikut'),
            useWhileDead = false,
            canCancel = true,
            controlDisables = {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true},
            animation = {animDict = "random@shop_robbery", anim = "robbery_action_b", flags = 49},
        }, function(cancelled)
            if not cancelled and canOpenInventory() then
                local distance = #(GetEntityCoords(targetPed) - GetEntityCoords(playerPed))
                if distance < 3.0 then
                    events:Trigger("inventory:getCID", function(cid)
                        if cid then
                            openInventory({
                                invType = "player",
                                invId = cid
                            })
                            repeat Wait(10) until inventoryOpen == true
                            while inventoryOpen and canViewInventory() do
                                local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(targetPed))
                                if dist > 3.0 then
                                    closeInventory()
                                    ClearPedTasksImmediately(playerPed)
                                    exports['alerts']:notify('Inventory', "Isik jooksis ära!", 'errorAlert', 500)
                                end
                                Wait(10)
                            end
                        end
                    end, GetPlayerServerId(closestPlayer))
                end
            end
        end)
    end
end)

AddEventHandler("police:searchNearest", function()
    local faction = exports['players']:GetClientVar('character').faction
    
	if faction and (faction.group.faction_name == 'LSPD' and faction.member.rank_level >= 1) then
		local closestPlayer, closestPlayerDistance = exports['modules']:getModule("Game").GetClosestPlayer()
		local targetPed = GetPlayerPed(closestPlayer)
		if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
			events:Trigger("inventory:getCID", function(cid)
				if cid then
					openInventory({
						invType = "player",
						invId = cid
					})
                    TriggerServerEvent("police:beingSearched", GetPlayerServerId(closestPlayer))
					repeat Wait(10) until inventoryOpen == true
					while inventoryOpen and canViewInventory() do
						local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(targetPed))
						if dist > 3.0 then
							closeInventory()
							ClearPedTasksImmediately(playerPed)
							exports['alerts']:notify('Inventory', "Isik jooksis ära!", 'errorAlert', 500)
						end
						Wait(10)
					end
				end
			end, GetPlayerServerId(closestPlayer))
		end
	end
end)

RegisterNUICallback('MoveToEmpty', function(data, cb)
    events:Trigger('inventory:MoveToEmpty', function(success)
        if not success then closeInventory(true) end
    end, data)
end)

RegisterNUICallback('EmptySplitStack', function(data, cb)
    events:Trigger('inventory:EmptySplitStack', function(success)
        if not success then closeInventory(true) end
    end, data)
end)

RegisterNUICallback('SplitStack', function(data, cb)
    events:Trigger('inventory:SplitStack', function(success)
        if not success then closeInventory(true) end
    end, data)
end)

RegisterNUICallback('CombineStack', function(data, cb)
    events:Trigger('inventory:CombineStack', function(success)
        if not success then closeInventory(true) end
    end, data)
end)

RegisterNUICallback('TopoffStack', function(data, cb)
    events:Trigger('inventory:TopoffStack', function(success)
        if not success then closeInventory(true) end
    end, data)
end)

RegisterNUICallback('SwapItems', function(data, cb)
    events:Trigger('inventory:SwapItems', function(success)
        if not success then closeInventory(true) end
    end, data)
end)

RegisterNUICallback('NUIFocusOff', function(data)
    closeInventory(true)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        closeInventory()
    end
end)

local throwables = {
    [`WEAPON_GRENADE`] = true, --// STUN GREANDE
    [`WEAPON_CASH`] = true,
    [`WEAPON_BRICK`] = true,
}

function isThrowableWeapon(hash)
    return throwables[hash] == true
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        HideHudComponentThisFrame(17)
        DisableControlAction(0, 37, true) --Disable Tab
    end
end)

Citizen.CreateThread(function()
    local keys = {
        157, 158, 160, 164, 165
    } --/1, 2, 3, 4, 5
    while true do
        Citizen.Wait(0)
        for k, v in pairs(keys) do
            if IsDisabledControlJustReleased(0, v) then
                UseItemFromSlot(k)
            end
        end
    end
end)

local closestDrop = {
    id = -1,
    distance = math.huge,
    coords = {x=0.0,y=0.0,z=0.0},
}

function GetVehicleSlots(vehicle)
    local vehClass = GetVehicleClass(vehicle)
    local vehModel = GetEntityModel(vehicle);

    local min, max = GetModelDimensions(vehModel)

    local minX, minY, minZ = min.x, min.y, min.z
    local maxX, maxY, maxZ = max.x, max.y, max.z
    local vehVolume = (maxX - minX) * (maxY - minY) * (maxZ - minZ)

    local seats = GetVehicleModelNumberOfSeats(vehModel)

    local classModifier = VehicleWeightModifiers[vehClass][1]
    local classBaseWeight = VehicleWeightModifiers[vehClass][2]
    local classMaxWeight = VehicleWeightModifiers[vehClass][3]

    if (classBaseWeight == 0) then
        return 0
    end

    local vehSeatModifier = (classBaseWeight * seats) / 3
    local vehWeightCalc = vehVolume * classModifier + vehSeatModifier;

    vehWeightCalc = math.floor((vehWeightCalc / 50) + 0.5) * 50;

    if vehWeightCalc > classMaxWeight then
        vehWeightCalc = classMaxWeight;
    end

    for i,v in pairs (VehicleWeightOverrides) do
        if vehModel == i then
            vehWeightCalc = v
        end
    end

    return vehWeightCalc
end

RegisterCommand('+openInventory', function()
    if not canOpenInventory() then return end
    local secondInventory = nil

    local vehInDirection = exports['modules']:getModule("Game").GetVehicleInDirection()

    --* OPEN GLOVEBOX
    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed)
        local meta = exports['jp-garages']:getVehicleMeta(vehicle)
        if meta then
            secondInventory = {
                invType = "plyglovebox",
                invId = meta.vin
            }
        else
            secondInventory = {
                invType = "glovebox",
                invId = GetVehicleNumberPlateText(vehicle)
            }
        end

        CreateThread(function()
            repeat Wait(0) until inventoryOpen
            while inventoryOpen do
                if not IsPedInAnyVehicle(playerPed, false) then
                    closeInventory()
                    return
                end
                Wait(10)
            end
        end)
    --* OPEN DROP
    elseif closestDrop.coords ~= nil and closestDrop.id ~= -1 and closestDrop.distance < 1.0 then
        local currentId = closestDrop.id

        secondInventory = {
            invType = "drop",
            invId = tostring(currentId)
        }
        randPickupAnim()

        CreateThread(function()
            repeat Wait(0) until inventoryOpen
            while inventoryOpen do
                if closestDrop.distance > 1.5 or closestDrop.id ~= currentId then
                    closeInventory()
                    return
                end
                Wait(10)
            end
        end)
    -- * OPEN TRUNK
    elseif vehInDirection ~= nil 
            and GetVehicleDoorLockStatus(vehInDirection) ~= 2 
            and not players:GetClientVar("inTrunk") 
            and exports['jp-interact']:isCloseToBoot(vehInDirection, PlayerPedId(), 2.0, GetEntityModel(vehInDirection))
        then

        local playerPed = PlayerPedId()
        
        SetVehicleDoorOpen(vehInDirection, 5, false, false)
        TaskTurnPedToFaceEntity(playerPed, vehInDirection, 1.0)

        while ( not HasAnimDictLoaded( "mini@repair" ) ) do
            RequestAnimDict( "mini@repair" )
            Citizen.Wait( 5 )
        end

        TaskPlayAnim(playerPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)    

        local slots = GetVehicleSlots(vehInDirection)
        local meta = exports['jp-garages']:getVehicleMeta(vehInDirection)

        if meta then
            secondInventory = {
                invType = "plytrunk",
                invId = meta.vin,
                extras = {slots = slots}
            }
        else
            secondInventory = {
                invType = "trunk",
                invId = GetVehicleNumberPlateText(vehInDirection),
                extras = {slots = slots}
            }
        end

        CreateThread(function()
            repeat Wait(0) until inventoryOpen
            while inventoryOpen do
                if not vehInDirection
                or not exports['jp-interact']:isCloseToBoot(vehInDirection, PlayerPedId(), 2.0, GetEntityModel(vehInDirection))
                or GetVehicleDoorLockStatus(vehInDirection) == 2
                then
                    closeInventory()

                    ClearPedTasks(playerPed)
                    SetVehicleDoorShut(vehInDirection, 5, false)        
                    return
                end
                Wait(0)
            end
            ClearPedTasks(playerPed)
            SetVehicleDoorShut(vehInDirection, 5, false)
        end)
    end
    openInventory(secondInventory)
end, false)


--* DROPS

local itemDrops = {}

RegisterNetEvent("inventory:addDrop")
AddEventHandler("inventory:addDrop", function(id, coords)
    itemDrops[tostring(id)] = coords
end)

RegisterNetEvent("inventory:addDropsInitial")
AddEventHandler("inventory:addDropsInitial", function(drops)
    closestDrop = {
        id = -1,
        distance = math.huge,
        coords = {x=0.0,y=0.0,z=0.0},
    }

    itemDrops = {}
    for id, coords in pairs (drops) do
        itemDrops[tostring(id)] = coords
    end
end)

RegisterNetEvent("inventory:removeDrop")
AddEventHandler("inventory:removeDrop", function(id)
    itemDrops[tostring(id)] = nil
    if tostring(closestDrop.id) == tostring(id) then
        closestDrop = {
            id = -1,
            distance = math.huge,
            coords = {x=0.0,y=0.0,z=0.0},
        }
    end
end)

local myCoords = math.huge

CreateThread(function()
    while true do
        local closestId = -1
        local closestCoords = {x = 0.0, y = 0.0, z = 0.0}
        local closestDist = math.huge

        myCoords = GetEntityCoords(playerPed)
        for id, coords in pairs (itemDrops) do
            local dist = #(coords - myCoords)
            if dist < closestDist then
                closestId = id
                closestDist = dist
                closestCoords = coords
            end
        end

        closestDrop.id = closestId
        closestDrop.coords = closestCoords
        closestDrop.distance = closestDist

        Wait(50)
    end
end)

CreateThread(function()
    local wait = 100
    while true do
        local found = false
        for id, coords in pairs (itemDrops) do
            local dist = #(coords - myCoords)
            if dist < 25.0 then
                wait = 1
                found = true
                DrawMarker(20, coords.x, coords.y, coords.z-0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.5, -0.5, -0.3, 255, 255, 255, 100, false, false, 2, true, false, false, false)
            end
        end
        if (wait == 1 and not found) then
            wait = 100
        end
        Wait(wait)
    end
end)

RegisterCommand("drop", function(source, args, raw)
    if closestDrop.coords ~= nil and closestDrop.id ~= -1 and closestDrop.distance < 1.0 then return end
    if not players:GetClientVar("inTrunk") and not IsPedInAnyVehicle(playerPed, true) and canOpenInventory() then
        randPickupAnim()
        events:Trigger("inventory:makeDrop", function(id)
            secondInventory = {
                invType = "drop",
                invId = id
            }
            openInventory(secondInventory)
        end)
    end
end)

--* KEYBINDS

RegisterCommand('-openInventory', function() end, false)
exports['jp-keybinds']:registerKeyMapping("openInventory", "Inventory", "Ava Inventory", "+openInventory", "-openInventory", "I")

RegisterCommand('+openHotbar', function()
    if not canViewInventory() then return end
    ShowItemsInHotbar()
end, false)

RegisterCommand('-openHotbar', function() end, false)
exports['jp-keybinds']:registerKeyMapping("openHotbar", "Inventory", "Näita Asjaderiba", "+openHotbar", "-openHotbar", "TAB")

--* EXPORTS

exports('hasEnoughOfItem', hasEnoughOfItem)
exports('canCarryItem', canCarryItem)
exports('amountOfItem', amountOfItem)
exports('removeItem', removeItem)
exports('getInventoryWeight', getInventoryWeight)

RegisterCommand("stopDrugEffects", function()
    local effects = {
        [1] = {
            [1] = 'DrugsMichaelAliensFightIn',
            [2] = 'DrugsMichaelAliensFight',
            [3] = 'DrugsMichaelAliensFightOut'
        },
        [2] = {
            [1] = 'DrugsTrevorClownsFightIn',
            [2] = 'DrugsTrevorClownsFight',
            [3] = 'DrugsTrevorClownsFightOut'
        }
    }

    for i,v in pairs (effects) do
        for i,v in pairs(v) do
            StopScreenEffect(v)
        end
    end
end)

RegisterCommand("closeInv", function()
    if inventoryOpen then
        closeInventory()
    end
end)

exports('closeInventory', function()
    if inventoryOpen then
        closeInventory()
    end
end)