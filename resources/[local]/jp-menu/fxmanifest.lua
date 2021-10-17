fx_version "cerulean"

games {"gta5"}

description "Menu Handler"

version "0.1.0"

client_scripts {
  "client/*.lua"
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