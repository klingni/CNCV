resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'
fx_version 'adamant'
game 'gta5'

description 'CNC Editor User Interface'

-- temporary!
ui_page 'html/hud.html'

client_script 'hud.lua'

files {
    'html/hud.html',
    'html/style.css',
    'html/listener.js',
}

export 'updateHudMapName'
