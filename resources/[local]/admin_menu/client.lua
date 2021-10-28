local playerPed = PlayerPedId()
AddEventHandler("jp:onPedChange", function(ped)
    playerPed = ped
    print ("New ped: "..ped)
end)

local adminRank = false

print "heyyy"

WarMenu.CreateMenu('admin', 'Admin')

WarMenu.SetMenuWidth("admin", 0.35)
WarMenu.SetMenuX("admin", 0.61)
WarMenu.SetMenuY("admin", 0.017)
WarMenu.SetMenuMaxOptionCountOnScreen("admin", 20)
WarMenu.SetTitleBackgroundColor("admin", 52, 114, 138)
WarMenu.SetMenuBackgroundColor("admin", 52, 114, 138)

local function SetDefaultSubMenuProperties(menu)
    WarMenu.SetMenuWidth(menu, 0.35)
    WarMenu.SetMenuTitleBackgroundColor(menu, 52, 114, 138)
    WarMenu.SetMenuBackgroundColor(menu, 52, 114, 138)
end

WarMenu.CreateSubMenu("admin_players", "admin", "Player List")
SetDefaultSubMenuProperties("admin_players")

WarMenu.CreateSubMenu("admin_player_options", "admin_players", "Player Options")
SetDefaultSubMenuProperties("admin_player_options")

WarMenu.CreateSubMenu("admin_player_datas", "admin_player_options", "Player Data")
SetDefaultSubMenuProperties("admin_player_datas")

WarMenu.CreateSubMenu("admin_player_vehicles", "admin_player_options", "Player Vehicles")
SetDefaultSubMenuProperties("admin_player_vehicles")

WarMenu.CreateSubMenu("admin_player_warnings", "admin_player_options", "Player Warnings")
SetDefaultSubMenuProperties("admin_player_warnings")

WarMenu.CreateSubMenu("admin_ban_options", "admin_player_options", "Ban Options")
SetDefaultSubMenuProperties("admin_ban_options")

WarMenu.CreateSubMenu("admin_self_options", "admin", "Self Options")
SetDefaultSubMenuProperties("admin_self_options")

WarMenu.CreateSubMenu("admin_disconnected_players", "admin", "Disconnected Players")
SetDefaultSubMenuProperties("admin_disconnected_players")

WarMenu.CreateSubMenu("admin_vehicle_options", "admin", "Vehicle Options")
SetDefaultSubMenuProperties("admin_vehicle_options")

local function ShowTextEntry(title, subMsg, cb)
    SendNUIMessage({open = true, textEntry = true, title = title, submsg = subMsg and subMsg or ""})
    textEntryCb = function(text) cb(text) end
end

local Data = {
    SelectedPlayerWarnings,
    SelectedPlayerVehicles,
    SelectedPlayer,
    Players = {},
    DisconnectedPlayers = {},
    SelectedVehicle = 0,

    SelectedItem = "",
    ItemQuantity = 0,
}

local function DrawMain()
    WarMenu.Button("Player List")
    if WarMenu.IsItemSelected() then
        Data.Players = RPC.execute('admin:getPlayerDatas')
        WarMenu.OpenMenu("admin_players")
    end

    WarMenu.Button("Disconnects")
    if WarMenu.IsItemSelected() then
        Data.DisconnectedPlayers = RPC.execute('admin:getDisconnectedPlayers')
        WarMenu.OpenMenu("admin_disconnected_players")
    end

    WarMenu.Button("Self Options")
    if WarMenu.IsItemSelected() then
        WarMenu.OpenMenu("admin_self_options")
    end

    WarMenu.Button("Vehicle Options")
    if WarMenu.IsItemSelected() then
        if Data.SelectedVehicle ~= 0 and not DoesEntityExist(Data.SelectedVehicle) then
            Data.SelectedVehicle = 0 
        end
        WarMenu.OpenMenu("admin_vehicle_options")
    end

    WarMenu.Button("View Inventory (From CID)")
    if WarMenu.IsItemSelected() then
        local result = exports['textbox']:open({
            {
                label = "Target Citizen ID (CID)",
                id = "cid"
            }
        }).cid
        if string.gsub(result, " ", "") == "" or result == "" then result = "None" end
        if result then
            TriggerEvent("admin:openInventory", {invType = "player", invId = result})
        end 
    end

    if WarMenu.Button("Close") then
        WarMenu.CloseMenu()
    end
end

