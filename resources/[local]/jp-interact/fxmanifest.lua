fx_version 'cerulean'

game 'gta5'

dependencies {
    "PolyZone"
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/css/style.css',
	'html/js/script.js'
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
}

client_scripts {
	"@jp-flags/client/cl_flags.lua",
    "client/*.lua",
	"client/entries/cl_*.lua",
}