local Map
local MapBlips = {}
local loaded = false
local Vehicles = {}
local GetawayInfo = {}



RegisterNetEvent("CNCE:Map:forceLoadMap")
AddEventHandler("CNCE:Map:forceLoadMap",function(args)
    TriggerServerEvent('CNCE:Map:loadMap', args['id'])
end)

RegisterNetEvent("CNCE:Map:forceLoadMapById")
AddEventHandler("CNCE:Map:forceLoadMapById",function(id)
    Citizen.Trace('Force:' .. id)
    TriggerServerEvent('CNCE:Map:loadMap', id)
end)



RegisterNetEvent("CNCE:Map:createMap")
AddEventHandler("CNCE:Map:createMap",function(map, createVehicle)
    loaded = false
    clear()
    Citizen.Wait(1000)
    Map = map

    for i,crook in ipairs(Map['crook']['spawnpoints']) do
        blip = createBlipMap(crook.x, crook.y, crook.z, 81, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Crook spawn")
        EndTextCommandSetBlipName(blip)
    end

    for i,cop in ipairs(Map['cop']['spawnpoints']) do
        blip = createBlipMap(cop.x, cop.y, cop.z, 27, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Cop spawn")
        EndTextCommandSetBlipName(blip)
    end

    for i,getaway in ipairs(Map['getaway']) do

        blip = createBlipMap(getaway.coord.x, getaway.coord.y, getaway.coord.z, 81, 225)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Getaway")
        EndTextCommandSetBlipName(blip)
    end

    for i,vehicle in ipairs(Map['vehicle']) do

        blip = createBlipMap(vehicle.coord.x, vehicle.coord.y, vehicle.coord.z, 74, 225)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Vehicle")
        EndTextCommandSetBlipName(blip)
    end

    if createVehicle then
        for i,getaway in ipairs(Map['getaway']) do

            --local hash = GetHashKey(getaway.model)
            local hash = getaway.hash
            
            while not HasModelLoaded(hash) do
                Citizen.Wait(5)
                RequestModel(hash)
            end

            Vehicle = CreateVehicle(hash, getaway.coord.x, getaway.coord.y, getaway.coord.z, 0.0, true, false)
            SetEntityRotation(Vehicle, getaway.rot.x, getaway.rot.y, getaway.rot.z, false, true)
            --FreezeEntityPosition(Vehicle, true)
            table.insert( Vehicles, Vehicle )

        end

        for i,vehicle in ipairs(Map['vehicle']) do

            --local hash = GetHashKey(vehicle.model)
            local hash = vehicle.hash
            
            while not HasModelLoaded(hash) do
                RequestModel(hash)
                Citizen.Wait(0)
            end

            Vehicle = CreateVehicle(hash, vehicle.coord.x, vehicle.coord.y, vehicle.coord.z, 0.0, true, false)
            SetEntityRotation(Vehicle, vehicle.rot.x, vehicle.rot.y, vehicle.rot.z, false, true)
            table.insert( Vehicles, Vehicle )

        end
    end
    loaded = true
end)


RegisterNetEvent("CNCE:Map:clear")
AddEventHandler("CNCE:Map:clear",function()
    Citizen.Trace('clearEvent')
    clear()
end)

function clear( )
    Map = {}
    
    for i,blip in ipairs(MapBlips) do
        RemoveBlip(blip)
    end

    for i,vehicle in ipairs(Vehicles) do
        DeleteVehicle(vehicle)
    end
    MapBlips = {}
    Vehicles = {}
    
    Citizen.InvokeNative(0x957838AAF91BD12D, 0, 0, 0, 10000.0, false, false, false, false)

    players = GetPlayersNetworkID()
    ids = {}

    for i=1,999 do
        table.insert( ids, i )
    end

    for i= #ids, 1, -1 do 
        for j,player in ipairs(players) do
            if i == tonumber(player) then
                table.remove( ids, i )
            end
        end
    end

    Citizen.CreateThread(function (  )
        for i,id in ipairs(ids) do
            if NetworkDoesNetworkIdExist(id) then        
                DeleteEntity(NetworkGetEntityFromNetworkId(id))
            end
        end
    end)
end

function GetPlayersNetworkID()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            --Citizen.Trace(i .. ":")
            table.insert(players, NetworkGetNetworkIdFromEntity(GetPlayerPed(i)))
        end
    end

    return players
end

RegisterNetEvent("CNCE:Map:forceAddCop")
AddEventHandler("CNCE:Map:forceAddCop",function()

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    coord = {x=x, y = y, z = z}
    TriggerServerEvent('CNCE:Map:addCop', coord)
end)

RegisterNetEvent("CNCE:Map:forceAddCrook")
AddEventHandler("CNCE:Map:forceAddCrook",function()

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    coord = {x=x, y = y, z = z}
    TriggerServerEvent('CNCE:Map:addCrook', coord)
end)


RegisterNetEvent("CNCE:Map:forceRemoveSpawn")
AddEventHandler("CNCE:Map:forceRemoveSpawn",function()
    removeSpawn()
end)

function removeSpawn()
    Citizen.CreateThread(function (  )
        local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
        for i,coord in ipairs(Map['cop']['spawnpoints']) do
            if DistanceBetweenCoords2D(x,y,coord.x, coord.y) < 3 then
                TriggerServerEvent('CNCE:Map:removeSpawn', 'cop', i)
            end
        end
        for i,coord in ipairs(Map['crook']['spawnpoints']) do
            if DistanceBetweenCoords2D(x,y,coord.x, coord.y) < 3 then
                TriggerServerEvent('CNCE:Map:removeSpawn', 'crook', i)
            end
        end
        for i,ga in ipairs(Map['getaway']) do
            if DistanceBetweenCoords2D(x,y,ga.coord.x, ga.coord.y) < 3 then
                TriggerServerEvent('CNCE:Map:removeSpawn', 'getaway', i)
            end
        end
        for i,veh in ipairs(Map['vehicle']) do
            if DistanceBetweenCoords2D(x,y,veh.coord.x, veh.coord.y) < 3 then
                TriggerServerEvent('CNCE:Map:removeSpawn', 'vehicle', i)
            end
        end
    end)
end


RegisterNetEvent("CNCE:Map:forceSetCurrentVehicleToGetaway")
AddEventHandler("CNCE:Map:forceSetCurrentVehicleToGetaway",function()

    if IsPedSittingInAnyVehicle(PlayerPedId()) then

        currentVehicle = GetVehiclePedIsUsing(PlayerPedId())

        VehicleCoord = GetEntityCoords(currentVehicle, true)
        VehicleRot = GetEntityRotation(currentVehicle, false)
        VehicleModel = GetEntityModel(currentVehicle)

        GetawayInfo = {
            coord = {x=VehicleCoord.x, y=VehicleCoord.y, z=VehicleCoord.z},
            rot = {x=VehicleRot.x, y=VehicleRot.y, z=VehicleRot.z},
            model = GetDisplayNameFromVehicleModel(VehicleModel),
            hash = VehicleModel
        }

        TriggerServerEvent('CNCE:Map:addGetaway', GetawayInfo)

    else
        TriggerEvent('CNC:showNotification', '~r~ERROR: ~w~You are not in a vehicle')
    end
end)

RegisterNetEvent("CNCE:Map:forceSetCurrentVehicleToVehicle")
AddEventHandler("CNCE:Map:forceSetCurrentVehicleToVehicle",function()

    if IsPedSittingInAnyVehicle(PlayerPedId()) then

        currentVehicle = GetVehiclePedIsUsing(PlayerPedId())

        VehicleCoord = GetEntityCoords(currentVehicle, true)
        VehicleRot = GetEntityRotation(currentVehicle, false)
        VehicleModel = GetEntityModel(currentVehicle)

        VehicleInfo = {
            coord = {x=VehicleCoord.x, y=VehicleCoord.y, z=VehicleCoord.z},
            rot = {x=VehicleRot.x, y=VehicleRot.y, z=VehicleRot.z},
            model = GetDisplayNameFromVehicleModel(VehicleModel),
            hash = VehicleModel
        }

        TriggerServerEvent('CNCE:Map:addVehicle', VehicleInfo)

    else
        TriggerEvent('CNC:showNotification', '~r~ERROR: ~w~You are not in a vehicle')
    end
end)

RegisterNetEvent("CNCE:Map:forceRenameMap")
AddEventHandler("CNCE:Map:forceRenameMap",function()
    local newName = GetUserInput('Please enter the new map name:')
    if newName ~= "" then
        TriggerServerEvent('CNCE:Map:renameMap', newName)
    else
        TriggerEvent('CNC:showNotification', '~r~ERROR: ~w~No name was entered, rename canceled')
    end
end)


function createBlipMap( x,y,z, color, sprite )
    blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    table.insert( MapBlips, blip )
end


Citizen.CreateThread(function (  )
    while true do
        Citizen.Wait(0)
        if loaded then
            for i,coord in ipairs(Map['cop']['spawnpoints']) do
                    DrawMarker(0,coord.x ,coord.y ,coord.z ,0,0,0,0,0,0,2.001,2.0001,1.001,179,0,179,200,0,0,0,0)
            end

            for i,coord in ipairs(Map['crook']['spawnpoints']) do
                DrawMarker(0,coord.x ,coord.y ,coord.z ,0,0,0,0,0,0,2.001,2.0001,1.001,255,153,0,200,0,0,0,0)
            end
        end

        --SetEntityHealth(PlayerPedId(), 200)

    end
end)


RegisterNetEvent("CNCE:Map:addToVehiclesList")
AddEventHandler("CNCE:Map:addToVehiclesList",function(vehicle)

    table.insert( Vehicles,vehicle )

end)

RegisterNetEvent("CNCE:Map:addNewMap")
AddEventHandler("CNCE:Map:addNewMap",function()

    local mapName = GetUserInput('Please enter the map NAME:')
    local autorName = GetUserInput('Please enter the AUTOR/CREATOR name:')
    local password = GetUserInput('Please enter PASSWORD to protect editing by others:')

    TriggerServerEvent('CNCE:Map:addNewMap', mapName, autorName, password)

end)

RegisterNetEvent("CNCE:Map:saveMap")
AddEventHandler("CNCE:Map:saveMap",function()

    local password = GetUserInput('Please enter PASSWORD to save the map:')
    TriggerServerEvent("CNCE:Map:saveMap", password)

end)