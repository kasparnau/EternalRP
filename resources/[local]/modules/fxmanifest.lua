fx_version 'cerulean'
games { 'gta5' }

server_script 'sh_init.lua'
client_script 'sh_init.lua'

server_script 'core/sh_core.lua'
client_script 'core/sh_core.lua'
server_script 'core/sh_enums.lua'
client_script 'core/sh_enums.lua'

server_script "util/sh_util.lua"
client_script "util/sh_util.lua"

client_script 'streaming/streaming.lua'

client_script 'game/entityiter.lua'
client_script 'game/cl_game.lua'