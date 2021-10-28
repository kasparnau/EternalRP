local sql = exports['jp-sql2']

--* DRAGGING
RegisterServerEvent("police:askToEscort")
AddEventHandler("police:askToEscort", function(Target)
	local Source = source
	TriggerClientEvent("police:escort", Target, Source)
end)

RegisterServerEvent("police:seatPlayer")
AddEventHandler("police:seatPlayer", function(Target, Vehicle, inTrunk)
	local Source = source
	TriggerClientEvent("police:seatPlayer", Target, Vehicle, inTrunk)
end)

RegisterServerEvent("police:unseatPlayer")
AddEventHandler("police:unseatPlayer", function(Target)
	local Source = source

	TriggerClientEvent("police:unseatPlayer", Target, Source)
end)

RegisterServerEvent("police:beingSearched")
AddEventHandler("police:beingSearched", function(Target)
	TriggerClientEvent("DoLongHudText", Target, "Teid otsitakse läbi.", 'red', 2000)
end)

RPC.register("police:fingerprintNearest", function(source, target)
	local trgCharacter = exports['players']:getCharacter(target)
	local srcCharacter = exports['players']:getCharacter(source)

	if not srcCharacter.faction then return false end
	local faction_name = srcCharacter.faction.group.faction_name

	if faction_name ~= "LSPD" and faction_name ~= "EMS" then return false end

    local retval = {
		name = (trgCharacter.first_name.." "..trgCharacter.last_name),
		cid = trgCharacter.cid
    }

	TriggerClientEvent("DoLongHudText", target, "Teilt võetakse sõrmejälge.", 'red', 2000)
	return retval 
end)

local lastFood = {}
RegisterNetEvent("police:givePrisonFood")
AddEventHandler("police:givePrisonFood", function()
	local source = source
	local srcCharacter = exports['players']:getCharacter(source)
	if srcCharacter then
		if not lastFood[source] then lastFood[source] = 0 end

		local timePassed = os.time() - lastFood[source]
		if timePassed > 29.0 then
			exports['inventory']:addItem(source, 'prison-food', 1)
			lastFood[source] = os.time()
		else
			exports['admin']:banPlayerFromSource(source, "Automaatne Ban - Cheating", "System", 7776000, ("Tried to make multiple prison foods in: %s"):format(timePassed))
		end
	end
end)