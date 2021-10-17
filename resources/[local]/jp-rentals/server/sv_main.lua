local events = exports['events']

events:Register("jp-rentals:purchase", function(source, cb, id)
    local character = exports['players']:getCharacter(source)
    if not character then return end
    
    for i,v in pairs (Options) do
        if v.name == id then
            if not exports['inventory']:canCarryItem(source, 'rental-papers', 1) then
                TriggerClientEvent("DoLongHudText", source, "Sul pole ruumi rendipaberite jaoks!", 'red')
                return
            end
            if exports['inventory']:removeItem(source, 'cash', v.price) then
                local entity = CreateVehicle(GetHashKey(id), 117.84, -1079.95, 29.23, 355.92, true, true)

                local failTries = 0
                while not DoesEntityExist(entity) do 
                    failTries = failTries + 1
                    if failTries > 5000 then return end
                    Wait(0)
                end
    
                exports['inventory']:addItem(source, 'rental-papers', 1, {
                    metadata = {
                        ["Issued to"] = character.first_name.." "..character.last_name,
                        ["Issued on"] = os.date("%x"),
                        ["Plate"] = GetVehicleNumberPlateText(entity)
                    }
                })

                local networkId = NetworkGetNetworkIdFromEntity(entity)
    
                --SetPedIntoVehicle(GetPlayerPed(source), entity, -1)
                cb(networkId)   
            else
                TriggerClientEvent("DoLongHudText", source, "Sul pole piisavalt raha selle jaoks!", 'red')
            end
            return
        end
    end
end)