local function nuiCallBack(data)
    if data.textEntry then
        textEntryCb(data.text and data.text or nil)
    end

    if data.close then
        SetNuiFocus(false, false)
    end

    if data.showcursor or data.showcursor == false then SetNuiFocus(data.showcursor, data.showcursor) end
end

RegisterNUICallback("nuiMessage", nuiCallBack)

local function DrawPlayerDatas()
    WarMenu.Button("pid: "..Data.SelectedPlayer.pid)
    WarMenu.Button(Data.SelectedPlayer.license2)
    WarMenu.Button("source: "..Data.SelectedPlayer.source)
    WarMenu.Button("ping: "..Data.SelectedPlayer.ping)
    WarMenu.Button(Data.SelectedPlayer.ip)
    WarMenu.Button("")
    WarMenu.Button("cid: "..Data.SelectedPlayer.cid)
    WarMenu.Button("name: "..Data.SelectedPlayer.character_name)
    WarMenu.Button("phone: "..Data.SelectedPlayer.phone)

    WarMenu.Button("faction: "..Data.SelectedPlayer.faction)
    WarMenu.Button("rank: "..Data.SelectedPlayer.rank_name)
end

--//BAN SHIT
local banReason = ""
local secretReason = ""
local _comboBoxIndex = 1

--//SPECTATING
local currentlySpectating = false
local spectatingOldCoords = {x=0, y=0, z=0}

local noclip = false

local oldClothing = {}
local jesusMode = false

function DrawSelfOptions()
    local enabledText = noclip and "~g~Enabled" or "~o~Disabled"
    WarMenu.Button("Toggle Noclip | "..enabledText) 
     if WarMenu.IsItemSelected() then
         noclip = not noclip
     end

     local enabledText = jesusMode and "~g~Enabled" or "~o~Disabled"
     WarMenu.Button("Jesus Mode | "..enabledText) 
     if WarMenu.IsItemSelected() then
         jesusMode = not jesusMode
         if jesusMode then
            oldClothing = exports['clothes']:GetCurrentPed()
            exports['clothes']:LoadPed({model = `u_m_m_jesus_01`})
         else
            exports['clothes']:LoadPed(oldClothing)
         end
     end
 end

