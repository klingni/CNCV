-- local CopColor = 50
-- local CrookColor = 64
-- local LobbyColor = 69
-- local BossSprite = 119
-- local BossViewRange = 200.0
-- local playerInfos
-- local blips = {}


-- RegisterNetEvent('CNC:StartRound')
-- AddEventHandler('CNC:StartRound', function(PlayerInfos)
--     playerInfos = PlayerInfos
-- 	--createPlayerBlips()	
-- end)


-- RegisterNetEvent('CNC:createPlayerBlip')
-- AddEventHandler('CNC:createPlayerBlip', function()
-- 	createPlayerBlips()
-- end)


-- function createPlayerBlips()	
-- 	local blips = {}
-- 	local currentPlayer = GetPlayerServerId(PlayerId())
-- 	local currentPlayerTeam = GetPlayerCNCTeam(currentPlayer)
-- 	local BossID = GetPlayerBossId()


-- 	for i,playerInfo in ipairs(playerInfos) do
-- 		if tonumber(playerInfo.player) ~= tonumber(currentPlayer) --[[ and NetworkIsPlayerActive(player) ]] then

-- 			local player = GetPlayerFromServerId(tonumber(playerInfo.player))
-- 			local playerPed = GetPlayerPed(player)
-- 			local playerName = GetPlayerName(player)
-- 			local playerServerId = playerInfo.player
-- 			local Color
			
-- 			if  playerInfo.team == 'crook' then		-- CROOK
-- 				Color = CrookColor
-- 			elseif playerInfo.team == 'cop' then	-- COP
-- 				Color = CopColor
-- 			elseif playerInfo.team == 'lobby' then	-- LOBBY
-- 				Color = LobbyColor
-- 			else
-- 				Color = 52
-- 			end
			
-- 			if currentPlayerTeam == 'crook' then
				
-- 				if playerInfo.team == 'crook' then  -- If Player == Crook
-- 					--RemoveBlip(blips[player])

-- 					local new_blip = AddBlipForEntity(playerPed)
					
-- 					SetBlipNameToPlayerName(new_blip, player)

-- 					BeginTextCommandSetBlipName("STRING")
-- 					AddTextComponentSubstringBlipName("irgendwas")
					
-- 					EndTextCommandSetBlipName(new_blip)

-- 					if tonumber(playerServerId) == tonumber(BossID) then
-- 						SetBlipSprite(new_blip, BossSprite)
-- 					else
-- 						SetBlipSprite(new_blip, 1)
-- 					end

-- 					SetBlipColour(new_blip, Color)

-- 					-- Enable text on blip
-- 					SetBlipCategory(new_blip, 2)

-- 					-- Set the blip to shrink when not on the minimap
-- 					Citizen.InvokeNative(0x2B6D467DAB714E8D, new_blip, true)

-- 					-- Shrink player blips slightly
-- 					SetBlipScale(new_blip, 0.9)

-- 					-- Add nametags above head
-- 					Citizen.InvokeNative(0xBFEFE3321A3F5015, playerPed, playerName, false, false, '', false)



-- 					-- Record blip so we don't keep recreating it
-- 					blips[player] = new_blip

-- 				elseif playerInfo.team == 'cop' then -- If Player == Cop

-- 					print('crook - cop')

-- 					--RemoveBlip(blips[player])

-- 					-- Add nametags above head
-- 					Citizen.InvokeNative(0xBFEFE3321A3F5015, playerPed, playerName, false, false, '', false)
					
-- 					if tonumber(currentPlayer) == tonumber(BossID) then
-- 						local xcp, ycp, zcp = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
-- 						local xp, yp, zp = table.unpack(GetEntityCoords(GetPlayerPed(player), false))
-- 						if DistanceBetweenCoords2D(xcp, ycp, xp, yp) < BossViewRange then
-- 							--RemoveBlip(blips[player])

-- 							local new_blip = AddBlipForEntity(playerPed)

-- 							-- Add player name to blip
-- 							SetBlipNameToPlayerName(new_blip, player)


-- 							-- Make blip white
-- 							SetBlipColour(new_blip, Color)

-- 							-- Enable text on blip
-- 							SetBlipCategory(new_blip, 2)

-- 							-- Set the blip to shrink when not on the minimap
-- 							Citizen.InvokeNative(0x2B6D467DAB714E8D, new_blip, true)

-- 							-- Shrink player blips slightly
-- 							SetBlipScale(new_blip, 0.9)

-- 							-- Add nametags above head
-- 							Citizen.InvokeNative(0xBFEFE3321A3F5015, playerPed, playerName, false, false, '', false)

-- 							-- Record blip so we don't keep recreating it
-- 							blips[player] = new_blip
-- 						end
-- 					end
-- 				end

							

-- 			elseif playerInfo.team == 'cop' then

-- 				--print('currentTeam: ' .. currentPlayerTeam)
-- 				--RemoveBlip(blips[player])

-- 				local new_blip = AddBlipForEntity(playerPed)

-- 				-- Add player name to blip
-- 				SetBlipNameToPlayerName(new_blip, player)

-- 				if tonumber(playerServerId) == tonumber(BossID) then
-- 					SetBlipSprite(new_blip, BossSprite)
-- 				else
-- 					SetBlipSprite(new_blip, 1)
-- 				end

-- 				-- Make blip white
-- 				SetBlipColour(new_blip, Color)

-- 				-- Enable text on blip
-- 				SetBlipCategory(new_blip, 2)

-- 				-- Set the blip to shrink when not on the minimap
-- 				Citizen.InvokeNative(0x2B6D467DAB714E8D, new_blip, true)

-- 				-- Shrink player blips slightly
-- 				SetBlipScale(new_blip, 0.9)

-- 				-- Add nametags above head
-- 				Citizen.InvokeNative(0xBFEFE3321A3F5015, playerPed, playerName, false, false, '', false)

-- 				-- Record blip so we don't keep recreating it
-- 				blips[player] = new_blip

-- 			end
-- 		end
-- 	end
-- end

-- function GetPlayerCNCTeam( playerServerId )
-- 	for i,playerInfo in ipairs(playerInfos) do
-- 		if tonumber(playerInfo.player) == tonumber(playerServerId) then
-- 			return playerInfo.team
-- 		end
-- 	end
-- end

-- function GetPlayerBossId( )
-- 	for i,PlayerInfo in ipairs(playerInfos) do
-- 		if PlayerInfo.isBoss == true then
-- 			print('BossID:' .. PlayerInfo.player)
--             return PlayerInfo.player
--         end
-- 	end
-- end