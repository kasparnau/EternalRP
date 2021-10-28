jobPoints = {
    ['Sewer'] = {
        {
            ['coords'] = vector3(1981.1604003906,5173.6879882812,47.629272460938),
            ['name'] = 'Lõng',

            ['worldText'] = 'Kogu lõnga',
            ['doText'] = 'Kogud lõnga',

            ['addItem'] = {itemId = 'yarn', qty = 1},
            ['max'] = 45,
            ['cooldown'] = 3000,
        },
        {
            ['coords'] = vector3(715.75384521484,-960.0,30.391967773438),
            ['name'] = 'Kangas',

            ['worldText'] = 'Tee kangast',
            ['doText'] = 'Teed kangast',

            ['addItem'] = {itemId = 'fabric', qty = 1},
            ['removeItem'] = {itemId = 'yarn', qty = 1},
            ['cooldown'] = 3000,
        },
        {
            ['coords'] = vector3(712.87915039062,-970.66815185547,30.391967773438),
            ['name'] = 'Riided',

            ['worldText'] = 'Tee riideid',
            ['doText'] = 'Teed riideid',

            ['addItem'] = {itemId = 'cloth', qty = 1},
            ['removeItem'] = {itemId = 'fabric', qty = 1},
            ['cooldown'] = 3000,
        },
        {
            ['coords'] = vector3(-822.93627929688,-1069.5823974609,11.317993164062),
            ['name'] = "Ostja",

            ['worldText'] = 'Müü riideid',
            ['doText'] = 'Müüd riideid',

            ['removeItem'] = {itemId = 'cloth', qty = 1},
            ['addItem'] = {itemId = 'cash', qty = 50},
            ['cooldown'] = 1000,
        }
    },
    ['Miner'] = {
        {
            ['coords'] = {vector3(2927.3010253906,2792.7561035156,40.518676757812), vector3(2951.9077148438,2769.4680175781,39.035888671875)},
            ['name'] = 'Kivi',

            ['worldText'] = 'Kaevanda kive',
            ['doText'] = 'Kaevandad kive',

            ['addItem'] = {itemId = 'stone', qty = 1},
            ['max'] = 20,
            ['cooldown'] = 7500,
        },
        {
            ['coords'] = vector3(289.46374511719,2861.8549804688,43.635864257812),
            ['name'] = "Töötlusjaam",

            ['worldText'] = 'Töötle kive',
            ['doText'] = 'Töötled ja pesed kive',

            ['addItem'] = {itemId = 'processed-stone', qty = 1},
            ['removeItem'] = {itemId = 'stone', qty = 1},
            ['cooldown'] = 7500,
        },
        {
            ['coords'] = vector3(1083.5867919922,-1974.3560791016,30.99853515625),
            ['name'] = "Ostja",

            ['worldText'] = 'Müü töödeldud kive',
            ['doText'] = 'Müüd töödeldud kive',

            ['removeItem'] = {itemId = 'processed-stone', qty = 1},
            ['addItem'] = {itemId = 'cash', qty = 100},
            ['cooldown'] = 7500,
        },
    }
}

--[[
    Sewer:
        45 yarn (135s), 
        45 yarn -> 45 fabric (135s), DIST: 6262
        45 fabric -> 45 cloth (135s), DIST: 11
        45 cloth -> 2250 cash (45s), DIST: 1539
        
        total: 450s (7.5min)
        dist: 7182m

    Miner:
        20 stone (100s)
        25 stone -> 20 processed-stone (60s), DIST: 2664
        20 processed-stone -> 2000 cash (100s), DIST: 4900

        total: 260s (4.33min)
        dist: 7564min
]]