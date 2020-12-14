AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
    
    NetworkSetFriendlyFireOption(true)
  end)
  
  
RegisterNetEvent("dontneed")
AddEventHandler("dontneed",function(args)

    Citizen.CreateThread(function (  )
        for i=2,999 do
            --Citizen.Trace(i)
            if NetworkDoesNetworkIdExist(i) then
               -- Citizen.Trace('ExistID:' .. i)            
                DeleteEntity(NetworkGetEntityFromNetworkId(i))
            end
        end
    end)
     
end)



RegisterNetEvent("ray")
AddEventHandler("ray",function()

    local bool, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
    Citizen.Trace('bool: ' .. tostring(bool))
    Citizen.Trace('entity: ' .. tostring(entity))
    Citizen.Trace('NetworkID: ' .. NetworkGetNetworkIdFromEntity(entity))
    DeleteEntity(entity)

     
end)

RegisterNetEvent("updateMapName")
AddEventHandler("updateMapName",function(name)
     exports.editorhud:updateHudMapName(name)
end)



RegisterNetEvent("del")
AddEventHandler("del",function(args)
    Citizen.Trace('DEL: ' .. args)
    i  = tonumber(args)

    if NetworkDoesNetworkIdExist(i) then
        DeleteEntity(NetworkGetEntityFromNetworkId(i))
    end
end)


RegisterNetEvent("delall")
AddEventHandler("delall",function(args)

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
end)



RegisterNetEvent("get")
AddEventHandler("get",function()
     local players = GetPlayersNetworkID()

     for i,player in ipairs(players) do
        Citizen.Trace(i.. ": " ..player)
     end
end)

function GetPlayersNetworkID()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            --Citizen.Trace(i .. ":")
            table.insert(players, NetworkGetNetworkIdFromEntity(GetPlayerPed(i)))
        end
    end

    return players
end