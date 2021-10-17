function GenerateShopKeeperNPCs()
    for _, keeperLocations in ipairs(Generic.ShopKeeperLocations) do
        Generic.NPCS[#Generic.NPCS + 1] = {
            id = ('shopkeeper_%s'):format(_),
            name = ('shopkeeper_%s'):format(_),
            position = {
                coords = keeperLocations.xyz,
                heading = keeperLocations.w,
                random = false
            },
            pedType = 4,
            model = 'mp_m_shopkeep_01',
            networked = false,
            distance = 25.0,
            settings = {
                { mode = 'invincible', active = true },
                { mode = 'ignore', active = true },
                { mode = 'freeze', active = true },
            },
            scenario = "WORLD_HUMAN_STAND_MOBILE",
            flags = {
                ['isNPC'] = true,
                ['isShopKeeper'] = true,
            },
        }        
    end
end

function GenerateRentalNPC()
    local keeperLocations = Generic.RentalLocations[1]
    Generic.NPCS[#Generic.NPCS + 1] = {
        id = ('rental_npc'),
        name = ('rental_npc'),
        position = {
            coords = keeperLocations.xyz,
            heading = keeperLocations.w,
            random = false
        },
        pedType = 4,
        model = 'a_m_y_business_02',
        networked = false,
        distance = 100.0,
        settings = {
            { mode = 'invincible', active = true },
            { mode = 'ignore', active = true },
            { mode = 'freeze', active = true },
            { mode = 'collision', active = true }
        },
        scenario = "WORLD_HUMAN_STAND_MOBILE",
        flags = {
            ['isNPC'] = true,
        },
    }        
end

function GenerateImpoundNPC()
    local keeperLocations = Generic.ImpoundLocations[1]
    Generic.NPCS[#Generic.NPCS + 1] = {
        id = ('impound_npc'),
        name = ('impound_npc'),
        position = {
            coords = keeperLocations.xyz,
            heading = keeperLocations.w,
            random = false
        },
        pedType = 4,
        model = 's_m_y_cop_01',
        networked = false,
        distance = 100.0,
        settings = {
            { mode = 'invincible', active = true },
            { mode = 'ignore', active = true },
            { mode = 'freeze', active = true },
            { mode = 'collision', active = true }
        },
        scenario = "CODE_HUMAN_MEDIC_TIME_OF_DEATH",
        flags = {
            ['isNPC'] = true,
        },
    }        
end

function GeneratePaycheckManager()
    Generic.NPCS[#Generic.NPCS + 1] = {
        id = "paycheck_banker",
        name = "Bank Account Manager",
        pedType = 4,
        model = "cs_bankman",
        networked = false,
        distance = 25.0,
        position = {
          coords = vector3(242.020568847656, 227.114593505859, 106.031478881835),
          heading = 160.0,
          random = false
        },
        appearance = nil,
        settings = {
            { mode = "invincible", active = true },
            { mode = "ignore", active = true },
            { mode = "freeze", active = true },
            { mode = "collision", active = true }
        },
        flags = {
            ['isNPC'] = true,
        },
        scenario = "PROP_HUMAN_SEAT_CHAIR_UPRIGHT"
      }      
end

function GenerateToolShopNPCs()
    for _, keeperLocations in ipairs(Generic.ToolShopLocations) do
        Generic.NPCS[#Generic.NPCS + 1] = {
            id = ('toolshop_%s'):format(_),
            name = ('toolshop_%s'):format(_),
            position = {
                coords = keeperLocations.xyz,
                heading = keeperLocations.w,
                random = false
            },
            pedType = 4,
            model = 'a_m_m_hillbilly_01',
            networked = false,
            distance = 200.0,
            settings = {
                { mode = 'invincible', active = true },
                { mode = 'ignore', active = true },
                { mode = 'freeze', active = true },
            },
            scenario = "CODE_HUMAN_MEDIC_TIME_OF_DEATH",
            flags = {
                ['isNPC'] = true,
                ['isToolShopNPC'] = true,
            },
        }        
    end
end

function GenerateJobCenterNPC()
    Generic.NPCS[#Generic.NPCS + 1] = {
        id = ('job_center'),
        name = ('job_center'),
        position = {
            coords = vector3(-268.31207275391,-957.61315917969,30.217529296875),
            heading = 206.92913818359,
            random = false
        },
        pedType = 4,
        model = 'a_m_y_business_01',
        networked = false,
        distance = 25.0,
        settings = {
            { mode = 'invincible', active = true },
            { mode = 'ignore', active = true },
            { mode = 'freeze', active = true },
        },
        scenario = "WORLD_HUMAN_CLIPBOARD",
        flags = {
            ['isNPC'] = true,
        },
    }        
end

function GenerateWeaponShopNPCs()
    for _, keeperLocations in ipairs(Generic.WeaponShopLocations) do
        Generic.NPCS[#Generic.NPCS + 1] = {
            id = ('weapon_shop_%s'):format(_),
            name = ('weapon_shop_%s'):format(_),
            position = {
                coords = keeperLocations.xyz,
                heading = keeperLocations.w,
                random = false
            },
            pedType = 4,
            model = 'cs_josef',
            networked = false,
            distance = 200.0,
            settings = {
                { mode = 'invincible', active = true },
                { mode = 'ignore', active = true },
                { mode = 'freeze', active = true },
            },
            scenario = "WORLD_HUMAN_STAND_MOBILE",
            flags = {
                ['isNPC'] = true,
                ['isWeaponShopNPC'] = true,
            },
        }       
    end
end

GenerateWeaponShopNPCs()
GenerateShopKeeperNPCs()
GenerateRentalNPC()
GenerateImpoundNPC()
GeneratePaycheckManager()
GenerateToolShopNPCs()
GenerateJobCenterNPC()

RegisterNetEvent("jp-npcs:location:fetch")
AddEventHandler("jp-npcs:location:fetch", function()
    TriggerClientEvent("jp-npcs:set:ped", source, Generic.NPCS)
end)
