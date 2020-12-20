local score = {}


RegisterNetEvent('CNC:initPoints')
AddEventHandler('CNC:initPoints', function()
    score = {
        cop = 0,
        crook = 0
    }
    TriggerClientEvent('CNC:updateScore', -1, score)
end)


RegisterNetEvent('CNC:addPoints')
AddEventHandler('CNC:addPoints', function(team, points)
    print("team:" .. team)
    print("points:" .. points)
    score[team] = score[team] + points
    if score[team] < 0 then score[team] = 0 end
    TriggerClientEvent('CNC:updateScore', -1, score)
end)

RegisterNetEvent('CNC:switchPoints')
AddEventHandler('CNC:switchPoints', function()
    local scoreCops = score['cop']
    local scoreCrooks = score['crook']

    score['cop'] = scoreCrooks
    score['crook'] = scoreCops

    TriggerClientEvent('CNC:updateScore', -1, score)
end)