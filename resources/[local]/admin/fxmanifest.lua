fx_version 'cerulean'
games { 'gta5' }

server_script '@mysql-async/lib/MySQL.lua'
server_script 'date.lua'

server_scripts {
    'server.lua'
}

client_script 'date.lua'

client_scripts {
    'client.lua',
}