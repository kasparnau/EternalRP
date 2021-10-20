RegisterNetEvent("jp-phone:pingRequest")
AddEventHandler("jp-phone:pingRequest", function(from)
    local pingNoti = addNoti("PING (30)", "Keegi tahab teada sinu asukohta.", { no = true, yes = true})
    local eventHandler
    eventHandler = AddEventHandler("jp-phone:notiAction", function(id, accept)
        if id == pingNoti then
            removeNoti(pingNoti)
            RemoveEventHandler(eventHandler)
            eventHandler = nil

            if accept then
                RPC.execute("acceptPing", from)
            end
        end
    end)
    
    local timer = 31
    CreateThread(function()
        while eventHandler do --//UNANSWERED
            timer = timer - 1
            updateNoti(pingNoti, ("PING (%s)"):format(timer), "Keegi tahab teada sinu asukohta.", { no = true, yes = true})

            if timer == 0 then
                removeNoti(pingNoti)
                RemoveEventHandler(eventHandler)
                eventHandler = nil
                return
            end

            Wait(1000)
        end
    end)
end)

RegisterNetEvent("jp-phone:acceptedPing")
AddEventHandler("jp-phone:acceptedPing", function(coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 792)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    SetBlipScale(blip, 2.0)
    AddTextComponentString("PING")
    EndTextCommandSetBlipName(blip)
    CreateThread(function()
        TriggerEvent("DoLongHudText", "Isik võttis sinu PING-i vastu.", "green", 5000)
        Wait(60*1000)
        RemoveBlip(blip)
    end)
end)