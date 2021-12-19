-- local CopColor = 50
-- local CrookColor = 64
-- local LobbyColor = 69
-- local BossSprite = 119
-- local BossViewRange = 200.0
-- local playerInfos
-- Blips = {}


-- RegisterNetEvent('CNC:StartRound')
-- AddEventHandler('CNC:StartRound', function(PlayerInfos)
--     playerInfos = PlayerInfos
-- 	--createPlayerBlips()
-- end)


-- RegisterNetEvent('CNC:createPlayerBlip')
-- AddEventHandler('CNC:createPlayerBlip', function()
-- 	CreatePlayerBlips()
-- end)


-- function CreatePlayerBlips()
-- 	-- local blips = {}
-- 	local currentPlayer = GetPlayerServerId(PlayerId())
-- 	local currentPlayerTeam = GetPlayerCNCTeam(currentPlayer)
-- 	local BossID = GetPlayerBossId()


-- 	for i,playerInfo in ipairs(playerInfos) do
-- 		if tonumber(playerInfo.player) ~= tonumber(currentPlayer) --[[ and NetworkIsPlayerActive(player) ]] then

-- 			local player = GetPlayerFromServerId(tonumber(playerInfo.player))
-- 			local playerPed = GetPlayerPed(player)
-- 			local playerName = playerInfo.playerName
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
-- 					CreatePlayerBlip(player, playerServerId, playerPed, playerName, BossID, BossSprite, Color)



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
-- 							CreatePlayerBlip(player, playerServerId, playerPed,playerName, BossID, BossSprite, Color)
-- 						end
-- 					end
-- 				end


-- 			elseif playerInfo.team == 'cop' then

-- 				CreatePlayerBlip(player, playerServerId, playerPed,playerName, BossID, BossSprite, Color)
			
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


-- function CreatePlayerBlip(player, playerServerId, playerPed,playerName, BossID, BossSprite, Color)

-- 	local new_blip = AddBlipForEntity(playerPed)

-- 	if tonumber(playerServerId) == tonumber(BossID) then
-- 		SetBlipSprite(new_blip, BossSprite)
-- 	else
-- 		SetBlipSprite(new_blip, 1)
-- 	end
	
-- 	SetBlipNameToPlayerName(new_blip, player)
-- 	SetBlipColour(new_blip, Color)
-- 	SetBlipCategory(new_blip, 2)
-- 	SetBlipScale(new_blip, 0.9)

-- 	-- Set the blip to shrink when not on the minimap
-- 	Citizen.InvokeNative(0x2B6D467DAB714E8D, new_blip, true)
-- 	-- Add nametags above head
-- 	Citizen.InvokeNative(0xBFEFE3321A3F5015, playerPed, playerName, false, false, '', false)

-- 	Blips[player] = new_blip
-- end