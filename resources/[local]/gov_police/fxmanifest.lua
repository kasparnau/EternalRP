fx_version "cerulean"

games {"gta5"}

description "Police"

version "0.1.0"

server_script '@rpc/server/sv_main.lua'
client_script '@rpc/client/cl_main.lua'

shared_scripts {
  "shared/*.lua"
}

server_scripts {
  "server/sv_*.lua"
}

client_scripts {
  "client/cl_*.lua"
}