function DrawPlayerOptions()
    WarMenu.Button("Player Data")
    if WarMenu.IsItemSelected() then
        WarMenu.OpenMenu("admin_player_datas")
    end
    WarMenu.Button("Player Vehicles")
    if WarMenu.IsItemSelected() then
        Data.SelectedPlayerVehicles = RPC.execute('admin:getPlayerVehicles', Data.SelectedPlayer.cid)
        WarMenu.OpenMenu("admin_player_vehicles")
    end
    WarMenu.Button("View Inventory")
    if WarMenu.IsItemSelected() then
        TriggerEvent("admin:openInventory", {invType = "player", invId = Data.SelectedPlayer.cid})
    end
    WarMenu.Button("")

    WarMenu.Button("History")
    WarMenu.Button("Warnings")
    if WarMenu.IsItemSelected() then
        Data.SelectedPlayerWarnings = RPC.execute('admin:getWarnings', Data.SelectedPlayer.source)
        WarMenu.SetMenuSubTitle('admin_player_warnings', "Amount of warnings: "..#Data.SelectedPlayerWarnings)
        WarMenu.OpenMenu("admin_player_warnings")
    end

    WarMenu.Button("")
    local x = currentlySpectating and " | Select again to stop spectating" or ""
    WarMenu.Button("Spectate Player "..x)
    if WarMenu.IsItemSelected() then
        if not currentlySpectating then
            currentlySpectating = true

            local tgtCoords = RPC.execute('admin:getCoords', Data.SelectedPlayer.source)

            if not tgtCoords then currentlySpectating = false return end

            noclip = true
            spectatingOldCoords = GetEntityCoords(playerPed)
            SetEntityCoords(playerPed, tgtCoords.x, tgtCoords.y, tgtCoords.z +5.0, 0, 0, 0, false)

            CreateThread(function()
                while currentlySpectating do
                    local ped = GetPlayerPed(Data.SelectedPlayer.source)
                    local coords = GetEntityCoords(ped)

                    DrawMarker(20, coords.x, coords.y, coords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, -0.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)
                    Wait(0)
                end
            end)
        else
            SetEntityCoords(playerPed, spectatingOldCoords.x, spectatingOldCoords.y, spectatingOldCoords.z, 0, 0, 0, false)
            noclip = false
            currentlySpectating = false
        end
    end

    WarMenu.Button("")
    WarMenu.Button("Warn Player")
    if WarMenu.IsItemSelected() then
        local result = exports['textbox']:open({
            {
                label = "Enter a reason",
                id = "result"
            }
        }).result
        if result then
            TriggerServerEvent("admin:warnPlayer", Data.SelectedPlayer, result)
        end
    end
    WarMenu.Button("Set Waypoint")
    if WarMenu.IsItemSelected() then
        local coords = RPC.execute('admin:getCoords', Data.SelectedPlayer.source)
        SetNewWaypoint(coords.x, coords.y)
    end
    WarMenu.Button("Teleport To Player")
    if WarMenu.IsItemSelected() then
        TriggerServerEvent("admin:teleportTo", Data.SelectedPlayer.source)
    end
    WarMenu.Button("Bring Player")
    if WarMenu.IsItemSelected() then
        TriggerServerEvent("admin:bringPlayer", Data.SelectedPlayer.source)
    end
    WarMenu.Button("Freeze Player")
    if WarMenu.IsItemSelected() then
        TriggerServerEvent("admin:freezePlayer", Data.SelectedPlayer.source, true)
    end
    WarMenu.Button("Unfreeze Player")
    if WarMenu.IsItemSelected() then
        TriggerServerEvent("admin:freezePlayer", Data.SelectedPlayer.source, false)
    end
    WarMenu.Button("Revive Player")
    if WarMenu.IsItemSelected() then
        TriggerServerEvent("admin:revivePlayer", Data.SelectedPlayer.source)
    end
    WarMenu.Button("")
    WarMenu.Button("Give Item")
    if WarMenu.IsItemSelected() then

        local result = exports['textbox']:open({
            {
                label = "Item ID",
                id = "id"
            },
            {
                label = "Amount of item",
                id = "amount"
            }
        })

        if result.id and result.amount then
            local success = RPC.execute('admin:giveItem', Data.SelectedPlayer.source, result.id, result.amount)
            print (result.id.." | "..result.amount)
            print ("Success: "..tostring(success))
            if not success then
                exports['alerts']:notify('Admin', "Could not give: "..result.id.." | "..result.amount, 'errorAlert')
            end
        end
    end
    WarMenu.Button("")
    WarMenu.Button("Kick Player")
    if WarMenu.IsItemSelected() then
        local result = exports['textbox']:open({
            {
                label = "Enter a reason",
                id = "reason"
            },
        }).reason

        TriggerServerEvent("admin:kickPlayer", Data.SelectedPlayer, result)
    end
    WarMenu.Button("Ban Player")
    if WarMenu.IsItemSelected() then
        banReason = ""
        secretReason = ""
        _comboBoxIndex = 1
        menuBeforeBanOptions = "admin_player_options"
        WarMenu.OpenMenu('admin_ban_options')
    end
end

function DrawText3D(x,y,z, text, selected)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.5, 0.5)
    SetTextFont(4)
    SetTextProportional(1)
    if not selected then SetTextColour(255, 255, 255, 255) else SetTextColour(66, 135, 245, 255) end

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 250
    DrawRect(_x,_y+0.0165, 0.015+ factor, 0.045, 41, 11, 41, 68)
end

function DrawPlayerList()
    for i,v in pairs (Data.Players) do
        local ped = GetPlayerPed(GetPlayerFromServerId(v.source))
        local pedPos
        local distance = math.huge
        if ped then
            pedPos = GetEntityCoords(ped)
            distance = #(pedPos - GetEntityCoords(playerPed))
        end

        WarMenu.Button("[" ..v.source.."] "..v.name.." | "..v.faction.." "..v.rank_name)

        if distance < 100.0 then
            DrawText3D(pedPos.x, pedPos.y, pedPos.z+0.9, ('['..v.source..'] '..v.name..' - '..v.character_name), WarMenu.IsItemHovered())
        end

        if WarMenu.IsItemSelected() then
            Data.SelectedPlayer = v
            WarMenu.SetMenuSubTitle('admin_player_options', "PID: "..Data.SelectedPlayer.pid.." | CID: "..Data.SelectedPlayer.cid.." | "..Data.SelectedPlayer.name.." | "..Data.SelectedPlayer.character_name)
            WarMenu.OpenMenu("admin_player_options")
        end
    end
end

local _timeToLength = {
    ['hour'] = 3600,
    ['day'] = 86400,
    ['week'] = 604800,
    ['month'] = 2592000,
    ['year'] = 31104000
}

