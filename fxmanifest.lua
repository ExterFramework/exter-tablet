fx_version 'cerulean'

game 'gta5'

lua54 'yes'

author 'Sobing4413'

description 'ExterFramework'

name 'exter-tablet'

version '1.0.0'

files {
    'web/**',
    'web/assets/**',
}

ui_page 'web/index.html'

client_scripts {
	'client/core.lua',
	'client/**.lua',
}

shared_scripts {
	
	'shared/**.lua',
}

server_scripts {
	'server/core.lua',
	'server/**.lua',
}

escrow_ignore {
	'shared/**',
	'client/**.lua',
	'server/**.lua',
}
