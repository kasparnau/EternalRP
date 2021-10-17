function GetFullStreetFromPos(pos)
    local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    local current_zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))
    if GetStreetNameFromHashKey(var1) and GetNameOfZone(pos.x, pos.y, pos.z) then
        if GetStreetNameFromHashKey(var1) then
            StreetName = GetStreetNameFromHashKey(var1) or nil
            RoadName = GetStreetNameFromHashKey(var2) or nil
        end
    end
    return StreetName, RoadName, current_zone
end

local policeEvents = {
    [1] = {
        name = 'House break-in',
    },
    [2] = {
        name = 'Shots fired',
    },
    [3] = {
        name = 'Fight in progress',
    },
    [4] = {
        name = 'Carjacking in progress',
    },
    [5] = {
        name = 'Robbery at gunpoint',
    },
    [6] = {
        name = 'Car crash'
    },
    [20] = {
        name = 'Robbery at Grocery Store',
        time = 25000,
        mediumPrio = true,
    },
    [21] = {
        name = 'Robbery at Jewelry Store',
        time = 50000,
        highPrio = true
    },
    [22] = {
        name = 'Robbery at Fleeca Bank',
        time = 50000,
        highPrio = true
    },
    [23] = {
        name = 'Robbery at Pacific Standard Bank',
        time = 50000,
        highPrio = true
    }
}

function PoliceAlertNotification(eventId, location)
    local eventType = ""
    local eventText = ""
    local eventTheme = 'policeAlert'
    local eventTime = 5000

    if policeEvents[eventId] then
        eventType = policeEvents[eventId].name or ("Unknown ("..eventId..")")
        eventTime = policeEvents[eventId].time or 5000

        StreetName, RoadName, current_zone = GetFullStreetFromPos(location)
        if StreetName ~= "" then
            eventText = ("🌐 "..StreetName)
        end
        if RoadName ~= "" then
            eventText = (eventText..", nearby "..RoadName)
        end
        if current_zone ~= "" then
            eventText = (eventText.." near "..current_zone)
        end

        eventTheme = policeEvents[eventId].highPrio and 'policeAlertHigh' or policeEvents[eventId].mediumPrio and 'policeAlertMed' or 'policeAlert'
    end

    exports.pNotify:SetQueueMax("policeAlert", 15)
	exports.pNotify:SendNotification({
		text = ("<b style='color:white'>"..eventType.."</b> <br /><br /> <b style='color:white;font-size:11px'>"..eventText.."</b>"),
		type = eventTheme,
		queue = "policeAlert",
		timeout = eventTime,
		layout = "centerRight",
		sounds = {
			sources = {"sound-example.wav"},
			volume = 0.2,
			conditions = {"docVisible"}
		}
	})
end

exports('notify', function(eventType, eventText, alertType, timeout)
    exports.pNotify:SetQueueMax(alertType, 5)
    local textColor = alertType == 'infoAlert' and 'black' or 'white'
    exports.pNotify:SendNotification({
        text = ("<b style='color:"..textColor.."'>"..eventType.."</b> <br /><br /> <b style='color:"..textColor..";font-size:11px'>"..eventText.."</b>"),
        type = alertType,
        queue = alertType,
        timeout = timeout or 1000,
        layout = "topRight",
        sounds = {
            sources = {"sound-example.wav"}, 
            volume = 0.2,
            conditions = {"docVisible"}
        }
    })
end)

RegisterNetEvent("alerts:SendNotification")
AddEventHandler("alerts:SendNotification", function(...)
    exports['alerts']:notify(...)
end)

RegisterCommand("notify", function(source, args)
    PoliceAlertNotification(tonumber(args[1]), GetEntityCoords(PlayerPedId()))
end)