local inPrisonZone = false

AddEventHandler("players:CharacterVarChanged", function(name, old, new)
	if name == 'jail_time' then
		if not inPrisonZone then
			TriggerEvent("DoLongHudText",("Sa ei saa põgeneda seadusest!"), 'red', 5000)
            StartPlayerTeleport(PlayerId(), vector3(1779.1911621094,2583.5473632812,45.792724609375), 0.0, true, true, true)
		end
		if new > 0 then
			if new < 1 then
				TriggerEvent("DoLongHudText",("Vabanete vanglast varsti!"))
			else
				TriggerEvent("DoLongHudText",("Teil on vanglakaristust järel "..math.floor(new + 0.5).." kuud."), "red", 6000)
			end
		elseif new <= 0 then
            TriggerEvent("DoLongHudText",("Te olete vabad!"),'green')
        end
    end
end)

AddEventHandler("jp-polyzone:enter", function(zone)
    if zone == "prison" then 
		inPrisonZone = true
	end
end)

AddEventHandler("jp-polyzone:exit", function(zone)
    if zone == "prison" then 
		inPrisonZone = false
	end
end)

exports["jp-polyzone"]:AddPolyZone("prison", {
	vector2(1829.4222412109, 2620.8461914062),
	vector2(1854.7977294922, 2700.3229980469),
	vector2(1774.4296875, 2768.7282714844),
	vector2(1647.1409912109, 2763.0681152344),
	vector2(1565.4890136719, 2683.3771972656),
	vector2(1528.6467285156, 2585.0300292969),
	vector2(1535.3923339844, 2467.546875),
	vector2(1658.5743408203, 2388.6613769531),
	vector2(1763.6359863281, 2405.6196289062),
	vector2(1830.0268554688, 2473.0979003906),
	vector2(1834.2340087891, 2579.7426757812),
	vector2(1834.2774658203, 2592.6013183594),
	vector2(1833.4014892578, 2595.6577148438),
	vector2(1818.4958496094, 2596.8950195312),
	vector2(1818.7344970703, 2611.9055175781)
}, {
	--minZ = 46.150791168213,
	--maxZ = 66.887359619141
})