local isInRagdoll = false

local isCuffed = exports['players']:GetClientVar('isCuffed')
AddEventHandler("players:ClientVarChanged", function(name, old, new)
    if name == "isCuffed" then
        isCuffed = new
        if isCuffed then isInRagdoll = false end
    end
end)

Citizen.CreateThread(function()
 while true do
    Citizen.Wait(10)
    if isInRagdoll and not isCuffed then
      SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
    end
  end
end)

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(0)
    if IsControlJustPressed(2, Config.RagdollKeybind) and Config.RagdollEnabled and IsPedOnFoot(PlayerPedId()) and not isCuffed then
        if isInRagdoll then
            isInRagdoll = false
        else
            isInRagdoll = true
            Wait(500)
        end
    end
  end
end)

