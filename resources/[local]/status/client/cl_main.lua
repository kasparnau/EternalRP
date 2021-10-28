Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)

local IsInVehicle
local playerPed = PlayerPedId()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsInVehicle then
            DisplayRadar(true)
        else
            DisplayRadar(false)
        end
    end
end)

local Health = GetEntityHealth(playerPed)
local Armour = GetPedArmour(playerPed)
local MaxHealth = GetEntityMaxHealth(playerPed)

AddEventHandler("jp:onPedChange", function(ped)
    playerPed = ped
    MaxHealth = GetEntityMaxHealth(playerPed)

    if character and character.status then
        local status = json.decode(character.status)
        if status.health then
            SetEntityHealth(ped, status.health)
        else
            SetEntityHealth(ped, GetEntityMaxHealth(ped))
        end
        if status.armor then
            SetPedArmour(ped, status.armor)
        else
            SetPedArmour(ped, 0)
        end
    end
end)


CreateThread(function() --! IF INGAME ALREADY (AKA RESTARTED SCRIPT)
    Wait(500)

    local plrData = exports['players']:GetClientVar("character")
    if plrData and plrData.status then
        local status = json.decode(plrData.status)
        if not status.hunger then status.hunger = 100 end
        if not status.thirst then status.thirst = 100 end
        if not status.health then status.health = 100 end
        if not status.armor then status.armor = 100 end
        SendNUIMessage({
            update = true,

            name = "hunger",
            progress = status.hunger,
        })
        SendNUIMessage({
            update = true,

            name = "thirst",
            progress = status.thirst,
        })

        updateHealthStatus(status.health)
        updateArmorStatus(status.armor)
    end
end)

function updateHealthStatus(healthVal)
    if healthVal > 100 then healthVal = 100 end
    if healthVal < 0 or exports['players']:GetClientVar('isDead') then healthVal = 0 end

    local healthCol

    if healthVal > 75 then
        healthCol = '#3bb174'
    elseif healthVal > 50 then
        healthCol = '#c4ba60'
    elseif healthVal > 25 then
        healthCol = '#b13f3b'
    else
        healthCol = "#d61f1f"
    end

    SendNUIMessage({    
        update = true,
        name = "health",
        progress = healthVal,
        color = healthCol
    })
end

function updateArmorStatus(armorVal)
    local visible = false

    if armorVal >= 100 then armorVal = 100 end
    if armorVal <= 0 then armorVal = 0 else visible = true end

    SendNUIMessage({
        update = true,
        name = "armor",
        progress = armorVal,
        visible = visible
    })
end

local wasShowing = false

Citizen.CreateThread(function() --* DISPLAY STUFF
    local waitTime = 250
    while true do
        Citizen.Wait(waitTime)

        local playerPed = PlayerPedId()

        local plrData = exports['players']:GetClientVar("character")

        if plrData then
            waitTime = 500

            if not wasShowing then
                SendNUIMessage({
                    show = true
                })
                wasShowing = true
            end

            Health = GetEntityHealth(playerPed)
            Armour = GetPedArmour(playerPed)
            IsInVehicle = IsPedInAnyVehicle(playerPed, false)

            local healthVal = Health - 100
            if healthVal > 100 then healthVal = 100 end
            if healthVal < 0 or exports['players']:GetClientVar('isDead') then healthVal = 0 end

            local healthCol

            if healthVal > 75 then
                healthCol = '#3bb174'
            elseif healthVal > 50 then
                healthCol = '#c4ba60'
            elseif healthVal > 25 then
                healthCol = '#b13f3b'
            else
                healthCol = "#d61f1f"
            end

            SendNUIMessage({    
                update = true,
                name = "health",
                progress = healthVal,
                color = healthCol
            })

            local visible = false

            local armorVal = Armour
            if armorVal >= 100 then armorVal = 100 end
            if armorVal <= 0 then armorVal = 0 else visible = true end

            SendNUIMessage({
                update = true,
                name = "armor",
                progress = armorVal,
                visible = visible
            })
        else
            waitTime = 2500

            if wasShowing then
                SendNUIMessage({
                    show = false
                })
                wasShowing = false
            end
        end

    end
end)

exports('setVoiceMode', function(mode)
    local percentage = mode == 3 and 100 or mode == 2 and 66 or mode == 1 and 33 or 0

    SendNUIMessage({
        update = true,

        name = "voice",
        progress = percentage,
    })
end)

exports('setVoiceColor', function(color)
    SendNUIMessage({
        update = true,

        name = "voice",
        color = color,
    })
end)

local isDead = exports['players']:GetClientVar('isDead')
local inGame = exports['players']:GetClientVar('inGame')
local character = exports['players']:GetClientVar("character")

