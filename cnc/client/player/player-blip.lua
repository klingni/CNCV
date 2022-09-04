local ServerBossID

Blips = {}


RegisterNetEvent('CNC:StartRound')
AddEventHandler('CNC:StartRound', function(PlayerInfos)

	TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:StartRound', PlayerInfos)

    print('Start Round Blips')
    for _,PlayerInfo in ipairs(PlayerInfos) do
        if PlayerInfo.isBoss == true then
            ServerBossID = PlayerInfo.player
        end
    end
end)


Citizen.CreateThread(function()
	local myPlayer = PlayerId()
	
	while true do
		Wait(100)
		local myPlayerTeam = GetPlayerTeam(myPlayer)

		for _, player in ipairs(GetActivePlayers()) do

			if player ~= myPlayer then
                RemoveBlip(Blips[player])

				local playerPed = GetPlayerPed(player)
				local playerName = GetPlayerName(player)
				local playerServerId = GetPlayerServerId(player)
				local myPlayerServerId = GetPlayerServerId(myPlayer)
				local Color
                local TagColor
                local Team = GetPlayerTeam(player)
                

                if  Team == 1 then		-- CROOK
					Color = Config.CrookColor
					TagColor = Config.CrookTagColor
                elseif Team == 2 then	-- COP
					Color = Config.CopColor
					TagColor = Config.CopTagColor
                elseif Team == 0 then	-- LOBBY
					Color = Config.LobbyColor
					TagColor = Config.LobbyTagColor
                else
                    Color = 52
				end
				
				if myPlayerTeam == 1 then     -- If CurrentPlayer == CROOK
					
					if Team == 1 then      -- If Player == CROOK
						CreatePlayerBlip(player, playerServerId, playerPed,playerName, ServerBossID, Config.BossSprite, Color)

					elseif Team == 2 then  -- If Player == COP
	
						if tonumber(myPlayerServerId) == tonumber(ServerBossID) then
							local xcp, ycp, zcp = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
							local xp, yp, zp = table.unpack(GetEntityCoords(GetPlayerPed(player), false))
							if DistanceBetweenCoords2D(xcp, ycp, xp, yp) < Config.BossViewRange then
                                CreatePlayerBlip(player, playerServerId, playerPed,playerName, ServerBossID, Config.BossSprite, Color)
                            end
                        else
                            GamerTag = CreateFakeMpGamerTag(playerPed, playerName, false, false, '', false)
							SetMpGamerTagColour(GamerTag, 0, TagColor)
							SetMpGamerTagVisibility(GamerTag, 0, HasEntityClearLosToEntity(PlayerPedId(), playerPed, 17))
                        end
					end

				elseif myPlayerTeam == 2 then -- If CurrentPlayer == COP
                    CreatePlayerBlip(player, playerServerId, playerPed,playerName, ServerBossID, Config.BossSprite, Color)
				elseif myPlayerTeam == 0 then -- If CurrentPlayer == LOOBY
					CreatePlayerBlip(player, playerServerId, playerPed,playerName, ServerBossID, Config.BossSprite, Color)
				end
			end
        end
	end
end)

function CreatePlayerBlip(player, playerServerId, playerPed, playerName, serverBossID, bossSprite, color)

	local new_blip = AddBlipForEntity(playerPed)

	if tonumber(playerServerId) == tonumber(serverBossID) then
		SetBlipSprite(new_blip, bossSprite)
	else
		SetBlipSprite(new_blip, 1)
	end
	
	SetBlipNameToPlayerName(new_blip, player)
	SetBlipColour(new_blip, color)
	SetBlipCategory(new_blip, 2)
	SetBlipScale(new_blip, 0.9)
    SetBlipShrink(new_blip, true)
	CreateFakeMpGamerTag(playerPed, playerName, false, false, '', false)

	Blips[player] = new_blip
end