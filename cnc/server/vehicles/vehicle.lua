
-- =========================================================================
-- ================================ VEHICLE ================================
-- =========================================================================



RegisterNetEvent('CNC:createVehicle')
AddEventHandler('CNC:createVehicle', function(vehicles)
    TriggerEvent('Log', 'CNC:createVehicle', vehicles)
    -- print('Spawner:' .. #vehicles)
    net_Vehicles = vehicles
end)


RegisterNetEvent('CNC:clearVehicles')
AddEventHandler('CNC:clearVehicles', function()

    TriggerEvent('Log', 'CNC:clearVehicles')

    print('CLEAR ALL VEHICLES NEU')
    -- print('SPAWNER:' .. #net_Spawner)
    -- print('VEHICLES:' .. #net_Vehicles)

    TriggerClientEvent('CNC:clearSpawner', -1, net_Spawner)
    TriggerClientEvent('CNC:clearVehicle', -1, net_Vehicles)
    TriggerClientEvent('CNC:clearGA', -1, net_Getaway)

    --net_Spawner = {}
    --net_Vehicles = {}
    --net_Getaway = {}
end)