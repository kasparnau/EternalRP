local events = exports['events']

addAction({'hamburger', 'sandwich', 'donut', 'hot-dog', 'pizza'}, function(item, data)
    doProgressBar(data, 6000, function()
        local status = exports['status']:get()

        status.hunger = status.hunger + 25
        if status.hunger >= 100 then status.hunger = 100 end

        exports['status']:set(status)
    end, {lbl = ("SÖÖD:  "..item.label), anim = {animDict = 'mp_player_inteat@burger', anim = 'mp_player_int_eat_burger', flags = 49}})
end, function(item, data)
    local status = exports['status']:get()
    return status.hunger < 100
end)

addAction({'coffee', 'cola', 'water', 'sprunk', 'milk'}, function(item, data)
    doProgressBar(data, 6000, function()
        local status = exports['status']:get()

        status.thirst = status.thirst + 25
        if status.thirst >= 100 then status.thirst = 100 end

        exports['status']:set(status)
    end, {lbl = ("JOOD: "..item.label), anim = {animDict = 'amb@world_human_drinking@beer@female@idle_a', anim = 'idle_e', flags = 49}})
end, function(item, data)
    local status = exports['status']:get()
    return status.thirst < 100
end)

addAction({'holy-water'}, function(item, data)
    doProgressBar(data, 2000, function()
        local status = exports['status']:get()

        status.thirst = 100
        status.hunger = 100

        exports['status']:set(status)
    end, {lbl = ("JOOD: "..item.label)})
end, function(item, data)
    local status = exports['status']:get()
    return status.thirst < 100 or status.hunger < 100
end)

addAction({'prison-food'}, function(item, data)
    doProgressBar(data, 10000, function()
        local status = exports['status']:get()

        status.thirst = status.thirst + 25
        if status.thirst >= 100 then status.thirst = 100 end

        status.hunger = status.hunger + 25
        if status.hunger >= 100 then status.hunger = 100 end

        exports['status']:set(status)
    end, {lbl = ("SÖÖD: "..item.label)})
end, function(item, data)
    local status = exports['status']:get()
    return status.thirst < 100 or status.hunger < 100
end)

local armors = {
    ['armor1'] = {amount = 60},
    ['armor2'] = {amount = 100}
}
addAction({'armor1', 'armor2'}, function(item, data)
    local info = armors[item.itemId]
    doProgressBar(data, info.amount*100, function()
        SetPedArmour(PlayerPedId(), info.amount)
    end, {lbl = ("Paned selga "..item.label), anim = {animDict = "oddjobs@basejump@ig_15", anim = "puton_parachute", flags = 49}})
end, function(item, data)
    local info = armors[item.itemId]
    if not info then return false end

    local armor = GetPedArmour(PlayerPedId())
    return armor < info.amount
end)

local itemIdToBulletData = {
    ['pistol-ammo'] = {hash = 1950175060, amount = 30},
    ['rifle-ammo'] = {hash = 218444191, amount = 30},
    ['lmg-ammo'] = {hash = 1788949567, amount = 50},
    ['shotgun-ammo'] = {hash = -1878508229, amount = 10},
    ['ltl-ammo'] = {hash = 1517835987, amount = 10},
    ['sub-ammo'] = {hash = 1820140472, amount = 30},
    ['sniper-ammo'] = {hash = 1285032059, amount = 5},
    ['taser-ammo'] = {hash = -1575030772, amount = 2}
}

addAction({'pistol-ammo', 'rifle-ammo', 'lmg-ammo', 'shotgun-ammo', 'sub-ammo', 'sniper-ammo', 'ltl-ammo', 'taser-ammo'}, function(item, data)
    local info = itemIdToBulletData[item.itemId]
    doProgressBar(data, 5000, function()
        TriggerServerEvent("inventory:weapons:addAmmo", info.hash, info.amount)
        addAmmo(info.hash, info.amount)
        TriggerEvent("DoLongHudText", ('Laadisid %s kuuli.'):format(info.amount), 'green', 3000)
    end, {lbl = ("LAED RELVA KUULE"), anim = {animDict = "anim@cover@weapon@reloads@submg@bullpup_rifle", anim = "reload_low_left", flags = 49}})
end, function(item, data)
    local info = itemIdToBulletData[item.itemId]
    local maxAmmo = getWeaponAmmo(info.hash) >= 150
    return not maxAmmo and info ~= nil
end)

addAction({'bandage'}, function(item, data)
    doProgressBar(data, 7500, function()
        local playerPed = PlayerPedId()
        ClearPedBloodDamage(playerPed)
        CreateThread(function()
            local healthToAdd = 30
            for i = 1, healthToAdd do
                if GetEntityHealth(playerPed) == GetEntityMaxHealth(playerPed) then return end
                SetEntityHealth(playerPed, (GetEntityHealth(playerPed) + 1))
                Citizen.Wait(1000)
            end
        end)
    end, {lbl = ("Paned sidemet haavale"), anim = {animDict = "amb@world_human_clipboard@male@idle_a", anim = "idle_c", flags = 49}})
end)

addAction({'ifak'}, function(item, data)
    doProgressBar(data, 7500, function()
        local playerPed = PlayerPedId()
        ClearPedBloodDamage(playerPed)
        CreateThread(function()
            local healthToAdd = 100
            for i = 1, healthToAdd do
                if GetEntityHealth(playerPed) == GetEntityMaxHealth(playerPed) then return end
                SetEntityHealth(playerPed, (GetEntityHealth(playerPed) + 1))
                Citizen.Wait(500)
            end
        end)
    end, {anim = {animDict = "amb@world_human_clipboard@male@idle_a", anim = "idle_c", flags = 49}})
end)

