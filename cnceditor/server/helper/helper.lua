---@diagnostic disable-next-line: discard-returns
math.randomseed(os.time())


RegisterNetEvent('EventSavePosition')
AddEventHandler('EventSavePosition', function (Pos)
    
    
    local pos = "{\"x\":" .. PosX .. ", \"y\":".. PosY .. ", \"z\": " .. PosZ .."},"
    print("save current Position: " .. pos)
    File = io.open("weapons.lua", "a+")
    File:write(pos .. "\n")
    File:close()
end)


RegisterNetEvent('Debug')
AddEventHandler('Debug', function (arg)
    print(arg)
end)


RegisterNetEvent('ident')
AddEventHandler('ident', function (arg)
    print(GetNumPlayerIdentifiers(arg))
    print(GetPlayerIdentifier(arg, 0))
end)
