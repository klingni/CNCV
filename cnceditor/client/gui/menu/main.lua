MenuPool = NativeUI.CreatePool()
MenuPool:RefreshIndex()
MainMenu = nil

-- _menuPool:MouseControlsEnabled(false)
-- _menuPool:ControlDisablingEnabled(false)

local loadmenu

local Maps = {}
local CurrentMapId

TriggerServerEvent('CNCE:Map:startInit')

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end


function AddMenuGlobalMap(menu)
    local globalmenu = MenuPool:AddSubMenu(menu, "Global Map", "contains Pickups and Spawner")
    
    local globLoad = NativeUI.CreateItem("load", "load the Globalmap")
    local globSave = NativeUI.CreateItem("save", "save the Globalmap")
    local globcrPi = NativeUI.CreateItem("create Pickup", "creat a pickup position")
    local globRmPu = NativeUI.CreateItem("remove Pickup", "remove a pickup position")
    local globToVe = NativeUI.CreateItem("cur Veh. to Spawner", "saves the current vehicle to a vehicle spawner")

    globalmenu:AddItem(globLoad)
    globalmenu:AddItem(globSave)
    globalmenu:AddItem(globcrPi)
    globalmenu:AddItem(globRmPu)
    globalmenu:AddItem(globToVe)

    globalmenu.OnItemSelect = function( sender, item, index )
        if item == globLoad then TriggerServerEvent("CNCE:globMap:callLoadMap") end
        if item == globSave then TriggerServerEvent("CNCE:globMap:save") end
        if item == globcrPi then TriggerEvent("CNCE:globMap:Pickup:createPickup") end
        if item == globRmPu then TriggerEvent("CNCE:globMap:Pickup:removePickup") end
        if item == globToVe then TriggerEvent("CNCE:globMap:forceSetCurrentVehicleToSpawner") end
    end
end
    

function AddMenuMap(menu)
    local mapmenu = MenuPool:AddSubMenu(menu, "Map", "contains Getaways, Cops and Crook spawns, Vehicle spawns")
    
    loadmenu = MenuPool:AddSubMenu(mapmenu, "load Map", "open a Map")

    mapmenu.OnMenuChanged = function(menu, newmenu, forward)
        Citizen.Trace('Change Menü:' .. tostring(menu['Title']))
    end

        for i,map in ipairs(Maps) do
            loadmenu:AddItem(NativeUI.CreateItem(map['infos']['title'], "created by " .. map['infos']['autor']))
        end

    loadmenu.OnItemSelect = function ( sender, item, index )
        Citizen.Trace('TRIGGER:' .. index)
        TriggerEvent('CNCE:Map:forceLoadMapById', index)
    end
    
    

    local editmenu = MenuPool:AddSubMenu(mapmenu, "edit", "edit current Map")
        local mapSetCop = NativeUI.CreateItem("add Cop spawn", "add a cop spawn position")
        local mapSetCrk = NativeUI.CreateItem("add Crook spawn", "add a crook spawn position")
        local mapToVehi = NativeUI.CreateItem("curr. Vehicel -> Vehicel", "saves the current vehicle to vehicle")
        local mapToGeta = NativeUI.CreateItem("curr. Vehicel -> Getaway", "saves the current vehicle to getaway")
        local mapRemSwn = NativeUI.CreateItem("~r~remove", "removes cops/crooks/getaways/vehicles in 3m range")
        local mapRename = NativeUI.CreateItem("rename the map", "renames the map")


        editmenu:AddItem(mapSetCop)
        editmenu:AddItem(mapSetCrk)
        editmenu:AddItem(mapToVehi)
        editmenu:AddItem(mapToGeta)
        editmenu:AddItem(mapRemSwn)
        editmenu:AddItem(mapRename)


        editmenu.OnItemSelect = function ( sender, item, index )
            if item == mapSetCop then TriggerEvent("CNCE:Map:forceAddCop") end
            if item == mapSetCrk then TriggerEvent("CNCE:Map:forceAddCrook") end
            if item == mapToVehi then TriggerEvent("CNCE:Map:forceSetCurrentVehicleToVehicle") end
            if item == mapToGeta then TriggerEvent("CNCE:Map:forceSetCurrentVehicleToGetaway") end
            if item == mapRemSwn then TriggerEvent("CNCE:Map:forceRemoveSpawn") end
            if item == mapRename then
                MenuPool:CloseAllMenus()
                TriggerEvent("CNCE:Map:forceRenameMap")
            end
        end


    local mapSave = NativeUI.CreateItem("save current Map", "save the current map")
    local mapAdd = NativeUI.CreateItem("add new Map", "add a new map")
    mapmenu:AddItem(mapSave)
    mapmenu:AddItem(mapAdd)

    mapmenu.OnItemSelect = function (sender, item, index)
        if item == mapSave then
            MenuPool:CloseAllMenus()
            TriggerEvent("CNCE:Map:saveMap") end
        if item == mapAdd then
            MenuPool:CloseAllMenus()
            TriggerEvent("CNCE:Map:addNewMap")
        end
    end
end

function AddMenuItemClear(menu)
    local clearItem = NativeUI.CreateItem("Clear", "Cleanup")
    menu:AddItem(clearItem)
    menu.OnItemSelect = function(sender, item, index)
        if item == clearItem then
            Citizen.Trace('CLEAR')
            TriggerEvent('CNCE:Map:clear')
        end
    end
end

RegisterNetEvent('CNCE:Map:init')
AddEventHandler('CNCE:Map:init', function (maps, currentMapId)
    Maps = maps
    CurrentMapId = currentMapId
end)




function OpenMenu( )
    TriggerServerEvent('CNCE:Map:startInit')
    Citizen.Trace('open Menue')
    MainMenu = NativeUI.CreateMenu("CnC Editor", "~b~CNC Editor")
    MenuPool:Add(MainMenu)
    AddMenuGlobalMap(MainMenu)
    AddMenuMap(MainMenu)
    AddMenuItemClear(MainMenu)
    MenuPool:RefreshIndex()
    MainMenu:Visible(true)
end




Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
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


