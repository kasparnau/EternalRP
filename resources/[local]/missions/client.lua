local events = exports['events']

local enabled = false
local currentCallback
local currentMission = ""

function showUi()
    enabled = true
    SendNUIMessage({
        type = 'show'
    })
end

function hideUi()
    enabled = false
    SendNUIMessage({
        type = 'hide'
    })
end

exports("hide", function()
    hideUi()
end)

exports("show", function()
    showUi()
end)

exports("start", function(name, tbl)
    if not enabled then
        currentMission = name
        SendNUIMessage({
            type = "update",
            title = tbl.title,
            desc = tbl.desc
        })
        showUi()
        return true
    end
    return false
end)

exports('stop', function(name)
    hideUi()
end)

exports('current', function()
    return currentMission
end)

exports("update", function(tbl)
    SendNUIMessage({
        type = "update",
        title = tbl.title,
        desc = tbl.desc
    })
end)

exports("ongoing", function()
    return enabled
end)

RegisterNUICallback('nuiAction', function(data, cb)
    print ("NuiAction (LUA): "..json.encode(data))
    cb("ok")
end)

RegisterCommand("xd", function()
    exports['missions']:show()

    exports['missions']:update({
        title = "CURRENT MISSION",
        desc = "Go pick up trash. (1/5)"
    })
end)