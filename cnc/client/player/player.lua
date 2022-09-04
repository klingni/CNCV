local spawnRadius = 50
local ServerBossID_player
local playerInfos = {}


function GetPlayerInfos()
    return playerInfos
end

RegisterNetEvent('CNC:ClientUpdate')
AddEventHandler('CNC:ClientUpdate', function(PlayerInfos)
    print('CNC:ClientUpdate')
    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:ClientUpdate', PlayerInfos)
    playerInfos = PlayerInfos
    playerInfos = UpdatePlayerPositions(playerInfos)

end)


RegisterNetEvent('CNC:StartRound')
AddEventHandler('CNC:StartRound', function(PlayerInfos)
    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:StartRound', PlayerInfos)
    playerInfos = PlayerInfos
    playerInfos = UpdatePlayerPositions(playerInfos)
end)

RegisterNetEvent('CNC:StopRound')
AddEventHandler('CNC:StopRound', function()
	TriggerEvent('CNC:setTeam')
end)



RegisterNetEvent("CNC:setTeam")
AddEventHandler("CNC:setTeam", function(PlayerInfo)
    --Prüfen ob es eine PlayerInfo gibt, wenn nicht dann Lobby Team (kommt beim login vor)
    if not PlayerInfo then
        NetworkSetVoiceChannel(0)
        SetPlayerTeam(PlayerId(), 0)
        return
    end
    
    print('Team: ' .. tostring(PlayerInfo.team))

    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:setTeam', PlayerInfo.team)

    local teamID = 0

    if PlayerInfo.team == "crook" then
        teamID = 1
    elseif PlayerInfo.team == "cop" then
        teamID = 2
    elseif PlayerInfo.team == "lobby" then
        teamID = 0
    end

    NetworkSetVoiceChannel(teamID)
    SetPlayerTeam(PlayerId(), teamID)
    --TriggerEvent('CNC:showNotification', "Team:" .. GetPlayerTeam(PlayerId()))
end)



RegisterNetEvent("CNC:getTeam")
AddEventHandler("CNC:getTeam", function()
	TriggerEvent('CNC:showNotification', "Team:" .. GetTeam())
end)

function GetTeam()
	return GetPlayerTeam(PlayerId())
end


RegisterNetEvent("CNC:killPlayer")
AddEventHandler("CNC:killPlayer", function(PlayerSetting)
    --TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:killPlayer', PlayerSetting)
    SetEntityHealth(PlayerPedId(), 1)
end)

RegisterNetEvent("CNC:wakeup")
AddEventHandler("CNC:wakeup", function(PlayerSetting)
    --TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:killPlayer', PlayerSetting)
    SetEntityHealth(PlayerPedId(), 100)
end)


AddEventHandler('playerSpawned', function(spawn)
    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - playerSpawned', spawn)
    if isRoundOngoing then
        --Citizen.Wait(5000)
        --TriggerServerEvent('CNC:Respawn')
	else
		TriggerEvent('CNC:setTeam')
		print('Player spawned Trigger')
	end
end)




RegisterNetEvent("CNC:getPos")
AddEventHandler("CNC:getPos", function()
    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:getPos')

    local px, py, pz = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local coord = {x = px, y=py, z=pz}
    print("getPlayerPosition - X: " .. px .. " / Y: " .. py .. " / Z: " .. pz)
end)


-- Citizen.CreateThread(function ( )
--     while true do
--         Citizen.Wait(1000)
--         local px, py, pz = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
--         coord = {x = px, y=py, z=pz}

--         TriggerServerEvent('CNC:sendPlayerCoord', coord)
--     end
-- end)


Citizen.CreateThread(function (  )
    while true do
    Citizen.Wait(100)
    	if GetPlayerWantedLevel(PlayerId()) ~= 0 then
			SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
            SetEveryoneIgnorePlayer(PlayerId(), true)
        end
        ResetPlayerStamina(PlayerId())
    end
end)


function PlayerStartNotification(playerInfo)
    local option = {}

        if playerInfo.team == 'cop' then
            option = {
                layout = 'bottomCenter',
                type = 'cop',
                text = 'You are a cop, stop the boss from getting into the getaway vehicle.',
                theme = 'cnc'
            }
        elseif playerInfo.team == 'crook' then
            if playerInfo.isBoss then
                option = {
                    layout = 'bottomCenter',
                    type = 'crook',
                    text = 'You are the boss 👑, try to reach the getaway vehicle.',
                    theme = 'cnc'
                }
            else
                option = {
                    layout = 'bottomCenter',
                    type = 'crook',
                    text = 'You are a crook, help the boss get into the getaway vehicle.',
                    theme = 'cnc'
                }   
            end

        end
        TriggerEvent('pNotify:SendNotification',option)
end


