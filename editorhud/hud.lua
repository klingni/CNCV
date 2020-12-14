local MapName = "NULL"

Citizen.CreateThread(function()
    while true do
        Wait(1000)
            SendNUIMessage({ map = MapName })
    end
end)


RegisterNetEvent("CNC:updateScore")
AddEventHandler("CNC:updateScore", function(newScore)
  
end)


function updateHudMapName( mapName )
    MapName = mapName
end