fx_version 'cerulean'
game 'gta5'

server_script '@rpc/server/sv_main.lua'
client_script '@rpc/client/cl_main.lua'

shared_scripts {
    'shared/sh_*.lua'
}

server_scripts {
    'server/sv_main.lua',
}

client_scripts {
    'client/cl_main.lua',
    'client/cl_anim.lua',
    
    'client/cl_ping.lua'
}

ui_page 'build/index.html'

files {
    'build/static/js/*.js',
    'build/static/css/*.css',
    'build/static/media/*.woff',
    'build/static/media/*.svg',
    'build/static/media/*.png',
    'build/static/media/*.webp',
    'build/static/media/*.ogg',
    'build/index.html'
}