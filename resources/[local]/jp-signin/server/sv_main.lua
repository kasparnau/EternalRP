local events = exports['events']

local onDuty = {}

exports('onDuty', function(source)
    return exports['players']:getCharacter(source).onDuty or false
end)

RegisterNetEvent("jp-signin:duty")
AddEventHandler("jp-signin:duty", function()
    local character = exports['players']:getCharacter(source)
    if not character then return end
    
    local faction = character.faction
    if faction and not character.onDuty then
        if faction.member.rank_level < 1 then
            TriggerClientEvent('DoLongHudText', source, "Te ei saa sisse logida.", 'red')
            return
        end

        exports['players']:modifyPlayerCurrentCharacter(source, 'onDuty', true)

        if faction.group.faction_name == 'LSPD' then TriggerClientEvent('DoLongHudText', source, "10-41. Logisid sisse.", 'green') end

        TriggerClientEvent("jp-signin:signed_on", source)
    end
end)

RegisterNetEvent("jp-signoff:duty")
AddEventHandler("jp-signoff:duty", function()
    local character = exports['players']:getCharacter(source)
    if not character then return end
    
    local faction = character.faction

    if faction and character.onDuty then
        exports['players']:modifyPlayerCurrentCharacter(source, 'onDuty', false)

        if faction.group.faction_name == 'LSPD' then TriggerClientEvent('DoLongHudText', source, "10-42. Logisid välja.", 'red') end

        TriggerClientEvent("jp-signin:signed_off", source)
    end
end)