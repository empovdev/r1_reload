fx_version 'adamant'

game 'gta5'
author "Re1ease"
version '1.0.0'

server_script {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua'
}