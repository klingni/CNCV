local currentFolder = "resources//[cnc]//cnc-map//"
local Maps = {}
local TestMaps = {}
local currendMapId = 0
local currentMap = {}
local tmpMaps = {}
local adminpwd = "cnc4ever"


function createMap()
    Players = GetPlayers()

    -- TriggerClientEvent('CNCE:Map:createMap_forAll', -1, currentMap)
    -- Citizen.Wait(1000)
    -- TriggerClientEvent('CNCE:Map:createMap_forSingle', Players[1], currentMap)

    TriggerClientEvent('CNCE:Map:createMap', Players[1], currentMap, true)
    TriggerClientEvent('CNCE:Map:createMap', -1, currentMap, false)
end


RegisterNetEvent('CNCE:Map:loadMap')
AddEventHandler('CNCE:Map:loadMap', function (mapId)
    if currendMapId == 0 or mapId then
        Maps = getMapSettings()
        print('LoadMap ' .. mapId)
        currendMapId = mapId
        currentMap = Maps[mapId]
    end

    createMap()
end)


function getMapSettings()
    --print('getSettingsS')
    file = io.open(currentFolder .. "Maps.json", "r")
    local content = file:read("*a")
    file:close()
    local testObj, pos, testErro = json.decode(content)
    --print(testObj[1]['cop']['spawnpoints'][1]['x'])

    return testObj
end


RegisterNetEvent('CNCE:Map:startInit')
AddEventHandler('CNCE:Map:startInit', function ()
    tmpMaps = getMapSettings()
    TriggerClientEvent('CNCE:Map:init', -1, tmpMaps, currendMapId)
end)


RegisterNetEvent('CNCE:Map:addCop')
AddEventHandler('CNCE:Map:addCop', function (coord)
    --print(#currentMap['cop']['spawnpoints'])
    table.insert( currentMap['cop']['spawnpoints'], coord )
    createMap()
end)

RegisterNetEvent('CNCE:Map:addCrook')
AddEventHandler('CNCE:Map:addCrook', function (coord)
    --print(#currentMap['crook']['spawnpoints'])
    table.insert( currentMap['crook']['spawnpoints'], coord )
    createMap()
end)

RegisterNetEvent('CNCE:Map:removeSpawn')
AddEventHandler('CNCE:Map:removeSpawn', function ( type, i)
    print('Remove Spawn: ' .. type .. " - Pos: " .. i)
    if type == 'cop' then
        table.remove( currentMap['cop']['spawnpoints'], i )
    elseif type == 'crook' then
        table.remove( currentMap['crook']['spawnpoints'], i )
    elseif type == 'getaway' then
        table.remove( currentMap['getaway'], i )
    elseif type == 'vehicle' then
        table.remove( currentMap['vehicle'], i )
    end
    createMap()
end)

RegisterNetEvent('CNCE:Map:addGetaway')
AddEventHandler('CNCE:Map:addGetaway', function ( GetawayInfo)

    --print(#currentMap['getaway'])
    table.insert( currentMap['getaway'] , GetawayInfo )

    createMap()
end)

RegisterNetEvent('CNCE:Map:addVehicle')
AddEventHandler('CNCE:Map:addVehicle', function ( VehicleInfo )
    --print(#currentMap['vehicle'])
    table.insert( currentMap['vehicle'] , VehicleInfo )

    createMap()
end)

RegisterNetEvent('CNCE:Map:renameMap')
AddEventHandler('CNCE:Map:renameMap', function ( newName )

    currentMap['infos']['title'] = newName
    --TriggerClientEvent('CNCE:Map:createMap', -1, currentMap)

end)

RegisterNetEvent('CNCE:Map:saveMap')
AddEventHandler('CNCE:Map:saveMap', function ( password )

    if currendMapId ~= 0 then
        Maps[currendMapId] = currentMap
    end

    if password == currentMap['infos']['password'] or password == adminpwd then

        local text = json.encode(Maps)

        print('start saving')
        
        file = io.open(currentFolder .. "Maps.json", "w")
        file:write(text)
        file:close()

        date = os.date("*t")
        backupfile = io.open(currentFolder .. "Maps_" .. date.year .. date.month .. date.day .."_" .. date.hour .. date.min .. date.sec .. ".json", "w")
        backupfile:write(text)
        backupfile:close()
        print('saving was successful')
        TriggerClientEvent('CNC:showNotification', source, '~g~saving was successful')

    else
        print('wrong Password')
        TriggerClientEvent('CNC:showNotification', source, '~r~wrong password, save was canceled')
    end
end)


RegisterNetEvent('CNCE:Map:saveNewMap')
AddEventHandler('CNCE:Map:saveNewMap', function (  )

    if currendMapId ~= 0 then
        Maps[currendMapId] = currentMap
    end
        local text = json.encode(Maps)

        print('start saving')
        
        file = io.open(currentFolder .. "Maps.json", "w")
        file:write(text)
        file:close()

        date = os.date("*t")
        backupfile = io.open(currentFolder .. "Maps_" .. date.year .. date.month .. date.day .."_" .. date.hour .. date.min .. date.sec .. ".json", "w")
        backupfile:write(text)
        backupfile:close()
        print('saving was successful')
        TriggerClientEvent('CNC:showNotification', source, '~g~saving was successful')
end)


RegisterNetEvent('CNCE:Map:addNewMap')
AddEventHandler('CNCE:Map:addNewMap', function ( title, autor, password )

    print("add Map")
    print(#Maps)

    if #Maps == 0 then
        --TriggerEvent('CNCE:Map:loadMap', 1)
        Maps = getMapSettings()
        Citizen.Wait(2000)
    end

    print(#Maps)

    print('addNew Map')

    local title = title or "unnamed"
    local autor = autor or "unknown"
    local password = password or ""

    local newMap = {
        infos = {
            title = title,
            autor = autor,
            password = password
        },
        cop = {
            spawnpoints = {}
        },
        crook = {
            spawnpoints = {}
        },
        getaway = {},
        vehicle = {}
    }

    --print(Maps[1]['getaway'][1]['model'])

    table.insert( Maps,  newMap)
    print('################')
    print('################')

    --print(Maps[1]['getaway'][1]['model'])
    
    TriggerEvent('CNCE:Map:saveNewMap')
    Citizen.Wait(1000)
    TriggerEvent('CNCE:Map:loadMap', #Maps)

end)


RegisterNetEvent('CNCE:Map:addInfos')
AddEventHandler('CNCE:Map:addInfos', function ( title, autor )
    title = title or 'unnamed'
    autor = autor or 'unknown'
    --print('test')
    TriggerClientEvent('CNC:showNotification', -1, 'Mapname: ' .. title)
    TriggerClientEvent('CNC:showNotification', -1, 'Autor: ' .. autor)

    currentMap['infos']['autor'] = autor
    currentMap['infos']['title'] = title
end)



Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(1000)
        if currendMapId ~= 0 then
            --print(currentMap)
            TriggerClientEvent('updateMapName', -1, currentMap['infos']['title'])
        else
            TriggerClientEvent('updateMapName', -1, 'NO MAP LOADED')
        end
    end
end)