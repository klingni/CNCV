local PickupCoords = {}
local Pickups = {}
local PickupBlips = {}
local locGlobalMap = {}
local loaded = false
local Vehicles = {}
local MapBlips = {}


-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(0) -- Always put a wait if you're looping to avoid crashing.

--         if IsControlJustReleased(1 --[[input group]], 51 --[[control index]]) then      -- Case E pressed
--             createPickup( )
        
--         elseif IsControlJustReleased(1 --[[input group]], 45 --[[control index]]) then  -- Case R pressed
--             removePickup()
                
--         elseif IsControlJustReleased(1 --[[input group]], 52 --[[control index]]) then  -- Case Q pressed 
--             --Open Menue()
--             exports.ft_libs:OpenMenu("menu_main")
--         end
--     end
-- end)


RegisterNetEvent("CNCE:globMap:createMap")
AddEventHandler("CNCE:globMap:createMap",function(globalMap)
    loaded = false
    cleaning()

    Citizen.Wait(150)
    locGlobalMap = globalMap

    Citizen.Trace('CREATE MAP')

    for i,vehicle in ipairs(locGlobalMap['vehicles']) do

        --local hash = GetHashKey(vehicle.model)
        local hash = vehicle.hash
        while not HasModelLoaded(hash) do
            Citizen.Wait(5)
            RequestModel(hash)
        end


        --Citizen.Trace(vehicle.model .. " - " .. hash)

        Vehicle = CreateVehicle(hash, vehicle.coord.x, vehicle.coord.y, vehicle.coord.z, 0.0, true, false)
        SetEntityRotation(Vehicle, vehicle.rot.x, vehicle.rot.y, vehicle.rot.z, false, true)
        table.insert( Vehicles, Vehicle )
        --Citizen.Trace(Vehicle)

        blip = AddBlipForEntity(Vehicle)
        SetBlipSprite(blip, 225)
        SetBlipColour(blip, 69)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Spawner")
        EndTextCommandSetBlipName(blip)

        table.insert( MapBlips, blip )
    end


    Citizen.Wait(70)
    for i,pickup in ipairs(locGlobalMap['pickups']['positions']) do

        createBlipPickup(pickup.x, pickup.y, pickup.z)


    end

    loaded = true

end)



function cleaning( )
    Citizen.Trace('CLEAR')
    locGlobalMap = {}

    for i,blip in ipairs(PickupBlips) do
        RemoveBlip(blip)
    end
    PickupBlips = {}
    
    for i,blip in ipairs(MapBlips) do
        RemoveBlip(blip)
    end

    for i,vehicle in ipairs(Vehicles) do
        DeleteVehicle(vehicle)
        Citizen.Trace('Clear:' .. vehicle)
        Citizen.Wait(1000)
    end

    

    MapBlips = {}
    Vehicles = {}
end



RegisterNetEvent('CNCE:globMap:forceCallLoadMap')
AddEventHandler('CNCE:globMap:forceCallLoadMap', function ()
    TriggerServerEvent('CNCE:globMap:callLoadMap')
end)



function createBlipPickup( x,y,z )
    
    --Citizen.Trace(x)
    blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Randome Pickup")
    EndTextCommandSetBlipName(blip)
    
    table.insert( PickupBlips, blip )
    --Citizen.Trace('Count: ' .. #PickupBlips)
end



RegisterNetEvent('CNCE:globMap:Pickup:createPickup')
AddEventHandler('CNCE:globMap:Pickup:createPickup', function ()
    createPickup( )
end)

function createPickup( )
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    coord = {x=x, y = y, z = z}
    TriggerServerEvent('CNCE:globMap:Pickup:forceAddPickup', coord)
end



RegisterNetEvent('CNCE:globMap:Pickup:removePickup')
AddEventHandler('CNCE:globMap:Pickup:removePickup', function ()
    removePickup( )
end)

function removePickup()
    Citizen.CreateThread(function (  )
        local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
        for i,coord in ipairs(locGlobalMap['pickups']['positions']) do
            if DistanceBetweenCoords2D(x,y,coord.x, coord.y) < 3 then
                TriggerServerEvent('CNCE:globMap:Pickup:forceRemovePickup', i)
            end
        end
    end)
end





RegisterNetEvent("CNCE:globMap:forceSetCurrentVehicleToSpawner")
AddEventHandler("CNCE:globMap:forceSetCurrentVehicleToSpawner",function()
    if IsPedSittingInAnyVehicle(PlayerPedId()) then

        Citizen.Trace('SPAWN')
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

        TriggerServerEvent('CNCE:globMap:addVehicle', VehicleInfo)
    end
end)







function DistanceBetweenCoords2D(x1,y1,x2,y2)
	local deltax = x1 - x2
	local deltay = y1 - y2

	dist = math.sqrt((deltax * deltax) + (deltay * deltay))

	return dist
end


Citizen.CreateThread(function (  )
    while true do
        Citizen.Wait(0)
        if loaded then
            local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
                
            for i,pickup in ipairs(locGlobalMap['pickups']['positions']) do
                if DistanceBetweenCoords2D(pickup.x, pickup.y, x , y) < 200 then
                    DrawMarker(0,pickup.x ,pickup.y ,pickup.z ,0,0,0,0,0,0,2.001,2.0001,1.001,0,155,255,200,0,0,0,0)
                end
            end
        end
    end
end)
