local sql = exports['jp-sql2']

local itemPrices = {
    ['Spoiler'] = 500,
    ['FrontBumper'] = 500,
    ['RearBumper'] = 500,
    ['SideSkirt'] = 500,
    ['Exhaust'] = 500,
    ['Frame'] = 500,
    ['Grille'] = 500,
    ['Hood'] = 500,
    ['Fender'] = 500,
    ['RightFender'] = 500,
    ['Livery'] = 500,
    ['Perleascent'] = 500,
    ['WheelColour'] = 500,
    ['PrimaryColour'] = 500,
    ['SecondaryColour'] = 500,
    ['Roof'] = 500,
    ['TrimB'] = 500,
    ['ArchCover'] = 500,
    ['Tank'] = 500,

    ['Xenon'] = 500,
    ['XenonColor'] = 1000,
    ['WindowTint'] = 500,
    ['Extras'] = 0
}


local wheelTypes = {
    [0] = 'Sport',
    [1] = 'Muscle',
    [2] = 'Lowrider',
    [3] = 'SUV',
    [4] = 'Offroad',
    [5] = 'Tuner',
    [6] = 'Bike Wheels',
    [7] = 'High End',
}

local wheelPrices = {
    ['Sport'] = 1000,
    ['Muscle'] = 1000,
    ['Lowrider'] = 1000,
    ['SUV'] = 1000,
    ['Offroad'] = 1000,
    ['Tuner'] = 1000,
    ['Bike Wheels'] = 1000,
    ['High End'] = 1000,
}

function getItemCost(mod, value)
    if itemPrices[mod] then return itemPrices[mod] end

    if mod == 'FrontWheels' then
        return 0
    end

    if mod == "Engine" then
        return math.ceil(((500000 * 0.03) * (value+2)) / 2)
    end

    if mod == "Brakes" or mod == 'Transmission' or mod == 'Suspension' or mod == 'Armor' then
        return math.ceil(((500000 * 0.02) * (value+2)) / 2)
    end

    if mod == 'Turbo' then
        return math.ceil(((500000 * 0.03) * 4) / 3)
    end

    if wheelTypes[value] then
        return wheelPrices[wheelTypes[value]]
    end

    return 999999999
end

local lastUpdate = {}

RPC.register('tuner:updateMods', function(pSource, mod, value, vin, second)  
    if not lastUpdate[pSource] then lastUpdate[pSource] = 0 end
    local timeSince = os.time() - lastUpdate[pSource]

    if timeSince > 1 then
        lastUpdate[pSource] = os.time()

        local cid = exports['players']:getCharacter(pSource).cid
        local cost = getItemCost(mod, value)

        local data = sql:executeSync("SELECT mods FROM vehicles WHERE vin=? AND cid=?", {vin, cid})
        if data[1] then
            local mods = json.decode(data[1].mods)
            if mods[mod] == value and not second then return false end
            mods[mod] = value
            if second then
                mods[second.mod] = second.val
            end
            local nmods = json.encode(mods)
            
            if (cost > 0 and exports['inventory']:removeItem(pSource, 'cash', cost)) or cost == 0 then
                sql:executeSync("UPDATE vehicles SET mods=? WHERE vin=?", {nmods, vin})
                return true
            else
                return false
            end
        else
            return false
        end
    else
        TriggerClientEvent("DoLongHudText", pSource, "Aeglasemalt!", 'red')
        return false
    end
end)

RPC.register("toggleExtra", function(pSource, ind, enabled, vin)
    if not lastUpdate[pSource] then lastUpdate[pSource] = 0 end
    local timeSince = os.time() - lastUpdate[pSource]

    if timeSince > 0.3 then
        lastUpdate[pSource] = os.time()

        local cid = exports['players']:getCharacter(pSource).cid

        local data = sql:executeSync("SELECT mods FROM vehicles WHERE vin=? AND cid=?", {vin, cid})
        if data[1] then
            local mods = json.decode(data[1].mods)

            if not enabled then
                for i,v in pairs (mods['Extras']) do
                    if v == ind then
                        table.remove(mods['Extras'], i)
                    end
                end
            else
                if not mods['Extras'] then mods['Extras'] = {} end
                table.insert(mods['Extras'], ind)
            end
            
            local nmods = json.encode(mods)
            
            sql:executeSync("UPDATE vehicles SET mods=? WHERE vin=?", {nmods, vin})
            return true
        else
            return false
        end
    else
        TriggerClientEvent("DoLongHudText", pSource, "Aeglasemalt!", 'red')
        return false
    end
end)