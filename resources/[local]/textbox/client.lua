local events = exports['events']

local enabled = false
local prom

function showUi()
    enabled = true
    SendNUIMessage({
        show = true
    })
    SetNuiFocus(true, true)
end

function hideUi()
    enabled = false
    SendNUIMessage({
        show = false
    })
    SetNuiFocus(false, false)
end

exports("update", function(tbl)
    SendNUIMessage({
        type = "update",
        title = tbl.title,
        desc = tbl.desc
    })
end)

exports("isOpen", function()
    return enabled
end)

exports("open", function(pItems)
    if not exports['textbox']:isOpen() then
        prom = promise.new()
        SendNUIMessage({
            show = true,
            items = pItems
        })
        showUi()
        return Citizen.Await(prom)
    else
        return false
    end
end)

exports("hide", function()
    prom = nil
    hideUi()
end)

RegisterNUICallback('nuiAction', function(data, cb)
    if (data.action == "submit") then
        hideUi()
        local new = {}
        for i,v in pairs (data.data.values) do
            new[v.id] = v.val
        end
        print (json.encode(new))
        prom:resolve(new)
    elseif (data.action == 'close') then
        hideUi()
        prom:resolve(nil)
    end
    cb("ok")
end)