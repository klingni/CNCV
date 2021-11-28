local pickupInfos = {}
local removedPickups = {}

RegisterNetEvent('CNC:startSpawnPickups')
AddEventHandler('CNC:startSpawnPickups', function ( )
    local globalMapSettings = GetGlobalMapSettings() --test
    
    Citizen.Trace('startSpawnPickups')
    TriggerEvent('CNC:clearPickups')
    ListPickupPos = globalMapSettings['pickups']['positions']
    ListSpawnablePickups = globalMapSettings['pickups']['types']
    for i,PickupCoord in ipairs(ListPickupPos) do
        local chosenPickupID = math.random(1, #ListSpawnablePickups)

        local ChosenPickup = ListSpawnablePickups[chosenPickupID]
        ForceCreateWeaponPickupAtLocation( PickupCoord.x, PickupCoord.y, PickupCoord.z, ChosenPickup.pickup, ChosenPickup.ammo, ChosenPickup.blipSprite, ChosenPickup.color)
    end

    TriggerClientEvent("CNC:createMuliiplePickups", -1, pickupInfos)
end)

RegisterNetEvent('CNC:startSpawnPickupsJoiningPlayer')
AddEventHandler('CNC:startSpawnPickupsJoiningPlayer', function ( playerID )
    TriggerClientEvent("CNC:createMuliiplePickups", playerID, pickupInfos)
end)


Citizen.CreateThread(function ( )
    function ForceCreateWeaponPickupAtLocation( spawnPosX, spawnPosY, SpawnPosZ, PickupName, AmmoCount, BlipSpriteID, BlipColor )
        --Citizen.Trace('forceCreatePickup')
        PickupName = string.upper(PickupName)
        
        local pickupInfo = {
            pickupName = PickupName,
            x = spawnPosX,
            y = spawnPosY,
            z = SpawnPosZ,
            ammo = AmmoCount,
            spawnedBlip = false,
            blipSpriteID = BlipSpriteID,
            blipColor = BlipColor,
            spawnedLocal = false
        }
        
        table.insert( pickupInfos, pickupInfo )
    end
end)


RegisterNetEvent('CNC:registerNewPickup')
AddEventHandler('CNC:registerNewPickup', function ( pickupInfo )
    Citizen.Trace('registerNewPickup')
    table.insert( pickupInfos, pickupInfo )
    TriggerClientEvent('createPickup', -1, pickupInfo)
end)


RegisterNetEvent('CNC:clearPickups')
AddEventHandler('CNC:clearPickups', function ( )
    print('clearPickups Handler')
    pickupInfos = {}
    TriggerClientEvent('CNC:clearPickups', -1)
end)


RegisterNetEvent('CNC:removePickup')
AddEventHandler('CNC:removePickup', function ( pickupInfo )
    Citizen.Trace('removePickup')
    for i,pickup in pairs(pickupInfos) do

        if pickup.x == pickupInfo.x and pickup.y == pickupInfo.y and pickup.z == pickupInfo.z then
            table.remove(pickupInfos, i)
            local collectedPickupInfo = pickupInfo
            collectedPickupInfo.time = os.time()
            table.insert( removedPickups, collectedPickupInfo )
            TriggerClientEvent("removePickup", -1, pickupInfo)
            break
        end
    end
end)


-- Respawn Pickups
local respawnTime = 90 --Respawntime in seconds
Citizen.CreateThread(function (  )
    while true do
        Citizen.Wait(100)
        --print(os.time())
        for i,pickupInfo in ipairs(removedPickups) do
            
            if os.time() - pickupInfo.time > respawnTime then
                table.remove( removedPickups, i )
                print('Respawn')
                TriggerEvent('CNC:registerNewPickup', pickupInfo)
            end
        end

        --print('Pickups: ' .. #pickupInfos)
    end
end)