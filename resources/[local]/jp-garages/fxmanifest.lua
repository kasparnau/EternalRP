fx_version 'cerulean'
games { 'gta5' }

server_script '@rpc/server/sv_main.lua'
client_script '@rpc/client/cl_main.lua'

shared_scripts {
  'shared.sh_*.lua'
}

server_scripts {
    'server/sv_main.lua',
    'server/sv_trackers.lua',
    'server/sv_ownership.lua'
}

client_scripts {
    'client/cl_main.lua',
    'client/cl_trackers.lua',
    'client/cl_events.lua'
}