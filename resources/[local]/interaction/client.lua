local enabled = false

function showUi()
    enabled = true
    SendNUIMessage({
        show = true
    })
end

function hideUi()
    enabled = false
    SendNUIMessage({
        show = false
    })
end

exports("isOpen", function()
    return enabled
end)

exports("show", function(text, colorType)
    local color = '#1b70b6'
    if colorType == 'red' then
        color = '#b61b1b'
    end
    if colorType == 'green' then
        color = '#1bb651'
    end
    SendNUIMessage({
        text = text,
        color = color
    })
    showUi()
end)

exports("hide", function(text, type)
    hideUi()
end)