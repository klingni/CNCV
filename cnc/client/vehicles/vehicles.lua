local ListVehicles = {}

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

    local veh_net = VehToNet(vehicle)

    local veh = NetToVeh(veh_net)

    NetworkRegisterEntityAsNetworked(vehicle)
    SetNetworkIdSyncToPlayer(veh_net, -1, true)
    NetworkSetNetworkIdDynamic(veh_net, true)
    
    local blip = AddBlipForEntity(vehicle)

    SetBlipSprite(blip, 103)
    SetBlipColour(blip, 57)
    local getaway_blip = blip
end)


