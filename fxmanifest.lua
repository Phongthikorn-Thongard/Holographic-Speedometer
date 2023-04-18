fx_version 'cerulean'
game 'gta5'

author 'SkyeZ'
description 'hologram'
version '1.0.0'

client_script {
    'client.lua'
}

server_script {
    'server.lua'
}

data_file 'DLC_ITYP_REQUEST' 'stream/screen.ydr'
data_file 'DLC_ITYP_REQUEST' 'stream/screen.ytyp'

ui_page 'nui/index.html'

files {
    'html/index.html',
    'html/style.css',
    'stream/screen.ydr',
    'stream/screen.ytyp',
    'html/ui.js'
}

shared_script '@es_extended/imports.lua'
