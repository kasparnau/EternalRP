Housing.missionTimeout = 3000 -- 50 mins == 3000
Housing.reuseTime = 3600 -- time until the property can be reused for robbery once robbed
Housing.staticObjectsChance = 30
Housing.secondsPerJobCreated = 900 -- every 15 mins a job has the potential to be created
Housing.maxJobsAtAGivenTime = 3

Housing.robInformation = {
    ["staticLocations"] = {
        ["v_int_16_mid"] = {
            ["maxLocations"] = 6, -- Max possible locations for a given model
            ["maxGenerationAttempts"] = 14, -- Max attempts to fill out the 6 locations , the greater the difference to locations the more likely to fill the max locations
            ["staticObjects"] = {
                ["prop_tv_flat_01"] = "stolentv",
                ["prop_micro_01"] = "stolenmicrowave",

            },
            ["staticPositions"] = {
                {["pos"] = vector4(-4.65,0.49,0.97,87.88),["itemCat"] = "electronics"},
                {["pos"] = vector4(8.68,-1.76,0.98,180.83),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(9.21,-1.47,0.98,271.55),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(8.42,3.84,0.98,1.97),["itemCat"] = "randomClothes"},
                {["pos"] = vector4(7.46,3.83,0.98,4.94),["itemCat"] = "randomClothes"},
                {["pos"] = vector4(6.48,2.59,0.98,91.51),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(3.26,-4.3,0.98,90.9),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-1.8,-6.1,0.97,180.04),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-3.29,-5.96,0.97,158.92),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(2.46,0.35,0.97,274.49),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(2.55,1.63,0.97,268.47),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(2.47,3.1,0.97,268.86),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(2.46,4.15,0.97,270.78),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(4.4, 4.25, 0.82, 0.0), ['itemCat'] = "randomToilet"}
            }
        },

        ["v_int_44"] = {
            ["maxLocations"] = 6,
            ["maxGenerationAttempts"] = 14,
            ["staticObjects"] = {
                ["prop_mp3_dock"] = "stolenmusic",
                ["prop_speaker_06"] = "stolenmusic",
                ["prop_speaker_01"] = "stolenmusic",
                ["v_club_roc_cab3"] = "stolenmusic",
                ["v_club_roc_cabamp"] = "stolenmusic",
                ["v_club_roc_eq1"] = "stolenmusic",
                ["v_club_roc_eq2"] = "stolenmusic",
                ["prop_amp_01"] = "stolenmusic",
                ["v_res_pctower"] = "stolencomputer",
                ["prop_laptop_01a"] = "stolencomputer", 
                ["prop_console_01"] = "stolencomputer",
                ["prop_micro_02"] = "stolenmicrowave",
                ["prop_tv_flat_03b"] = "stolentv",
                --["v_res_m_spanishbox"] = "jewllootbox",
                --["v_res_jewelbox"] = "jewllootbox",
            },
            ["staticPositions"] = {
                {["pos"] = vector4(-0.71,-5.78,1.68,85.63),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-0.71,-4.05,1.68,86.96),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-0.71,-2.35,1.68,77.51),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(3.23,1.12,1.68,1.8),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(1.93,5.92,1.01,2.45),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-0.75,0.63,5.58,176.36),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-1.55,7.23,5.58,275.78),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-1.54,8.72,5.58,270.13),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-2.9,8.59,5.59,6.21),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-5.66,8.6,5.59,358.11),["itemCat"] = "randomHousehold"},
                {["pos"] = vector4(-3.82,2.29,5.74,325.38),["itemCat"] = "randomClothes"},
                {["pos"] = vector4(-3.83,1.2,5.59,203.0),["itemCat"] = "randomClothes"},
                {["pos"] = vector4(5.82,-2.42,5.58,349.38),["itemCat"] = "randomClothes"},
            }
        },
        ["v_int_49"] = {
            ["maxLocations"] = 4,
            ["maxGenerationAttempts"] = 14,
            ["staticObjects"] = {
                
            },
            ["staticPositions"] = {
                {['pos'] = vector4(2.51, -1.466, 1.00, 0), ['itemCat'] = 'randomHousehold'}, --* UNDER BED
                {['pos'] = vector4(2.60, 1.02, 1.00, 0), ['itemCat'] = 'randomHousehold'}, --* UNDER BED 2
                {['pos'] = vector4(-0.48, 3.04, 1.00, 0), ['itemCat'] = 'randomClothes'}, --* WARDROBE
                {['pos'] = vector4(2.33, 3.40, 1.00, 0), ['itemCat'] = 'randomToilet'}, --* TOILET
                {['pos'] = vector4(2.33, -2.96, 1.66, 0), ['itemCat'] = 'randomHousehold'}, --* TABLE
                {['pos'] = vector4(-1.54, -1.35, 1.00, 0), ['itemCat'] = 'randomHousehold'}, --* BEHIND TV
                -- {['pos'] = vector4(2.51, -1.466, 1.00, 0), ['itemCat'] = 'randomHousehold'},
                -- {['pos'] = vector4(2.51, -1.466, 1.00, 0), ['itemCat'] = 'randomHousehold'},
                -- {["pos"] = vector4(1.86,3.73,1.01,3.76),["itemCat"] = "randomHousehold"},
                -- {["pos"] = vector4(-0.42,3.28,1.01,87.71),["itemCat"] = "randomClothes"},
                -- {["pos"] = vector4(2.05,1.13,1.01,255.46),["itemCat"] = "randomHousehold"},
                -- {["pos"] = vector4(2.52,-1.46,1.01,272.27),["itemCat"] = "randomHousehold"},
                -- {["pos"] = vector4(-1.02,-0.51,1.01,78.89),["itemCat"] = "electronics"},
                -- {["pos"] = vector4(-0.97,1.16,1.01,28.76),["itemCat"] = "electronics"},
            }
        },
        ["v_int_24"] = {
            ["maxLocations"] = 6,
            ["maxGenerationAttempts"] = 14,
            ["staticObjects"] = {
                ["prop_laptop_01a"] = "stolencomputer",
                ["prop_tv_flat_01"] = "stolentv",
                ["v_24_bdrm_mesh_arta"] = "stolenart",
                ["v_res_fh_speakerdock"] = "stolenmusic",
                ["v_24_lnb_mesh_artwork"] = "stolenart",
            },
            ["staticPositions"] = {
                {['pos'] = vector4(5.38, -1.5, 0.99, 0.0), ['itemCat'] = 'randomClothes'}, --* WARDROBE
                {['pos'] = vector4(5.4, -4.65, 0.99, 0.0), ['itemCat'] = 'randomClothes'}, --* WARDROBE
                {['pos'] = vector4(-6.63, -4.64, 1.00, 0.0), ['itemCat'] = 'randomHousehold'}, --* BED
                {['pos'] = vector4(-6.9, -2.00, 1.45, 0.0), ['itemCat'] = 'randomHousehold'}, --* BED
                {['pos'] = vector4(-19.20, -5.59, 5.00, 0.0), ['itemCat'] = 'randomFood'},
                {['pos'] = vector4(-14.9, -2.64, 5.00, 0.0), ['itemCat'] = 'randomFood'},
                {['pos'] = vector4(-11.35, -4.28, 5.00, 0.0), ['itemCat'] = 'electronics'},
                {['pos'] = vector4(-1.50, -1.17, 5.733, 0.0), ['itemCat'] = 'randomHousehold'},
                {['pos'] = vector4(7.40, -2.90, 5.51, 0.0), ['itemCat'] = 'randomHousehold'},
                {['pos'] = vector4(-3.92, 5.88, 5.71, 0.0), ['itemCat'] = 'randomHousehold'},
                {['pos'] = vector4(-0.18, 7.7, 5.7, 0.0), ['itemCat'] = 'randomHousehold'},
                {['pos'] = vector4(2.11, 1.66, 5.71, 0.0), ['itemCat'] = 'randomClothes'},
                {['pos'] = vector4(-8.9, 2.14, 5.3, 0.0), ['itemCat'] = 'randomFood'},
                {['pos'] = vector4(-10.4, 7.09, 0.99, 0.0), ['itemCat'] = 'electronics'}
                -- {["pos"] = vector4(6.75,6.31,6.41,41.62),["itemCat"] = "randomHousehold"},
                -- {["pos"] = vector4(6.58,-2.19,5.01,218.87),["itemCat"] = "randomHousehold"},
                -- {["pos"] = vector4(-0.46,-2.91,5.01,34.73),["itemCat"] = "randomHousehold"},
                -- {["pos"] = vector4(-5.39,-2.9,5.01,302.66),["itemCat"] = "randomHousehold"},
                -- {["pos"] = vector4(-9.17,4.92,5.38,352.09),["itemCat"] = "randomHousehold"},
                -- {["pos"] = vector4(-3.62,6.05,5.72,26.95),["itemCat"] = "electronics"},
                -- {["pos"] = vector4(-1.46,7.61,5.72,351.32),["itemCat"] = "randomHousehold"},
                -- {["pos"] = vector4(1.24,-0.81,1.0,260.02),["itemCat"] = "randomHousehold"},
                -- {["pos"] = vector4(-6.64,-1.66,1.0,82.89),["itemCat"] = "randomHousehold"},
                -- {["pos"] =  vector4(-6.66,-4.94,1.0,92.25),["itemCat"] = "randomHousehold"},
                -- {["pos"] = vector4(5.39,-1.91,1.0,284.25),["itemCat"] = "randomClothes"},
                -- {["pos"] = vector4(5.42,-3.99,1.0,268.65),["itemCat"] = "randomClothes"},
                -- {["pos"] = vector4(-15.92,-2.99,5.01,32.98),["itemCat"] = "randomHousehold"},
                -- {["pos"] = vector4(-17.59,-4.39,5.01,38.16),["itemCat"] = "randomHousehold"},
                -- {["pos"] = vector4(-19.39,-5.54,5.01,28.45),["itemCat"] = "randomHousehold"},

            }
        },
    }
}


