
-- =========================================================================
-- ================================ SPAWNER ================================
-- =========================================================================



RegisterNetEvent('CNC:createSpawner')
AddEventHandler('CNC:createSpawner', function(spawner)
    TriggerEvent('Log', 'CNC:createSpawner', spawner)
    -- print('Spawner:' .. #spawner)
    Net_Spawner = spawner
end)