addAction({'cash-stack'}, function(item, data)
    RPC.execute("use:cash-stack", data.item.slot)
end)

addAction({'lockpick-set', 'advanced-lockpick'}, function(item, data)
    exports['hotwiring']:start(item.itemId)
end)

addAction({'binoculars'}, function(item, data)
    TriggerEvent("binoculars:Activate")
end)

addAction({'hand-cuffs'}, function(item, data)
    -- doProgressBarManualRemove(200, function()
        local closestPlayer, closestPlayerDistance = exports['modules']:getModule("Game").GetClosestPlayer()
        local targetPed = GetPlayerPed(closestPlayer)
        local playerPed = PlayerPedId()

        if (closestPlayer ~= -1 and closestPlayerDistance < 3.0) then
            local playerHeading = GetEntityHeading(playerPed)
            local playerLocation = GetEntityForwardVector(playerPed)
            local playerCoords = GetEntityCoords(playerPed)

            local canStillUse = #(GetEntityCoords(targetPed) - GetEntityCoords(playerPed)) < 3.0

            if canStillUse then
                events:Trigger("cuffs:cuff", function()
                    loadAnimDict('mp_arrest_paired')
                    TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
                end, GetPlayerServerId(closestPlayer), playerHeading, playerCoords, playerLocation)
            end
        end
    -- end, {lbl = ("PANED ISIKUT KÄERAUDADESSE"), anim = {animDict = 'mp_arrest_paired', anim = 'crook_p2_back_right'}})
end, function(item, data)
    local char = exports['players']:GetClientVar("character")
    if not char.faction or char.faction.group.faction_name ~= "LSPD" then return false end

    local closestPlayer, closestPlayerDistance = exports['modules']:getModule("Game").GetClosestPlayer()
    return (closestPlayer ~= -1 and closestPlayerDistance < 3.0)
end)

RegisterCommand('cuff', function(source, args)
    local char = exports['players']:GetClientVar("character")
    if not char.faction or char.faction.group.faction_name ~= "LSPD" then return end

    local closestPlayer, closestPlayerDistance = exports['modules']:getModule("Game").GetClosestPlayer()
    local playerPed = PlayerPedId()

    if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
        local targetPed = GetPlayerPed(closestPlayer)
        local playerHeading = GetEntityHeading(playerPed)
        local playerLocation = GetEntityForwardVector(playerPed)
        local playerCoords = GetEntityCoords(playerPed)

        events:Trigger("cuffs:cuff", function()
            loadAnimDict('mp_arrest_paired')
            TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
        end, GetPlayerServerId(closestPlayer), playerHeading, playerCoords, playerLocation)
    end
end)

RegisterCommand('hc', function(source, args)
    local char = exports['players']:GetClientVar("character")
    if not char.faction or char.faction.group.faction_name ~= "LSPD" then return end

    local closestPlayer, closestPlayerDistance = exports['modules']:getModule("Game").GetClosestPlayer()
    local playerPed = PlayerPedId()

    if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
        events:Trigger("cuffs:makeHard", function()
            print "making hard"
        end, GetPlayerServerId(closestPlayer), true)
    end
end)

RegisterCommand('sc', function(source, args)
    local char = exports['players']:GetClientVar("character")
    if not char.faction or char.faction.group.faction_name ~= "LSPD" then return end

    local closestPlayer, closestPlayerDistance = exports['modules']:getModule("Game").GetClosestPlayer()
    local playerPed = PlayerPedId()

    if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
        events:Trigger("cuffs:makeHard", function()
        end, GetPlayerServerId(closestPlayer), false)
    end
end)

RegisterCommand('uncuff', function(source, args)
    local char = exports['players']:GetClientVar("character")
    if not char.faction or char.faction.group.faction_name ~= "LSPD" then return end

    local closestPlayer, closestPlayerDistance = exports['modules']:getModule("Game").GetClosestPlayer()
    local playerPed = PlayerPedId()

    if closestPlayer ~= -1 and closestPlayerDistance < 3.0 then
        local targetPed = GetPlayerPed(closestPlayer)
        local playerHeading = GetEntityHeading(playerPed)
        local playerLocation = GetEntityForwardVector(playerPed)
        local playerCoords = GetEntityCoords(playerPed)

        events:Trigger("cuffs:uncuff", function()
            Wait(250)
            loadAnimDict('mp_arresting')
            TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
            Citizen.Wait(5500)
            ClearPedTasks(GetPlayerPed(-1))
        end, GetPlayerServerId(closestPlayer), playerHeading, playerCoords, playerLocation)
    end
end)

addAction({'phone', 'apple-iphone', 'nokia-phone', 'pixel-2-phone', 'samsung-s8'}, function(item, data)
    exports['jp-phone']:toggle()
end)

AddEventHandler("vehicle:addFakePlate", function(pEntity, pContext, pParams)
    doProgressBarManualRemove(25000, function()
        if exports['jp-interact']:isCloseToBoot(pEntity, PlayerPedId(), 1.8, pContext.model) and not IsPedInAnyVehicle(PlayerPedId(), false)
        and exports["keys"]:hasKeys(pEntity) and exports["inventory"]:hasEnoughOfItem("fake-plate", 1)
        and not exports["jp-flags"]:HasVehicleFlag(pEntity, 'fakePlate') then
            if removeItem('fake-plate', 1) then
                SetVehicleNumberPlateText(pEntity, exports['vehicle']:randomPlate())
                exports['jp-flags']:SetVehicleFlag(pEntity, "fakePlate", true)
            end
        end
    end, {anim = {animDict = "mini@repair", anim = "fixing_a_player"}, lbl = "Vahetab numbrimärki"})
end)

