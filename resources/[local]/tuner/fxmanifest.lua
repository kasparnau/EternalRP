fx_version 'adamant'
game 'gta5'

server_script '@rpc/server/sv_main.lua'
client_script '@rpc/client/cl_main.lua'

client_scripts {
    "dependencies/RMenu.lua",
    "dependencies/menu/RageUI.lua",
    "dependencies/menu/Menu.lua",
    "dependencies/menu/MenuController.lua",
  
    "dependencies/components/*.lua",
  
    "dependencies/menu/elements/*.lua",
    "dependencies/menu/items/*.lua",

    "client.lua"
}

server_scripts {
    "server.lua",
}