RegisterNetEvent("jp-npcs:set:ped")
AddEventHandler("jp-npcs:set:ped", function(pNPCs)
    if type(pNPCs) == "table" then
        for _, ped in ipairs(pNPCs) do
            RegisterNPC(ped)
            EnableNPC(ped.id)
        end
    else
        RegisterNPC(ped)
        EnableNPC(ped.id)
    end
end)

TriggerServerEvent("jp-npcs:location:fetch")