local weather = 'THUNDER'

local hours = 8

local weatherCycle = {'EXTRASUNNY', 'EXTRASUNNY','EXTRASUNNY', 'EXTRASUNNY', 'CLEARING', 'CLOUDS', 'OVERCAST', 'OVERCAST', 'OVERCAST',
'CLOUDS', 'EXTRASUNNY', --[['CLEARING', 'RAIN', 'THUNDER', 'SMOG', 'FOGGY',]] 'EXTRASUNNY', 'OVERCAST',
'EXTRASUNNY', 'EXTRASUNNY', 'CLOUDS', 'CLEARING', 'CLEAR', 'CLEAR', 'CLEAR', 'CLEAR', 'CLEAR', 'EXTRASUNNY', 'EXTRASUNNY','EXTRASUNNY'}
local currWeather = 0

RPC.register('getWeatherTime', function(source)
    return {weather = weather, time = {hours = hours, mins = 0}}
end)

CreateThread(function() -- TIME
    while true do
        hours = hours + 1
        if hours >= 24 then
            hours = 0
        end

        TriggerClientEvent("jp-weather:sync:time", -1, {hours = hours, mins = 0})

        Wait(60*1000)
    end
end)

local currentlyForced = false
local lastForceId = 0

CreateThread(function()
    while true do
        if not currentlyForced then
            currWeather = currWeather + 1
            if currWeather > #weatherCycle then currWeather = 1 end

            weather = weatherCycle[currWeather]

            TriggerClientEvent("jp-weather:sync:weather", -1, weather)
        end
        Wait(120*1000*2)
    end
end)

function forceWeather(pWeather)
    currentlyForced = true
    lastForceId = lastForceId + 1
    local currForceId = lastForceId
    weather = pWeather
    TriggerClientEvent("jp-weather:sync:weather:instant", -1, weather)
    CreateThread(function()
        Wait(1000*60*10)
        if currForceId == lastForceId then
            currentlyForced = false
        end
    end)
end

exports('forceWeather', forceWeather)

function forceTime(nHours)
    if (nHours >= 24) or (nHours < 0) then
        nHours = 0
    end
    hours = nHours

    TriggerClientEvent("jp-weather:sync:time", -1, {hours = nHours, mins = 0})
    return true
end

exports('forceTime', forceTime)