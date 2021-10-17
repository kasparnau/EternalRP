itemsList = {
    ['vodka'] = {label = "Viin", weight = 1},
    ['beer'] = {label = "Õlu", weight = 1},
    ['whiskey'] = {label = "Viski", weight = 1},
    ['wine'] = {label = "Vein", weight = 1},

    ['coffee'] = {label = "Kohvi", weight = 1},
    ['cola'] = {label = "Coca-Cola", weight = 1},
    ['water'] = {label = "Vesi", weight = 1},
    ['sprunk'] = {label = "Sprunk", weight = 1},

    ['milk'] = {label = "Piim", weight = 1},

    ['prison-food'] = {label = "Vangla toit", weight = 5},

    ['hamburger'] = {label = "Hamburger", weight = 1},
    ['sandwich'] = {label = "Võileib", weight = 1},
    ['donut'] = {label = "Sõõrik", weight = 1},
    ['hot-dog'] = {label = "Hot Dog", weight = 1},
    ['pizza'] = {label = "Pizza viil", weight = 1},
    ['muffin'] = {label = "Muffin", weight = 1},
    ['fries'] = {label = "Friikad", weight = 1},
    ['churro'] = {label = "Churro", weight = 1},
    ['ice-cream'] = {label = "Jäätis", weight = 1},

    --** FRUITS
    ['peach'] = {label = "Virsik", weight = 1},
    ['apple'] = {label = "Õun", weight = 1},
    ['strawberry'] = {label = "Maasikas", weight = 1},
    ['kiwi'] = {label = "Kiivi", weight = 1},
    ['cherry'] = {label = "Kirrs", weight = 1},
    ['banana'] = {label = "Banaan", weight = 1},
    ['potato'] = {label = "Kartul", weight = 1},
    ['watermelon'] = {label = "Arbuus", weight = 1},
    ['lime'] = {label = "Laim", weight = 1},
    ['lemon'] = {label = "Sidrun", weight = 1},
    ['grapes'] = {label = "Viinamarjad", weight = 1},
    ['coconut'] = {label = "Kookospähkel", weight = 1},

    ['armor1'] = {label = "Armor", weight = 30},
    ['armor2'] = {label = "Heavy Armor", weight = 50},
    ['bandage'] = {label = "Side", description = "+30 HP", weight = 2},
    ['ifak'] = {label = "IFAK", description = "+100 HP", weight = 5},

    -- DOCUMENTS
    ['rental-papers'] = {label = "Laenutuspaberid", description = "Sõiduki rentimise tõend", unique = true, dontRemoveOnUse = true, weight = 0.25, nonStackable = true},
    ['drivers-license'] = {label = "Juhiluba", description = "Los Santos Juhiluba", unique = true, dontRemoveOnUse = true, weight = 0.25, nonStackable = true},
    ['citizen-card'] = {label = "ID-kaart", unique = true, dontRemoveOnUse = true, weight = 0.25, nonStackable = true},

    ['binoculars'] = {label = "Binokkel", dontRemoveOnUse = true, weight = 5},
    ['fake-plate'] = {label = "Võlts Numbrimärk", description = "Vaata läbi kolmanda silma et peale panna.", nonUsable = true, weight = 20},  --//* ?

    --*DRUGS
    ['fertilizer'] = {label = "Väetis", description = "Hmm", weight = 10},
    ['weed-seed'] = {label = "Kanepi Seeme", weight = 1},
    ['weed-6g'] = {label = "Kanepi Kotike (6g)", nonUsable = true, weight = 2}, --//*8 $140
    ['weed-24g'] = {label = "Kanepi Kott (24g)", nonUsable = true, weight = 8}, --//* $525
    ['weed-brick-600g'] = {label = "Kanepiplokk (600g)", nonUsable = true, weight = 200}, --//* $14,500
    ['joint'] = {label = "Pläru (3g)", weight = 2}, --//* $60-$90, = 3g + paper --// 10% RECOIL BOOST

    ['tups'] = {label = "Tups", weight = 1},

    ['meth-baggy'] = {label = "Metamfetamiin (5g)", weight = 2}, --//* SPEED BOOST 1.3x // $800 --IMP: DEPENDING ON PURITY 
    ['cocaine-baggy'] = {label = "Kokaiin (5g)", weight = 2}, --//* SPEED BOOST 1.2x // $300
    ['crack'] = {label = "Crack", weight = 2}, --//* SPEED BOOST --// 1.1x // $150-200

    ['cigarette'] = {label = "Sigaret", weight = 1},
    ['cigar'] = {label = "Sigar", weight = 1},

    ['rose'] = {label = "Roos", nonUsable = true, weight = 1},

    --*VALUABLES
    ['2ct-gold-chain'] = {label = "2ct Kuldkett", nonUsable = true, weight = 3}, --//* $150
    ['5ct-gold-chain'] = {label = "5ct Kuldkett", nonUsable = true, weight = 3}, --//* $275
    ['8ct-gold-chain'] = {label = "8ct Kuldkett", nonUsable = true, weight = 3}, --//* $400
    ['10ct-gold-chain'] = {label = "10ct Kuldkett", nonUsable = true, weight = 3}, --//* $550
    ['gold-bar'] = {label = "Kullakang", nonUsable = true, weight = 20}, --//* $4500
    ['rolex-watch'] = {label = "Rolexi Kell", nonUsable = true, weight = 1}, --//* $250
    ['valuable-goods'] = {label = "Väärtuslikud Asjad", nonUsable = true, weight = 1},
    ['inked-money-bag'] = {label = "", nonUsable = true, weight = 10},
    ['cash-stack'] = {label = "Raha Stack", weight = 0}, --//* 250

    ['trophy'] = {label = "Karikas", description = "Hea töö!", nonUsable = true, nonStackable = true, weight = 15},
    ['civ-trophy'] = {label = "Karikas", description = "Hea töö!", nonUsable = true, nonStackable = true, weight = 15},

    --*PHONES
    ['apple-iphone'] = {label = "iPhone 12", dontRemoveOnUse = true, weight = 5}, --//* $350
    ['nokia-phone'] = {label = "Nokia 3310", dontRemoveOnUse = true, weight = 5}, --//* $350
    ['phone'] = {label = "Nutitelefon", dontRemoveOnUse = true, weight = 5}, --//* $250
    ['pixel-2-phone'] = {label = "Pixel 2", dontRemoveOnUse = true, weight = 5}, --//* $350
    ['samsung-s8'] = {label = "Samsung S8", dontRemoveOnUse = true, weight = 5}, --//* $350

    ['radio'] = {label = "Raadio", dontRemoveOnUse = true, weight = 5}, --//* $1000
    ['radio-scanner'] = {label = "Raadio Skanner", dontRemoveOnUse = true, weight = 5}, --//* $500

    --* TOOLS
    ['basic_repair-kit'] = {label = "Paranduskomplekt", weight = 10}, --//* $1000
    ['repair-toolkit'] = {label = "Remonditööriistad", nonUsable = true, weight = 5}, --//* $50
    ['toolbox'] = {label = "Tööriistakast", weight = 1}, --//* $350
    ['hand-cuffs'] = {label = "Käerauad", weight = 5}, --//* $6000
    ['safe-cracking-tool'] = {label = "Seifi muukimise tööriist", description = "Huvitav mis sellega teha võiks?", weight = 15, nonUsable = true},

    --* USBS
    ['heist-usb-yellow'] = {label = "USB -tikk", description = "Huvitav 😏", weight = 1, nonUsable = true}, 
    ['heist-usb-red'] = {label = "USB -tikk", description = "Huvitav 😏", weight = 1, nonUsable = true}, 
    ['heist-usb-green'] = {label = "USB -tikk", description = "01000001 01000011 01000101 01000101 01001100 01000110", weight = 1, nonUsable = true}, 
    ['heist-usb-blue'] = {label = "USB -tikk", description = "Huvitav 😏", weight = 1, nonUsable = true}, 
    ['heist-usb-black'] = {label = "USB -tikk", description = "Huvitav 😏", weight = 1, nonUsable = true}, 

    --** LOCKPICKS
    ['advanced-lockpick'] = {label = "Multitööriist", description = "Hea muukimisvahend.", weight = 3, dontRemoveOnUse = true}, --* 4500
    ['lockpick-set'] = {label = "Muukraud", weight = 3, dontRemoveOnUse = true},  --* 900
    ['broken-lockpick'] = {label = "Katkine muukraud", description = "Rip, se läks katki :/", weight = 1, nonUsable = true},  --* 0

    --* WEAPONS
    ['pistol'] = {label = "COLT 1911", description = "Tavaline 9mm käsirelv.", isWeapon = true, weight = 10}, --//* $7500
    ['pistol2'] = {label = "Beretta M9", description = "Tavaline 9mm käsirelv, aga parem.", isWeapon = true, weight = 10}, --//* $10500
    ['combat-pistol'] = {label = "FN FNX-45", isWeapon = true, weight = 10}, --//* $11500
    ['pistol-50'] = {label = "Desert Eagle", description = "Suurte meeste relv.", isWeapon = true, weight = 20}, --//* $12500
    ['stun-gun'] = {label = "Taser", isWeapon = true, weight = 10}, --//* $2500?

    ['mini-smg'] = {label = "Mini SMG", isWeapon = true, weight = 15}, --//* $20K+
    ['machine-pistol'] = {label = "Tec 9", isWeapon = true, weight = 15}, --//* $20K+

    ['sniper-rifle'] = {label = "Sniper Rifle", isWeapon = true, weight = 85}, --//* $?
    ['mg'] = {label = "Light Machine Gun", isWeapon = true, weight = 85}, --//* $?
    ['heavy-pistol'] = {label = "Heavy Püstol", isWeapon = true, weight = 25}, --//* $12500

    ['assault-rifle'] = {label = "AK-47", isWeapon = true, weight = 60}, --//* $?
    ['assault-rifle2'] = {label = "M70", isWeapon = true, weight = 60}, --//* $?

    ['pump-shotgun'] = {label = "Pumppüss", isWeapon = true, weight = 75}, --//* $10K
    ['special-carbine'] = {label = "Special Carbine", isWeapon = true, weight = 60}, --//* $?

    ['m4'] = {label = "M4 Carbine", isWeapon = true, weight = 60}, --// PD
    ['glock'] = {label = "Glock 17", isWeapon = true, weight = 10}, --// PD
    ['weapon-ltl'] = {label = "LTL Pumppüss", isWeapon = true, weight = 40}, --// PD

    --//* MELEE
    ['knife'] = {label = "Nuga", isWeapon = true, weight = 5}, --//* $2000
    ['knuckle-dusters'] = {label = "Nukid", max = 1, isWeapon = true, weight = 5}, --//* $2500
    ['flashlight'] = {label = "Taskulamp", max = 1, isWeapon = true, weight = 5}, --//* $800
    ['nightstick'] = {label = "Kumminui", isWeapon = true, weight = 10}, --//* $1200
    ['switchblade'] = {label = "Taskunuga", isWeapon = true, weight = 5}, --//* $3500
    ['baseball-bat'] = {label = "Pesapalli Kurikas", isWeapon = true, weight = 25}, --//* $950

    --//* THROWABLES
    ['stun-grenade'] = {label = "Stun Granaat (SWAT)", isWeapon = true, weight = 1, description = "Ära osta kui pole SWAT"},
    ['weapon-brick'] = {label = "Telliskivi", isWeapon = true, weight = 10},

    --//* AMMO
    ['lmg-ammo'] = {label = "LMG Kuulid X50", weight = 3}, --//* $?
    ['pistol-ammo'] = {label = "Püstoli Kuulid X30", weight = 3}, --//* $?
    ['rifle-ammo'] = {label = "Rifle Kuulid X30", weight = 3}, --//* $?
    ['shotgun-ammo'] = {label = "Pumppüssi Kuulid X10", weight = 3}, --//* $?
    ['ltl-ammo'] = {label = "LTL Pumppüssi Kuulid X10", weight = 3}, --//* $?
    ['taser-ammo'] = {label = "Taserikassett X2", weight = 5},
    ['sub-ammo'] = {label = "SMG Kuulid X30", weight = 3}, --//* $?
    ['sniper-ammo'] = {label = "Sniper Kuulid X5", weight = 3}, --//* $?

    --* JOB ITEMS
    ['yarn'] = {label = "Lõng", description = "Sa võiksid teha sellest kangast!", weight = 0, nonUsable = true},
    ['fabric'] = {label = "Kangas", description = "Sa võiksid teha sellest riiet!", weight = 0, nonUsable = true},
    ['cloth'] = {label = "Riie", description = "Sa võiksid selle maha müüa!", weight = 0, nonUsable = true},

    ['stone'] = {label = "Kivi", description = "Huvitav, mis selle kivi sees on.", weight = 0, nonUsable = true},
    ['processed-stone'] = {label = "Töödeldud Kivi", description = "Huvitav, mida ma neist välja saaksin.", weight = 0, nonUsable = true},


    --// MISC
    ['cash'] = {label = "Raha", nonUsable = true, weight = 0},
    ['casino-chips'] = {label = "Kasiino Žetoonid", nonUsable = true, weight = 0},

    --// CRAFTING

    --// MATERIALS
    ['recyclable-material'] = {label = "Taaskasutatav Materjal", weight = 1},

    ['aluminium'] = {label = "Alumiinium", weight = 1},
    ['aluminium-oxide'] = {label = "Alumiiniumoksiid", weight = 1},
    ['steel'] = {label = "Teras", weight = 1},
    ['rubber'] = {label = "Kumm", weight = 1},
    ['scrap-metal'] = {label = "Vanametall", weight = 1},
    ['plastic'] = {label = "Plastik", weight = 1},
    ['copper'] = {label = "Vask", weight = 1},
    ['glass'] = {label = "Klaas", weight = 1},
    ['electronics'] = {label = "Elektroonikad", weight = 1},

    --// INGREDIENTS
    ['baking-soda'] = {label = "Toidusooda", nonUsable = true, weight = 1},
    ['rolling-paper'] = {label = "Tubaka Paber", nonUsable = true, weight = 1},
    ['glucose'] = {label = "Glükoos", nonUsable = true, weight = 1},
    ['empty-baggies'] = {label = "Tühjad Kotid", nonUsable = true, weight = 1},
    ['high-quality-scale'] = {label = "Kvaliteetne Kaal", nonUsable = true, weight = 2},
    ['small-scale'] = {label = "Väike Kaal", nonUsable = true, weight = 1},

    --// ADMIN
    ['holy-water'] = {label = "Püha Vesi", description = "+100 Hunger, +100 Thirst :)", weight = 0.69}
}