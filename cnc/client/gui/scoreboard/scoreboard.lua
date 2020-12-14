local listOn = false
showSBA = false
local score = {
    cops = 0,
    crooks = 0
}

Citizen.CreateThread(function()
    listOn = false
    while true do
        Wait(0)

        if IsControlPressed(0, 27) or showSBA--[[ INPUT_PHONE ]] then
            if not listOn then
                local players = {}


                
                SendNUIMessage({
                    PlayerInfos = playerInfos,
                    Score = score
                    })

                listOn = true
                while listOn do
                    Wait(0)
                    if(IsControlPressed(0, 27) == false and showSBA == false) then
                        listOn = false
                        SendNUIMessage({
                            meta = 'close'
                        })
                        break
                    end
                end
            end
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

function sanitize(txt)
    local replacements = {
        ['&' ] = '&amp;', 
        ['<' ] = '&lt;', 
        ['>' ] = '&gt;', 
        ['\n'] = '<br/>'
    }
    return txt
        :gsub('[&<>\n]', replacements)
        :gsub(' +', function(s) return ' '..('&nbsp;'):rep(#s-1) end)
end

RegisterNetEvent("CNC:updateScore")
AddEventHandler("CNC:updateScore", function(newScore)
  score = newScore
end)

RegisterNetEvent("CNC:showSBA")
AddEventHandler("CNC:showSBA", function(toggle)
    showSBA = toggle
end)