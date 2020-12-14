
-- =========================================================================
-- ================================ GETAWAY ================================
-- =========================================================================

local checked = false
local OldGetawayCoord = {x=0, y=0, z=0}
local dist = 1000


RegisterNetEvent('CNC:UpdateGetawayCoord')
AddEventHandler('CNC:UpdateGetawayCoord', function( getawayCoord )
    GetawayCoord = getawayCoord
end)


RegisterNetEvent('CNC:forceUpdateGetawayBlip')
AddEventHandler('CNC:forceUpdateGetawayBlip', function()
    Citizen.CreateThread(function ( )
        while isRoundOngoing do
            Citizen.Wait(10)
            dist = DistanceBetweenCoords2D(GetawayCoord.x, GetawayCoord.y, OldGetawayCoord.x, OldGetawayCoord.y)
            if dist > 5.0 then
                OldGetawayCoord = GetawayCoord

                for i,player in ipairs(PlayerInfos) do
                    if player.team == 'crook' then
                        TriggerClientEvent("CNC:UpdateGetawayBlip", player.player, GetawayCoord)
                    end
                end
            end
        end
    end)
end)



-- create GetawayBlips
RegisterNetEvent('CNC:creatGetaway')
AddEventHandler('CNC:creatGetaway', function(net_getaway)

    TriggerEvent('Log', 'CNC:creatGetaway-NetGeta', net_getaway)


    net_Getaway = net_getaway
    TriggerClientEvent('CNC:findGetawayCoord', -1, net_Getaway)
    TriggerEvent('CNC:forceUpdateGetawayBlip')
end)


-- check Boss left the Getaway
RegisterNetEvent('cnc:baseevents:leftVehicle')
AddEventHandler('cnc:baseevents:leftVehicle', function(veh, seat, displayName,netId)






    TriggerClientEvent("cnc:baseevents:playerLeftdGeta", source)
    if isRoundOngoing then
        --if tonumber(source) == tonumber(BossInfo.player) and veh == Getaway then
        if tonumber(source) == tonumber(BossID) and netId == net_Getaway then
            print("Boss left the GETA")
            TriggerClientEvent('CNC:showNotification', -1, '~r~Boss left the Getaway')
            isBossInGetaway = false
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

    if isRoundOngoing then
        print('netId: ' .. netId)
        print('netId_new: ' .. veh)
        print('net_Getaway: ' .. net_Getaway)
        TriggerClientEvent('CNC:id', source, veh)
        if tonumber(source) == tonumber(BossID) and netId == net_Getaway then
            print("Boss entered the GETA")
            TriggerClientEvent('CNC:showNotification', -1, '~r~Boss entered the Getaway')
            isBossInGetaway = true
            startCoolDownThread( )
        end
    end
end)
