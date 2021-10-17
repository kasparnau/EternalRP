fx_version "cerulean"

games {"gta5"}

description "NPCs Handler"

version "0.1.0"

client_script "@jp-flags/client/cl_flags.lua"

client_scripts {
  "client/classes/*.lua",
  "client/*.lua"
}

shared_scripts {
  "shared/sh_*.lua"
}

server_scripts {
  "server/sv_*.lua"
}