local CopColor = 50
local CrookColor = 64
local LobbyColor = 69
local CopTagColor = 255
local CrookTagColor = 65
local LobbyTagColor = 210
local BossSprite = 119
local BossViewRange = 200.0
local BossID
local playerInfos

local getInfos = false


RegisterNetEvent('CNC:StartRound')
AddEventHandler('CNC:StartRound', function(PlayerInfos)

	TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:StartRound', PlayerInfos)

    playerInfos = PlayerInfos
    print('Start Round Blips')
    for i,PlayerInfo in ipairs(PlayerInfos) do
        if PlayerInfo.isBoss == true then
            BossID = PlayerInfo.player
        end
    end
end)

function GetPlayers()
	local players = {}

	for i = 0, 31 do
		if NetworkIsPlayerActive(i) then
			table.insert(players, i)
		end
	end

	return players
end



Citizen.CreateThread(function()
	local blips = {}
	local currentPlayer = PlayerId()
	
	while true do
		Wait(100)
		local currentPlayerTeam = GetPlayerTeam(currentPlayer)
		local players = GetPlayers()
        

		for player = 0, 25 do
            if player ~= currentPlayer and NetworkIsPlayerActive(player) then



				local playerPed = GetPlayerPed(player)
				local playerName = GetPlayerName(player)
				local playerServerId = GetPlayerServerId(player)
				local currentPlayerServerId = GetPlayerServerId(currentPlayer)
				local Color
                local TagColor
                local Team = GetPlayerTeam(player)
                

                if getInfos then
                    TriggerServerEvent('Debug', '(' .. currentPlayer .. ')-'..'[' .. player .. ']' .. playerName .. ' - Team:'.. Team)	

                end

                
				--print(GetPlayerTeam(1))
                if  Team == 1 then		-- CROOK
					Color = CrookColor
					TagColor = CrookTagColor
                elseif Team == 2 then	-- COP
					Color = CopColor
					TagColor = CopTagColor
                elseif Team == 0 then	-- LOBBY
					Color = LobbyColor
					TagColor = LobbyTagColor
                else
                    Color = 52
				end
				
				if currentPlayerTeam == 1 then     -- If CurrentPlayer == CROOK
					
					if Team == 1 then      -- If Player == CROOK
						RemoveBlip(blips[player])
	
						local new_blip = AddBlipForEntity(playerPed)
	
						-- Add player name to blip
						SetBlipNameToPlayerName(new_blip, player)

						if tonumber(playerServerId) == tonumber(BossID) then
							SetBlipSprite(new_blip, BossSprite)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString("BOSS")
                            EndTextCommandSetBlipName(new_blip)
						else
                            SetBlipSprite(new_blip, 1)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString("Crook")
                            EndTextCommandSetBlipName(new_blip)
						end
	
						-- Make blip white
						SetBlipColour(new_blip, Color)
	
						-- Enable text on blip
						SetBlipCategory(new_blip, 2)
	
						-- Set the blip to shrink when not on the minimap
						Citizen.InvokeNative(0x2B6D467DAB714E8D, new_blip, true)
	
						-- Shrink player blips slightly
                        SetBlipScale(new_blip, 0.9)
	
                        -- Add nametags above head
                        

						gamerTag = Citizen.InvokeNative(0xBFEFE3321A3F5015, playerPed, playerName, false, false, '', false)
						SetMpGamerTagColour(gamerTag, 0, TagColor)
						SetMpGamerTagVisibility(gamerTag, 0, HasEntityClearLosToEntity(PlayerPedId(), playerPed, 17))

	
						-- Record blip so we don't keep recreating it
						blips[player] = new_blip

					elseif Team == 2 then  -- If Player == COP

						RemoveBlip(blips[player])
	
						-- Add nametags above head
						-- Citizen.InvokeNative(0xBFEFE3321A3F5015, playerPed, playerName, false, false, '', false)
						
						if tonumber(currentPlayerServerId) == tonumber(BossID) then
							local xcp, ycp, zcp = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
							local xp, yp, zp = table.unpack(GetEntityCoords(GetPlayerPed(player), false))
							if DistanceBetweenCoords2D(xcp, ycp, xp, yp) < BossViewRange then
								RemoveBlip(blips[player])

								local new_blip = AddBlipForEntity(playerPed)

								-- Add player name to blip
								SetBlipNameToPlayerName(new_blip, player)


								-- Make blip white
								SetBlipColour(new_blip, Color)

								-- Enable text on blip
								SetBlipCategory(new_blip, 2)

								-- Set the blip to shrink when not on the minimap
								Citizen.InvokeNative(0x2B6D467DAB714E8D, new_blip, true)

								-- Shrink player blips slightly
								SetBlipScale(new_blip, 0.9)

                                -- Add nametags above head
                                BeginTextCommandSetBlipName("STRING")
                                AddTextComponentString("Cop")
                                EndTextCommandSetBlipName(new_blip)

								gamerTag = Citizen.InvokeNative(0xBFEFE3321A3F5015, playerPed, playerName, false, false, '', false)
								SetMpGamerTagColour(gamerTag, 0, TagColor)
								SetMpGamerTagVisibility(gamerTag, 0, HasEntityClearLosToEntity(PlayerPedId(), playerPed, 17))


								-- Record blip so we don't keep recreating it
								blips[player] = new_blip
                            end
                            
                        else
                            gamerTag = Citizen.InvokeNative(0xBFEFE3321A3F5015, playerPed, playerName, false, false, '', false)
							SetMpGamerTagColour(gamerTag, 0, TagColor)
							SetMpGamerTagVisibility(gamerTag, 0, HasEntityClearLosToEntity(PlayerPedId(), playerPed, 17))
                        end
                        

					end

				elseif currentPlayerTeam == 2 then -- If CurrentPlayer == COP

					--print('currentTeam: ' .. currentPlayerTeam)
					RemoveBlip(blips[player])

					local new_blip = AddBlipForEntity(playerPed)

					-- Add player name to blip
					SetBlipNameToPlayerName(new_blip, player)

					if tonumber(playerServerId) == tonumber(BossID) then
						SetBlipSprite(new_blip, BossSprite)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString("BOSS")
                        EndTextCommandSetBlipName(new_blip)
					else
                        SetBlipSprite(new_blip, 1)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString("Crook")
                        EndTextCommandSetBlipName(new_blip)
					end

					-- Make blip white
					SetBlipColour(new_blip, Color)

					-- Enable text on blip
					SetBlipCategory(new_blip, 2)

					-- Set the blip to shrink when not on the minimap
					Citizen.InvokeNative(0x2B6D467DAB714E8D, new_blip, true)

					-- Shrink player blips slightly
					SetBlipScale(new_blip, 0.9)

                    -- Add nametags above head
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Cop")
                    EndTextCommandSetBlipName(new_blip)

					gamerTag = Citizen.InvokeNative(0xBFEFE3321A3F5015, playerPed, playerName, false, false, '', false)
					SetMpGamerTagColour(gamerTag, 0, TagColor)
                    SetMpGamerTagVisibility(gamerTag, 0, HasEntityClearLosToEntity(PlayerPedId(), playerPed, 17))


					-- Record blip so we don't keep recreating it
					blips[player] = new_blip

				elseif currentPlayerTeam == 0 then -- If CurrentPlayer == LOOBY
					RemoveBlip(blips[player])

					local new_blip = AddBlipForEntity(playerPed)

					-- Add player name to blip
					SetBlipNameToPlayerName(new_blip, player)

					-- Make blip white
					SetBlipColour(new_blip, Color)

					-- Enable text on blip
					SetBlipCategory(new_blip, 2)

					-- Set the blip to shrink when not on the minimap
					Citizen.InvokeNative(0x2B6D467DAB714E8D, new_blip, true)

					-- Shrink player blips slightly
					SetBlipScale(new_blip, 0.9)

                    -- Add nametags above head
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Lobby")
                    EndTextCommandSetBlipName(new_blip)
					
                    
					gamerTag = Citizen.InvokeNative(0xBFEFE3321A3F5015, playerPed, playerName, false, false, '', false)
					SetMpGamerTagColour(gamerTag, 0, TagColor)
                    SetMpGamerTagVisibility(gamerTag, 0, HasEntityClearLosToEntity(PlayerPedId(), playerPed, 17))

                    
					-- Record blip so we don't keep recreating it
					blips[player] = new_blip

				end
			end
        end
        
        getInfos = false

	end
end)

RegisterNetEvent('CNC:debugBlip')
AddEventHandler('CNC:debugBlip', function()
    
    getInfos = true

    local ID = PlayerId()
    local name = GetPlayerName(ID)
    local team = GetPlayerTeam(ID)
    
    --print('[' .. ID .. ']' .. name .. ' - Team:'.. team)
    TriggerServerEvent('Debug', '[' .. ID .. ']' .. name .. ' - Team:'.. team)	
end)