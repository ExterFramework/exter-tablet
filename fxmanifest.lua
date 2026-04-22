fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Sobing4413'
description 'Exter Tablet - multi framework compatibility layer'
name 'exter-tablet'
version '2.0.0'

files {
    'web/**'
}

ui_page 'web/index.html'

shared_scripts {
    'shared/config.lua',
    'shared/adapters.lua'
}

client_scripts {
    'client/core.lua',
    'client/main.lua',
    'client/notifications.lua'
}

server_scripts {
    'server/core.lua',
    'server/server.lua',
    'server/open_server.lua'
}

escrow_ignore {
    'shared/**',
    'client/**.lua',
    'server/**.lua'
}