Housing.robCat = {

    ["electronics"] = {
        ["catChance"] = 50, -- chance it will get added to generator if picked
        ["maxItems"] = 4,
        ["items"] = {
            {["name"] = "aluminium", ["chance"] = 30},
            {["name"] = "plastic", ["chance"] = 30},
            {["name"] = "copper", ["chance"] = 30},
            {["name"] = "electronics", ["chance"] = 5},
            {["name"] = "rubber", ["chance"] = 30},
            {["name"] = "scrap-metal", ["chance"] = 30},
        }
    },

    ["randomHousehold"] = {
        ["catChance"] = 30,
        ["maxItems"] = 6,
        ["items"] = {
            {["name"] = "aluminium-oxide", ["chance"] = 10},
            {["name"] = "lockpick-set", ["chance"] = 10},
            {["name"] = "advanced-lockpick", ["chance"] = 2},
            {["name"] = "cigarette", ["chance"] = 25},
            {["name"] = "cigar", ["chance"] = 3},
            {["name"] = "milk", ["chance"] = 10},

            {["name"] = "apple-iphone", ["chance"] = 6},
            {["name"] = "nokia-phone", ["chance"] = 6},
            {["name"] = "samsung-s8", ["chance"] = 6},
            {["name"] = "pixel-2-phone", ["chance"] = 6},
            {["name"] = "phone", ["chance"] = 6},

            {["name"] = "beer", ["chance"] = 10},
            {["name"] = "vodka", ["chance"] = 10},

            {["name"] = "rolex-watch", ["chance"] = 15},
            {["name"] = "pistol-ammo", ["chance"] = 10},
            {["name"] = "joint", ["chance"] = 30},
            {["name"] = "meth-baggy", ["chance"] = 10},
            {['name'] = 'high-quality-scale', ['chance'] = 5}
        }
    },

    ["randomClothes"] = {
        ["catChance"] = 70,
        ["maxItems"] = 4,
        ["items"] = {
            {["name"] = "armor1", ["chance"] = 3},
            {["name"] = "10ct-gold-chain", ["chance"] = 5},
            {["name"] = "2ct-gold-chain", ["chance"] = 30},
            {["name"] = "5ct-gold-chain", ["chance"] = 20},
            {["name"] = "8ct-gold-chain", ["chance"] = 10},
            {["name"] = "rolex-watch", ["chance"] = 30},
            {["name"] = "bandage", ["chance"] = 70},
            {["name"] = "ifak", ["chance"] = 10},
        }
    },
    ["randomFood"] = {
        ["catChance"] = 75,
        ["maxItems"] = 6,
        ["items"] = {
            {["name"] = "donut", ["chance"] = 50},
            {["name"] = "fries", ["chance"] = 50},
            {["name"] = "churro", ["chance"] = 50},
            {["name"] = "baking-soda", ["chance"] = 20},
            {["name"] = "hamburger", ["chance"] = 35},
            {["name"] = "water", ["chance"] = 90},
            {["name"] = "hot-dog", ["chance"] = 40},
            {["name"] = "ice-cream", ["chance"] = 60},
            {["name"] = "sandwich", ["chance"] = 60},
            {["name"] = "pizza", ["chance"] = 60},
            {["name"] = "muffin", ["chance"] = 15},
            {["name"] = "milk", ["chance"] = 30},
            {["name"] = "sprunk", ["chance"] = 60},
            {["name"] = "cola", ["chance"] = 60},
            {["name"] = "potato", ["chance"] = 30},
            {["name"] = "kiwi", ["chance"] = 30},
            {["name"] = "peach", ["chance"] = 30},
            {["name"] = "apple", ["chance"] = 30},
            {["name"] = "banana", ["chance"] = 70},
            {["name"] = "wine", ["chance"] = 40},
        }
    },
    ['randomToilet'] = {
        ['maxItems'] = 3,
        ['items'] = {
            {['name'] = 'cigarette', ['chance'] = 60},
            {['name'] = 'joint', ['chance'] = 20},
            {['name'] = 'donut', ['chance'] = 50},
            {['name'] = 'crack', ['chance'] = 10},
            {['name'] = 'meth-baggy', ['chance'] = 10},
            {['name'] = 'switchblade', ['chance'] = 2},
            {['name'] = 'rolling-papers', ['chance'] = 35},
            {['name'] = 'weed-6g', ['chance'] = 5},
            {['name'] = 'weed-seed', ['chance'] = 5},
            {['name'] = 'sandwich', ['chance'] = 25},
            {['name'] = 'steel', ['chance'] = 10}
        }
    }
}
