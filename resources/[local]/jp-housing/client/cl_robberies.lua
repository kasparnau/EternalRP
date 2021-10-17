local interaction = exports['interaction']

function getGlobalVector(vector,buildingVector)
    local vec3 = vec3FromVec4(vector)
    return (vec3 + buildingVector) 
end

function buildRobLocations(propertyID)
    local model = Housing.info[propertyID].model
    if not model then return end
    
    local robLocations = {}

    local index1 = 1
    
    local buildingVector = exports["jp-build"]:getModule("func").currentBuildingVector()
    for _,v in pairs(Housing.robLocations) do
        print (json.encode(Housing.robInformation.staticLocations[model].staticPositions))
        local vector = Housing.robInformation.staticLocations[model].staticPositions[v].pos

        robLocations[index1] = {["pos"] = getGlobalVector(vector,buildingVector), ["id"] = v, ["model"] = "none"}
        index1 = index1 + 1
    end

    --local finished,locations = RPC.execute("housing:robbery:robLocationsGenerated",robLocations,propertyID)
    Housing.robPosLocations = robLocations
end

local wasShowing = false
CreateThread(function()
    local waitTime = 1000
    while true do
        if Housing.robPosLocations then
            waitTime = 1
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)

            local closestDist = math.huge
            local closest = nil

            for _,v in pairs (Housing.robPosLocations) do
                local dist = #(GetEntityCoords(ped) - v.pos)
                if (dist < closestDist) then
                    closestDist = dist
                    closest = v
                end
            end

            if closestDist < 1.3 then
                if not wasShowing then
                    interaction:show('[E] Otsi Läbi')
                    wasShowing = true
                end
                if IsControlJustPressed(0, 38) then
                    exports['progress']:Progress({
                        name = "Housing",
                        duration = 10000,
                        label = ('Otsib Läbi'),
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
                        animation = {animDict = "missexile3", anim = "ex03_dingy_search_case_a_michael"},
                    }, function(cancelled)
                        ClearPedTasks(PlayerPedId())
                        if not cancelled and Housing.currentlyInsideBuilding then
                            RPC.execute("jp-housing:robLocation", Housing.propertyId, closest.id)
                        end 
                    end)                
                end
            elseif wasShowing then
                interaction:hide()
                wasShowing = false
            end
        end
        Wait(waitTime)
    end
end)