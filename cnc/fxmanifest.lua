resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

resource_type "gametype" {name = "Cops and Crooks Alpha"}
description "Cops and Crooks V"

game 'common'
fx_version 'adamant'

client_script {
    "@NativeUI/NativeUI.lua",
    "client/client.lua",
    "client/helper.lua",
    "client/player/player.lua",
    "client/player/player-blip.lua",
    "client/player/player-blip_neu.lua",
    "client/vehicles/vehicles.lua",
    "client/vehicles/spawner.lua",
    "client/vehicles/getaway.lua",
    "client/pickups/pickups.lua",
    "client/gui/notifications.lua",
    "client/gui/menu.lua",
    "client/gui/scoreboard/scoreboard.lua",
    "client/gui/help/help.lua",
    "Settings/config.lua",

}

server_script {
    "server/server.lua",
    "server/helper/helper.lua",
    "server/pickups/nethandler.lua",
    "server/gameplay/player.lua",
    "server/helper/commands.lua",
    "server/gameplay/score.lua",
    "server/vehicles/getaway.lua",
    "server/vehicles/spawner.lua",
    "server/vehicles/vehicle.lua"
}

dependencies {
    --"NativeUI"
}

loadscreen "client/gui/loadscreen/index.html"
ui_page 'client/gui/scoreboard/html/scoreboard.html'


files {
    -- LOADSCREEN
    "client/gui/loadscreen/index.html",
    "client/gui/loadscreen/keks.css",
    "client/gui/loadscreen/bankgothic.ttf",
    "client/gui/loadscreen/loadscreen.jpg",
    "client/gui/loadscreen/cnc5.png",

    -- SCOREBOARD
    'client/gui/scoreboard/html/scoreboard.html',
    'client/gui/scoreboard/html/style.css',
    'client/gui/scoreboard/html/reset.css',
    'client/gui/scoreboard/html/listener.js',
    'client/gui/scoreboard/res/futurastd-medium.css',
    'client/gui/scoreboard/res/futurastd-medium.eot',
    'client/gui/scoreboard/res/futurastd-medium.woff',
    'client/gui/scoreboard/res/futurastd-medium.ttf',
    'client/gui/scoreboard/res/futurastd-medium.svg',
    'client/gui/scoreboard/res/cnc-logo.png',


    
}
