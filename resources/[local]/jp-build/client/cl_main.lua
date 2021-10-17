Build.InVisable = false

local exitingBuilding = false
local lastLine = ""
-- Text Draw
Citizen.CreateThread(function()
    local waitTime = 1000
    while true do
        if not exitingBuilding and Build.CurrentRoomPlan ~= nil then
            local plan = Build.CurrentRoomPlan

            if plan.interact ~= nil then
                local pedCoords = GetEntityCoords(PlayerPedId())

                local closest = nil
    
                for k,v in pairs(plan.interact) do
                    -- k = interact ID 
                    -- v = interact table 

                    local distance = #(pedCoords - (Build.CurrentBuildingOrigin+v.offset))
                    if distance <= v.viewDist then
                        closest = v
                        break
                    end
                end

                local newLine = buildLine(closest)

                local isRobbing = exports['jp-housing']:isRobbing()
                local interactBtn = closest and closest.housingMain[2]
                if not (isRobbing and (interactBtn == 'jp-housing:swapCharacter' or interactBtn == 'jp-housing:stash')) then
                    if (not Build.InVisable or lastLine ~= newLine) and closest then
                        exports['interaction']:show(newLine)
                        Build.InVisable = true
                        lastLine = newLine
                    elseif Build.InVisable and not closest then
                        exports['interaction']:hide()
                        Build.InVisable = false
                    end    
                end
            end

            waitTime = 50
        else
            if Build.InVisable then
                exports['interaction']:hide()
                Build.InVisable = false
            end

            waitTime = 1000
        end
        Wait(waitTime)
    end
end)

function buildLine(interact)
	local line = ""

	if interact then
		if interact.housingMain ~= nil and interact.housingMain[1] ~= "" then
			line = line.."[G] "..interact.housingMain[1]
            if interact.housingSecondary ~= nil and interact.housingSecondary[1] ~= "" then
                line = line.." / "
            end
        end
		if interact.housingSecondary ~= nil and interact.housingSecondary[1] ~= "" then
			line = line.."[H] "..interact.housingSecondary[1]
		end
	end

	return line 
end

function GetOffsets(vect,num,multi,numMultiplier)
    local genAdd = vect

    if num ~= 0 then
        if multi ~= 0 then
            genAdd = num + ((numMultiplier * multi))
        else
            genAdd = num
        end
    end

    return genAdd
end

function OffsetsModulo(vect,multi,numMultiplier,xLimit,yLimit)
    local generator = {x = 0.0,y = 0.0,z = 0.0}
    
    local modulo = numMultiplier % xLimit
    
    
    yOffset = math.ceil(numMultiplier / xLimit)
    zOffset = math.ceil(numMultiplier / (yLimit*xLimit))
    
    if modulo == 0 then
        modulo = numMultiplier / yOffset
    end
    local yModulo = (yOffset % yLimit) + 1
    
    
    modulo = modulo + 0.0
    yOffset = yOffset + 0.0
    
    generator.x = (vect[1]) + ((modulo * multi.x))
    generator.y = (vect[2]) + ((yModulo * multi.y))
    generator.z = (vect[3]) + ((zOffset * multi.z))

    return vector3(generator.x,generator.y,generator.z)
end

function CustomPointSpawn(numMultiplier,plan)
    local gen = vector3(0.0,0.0,0.0)
    for k,v in pairs(plan.customLocations) do
        if  numMultiplier > v.numMulStart and numMultiplier < v.numMulEnd then
            gen = vector3(v.gen.x,v.gen.y,v.gen.z)
            if numMultiplier < 7 then
                numMultiplier = numMultiplier - v.numMulStart
                local x,y,z
                x = Build.func.GetOffsets(gen.x,v.offSet.x,v.multi,numMultiplier)
                y = Build.func.GetOffsets(gen.y,v.offSet.y,v.multi,numMultiplier)
                z = Build.func.GetOffsets(gen.z,v.offSet.z,v.multi,numMultiplier)

                gen = vector3(x,y,z)
            end

        end
    end

    return gen
end

function getGeneratorFromRoom(numMultiplier,currentPlan)
    local plan = currentPlan
    local generator = vector3(100.0,100.0,20.0)

    if plan.generator then 
        generator = vector3(plan.generator.x,plan.generator.y,plan.generator.z)

        if plan.offsetX ~= nil then
            local x,y,z
            x = GetOffsets(generator.x,plan.offsetX.num,plan.offsetX.multi,numMultiplier)

            y = GetOffsets(generator.y,plan.offsetY.num,plan.offsetY.multi,numMultiplier)

            z = GetOffsets(generator.z,plan.offsetZ.num,plan.offsetZ.multi,numMultiplier)

            generator = vector3(x,y,z)
        elseif plan.modulo ~= nil then
            generator = OffsetsModulo(generator,plan.modulo.multi,numMultiplier,plan.modulo.xLimit,plan.modulo.yLimit)
        else
            generator = CustomPointSpawn(numMultiplier,plan)
        end

    end

    return generator
