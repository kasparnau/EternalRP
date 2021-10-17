function doInitialize()
    FreezeEntityPosition(PlayerPedId(), true)

    TransitionToBlurred(100)
    DoScreenFadeOut(100)

    ShutdownLoadingScreen()

    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)

    SetCamRot(cam, -10.0, 0.0, -77.0, 2)
    SetCamCoord(cam, -2091.6000976562,-1265.8022460938,147.39709472656)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)

    local ped = PlayerPedId()

    SetEntityCoordsNoOffset(ped, -2091.6000976562,-1265.8022460938,147.39709472656, false, false, false, true)

    SetEntityVisible(ped, false)

    TriggerEvent("spawnmanager:spawnInitialized")
    TriggerServerEvent("spawnmanager:spawnInitialized")

    DoScreenFadeIn(500)

    while IsScreenFadingIn() do
        Wait(0)
    end
end

exports('doInitialize', doInitialize)

function Initialize()
    CreateThread(function()
        doInitialize()
    end)
end

AddEventHandler("players:playerSessionStarted", function()
    Initialize()

    for i = 1, 25 do
        EnableDispatchService(i, false)
    end

    for i,v in ipairs (GetActivePlayers()) do
        local ped = GetPlayerPed(v)
        if ped ~= nil then
            SetCanAttackFriendly(ped, true, true)
        end
    end
    
    local playerId = PlayerId()

    CreateThread(function()
        while true do
            Wait(1)
            DisablePlayerVehicleRewards(playerId)
        end
    end)

    NetworkSetFriendlyFireOption(true)

    local pickupList = {`PICKUP_AMMO_BULLET_MP`,`PICKUP_AMMO_FIREWORK`,`PICKUP_AMMO_FLAREGUN`,`PICKUP_AMMO_GRENADELAUNCHER`,`PICKUP_AMMO_GRENADELAUNCHER_MP`,`PICKUP_AMMO_HOMINGLAUNCHER`,`PICKUP_AMMO_MG`,`PICKUP_AMMO_MINIGUN`,`PICKUP_AMMO_MISSILE_MP`,`PICKUP_AMMO_PISTOL`,`PICKUP_AMMO_RIFLE`,`PICKUP_AMMO_RPG`,`PICKUP_AMMO_SHOTGUN`,`PICKUP_AMMO_SMG`,`PICKUP_AMMO_SNIPER`,`PICKUP_ARMOUR_STANDARD`,`PICKUP_CAMERA`,`PICKUP_CUSTOM_SCRIPT`,`PICKUP_GANG_ATTACK_MONEY`,`PICKUP_HEALTH_SNACK`,`PICKUP_HEALTH_STANDARD`,`PICKUP_MONEY_CASE`,`PICKUP_MONEY_DEP_BAG`,`PICKUP_MONEY_MED_BAG`,`PICKUP_MONEY_PAPER_BAG`,`PICKUP_MONEY_PURSE`,`PICKUP_MONEY_SECURITY_CASE`,`PICKUP_MONEY_VARIABLE`,`PICKUP_MONEY_WALLET`,`PICKUP_PARACHUTE`,`PICKUP_PORTABLE_CRATE_FIXED_INCAR`,`PICKUP_PORTABLE_CRATE_UNFIXED`,`PICKUP_PORTABLE_CRATE_UNFIXED_INCAR`,`PICKUP_PORTABLE_CRATE_UNFIXED_INCAR_SMALL`,`PICKUP_PORTABLE_CRATE_UNFIXED_LOW_GLOW`,`PICKUP_PORTABLE_DLC_VEHICLE_PACKAGE`,`PICKUP_PORTABLE_PACKAGE`,`PICKUP_SUBMARINE`,`PICKUP_VEHICLE_ARMOUR_STANDARD`,`PICKUP_VEHICLE_CUSTOM_SCRIPT`,`PICKUP_VEHICLE_CUSTOM_SCRIPT_LOW_GLOW`,`PICKUP_VEHICLE_HEALTH_STANDARD`,`PICKUP_VEHICLE_HEALTH_STANDARD_LOW_GLOW`,`PICKUP_VEHICLE_MONEY_VARIABLE`,`PICKUP_VEHICLE_WEAPON_APPISTOL`,`PICKUP_VEHICLE_WEAPON_ASSAULTSMG`,`PICKUP_VEHICLE_WEAPON_COMBATPISTOL`,`PICKUP_VEHICLE_WEAPON_GRENADE`,`PICKUP_VEHICLE_WEAPON_MICROSMG`,`PICKUP_VEHICLE_WEAPON_MOLOTOV`,`PICKUP_VEHICLE_WEAPON_PISTOL`,`PICKUP_VEHICLE_WEAPON_PISTOL50`,`PICKUP_VEHICLE_WEAPON_SAWNOFF`,`PICKUP_VEHICLE_WEAPON_SMG`,`PICKUP_VEHICLE_WEAPON_SMOKEGRENADE`,`PICKUP_VEHICLE_WEAPON_STICKYBOMB`,`PICKUP_WEAPON_ADVANCEDRIFLE`,`PICKUP_WEAPON_APPISTOL`,`PICKUP_WEAPON_ASSAULTRIFLE`,`PICKUP_WEAPON_ASSAULTSHOTGUN`,`PICKUP_WEAPON_ASSAULTSMG`,`PICKUP_WEAPON_AUTOSHOTGUN`,`PICKUP_WEAPON_BAT`,`PICKUP_WEAPON_BATTLEAXE`,`PICKUP_WEAPON_BOTTLE`,`PICKUP_WEAPON_BULLPUPRIFLE`,`PICKUP_WEAPON_BULLPUPSHOTGUN`,`PICKUP_WEAPON_CARBINERIFLE`,`PICKUP_WEAPON_COMBATMG`,`PICKUP_WEAPON_COMBATPDW`,`PICKUP_WEAPON_COMBATPISTOL`,`PICKUP_WEAPON_COMPACTLAUNCHER`,`PICKUP_WEAPON_COMPACTRIFLE`,`PICKUP_WEAPON_CROWBAR`,`PICKUP_WEAPON_DAGGER`,`PICKUP_WEAPON_DBSHOTGUN`,`PICKUP_WEAPON_FIREWORK`,`PICKUP_WEAPON_FLAREGUN`,`PICKUP_WEAPON_FLASHLIGHT`,`PICKUP_WEAPON_GRENADE`,`PICKUP_WEAPON_GRENADELAUNCHER`,`PICKUP_WEAPON_GUSENBERG`,`PICKUP_WEAPON_GOLFCLUB`,`PICKUP_WEAPON_HAMMER`,`PICKUP_WEAPON_HATCHET`,`PICKUP_WEAPON_HEAVYPISTOL`,`PICKUP_WEAPON_HEAVYSHOTGUN`,`PICKUP_WEAPON_HEAVYSNIPER`,`PICKUP_WEAPON_HOMINGLAUNCHER`,`PICKUP_WEAPON_KNIFE`,`PICKUP_WEAPON_KNUCKLE`,`PICKUP_WEAPON_MACHETE`,`PICKUP_WEAPON_MACHINEPISTOL`,`PICKUP_WEAPON_MARKSMANPISTOL`,`PICKUP_WEAPON_MARKSMANRIFLE`,`PICKUP_WEAPON_MG`,`PICKUP_WEAPON_MICROSMG`,`PICKUP_WEAPON_MINIGUN`,`PICKUP_WEAPON_MINISMG`,`PICKUP_WEAPON_MOLOTOV`,`PICKUP_WEAPON_MUSKET`,`PICKUP_WEAPON_NIGHTSTICK`,`PICKUP_WEAPON_PETROLCAN`,`PICKUP_WEAPON_PIPEBOMB`,`PICKUP_WEAPON_PISTOL`,`PICKUP_WEAPON_PISTOL50`,`PICKUP_WEAPON_POOLCUE`,`PICKUP_WEAPON_PROXMINE`,`PICKUP_WEAPON_PUMPSHOTGUN`,`PICKUP_WEAPON_RAILGUN`,`PICKUP_WEAPON_REVOLVER`,`PICKUP_WEAPON_RPG`,`PICKUP_WEAPON_SAWNOFFSHOTGUN`,`PICKUP_WEAPON_SMG`,`PICKUP_WEAPON_SMOKEGRENADE`,`PICKUP_WEAPON_SNIPERRIFLE`,`PICKUP_WEAPON_SNSPISTOL`,`PICKUP_WEAPON_SPECIALCARBINE`,`PICKUP_WEAPON_STICKYBOMB`,`PICKUP_WEAPON_STUNGUN`,`PICKUP_WEAPON_SWITCHBLADE`,`PICKUP_WEAPON_VINTAGEPISTOL`,`PICKUP_WEAPON_WRENCH`, `PICKUP_WEAPON_RAYCARBINE`}
    CreateThread(function()
        for i = 1, #pickupList do
            ToggleUsePickupsForPlayer(playerId, pickupList[i], false)
        end
    end)

    Citizen.CreateThread(function()
        while true do
            Wait(1000)

            SetPlayerWantedLevel(playerId, 0, false)
            SetPlayerWantedLevelNow(playerId, false)
        end
    end)

    SetPoliceIgnorePlayer(PlayerPedId(), true)

    Citizen.CreateThread(function()
        while true do
            RemoveMultiplayerHudCash(0x968F270E39141ECA)
            RemoveMultiplayerBankCash(0xC7C6789AA1CFEDD0)
            Wait(100)
        end
    end)
    --SetPoliceIgnorePlayer(playerPed,true)
    --SetPoliceIgnorePlayer(playerId,true)
end)

