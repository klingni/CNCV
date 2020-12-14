

AddEventHandler('onClientMapStart', function()

    print('MAP START')
    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:spawnPlayer({
        x = -764.7618,
        y = 153.4494,
        z = 67.4746,
        heading = 0,
        model = 'a_m_y_hipster_02',
        skipFade = false
    })
    -- exports.spawnmanager:forceRespawn()



     NetworkSetFriendlyFireOption(true)
     NetworkSetTeamOnlyChat(true)
   
end)

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' has been started on the client.')
    --exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:spawnPlayer({
        x = -764.7618,
        y = 153.4494,
        z = 67.4746,
        heading = 0,
        model = 'a_m_y_hipster_02',
        skipFade = false
    }, function(spawn)

    end)
   -- exports.spawnmanager:forceRespawn()

     NetworkSetFriendlyFireOption(true)
     NetworkSetTeamOnlyChat(true)
    TriggerServerEvent('CNC:Map:startInit')

    TriggerEvent('CNC:createMarker')

end)


local bool = false
local score = {}

local diameter = 10.0

local x1, y1, z1 = -772.94 ,146.69 ,66.47
local x2, y2, z2 = -773.03 ,160.18 ,66.47



RegisterNetEvent("CNC:createMarker")
AddEventHandler("CNC:createMarker", function()

    TriggerServerEvent('Debug', 'CREATE MARKER')
  print('createMarker')
  local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))

  Citizen.CreateThread(function ()
    
    while true do
      Citizen.Wait(0)
      DrawMarker(1, x2, y2 ,z2 ,0,0,0,0,0,0,diameter,diameter,1.0,179,0,179,200,0,0,0,0)
      DrawMarker(11, x2, 168.4 ,z2+0.5 ,0,0,0,0,0,0,2.0,2.0,2.0,179,0,179,200,0,0,0,0)

      DrawMarker(1, x1, y1 ,z1 ,0,0,0,0,0,0,diameter,diameter,1.0,255,153,0,200,0,0,0,0)
      DrawMarker(12, x1, 137.1 ,z1+0.5 ,0,1.0,0,0,0,0,2.0,2.0,2.0,255,153,0,200,0,0,0,0)

    end
  end)

end)

RegisterNetEvent("CNC:getSelectedTeam")
AddEventHandler("CNC:getSelectedTeam", function()

    -- TriggerServerEvent('Debug', 'CNC:Client:Client:getSelectedTeam')

  local xp, yp, zp = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))

  if DistanceBetweenCoords2D(x1, y1, xp, yp) < diameter / 2  then
    TriggerEvent('CNC:showNotification', 'CROOK')
    TriggerServerEvent('CNC:registerTeam', 'crook')

  elseif DistanceBetweenCoords2D(x2, y2, xp, yp) < diameter / 2  then
    TriggerEvent('CNC:showNotification', 'COP')
    TriggerServerEvent('CNC:registerTeam', 'cop')
  else
    TriggerEvent('CNC:showNotification', 'LOBBY')
    TriggerServerEvent('CNC:registerTeam', 'lobby')
  end

end)

RegisterNetEvent("CNC:updateScore")
AddEventHandler("CNC:updateScore", function(newScore)
  score = newScore
end)


RegisterNetEvent("CNC:StartRound")
AddEventHandler("CNC:StartRound", function()
    exports.spawnmanager:setAutoSpawn(false)
end)


RegisterNetEvent("CNC:StopRound")
AddEventHandler("CNC:StopRound", function()
    exports.spawnmanager:setAutoSpawn(true)
end)



RegisterNetEvent("CNC:cleanAll")
AddEventHandler("CNC:cleanAll", function()
    -- TriggerServerEvent('Debug', 'CNC:Client:Client:clearAll')

    print("START clean Map")

    Citizen.InvokeNative(0x957838AAF91BD12D, 0, 0, 0, 10000.0, false, false, false, false)

    players = GetPlayersNetworkID()
    ids = {}

    for i=1,999 do
        table.insert( ids, i )
    end

    for i= #ids, 1, -1 do 
        for j,player in ipairs(players) do
            if i == tonumber(player) then
                table.remove( ids, i )
            end
        end
    end

    Citizen.CreateThread(function (  )
        for i,id in ipairs(ids) do
            if NetworkDoesNetworkIdExist(id) then        
                DeleteEntity(NetworkGetEntityFromNetworkId(id))
            end
        end
    end)
    print("STOP clean Map")
end)


function GetPlayersNetworkID()
    -- TriggerServerEvent('Debug', 'CNC:Client:Client:getPlayersNetworkID')
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            --print(i .. ":")
            table.insert(players, NetworkGetNetworkIdFromEntity(GetPlayerPed(i)))
        end
    end
    return players
end

local trafficDensity = 1.0
local pedDensity = 1.0


Citizen.CreateThread(function()

    -- Do this every tick.
    while true do
        Citizen.Wait(0) -- these things NEED to run every tick.
        
        -- Traffic and ped density management
        SetTrafficDensity(trafficDensity)
        SetPedDensity(pedDensity)
        SetPlayerWeaponDamageModifier( PlayerId() , 0.5)
        --SetPlayerVehicleDamageModifier( PlayerId(), 1000.0)
        --SetPlayerVehicleDefenseModifier(PlayerId(), 1000.0)
        
    end
end)

RegisterNetEvent("CNC:setDensity")
AddEventHandler("CNC:setDensity", function(PedDensity, TrafficDensity)
    trafficDensity = TrafficDensity
    pedDensity = PedDensity
    print('SetDensity: Ped:'..tostring(PedDensity) .. ' - Traffic:'.. tostring(TrafficDensity))
end)

function SetPedDensity(density)
    SetPedDensityMultiplierThisFrame(density)
    SetScenarioPedDensityMultiplierThisFrame(density, density)
end

function SetTrafficDensity(density)
    SetParkedVehicleDensityMultiplierThisFrame(density)
    SetVehicleDensityMultiplierThisFrame(density)
    SetRandomVehicleDensityMultiplierThisFrame(density)
end
