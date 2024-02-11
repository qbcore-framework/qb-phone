fx_version 'bodacious'
game 'gta5'
lua54 'yes'
author 'Kakarot'
description 'Allows players to access a phone to interact with various apps and features'
version '1.3.0'

ui_page 'html/index.html'

shared_scripts {
    'config.lua',
    '@qb-apartments/config.lua'
}

client_scripts {
    'client/main.lua',
    'client/animation.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

files {
    'html/*.html',
    'html/js/*.js',
    'html/img/*.png',
    'html/css/*.css',
    'html/img/backgrounds/*.png',
    'html/img/apps/*.png',
}
