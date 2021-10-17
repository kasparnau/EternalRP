Build = {}
Build.func = {}

	-- <physicsDictionary>V_Apart_Midspaz</physicsDictionary>
	-- <physicsDictionary>V_Studio_Lo</physicsDictionary>

--[[
    DONE INTERIORS:
    v_int_49 : v_49_motelmp_shell
	
	v_int_16_mid : v_16_mid_shell
	v_int_16_low : v_16_studio_loshell

	v_int_24 : v_24_shell // NEED TO BLOCK WINDOWS
	v_int_24_full : v_24_shell // NEED TO BLOCK WINDOWS
	
	ex_int_office_03b_dlc : ex_office_03b_shell // NEED TO BLOCK WINDOWS
	v_int_61 : v_61_shell_walls // NEED TO BLOCK WINDOWS

	v_int_44 : v_44_shell2 // ADD DOOR, BLOCK WINDOWS, BLOCK GARAGE

	v_int_38 : v_38_barbers_shell // UNUSED/ADD DOOR BLOCK OUT WINDOW
	TODO:
	v_int_16_high : v_16_mesh_shell	
	
	bkr_biker_dlc_int_ware05 : bkr_ware06_walls_upgrade //NOT USED NOT NEEDED
]]

function getModule(module)
    if not Build then print("Warning: '" .. tostring(module) .. "' module doesn't exist") return false end
    return Build[module]
end

