resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'
fx_version 'adamant'
game 'gta5'

resource_type 'gametype' { name = 'Cops and Crooks EDITOR Alpha' }


client_script {
    '@NativeUI/NativeUI.lua',
    'client/map/globMap.lua',
    'client/map/vehicles.lua',
    'client/gui/notifications.lua',
    'client/gui/input.lua',
    'client/map/map.lua',
    --'client/menue/main.lua',
    --'client/menue/map.lua',
    --'client/menue/globMap.lua',
    --'client/menue/time.lua',
    'client/gui/menu/main.lua',
    'client/client.lua'
    
}

server_script {
    'server/server.lua',
    'server/helper/helper.lua',
    'server/map/map.lua',
    'server/map/globMap.lua'   
}

dependencies {
    --'ft_libs'
    'NativeUI',
    'editorhud',
    'vMenu'
  }
