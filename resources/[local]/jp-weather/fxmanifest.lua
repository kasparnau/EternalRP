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
    'client/cl_*.lua'
}