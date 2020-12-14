
-- =========================================================================
-- ================================ SPAWNER ================================
-- =========================================================================



RegisterNetEvent('CNC:createSpawner')
AddEventHandler('CNC:createSpawner', function(spawner)
    TriggerEvent('Log', 'CNC:createSpawner', spawner)
    -- print('Spawner:' .. #spawner)
    net_Spawner = spawner
end)



