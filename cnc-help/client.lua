
local isShown = false
local startUp = true
local playerCount = 0

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlPressed(0, 288) or startUp--[[ INPUT_PHONE ]] then
            if isShown then
                CloseHelp()
            else
                ShowHelp()
            end
        end
    end
end)



RegisterNUICallback("start", function(data)
    CloseHelp()
    TriggerServerEvent('CNC-HELP:closeAllHelpWindows')
    TriggerServerEvent('CNC:startRound', 0, true, true, 0.5, 0.5)
end)

RegisterNUICallback("exit", function(data)
    CloseHelp()
    TriggerEvent("CNC:joinRoundIfRoundIsGoingOn")
end)


RegisterNetEvent('CNC-HELP:close')
AddEventHandler('CNC-HELP:close', function ()
    CloseHelp()
end)

-- RegisterNetEvent('CNC-HELP:UpdatePlayer')
-- AddEventHandler('CNC-HELP:UpdatePlayer', function (plCount)
--     playerCount = plCount
--     updateHelp()
-- end)


function CloseHelp()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'close'
    })
    isShown = false
    Wait(100)

    print("CLOSE HELP")
    
end

function ShowHelp()
    -- TriggerServerEvent('CNC-HELP:getPlayerCount')
    print("PlayerCount: " .. #GetActivePlayers())
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'show',
        playerCount = #GetActivePlayers()
    })
    isShown = true
    startUp = false
    Wait(100)
end

-- function updateHelp()
--     SendNUIMessage({
--         action = 'update',
--         playerCount = playerCount
--     })
-- end