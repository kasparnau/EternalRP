local safes = {
    {
        vector3(2672.22, 3286.9, 55.24), 0.8, 0.8, 
        {
            heading=150,
            minZ=54.24,
            maxZ=55.24,
        }   
    },
    {
        vector3(1958.92, 3749.46, 32.34), 0.8, 0.7, {
            heading=30,
            --debugPoly=true,
            minZ=31.34,
            maxZ=32.24
          }
    },
    {
        vector3(1735.08, 6421.37, 35.04), 0.8, 0.7, {
            heading=64,
            --debugPoly=true,
            minZ=34.04,
            maxZ=34.94
        },
    },
    {
        vector3(1708.25, 4920.91, 42.06), 0.8, 0.7, {
            heading=55,
            --debugPoly=true,
            minZ=41.06,
            maxZ=41.96
        }
    },
    {vector3(-3250.68, 1004.44, 12.83), 0.8, 0.7, {
        heading=85,
        --debugPoly=true,
        minZ=11.83,
        maxZ=12.73
    }},
    {vector3(-3048.46, 585.38, 7.91), 0.8, 0.7, {
        heading=107,
        --debugPoly=true,
        minZ=6.91,
        maxZ=7.81
    }},
    {vector3(-2959.65, 386.45, 14.04), 0.8, 0.7, {
        heading=86,
        --debugPoly=true,
        minZ=13.04,
        maxZ=14.54
    }},
    {vector3(-1829.67, 798.29, 138.18), 0.8, 0.7, {
        heading=133,
        --debugPoly=true,
        minZ=136.58,
        maxZ=138.08
    }},
    {vector3(546.52, 2662.15, 42.16), 0.8, 0.7, {
        heading=98,
        --debugPoly=true,
        minZ=40.56,
        maxZ=42.06
    }},
    {vector3(1169.87, 2717.88, 37.16), 0.8, 0.7, {
        heading=91,
        --debugPoly=true,
        minZ=35.56,
        maxZ=37.66
    }},
    {vector3(1158.84, -314.17, 69.21), 0.8, 0.7, {
        heading=101,
        --debugPoly=true,
        minZ=67.61,
        maxZ=69.11
    }},
    {vector3(378.29, 333.99, 103.57), 0.8, 0.7, {
        heading=76,
        --debugPoly=true,
        minZ=101.97,
        maxZ=103.47
    }},
    {vector3(-1478.45, -375.91, 39.16), 0.8, 0.7, {
        heading=46,
        --debugPoly=true,
        minZ=37.56,
        maxZ=39.66
    }},
    {vector3(28.13, -1338.57, 29.5), 0.6, 0.7, {
        heading=91,
        --debugPoly=true,
        minZ=27.9,
        maxZ=29.4
    }},
    {
        vector3(-43.93, -1748.0, 29.42), 0.6, 0.7, {
            heading=141,
            --debugPoly=true,
            minZ=27.82,
            maxZ=29.32
        }
    }
}

local options = {
    {
        event = "jp-heists:shops:openSafe",
        icon = "fas fa-box-open",
        label = "Ava Seif",
    },
    {
        event = "jp-heists:shops:crackSafe",
        icon = "fas fa-user-secret",
        label = "Muugi Seif",
    },
}

for i = 1, #safes do
    local safe = safes[i]
    local scale = safe[4]
    
    local id = i

    exports['jp-interact']:AddPeekEntryByPolyTarget(("shop_safe_robbery_"..id), 
        safe[1], 
        safe[2], 
        safe[3], 
        scale,
        {
        options = options,
        params = {
            id = id 
        },
        distance = 3.0,
        isEnabled = function()
            local character = exports['players']:GetClientVar("character")
            local faction = character.faction
            return character ~= nil
        end
        }
    )
end

AddEventHandler("jp-heists:shops:openSafe", function(pEntity, pContext, pParameters)
    local success = RPC.execute("jp-heists:safes:openSafe", pParameters.id)
end)

AddEventHandler("jp-heists:shops:crackSafe", function(pEntity, pContext, pParameters)
    if skilling then return end
    if not exports['inventory']:canCarryItem('cash', 500) then
        TriggerEvent("DoLongHudText", "Sul pole piisavalt ruumi et sularaha võtta!", 'red')
        return
    end
    if not exports['inventory']:hasEnoughOfItem('safe-cracking-tool', 1) then
        TriggerEvent("DoLongHudText", "Sul pole vajalikku tööriista!", 'red')
        return
    end

    local canRob = RPC.execute('jp-heists:safes:startCrack', pParameters.id)

    if canRob then
        local success = exports['visual-memory']:start(5, 5, 10, 1500)

        print (tostring(success))
        if not success then
            exports['inventory']:removeItem("safe-cracking-tool", 1)
            TriggerEvent("DoLongHudText", "Sinu seifi murdmise tööriist läks katki!", 'red')
        else
            RPC.execute('jp-heists:safes:crackSuccessful', pParameters.id)
        end
    end
end)