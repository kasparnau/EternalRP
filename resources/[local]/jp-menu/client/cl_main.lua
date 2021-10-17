local events = exports['events']

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

exports("showContextMenu", function(data, title)
    exports['inventory']:closeInventory() --//SO IT DOESNT GET STUCK

    showUi()
    SendNUIMessage({
        list = data,
        title = title
    })
end)

exports("isOpen", function()
    return enabled
end)

exports("hide", function(data, title)
    hideUi()
end)

RegisterNUICallback('nuiAction', function(data, cb)
    if (data.action == "buttonClicked") then
        hideUi()
        TriggerEvent(data.data.event, data.data.params)
    elseif (data.action == 'hide') then
        hideUi()
    end
    cb("ok")
end)