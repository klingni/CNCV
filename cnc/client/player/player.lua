local isRoundGoingOn
local spawnRadius = 50
playerInfos = {}


RegisterNetEvent('CNC:ClientUpdate')
AddEventHandler('CNC:ClientUpdate', function(PlayerInfos)
    print('CNC:ClientUpdate')
    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:ClientUpdate', PlayerInfos)
    playerInfos = PlayerInfos
end)


RegisterNetEvent('CNC:StartRound')
AddEventHandler('CNC:StartRound', function(PlayerInfos)
    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:StartRound', PlayerInfos)

    isRoundGoingOn = true
    playerInfos = PlayerInfos
end)

RegisterNetEvent('CNC:StopRound')
AddEventHandler('CNC:StopRound', function()
	isRoundGoingOn = false
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
	--TriggerEvent('CNC:showNotification', "Team:" .. getTeam())
end)

function getTeam()
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
    if isRoundGoingOn then
        --Citizen.Wait(5000)
        --TriggerServerEvent('CNC:Respawn')
	else
		TriggerEvent('CNC:setTeam')
		print('Player spawned Trigger')
	end
end)



RegisterNetEvent("CNC:getPlayerPosition")
AddEventHandler("CNC:getPlayerPosition", function()
    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:getPlayerPosition')

    local px, py, pz = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    coord = {x = px, y=py, z=pz}
    print("getPlayerPosition - X: " .. px .. " / Y: " .. py)

    TriggerServerEvent('CNC:sendPlayerCoord', coord)
end)


RegisterNetEvent("CNC:getPos")
AddEventHandler("CNC:getPos", function()
    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:getPos')

    local px, py, pz = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    coord = {x = px, y=py, z=pz}
    print("getPlayerPosition - X: " .. px .. " / Y: " .. py .. " / Z: " .. pz)
end)


Citizen.CreateThread(function ( )
    while true do
        Citizen.Wait(1000)
        local px, py, pz = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
        coord = {x = px, y=py, z=pz}

        TriggerServerEvent('CNC:sendPlayerCoord', coord)
    end
end)


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


function playerStartNotification(playerInfo)
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
AddEventHandler("CNC:newSpawnPlayer", function(coord, PlayerSetting, firstSpawn, playerInfo)
    -- SET TEAM
    TriggerEvent('CNC:setTeam', playerInfo)


    -- SPAWN ON POSSITION

    if firstSpawn then
    
        print("FiestSpawn")

        exports.spawnmanager:spawnPlayer({
            x = coord.x,
            y = coord.y,
            z = coord.z,
            heading = 0,
            model = PlayerSetting['model'],
            skipFade = false
        }, function(spawn)
            TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - FirstSpawn', spawn)
            playerStartNotification(playerInfo)
            setWeapons(PlayerSetting)

        end)
        

    else
        spawnRadius = 150
        spawnX = coord.xw
        spawnY = coord.y
        spawnZ = 0

        
        i = 0
        j = 0
        k = 0

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
                
                TriggerServerEvent('Debug', 'spawnX:' .. spawnX .. ' spawnY:' .. spawnY .. ' spawnZ:' .. spawnZ)

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

        spawn = {
            x = spawnX,
            y = spawnY,
            z = spawnZ,
            heading = 0,
            model = PlayerSetting['model'],
            skipFade = false
        }
    
        exports.spawnmanager:spawnPlayer(spawn,
            function(spawn)
            setWeapons(PlayerSetting)
        end)


    end
 


end)


function setWeapons(PlayerSetting)
    -- TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - setWeapons', PlayerSetting['weapons'])
    for k,v in pairs(PlayerSetting['weapons']) do
        GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(v['type']), v['ammo'],true, v['equipt'])
        Citizen.Wait(100)
    end
end

