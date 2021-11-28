local ListVehicles = {}


-- ============== VEHICLES START ========================

RegisterNetEvent("CNC:eventCreateVehicles")
AddEventHandler("CNC:eventCreateVehicles", function(vehicles)

    -- TriggerServerEvent('Debug', 'CNC:Client:Vehicle:eventCreateVehicles')
    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:eventCreateVehicles', vehicles)

    for i,vehicle in ipairs(vehicles) do

        --local hash = GetHashKey(vehicle['model'])
        local hash = vehicle['hash']

        RequestModel(hash)

        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Citizen.Wait(1)
        end

        local curVehicle = CreateVehicle(hash, vehicle.coord.x, vehicle.coord.y, vehicle.coord.z, 0.0, true, false)
        SetEntityRotation(curVehicle, vehicle.rot.x, vehicle.rot.y, vehicle.rot.z, false, true)
        SetVehicleNumberPlateText(curVehicle, 'Vehicle')  

        local veh_net = VehToNet(curVehicle)
        print('net_Veh: ' .. veh_net)
        SetNetworkIdExistsOnAllMachines(veh_net, true)
        SetEntityAsMissionEntity(veh_net, true, true)
        table.insert( ListVehicles, veh_net )
    end
    TriggerServerEvent('CNC:createVehicle', ListVehicles)
    ListVehicles = {}
end)


RegisterNetEvent("CNC:clearVehicle")
AddEventHandler("CNC:clearVehicle",function(net_Vehicle)
    -- TriggerServerEvent('Debug', 'CNC:Client:Vehicle:clearVehicles')

    print('delete Vehicles: ' .. #net_Vehicle)
    for i,vehicle in ipairs(net_Vehicle) do
        local veh = NetToVeh(tonumber(vehicle))
        --print('ID:' .. i ..' Net:' .. vehicle .. ' Veh:' .. veh)
        SetVehicleAsNoLongerNeeded(veh)
        DeleteVehicle(veh)
    end
    ListVehicles = {}
end)


-- ============== VEHICLES END ========================



RegisterNetEvent("eventSpawnCar")
AddEventHandler("eventSpawnCar",function(car, coord)
    
    local car = car or "zentorno"
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local coord = coord or {
        x=x+2,
        y=y+2,
        z=z-1
    }
    
    local hash = GetHashKey(car)
    RequestModel(hash)
    
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Citizen.Wait(0)
    end
    
    local vehicle = CreateVehicle(hash, coord.x, coord.y, coord.z, 0.0, true, true)
    table.insert( ListVehicles, vehicle )
    SetVehicleNumberPlateText(vehicle, 'CHEATER')

    SetEntityAsMissionEntity(vehicle, true, true)

    local vektor = GetEntityRotation(vehicle, false)
    print("X:" .. vektor.x .. " Y:" .. vektor.y .. " Z:" .. vektor.z)
    --SetNetworkIdExistsOnAllMachines(vehicle, true)


    local veh_net = VehToNet(vehicle)
    -- print('NetworkID von Cheat Karre: ' .. veh_net)

    local veh = NetToVeh(veh_net)
    -- print('VehicleID von Cheat Karre: ' .. veh)
    -- print('Veh aus Net:' .. NetToVeh(veh_net))
    -- print('Ent aus Net:' .. NetToEnt(veh_net))


    NetworkRegisterEntityAsNetworked(vehicle)
    SetNetworkIdSyncToPlayer(veh_net, -1, true)
    NetworkSetNetworkIdDynamic(veh_net, true)
    
    local blip = AddBlipForEntity(vehicle)

    SetBlipSprite(blip, 103)
    SetBlipColour(blip, 57)
    local getaway_blip = blip
end)


