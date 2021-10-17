-- MRPD
exports['jp-interact']:AddPeekEntryByPolyTarget("officer_sign_in", vector3(441.83, -982.05, 30.69), 0.5, 0.35, {
	heading=12,
	minZ=30.79,
	maxZ=30.84,
}, {
	options = {
		{
			event = "jp-signin:peekAction",
			icon = "far fa-clipboard",
			label = "Logi sisse",
		},
		{
			event = "jp-signoff:peekAction",
			icon = "far fa-clipboard",
			label = "Logi välja",
		},
	},
	distance = 1.5,
	isEnabled = function()
		local character = exports['players']:GetClientVar("character")
		local faction = character.faction
		return faction and (faction.group.faction_name == 'LSPD' and faction.member.rank_level >= 1)
	end
})

exports['jp-interact']:AddPeekEntryByPolyTarget("armory", vector3(481.4, -994.81, 30.69), 0.6, 3.0, {
	heading=0,
	minZ=29.49,
  	maxZ=32.29,
}, {
	options = {
		{
			event = "jp-shops:openShop",
			icon = "fas fa-shopping-cart",
			label = "Ava Relvaladu",
		},
	},
	params = { 1 },
	distance = 1.5,
	isEnabled = function()
		local character = exports['players']:GetClientVar("character")
		local faction = character.faction
		return faction and (faction.group.faction_name == 'LSPD' and faction.member.rank_level >= 1)
	end
})

exports['jp-interact']:AddPeekEntryByPolyTarget("prison_food", vector3(1779.56, 2590.48, 45.8), 1.4, 0.8, {
	heading=90,
	minZ=45.8,
  	maxZ=46.15,
}, {
	options = {
		{
			event = "police:makePrisonFood",
			icon = "fas fa-burger-soda",
			label = "Võta Vangla Toitu",
		},
	},
	distance = 1.5,
	isEnabled = function()
		local character = exports['players']:GetClientVar("character")
		return character and character.jail_time > 0
	end
})