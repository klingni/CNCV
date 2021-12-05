IsRoundOngoing  = false
BossID = 0
IsBossInGetaway = false
PlayerInfos ={}

Getaway = {}
IsGetawayDriveable = true
Net_Getaway = 0
Net_Spawner = {}
Net_Vehicles = {}

local RoundCounter = 0
local RoundsToPlay = 2
local countPlayerResponse = 0
local mapFolder = GetResourcePath(GetCurrentResourceName()) .. "/../cnc-map/"
local settingsFolder = GetResourcePath(GetCurrentResourceName()) .. "/Settings/"

local ChoosenMap
local map ={}
local CopHint = false
local RndTeam = false
local TrafficDensity = 0.5
local PedDensity = 0.5

local countdownStartNextRound = 10
local countdownBossInGetway = 40
local DEBUG_MODE = false


function GetPlayerInfos( )
    return PlayerInfos
end


function ResetVars()
    IsRoundOngoing  = false
    BossID = 0
    IsBossInGetaway = false
    PlayerInfos ={}

    Getaway = {}
    Net_Getaway = 0
    Net_Spawner = {}
    Net_Vehicles = {}
    RoundCounter = 0
    countPlayerResponse = 0
    map ={}
end


function GetBossInfo( )
    for i,playerInfo in ipairs(PlayerInfos) do
        if playerInfo.player == BossID then
            return playerInfo
        end
    end
    --return BossInfo
end


function DoesRoundIsGoingOn( )
    return IsRoundOngoing
end


function GetGlobalMapSettings()
    File = io.open(mapFolder .. "GlobalMap.json", "r")
    local content = File:read("*a")
    File:close()
    local testObj, pos, testErro = json.decode(content)
    return testObj
end


function GetPlayerSettings(team)
    TriggerEvent('Log', 'getPlayerSettings', team)

    File = io.open(settingsFolder .. "Player.json", "r")
    local content = File:read("*a")
    File:close()
    local testObj, pos, testErro = json.decode(content)
    return testObj[team]
end


