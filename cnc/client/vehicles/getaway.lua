local getaway_blip
local getaway_hint_blips = {}
local spawned = false
local isRoundOngoing = false
local OldGetawayCoord = {x=0, y=0, z=0}


-- spawn Getaway
RegisterNetEvent("CNC:eventCreateGetaway")
AddEventHandler("CNC:eventCreateGetaway", function(getaway)

    -- TriggerServerEvent('Debug', 'CNC:Client:getaway:enebtCreateGetaway')

    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:eventCreateGetaway', getaway)
    
    --local hash = GetHashKey(getaway['model'])
    local hash = getaway['hash']

    RequestModel(hash)

    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Citizen.Wait(0)
    end

    local vehicle = CreateVehicle(hash, getaway.coord.x, getaway.coord.y, getaway.coord.z, 0.0, true, true)
    SetEntityRotation(vehicle, getaway.rot.x, getaway.rot.y, getaway.rot.z, false, true)
    FreezeEntityPosition(vehicle, false)


    --All Getaways are godmoded, exept submarine
    if hash ~= 771711535 then
        SetEntityCanBeDamaged(vehicle, false)
    end

    SetVehicleNumberPlateText(vehicle, 'GETAWAY')
    veh_net = VehToNet(vehicle)

    SetNetworkIdExistsOnAllMachines(veh_net, true)
    SetEntityAsMissionEntity(veh_net, true, true)
    --print('veh_net: ' .. veh_net)
    TriggerServerEvent("CNC:creatGetaway", veh_net)
end)


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

    veh = NetToVeh(tonumber(getaway_net))
    print("ClearGetaway Veh: " .. veh)
    SetVehicleAsNoLongerNeeded(veh)
    DeleteVehicle(veh)
end)



RegisterNetEvent("CNC:StartRound")
AddEventHandler("CNC:StartRound",function()
    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:StartRound')
    isRoundOngoing = true
end)

RegisterNetEvent("CNC:StopRound")
AddEventHandler("CNC:StopRound",function()
    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:StopRound')
    isRoundOngoing = false
end)


-- RegisterNetEvent("CNC:findGetawayCoord")
-- AddEventHandler("CNC:findGetawayCoord",function(GetawayNetId)

--     TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:findGetawayCoord', GetawayNetId)

--     Citizen.CreateThread(function ( )
--         local time = 1000
--         while isRoundOngoing do
--             Citizen.Wait(time)
--             --print('search for Getaway')
--             local vehicle = NetToVeh(tonumber(GetawayNetId))
--             --print('NetId:' .. GetawayNetId .. ' / Veh:' .. tostring(vehicle))
--             if vehicle ~= 0 then
--                 -- send Getaway Coordinate
--                 local x,y,z = table.unpack(GetEntityCoords(vehicle, true))
--                 TriggerServerEvent('CNC:UpdateGetawayCoord', {x=x, y=y, z=z})
--                 time = 1000
--             else
--                 time = 5000
--             end 
--         end
--     end)
-- end)



RegisterNetEvent("CNC:findGetawayCoord")
AddEventHandler("CNC:findGetawayCoord",function(GetawayNetId)

    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:findGetawayCoord', GetawayNetId)

    Citizen.CreateThread(function ( )
        while isRoundOngoing do
            Citizen.Wait(10)
            --print('search for Getaway')
            local vehicle = NetToVeh(tonumber(GetawayNetId))
            --print('NetId:' .. GetawayNetId .. ' / Veh:' .. tostring(vehicle))
            if vehicle ~= 0 then
                -- send Getaway Coordinate
                local x,y,z = table.unpack(GetEntityCoords(vehicle, true))

                local dist = DistanceBetweenCoords2D(x, y, OldGetawayCoord.x, OldGetawayCoord.y)
                if dist > 5.0 then
                    TriggerServerEvent('CNC:UpdateGetawayCoord', {x=x, y=y, z=z})
                    OldGetawayCoord.x = x
                    OldGetawayCoord.y = y
                end
            end 
        end
    end)
end)


RegisterNetEvent("CNC:UpdateGetawayBlip")
AddEventHandler("CNC:UpdateGetawayBlip",function(coord)
    RemoveBlip(getaway_blip)
    
    getaway_blip = AddBlipForCoord(coord.x, coord.y, coord.z)
    SetBlipSprite(getaway_blip, 315)
    SetBlipColour(getaway_blip, 47)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Getaway")
    EndTextCommandSetBlipName(getaway_blip)

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
