local enabled = false

local p = nil

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

exports("canDo", function()
    return not enabled
end)

function startGame(rows, cols, tiles, time)
    SendNUIMessage({
        show = true,

        play = true,
        rows = rows,
        columns = cols,
        tiles = tiles,
        memorizeTime = time
    })
    showUi()

    p = promise.new()

    return Citizen.Await(p)
end

RegisterCommand("game", function(...)
    if enabled then hideUi() else startGame(6, 6, 14, 2000) end
end)

exports('start', function(...)
    if (enabled and p) then
        p:resolve(false)
    end

    return startGame(...)
end)

RegisterNUICallback('nuiAction', function(data, cb)
    print ("NuiAction (LUA): "..json.encode(data))

    if (data.action == 'endGame') then
        hideUi()
        print (json.encode(data))
        p:resolve(data.data.success)
        cb('ok')
    end
end)