AddEventHandler("players:ClientVarChanged", function(name, old, new)
    if name == "inGame" then
        inGame = new
    elseif name == 'isDead' then
        isDead = new
    elseif name == 'character' then
        character = new
    end
end)

AddEventHandler("login:firstSpawn", function()
    local plrData = exports['players']:GetClientVar("character")
    if plrData and plrData.status then
        local status = json.decode(plrData.status)
        if not status.hunger then status.hunger = 100 end
        if not status.thirst then status.thirst = 100 end
        if not status.armor then status.armor = 0 end
        if not status.health then status.health = 200 end

        SetEntityHealth(PlayerPedId(), status.health)
        SetPedArmour(PlayerPedId(), status.armor)

        SendNUIMessage({
            update = true,
    
            name = "hunger",
            progress = status.hunger,
        })
        SendNUIMessage({
            update = true,
    
            name = "thirst",
            progress = status.thirst,
        })
        SendNUIMessage({
            update = true,
    
            name = "armor",
            progress = status.armor,
        })
        SendNUIMessage({
            update = true,
    
            name = "health",
            progress = status.health-100,
        })
    end
end)

AddEventHandler("players:CharacterVarChanged", function(name, old, new)
    if name == 'status' then
        local status = json.decode(new)
        SendNUIMessage({
            update = true,
    
            name = "hunger",
            progress = status.hunger,
        })
        SendNUIMessage({
            update = true,
    
            name = "thirst",
            progress = status.thirst,
        })
    end
end)

CreateThread(function()
    while true do
        if character and inGame and not isDead then
            local status = exports['status']:get()

            if not status.hunger then status.hunger = 100 end
            if not status.thirst then status.thirst = 100 end

            status.hunger = status.hunger - 1
            if status.hunger < 0 then status.hunger = 0 end

            status.thirst = status.thirst - math.random(3)
            if status.thirst < 0 then status.thirst = 0 end

            if status.thirst < 20 or status.hunger < 20 then
                local newhealth = GetEntityHealth(PlayerPedId()) - math.random(10)
                SetEntityHealth(PlayerPedId(), newhealth)
            end

            status.health = GetEntityHealth(PlayerPedId())
            status.armor = GetPedArmour(PlayerPedId())

            exports['status']:set(status)
            Wait(200*1000)
        else
            Wait(100)
        end
    end
end)

local lastPositionUpdate = nil

CreateThread(function()
    while true do
        if character and inGame and not isDead and not exports['jp-housing']:isInside() then
            local playerCoords = GetEntityCoords(playerPed)
            if not lastPositionUpdate or (#(lastPositionUpdate - playerCoords) > 10.0) then
                lastPositionUpdate = playerCoords
                TriggerServerEvent("status:updatePos", {
                    x = playerCoords.x,
                    y = playerCoords.y,
                    z = playerCoords.z,
                    heading = GetEntityHeading(playerPed)
                })
            end
        end
        Wait(10*1000)
    end
end)

local lastHealth = -1
local lastArmor = -1

CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        if character and inGame and playerPed ~= nil then
            local playerHealth = GetEntityHealth(playerPed)
            local playerArmour = GetPedArmour(playerPed)

            if playerHealth ~= lastHealth or playerArmour ~= lastArmor then
                lastHealth = playerHealth
                lastArmor = playerArmour

                CreateThread(function()
                    Wait(1000)
                    playerPed = PlayerPedId()
                    if GetEntityHealth(playerPed) == playerHealth and GetPedArmour(playerPed) == playerArmour then
                        TriggerServerEvent("status:updateStatus",playerHealth,playerArmour)
                    end
                end)
            end
            Wait(100)
        else
            Wait(1000)
        end
    end
end)

AddEventHandler("death:revived", function()
    local playerHealth = GetEntityHealth(playerPed)
    -- updateHealthStatus(playerHealth-100)
end)

function getStatus()
    local status = json.decode(exports['players']:GetClientVar('character').status)
    local playerPed = PlayerPedId()

    if not status.hunger then status.hunger = 100 end
    if not status.thirst then status.thirst = 100 end

    if not status.armor then status.armor = GetPedArmour(playerPed) end
    if not status.health then status.health = GetEntityHealth(playerPed) end

    return status
end
exports('get', getStatus)

function setStatus(status)
    local playerPed = PlayerPedId()

    if not status.hunger then status.hunger = 100 end
    if not status.thirst then status.thirst = 100 end

    if not status.armor then status.armor = GetPedArmour(playerPed) end
    if not status.health then status.health = GetEntityHealth(playerPed) end

    TriggerServerEvent("status:updateStatus",status.health,status.armor,status.thirst,status.hunger)
end

exports('set', setStatus)

RegisterNetEvent("admin:maxHungerAndThirst")
AddEventHandler("admin:maxHungerAndThirst", function()
    local status = getStatus()
    status.hunger = 100
    status.thirst = 100
    setStatus(status)
end)