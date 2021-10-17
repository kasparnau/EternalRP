local players = exports['players']
local game = exports['modules']:getModule("Game")

local player = PlayerId()
local playerPed = PlayerPedId()

players:SetClientVar("isDead", false)

local localPlayer = Player(GetPlayerServerId(PlayerId()))
localPlayer.state:set('isDead', false, true)

TriggerEvent('chat:addSuggestion', '/revive', 'Revive kedagi või ennast', {
    { name="Target Player", help="Server ID" },
})

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        Citizen.Wait(1)
    end
end

local DeathAnimPlaying = false
function DeathAnim()
    if DeathAnimPlaying or players:GetClientVar("beingDragged") then return end
    DeathAnimPlaying = true
    CreateThread(function()
        while (IsPedRagdoll(PlayerPedId()) and GetEntitySpeed(PlayerPedId()) > 0.5) and not IsEntityInWater(PlayerPedId()) do
            Citizen.Wait(1)
        end

        if not IsPedInAnyVehicle(PlayerPedId()) then
            if not IsEntityInWater(PlayerPedId()) then
                loadAnimDict("dead")
                SetEntityCoords(PlayerPedId(), GetEntityCoords(PlayerPedId()))
                ClearPedTasksImmediately(PlayerPedId())
                TaskPlayAnim(PlayerPedId(), "dead", "dead_a", 8.0, 8.0, -1, 1, 0, 0, 0, 0)    
            else
                --SetEntityCoords(PlayerPedId(), GetEntityCoords(PlayerPedId()))
                SetPedToRagdoll(PlayerPedId(), 26000, 26000, 3, 0, 0, 0)     
            end
        end

        Wait(1000)
        DeathAnimPlaying = false
    end)
end

function CarDeathAnim()
    loadAnimDict("veh@low@front_ps@idle_duck") 
    TaskPlayAnim(PlayerPedId(), "veh@low@front_ps@idle_duck", "sit", 8.0, -8, -1, 1, 0, 0, 0, 0)                     
end

local inGame = players:GetClientVar("inGame") 
local isDead = isDead

AddEventHandler("players:ClientVarChanged", function(name, old, new)
    if name == 'inGame' then
        inGame = new
    elseif name == 'isDead' then
        isDead = new
    end
end)

local EHeldTimer = 500
local DeadTimer = 300

function MainLoop()
    while true do
        Wait(1)
        if inGame and not isDead and IsEntityDead(PlayerPedId()) then
            players:SetClientVar("isDead", true)
            TriggerServerEvent("death:died")
            localPlayer.state:set('isDead', true, true)

            EHeldTimer = 500
            DeadTimer = 300

            --//* DISABLE ALL ACTIONS
            CreateThread(function()
                while exports['players']:GetClientVar("inGame") and isDead do
                    DisableInputGroup(0)
                    DisableInputGroup(1)
                    DisableInputGroup(2)

                    Wait(0)
                end
            end)

            local ragDollTimer = 0
            while (IsPedRagdoll(PlayerPedId()) and GetEntitySpeed(PlayerPedId()) > 0.5) and not IsEntityInWater(PlayerPedId()) and ragDollTimer < (10*1000) do
                ragDollTimer = ragDollTimer + 1
                Citizen.Wait(1)
            end
            
            Citizen.Wait(100)

            local seat = 0

            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            local vehmodel = GetEntityModel(veh)

            if veh ~= 0 then
                local vehmodel = GetEntityModel(veh)
                for i = -1, GetVehicleModelNumberOfSeats(vehmodel) do
                    if GetPedInVehicleSeat(veh, i) == PlayerPedId() then
                        seat = i
                        break
                    end
                end
            end

            local plyPos = GetEntityCoords(PlayerPedId())
            NetworkResurrectLocalPlayer(plyPos, true, true, false)   

            if veh ~= 0 then
                TaskWarpPedIntoVehicle(PlayerPedId(),veh,seat)
                CreateThread(function()
                    while exports['players']:GetClientVar("inGame") and isDead do
                        local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                        Wait(300)
                        if PlayerPedId() ==  GetPedInVehicleSeat(currentVehicle, -1) then
                            SetVehicleUndriveable(currentVehicle,true)
                        end    
                    end
                end)
            end

            DeathAnim()

            CreateThread(function()
                while isDead and inGame and not exports['players']:GetClientVar("beingEscorted") do
                    local inWater = IsEntityInWater(PlayerPedId())
                    if IsPedInAnyVehicle(PlayerPedId()) then
                        CarDeathAnim()
                    --elseif not IsEntityPlayingAnim(PlayerPedId(), "dam_ko", "drown", 1) and inWater then
                        --DeathAnim()
                    elseif players:GetClientVar("inTrunk") or (inveh == 0 and GetEntityHeightAboveGround(PlayerPedId()) < 2.0) then
                        DeathAnim()
                    elseif not IsPedInAnyVehicle(PlayerPedId()) then
                        if (IsPedRagdoll(PlayerPedId()) and not inWater) or (not IsEntityPlayingAnim(PlayerPedId(), "dead", "dead_a", 1) and not inWater) then
                            DeathAnim()
                        elseif (not IsEntityPlayingAnim(PlayerPedId(), "dam_ko", "drown", 1) and inWater) then
                            DeathAnim()
                        end
                    end
                    Wait(1)
                end

                SetEntityInvincible(PlayerPedId(), false)
            end)

            while isDead and inGame do
                SetEntityInvincible(PlayerPedId(), true)
                SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
    
                DeadTimer = DeadTimer - 0.01
                if DeadTimer % 60 == 0 then
                    exports['policeAlerts']:alert("death")
                end

                -- drawTxt(0.89, 1.38, 1.0,1.0,0.6, "EMS AND LAW ENFORCEMENT HAVE BEEN ALERTED", 255, 255, 255, 255)

                if DeadTimer > 0 then
                    drawTxt(0.89, 1.42, 1.0,1.0,0.6, "Respawn: ~r~" .. math.ceil(DeadTimer) .. "~w~ sekundit veel", 255, 255, 255, 255)
                else
                    drawTxt(0.89, 1.42, 1.0,1.0,0.6, "~w~HOIA ~r~E ~w~(" .. math.ceil(EHeldTimer/100) .. ") ~w~ET ~r~RESPAWNIDA ~w~VÕI OOTA ~r~EMS-i", 255, 255, 255, 255)
                end

                if IsControlPressed(1,38) then
                    local hspDist = #(vector3(307.93017578125,-594.99530029297,43.291835784912) - GetEntityCoords(PlayerPedId()))
                    EHeldTimer = EHeldTimer - 1
                    if hspDist > 5 and EHeldTimer <= 0 then
                        EHeldTimer = 0
                        DeadTimer = 99999999
                        respawn()
                    end
                else
                    EHeldTimer = 500
                end
    
                Wait(1)
            end
        end
    end
