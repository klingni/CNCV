RegisterNetEvent('CNC-HELP:closeAllHelpWindows')
AddEventHandler('CNC-HELP:closeAllHelpWindows', function()
    TriggerClientEvent('CNC-HELP:close', -1)
end)

RegisterNetEvent('CNC-HELP:getPlayerCount')
AddEventHandler('CNC-HELP:getPlayerCount', function()
    playerlist = GetPlayers()
    playerCount = #playerlist
    TriggerClientEvent('CNC-HELP:UpdatePlayer', -1, playerCount)
end)