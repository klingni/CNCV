MenuPool = MenuPool.New()
MenuPool:RefreshIndex()
MainMenu = nil


local Maps = {}
local choosenMap
local copHint = true
local randomeTeams = false
local choosenTrafficDensity = 0.5
local choosenPedDensity = 0.5




function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function AddMenuMaps(menu)
    local maps = {
        "RANDOM"
    }


        print(#Maps)

    local counter = 0
    
    -- Wait for Map update
    while #Maps == 0 do
        print(#Maps)
        counter = counter + 1
        if counter == 15 then
            print("Cant load any maps!")
            break
        end
        Citizen.Wait(100)
    end

    for i,map in ipairs(Maps) do
        table.insert( maps,map['infos']['title'] )
    end

    local newitemMap = NativeUI.CreateListItem("Maps", maps, 1, 'Maps')
    
    local densityTrafficDensity = {0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0}
    local newitemTrafficDensity = NativeUI.CreateListItem("Traffic Density", densityTrafficDensity, 6, 'Set Traffic density')

    local densityPed = {0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0}
    local newitemPedDensity = NativeUI.CreateListItem("Pad Density", densityPed, 6, 'Set Traffic density')
    
    
    menu:AddItem(newitemMap)
    menu:AddItem(newitemTrafficDensity)
    menu:AddItem(newitemPedDensity)

    menu.OnListChange = function(sender, item, index)
        if item == newitemMap then
            choosenMap = index - 1
        elseif item == newitemTrafficDensity then

            choosenTrafficDensity = (index -1)/10
        elseif item == newitemPedDensity then
            choosenPedDensity = (index -1)/10
        end
    end
end

function AddMenuCopHint(menu)
    local newitemHint = NativeUI.CreateCheckboxItem("Show Cop hints", copHint,  "Shows the cops the possible getaway positions on the map.")
    local newitemChoice = NativeUI.CreateCheckboxItem("Random Team", randomeTeams,  "Choose teams randomly or by yourself.")
   
    menu:AddItem(newitemHint)
    menu:AddItem(newitemChoice)
    
    menu.OnCheckboxChange = function(sender, item, checked_)
        if item == newitemHint then
            copHint = checked_
            print('copHint: ' .. tostring(copHint))
        end
        if item == newitemChoice then
            randomeTeams = checked_
            print('randomTeams: ' .. tostring(randomeTeams))
        end
    end
end

function AddMenuStartRound(menu)
    local newitem = UIMenuItem.New("~g~Start / Join Round~s~", "Starts a CNC-Round or join a running Round.")
    menu:AddItem(newitem)
    menu.OnItemSelect = function(sender, item, index)
        if item == newitem then
            local string = "Start/Join Round"
            ShowNotification(string)
            MenuPool:CloseAllMenus()
            --TriggerServerEvent('CNC:startRound', choosenMap, true, randomeTeams)
            TriggerServerEvent('CNC:startRound', choosenMap, copHint, randomeTeams, choosenPedDensity, choosenTrafficDensity)
        end
    end
end



RegisterNetEvent('CNC:Map:init')
AddEventHandler('CNC:Map:init', function (maps)
    Maps = maps
    --Citizen.Trace(#maps)
end)

RegisterNetEvent('CNC:StartRound')
AddEventHandler('CNC:StartRound', function ()
    MenuPool:CloseAllMenus()
end)


function OpenMenu( )
    TriggerServerEvent('CNC:Map:refreshMap')
    choosenMap = 0
    --Citizen.Trace('open Menue')
    MainMenu = NativeUI.CreateMenu("Settings", "~b~Settings")
    MenuPool:Add(MainMenu)
    AddMenuMaps(MainMenu)
    AddMenuCopHint(MainMenu)
    --AddMenuTeamChoice(mainMenu)
    --AddMenuTrafficDensity(mainMenu)
    --AddMenuPadDensity(mainMenu)
    AddMenuStartRound(MainMenu)


    MenuPool:RefreshIndex()
    MainMenu:Visible(true)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
         MenuPool:MouseControlsEnabled(false)
        MenuPool:ControlDisablingEnabled(false)

        MenuPool:ProcessMenus()
        if IsControlJustPressed(1, 166) then
            if MainMenu == nil then
                OpenMenu()
            else
                if (not MenuPool:IsAnyMenuOpen()) then
                    OpenMenu()
                else
                    MenuPool:CloseAllMenus()
                end
            end
        end
    end
end)
