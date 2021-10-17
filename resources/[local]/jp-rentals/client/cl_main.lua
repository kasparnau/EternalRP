local events = exports['events']

AddEventHandler("jp-rentals:rent", function(pParams)
	local spawnPointClear = exports['modules']:getModule("Game").IsSpawnPointClear(vector3(117.84, -1079.95, 29.23), 3.0)

	if not spawnPointClear then
		TriggerEvent("DoLongHudText", "Autot ei saa välja võtta, sest midagi on ees!", 'red')
		return
	end

	events:Trigger("jp-rentals:purchase", function(networkId)
		local entity = NetworkGetEntityFromNetworkId(networkId)

        while not NetworkDoesEntityExistWithNetworkId(networkId) do Wait(0) end
        local entity = NetworkGetEntityFromNetworkId(networkId)
        while not DoesEntityExist(entity) do Wait(0) end

		exports['jp-flags']:SetVehicleFlag(entity, 'isRentalVehicle', true)
		
		exports['keys']:addKeys(entity)
	end, pParams.id)
end)

AddEventHandler("jp-rentals:browse", function(pEnt, pArgs)
	local MenuData = {}
	for i,v in pairs (Options) do
		local vehicleName = GetDisplayNameFromVehicleModel(v.name)
		local localizedName = GetLabelText(vehicleName)
		MenuData[#MenuData+1] = {
			title = localizedName,
			desc = ("$"..v.price),
			children = {
				{
					title = "Confirm Purchase",
					event = "jp-rentals:rent",
					params = { id = v.name }
				}
			}
		}
	end
	-- MenuData = {
	-- 	{
	-- 		title = "Vehicle Information",
	-- 		desc = "Class: S | Rating: 740 | Mileage: 2463.15"
	-- 	},
	-- 	{
	-- 		title = "Vehicle Diagnostics",
	-- 		children = {}
	-- 	}
	-- }
	exports['jp-menu']:showContextMenu(MenuData, "Rendikad")
end)