local _nameToLength = {
    ['1 Hour'] = _timeToLength['hour']*1,
    ['3 Hours'] = _timeToLength['hour']*3,
    ['6 Hours'] = _timeToLength['hour']*6, 
    ['12 Hours'] = _timeToLength['hour']*12, 
    ['1 Day'] = _timeToLength['day'], 
    ['3 Days'] = _timeToLength['day']*3, 
    ['1 Week'] = _timeToLength['week'], 
    ['2 Weeks'] = _timeToLength['week']*2, 
    ['3 Weeks'] = _timeToLength['week']*3, 
    ['1 Month'] = _timeToLength['month'], 
    ['2 Months'] = _timeToLength['month']*2,
    ['3 Months'] = _timeToLength['month']*3,
    ['6 Months'] = _timeToLength['month']*6,
    ['~r~1 Year'] = _timeToLength['year'],
}

local _comboBoxItems = { '1 Hour', '3 Hours', '6 Hours', '12 Hours', '1 Day', '3 Days', '1 Week', '2 Weeks', '3 Weeks', '1 Month', '2 Months', '3 Months', '6 Months', '~r~1 Year' }
local menuBeforeBanOptions = "admin_player_options"

function DrawPlayerBanOptions()
    local _, comboBoxIndex = WarMenu.ComboBox('Length', _comboBoxItems, _comboBoxIndex)
    if _comboBoxIndex ~= comboBoxIndex then
        _comboBoxIndex = comboBoxIndex
    end

    if WarMenu.Button("Reason: "..banReason) then
        local result = exports['textbox']:open({
            {
                label = "Enter a reason",
                id = "reason"
            }
        }).reason
        if string.gsub(result, " ", "") == "" or result == "" then result = "None" end
        banReason = result
    end

    if WarMenu.Button("Secret Reason: "..secretReason) then
        local result = exports['textbox']:open({
            {
                label = "Secret reason (Player won't see this)",
                id = "reason"
            }
        }).reason
        if string.gsub(result, " ", "") == "" or result == "" then result = "None" end
        secretReason = result
    end

    if WarMenu.Button("~r~Ban Player") then
        local selectedLength = _nameToLength[_comboBoxItems[_comboBoxIndex]]
        TriggerServerEvent("admin:banPlayer", Data.SelectedPlayer, banReason, selectedLength, secretReason)
        WarMenu.OpenMenu('admin_players')
    end
end

function DrawPlayerVehicles()
    for i,v in pairs (Data.SelectedPlayerVehicles) do
        local vehicleName = GetDisplayNameFromVehicleModel(v.model)
        localizedName = GetLabelText(vehicleName)

        local status = v.inGarage == 1 and "In Garage" or v.inGarage == 0 and "~o~Outside" or v.inGarage == 2 and "~y~Impounded" or v.inGarage == 3 and "~r~Destroyed" or "Unknown"
        WarMenu.Button("VIN: "..v.vin.." | "..localizedName, status)
    end
end

function DrawPlayerWarnings()
    for i,v in pairs (Data.SelectedPlayerWarnings) do
        WarMenu.Button(v.warnDateString.." | Reason: "..v.reason)
    end
end

function DrawDisconnectedPlayers()
    for i,v in pairs (Data.DisconnectedPlayers) do
        if WarMenu.Button("["..v.source.."] "..v.name.." | Reason: "..v.reason) then
            Data.SelectedPlayer = v
            menuBeforeBanOptions = "admin_disconnected_players"
            WarMenu.OpenMenu("admin_ban_options")
        end
    end
end


