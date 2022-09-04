
-- =========================================================================
-- ================================ VEHICLE ================================
-- =========================================================================

local ListVehicles = {}

function CreateVehicles(vehicles)
    for i,vehicle in ipairs(vehicles) do
        local curVehicle = CreateVehicle(vehicle['hash'], vehicle.coord.x, vehicle.coord.y, vehicle.coord.z, 0.0, true, false)
        SetEntityRotation(curVehicle, vehicle.rot.x, vehicle.rot.y, vehicle.rot.z, false, true)
        SetVehicleNumberPlateText(curVehicle, 'Vehicle')
        table.insert( ListVehicles, curVehicle )
    end
end




RegisterNetEvent('CNC:clearVehicles')
AddEventHandler('CNC:clearVehicles', function()
    TriggerEvent('Log', 'CNC:clearVehicles')
   
    for i,vehicle in ipairs(ListVehicles) do
        DeleteEntity(vehicle)
    end
end)