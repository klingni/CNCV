RegisterCommand("cnc", function(source, args, rawCommand)
    if args[1] == "spawncar" then
        TriggerClientEvent('eventSpawnCar', source, args[2])

    
    elseif args[1] == "spawnPickups" then
        print('command: spawn Pickups')
        TriggerEvent('CNC:startSpawnPickups')
        --TriggerClientEvent('loadPickups', source, getPickupSettings() )

    elseif args[1] == "clearPickups" then
        print('clear Pickups')
        TriggerEvent('CNC:clearPickups')

        
    elseif args[1] == "spawnPlayer" then

        print('spawn Player command')
       
        spawnPlayer(args[2], getMap(1), tonumber(args[3]), tobool(args[4]))

        --local player = args[2] or -1
        --TriggerClientEvent('eventSetTeam', player, getPlayerSettings(args[3]))

        
    elseif args[1] == "startRound" then
        startCNCRound( source ) 
       

    elseif args[1] == "showPlayers" then
        local players = GetPlayers()
        for i,player in ipairs(players) do
            print('[' .. player .. ']' .. GetPlayerName(player))
        end

    elseif args[1] == "spawnGeta" then
        local map = getMap(1)
        TriggerClientEvent('CNC:eventCreateGetaway', -1, map['getaway'])


    elseif args[1] == "spawner" then
        VehicleSpawner()

    elseif args[1] == "createPlayerBlips" then
        TriggerClientEvent('CNC:createPlayerBlip', -1)


    elseif args[1] == "getPos" then
        TriggerClientEvent('CNC:getPos', -1)

    elseif args[1] == "getId" then
        TriggerClientEvent('CNC:id', -1)

    elseif args[1] == "gablip" then
        TriggerClientEvent('CNC:findGetawayCoord', 1, args[2])
        TriggerEvent('CNC:forceUpdateGetawayBlip')

    elseif args[1] == "clear" then
        TriggerClientEvent('CNC:cleanAll', source)

    elseif args[1] == "createMarker" then
        TriggerClientEvent('CNC:createMarker', -1)

    elseif args[1] == "getTeam" then
        TriggerClientEvent('CNC:getSelectedTeam', -1)

    elseif args[1] == "showPlayerInfos" then
        TriggerEvent('CNC:showPlayerInfos')
    
    elseif args[1] == "getPlayer" then
        TriggerClientEvent('CNC:getPlayer', -1, args[2])

    elseif args[1] == "getPlayerInfos" then
        TriggerClientEvent('CNC:getPlayerInfos', -1)
                
    elseif args[1] == "addPoints" then
        TriggerEvent('CNC:addPoints', args[2], args[3])

    elseif args[1] == "initPoints" then
        TriggerEvent('CNC:initPoints')

    elseif args[1] == "teleport" then
        TriggerClientEvent('CNC:teleport', source)

    elseif args[1] == "clearVehicles" then
        TriggerEvent('CNC:clearVehicles')

    elseif args[1] == "createSpawner" then
        TriggerClientEvent('CNC:createSpawner', -1)

    elseif args[1] == "startEditor" then
        TriggerEvent('CNC:startEditor')

    elseif args[1] == "getNWID" then
        TriggerClientEvent('getNWID', source)
        
    elseif args[1] == "debugBlip" then
        TriggerClientEvent('CNC:debugBlip', -1)

    elseif args[1] == "rcon" then
        RconPrint('HUHU')

    elseif args[1] == "setWeapon" then
        TriggerClientEvent('CNC:setWeapon', -1, args[2])

    elseif args[1] == "showScaleform" then
        TriggerClientEvent('CNC:showScaleform', -1, args[2], args[3], args[4])

    elseif args[1] == "join" then
        TriggerEvent('CNC:joinRunningRound', source, args[2])
        
    elseif args[1] == "createBlip" then
        TriggerClientEvent('CNC:createBlip', source, args[2])
        
    elseif args[1] == "showLocalPlayers" then
        TriggerClientEvent('CNC:showLocalPlayers', source)
        
    elseif args[1] == "getPed" then
        TriggerEvent('CNC:getPed', args[2])
        
    elseif args[1] == "noti" then
        local option = {
            layout = 'bottomCenter',
            type = 'warning',
            text = 'You are the Boss',
            theme = 'cnc'
        }
        TriggerClientEvent('pNotify:SendNotification', -1 ,option)
        
    elseif args[1] == "updateChat" then
        TriggerEvent('chat:updatePlayerInfos', 'HI')
        
    elseif args[1] == "flipGeta" then
        TriggerClientEvent('CNC:flipGeta', source)

    elseif args[1] == "suicide" then
        TriggerClientEvent('CNC:killPlayer', source, args[2])
        
    elseif args[1] == "wakeup" then
        TriggerClientEvent('CNC:wakeup', source, args[2])

    end
end, false)