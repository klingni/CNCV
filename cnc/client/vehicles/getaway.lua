local getaway_blip
local getaway_hint_blips = {}
local spawned = false
local OldGetawayCoord = {x=0, y=0, z=0}



RegisterNetEvent("CNC:eventCreateGetawayWaypoint")
AddEventHandler("CNC:eventCreateGetawayWaypoint", function(getaway)
    Citizen.Wait(2500)
    while not IsWaypointActive() do
        Wait(1)
        SetNewWaypoint(getaway.coord.x, getaway.coord.y)
    end
end)


RegisterNetEvent("CNC:clearGA")
AddEventHandler("CNC:clearGA",function(getaway_net)
    while DoesBlipExist(getaway_blip) do
        Citizen.Wait(1)
        print("try to delete Getaway Blip")
        RemoveBlip(getaway_blip)
    end

    print("ClearGetaway NET: " .. getaway_net)

    local veh = NetToVeh(tonumber(getaway_net))
    print("ClearGetaway Veh: " .. veh)
    SetVehicleAsNoLongerNeeded(veh)
    DeleteVehicle(veh)
end)



RegisterNetEvent("CNC:CreateGetawayBlip")
AddEventHandler("CNC:CreateGetawayBlip",function(getaway)

    print('CREATE GETAWAY BLIP: ' .. getaway)

    RemoveBlip(getaway_blip)


    getaway_blip = AddBlipForEntity(NetToVeh(tonumber(getaway)))
    SetBlipSprite(getaway_blip, 315)
    SetBlipColour(getaway_blip, 47)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Getaway")
    EndTextCommandSetBlipName(getaway_blip)

    CheckGetawayIsDriveable(NetToVeh(tonumber(getaway)))

end)


RegisterNetEvent("CNC:eventCreateCopHints")
AddEventHandler("CNC:eventCreateCopHints",function(map)
    -- TriggerServerEvent('Debug', 'CNC:Client:getaway:createCopHints')


    for i,getaway in ipairs(map['getaway']) do
        getaway_blip = AddBlipForCoord(getaway.coord.x, getaway.coord.y, getaway.coord.z)
        SetBlipSprite(getaway_blip, 66)
        SetBlipColour(getaway_blip, 46)
        SetBlipAsShortRange(getaway_blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("possible GETA")
        EndTextCommandSetBlipName(getaway_blip)

        table.insert( getaway_hint_blips, getaway_blip )
    end  
end)

RegisterNetEvent("CNC:cleanAll")
AddEventHandler("CNC:cleanAll", function()

    -- TriggerServerEvent('Debug', 'CNC:Client:getaway:clearAll')


    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:cleanAll')

    print("START clean Map-Getaway")
    for i,blip in ipairs(getaway_hint_blips) do
        while DoesBlipExist(blip) do
            Citizen.Wait(1)
            print("try to delete Getaway Blip")
            RemoveBlip(blip)
        end
    end
    getaway_hint_blips = {}

    while DoesBlipExist(getaway_blip) do
        Citizen.Wait(1)
        print("try to delete Getaway Blip")
        RemoveBlip(getaway_blip)
    end

    print("STOP clean Map-Getaway")


end)


function CheckGetawayIsDriveable(vehicle)
    Citizen.CreateThread(function()
        local running = true
        while running do
            if not IsVehicleDriveable(vehicle, false) then
                TriggerServerEvent("CNC:GetawayIsNotDriveable")
                running = false
            end
            Citizen.Wait(2000)
        end
    end)
end