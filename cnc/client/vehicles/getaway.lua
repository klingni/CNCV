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

    local vehicle = CreateVehicle(hash, getaway.coord.x, getaway.coord.y, getaway.coord.z , 0.0, true, true)
    -- FreezeEntityPosition(vehicle, true)
    SetEntityRotation(vehicle, getaway.rot.x, getaway.rot.y, getaway.rot.z, false, true)
    
    
    --All Getaways are godmoded, exept submarine
    if hash ~= 771711535 then
        SetEntityCanBeDamaged(vehicle, false)
    end
    
    SetVehicleNumberPlateText(vehicle, 'GETAWAY')
    
    NetworkRegisterEntityAsNetworked(vehicle)
    SetNetworkIdSyncToPlayer(veh_net, -1, true)
    
    veh_net = VehToNet(vehicle)
    
    SetNetworkIdExistsOnAllMachines(veh_net, true)
    SetEntityAsMissionEntity(veh_net, true, true)
    SetNetworkIdCanMigrate(veh_net, true)
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


RegisterNetEvent("CNC:CreateGetawayBlip")
AddEventHandler("CNC:CreateGetawayBlip",function(ga_netid)

    print("set Getaway Blip")

    while not NetworkDoesNetworkIdExist(ga_netid) do
        Citizen.Wait(1000)
    end


    print("GA_NetId: " .. ga_netid)
    
    local GA_Entity = NetToVeh(tonumber(ga_netid))
    print("GA_Entity: " .. GA_Entity)
    
    getaway_blip = AddBlipForEntity(GA_Entity)
    SetBlipSprite(getaway_blip, 315)
    SetBlipColour(getaway_blip, 47)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Getaway")
    EndTextCommandSetBlipName(getaway_blip)

    checkGetawayIsDriveable(GA_Entity)

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


RegisterNetEvent("CNC:unfrezzeGetaway")
AddEventHandler("CNC:unfrezzeGetaway", function(veh)
    print("UNFREZZE GETAWAY")
    FreezeEntityPosition(veh, false)
    SetEntityCanBeDamaged(veh, true)
end)


function checkGetawayIsDriveable(vehicle)
    Citizen.CreateThread(function()
        running = true
        while running do
            if not IsVehicleDriveable(vehicle, false) then
                TriggerServerEvent("CNC:GetawayIsNotDriveable")
                running = false
            end
            Citizen.Wait(2000)
        end
    end)
end