local interaction = exports['interaction']

local wasShowing = false
local lastText = ''

local garage = nil
local dist = math.huge

function openGarageMenu()
    local vehicles = RPC.execute('jp-garages:getSharedVehicles')
    local MenuData = exports['jp-garages']:makeVehicleMenuList(vehicles)
    
    exports['jp-menu']:showContextMenu(MenuData, "Grupeeringu Garaaž")
end

AddEventHandler("factions:updated", function()
    garage = nil
end)

CreateThread(function() --* HANDLE UI
    local waitTime = 5000
    while true do
        if myFaction and myFaction.group.garage then
            waitTime = 1

            local arr = json.decode(myFaction.group.garage)
            garage = garage or vector3(arr[1], arr[2], arr[3])                    

            local ped = PlayerPedId()
            dist = #(GetEntityCoords(ped) - garage)

            if dist < 3.0 then
                local str = '[E] Ava Grupeeringu Garaaž'

                local store = false
                local canContinue = true

                if IsPedInAnyVehicle(ped, false) then
                    local meta = exports['jp-garages']:getVehicleMeta(GetVehiclePedIsIn(ped, false))
                    if meta and meta.faction_id ~= 0 then
                        str = '[E] Pane sõiduk garaaži'
                        store = true
                    else
                        canContinue = false
                        waitTime = 100
                    end
                end

                if canContinue then
                    if not wasShowing or lastText ~= str then
                        wasShowing = true

                        lastText = str
                        interaction:show(str)
                    end

                    if IsControlJustPressed(0, 38) then
                        if not store then
                            openGarageMenu()
                        else
                            exports['jp-garages']:storeVehicle(GetVehiclePedIsIn(ped, false))
                        end
                    end
                end
            else
                if wasShowing then
                    wasShowing = false
                    interaction:hide()
                end
            end
        else
            if garage then garage = nil end
            waitTime = 5000
        end
        Wait(waitTime)
    end
end)

AddEventHandler("jp-factions:retrieveFromImpound", function(car)
    local car = json.decode(car)

    local vehicleName = GetDisplayNameFromVehicleModel(car.model)
    local localizedName = GetLabelText(vehicleName)
    car.model = localizedName

    RPC.execute("unimpound", car)
end)