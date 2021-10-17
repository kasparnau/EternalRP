fx_version 'cerulean'
games { 'gta5' }

shared_script {
  'shared/sh_*.lua'
}

server_scripts {
    'server/sv_*.lua',
}

ui_page 'build/index.html'

files {
    'build/static/js/*.js',
    'build/static/css/*.css',
    'build/static/media/*.woff',
    'build/static/media/*.svg',
    'build/static/media/*.png',
    'build/index.html'
}

client_scripts {
    'client/cl_*.lua',
}