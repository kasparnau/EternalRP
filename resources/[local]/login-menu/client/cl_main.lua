enabled = false
currentChar = nil
currentPed = nil
function showUi()
    enabled = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        show = true
    })
end

function hideUi()
    enabled = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        show = false
    })
end

function openMenu()
    exports['interaction']:hide()
    exports['players']:SetClientVar("inGame", false)
    exports['players']:SetClientVar("isDead", false)
    Player(GetPlayerServerId(PlayerId())).state:set('isDead', false, true)
    exports['players']:SetClientVar("inTrunk", false)
    exports['players']:SetClientVar("isCuffed", false)
    Player(GetPlayerServerId(PlayerId())).state:set('isCuffed', false, true)
    exports['players']:SetClientVar("beingEscorted", false)
    exports['players']:SetClientVar("character", nil)

    RPC.execute('inMenu')

    showUi()

    Citizen.CreateThread(function()
        PlayerPed = PlayerPedId()
        while enabled do
            HideHudAndRadarThisFrame()
            DisableAllControlActions(0)
            TaskSetBlockingOfNonTemporaryEvents(PlayerPedId(), true)
            Citizen.Wait(0)
        end
    end)
end

function closeMenu()
    hideUi()

    ClearSpawnedPeds()
    EnableAllControlActions(0)
    TaskSetBlockingOfNonTemporaryEvents(PlayerPedId(), false)
    SetNuiFocus(false, false)
end

RegisterNUICallback('nuiAction', function(data, cb)
    local action = data.action
    local content = data.data
    print ("NuiAction | "..json.encode(data))

    if action == 'fetchCharacters' then
        local succ = RPC.execute('login:fetchCharacters')
        CreatePlayerCharacterPeds(succ)
        cb(succ)
    elseif action == 'createCharacter' then
        local succ = RPC.execute('login:createCharacter', data.data)
        cb(succ)
    elseif action == 'selectCharacter' then
        if currentChar then
            local data = RPC.execute('login:selectCharacter', currentChar.character_id)
            cb(data ~= false)
            local LocalPlayer = exports['players']:SetClientVar("character", data)

            local PlayerPed = PlayerPedId()
            SetPlayerInvincible(PlayerPed, true)

            closeMenu()

            SetPlayerInvincible(PlayerPed, false)
            TriggerEvent("login:firstSpawn", LocalPlayer)

            exports['jp-weather']:toggle(true)
            exports['jp-weather']:forceUpdate()    
        end
    elseif action == 'click' then
        local loginCam = exports['spawn_manager']:GetLoginCam()
        local hit, endCoords, surface, entity = screenToWorld(8, PlayerPedId(), GetCamCoord(loginCam))
        local found

        if (hit and entity and entity ~= 0) then
            for _,v in pairs (currentPedChoices) do
                if (v.ped == entity) then
                    found = v
                    break
                end
            end
        end

        if found then
            currentChar = found.char
            currentPed = found.ped
            SendNUIMessage({
                setCurrent = found.char
            })
        end
    end
end)

AddEventHandler("spawnmanager:spawnInitialized", function()
    ShutdownLoadingScreenNui()
    -- Wait(500) --* ARBITRARY WAIT BEFORE OPENING CHARACTER SELECTION MENU
    openMenu()
end)

exports('openMenu', function()
    exports['spawn_manager']:doInitialize()
end)

RegisterCommand("log", function()
    if not enabled then 
        exports['spawn_manager']:doInitialize()
    else 
        closeMenu() 
    end
end)

CreateThread(function()
    exports['spawn_manager']:doInitialize()
end)