Build.Plans = {
	["v_int_49"] = {
		["shell"] = "v_49_motelmp_shell", --"v_49_motelmp_shell",
		["saveClient"] = true,
		["origin"] = vector3(152.7,-1005.07,-98.99),
		["generator"] = vector3(175.09986877441,-904.7946166992,-98.9),
		["spawnOffset"] = vector3(-1.0, -3.0, 0),
		["bedOffset"] = vector4(1.82,-0.66,1.59,88.27),
		["modulo"] = {
			["multi"] = {
				x = 12.0,
				y = 12.0,
				z = -14.0,
			},
			["xLimit"] = 24,
			["yLimit"] = 2,
		},
		["interact"] = {
			[1] = {
				
				["offset"] = vector3(-1.04,3.4,1.20),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["housingMain"] = {"Vaheta Tegelast","jp-housing:swapCharacter"},
			},
			[2] = {
				
				["offset"] = vector3(-0.96,-3.59,1.20),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["housingMain"] = {"Lahku","jp-housing:leave"},
			},
			[3] = {
				
				["offset"] = vector3(-1.6,1.2,1.0),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["housingMain"] = {"Ava Stash","jp-housing:stash"},
			}
		}
	},

	["v_int_16_mid"] = {
		["shell"] = "v_16_mid_shell", --"v_16_mid_shell",
		["saveClient"] = true,
		["origin"] = vector3(347.04724121094,-1000.2844848633,-99.194671630859),
		["generator"] = vector3(175.09986877441,-904.7946166992,-98.999984741211),
		["spawnOffset"] = vector3(3.6,-15.0,0.7),
		["backSpawnOffset"] = vector3(-3.8,5.2,0.7),
		["bedOffset"] = vector4(7.18,1.43,1.47,271.37),
		["offsetX"] = {
			["num"] = 175.09986877441,
			["multi"] = 25.0
		},
		["offsetY"] = {
			["num"] = -774.7946166992,
			["multi"] = 0.0
		},
		["offsetZ"] = {
			["num"] = 0.0,
			["multi"] = 0.0
		},
		["interact"] = {
			[1] = {
				["offset"] = vector3(8.0,4.0,1.1),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["housingMain"] = {"Vaheta Tegelast","jp-housing:swapCharacter"},
			},
			[2] = {
				["offset"] = vector3(4.3,-15.95,0.95),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["housingMain"] = {"Lahku","jp-housing:leave"},
			},
			[3] = {
				["offset"] = vector3(9.8,-1.35,0.15),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				["housingMain"] = {"Ava Stash","jp-housing:stash"},
			}
		}
	},

	["v_int_72_l"] = {
		["shell"] = "v_72_garagel_shell",
		["saveClient"] = true,
		["origin"] = vector3(228.54,-999.84,-98.99),
		["generator"] = vector3(227.391,-1035.0,-98.99),
		["spawnOffset"] = vector3(9.5,-12.7,2.0),
		["offsetX"] = {
			["num"] = 175.09986877441,
			["multi"] = 25.0
		},
		["offsetY"] = {
			["num"] = -774.7946166992,
			["multi"] = 0.0
		},
		["offsetZ"] = {
			["num"] = 0.0,
			["multi"] = 0.0
		},
		["interact"] = {
			[1] = {
				["offset"] = vector3(9.5,-12.7,1.0),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				
				["housingMain"] = {"to Room","apartments:garageToHouse"},
				["housingSecondary"] = {"to Garage Door.","apartments:garageToWorld"}, 
			},
		}
	},

	["v_int_44"] = {
		["shell"] = "v_44_shell",
		["saveClient"] = false,
		["origin"] = vector3(-801.5,178.69,72.84),
		["generator"] = vector3(-811.5,178.69,-40.84),
		["spawnOffset"] = vector3(-5.5793,5.100,0.0),
		["backSpawnOffset"] = vector3(14.17921200,1.90079500,1.1),
		["offsetX"] = {
			["num"] = -811.5,
			["multi"] = 26.0
		},
		["offsetY"] = {
			["num"] = 0.0,
			["multi"] = 0.0
		},
		["offsetZ"] = {
			["num"] = 0.0,
			["multi"] = 0.0
		},
		["interact"] = {
			[1] = {
				["offset"] = vector3(-6.9,6.32,1.01),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				
				["housingMain"] = {"Lahku","jp-housing:leave"},
			},
			[2] = {
				["offset"] = vector3(-4.20, 1.70, 5.58),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				
				["housingMain"] = {"Vaheta Tegelast","jp-housing:swapCharacter"},
			},
			[3] = {
				["offset"] = vector3(7.70, -0.54, 1.67),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				
				["housingMain"] = {"Ava Stash","jp-housing:stash"},
			},
		},
	},

	["ex_int_office_03b_dlc"] = {
		["shell"] = "ex_office_03b_shell",
		["saveClient"] = false,
		["origin"] = vector3(-139.53950000,-629.07570000,167.82040000),
		["generator"] = vector3(162.78,-21.89,-44.35),
		["spawnOffset"] = vector3(-3.5793,3.100,0.0),
		["offsetX"] = {
			["num"] = -811.5,
			["multi"] = 26.0
		},
		["offsetY"] = {
			["num"] = 0.0,
			["multi"] = 0.0
		},
		["offsetZ"] = {
			["num"] = 0.0,
			["multi"] = 0.0
		},
		["interact"] = {
			[1] = {
				["offset"] = vector3(-4.73,3.11,1.02),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				
				["housingMain"] = {"Lahku","jp-housing:leave"},
			},
			[2] = {
				["offset"] = vector3(10.66, 9.05, 1.00),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				
				["housingMain"] = {"Ava Stash","jp-housing:stash"},
			},
			[3] = {
				["offset"] = vector3(2.73, 4.98, 1.00),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				
				["housingMain"] = {"Vaheta Tegelast","jp-housing:swapCharacter"},
			},
		},
	},

	-- Empty Buildings 

	["v_int_38"] = {	-- // NOT USED
		["shell"] = "v_38_barbers_shell",
		["saveClient"] = false,
		["origin"] = vector3(1212.77,-472.43,66.21),
		["spawnOffset"] = vector3(-1.4,-4.47,0.0),
		["interact"] = {
			[1] = {
				["offset"] = vector3(-0.89,-4.52,1.0),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				
				["housingMain"] = {"Lahku","jp-housing:leave"},
			},
		},
	},

	["bkr_biker_dlc_int_ware05"] = { -- // NOT USED
		["shell"] = "bkr_ware06_walls_upgrade",
		["saveClient"] = false,
		["origin"] = vector3(1165.09,-3191.71,-39.0),
		["spawnOffset"] = vector3(5.81353500,0.28204400,0.0),
		["interact"] = {
			[1] = {
				["offset"] = vector3(8.69,0.0,1.03),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				
				["housingMain"] = {"Lahku","jp-housing:leave"},
			},
		},
	},

	["v_int_16_low"] = {
		["shell"] = "v_16_studio_loshell",
		["saveClient"] = false,
		["origin"] = vector3(260.32970000 ,-997.42880000, -100.00000000),
		["spawnOffset"] = vector3(5.64, -9.82, -1.00),
		["interact"] = {
			[1] = {
				["offset"] = vector3(5.65,-10.03,-0.99),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				
				["housingMain"] = {"Lahku","jp-housing:leave"},
			},
			[2] = {
				["offset"] = vector3(-0.48, -6.53, 0.99),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				
				["housingMain"] = {"Vaheta Tegelast","jp-housing:swapCharacter"},
			},
			[3] = {
				["offset"] = vector3(5.55, -1.80, 0.99),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				
				["housingMain"] = {"Ava Stash","jp-housing:stash"},
			}
		},
	},

	["v_int_24"] = {
		["shell"] = "v_24_shell",
		["saveClient"] = false,
		["origin"] = vector3(3.19946300 ,529.78070000, 169.62620000),
		["spawnOffset"] = vector3(7.5793,6.400,7.0),
		["interact"] = {
			[1] = {
				["offset"] = vector3(8.05,6.18,6.41),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				
				["housingMain"] = {"Lahku","jp-housing:leave"},
			},
			[2] = {
				["offset"] = vector3(5.49, -3.33, 0.99),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				
				["housingMain"] = {"Vaheta Tegelast","jp-housing:swapCharacter"},
			},
			[3] = {
				["offset"] = vector3(-11.11, -4.47, 5.00),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				
				["housingMain"] = {"Ava Stash","jp-housing:stash"},
			},

		},
	},

	["v_int_61"] = {
		["shell"] = "v_61_shell_walls",
		["saveClient"] = false,
		["origin"] = vector3(-1153.18300000 ,-1518.34800000, 9.63082300),
		["spawnOffset"] = vector3(0.7,-3.5,0.0),
		["interact"] = {
			[1] = {
				["offset"] = vector3(0.72,-3.84,1.02),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				
				["housingMain"] = {"Lahku","jp-housing:leave"},
			},
			[2] = {
				["offset"] = vector3(4.78, 2.69, 1.00),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				
				["housingMain"] = {"Vaheta Tegelast","jp-housing:swapCharacter"},
			},
			[3] = {
				["offset"] = vector3(-4.21, 2.99, 1.00),
				["viewDist"] = 2.0,
				["useDist"] = 2.0,
				
				["housingMain"] = {"Ava Stash","jp-housing:stash"},
			},
		},
	},

	-- Instancing Buildings , not used on buildings that have to be created , must be already built MLO 

	["v_33_cur"] = {
		["instance"] = true,
		["origin"] = vector3(133.2307,-616.1162,205.1947),
		["darken"] = true
	}

}
