
local isShown = false
local startUp = true
local playerCount = 0

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlPressed(0, 288) or startUp--[[ INPUT_PHONE ]] then
            if isShown then
                closeHelp()
            else
                showHelp()
            end
        end
    end
end)



RegisterNUICallback("start", function(data)
    closeHelp()
    TriggerServerEvent('CNC-HELP:closeAllHelpWindows')
end)

RegisterNUICallback("exit", function(data)
    closeHelp()
end)


RegisterNetEvent('CNC-HELP:close')
AddEventHandler('CNC-HELP:close', function ()
    closeHelp()
end)

-- RegisterNetEvent('CNC-HELP:UpdatePlayer')
-- AddEventHandler('CNC-HELP:UpdatePlayer', function (plCount)
--     playerCount = plCount
--     updateHelp()
-- end)


function closeHelp()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'close'
    })
    isShown = false
    Wait(100)

    print("CLOSE HELP")
    TriggerEvent("CNC:joinRoundIfRoundIsGoingOn")
end

function showHelp()
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