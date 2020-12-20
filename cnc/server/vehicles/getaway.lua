
-- =========================================================================
-- ================================ GETAWAY ================================
-- =========================================================================

local checked = false


RegisterNetEvent('CNC:forceCreateGetawayBlip')
AddEventHandler('CNC:forceCreateGetawayBlip', function()

    for i,playerInfo in ipairs(PlayerInfos) do
        if playerInfo.team == 'crook' then
            TriggerClientEvent("CNC:CreateGetawayBlip", playerInfo.player, net_Getaway)
        end
    end

end)



-- create GetawayBlips
RegisterNetEvent('CNC:creatGetaway')
AddEventHandler('CNC:creatGetaway', function(net_getaway)

    TriggerEvent('Log', 'CNC:creatGetaway-NetGeta', net_getaway)


    net_Getaway = net_getaway
    TriggerEvent('CNC:forceCreateGetawayBlip')
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
        if tonumber(source) == tonumber(BossID) and netId == net_Getaway then
            print("Boss entered the GETA")
            TriggerClientEvent('CNC:showNotification', -1, '~r~Boss entered the Getaway')
            isBossInGetaway = true
            startCoolDownThread( )
        end
    end
end)
