resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "Cops and Crooks V - HELP"
game 'common'

fx_version 'adamant'

client_script {
    "client.lua"
}

server_script{
    "server.lua"
}

server_script {}

ui_page 'help.html'


files {
    -- SCOREBOARD
    'help.html',
    'style.css',
    'reset.css',
    'listener.js',
    'res/futurastd-medium.css',
    'res/futurastd-medium.eot',
    'res/futurastd-medium.woff',
    'res/futurastd-medium.ttf',
    'res/futurastd-medium.svg',
    'CNC.png',
    'res/cnc-logo.png'
 
}
