local enabled = true

local blackout = false

local currWeather = 'EXTRASUNNY'
local newWeather = nil

local time = {
    hours = 8,
    mins = 0,
    seconds = 0
}

function updateWeather()
    if newWeather ~= currWeather and enabled then
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypeOvertimePersist(newWeather, 120.0)
        currWeather = newWeather
    end
end

function updateTime()
    if not enabled then return end
    NetworkOverrideClockTime(time.hours, time.mins, 00)
    TriggerEvent("jp-weather:timeUpdated", time.hours, time.mins)
end

function forceUpdateWeatherTime()
    if not enabled then return end
    
    local data = RPC.execute("getWeatherTime")
    newWeather = data.weather
    time = data.time
    
    currWeather = newWeather
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypeNow(newWeather)
    SetWeatherTypeNowPersist(newWeather)
    -- updateWeather()
    updateTime()
end

RegisterNetEvent("jp-weather:sync:weather")
AddEventHandler("jp-weather:sync:weather", function(nWeather)
    if not enabled then return end

    newWeather = nWeather
    
    updateWeather()
end)

RegisterNetEvent("jp-weather:sync:weather:instant")
AddEventHandler("jp-weather:sync:weather:instant", function(nWeather)
    if not enabled then return end

    newWeather = nWeather

    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypeNow(newWeather)
    SetWeatherTypeNowPersist(newWeather)
    SetWeatherTypePersist(newWeather)
end)

RegisterNetEvent("jp-weather:sync:time")
AddEventHandler("jp-weather:sync:time", function(nTime)
    if not enabled then return end

    time = nTime
    
    updateTime()
end)

CreateThread(function()
    while true do
        Wait(1000)
        time.mins = time.mins + 1
        if time.mins >= 60 then
            time.mins = 0
        end
        updateTime()
    end
end)

function toggle(enable)
    enabled = enable

    if enabled then
        forceUpdateWeatherTime()
    end
end

CreateThread(function()
    if NetworkIsSessionStarted() then
        forceUpdateWeatherTime()
    end
end)

AddEventHandler("spawnmanager:spawnInitialized", forceUpdateWeatherTime)

exports('toggle', toggle)
exports('forceUpdate', forceUpdateWeatherTime)