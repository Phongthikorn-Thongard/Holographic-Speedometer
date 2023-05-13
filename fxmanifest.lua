fx_version 'cerulean'
game 'gta5'

author 'SkyeZ'
description 'Hologram Speed Meter'
version '1.0.0'

client_script {
    'config.lua',
    'common/function.lua',
    'client/function/hologram.lua',
    'client/function/dui.lua',
    'client/function/model.lua',
    'client/event.lua',
    'client/client.lua'
}

server_script {
    'common/function.lua',
    'server/*.lua'
}   

ui_page 'ui/speedometer_1.html'

files {
    'ui/font/*',
    'ui/font/icon-font/*',
    'ui/css/*.css',
    
    'ui/js/ui.js',
    'ui/js/hologram.js',

    'ui/html/speedometer.html',
    'ui/html/car-performance.html',
    'ui/speedometer_1.html',
    'ui/speedometer_2.html',

    'data/hologram_box_1/*.meta',
    'data/hologram_box_2/*.meta'
}

shared_script '@es_extended/imports.lua'

data_file 'HANDLING_FILE' 'data/hologram_box_1/handling.meta'
data_file 'HANDLING_FILE' 'data/hologram_box_2/handling.meta'

data_file 'VEHICLE_METADATA_FILE' 'data/hologram_box_1/vehicles.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/hologram_box_2/vehicles.meta'

data_file 'VEHICLE_VARIATION_FILE' 'data/hologram_box_1/carvariations.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/hologram_box_2/carvariations.meta'

