local checked = false
local global = "test"

Citizen.CreateThread(function()
    local isDead = false
    local hasBeenDead = false
	local diedAt
    
    while true do
        Wait(1)
        
        
        local player = PlayerId()
        
        if NetworkIsPlayerActive(player) then
            local ped = PlayerPedId()
            
            if IsPedFatallyInjured(ped) and not isDead then
                print("Fatally")
                isDead = true
                if not diedAt then
                	diedAt = GetGameTimer()
                end
                
                local killer, killerweapon = NetworkGetEntityKillerOfPlayer(player)
				local killerentitytype = GetEntityType(killer)
				local killertype = -1
				local killerinvehicle = false
				local killervehiclename = ''
                local killervehicleseat = 0
				if killerentitytype == 1 then
					killertype = GetPedType(killer)
					if IsPedInAnyVehicle(killer, false) == 1 then
						killerinvehicle = true
						killervehiclename = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(killer)))
                        killervehicleseat = GetPedVehicleSeat(killer)
					else killerinvehicle = false
					end
				end
                
				local killerid = NetworkGetPlayerIndexFromPed(killer)
				if killer ~= ped and killerid ~= nil and NetworkIsPlayerActive(killerid) then killerid = GetPlayerServerId(killerid)
				else killerid = -1
                end
                
                
                if killer == ped or killer == -1 then
                    while not checked do
                        print("DIED")
                        TriggerServerEvent('cnc:baseevents:onPlayerDied', killertype, { table.unpack(GetEntityCoords(ped)) })
                        hasBeenDead = true
                        Wait(1000)

                    end
                    checked = false
                else
                    while not checked do
                        print("cnc:base Killed")
                        print("GLOBAl Test: " .. global)
                        TriggerServerEvent('cnc:baseevents:onPlayerKilled', killerid, {killertype=killertype, weaponhash = killerweapon, killerinveh=killerinvehicle, killervehseat=killervehicleseat, killervehname=killervehiclename, killerpos={table.unpack(GetEntityCoords(ped))}})
                        hasBeenDead = true
                        Wait(1000)
                    end
                    checked = false
                end
            elseif not IsPedFatallyInjured(ped) then
                isDead = false
                diedAt = nil
            end
            
            -- check if the player has to respawn in order to trigger an event
            if not hasBeenDead and diedAt ~= nil and diedAt > 0 then
                while not checked do
                    print("WASTED")
                    TriggerServerEvent('cnc:baseevents:onPlayerWasted', { table.unpack(GetEntityCoords(ped)) })
                    hasBeenDead = true
                    Wait(1000)

                end
                checked = false
            elseif hasBeenDead and diedAt ~= nil and diedAt <= 0 then
                hasBeenDead = false
            end
        end
    end
    
    
end)

RegisterNetEvent("cnc:baseevents:onPlayerKilled:checked")
AddEventHandler("cnc:baseevents:onPlayerKilled:checked", function()
    checked = true
end)



