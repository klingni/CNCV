math.randomseed(os.time())
local currentFolder = "resources//[cnc]//cnc//Log//"




function shuffle(tbl)
    print('SHUFFLE')
    size = #tbl
    for i = size, 1, -1 do
      local rand = math.random(size)
      tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
    return tbl
  end


function showTeams( )
    print("#### ALL PLAYERS ###")
    for i=1,#ListAllPlayer do
        print(ListAllPlayer[i])
    end

    print("#### COPS ###")
    for i=1,#ListCopPlayer do
        print(ListCopPlayer[i] .. " : " .. GetPlayerTeam(ListCopPlayer[i]))
        
    end

    print("#### CROOCKS ###")
    for i=1,#ListCrookPlayer do
        print(ListCrookPlayer[i] .. " : " .. GetPlayerTeam(ListCopPlayer[i]))
    end
end



RegisterNetEvent('Debug')
AddEventHandler('Debug', function (arg)
    print("DEBUG -" .. os.date("%X") .. ": " .. dump(arg))
    --RconPrint(arg)
end)

RegisterNetEvent('Log')
AddEventHandler('Log', function (funct, args)

    
        --print('write Log')
        local logLine = os.date("%X") .. ' - ' .. 'Function:' .. funct .. ' - Param: ' .. dump( args ) .. "\n"
        --print(logLine)
        
        date = os.date("*t")
        file = io.open(currentFolder .. "Log_" .. date.year .. date.month .. date.day .. ".log", "a")
        file:write(logLine)
        file:close()

end)

function startRound()
    randomizeTeams()
end


function tobool( v )
    if v == 'true' then
        return true
    elseif v == false then
        return false
    end
end

function mean( t )
    local sum = 0
    local count= 0
  
    for k,v in pairs(t) do
      if type(v) == 'number' then
        sum = sum + v
        count = count + 1
      end
    end
  
    return (sum / count)
end

RegisterNetEvent('CNC:startEditor')
AddEventHandler('CNC:startEditor', function (arg)
    print('start Editor')
    StartResource('cnceditor')
end)



function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end


 RegisterNetEvent('CNC:getPed')
 AddEventHandler('CNC:getPed', function (PlayerID)
     print('PlayerID:' ..tonumber(PlayerID))
     print('Ped:' .. GetPlayerPed(PlayerID) )
 
 end)

 function DistanceBetweenCoords2D(x1,y1,x2,y2)
	local deltax = x1 - x2
	local deltay = y1 - y2

	dist = math.sqrt((deltax * deltax) + (deltay * deltay))

	return dist
end