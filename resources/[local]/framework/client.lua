-- EVENTS

local ped = PlayerPedId()

local oldTriggerEvent = TriggerEvent

TriggerEvent = function(eventName, ...)
    local args = {...}
    local argString = args == nil and "None" or json.encode(args)
    -- print("Event: "..eventName.." with the parameters of: "..argString)
    oldTriggerEvent(eventName, ...)
end

CreateThread(function()
    while true do
        local nPed = PlayerPedId()
        if ped ~= nPed then
            Wait(10)
            if PlayerPedId() == nPed then
                ped = nPed
                SetPedConfigFlag(ped, 184, true)
                SetPedConfigFlag(ped, 35, true)
                SetPedMaxHealth(ped, 200)
                SetEntityMaxHealth(ped, 200)
                TriggerEvent("jp:onPedChange", ped)
            -- else
            --     print "Changed, didnt send"
            end
        end
        Wait(1)
    end
end)