function InitialSpawn(plrData)
    CreateThread(function()
        DisableAllControlActions(0)

        TransitionToBlurred(100)        
        DoScreenFadeOut(50)

        while IsScreenFadingOut() do
            Wait(0)
        end

        local character = exports['players']:GetClientVar("character")
        local status = exports['status']:get()

        local spawn = exports['modules']:getModule("Enums").SpawnLocations.Initial[1]

        if character.jail_time > 0 then
            spawn[1] = 1714.8264160156
            spawn[2] = 2517.4814453125
            spawn[3] = 45.556762695312
            spawn[4] = 0.0
        else
            local charPos = character.position and json.decode(character.position) or false
            if charPos then
                if not (charPos.x == 0 and charPos.y == 0 and charPos.z == 0) then
                    local gotCoords, safeCoords = GetSafeCoordForPed(charPos.x, charPos.y, charPos.z, true, 16)
                    if gotCoords then
                        spawn[1] = safeCoords.x
                        spawn[2] = safeCoords.y
                        spawn[3] = safeCoords.z
                    else
                        spawn[1] = charPos.x
                        spawn[2] = charPos.y
                        spawn[3] = charPos.z
                    end
                end
                spawn[4] = charPos.heading
            end
        end

        if not character.outfit or (json.decode(character.outfit) and json.decode(character.outfit).new) then
            spawn = exports['modules']:getModule("Enums").SpawnLocations.CharacterCreation[1]
        end

        spawn = {
            model = "mp_m_freemode_01",
            x = spawn[1],
            y = spawn[2],
            z = spawn[3],
            heading = spawn[4]
        }

        TriggerEvent("spawnmanager:initialSpawnModelLoaded")

        RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)

        local ped = PlayerPedId()

        SetEntityCoordsNoOffset(ped, spawn.x, spawn.y, spawn.z, false, false, false, true)

        SetEntityVisible(ped, true)
        FreezeEntityPosition(ped, false)

        NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading, true, true, false)

        SetTimecycleModifier('default')

        ClearPedTasksImmediately(ped)
        RemoveAllPedWeapons(ped)
        --ClearPlayerWantedLevel(PlayerId())

        local startedCollision = GetGameTimer()

        while not HasCollisionLoadedAroundEntity(ped) do
            if GetGameTimer() - startedCollision > 8000 then break end
            Wait(0)
        end

        TriggerEvent("clothes:setCharacterClothes", json.decode(character.outfit), character.gender)
        TriggerEvent("spawnmanager:playerSpawned")

        SetEntityMaxHealth(PlayerPedId(), 200)
        SetEntityHealth(PlayerPedId(), status.health)

        if character.dead == 1 then
            exports['death']:respawn()
        end

        Wait(1000) --* WAIT FOR CLOTHES TO BE SET ETC
        DoScreenFadeIn(250)

        while IsScreenFadingIn() do
            Wait(0)
        end

        TransitionFromBlurred(100)
        EnableAllControlActions(0)

        exports['players']:SetClientVar("inGame", true)
    end)
end

AddEventHandler("login:firstSpawn", function(plrData)
    InitialSpawn(plrData)

    CreateThread(function()
        Wait(600)
        DestroyAllCams(true)
        RenderScriptCams(false, true, 1, true, true)
        FreezeEntityPosition(PlayerPedId(), false)
    end)
end)