function DrawVehicleOptions()
    local localizedName = "None Selected"

    if Data.SelectedVehicle ~= 0 then
        local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(Data.SelectedVehicle))
        localizedName = GetLabelText(vehicleName)    
    end

    if WarMenu.Button("Select Vehicle | "..localizedName..' ('..Data.SelectedVehicle..')') then
        if IsPedInAnyVehicle(playerPed) then
            Data.SelectedVehicle = GetVehiclePedIsIn(playerPed, false)
        else 
            Data.SelectedVehicle = exports['modules']:getModule("Game").GetVehicleInDirection() or 0
        end
    end

    if WarMenu.Button("Delete Vehicle") then
        if Data.SelectedVehicle ~= 0 then
            if DoesEntityExist(Data.SelectedVehicle) then
                exports['modules']:getModule("Game").DeleteVehicle(Data.SelectedVehicle)
            else
                Data.SelectedVehicle = 0
            end
        end
    end

    if WarMenu.Button("Fix Vehicle") then
        if Data.SelectedVehicle ~= 0 then
            if DoesEntityExist(Data.SelectedVehicle) then
                SetVehicleFixed(Data.SelectedVehicle)
                SetVehicleDeformationFixed(Data.SelectedVehicle)
                SetVehicleUndriveable(Data.SelectedVehicle, false)
            else
                Data.SelectedVehicle = 0
            end
        end
    end

    if WarMenu.Button("Get Keys") then
        if Data.SelectedVehicle ~= 0 then
            if DoesEntityExist(Data.SelectedVehicle) then
                exports['keys']:addKeys(Data.SelectedVehicle)
            else
                Data.SelectedVehicle = 0
            end
        end
    end

    if WarMenu.Button("Remove Keys") then
        if Data.SelectedVehicle ~= 0 then
            if DoesEntityExist(Data.SelectedVehicle) then
                exports['keys']:removeKeys(Data.SelectedVehicle)
            else
                Data.SelectedVehicle = 0
            end
        end
    end
end

local AdminMenus = {
    ["admin"] = DrawMain,
    ["admin_players"] = DrawPlayerList,
    ['admin_player_options'] = DrawPlayerOptions,
    ['admin_player_datas'] = DrawPlayerDatas,
    ['admin_player_vehicles'] = DrawPlayerVehicles,
    ['admin_player_warnings'] = DrawPlayerWarnings,
    ['admin_self_options'] = DrawSelfOptions,
    ['admin_ban_options'] = DrawPlayerBanOptions,
    ['admin_disconnected_players'] = DrawDisconnectedPlayers,
    ['admin_vehicle_options'] = DrawVehicleOptions
}

function MainLoop()
    while true do
        for i,v in pairs (AdminMenus) do
            if WarMenu.IsMenuOpened(i) then
                v()
            end
        end

        WarMenu.End()
        Wait(0)
    end
end

CreateThread(function()
    while true do
        local success, err = pcall(MainLoop)
        if not success then
            print (err)
            Wait(0)
        end
    end
end)

CreateThread(function()
    local rank = RPC.execute('admin:getMyRank')
    if not rank then return end
    adminRank = rank
    RegisterCommand("admin", function(source, args, raw)
        if WarMenu.IsAnyMenuOpened() then
            return
        end
    
        WarMenu.OpenMenu("admin")
    end)        
end)

RegisterNetEvent("_setCoords")
AddEventHandler("_setCoords", function(coords)
    local player = PlayerId()
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    SetEntityCoordsNoOffset(playerPed, coords.x, coords.y, coords.z, 0, 0, 2.0)
    FreezeEntityPosition(playerPed, true)
    SetPlayerInvincible(player, true)

    local startedCollision = GetGameTimer()

    while not HasCollisionLoadedAroundEntity(playerPed) do
        if GetGameTimer() - startedCollision > 5000 then break end
        Citizen.Wait(0)
    end

    FreezeEntityPosition(playerPed, false)
    SetPlayerInvincible(player, false)

    SetPedCoordsKeepVehicle(playerPed, coords.x, coords.y, coords.z)
end)

local frozen = false
RegisterNetEvent("_freezePlayer")
AddEventHandler("_freezePlayer", function(enable)
    frozen = enable
    FreezeEntityPosition(playerPed, enable)
    if IsPedInAnyVehicle(playerPed) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        FreezeEntityPosition(vehicle, enable)
        if frozen then
            CreateThread(function()
                while frozen do
                    DisableInputGroup(0)
                    DisableInputGroup(1)
                    DisableInputGroup(2)
                    Wait(0)
                end
            end)
        end
    end
end)

local GetVehiclesInArea = exports['modules']:getModule("Game").GetVehiclesInArea

