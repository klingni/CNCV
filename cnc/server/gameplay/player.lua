local locmap

RegisterNetEvent("cnc:baseevents:onPlayerWasted")
RegisterNetEvent("cnc:baseevents:onPlayerDied")
RegisterNetEvent("cnc:baseevents:onPlayerKilled")

-- Citizen.CreateThread(function()
        AddEventHandler("cnc:baseevents:onPlayerKilled", function(killerId)
                TriggerClientEvent("cnc:baseevents:onPlayerKilled:checked", source)
                if killerId ~= -1 then
                    print(GetPlayerName(source) .. " killed by " .. GetPlayerName(killerId))
                end
                -- TriggerEvent("CNC:Server:PlayerDiedV2", "killed", killerId)
                PlayerDiedV2("killed", killerId)
            end)

        AddEventHandler("cnc:baseevents:onPlayerWasted", function()
            TriggerClientEvent("cnc:baseevents:onPlayerKilled:checked", source)

                print(GetPlayerName(source).." wasted")
                -- TriggerEvent("CNC:Server:PlayerDiedV2", "died")
                PlayerDiedV2("died")
            end)

        AddEventHandler("cnc:baseevents:onPlayerDied", function()
            TriggerClientEvent("cnc:baseevents:onPlayerKilled:checked", source)

                print(GetPlayerName(source).." died")
                -- TriggerEvent("CNC:Server:PlayerDiedV2", "died")
                PlayerDiedV2("died")
            end)
--     end
-- )

RegisterNetEvent("CNC:Respawn")
AddEventHandler("CNC:Respawn", function()
        for i, PlayerInfo in ipairs(PlayerInfos) do
            if tonumber(PlayerInfo.player) == tonumber(source) then
                respawnPlayer(PlayerInfo)
                break
            end
        end
    end
)

function spawnPlayers(map)
    -- TriggerEvent('Debug', 'CNC:Server:player:spawnPlayers')

    print("spawn Players")
    locmap = map
    for i, PlayerInfo in ipairs(PlayerInfos) do
        if PlayerInfo.team ~= "lobby" then
            spawnPlayer(PlayerInfo)
        end
    end
end


function spawnPlayer(PlayerInfo)
    -- TriggerEvent('Debug', 'CNC:Server:player:spawnPlayer')
    local coord
    TriggerEvent("Log", "spawnPlayer", PlayerInfo)

    print("PlayerInfoTeam:" .. PlayerInfo.team)

    if PlayerInfo.isBoss == true then
        PlayerSetting = getPlayerSettings("boss")
        print(PlayerInfo.playerName .. " is Boss")
    else
        PlayerSetting = getPlayerSettings(PlayerInfo.team)
    end

    rnd = math.random(1, #locmap[PlayerInfo.team]["spawnpoints"])
    coord = locmap[PlayerInfo.team]["spawnpoints"][rnd]

    TriggerClientEvent("CNC:newSpawnPlayer", PlayerInfo.player, coord, PlayerSetting, PlayerInfo)
end


function respawnPlayer(PlayerInfo)
    if DoesRoundIsGoingOn() then

        PlayerSetting = getPlayerSettings(PlayerInfo.team)

        Citizen.Wait(3000)
        TriggerClientEvent("CNC:newSpawnPlayer", PlayerInfo.player, nil, PlayerSetting, PlayerInfo)
    end
end


function showPlayers()
    local ListAllPlayer = GetPlayers()
    for i, PlayerInfo in ipairs(ListAllPlayer) do
        print("ID: " .. PlayerInfo .. " / Name: " .. GetPlayerName(PlayerInfo))
    end
end

RegisterNetEvent("playerDropped")
AddEventHandler("playerDropped", function()
    -- TriggerEvent('Debug', 'CNC:Server:player:playerDropped')
    
        local droppedPlayerID = tonumber(source)
        
        if droppedPlayerID == tonumber(BossID) then
            TriggerClientEvent(
                "CNC:showNotification", -1, "BOSS(" .. GetPlayerName(droppedPlayerID) .. ") disconnected!")
            copsWinsTheRound()
        else
            TriggerClientEvent("CNC:showNotification", -1, GetPlayerName(droppedPlayerID) .. " disconnected!")
            Citizen.Wait(5000)
        end
        
        -- remove Player to PlayerInfos-List
        for i, PlayerInfo in ipairs(PlayerInfos) do
            if tonumber(PlayerInfo.player) == droppedPlayerID then
                print("Remove Player: " .. PlayerInfo.player)
                table.remove(PlayerInfos, i)
            end
        end
        
        if isRoundOngoing then
            local copCount = 0
            for i, PlayerInfo in ipairs(PlayerInfos) do
                if PlayerInfo.team == "cop" then
                    copCount = copCount + 1
                end
            end
            
            if copCount == 0 then
                TriggerClientEvent("CNC:showNotification", -1, "All the cops have been suspended. The game ends.")
                StopGame(true)
            end
        end
        
        TriggerClientEvent("CNC:ClientUpdate", -1, PlayerInfos)
        TriggerEvent('chat:updatePlayerInfos', PlayerInfos)
    end
)

function PlayerDiedV2(killtype, killerid)
    local victim
    local killer = nil

    if isRoundOngoing then

        print('SOURCE: ' .. source)

    
        for i, PlayerInfo in ipairs(PlayerInfos) do
            if tonumber(source) == tonumber(PlayerInfo.player) then
                victim = PlayerInfo
            elseif tonumber(killerid) == tonumber(PlayerInfo.player) then
                killer = PlayerInfo
            end
        end
        
        if killtype == "killed" then
            PlayerKilled(victim, killer)
        elseif killtype == "died" then
            PlayerSuicide(victim)
        end
        
        if tonumber(source) == tonumber(BossID) then -- If Boss died
            TriggerClientEvent("CNC:showNotification", -1, "~r~ ~h~Boss died!")
            TriggerEvent("CNC:addPoints", "cop", 1000)
            copsWinsTheRound()
        else
            respawnPlayer(victim)
            Citizen.Wait(5000)
        end
    end
end


function PlayerKilled(victim, killer)
    if killer ~= nil then
        -- getötet durch Spieler
        print('Killer-Team: ' .. killer.team)
        print('Victim-Team: ' .. victim.team)
        
        TriggerEvent("CNC:addPoints", killer.team, 100) -- Killer-Team bekommt 100 Punkte
    else
        -- getötet durch Pad
        TriggerEvent("CNC:addPoints", victim.team, -100) -- Opfer-Team bekommt -100 Punkte
    end
    TriggerClientEvent("CNC:showNotification", -1, getColoredPlayerName(victim) .. " has been murdered by " .. getColoredPlayerName(killer) .. "!")
    
end


function PlayerSuicide(victim)
    --Selbstmord
    TriggerEvent("CNC:addPoints", victim.team, -100) -- Selbstmörder-Team bekommt -100 Punkte
    TriggerClientEvent("CNC:showNotification", -1, getColoredPlayerName(victim) .. " committed suicide!")
end


function getColoredPlayerName(playerInfo)
    if playerInfo.team == "cop" then
        return "~p~" .. playerInfo.playerName .. "~s~"
    elseif playerInfo.team == "crook" then
        return "~o~" .. playerInfo.playerName .. "~s~"
    end
end