RegisterNetEvent("CNC:newSpawnPlayer")
AddEventHandler("CNC:newSpawnPlayer", function(coord, PlayerSetting, firstSpawn,  playerInfo)


    -- SET TEAM
    TriggerEvent('CNC:setTeam', playerInfo)

    print("Spawn Player")
    
    if coord then
        print("FirstSpawn")
        exports.spawnmanager:spawnPlayer({
            x = coord.x,
            y = coord.y,
            z = coord.z,
            heading = 0,
            model = PlayerSetting['model'],
            skipFade = false
        }, function(spawn)
            TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - FirstSpawn', spawn)
            PlayerStartNotification(playerInfo)
            SetWeapons(PlayerSetting)
    
        end)

    elseif not coord then
        coord = GetSpawnCoords(playerInfo, playerInfos)

        spawnRadius = 150
        local spawnX = coord.x
        local spawnY = coord.y
        local spawnZ = 0
    
        
        local i = 0
        local j = 0
        local k = 0
    
        FreezeEntityPosition(GetPlayerPed(PlayerId()), true)
        SetEntityCoords(GetPlayerPed(PlayerId()), coord.x, coord.y, coord.z + 100, 1, 0, 0, 1)
        
        repeat
            i = i + 1
            if i > 100 then
                spawnRadius = spawnRadius + 100
                i = 0
    
            end
    
            
            repeat
                
                Citizen.Wait(1)
                spawnX = coord.x + math.random(-spawnRadius, spawnRadius)
                spawnY = coord.y + math.random(-spawnRadius, spawnRadius)
                
                _,spawnZ = GetGroundZFor_3dCoord(spawnX+.0, spawnY+.0, 99999.0, 1)
                
                -- TriggerServerEvent('Debug', 'spawnX:' .. spawnX .. ' spawnY:' .. spawnY .. ' spawnZ:' .. spawnZ)
    
            until spawnZ ~= 0
    
            --j = 0
    
            -- NEU START
            if GetWaterHeight(spawnX, spawnY, spawnZ) then
                k = k + 1
                if k > 50 then
                    i = 100
                    k = 0
                end
            end
            -- NEU ENDE
    
        until not GetWaterHeight(spawnX, spawnY, spawnZ)
    
        spawnZ = spawnZ + 0.2
    
        local spawn = {
            x = spawnX,
            y = spawnY,
            z = spawnZ,
            heading = 0,
            model = PlayerSetting['model'],
            skipFade = false
        }
    
        exports.spawnmanager:spawnPlayer(spawn,
            function(spawn)
            SetWeapons(PlayerSetting)
        end)
    end
end)


function SetWeapons(PlayerSetting)
    -- TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - setWeapons', PlayerSetting['weapons'])
    for k,v in pairs(PlayerSetting['weapons']) do
        GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(v['type']), v['ammo'],true, v['equipt'])
        Citizen.Wait(100)
    end
end

function UpdatePlayerPositions(PlInfos)
    for i, PlInfo in ipairs(PlInfos) do
        local localPlayerID = GetPlayerFromServerId(tonumber(PlInfo.player))
            
        local px, py, pz = table.unpack(GetEntityCoords(GetPlayerPed(tonumber(localPlayerID))))

        -- print("Player " .. PlInfo.player .."(PAD:".. GetPlayerPed(localPlayerID) .. " - LocalPlayerID:" .. localPlayerID .. ") ..- X:" .. px .. " Y:" .. py .. " Z:" .. pz)
        PlInfos[i].coord.x = px
        PlInfos[i].coord.y = py
        PlInfos[i].coord.z = pz
    end

    return PlInfos

end

function GetSpawnCoords(PlayerInfo, PlayerInfos)
      -- TriggerEvent('Debug', 'CNC:Server:player:respawnPlayer')
      local coord
      TriggerServerEvent("Log", "respawnPlayer", PlayerInfo)
      TriggerEvent("Log", "respawnPlayer - frisch geholte Player Settings", PlayerSetting)

      playerInfos = UpdatePlayerPositions(playerInfos)
      
      if PlayerInfo.team == "crook" then -- Respawn Crooks in the near of the Boss
        --   print("Respawn Player crook")
        --   print("ServerBossID: " .. ServerBossID_player)

          local localBossID = GetPlayerFromServerId(tonumber(ServerBossID_player))
          
          local bx, by, bz = table.unpack(GetEntityCoords(GetPlayerPed(tonumber(localBossID))))

        --   print("BossCoord - X:" .. bx .. " Y:" .. by .. " Z:".. bz)
          
          coord = {
              x = bx,
              y = by,
              z = bz
          }
          
      elseif PlayerInfo.team == "cop" then -- Respawn Cops average all Cops
          print("Respawn Player cop")

          local CopXPos = {}
          local CopYPos = {}
          local count = 0

          for i, PlInfo in ipairs(PlayerInfos) do
              if tonumber(PlInfo.player) ~= tonumber(PlayerInfo.player) and PlInfo.team == "cop" then
                  count = count + 1
                  local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(PlInfo.player), false))
                  table.insert(CopXPos, PlInfo.coord.x)
                  table.insert(CopYPos, PlInfo.coord.y)
              end
          end

          if count > 0 then
              print("Other Cops")
              coord = {
                  x = Average(CopXPos),
                  y = Average(CopYPos),
                  z = 0.0
              }
          else
              print("no Cops")
              
              local localBossID = GetPlayerFromServerId(tonumber(ServerBossID_player))
              local bx, by, bz = table.unpack(GetEntityCoords(GetPlayerPed(tonumber(localBossID))))
              
              coord = {
                  x = bx,
                  y = by,
                  z = bz
              }

          end
      end

      return coord
end


RegisterNetEvent('CNC:StartRound')
AddEventHandler('CNC:StartRound', function(PlayerInfos)

    for i,PlayerInfo in ipairs(PlayerInfos) do
        if PlayerInfo.isBoss == true then
            ServerBossID_player = PlayerInfo.player
        end
    end
end)