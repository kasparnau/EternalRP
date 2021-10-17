local enabled = false

function showUi()
    enabled = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        show = true
    })
end

function hideUi()
    enabled = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        show = false
    })
end

--* INIT myFaction
local char = exports['players']:GetClientVar('character')
myFaction = char and char.faction

AddEventHandler("players:CharacterVarChanged", function(name, old, new)
    if name == 'faction' then
        myFaction = new
        TriggerEvent("factions:updated", new)        
    end
end)

AddEventHandler("players:CharacterVarChanged", function(name, old, new)
    if name == 'character' then
        myFaction = new.faction
        TriggerEvent("factions:updated", myFaction)
    end
end)

RegisterCommand("faction", function()
    if myFaction and myFaction.member.rank_level >= Permissions.IS_ADMIN then
        if enabled then hideUi() else showUi() end
    end
end)
--* INIT myFaction END

RegisterNUICallback('nuiAction', function(data, cb)
    local content = data.data

    print ("NuiAction | "..json.encode(data))

    if myFaction and myFaction.member.rank_level >= Permissions.IS_ADMIN then
        if (data.action == 'getFactionInfo') then
            local info = RPC.execute('factions:getFactionInfo')
            cb(info)
        elseif (data.action == 'getFactionMembers') then
            local info = RPC.execute('factions:getFactionMembers')
            print (json.encode(info))
            cb(info)
        elseif (data.action == 'closeNui') then
            hideUi()
            cb('ok')

        -- * MEMBERS
        elseif (data.action == 'removeMember') then
            local succ = RPC.execute('factions:removeMember', content.player)
            cb(succ)
        elseif (data.action == 'setAlias') then
            local succ = RPC.execute('factions:setAlias', content.player, content.alias)
            cb(succ)
        elseif (data.action == 'addMember') then
            local succ = RPC.execute('factions:addMember', content.cid)
            cb(succ)
        elseif (data.action == 'getFactionRanks') then
            local succ = RPC.execute('factions:getFactionRanks')
            cb(succ)
        elseif (data.action == 'changeRank') then
            local succ = RPC.execute('factions:changeRank', content.player, content.rank)
            cb(succ)
        elseif (data.action == 'getFactionLogs') then
            local succ = RPC.execute('factions:getFactionLogs')
            cb(succ)

        -- * RANKS
        elseif (data.action == 'addRank') then
            local succ = RPC.execute('factions:addRank', content.name, content.level)
            cb(succ)
        elseif (data.action == 'removeRank') then
            local succ = RPC.execute('factions:removeRank', content.name)
            cb(succ)
        elseif (data.action) == 'changeRankName' then
            local succ = RPC.execute('factions:changeRankName', content.rank, content.name)
            cb(succ)
        elseif (data.action) == 'changeRankLevel' then
            local succ = RPC.execute('factions:changeRankLevel', content.rank, content.level)
            cb(succ)
                    --* VEHICLES
        elseif (data.action == 'getVehicleOptions') then
            local succ = RPC.execute('factions:getVehicleOptions')
            local resp = {}
            for i,v in pairs (succ) do
                local vehicleName = GetDisplayNameFromVehicleModel(v.model)
                v.name = GetLabelText(vehicleName)
                table.insert(resp, v) 
            end
            cb(resp)
        elseif (data.action == 'getVehicles') then
            local succ = RPC.execute('factions:getVehicles')
            local resp = {}
            for i,v in pairs (succ) do
                local vehicleName = GetDisplayNameFromVehicleModel(v.model)
                v.name = GetLabelText(vehicleName)
                table.insert(resp, v) 
            end
            cb(resp)
        elseif (data.action == 'buyVehicle') then
            local succ = RPC.execute('factions:buyVehicle', data.data.id)
            cb(succ)    
        end
    end
end)