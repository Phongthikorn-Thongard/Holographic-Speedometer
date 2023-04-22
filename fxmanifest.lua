fx_version 'cerulean'
game 'gta5'

author 'SkyeZ'
description 'Hologram Speed Meter'
version '1.0.0'

client_script {
    'config.lua',
    'client.lua'
}

server_script {
    'server.lua'
}

data_file 'HANDLING_FILE' 'data/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/carvariations.meta'

ui_page 'nui/index.html'

files {
    'html/index.html',
    'html/style.css',
    'data/handling.meta',
	'data/vehicles.meta',
	'data/carvariations.meta',
    'html/ui.js',
    'html/font/*',
    'html/img/*'
}

shared_script '@es_extended/imports.lua'