end

CreateThread(function()
    while true do
        local success, err = pcall(MainLoop)
        if not success then
            print (err)
        end
        Wait(0)
    end
end)

function respawn()
    local character = players:GetClientVar("character")

    local status = json.decode(character.status)
    status.health = GetEntityMaxHealth(PlayerPedId())
    status.armor = 0
    if status.hunger and status.hunger < 20 then
        status.hunger = 30
    end
    if status.hunger and status.thirst < 20 then
        status.thirst = 30
    end
    TriggerServerEvent("status:updateStatus", status.health, status.armor, status.thirst,status.hunger)

    players:SetClientVar("isDead", false)
    localPlayer.state:set('isDead', false, true)
    -- isDead = false
    EHeldTimer = 500
    DeadTimer = 300

    ClearPedTasksImmediately(PlayerPedId())
    exports['alerts']:notify('Pillbox Medical', "Haigla töötajad äratasid teid ellu.", "infoAlert", 10000)
    FreezeEntityPosition(PlayerPedId(), false)

    if character.jail_time <= 0 then
        TriggerServerEvent("status:updatePos", {
            x = 357.43,
            y = -593.36,
            z = 28.79,
            heading = GetEntityHeading(PlayerPedId())
        })
        game.Teleport(PlayerPedId(), {x=357.43, y=-593.36, z=28.79})
    else
        game.Teleport(PlayerPedId(), {x=1779.1911621094,y=2583.5473632812,z=45.792724609375})
    end

    SetEntityInvincible(PlayerPedId(), false)
    ClearPedBloodDamage(PlayerPedId())
    RemoveAllPedWeapons(PlayerPedId())
    SetCurrentPedWeapon(ply, `WEAPON_UNARMED`, true)

    local plyPos = GetEntityCoords(PlayerPedId(),  true)
    NetworkResurrectLocalPlayer(plyPos, true, true, false)
    SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
    SetPedArmour(PlayerPedId(), 0)

    local outfit = json.decode(players:GetClientVar("character").outfit)
    TriggerEvent("clothes:setCharacterClothes", outfit)

    TriggerServerEvent("death:respawned")
    TriggerEvent("death:respawned")

    TriggerServerEvent("death:live")
end

exports('respawn', respawn)

AddEventHandler('onClientMapStart', function()
	exports.spawnmanager:setAutoSpawn(false)
end)

RegisterNetEvent("death:revivePlayer")
AddEventHandler("death:revivePlayer", function()
    local character = exports['players']:GetClientVar("character")

    local status = json.decode(character.status)
    status.health = GetEntityMaxHealth(PlayerPedId())
    status.armor = 0
    if status.hunger and status.hunger < 20 then
        status.hunger = 30
    end
    if status.hunger and status.thirst < 20 then
        status.thirst = 30
    end
    TriggerServerEvent("status:updateStatus", status.health, status.armor, status.thirst,status.hunger)

    localPlayer.state:set('isDead', false, true)
    players:SetClientVar("isDead", false)

    EHeldTimer = 500
    DeadTimer = 3

    local playerPos = GetEntityCoords(PlayerPedId(), true)
    NetworkResurrectLocalPlayer(playerPos, true, true, false)
    SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
    SetPedArmour(PlayerPedId(), 0)

    SetPlayerInvincible(PlayerPedId(), false)
    ClearPedBloodDamage(PlayerPedId())
    ClearPedTasksImmediately(PlayerPedId())

    ClearPedSecondaryTask(PlayerPedId())
    loadAnimDict("random@crash_rescue@help_victim_up") 
    TaskPlayAnim(PlayerPedId(), "random@crash_rescue@help_victim_up", "helping_victim_to_feet_victim", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    SetCurrentPedWeapon(PlayerPedId(),`WEAPON_UNARMED`,true)

    TriggerServerEvent("death:revived")
    TriggerEvent("death:revived")

    TriggerServerEvent("death:live")

    Wait(500)
    ClearPedSecondaryTask(PlayerPedId())
end)