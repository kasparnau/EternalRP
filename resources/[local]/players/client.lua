Citizen.CreateThread(function()
    while true do
        if NetworkIsSessionStarted() then
            TriggerEvent("players:playerSessionStarted")
            TriggerServerEvent("players:playerSessionStarted")
            break
        end
    end
end)

local ClientVars = {character = {}}

exports("SetClientVar", function(name, data)
    local old = ClientVars[name] or false
    ClientVars[name] = data

    TriggerEvent("players:ClientVarChanged", name, old, data)
    return data
end)

exports("modifyCurrentCharacter", function(value, data)
    local old = ClientVars['character'][value] or false
    ClientVars['character'][value] = data

    TriggerEvent("players:CharacterVarChanged", value, old, data)
end)

exports("GetClientVar", function(name, data)
    return ClientVars[name] or false
end)

RegisterNetEvent("players:networkCharacterVar")
AddEventHandler("players:networkCharacterVar", function(value, data)
    assert(value, "Missing args!")
    exports['players']:modifyCurrentCharacter(value, data)
end)

CreateThread(function()
    Citizen.CreateThread(function()

        while true do
    
            Citizen.Wait(1)
    
            local playerPed = PlayerPedId()

            SetPlayerTargetingMode(2)

            if not IsAimCamActive()  then
                HideHudComponentThisFrame(14)
            end
    
            HideHudComponentThisFrame(1)

            HideHudComponentThisFrame(6)

            HideHudComponentThisFrame(7)

            HideHudComponentThisFrame(9)
    
            if not IsPedInAnyVehicle(playerPed, true) then 
                HideHudComponentThisFrame(0)
            end
    
    
            --[[
            if IsControlPressed(0,44) then
                DisplayHud(1)
            else
                DisplayHud(0)
            end
            --]]
    
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
    
            SetPedMinGroundTimeForStungun(playerPed, 6000)
        end
    end)
end)

--// players:ClientVarChanged(var, old, new)