local ListVehicles = {}
local spawner_hint_blips = {}


-- ============== VEHICLES START ========================

RegisterNetEvent("CNC:eventCreateSpawner")
AddEventHandler("CNC:eventCreateSpawner", function(vehicles)
    -- TriggerServerEvent('Debug', 'CNC:Client:Spawner:eventCreateSpawner')
    print("create Spawner")

    for i,vehicle in ipairs(vehicles) do

        --local hash = GetHashKey(vehicle['model'])
        local hash = vehicle['hash']

        RequestModel(hash)

        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Citizen.Wait(1)
        end

        for i=1,5 do
            local carGen = CreateScriptVehicleGenerator(vehicle.coord.x, vehicle.coord.y, vehicle.coord.z, vehicle.rot.z, 5.0, 3.0, hash, 1, 1, -1, -1, true, false, false, true, true, -1)
            SetScriptVehicleGenerator(carGen, true)
            SetAllVehicleGeneratorsActive(true)
            
        end

        
        spawner_blip = AddBlipForCoord(vehicle.coord.x, vehicle.coord.y, vehicle.coord.z)
        SetBlipSprite(spawner_blip, 64)
        SetBlipColour(spawner_blip, 9)
        SetBlipAsShortRange(spawner_blip, true)
        --SetBlipScale(spawner_blip, 1.0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Aircraft-Spawner")
        EndTextCommandSetBlipName(spawner_blip)

        table.insert( spawner_hint_blips, spawner_blip )

    end
    TriggerServerEvent('CNC:createSpawner', ListVehicles)
    ListVehicles = {}
end)


RegisterNetEvent("CNC:clearSpawner")
AddEventHandler("CNC:clearSpawner",function(net_Spawner)
    -- TriggerServerEvent('Debug', 'CNC:Client:Spawner:clearSpawner')

    print('delete Spawner: ' .. #net_Spawner)
    for i,vehicle in ipairs(net_Spawner) do
        veh = NetToVeh(tonumber(vehicle))
        --print('ID:' .. i ..' Net:' .. vehicle .. ' Veh:' .. veh)
        SetVehicleAsNoLongerNeeded(veh)
        DeleteVehicle(veh)
    end
    ListVehicles = {}
end)