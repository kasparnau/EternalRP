fx_version 'cerulean'
games { 'gta5' }

shared_scripts {
    "shared/*.lua"
}

server_script '@rpc/server/sv_main.lua'
client_script '@rpc/client/cl_main.lua'

client_script "@jp-sync/client/lib.lua"

client_scripts {
    "client/*.lua",
}

server_scripts {
    "server/*.lua",
}