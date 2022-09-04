local pickupInfos = {}
local isThreadActive = false
local threadCheckAttempts = 0
local visiblePickups = {}




RegisterNetEvent("CNC:clearPickups")
AddEventHandler("CNC:clearPickups", function()
    print('clearPickups Handler')
    ClearPickups()
end)

Citizen.CreateThread(function ( )
    function ClearPickups( )
        -- print('clearPickup')
        while #pickupInfos > 0 do
            Citizen.Wait(0)
            for i,pickupInfo in ipairs(pickupInfos) do
                TriggerEvent('removePickup', pickupInfo)
            end
        end
    end
end)



Citizen.CreateThread(function ( )
    RegisterNetEvent("createPickup")
    AddEventHandler("createPickup", function(pickupInfo)
        -- print('createPickup')
        pickupInfo.spawnedBlip = false
        table.insert( pickupInfos, pickupInfo)
    end)



    RegisterNetEvent("CNC:createMuliiplePickups")
    AddEventHandler("CNC:createMuliiplePickups", function(PickupInfos)
        -- print('CNC:createMuliiplePickups')
        
        -- wait for Pickups are cleaned up
        while #pickupInfos ~= 0 do
            Citizen.Wait(500)
        end
        
        if #pickupInfos == 0 then
            pickupInfos = PickupInfos
            for i,pickupInfo in ipairs(pickupInfos) do
                pickupInfo.spawnedBlip = false
            end
        end
    end)
    



    RegisterNetEvent("removePickup")
    AddEventHandler("removePickup", function(pickupInfo)
        -- print('removePickup Handler')
        for i,pickup in ipairs(pickupInfos) do
            
            if pickup.x == pickupInfo.x and pickup.y == pickupInfo.y and pickup.z == pickupInfo.z then
                table.remove(pickupInfos, i)
                --print("BLIP: " .. pickup.blip)

                while DoesBlipExist(pickup.blip) do
                    Citizen.Wait(1)
                    --print("try to delete Blip")
                    RemoveBlip(pickup.blip)
                end
                --print("BLIP DELETED: " .. pickup.blip)
				TriggerEvent("deletePickup", pickup.pickup)
			end
        end
    end)
    
    
    RegisterNetEvent("deletePickup")
    AddEventHandler("deletePickup", function(pickup)
        -- print('deletePickup Handler')
        DeletePickup(pickup)
    end) 
    

    function DeletePickup( pickup )
        -- print('deletePickup Funktion')       
        while (DoesPickupExist(pickup) == 1 or DoesPickupExist(pickup) == true) do
            Citizen.Wait(1)
            --print('try to delete Pickup')
            SetEntityAsNoLongerNeeded(pickup)
            RemovePickup(pickup)
        end

        -- print('DELATED PICKUP')
        return true
    end

end)

RegisterNetEvent("createLootThread")
AddEventHandler("createLootThread", function()
    CreateLootThread(true)
end)

-- Collect pickups thread
Citizen.CreateThread(function ( )
    while Loaded == true do
        Citizen.Wait(1)

        -- local posX,posY,posZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
        for i, pickupInfo in pairs(pickupInfos) do

            if pickupInfo.spawnedBlip then
                -- DrawLightWithRange(pickupInfo.x, pickupInfo.y, pickupInfo.z - 0.5, 255, 0, 0, 3.0, 50.0)

				if HasPickupBeenCollected(pickupInfo.pickup) --[[ and DistanceBetweenCoords(posX,posY,posZ,pickupInfo.x,pickupInfo.y,pickupInfo.z) < 2.5 ]] then
                    -- print("pickup was collected\n")
                    
                    pickupInfo.spawnedBlip = false
                    TriggerEvent('removePickup', pickupInfo) --Importent to fix delay to Server
                    TriggerServerEvent("CNC:removePickup", pickupInfo, "pickup was collected\n")
					break
				end
			end
		end
    end
end)

local pickupFilter = {}

--Light
Citizen.CreateThread(function()
	while Loaded == true do
		Citizen.Wait(1)
        local playerCoords = GetEntityCoords(PlayerPedId(), true)

        for i, pickupInfo in pairs(pickupFilter) do
            -- if pickupInfo.spawnedBlip then
                -- if #(playerCoords - vector3(pickupInfo.x, pickupInfo.y, pickupInfo.z)) < 200.0 then
                    -- DrawLine(posX,posY,posZ, pickupInfo.x, pickupInfo.y, pickupInfo.z, 255, 255, 255, 255)
                    DrawLightWithRange(pickupInfo.x, pickupInfo.y, pickupInfo.z - 0.5, 255, 0, 0, 3.0, 50.0)
                -- end
            -- end
		end

	end
end)

Citizen.CreateThread(function()
	while Loaded == true do
        Citizen.Wait(5000)
        pickupFilter = {}
        
        local playerCoords = GetEntityCoords(PlayerPedId(), true)

        for i, pickupInfo in pairs(pickupInfos) do
            if pickupInfo.spawnedBlip then
                if #(playerCoords - vector3(pickupInfo.x, pickupInfo.y, pickupInfo.z)) < 200.0 then
                    table.insert( pickupFilter, pickupInfo)
                end
            end
		end

	end
end)


function CreateLootThread( crashed )
    if crashed ~= nil then
        --print("Loot fixed ...")
        --TriggerEvent('CNC:showNotification', "Loot fixed...")
    end
    
    Citizen.CreateThread(function ( )
        while Loaded == true do
            Citizen.Wait(500)
            isThreadActive = true
            local counter = 0
            local posX,posY,posZ = table.unpack(GetEntityCoords(PlayerPedId(), true))

            for i,pickupInfo in ipairs(pickupInfos) do
                if pickupInfo.spawnedBlip == false then
                    local pickup = 0
                    local blip = AddBlipForCoord(pickupInfo.x, pickupInfo.y, pickupInfo.z)
                    SetBlipSprite(blip, pickupInfo.blipSpriteID)
                    SetBlipAsShortRange(blip, true)
                    SetBlipColour(blip, pickupInfo.blipColor)
                    SetBlipScale(blip, 0.8)

                    if (DoesBlipExist(blip) == 1 or DoesBlipExist(blip)== true) then
                        pickupInfos[i].blip = blip
                        pickupInfos[i].spawnedBlip = true
                    end
                end

                local dist = DistanceBetweenCoords2D(posX, posY, pickupInfo.x, pickupInfo.y)

                if dist < 250 and not DoesPickupExist(pickupInfo.pickup) then
                    local pickup = CreatePickupRotate(pickupInfo.pickupName, pickupInfo.x, pickupInfo.y, pickupInfo.z + 1.0, 0.0, 0.0, 0.0, 512, pickupInfo.ammo, 24, 24, true, pickupInfo.pickupName)
                    pickupInfos[i].pickup = pickup

                elseif dist > 250 and DoesPickupExist(pickupInfo.pickup) then
                    RemovePickup(pickupInfo.pickup)
                    pickupInfo.pickup = 0

                end   
             end
        end
    end)
end


Citizen.CreateThread(function()
	while Loaded == true do
		Citizen.Wait(1)
		if isThreadActive then
			threadCheckAttempts = 0
            isThreadActive = false

		else
			threadCheckAttempts = threadCheckAttempts + 1
			if threadCheckAttempts >= 1000 then
				threadCheckAttempts = 0
				TriggerEvent("createLootThread")
			end
		end
	end
end)

Loaded = true
CreateLootThread()