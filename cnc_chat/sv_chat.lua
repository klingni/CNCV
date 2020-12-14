local PlayerInfos ={}
local TeamChat = false

RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

AddEventHandler('_chat:messageEntered', function(author, color, message)
    if not message or not author then
        return
    end

    local team

    TriggerEvent('chatMessage', source, author, message)

    TriggerEvent('CNC:getPlayerInfos')
    --Citizen.Wait(100)

    if not WasEventCanceled() then

        local newcolor = {255, 255, 255}

        
        for i,playerInfo in ipairs(PlayerInfos) do
            print(playerInfo.player .. ' / ' .. source)
            if tonumber(playerInfo.player) == tonumber(source) then
                team = playerInfo.team
                --print(playerInfo.team)
                
                if playerInfo.team == 'lobby' then
                    --print('COLOR = LOBBY')
                    newcolor = {255, 255, 255}
                elseif playerInfo.team == 'cop' then
                    --print('COLOR = COP')
                    newcolor = {153, 0, 145}
                elseif playerInfo.team == 'crook' then
                    --print('COLOR = CROOK')
                    newcolor = {255, 136, 0}
                end

                break
            end
        end
        
        if TeamChat == true then

            for i,playerInfo in ipairs(PlayerInfos) do
                print(playerInfo.team .. ' / ' .. team)
                if playerInfo.team == team then
                    TriggerClientEvent('chatMessage', playerInfo.player, author,  newcolor, '[TEAM]: ' .. message)
                end
            end
        
        else
            TriggerClientEvent('chatMessage', -1, author,  newcolor, '[ALL]: ' .. message)
        end

    end
    



    print('PlayerInfoCount: ' .. #PlayerInfos)
    print(author .. ': ' .. message)
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, '/' .. command) 
    end

    CancelEvent()
end)

-- player join messages
AddEventHandler('chat:init', function()
    TriggerClientEvent('chatMessage', -1, '', { 255, 255, 255 }, '^2* ' .. GetPlayerName(source) .. ' joined.')
end)

AddEventHandler('playerDropped', function(reason)
    TriggerClientEvent('chatMessage', -1, '', { 255, 255, 255 }, '^2* ' .. GetPlayerName(source) ..' left (' .. reason .. ')')
end)

RegisterCommand('say', function(source, args, rawCommand)
    TriggerClientEvent('chatMessage', -1, (source == 0) and 'console' or GetPlayerName(source), { 255, 255, 255 }, rawCommand:sub(5))
end)

-- command suggestions for clients
local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end

AddEventHandler('chat:init', function()
    refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)

    for _, player in ipairs(GetPlayers()) do
        refreshCommands(player)
    end
end)

RegisterServerEvent('chat:updatePlayerInfos')
AddEventHandler('chat:updatePlayerInfos', function(playerInfos)
    print('update PlayerInfos in Chat')
    PlayerInfos = playerInfos
end)

RegisterServerEvent('chat:setChatMode')
AddEventHandler('chat:setChatMode', function(isTeamChat)
    TeamChat = isTeamChat
end)