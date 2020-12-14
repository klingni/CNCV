
local currentFolder = "resources//[cnc]//cnc-map//"


RegisterCommand("cnc", function(source, args, rawCommand)

    if args[1] == "spawncar" then
        TriggerClientEvent('eventSpawnCar', source, args[2])   

    elseif args[1] == "loadPickups" then
        TriggerEvent('CNCE:Pickup:callLoadPickups')

    elseif args[1] == "savePickups" then
        TriggerEvent('CNCE:callSavePickups')

    elseif args[1] == "loadMap" then
        TriggerEvent('CNCE:callLoadMap')

    elseif args[1] == "addInfos" then
        TriggerEvent('CNCE:Map:addInfos', args[2] , args[3])

    elseif args[1] == "test" then
        TriggerEvent('test')

    elseif args[1] == "dontneed" then
        TriggerClientEvent('dontneed', source, args[2])

    elseif args[1] == "ray" then
        TriggerClientEvent('ray', source)

    elseif args[1] == "mapName" then
        TriggerClientEvent('mapName', source, args[2])

    elseif args[1] == "del" then
        TriggerClientEvent('del', source, args[2])

    elseif args[1] == "get" then
        TriggerClientEvent('get', source)

    elseif args[1] == "delall" then
        TriggerClientEvent('delall', source)

    elseif args[1] == "ident" then
        TriggerEvent('ident', source)
    end

end, false)


