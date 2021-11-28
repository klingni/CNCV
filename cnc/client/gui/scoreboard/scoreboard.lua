local listOn = false
local showSBA = false
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
                    scoreboard = {
                        show = true
                    },
                    PlayerInfos = playerInfos,
                    Score = score
                    })

                listOn = true
                while listOn do
                    Wait(0)
                    if(IsControlPressed(0, 27) == false and showSBA == false) then
                        listOn = false
                        SendNUIMessage({
                            scoreboard = {
                                show = false
                            }
                        })
                        break
                    end
                end
            end
        end


        -- if IsControlPressed(0, 173) or showSBA--[[ INPUT_PHONE ]] then
        --     if not listOn then
        --         local players = {}

        --         SendNUIMessage({
        --             countdown = {
        --                 show = true,
        --                 time = 50,
        --                 text = "Starting Round ..."
        --             },
        --             })

        --         listOn = true
        --         while listOn do
        --             Wait(0)
        --             if(IsControlPressed(0, 173) == false and showSBA == false) then
        --                 listOn = false
        --                 SendNUIMessage({
        --                     countdown = {
        --                         show = false
        --                     }
        --                 })
        --                 break
        --             end
        --         end
        --     end
        -- end
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

function Sanitize(txt)
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

RegisterNetEvent("CNC:showCountdown")
AddEventHandler("CNC:showCountdown", function(bool, time, message)
    SendNUIMessage({
        countdown = {
            show = bool,
            time = time,
            text = message
        },
        })
end)