CreateThread(function()
    while true do
        if noclip then
            local Scale = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
            while not HasScaleformMovieLoaded(Scale) do Wait(0) end

            local MovingSpeed = 0.5
            while noclip do
                local noclipEntity = IsPedInAnyVehicle(playerPed) and GetVehiclePedIsIn(playerPed) or playerPed

                FreezeEntityPosition(noclipEntity, true);
                SetEntityInvincible(noclipEntity, true);

                local newPos = vec3(0,0,0);

                DisableControlAction(0, 32, true);
                DisableControlAction(0, 268, true);
                DisableControlAction(0, 31, true);
                DisableControlAction(0, 269, true);
                DisableControlAction(0, 33, true);
                DisableControlAction(0, 266, true);
                DisableControlAction(0, 34, true);
                DisableControlAction(0, 30, true);
                DisableControlAction(0, 267, true);
                DisableControlAction(0, 35, true);
                DisableControlAction(0, 44, true);
                DisableControlAction(0, 20, true);
                DisableControlAction(0, 74, true);

                if IsPedInAnyVehicle(playerPed) then
                    DisableControlAction(0, 85, true);
                end

                if (IsControlJustPressed(0, 21)) then
                    MovingSpeed = MovingSpeed == 0.5 and 3.5 or 0.5
                end

                local wHeld = false
                local sHeld = false
                
                local qHeld = false
                local qHeld = false

                if (IsDisabledControlPressed(0, 44)) then
                    qHeld = true
                else
                    qHeld = false
                end
                if (IsDisabledControlPressed(0, 20)) then
                    zHeld = true
                else
                    zHeld = false
                end
                if (IsDisabledControlPressed(0, 32)) then
                    wHeld = true
                else
                    wHeld = false
                end
                if (IsDisabledControlPressed(0, 33)) then
                    sHeld = true
                else
                    sHeld = false
                end
                
                local moveSpeed = MovingSpeed;
                
                moveSpeed = moveSpeed / (1.0 / GetFrameTime()) * 60;
                
                local position = GetEntityCoords(noclipEntity)
                local direction = GetEntityForwardVector(noclipEntity)

                if wHeld then        
                    SetEntityCoords(noclipEntity, position.x + GetEntityForwardX(noclipEntity)*moveSpeed, position.y + GetEntityForwardY(noclipEntity)*moveSpeed, (position.z - 1), false, false, false, false)
                elseif sHeld then
                    SetEntityCoords(noclipEntity, position.x - GetEntityForwardX(noclipEntity)*moveSpeed, position.y - GetEntityForwardY(noclipEntity)*moveSpeed, (position.z - 1), false, false, false, false)
                end

                if qHeld then
                    SetEntityCoords(noclipEntity, position.x, position.y, ((position.z - 1) + 0.5*moveSpeed), true, true, true, false)
                elseif zHeld then
                    SetEntityCoords(noclipEntity, position.x, position.y, ((position.z - 1) - 0.5*moveSpeed), true, true, true, false)
                end

                local heading = GetEntityHeading(noclipEntity)

                SetEntityVelocity(noclipEntity, 0, 0, 0);
                SetEntityRotation(noclipEntity, 0, 0, 0, 0, false);

                local xHeading = GetGameplayCamRelativeHeading()
                SetEntityHeading(noclipEntity, xHeading)

                SetEntityCollision(noclipEntity, false, false);
                SetEntityVisible(noclipEntity, false, false);
                SetLocalPlayerVisibleLocally(true);
                SetEntityAlpha(noclipEntity, 51, 0);
                SetEveryoneIgnorePlayer(playerPed, true);
                SetPoliceIgnorePlayer(playerPed, true);

                Wait(0)

                FreezeEntityPosition(noclipEntity, false);
                SetEntityInvincible(noclipEntity, false);
                SetEntityCollision(noclipEntity, true, true);

                SetEntityVisible(noclipEntity, true, false);
                SetLocalPlayerVisibleLocally(true);
                ResetEntityAlpha(noclipEntity);

                SetEveryoneIgnorePlayer(playerPed, false);
                SetPoliceIgnorePlayer(playerPed, false);
            end
        end
        Wait(0)
    end 
end)

local ForbiddenClientEvents = {
    "ambulancier:selfRespawn",
    "bank:transfer",
    "esx_ambulancejob:revive",
    "esx-qalle-jail:openJailMenu",
    "esx_jailer:wysylandoo",
    "esx_policejob:getarrested",
    "esx_society:openBossMenu",
    "esx:spawnVehicle",
    "esx_status:set",
    "HCheat:TempDisableDetection",
    "UnJP",
}

local alreadyBanned = false
for i,event in pairs (ForbiddenClientEvents) do
    AddEventHandler(event, function(cb)
        if alreadyBanned then 
            CancelEvent()
            if type(cb) == "function" then cb(nil) end
            return 
        end
        
        alreadyBanned = true
        TriggerServerEvent("admin:banMyAss", "Forbidden Event: "..event, 7776000)
    end)
end