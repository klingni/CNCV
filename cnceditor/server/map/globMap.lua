local currentFolder = GetResourcePath(GetCurrentResourceName()) .. "/../cnc-map/"
local globalMap = {}
local currentMap = {}


RegisterNetEvent('CNCE:globMap:callLoadMap')
AddEventHandler('CNCE:globMap:callLoadMap', function ()
    if globalMap['vehicles'] == nil then
        globalMap = GetGlobalMapSettings()
    end
    --print(#globalMap['pickups']['positions'])
    TriggerClientEvent('CNCE:globMap:createMap', -1, globalMap)
end)


function GetGlobalMapSettings()
    File = io.open(currentFolder .. "GlobalMap.json", "r")
    local content = File:read("*a")
    File:close()
    local testObj, pos, testErro = json.decode(content)
    --print(testObj['pickups'])

    return testObj
end


RegisterNetEvent('CNCE:globMap:Pickup:forceAddPickup')
AddEventHandler('CNCE:globMap:Pickup:forceAddPickup', function (coord)
    table.insert( globalMap['pickups']['positions'], coord )
    --TriggerClientEvent('CNCE:globMap:Pickup:forceLoadPickups', -1)
    TriggerClientEvent('CNCE:globMap:forceCallLoadMap', -1)
end)


RegisterNetEvent('CNCE:globMap:Pickup:forceRemovePickup')
AddEventHandler('CNCE:globMap:Pickup:forceRemovePickup', function (i)
    table.remove( globalMap['pickups']['positions'], i )
    --TriggerClientEvent('CNCE:globMap:Pickup:forceLoadPickups', -1)
    TriggerClientEvent('CNCE:globMap:forceCallLoadMap', -1)
end)


RegisterNetEvent('CNCE:globMap:save')
AddEventHandler('CNCE:globMap:save', function ()
    SavePickups(globalMap)
    TriggerClientEvent('CNC:showNotification', -1, 'saving was successful')
end)


function SavePickups(globalMap)
        --print('getSettingsS')

        local text = json.encode(globalMap)

        print('start saving')
        
        File = io.open(currentFolder .. "GlobalMap.json", "w")
        File:write(text)
        File:close()

        Date = os.date("*t")
        BackupFile = io.open(currentFolder .. "GlobalMap_" .. Date.year .. Date.month .. Date.day .."_" .. Date.hour .. Date.min .. Date.sec .. ".json", "w")
        BackupFile:write(text)
        BackupFile:close()
        print('saving was successful')
end


RegisterNetEvent('CNCE:globMap:addVehicle')
AddEventHandler('CNCE:globMap:addVehicle', function ( VehicleInfo )

    print('Server add Vehicle')
    table.insert( globalMap['vehicles'] , VehicleInfo )

    TriggerClientEvent('CNCE:globMap:createMap', -1, globalMap)
end)