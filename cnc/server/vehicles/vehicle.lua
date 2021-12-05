
-- =========================================================================
-- ================================ VEHICLE ================================
-- =========================================================================

local ListVehicles = {}

function CreateVehicles(vehicles)
    -- TriggerServerEvent('Debug', 'CNC:Client:Vehicle:eventCreateVehicles')
    -- TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:eventCreateVehicles', vehicles)

    for i,vehicle in ipairs(vehicles) do


        local curVehicle = CreateVehicle(vehicle['hash'], vehicle.coord.x, vehicle.coord.y, vehicle.coord.z, 0.0, true, false)
        SetEntityRotation(curVehicle, vehicle.rot.x, vehicle.rot.y, vehicle.rot.z, false, true)
        SetVehicleNumberPlateText(curVehicle, 'Vehicle')

        -- local veh_net = VehToNet(curVehicle)

        table.insert( ListVehicles, curVehicle )
    end

    -- TriggerServerEvent('CNC:createVehicle', ListVehicles)
    -- ListVehicles = {}
end




RegisterNetEvent('CNC:clearVehicles')
AddEventHandler('CNC:clearVehicles', function()

    TriggerEvent('Log', 'CNC:clearVehicles')

    print('CLEAR ALL VEHICLES NEU')
    
    for i,vehicle in ipairs(ListVehicles) do
        DeleteEntity(vehicle)
    end
end)