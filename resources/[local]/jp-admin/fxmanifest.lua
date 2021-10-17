fx_version 'cerulean'
game 'gta5'

server_script '@rpc/server/sv_main.lua'
client_script '@rpc/client/cl_main.lua'
client_script "@jp-sync/client/lib.lua"

shared_scripts {
    'shared/sh_*.lua'
}

server_scripts {
    'server/sv_*.lua',
}

client_scripts {
    'client/cl_*.lua'
}

ui_page 'build/index.html'

files {
    'build/static/js/*.js',
    'build/static/css/*.css',
    'build/static/media/*.woff',
    'build/static/media/*.svg',
    'build/static/media/*.png',
    'build/index.html'
}