function GetMap( id )
    TriggerEvent('Log', 'getMap', id)

    -- print('getmap')
    File = io.open(mapFolder .. "Maps.json", "r")
    local content = File:read("*a")
    --print(content)
    File:close()
    local testObj, pos, testErro = json.decode(content)
    if id == 0 then
        id = math.random( 1, #testObj )
    end
    -- print("ID:" .. id)
    -- print("Objekte:" .. #testObj)
    return testObj[id]
end

function GetAllMaps()
    -- TriggerEvent('Debug', 'CNC:Server:server:getAllMaps')

    TriggerEvent('Log', 'getAllMaps')
    -- print('getmaps')
    File = io.open(mapFolder .. "Maps.json", "r")
    local content = File:read("*a")
    --print(content)
    File:close()
    local testObj, pos, testErro = json.decode(content)
    --print("Objekte:" .. #testObj)
    return testObj
end

RegisterNetEvent('CNC:startRound')
AddEventHandler('CNC:startRound', function(choosenMap, copHint, rndTeam, pedDensity, trafficDensity)
    -- TriggerEvent('Debug', 'CNC:Server:server:startRound')

    DEBUG_MODE = ToBool(GetConvar('cncdebug', 'false'))

    local PlayerID = source
    --print('Player: ' .. PlayerID)
    --print(tostring(isRoundOngoing))
    TriggerEvent('Log', 'CNC:startRound', choosenMap)
    TriggerEvent('Log', 'CNC:startRound', copHint)
    
    --print('Cophint: ' .. tostring(copHint) )

    
    if IsRoundOngoing then
        for i,PlayerInfo in ipairs(PlayerInfos) do
            --print('PlayerInfo.player: ' .. PlayerInfo.player .. "==" .. 'Player: ' .. PlayerID)
            if tonumber(PlayerInfo.player) == tonumber(PlayerID) then
                if PlayerInfo.team == "lobby" then
                    -- print(PlayerInfo.player .. 'isLobby')
                    TriggerEvent('CNC:joinRunningRound', PlayerID)
                else
                    -- print(PlayerInfo.player .. ' not in Lobby')
                    TriggerClientEvent("CNC:showNotification", PlayerID, "~r~You can't join the game two times")
                end
            end
        end       
    else
        ResetVars()
        ChoosenMap = choosenMap
        CopHint = copHint
        RndTeam = rndTeam
        PedDensity = pedDensity
        TrafficDensity = trafficDensity
        StartCNCRound(ChoosenMap)
    end
end)

-- Start Round
function StartCNCRound(choosenMap)
    -- TriggerEvent('Debug', 'CNC:Server:server:startCNCRound')

    TriggerEvent('Log', 'startCNCRound' , choosenMap)
    local ListAllPlayer = GetPlayers()
    
    if (#ListAllPlayer<2 and (not DEBUG_MODE)) then
        print("Can´t start the Round, not enough Player")
        TriggerClientEvent("CNC:showNotification", -1, "~r~Can´t start the Round, not enough Players")

        return  -- ENTFERNE KOMMETAR FÜR DIE GENUG-SPIELER-PRÜFUNG
    end

    if IsRoundOngoing then
        print("Round can't start, round is already running.")
        return
    end

    IsRoundOngoing = true
    
    IsBossInGetaway = false
    RoundCounter = RoundCounter + 1
    print("start Round " .. RoundCounter .. "!")

    if RoundCounter == 1 then
        print("RoundCounter 1")
        PlayerInfos = {}
        Net_Getaway = nil
        --BossInfo = nil
        BossID = 0
        
        print("Count Players: " ..  #ListAllPlayer)
        for i,playerID in pairs(ListAllPlayer) do
            local PlayerInfo ={
                player = playerID,
                playerName = GetPlayerName(playerID);
                type = nil,
                team = nil,
                isBoss = false,
                coord = {
                    x = 0,
                    y = 0,
                    z = 0
                }
            }
            table.insert( PlayerInfos, PlayerInfo )
        end
        RandomizeTeams(RndTeam)

        local copCount = 0
        local crookCount = 0

        for i,PlayerInfo in ipairs(PlayerInfos) do
            if PlayerInfo.team == 'crook' then crookCount = crookCount + 1
            elseif PlayerInfo.team == 'cop' then copCount = copCount +1
            end
        end

        if not DEBUG_MODE then

            if crookCount < 1 then
                TriggerClientEvent("CNC:showNotification", -1, "No Player in the ~o~CROOK-Team ")
                RoundCounter = 0
                IsRoundOngoing  = false
                return
            end
            if copCount < 1 then
                TriggerClientEvent("CNC:showNotification", -1, "No Player in the ~p~COP-Team ")
                IsRoundOngoing  = false
                RoundCounter = 0
                return
            end

        end

        TriggerEvent('CNC:initPoints')

    elseif RoundCounter ~= 1 then
        -- switch Team
        for i,playerInfo in ipairs(PlayerInfos) do
            if playerInfo.team == 'crook' then
                PlayerInfos[i].team = 'cop'
            elseif PlayerInfos[i].team == 'cop' then
                PlayerInfos[i].team = 'crook'
            end
        end
        -- switch Points
        TriggerEvent('CNC:switchPoints')

    end

    -- choose the Boss
    for i,playerInfo in pairs(PlayerInfos) do
        if playerInfo.team == "crook" then
            PlayerInfos[i]['isBoss'] = true
            BossID = PlayerInfos[i].player
            break
        end
    end
    
    map = GetMap(choosenMap)
    local rndGetaway = math.random(1, #map['getaway'])
    --local rndGetaway = 1
    TriggerClientEvent('CNC:cleanAll', -1)

    Citizen.Wait(2000)
    -- TriggerEvent('CNC:StartRound')
    TriggerClientEvent('CNC:StartRound', -1, PlayerInfos)
    --TriggerEvent('chat:updatePlayerInfos', PlayerInfos)
    

    -- CREATE SPAWNER
    local globMap = GetGlobalMapSettings()
    TriggerClientEvent('CNC:eventCreateSpawner', -1, globMap['vehicles'] )
    
    
    -- SPAWN PICKUPS
    if RoundCounter == 1 then
        TriggerEvent('CNC:startSpawnPickups', PlayerInfos[1].player)
    end
    
    -- TriggerClientEvent('CNC:eventCreateGetaway', BossID, map['getaway'][rndGetaway] )
    CreateGetaway(map['getaway'][rndGetaway] )
    
    --TriggerClientEvent('CNC:eventCreateSpawner', BossID, globMap['vehicles'] )
    
    -- SPAWN PLAYERS
    Citizen.Wait(1000)
    print("trigger spawn Players")
    SpawnPlayers(map)
    
    -- SPAWN Vehicles
    Citizen.Wait(500)
    CreateVehicles(map['vehicle'])
    -- TriggerClientEvent('CNC:eventCreateVehicles', BossID, map['vehicle'] )
    
    -- Set Density
    TriggerClientEvent('CNC:setDensity', -1, PedDensity, TrafficDensity )


    if CopHint then
        -- print('Cophint: is true' )
        for i,player in ipairs(PlayerInfos) do
            if player.team == 'cop' then
                --print('Cophint: send to cop' )
                TriggerClientEvent('CNC:eventCreateCopHints', player.player, map )
            elseif player.team == 'crook' then
                TriggerClientEvent('CNC:eventCreateGetawayWaypoint', player.player, map['getaway'][rndGetaway] )
                
            end
        end
    end

    TriggerClientEvent("CNC:showScaleform", -1, map.infos.title, 'created by ' .. map.infos.autor, 7000)

    TriggerEvent('chat:updatePlayerInfos', PlayerInfos)
end




RegisterNetEvent('CNC:joinRunningRound')
AddEventHandler('CNC:joinRunningRound', function (playerID, team)
    -- TriggerEvent('Debug', 'CNC:Server:server:joinRunningRound')

    team = team or ''
    local copCount = 0
    local crookCount = 0

    -- choose the Team
    for i,PlayerInfo in ipairs(PlayerInfos) do
        if PlayerInfo.team == 'cop' then
            copCount = copCount + 1
        elseif PlayerInfo.team == 'crook' then
            crookCount = crookCount + 1
        end
    end
    if team  == '' then
        if copCount >= crookCount then
            team = 'crook'
        else
            team = 'cop'
        end
    end


    for i,PlayerInfo in ipairs(PlayerInfos) do
        if tonumber(PlayerInfo.player) == tonumber(playerID) then
            PlayerInfo.team = team
            RespawnPlayer(PlayerInfo)
        end
    end
    
    if team == 'cop' and CopHint then
        TriggerClientEvent('CNC:eventCreateCopHints', playerID, map )
    end
    TriggerClientEvent('CNC:StartRound', -1, PlayerInfos)
    TriggerEvent('chat:updatePlayerInfos', PlayerInfos)
    TriggerEvent('CNC:startSpawnPickupsJoiningPlayer', playerID )
    TriggerClientEvent('CNC:setDensity', -1, PedDensity, TrafficDensity )

    if team == 'crook' then
        TriggerEvent('CNC:forceCreateGetawayBlip', playerID )
    end

end)






















Citizen.CreateThread(function (  )
    function StartCoolDownThread( )
        local time = countdownBossInGetway
        TriggerClientEvent("CNC:showCountdown", -1, true, time, "Boss in getaway")

        for i=1, time do
            if not IsBossInGetaway then
            TriggerClientEvent("CNC:showCountdown", -1, false, time, "Boss in getaway")
                
                return
            end

            -- TriggerClientEvent('CNC:showNotification', -1, 'Round ends in: ' .. time - i)
            Citizen.Wait(1000)
        end
        
        CrooksWinsTheRound( )
    end
end)


function CrooksWinsTheRound( )
    TriggerEvent('Log', 'crooksWinsTheRound')
    print('Crooks win the Round')
    TriggerEvent('CNC:addPoints','crook', 1000)
    TriggerClientEvent('CNC:showNotification', -1, 'Crooks wins the Round!')
    Citizen.Wait(5000)
    StopGame(false)
end


function CopsWinsTheRound( )
    TriggerEvent('Log', 'copsWinsTheRound')
    print('Cops win the Round')
    TriggerClientEvent('CNC:showNotification', -1, 'Cops wins the Round!')
    Citizen.Wait(5000)
    StopGame(false)
end


function StopGame( hardReste )
    TriggerClientEvent("CNC:showCountdown", -1, false, time, "Boss entered getaway")
    TriggerEvent('Log', 'StopGame')
    TriggerEvent('CNC:clearVehicles')
    IsRoundOngoing = false
    IsBossInGetaway = false
    IsGetawayDriveable = true
    Net_Getaway = nil
    BossID = 0
    --BossInfo = nil

    for i,playerInfo in pairs(PlayerInfos) do
        PlayerInfos[i]['isBoss'] = false
        --PlayerInfos[i]['team'] = 'lobby'
    end

    TriggerClientEvent('CNC:SetRoundIsGoing', -1, false)
    TriggerClientEvent('CNC:StopRound', -1)
    TriggerClientEvent('CNC:killPlayer', -1)
    TriggerClientEvent('CNC:setTeam', -1)

    TriggerEvent('CNC:showScoreboard')
    
    Citizen.Wait(5000)

    if hardReste then
        RoundCounter = 0
        TriggerClientEvent('CNC:clearPickups', -1)
        for i,playerInfo in pairs(PlayerInfos) do
            --PlayerInfos[i]['isBoss'] = false
            PlayerInfos[i]['team'] = 'lobby'
        end
        return
    end

    if RoundCounter < RoundsToPlay  then
        StartNewRoundCoolDown()
    elseif RoundCounter == RoundsToPlay then
        RoundCounter = 0
        TriggerClientEvent('CNC:clearPickups', -1)
        for i,playerInfo in pairs(PlayerInfos) do
            --PlayerInfos[i]['isBoss'] = false
            PlayerInfos[i]['team'] = 'lobby'
        end
    end
end


function StartNewRoundCoolDown()
    local time = countdownStartNextRound
    TriggerClientEvent("CNC:showCountdown", -1, true, time, "Start next round ...")
    --TriggerClientEvent('CNC:showSBA', -1,  true)
    for i=1, time do
        -- TriggerClientEvent('CNC:showNotification', -1, 'Next Round starts in: ' .. time - i)
        Citizen.Wait(1000)
    end
    TriggerClientEvent("CNC:showCountdown", -1, false, time, "Start next round ...")
    StartCNCRound(ChoosenMap)
end


function RandomizeTeams(rnd)
    print("Randomize Teams")
    countPlayerResponse = 0

    if rnd then
        print('PlayerInfos:' .. #PlayerInfos)
        PlayerInfos = Shuffle(PlayerInfos)
        local bool = true
        for i,playerInfo in ipairs(PlayerInfos) do
            if bool then
                PlayerInfos[i]['team'] = 'crook'
                bool = not bool
            elseif not bool then
                --PlayerInfos[i]['team'] = 'crook'
                PlayerInfos[i]['team'] = 'cop'
                bool = not bool
            end
        end
    else
        TriggerClientEvent('CNC:getSelectedTeam', -1)
        while (countPlayerResponse ~= #PlayerInfos) do
            Citizen.Wait(1000)
            print('waiting for Player')
        end
    end
end


Citizen.CreateThread(function ( )
    RegisterNetEvent('CNC:sendPlayerCoord')
    AddEventHandler('CNC:sendPlayerCoord', function (coord)
        for i,playerInfo in ipairs(PlayerInfos) do
            if tonumber(playerInfo.player) == tonumber(source) then
                PlayerInfos[i].coord = coord
            end
        end
    end)
end)

RegisterNetEvent('CNC:showScoreboard')
AddEventHandler('CNC:showScoreboard', function( )
    TriggerClientEvent('CNC:showSBA', -1,  true)
    Citizen.Wait(10000)
    TriggerClientEvent('CNC:showSBA', -1,  false)
end)

RegisterNetEvent('CNC:creatPlayerBlip')
AddEventHandler('CNC:creatPlayerBlip', function( )
    local players = GetPlayers()
    TriggerClientEvent("CNC:createPlayerBlip", -1, players[2])
end)


RegisterNetEvent('CNC:registerTeam')
AddEventHandler('CNC:registerTeam', function( team )
    TriggerEvent('Log', 'CNC:registerTeam', team)
    --print('ID:' .. source .. ' / Team:' .. team)
    countPlayerResponse = countPlayerResponse + 1
    for i,PlayerInfo in ipairs(PlayerInfos) do
        if tonumber(PlayerInfo.player) == tonumber(source) then
            PlayerInfo.team = team
        end
    end
end)


RegisterNetEvent('CNC:showPlayerInfos')
AddEventHandler('CNC:showPlayerInfos', function( )
    for i,PlayerInfo in ipairs(PlayerInfos) do
        print('ID:' .. PlayerInfo.player .. ' / Team:' .. PlayerInfo.team)
    end
end)

RegisterNetEvent('CNC:Map:startInit')
AddEventHandler('CNC:Map:startInit', function ()
    print( 'CNC:Map:startInit' )
    
    local playerID = source
    local PlayerInfo ={
        player = playerID,
        playerName = GetPlayerName(playerID);
        type = nil,
        team = 'lobby',
        isBoss = false,
        coord = {
            x = 0,
            y = 0,
            z = 0
        }
    }
    
    print( PlayerInfo.playerName .. ' joined' )
    TriggerClientEvent('CNC:showNotification', -1, '~g~' .. PlayerInfo.playerName .. ' ~s~joined the Server')

    table.insert( PlayerInfos, PlayerInfo )
    TriggerClientEvent('CNC:ClientUpdate', -1, PlayerInfos)
    TriggerClientEvent('CNC:ClientUpdate:GameState', playerID, DoesRoundIsGoingOn())
end)


RegisterNetEvent('CNC:Map:refreshMap')
AddEventHandler('CNC:Map:refreshMap', function ()
    local playerID = source
    
    local tmpMaps = GetAllMaps()
    TriggerClientEvent('CNC:Map:init', -1, tmpMaps)

end)

RegisterNetEvent('CNC:getPlayerInfos')
AddEventHandler('CNC:getPlayerInfos', function ()
    TriggerEvent('chat:updatePlayerInfos', PlayerInfos)
end)


