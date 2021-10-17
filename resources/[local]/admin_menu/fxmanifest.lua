fx_version 'cerulean'
games { 'gta5' }

server_script '@rpc/server/sv_main.lua'
client_script '@rpc/client/cl_main.lua'

server_script 'date.lua'
server_scripts {
    'server.lua'
}

client_script '@warmenu/warmenu.lua'

ui_page "html/index.html"

files({
    "html/index.html",
    "html/script.js",
    "html/styles.css"
})

client_scripts {
    'client.lua',
}