end

function CleanUpArea()
    local playerped = PlayerPedId()
    local plycoords = GetEntityCoords(playerped)
    local handle, ObjectFound = FindFirstObject()
    local success
    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = #(plycoords - pos)
        if distance < 50.0 and ObjectFound ~= playerped then
            if IsEntityAPed(ObjectFound) then
                if IsPedAPlayer(ObjectFound) then
                else
                    DeleteObject(ObjectFound)
                end
            else
                if not IsEntityAVehicle(ObjectFound) and not IsEntityAttached(ObjectFound) then
                    DeleteObject(ObjectFound)
                end
            end            
        end
        success, ObjectFound = FindNextObject(handle)
    until not success
    EndFindObject(handle)
end

function CleanUpPeds()
    local playerped = PlayerPedId()
    local plycoords = GetEntityCoords(playerped)
    local handle, ObjectFound = FindFirstPed()
    local success
    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = #(plycoords - pos)
        if distance < 50.0 and ObjectFound ~= playerped then
            if IsPedAPlayer(ObjectFound) or IsEntityAVehicle(ObjectFound) then
            else
                DeleteEntity(ObjectFound)
            end            
        end
        success, ObjectFound = FindNextPed(handle)
    until not success
    EndFindPed(handle)
end

function placeObjectCorrectZ(object,z)
    local dist = 0.0

    local d1,d2 = GetModelDimensions(GetEntityModel(object))
    local pos = GetEntityCoords(object)
    local bot = GetOffsetFromEntityInWorldCoords(object, 0.0,0.0,d1["z"])

    local newZ = z + (pos-bot)
    
    SetEntityCoords(object, pos.x, pos.y,newZ)
end

function FloatTilSafe(buildingObject)
    SetEntityInvincible(PlayerPedId(),true)
    FreezeEntityPosition(PlayerPedId(),true)

    local count = 500

    while count > 0 do
        Wait(100)
        if HasCollisionLoadedAroundEntity(PlayerPedId()) == 1 and HasCollisionForModelLoaded(GetEntityModel(buildingObject)) == 1 and HasModelLoaded(GetEntityModel(buildingObject)) == 1 then
            count = -9
        end
        count = count -1
    end

    if count <= -9 then return true else return false end
end

function buildRoom(planName, positionGen, isBackdoor, spawnOveride, start)
    local plan = Build.Plans[planName]
    if not plan then return end

    local player = PlayerPedId()
    Build.StartingPos = start or GetEntityCoords(player)
    FreezeEntityPosition(player,true)

    Build.CurrentRoomPlan = plan

    -- if plan.instance then
    --     FreezeEntityPosition(player,false)
    --     local instance = Build.func.enterInstancedBuilding(plan,positionGen)
    --     return instance
    -- end

    SetEntityCoords(player,plan.origin)

    local buildingObject = exports["jp-ytypparser"]:request(planName,plan.saveClient)
    local mainPos = vector3(0.0,0.0,0.0)
    local objectSpawnCoords = vector3(0.0,0.0,0.0)

    if type(positionGen) == "number" then
        objectSpawnCoords = getGeneratorFromRoom(positionGen,plan)
    elseif type(positionGen) == "table" or type(positionGen) == type(vector3(0.0,0.0,0.0)) then
        objectSpawnCoords = positionGen
    end

    Build.CurrentBuildingOrigin = objectSpawnCoords

    for k,v in pairs(buildingObject) do
        if string.lower(v.name) == string.lower(plan.shell) then
            mainPos = vector3(v.x,v.y,v.z)
        end
    end

    if type(spawnOveride) == "vector3" then
        SetEntityCoords(player, objectSpawnCoords.x+spawnOveride.x, objectSpawnCoords.y+spawnOveride.y, objectSpawnCoords.z+spawnOveride.z)
    else
        if not isBackdoor or isBackdoor == nil then
            SetEntityCoords(player, objectSpawnCoords.x+plan.spawnOffset.x, objectSpawnCoords.y+plan.spawnOffset.y, objectSpawnCoords.z+plan.spawnOffset.z)
        else
            SetEntityCoords(player, objectSpawnCoords.x+plan.backSpawnOffset.x, objectSpawnCoords.y+plan.backSpawnOffset.y, objectSpawnCoords.z+plan.backSpawnOffset.z)
        end
    end

    CleanUpArea()
    CleanUpPeds()
    -- TriggerEvent("inhotel",true)

    -- print "----------"
    -- print (json.encode(objectSpawnCoords))
    -- print (json.encode(mainPos))

    local building = CreateObject(GetHashKey(plan.shell),objectSpawnCoords.x,objectSpawnCoords.y,objectSpawnCoords.z,false,false,false)
    placeObjectCorrectZ(building,(objectSpawnCoords.z))
    FreezeEntityPosition(building,true)

    local holdingobjects = {}
    for k,v in pairs(buildingObject) do
        if v.name ~= plan.shell then
            local canCreate = true
            local wc = vector3(objectSpawnCoords.x+v.x,objectSpawnCoords.y+v.y,objectSpawnCoords.z+v.z)
            if destroyedObjects ~= nil and destroyedObjects[v.name] ~= nil then
                for u,i in pairs(destroyedObjects[v.name]) do
                    if #(wc-i) <= 1.0 then
                        canCreate = false
                    end
                end 
            end

            if canCreate then
                holdingobjects[k] = CreateObject(GetHashKey(v.name),wc.x,wc.y,wc.z,false,false,false)

                placeObjectCorrectZ(holdingobjects[k],(objectSpawnCoords.z+v.z))
                SetEntityQuaternion(holdingobjects[k], v.rx, v.ry, v.rz, v.rw*-1)
                FreezeEntityPosition(holdingobjects[k],true)            
            end
        else
            SetEntityQuaternion(building, v.rx, v.ry, v.rz, v.rw*-1)
        end
    end

    local safe = FloatTilSafe(building)

    FreezeEntityPosition(player,false)

    if safe then
        return objectSpawnCoords
    else
        SetEntityCoords(player,Build.StartingPos)
        Build.CurrentRoomPlan = nil
        Build.StartingPos = nil
        Build.CurrentBuildingOrigin = nil
        return false
    end

