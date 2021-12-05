
-- =========================================================================
-- ================================ GETAWAY ================================
-- =========================================================================

local getawayVehicle
local BlipUpdateDistance = 5.0

function CreateGetaway(getaway)

        getawayVehicle = CreateVehicle(getaway['hash'], getaway.coord.x, getaway.coord.y, getaway.coord.z , 0.0, true, true)
        SetEntityRotation(getawayVehicle, getaway.rot.x, getaway.rot.y, getaway.rot.z, false, true)
        SetVehicleNumberPlateText(getawayVehicle, 'GETAWAY')
        
        Wait(2000)

        SetEntityDistanceCullingRadius(getawayVehicle, 100000.0)   
        Net_Getaway = NetworkGetNetworkIdFromEntity(getawayVehicle)
        ForceCreateGetawayBlip(getawayVehicle)

end


function ForceCreateGetawayBlip(getawayVehicle)
    Citizen.CreateThread(function ()
        local oldGetawayCoords = {x=0.0, y=0.0, z=0.0}
        local currentGetawayCoords = {x=0.0, y=0.0, z=0.0}
        local dist

        while true do
            currentGetawayCoords.x, currentGetawayCoords.y, currentGetawayCoords.z = table.unpack(GetEntityCoords(getawayVehicle))

            dist = DistanceBetweenCoords2D(currentGetawayCoords.x, currentGetawayCoords.y, oldGetawayCoords.x, oldGetawayCoords.y )

            if dist > BlipUpdateDistance then
                oldGetawayCoords.x = currentGetawayCoords.x
                oldGetawayCoords.y = currentGetawayCoords.y
                SendGetawyCoordsToClients(currentGetawayCoords)
            end

            Citizen.Wait(10)
        end
    end)
end


function SendGetawyCoordsToClients(Coords)
    for i,playerInfo in ipairs(PlayerInfos) do
        if playerInfo.team == 'crook' then
            TriggerClientEvent("CNC:UpdateGetawayBlip", playerInfo.player, Coords)
        end
    end
end


-- check Boss left the Getaway
RegisterNetEvent('cnc:baseevents:leftVehicle')
AddEventHandler('cnc:baseevents:leftVehicle', function(veh, seat, displayName,netId)

    TriggerClientEvent("cnc:baseevents:playerLeftdGeta", source)
    if IsRoundOngoing then
        --if tonumber(source) == tonumber(BossInfo.player) and veh == Getaway then
        if tonumber(source) == tonumber(BossID) and netId == Net_Getaway then
            print("Boss left the GETA")
            TriggerClientEvent('CNC:showNotification', -1, '~r~Boss left the Getaway')
            IsBossInGetaway = false
        end
    end

end)


-- check Boss entered the Getaway
RegisterNetEvent('cnc:baseevents:enteredVehicle')
AddEventHandler('cnc:baseevents:enteredVehicle', function(veh, seat, displayName, netId)

    -- TriggerEvent('Debug', 'CNC:Server:getaway:enteredVehicle')
    TriggerClientEvent("cnc:baseevents:playerEnteredGeta", source)

    TriggerEvent('Log', 'baseevents:enteredVehicle-veh', veh)
    TriggerEvent('Log', 'baseevents:enteredVehicle-netId', netId)

    if IsRoundOngoing then

        if netId == Net_Getaway then

            for i,playerInfo in ipairs(PlayerInfos) do
                if playerInfo.team == 'crook' and tonumber(playerInfo.player) == tonumber(source) then
                    TriggerClientEvent('CNC:unfrezzeGetaway', source, veh)
                elseif playerInfo.team == 'cop' and tonumber(playerInfo.player) == tonumber(source) then
                    TriggerClientEvent('CNC:showNotification', source, '~r~This is the Getaway, please dont move it!!!')
                end
            end
            
            -- print('netId: ' .. netId)
            -- print('netId_new: ' .. veh)
            -- print('net_Getaway: ' .. net_Getaway)
            TriggerClientEvent('CNC:id', source, veh)
            if tonumber(source) == tonumber(BossID) then
                print("Boss entered the GETA")
                TriggerClientEvent('CNC:showNotification', -1, '~r~Boss entered the Getaway')
                IsBossInGetaway = true
                StartCoolDownThread( )
            end
        end
    end
end)


RegisterNetEvent('CNC:GetawayIsNotDriveable')
AddEventHandler('CNC:GetawayIsNotDriveable', function()

    if IsGetawayDriveable then
        IsGetawayDriveable = false
        print("Getaway is broken")
        TriggerClientEvent('CNC:showNotification', -1, 'Getaway is broken!')
        CopsWinsTheRound( )
    end

end)

RegisterNetEvent('CNC:clearVehicles')
AddEventHandler('CNC:clearVehicles', function()

        DeleteEntity(getawayVehicle)
end)