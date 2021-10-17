fx_version 'cerulean'
games { 'gta5' }

shared_script {
  'shared/sh_*.*'
}

server_script '@rpc/server/sv_main.lua'
client_script '@rpc/client/cl_main.lua'

server_scripts {
    'server/sv_*.lua',
}

client_scripts {
    'client/cl_*.lua',
}