local enabled = false

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

    EnableAllControlActions(0)
    TaskSetBlockingOfNonTemporaryEvents(PlayerPedId(), false)
    SetNuiFocus(false, false)
end

RegisterNUICallback('nuiAction', function(data, cb)
    if data.action == 'fetchCharacters' then
        local succ = RPC.execute('login:fetchCharacters')
        cb(succ)
    elseif data.action == 'createCharacter' then
        local succ = RPC.execute('login:createCharacter', data.data)
        cb(succ)
    elseif data.action == 'selectCharacter' then
        local data = RPC.execute('login:selectCharacter', data.data.citizen_id)
        cb(data ~= false)

        local LocalPlayer = exports['players']:SetClientVar("character", data)

        local PlayerPed = PlayerPedId()
        SetPlayerInvincible(PlayerPed, true)

        closeMenu()

        SetPlayerInvincible(PlayerPed, false)
        TriggerEvent("login:firstSpawn", LocalPlayer)
    end
end)

AddEventHandler("spawnmanager:spawnInitialized", function()
    ShutdownLoadingScreenNui()
    Wait(500) --* ARBITRARY WAIT BEFORE OPENING CHARACTER SELECTION MENU
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
