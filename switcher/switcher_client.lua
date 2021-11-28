local _menuPool = MenuPool.New()
local mainMenu = UIMenu.New("Switch", "~b~select Mode")
_menuPool:Add(mainMenu)

_menuPool:MouseControlsEnabled(false)
_menuPool:ControlDisablingEnabled(false)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end



function AddMainMenuItems(menu)
    local itemEditor = UIMenuItem.New("start/restart Map-Editor", "starts the CNC map editor (Attention: This can cause the server to crash.)")
    local itemCNC = UIMenuItem.New("start/restart CnC", "START CNC-GAMEMODE")

    menu:AddItem(itemEditor)
    menu:AddItem(itemCNC)

    menu.OnItemSelect = function(sender, item, index)
        if item == itemEditor then TriggerServerEvent('Switcher:SwitchToEditor') end
        if item == itemCNC then TriggerServerEvent('Switcher:SwitchToCNC') end
    end
end







AddMainMenuItems(mainMenu)


_menuPool:RefreshIndex()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        if IsControlJustPressed(0, 167) then
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
end)

RegisterNetEvent('CNC:StartRound')
AddEventHandler('CNC:StartRound', function ()
    _menuPool:CloseAllMenus()
end)