end
exports('buildRoom', buildRoom)

function exitBuilding(overrideVector)
    local plan = Build.CurrentRoomPlan

    if plan ~= nil then
        -- if plan.instance then
        --     local instance = Build.func.exitInstancedBuilding(plan)
        --     return true
        -- end

        CleanUpPeds()
        CleanUpArea()


        if overrideVector ~= nil then
            SetEntityCoords(PlayerPedId(),overrideVector)
        else
            if Build.StartingPos ~= nil then
                SetEntityCoords(PlayerPedId(), Build.StartingPos)
            end
        end

        Build.CurrentRoomPlan = nil
        Build.StartingPos = nil
        Build.CurrentBuildingOrigin = nil

        exitingBuilding = false
    end

end
exports('exitBuilding', exitBuilding)

local robLocations = {}
function interactClosest(key)
    local mainVector = Build.CurrentBuildingOrigin
    local interactPoints = Build.CurrentRoomPlan.interact

    local CurrentDist = math.huge
	local CurrentInteract = nil

    if ( mainVector and interactPoints ) then
        for k,v in pairs(interactPoints) do
            local distance = #(GetEntityCoords(PlayerPedId()) - (mainVector+v.offset))
            
            if distance <= v.useDist and distance < CurrentDist then
                CurrentDist = distance
                CurrentInteract = k
            end
        end    

    end

    print ("Key: "..key)
    if CurrentInteract ~= nil and interactPoints[CurrentInteract][key][2] ~= "" then
        if key == 'jp-housing:leave' then
            exports['interaction']:hide()
            Build.InVisable = false
            exitingBuilding = true
        end

		TriggerEvent(interactPoints[CurrentInteract][key][2])
	end
end

function updateRobLocations(locations)
    robLocations = locations
end

exports('updateRobLocations', updateRobLocations)

RegisterCommand("offset", function()
    local mainVec = Build.CurrentBuildingOrigin
    local playerVec = GetEntityCoords(PlayerPedId())

    print (mainVec, playerVec)
    local offset = (mainVec - playerVec)
    print ("Offset: "..json.encode(offset * -1))
end)

RegisterNetEvent('jp-binds:keyEvent')
AddEventHandler('jp-binds:keyEvent', function(name, onDown)
    if not onDown then return end

	if Build.CurrentRoomPlan ~= nil then
		local plan = Build.CurrentRoomPlan
		local interactName = nil

		if plan.interact ~= nil and Build.InVisable then
			if name == "housingSecondary" then
				interactName = "housingSecondary"
			end
			
			if name == "housingMain" then
				interactName = "housingMain"
			end
			
			if name == "general" then
				interactName = "generalUse"
			end

			if interactName ~= nil then
				interactClosest(interactName)
			end
		end
		Wait(1)
	end
end)

function Build.func.currentBuildingVector()
	local plan = Build.CurrentRoomPlan
	if plan ~= nil then 
        return Build.CurrentBuildingOrigin
    else 
        return false 
    end
end