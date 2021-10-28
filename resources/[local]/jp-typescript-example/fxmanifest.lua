fx_version 'cerulean'
games {'gta5'}

server_script '@rpc/server/sv_main.js'
client_script '@rpc/client/cl_main.js'

client_scripts {
    'shared/*.js',
    'client/*.js',
}

server_scripts {
    'shared/*.js',
    'server/*.js'
}