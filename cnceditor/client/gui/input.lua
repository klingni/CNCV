function GetUserInput( title )
    AddTextEntry('windowTitle', title)
    DisplayOnscreenKeyboard(1, 'windowTitle', '', '', '', '', '', 15)
    while true do
        if UpdateOnscreenKeyboard() == 2 then break
        elseif UpdateOnscreenKeyboard() == 1 then break
        elseif UpdateOnscreenKeyboard() == 3 then break
        else Citizen.Wait(0)
        end
        Citizen.Wait(0)
    end
    local status = UpdateOnscreenKeyboard()
    local result = GetOnscreenKeyboardResult()

    if (result ~="" and result ~= nil and status == 1) then
        --Citizen.Trace( 'Result:' .. result)
        return result
    else
        --Citizen.Trace( 'Result:' .. 'NIL')
        return ''
    end


end