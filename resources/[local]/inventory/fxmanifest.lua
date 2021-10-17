fx_version 'cerulean'
game 'gta5'

server_script '@rpc/server/sv_main.lua'
client_script '@rpc/client/cl_main.lua'

shared_scripts {
    'shared/sh_*.lua'
}

server_scripts {
    'server/sv_*.lua',
}

client_scripts {
    'client/cl_props.lua',
    'client/cl_weapons.lua',
    'client/cl_vehicleModifiers.lua',
    'client/cl_main.lua',
    'client/cl_items.lua' --// LOAD THIS LATER
}

ui_page 'html/ui.html'
files {
    'html/ui.html',
    'html/css/style.min.css',
    'html/js/inventory.js',
    'html/js/config.js',
    'html/css/jquery-ui.min.css',
    'html/css/bootstrap.min.css',
    'html/js/jquery.min.js',
    'html/js/jquery-ui.min.js',
    'html/js/bootstrap.min.js',
    'html/js/popper.min.js',

    -- IMAGES
    'html/img/*.png',
    'html/success.wav',
    'html/fail.wav',
    -- ICONS

    'html/img/items/*.png',
}