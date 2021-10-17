function openGui(id,clr,msg,time)
    guiEnabled = true
    SendNUIMessage({runProgress = true, id = id, color = clr, text = msg, time = time})
end

function closeGui()
    guiEnabled = false
    SendNUIMessage({closeProgress = true})
end

RegisterNetEvent("tasknotify:guiupdate")
AddEventHandler("tasknotify:guiupdate", function(id, color, text, length)
    openGui(id, color, text, length)
end)

RegisterNetEvent("tasknotify:guiclose")
AddEventHandler("tasknotify:guiclose", function()
    closeGui()
end)

local lastId = 0
RegisterNetEvent('DoLongHudText')
AddEventHandler('DoLongHudText', function(text, color, length)
    lastId = lastId + 1
    if not color then color = 'default' end
    if not length then length = 4000 end

    openGui(lastId, color, text, length)
end)