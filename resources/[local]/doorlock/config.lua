Config = {}
Config.ShowUnlockedText = true
Config.CheckVersion = false
Config.CheckVersionDelay = 60 -- Minutes


Config.DoorList = {
------------------------------------------
--	MISSION ROW POLICE DEPARTMENT		--
------------------------------------------
	-- gabz_mrpd	FRONT DOORS
	{
		factions = { ['LSPD']=1 },
		locked = false,
		maxDistance = 2.0,
		doors = {
			{objHash = -1547307588, objHeading = 90.0, objCoords = vector3(434.7444, -983.0781, 30.8153)},
			{objHash = -1547307588, objHeading = 270.0, objCoords = vector3(434.7444, -980.7556, 30.8153)}
		},
		lockpick = true
	},
	
	-- gabz_mrpd	NORTH DOORS
	{
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		doors = {
			{objHash = -1547307588, objHeading = 180.0, objCoords = vector3(458.2087, -972.2543, 30.8153)},
			{objHash = -1547307588, objHeading = 0.0, objCoords = vector3(455.8862, -972.2543, 30.8153)}
		},
		
	},

	-- gabz_mrpd	SOUTH DOORS
	{
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		doors = {
			{objHash = -1547307588, objHeading = 0.0, objCoords = vector3(440.7392, -998.7462, 30.8153)},
			{objHash = -1547307588, objHeading = 180.0, objCoords = vector3(443.0618, -998.7462, 30.8153)}
		},
		
	},

	-- gabz_mrpd	LOBBY LEFT


	{
		factions = {['LSPD']=1},
		objHash = -1406685646,
		objHeading = 0.0,
		objCoords = vector3(441.13, -977.93, 30.82319),
		locked = true,
		maxDistance = 2.0,
		fixText = true
	
	},

	-- gabz_mrpd	LOBBY RIGHT
	{
		objHash = -96679321,
		objHeading = 180.0,
		objCoords = vector3(440.5201, -986.2335, 30.82319),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
	},

	-- gabz_mrpd	GARAGE ENTRANCE 1
	{
		objHash = 1830360419,
		objHeading = 269.78,
		objCoords = vector3(464.1591, -974.6656, 26.3707),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		fixText = true
	},

	-- gabz_mrpd	GARAGE ENTRANCE 2
	{
		objHash = 1830360419,
		objHeading = 89.87,
		objCoords = vector3(464.1566, -997.5093, 26.3707),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		fixText = true
	},
	
	-- gabz_mrpd	GARAGE ROLLER DOOR 1
	{
		objHash = 2130672747,
		objHeading = 0.0,
		objCoords = vector3(431.4119, -1000.772, 26.69661),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 6,
		garage = true,
		slides = true,
		audioRemote = true
	},
	
	-- gabz_mrpd	GARAGE ROLLER DOOR 2
	{
		objHash = 2130672747,
		objHeading = 0.0,
		objCoords = vector3(452.3005, -1000.772, 26.69661),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 6,
		garage = true,
		slides = true,
		audioRemote = true
	},
	
	-- gabz_mrpd	BACK GATE
	{
		objHash = -1603817716,
		objHeading = 90.0,
		objCoords = vector3(488.8948, -1017.212, 27.14935),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 6,
		slides = true,
		audioRemote = true
	},

	-- gabz_mrpd	BACK DOORS
	{
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		doors = {
			{objHash = -692649124, objHeading = 0.0, objCoords = vector3(467.3686, -1014.406, 26.48382)},
			{objHash = -692649124, objHeading = 180.0, objCoords = vector3(469.7743, -1014.406, 26.48382)}
		},
		
	},

	-- gabz_mrpd	MUGSHOT
	{
		objHash = -1406685646,
		objHeading = 180.0,
		objCoords = vector3(475.9539, -1010.819, 26.40639),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 1.5,
		fixText = true,
	},

	-- gabz_mrpd	CELL ENTRANCE 1
	{
		objHash = -53345114,
		objHeading = 270.0,
		objCoords = vector3(476.6157, -1008.875, 26.48005),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.35},
		audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7}
	},

	-- gabz_mrpd	CELL ENTRANCE 2
	{
		objHash = -53345114,
		objHeading = 180.0,
		objCoords = vector3(481.0084, -1004.118, 26.48005),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.35},
		audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7}
	},

	-- gabz_mrpd	CELL 1
	{
		objHash = -53345114,
		objHeading = 0.0,
		objCoords = vector3(477.9126, -1012.189, 26.48005),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.35},
		audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7}
	},

	-- gabz_mrpd	CELL 2
	{
		objHash = -53345114,
		objHeading = 0.0,
		objCoords = vector3(480.9128, -1012.189, 26.48005),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.35},
		audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7}
	},

	-- gabz_mrpd	CELL 3
	{
		objHash = -53345114,
		objHeading = 0.0,
		objCoords = vector3(483.9127, -1012.189, 26.48005),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.35},
		audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7}
	},

	-- gabz_mrpd	CELL 4
	{
		objHash = -53345114,
		objHeading = 0.0,
		objCoords = vector3(486.9131, -1012.189, 26.48005),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.35},
		audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7}
	},

	-- gabz_mrpd	CELL 5
	{
		objHash = -53345114,
		objHeading = 180.0,
		objCoords = vector3(484.1764, -1007.734, 26.48005),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.35},
		audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7}
	},

	-- gabz_mrpd	LINEUP
	{
		objHash = -288803980,
		objHeading = 90.0,
		objCoords = vector3(479.06, -1003.173, 26.4065),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		fixText = true
	},

	-- gabz_mrpd	OBSERVATION I
	{
		objHash = -1406685646,
		objHeading = 270.0,
		objCoords = vector3(482.6694, -983.9868, 26.40548),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		fixText = true
	},

	-- gabz_mrpd	INTERROGATION I
	{
		objHash = -1406685646,
		objHeading = 270.0,
		objCoords = vector3(482.6701, -987.5792, 26.40548),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		fixText = true
	},

	-- gabz_mrpd	OBSERVATION II
	{
		objHash = -1406685646,
		objHeading = 270.0,
		objCoords = vector3(482.6699, -992.2991, 26.40548),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		fixText = true
	},

	-- gabz_mrpd	INTERROGATION II
	{
		objHash = -1406685646,
		objHeading = 270.0,
		objCoords = vector3(482.6703, -995.7285, 26.40548),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		fixText = true
	},

	-- gabz_mrpd	EVIDENCE
	{
		objHash = -692649124,
		objHeading = 134.7,
		objCoords = vector3(475.8323, -990.4839, 26.40548),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		fixText = true
	},

	-- gabz_mrpd	ARMOURY 1
	{
		objHash = -692649124,
		objHeading = 90.0,
		objCoords = vector3(479.7507, -999.629, 30.78927),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		fixText = true
	},

	-- gabz_mrpd	ARMOURY 2
	{
		objHash = -692649124,
		objHeading = 181.28,
		objCoords = vector3(487.4378, -1000.189, 30.78697),
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		fixText = true
	},

	-- gabz_mrpd	SHOOTING RANGE
	{
		factions = { ['LSPD']=1 },
		locked = true,
		maxDistance = 2.0,
		doors = {
			{objHash = -692649124, objHeading = 0.0, objCoords = vector3(485.6133, -1002.902, 30.78697)},
			{objHash = -692649124, objHeading = 180.0, objCoords = vector3(488.0184, -1002.902, 30.78697)}
		},
		
	},

	-- gabz_mrpd	ROOFTOP
	{
		objCoords = vector3(464.3086, -984.5284, 43.77124),
		factions = { ['LSPD']=1 },
		objHeading = 90.000465393066,
		slides = false,
		audioRemote = false,
		maxDistance = 2.0,
		garage = false,
		objHash = -692649124,
		locked = true,
		fixText = true,
	},

	-- 
	{
		garage = false,
		objHash = -288803980,
		locked = true,
		maxDistance = 1.5,
		factions = { ['LSPD']=1 },
		lockpick = false,
		audioRemote = false,
		objCoords = vector3(475.9539, -1006.938, 26.40639),
		fixText = true,
		slides = false,
		objHeading = 180.00001525879,		
	},

	

	{
		audioRemote = false,
		factions = { ['LSPD']=1 },
		objHash = -53345114,
		objHeading = 270.13998413086,
		lockpick = false,
		slides = false,
		objCoords = vector3(476.6157, -1008.875, 26.48005),
		locked = true,
		garage = false,
		fixText = false,
		maxDistance = 1.5,		
	}
}



