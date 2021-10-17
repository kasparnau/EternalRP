fx_version 'cerulean'
games { 'gta5' }

server_script '@rpc/server/sv_main.lua'
client_script '@rpc/client/cl_main.lua'

server_scripts {
    'server.lua'
}

client_scripts {
    'client.lua',
}
