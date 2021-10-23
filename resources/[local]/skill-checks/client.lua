local events = exports['events']

local enabled = false

local p = nil
-- local currentCallback

function showUi()
    enabled = true
    SetNuiFocus(true, false)
    SendNUIMessage({
        type = 'show'
    })
end

function hideUi()
    enabled = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'hide'
    })
end

exports("canDo", function()
    return not enabled
end)

AddEventHandler("players:ClientVarChanged", function(name, old, new)
    if name == 'isDead' then
        if isDead and enabled then
            hideUi()
        end
    end
end)

exports("start", function(speed, target, callback)
    if exports['skill-checks']:canDo() then
        -- currentCallback = callback
        p = promise.new()
        SendNUIMessage({type = "start", speed = speed, target = target})
        showUi()

        return Citizen.Await(p)
    else
        return false
    end
end)

RegisterNUICallback('nuiAction', function(data, cb)
    if (data.action == "hide") then
        hideUi()
        if p then
            p:resolve(false)
        end
    elseif (data.action == "completed") then
        hideUi()
        p:resolve(data.data.success)
        -- currentCallback(data.data.success)
    end
    cb("ok")
end)