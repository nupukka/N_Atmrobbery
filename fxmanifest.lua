fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Nupukka'
description 'Gravedigging'

client_scripts {
    'client/cl_main.lua',
    'client/cl_edit.lua'
}

server_scripts {
    'server/sv_main.lua'
}

shared_script '@ox_lib/init.lua'

files {
    'config.lua',
	'locales/*.json'
}