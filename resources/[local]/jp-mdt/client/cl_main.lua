local enabled = false

function showUi()
    local character = exports['players']:GetClientVar('character')
    if not character then return end

    enabled = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        show = true,
        character = character
    })
end

function hideUi()
    enabled = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        show = false
    })
end

local char = exports['players']:GetClientVar('character')
local myFaction = char and char.faction

AddEventHandler("factions:updated", function(fac)
    myFaction = fac
end)

RegisterCommand("mdt", function()
    if enabled then 
        hideUi() 
    else
        if myFaction and WhitelistedFactions[myFaction.group.faction_name] then 
            showUi() 
        end
    end
end)

AddEventHandler("mdt:open", function()
    if enabled then 
        hideUi() 
    else
        if myFaction and WhitelistedFactions[myFaction.group.faction_name] then 
            showUi() 
        end
    end
end)

function getModelDisplayName(model)
    return GetLabelText(GetDisplayNameFromVehicleModel(model))
end

function parseVehicles(vehicles)
    for i,v in pairs (vehicles) do
        v.model = getModelDisplayName(v.model)
    end

    return vehicles
end

local housingInfo = exports['jp-housing']:getModule('info')
function parseHousing(properties)
    for i,v in pairs (properties) do
        local info = housingInfo[v.property_id]
        v.street = info and info.Street or 'Unknown'
    end

    return properties
end

RegisterNUICallback('nuiAction', function(data, cb)
    local content = data.data
    local action = data.action

    print ("NuiAction | "..json.encode(data))
    if myFaction and WhitelistedFactions[myFaction.group.faction_name] then 
        --* DASHBOARD
        if (action == 'fetchDashboardPage') then
            local result = RPC.execute('mdt:fetchDashboardPage')
            cb(result)

        --* PROFILES
        elseif (action == 'getProfileResults') then
            local results = RPC.execute('mdt:getProfileResults', content.query)
            cb(results)
        elseif (action == 'fetchProfileData') then
            local succ = RPC.execute('mdt:fetchProfileData', content.character_id)
            if succ then
                succ.vehicles = parseVehicles(succ.vehicles)
                succ.housing = parseHousing(succ.housing)
            end
            print ("licenses: "..json.encode(succ.licenses))
            cb(succ)
        elseif (action == 'updateProfile') then
            local result = RPC.execute('mdt:updateProfile', content.character_id, content)
            cb(result)
        elseif (action == 'makeWanted') then
            local result = RPC.execute('mdt:makeWanted', content.character_id, content.reason)
            cb(result)
        elseif (action == 'removeWarrant') then
            local result = RPC.execute('mdt:removeWarrant', content.character_id)
            cb(result)
        elseif (action == 'removeLicense') then
            local result = RPC.execute('mdt:removeLicense', content.character_id, content.license) 
            cb(result)

        --* VEHICLES
        elseif (action == 'getVehicleResults') then
            local vehicles = RPC.execute('mdt:getVehicleResults', content.query)
            vehicles = parseVehicles(vehicles)
            cb(vehicles)
        elseif (action == 'getVehicleData') then
            local vehicle = RPC.execute('mdt:getVehicleData', content.vin)
            vehicle.model = getModelDisplayName(vehicle.model)
            cb(vehicle)

        --* CHARGES
        elseif(action == 'chargePlayer') then
            --/ UNPACK A BIT
            local citizen_id, charges = content.citizen_id, content.charges
            local totalFine, totalJail = content.totalFine, content.totalJail

            local success = RPC.execute('mdt:chargePlayer', citizen_id, charges, totalFine, totalJail)
            cb(success)
            hideUi()
        elseif (action == 'closeNui') then
            hideUi()
        end
    end
end)

AddEventHandler("login:firstSpawn", function()
    SendNUIMessage({
        resetData = true
    })
end)