table.insert(Config.DoorList, {
	lockpick = false,
	audioRemote = false,
	locked = true,
	factions = { ['LSPD']=1 },
	slides = false,
	doors = {
		{objHash = -288803980, objHeading = 89.999977111816, objCoords = vector3(438.1971, -996.3167, 30.82319)},
		{objHash = -288803980, objHeading = 270.00003051758, objCoords = vector3(438.1971, -993.9113, 30.82319)}
 },
	maxDistance = 2.5,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- 
table.insert(Config.DoorList, {
	factions = { ['LSPD']=1 },
	objHeading = 134.97177124023,
	garage = false,
	objCoords = vector3(452.2663, -995.5254, 30.82319),
	lockpick = false,
	objHash = -96679321,
	locked = true,
	audioRemote = false,
	fixText = true,
	slides = false,
	maxDistance = 2.0,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- 
table.insert(Config.DoorList, {
	factions = { ['LSPD']=1 },
	objHeading = 225.02824401855,
	garage = false,
	objCoords = vector3(458.0894, -995.5247, 30.82319),
	lockpick = false,
	objHash = 149284793,
	locked = true,
	audioRemote = false,
	fixText = true,
	slides = false,
	maxDistance = 2.0,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- UNNAMED DOOR CREATED BY Pede
table.insert(Config.DoorList, {
	locked = true,
	objCoords = vector3(458.6543, -990.6498, 30.82319),
	maxDistance = 2.0,
	lockpick = false,
	objHash = -96679321,
	fixText = false,
	objHeading = 270.00003051758,
	factions = { ['LSPD']=1 },
	garage = false,
	audioRemote = false,
	slides = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- UNNAMED DOOR CREATED BY Pede
table.insert(Config.DoorList, {
	locked = true,
	objCoords = vector3(445.4067, -984.2014, 30.82319),
	maxDistance = 2.0,
	lockpick = false,
	objHash = -1406685646,
	fixText = true,
	objHeading = 89.999977111816,
	factions = { ['LSPD']=1 },
	garage = false,
	audioRemote = false,
	slides = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- UNNAMED DOOR CREATED BY Pede
table.insert(Config.DoorList, {
	objHash = -1406685646,
	audioRemote = false,
	slides = false,
	locked = true,
	factions = { ['LSPD']=1 },
	objHeading = 270.00003051758,
	lockpick = false,
	fixText = true,
	objCoords = vector3(458.6543, -976.8864, 30.82319),
	maxDistance = 2.0,
	garage = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- UNNAMED DOOR CREATED BY Pede
table.insert(Config.DoorList, {
	slides = false,
	doors = {
		{objHash = -288803980, objHeading = 270.00003051758, objCoords = vector3(469.4406, -985.0313, 30.82319)},
		{objHash = -288803980, objHeading = 89.999977111816, objCoords = vector3(469.4406, -987.4377, 30.82319)}
 },
	locked = true,
	maxDistance = 2.5,
	audioRemote = false,
	factions = { ['LSPD']=1 },
	lockpick = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- UNNAMED DOOR CREATED BY Pede
table.insert(Config.DoorList, {
	slides = false,
	doors = {
		{objHash = -1406685646, objHeading = 180.00001525879, objCoords = vector3(475.3837, -989.8247, 30.82319)},
		{objHash = -96679321, objHeading = 180.00001525879, objCoords = vector3(472.9777, -989.8247, 30.82319)}
 },
	locked = true,
	maxDistance = 2.5,
	audioRemote = false,
	factions = { ['LSPD']=1 },
	lockpick = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- UNNAMED DOOR CREATED BY Pede
table.insert(Config.DoorList, {
	slides = false,
	doors = {
		{objHash = 149284793, objHeading = 180.00001525879, objCoords = vector3(475.3837, -984.3722, 30.82319)},
		{objHash = 149284793, objHeading = 0.0, objCoords = vector3(472.9781, -984.3722, 30.82319)}
 },
	locked = true,
	maxDistance = 2.5,
	audioRemote = false,
	factions = { ['LSPD']=1 },
	lockpick = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- UNNAMED DOOR CREATED BY Pede
table.insert(Config.DoorList, {
	slides = false,
	doors = {
		{objHash = -96679321, objHeading = 270.00003051758, objCoords = vector3(479.7534, -988.6204, 30.82319)},
		{objHash = -1406685646, objHeading = 270.00003051758, objCoords = vector3(479.7534, -986.2151, 30.82319)}
 },
	locked = true,
	maxDistance = 2.5,
	audioRemote = false,
	factions = { ['LSPD']=1 },
	lockpick = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- UNNAMED DOOR CREATED BY Pede
table.insert(Config.DoorList, {
	slides = false,
	garage = false,
	fixText = true,
	audioRemote = false,
	objHash = -1406685646,
	objHeading = 89.999977111816,
	maxDistance = 2.0,
	lockpick = false,
	objCoords = vector3(476.7512, -999.6307, 30.82319),
	factions = { ['LSPD']=1 },
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- UNNAMED DOOR CREATED BY Pede
table.insert(Config.DoorList, {
	objHash = -1406685646,
	locked = true,
	slides = false,
	garage = false,
	lockpick = false,
	objHeading = 45.028198242188,
	fixText = true,
	audioRemote = false,
	maxDistance = 2.0,
	objCoords = vector3(448.9868, -990.2007, 35.10376),
	factions = { ['LSPD']=1 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- UNNAMED DOOR CREATED BY Pede
table.insert(Config.DoorList, {
	slides = false,
	locked = true,
	maxDistance = 2.0,
	objCoords = vector3(448.9868, -981.5785, 35.10376),
	factions = { ['LSPD']=1 },
	fixText = false,
	lockpick = false,
	objHash = -96679321,
	objHeading = 134.97177124023,
	audioRemote = false,
	garage = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

--// EMS MEDICAL PILLBOX

-- PBM_1
table.insert(Config.DoorList, {
	factions = { ['EMS']=1, ['LSPD']=1 },
	slides = false,
	
	objHeading = 249.98275756836,
	fixText = true,
	maxDistance = 2.0,
	garage = false,
	objCoords = vector3(313.4801, -595.4583, 43.43391),
	locked = true,
	audioRemote = false,
	objHash = 854291622,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- PBM_2
table.insert(Config.DoorList, {
	garage = false,
	locked = true,
	maxDistance = 2.0,
	fixText = true,
	factions = { ['EMS']=1, ['LSPD']=1 },
	slides = false,
	audioRemote = false,
	objHeading = 160.00003051758,
	objCoords = vector3(309.1337, -597.7515, 43.43391),
	objHash = 854291622,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- PBM_3
table.insert(Config.DoorList, {
	fixText = true,
	objHeading = 70.01732635498,
	factions = { ['EMS']=1, ['LSPD']=1 },
	maxDistance = 2.0,
	audioRemote = false,
	locked = true,
	lockpick = false,
	objHash = 854291622,
	slides = false,
	objCoords = vector3(303.9596, -572.5579, 43.43391),
	garage = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

--// BIG BANK

-- vault_1
-- table.insert(Config.DoorList, {
-- 	locked = true,
-- 	audioRemote = false,
-- 	fixText = true,
-- 	factions = { ['LSPD']=1 },
-- 	slides = false,
-- 	garage = false,
-- 	objCoords = vector3(256.3116, 220.6579, 106.4296),
-- 	lockpick = false,
-- 	maxDistance = 2.0,
-- 	objHeading = 340.00003051758,
-- 	objHash = -222270721,		
-- 	-- oldMethod = true,
-- 	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
-- 	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
-- 	-- autoLock = 1000
-- })

-- -- vault_2
-- table.insert(Config.DoorList, {
-- 	factions = { ['LSPD']=1 },
-- 	locked = true,
-- 	slides = false,
-- 	fixText = true,
-- 	objHash = 746855201,
-- 	objHeading = 250.00003051758,
-- 	garage = false,
-- 	maxDistance = 2.0,
-- 	lockpick = false,
-- 	audioRemote = false,
-- 	objCoords = vector3(262.1981, 222.5188, 106.4296),		
-- 	-- oldMethod = true,
-- 	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
-- 	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
-- 	-- autoLock = 1000
-- })

-- UNNAMED DOOR CREATED BY Pede
table.insert(Config.DoorList, {
	lockpick = false,
	objHash = 1956494919,
	maxDistance = 2.0,
	locked = true,
	slides = false,
	fixText = false,
	garage = false,
	objCoords = vector3(236.5488, 228.3147, 110.4328),
	audioRemote = false,
	factions = { ['LSPD']=1 },
	objHeading = 160.00001525879,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- UNNAMED DOOR CREATED BY Pede
table.insert(Config.DoorList, {
	lockpick = false,
	objHash = 1956494919,
	maxDistance = 2.0,
	locked = true,
	slides = false,
	fixText = false,
	garage = false,
	objCoords = vector3(237.7704, 227.87, 106.426),
	audioRemote = false,
	factions = { ['LSPD']=1 },
	objHeading = 340.00003051758,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- UNNAMED DOOR CREATED BY Pede
table.insert(Config.DoorList, {
	lockpick = false,
	objHash = 1956494919,
	maxDistance = 2.0,
	locked = true,
	slides = false,
	fixText = false,
	garage = false,
	objCoords = vector3(256.6172, 206.1522, 110.4328),
	audioRemote = false,
	factions = { ['LSPD']=1 },
	objHeading = 250.00003051758,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- UNNAMED DOOR CREATED BY Pede
table.insert(Config.DoorList, {
	lockpick = false,
	objHash = 1956494919,
	maxDistance = 2.0,
	locked = true,
	slides = false,
	fixText = false,
	garage = false,
	objCoords = vector3(266.3624, 217.5697, 110.4328),
	audioRemote = false,
	factions = { ['LSPD']=1 },
	objHeading = 340.00003051758,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- END BANK DOORS

-- Benny's
table.insert(Config.DoorList, {
	maxDistance = 6.0,
	objHash = -427498890,
	slides = 6.0,
	fixText = false,
	locked = false,
	objCoords = vector3(-205.6828, -1310.683, 30.29572),
	lockpick = false,
	audioRemote = false,
	objHeading = 0.0,
	factions = { ['LSPD']=1, ['Mechanic']=1 },
	garage = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})


-- 
table.insert(Config.DoorList, {
	maxDistance = 2.5,
	audioRemote = false,
	slides = false,
	lockpick = false,
	factions = { ['LSPD']=1 },
	locked = true,
	doors = {
		{objHash = -288803980, objHeading = 180.00001525879, objCoords = vector3(469.9274, -1000.544, 26.40548)},
		{objHash = -288803980, objHeading = 0.0, objCoords = vector3(467.5222, -1000.544, 26.40548)}
 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	locked = true,
	doors = {
		{objHash = 741314661, objHeading = 289.17520141602, objCoords = vector3(1830.134, 2703.499, 44.4467)},
		{objHash = 741314661, objHeading = 110.00004577637, objCoords = vector3(1835.285, 2689.104, 44.4467)}
 },
	maxDistance = 6.0,
	lockpick = false,
	audioRemote = false,
	slides = true,
	factions = { ['LSPD']=1 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	maxDistance = 2.0,
	garage = false,
	locked = true,
	objHeading = 359.62673950195,
	slides = false,
	lockpick = false,
	audioRemote = false,
	fixText = false,
	objHash = -1033001619,
	factions = { ['LSPD']=1 },
	objCoords = vector3(1827.726, 2584.6, 46.09929),		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	maxDistance = 2.5,
	lockpick = false,
	audioRemote = false,
	locked = true,
	factions = { ['LSPD']=1 },
	doors = {
		{objHash = 262839150, objHeading = 270.07366943359, objCoords = vector3(1791.114, 2592.504, 46.31247)},
		{objHash = 1645000677, objHeading = 89.926338195801, objCoords = vector3(1791.063, 2595.103, 46.31176)}
 },
	slides = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	objCoords = vector3(1819.129, 2593.64, 46.09929),
	maxDistance = 2.0,
	factions = { ['LSPD']=1 },
	objHash = -1033001619,
	lockpick = false,
	audioRemote = false,
	garage = false,
	slides = false,
	locked = true,
	fixText = false,
	objHeading = 89.890563964844,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	factions = { ['LSPD']=1 },
	lockpick = false,
	objCoords = vector3(1797.761, 2596.565, 46.38731),
	objHeading = 179.99987792969,
	audioRemote = false,
	fixText = false,
	objHash = -1156020871,
	locked = true,
	slides = false,
	garage = false,
	maxDistance = 2.0,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	fixText = false,
	objCoords = vector3(1798.09, 2591.687, 46.41784),
	lockpick = false,
	objHeading = 179.99987792969,
	locked = true,
	objHash = -1156020871,
	factions = { ['LSPD']=1 },
	audioRemote = false,
	garage = false,
	maxDistance = 2.0,
	slides = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	factions = { ['LSPD']=1 },
	objHash = -1033001619,
	audioRemote = false,
	objHeading = 359.62673950195,
	fixText = false,
	garage = false,
	lockpick = false,
	slides = false,
	maxDistance = 2.0,
	objCoords = vector3(1827.365, 2587.547, 46.09929),
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	factions = { ['LSPD']=1 },
	objHash = -1033001619,
	audioRemote = false,
	objHeading = 89.890563964844,
	fixText = false,
	garage = false,
	lockpick = false,
	slides = false,
	maxDistance = 2.0,
	objCoords = vector3(1826.466, 2585.271, 46.09929),
	locked = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	audioRemote = false,
	garage = false,
	slides = false,
	factions = { ['LSPD']=1 },
	objHash = -1033001619,
	objCoords = vector3(1837.697, 2585.24, 46.09929),
	objHeading = 89.890563964844,
	fixText = false,
	locked = true,
	maxDistance = 2.0,
	lockpick = false,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	locked = true,
	slides = true,
	lockpick = false,
	doors = {
		{objHash = 741314661, objHeading = 252.02267456055, objCoords = vector3(1813.749, 2488.907, 44.46368)},
		{objHash = 741314661, objHeading = 70.905723571777, objCoords = vector3(1808.992, 2474.545, 44.48077)}
 },
	audioRemote = false,
	maxDistance = 6.0,
	factions = { ['LSPD']=1 },		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})


-- prison
table.insert(Config.DoorList, {
	doors = {
		{objHash = 741314661, objHeading = 206.12783813477, objCoords = vector3(1762.542, 2426.507, 44.43787)},
		{objHash = 741314661, objHeading = 26.757732391357, objCoords = vector3(1749.142, 2419.812, 44.42517)}
 },
	audioRemote = false,
	factions = { ['LSPD']=1 },
	lockpick = false,
	slides = true,
	locked = true,
	maxDistance = 6.0,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	doors = {
		{objHash = 741314661, objHeading = 173.02418518066, objCoords = vector3(1667.669, 2407.648, 44.42879)},
		{objHash = 741314661, objHeading = 353.00042724609, objCoords = vector3(1652.984, 2409.571, 44.44308)}
 },
	audioRemote = false,
	factions = { ['LSPD']=1 },
	lockpick = false,
	slides = true,
	locked = true,
	maxDistance = 6.0,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	doors = {
		{objHash = 741314661, objHeading = 118.08155059814, objCoords = vector3(1558.221, 2469.349, 44.39529)},
		{objHash = 741314661, objHeading = 298.04623413086, objCoords = vector3(1550.93, 2482.743, 44.39529)}
 },
	audioRemote = false,
	factions = { ['LSPD']=1 },
	lockpick = false,
	slides = true,
	locked = true,
	maxDistance = 6.0,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	doors = {
		{objHash = 741314661, objHeading = 87.052070617676, objCoords = vector3(1546.983, 2576.13, 44.39033)},
		{objHash = 741314661, objHeading = 267.01473999023, objCoords = vector3(1547.706, 2591.282, 44.50947)}
 },
	audioRemote = false,
	factions = { ['LSPD']=1 },
	lockpick = false,
	slides = true,
	locked = true,
	maxDistance = 6.0,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	doors = {
		{objHash = 741314661, objHeading = 54.545989990234, objCoords = vector3(1575.719, 2667.152, 44.50947)},
		{objHash = 741314661, objHeading = 233.70986938477, objCoords = vector3(1584.653, 2679.75, 44.50947)}
 },
	audioRemote = false,
	factions = { ['LSPD']=1 },
	lockpick = false,
	slides = true,
	locked = true,
	maxDistance = 6.0,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	doors = {
		{objHash = 741314661, objHeading = 207.18063354492, objCoords = vector3(1662.011, 2748.703, 44.44669)},
		{objHash = 741314661, objHeading = 27.17546081543, objCoords = vector3(1648.411, 2741.668, 44.44669)}
 },
	audioRemote = false,
	factions = { ['LSPD']=1 },
	lockpick = false,
	slides = true,
	locked = true,
	maxDistance = 6.0,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	doors = {
		{objHash = 741314661, objHeading = 339.61529541016, objCoords = vector3(1762.196, 2752.489, 44.44669)},
		{objHash = 741314661, objHeading = 160.00001525879, objCoords = vector3(1776.701, 2747.148, 44.44669)}
 },
	audioRemote = false,
	factions = { ['LSPD']=1 },
	lockpick = false,
	slides = true,
	locked = true,
	maxDistance = 6.0,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	garage = false,
	objCoords = vector3(1799.608, 2616.975, 44.60325),
	locked = true,
	lockpick = false,
	maxDistance = 6.0,
	objHash = 741314661,
	factions = { ['LSPD']=0 },
	objHeading = 179.99998474121,
	audioRemote = false,
	fixText = false,
	slides = true,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	factions = { ['LSPD']=0 },
	objHeading = 90.0,
	garage = false,
	audioRemote = false,
	lockpick = false,
	slides = true,
	fixText = false,
	objHash = 741314661,
	objCoords = vector3(1818.543, 2604.812, 44.611),
	locked = true,
	maxDistance = 6.0,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})

-- prison
table.insert(Config.DoorList, {
	factions = { ['LSPD']=0 },
	objHeading = 90.0,
	garage = false,
	audioRemote = false,
	lockpick = false,
	slides = true,
	fixText = false,
	objHash = 741314661,
	objCoords = vector3(1844.998, 2604.812, 44.63978),
	locked = true,
	maxDistance = 6.0,		
	-- oldMethod = true,
	-- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
	-- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
	-- autoLock = 1000
})