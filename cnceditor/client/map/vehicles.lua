RegisterNetEvent("eventSpawnCar")
AddEventHandler("eventSpawnCar",function(car)

    local car = car or "zentorno"

    local hash = GetHashKey(car)

    RequestModel(hash)

    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(hash, x + 2, y + 2, z + 1, 0.0, true, false)

    Citizen.Trace('NetworkID:'.. NetworkGetNetworkIdFromEntity(vehicle))
    Citizen.Trace('vehicle:' .. vehicle)

    SetVehicleNumberPlateText(vehicle, 'KLINGNI')

Citizen.Trace(car .. " - " .. hash)

    TriggerEvent('CNCE:Map:addToVehiclesList', vehicle)

end)


RegisterNetEvent("CNCE:Helper:teleport")
AddEventHandler("CNCE:Helper:teleport",function(car)
    local playerPed = GetPlayerPed(-1)
    local WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
        SetEntityCoords(playerPed, coord.x, coord.y, coord.z)
    end

end)