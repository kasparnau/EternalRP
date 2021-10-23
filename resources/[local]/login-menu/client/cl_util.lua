
-- function ScreenRelToWorld(camPos, camRot, cursor)
--     local camForward = RotationToDirection(camRot)
--     local rotUp = vector3(camRot.x + 1.0, camRot.y, camRot.z)
--     local rotDown = vector3(camRot.x - 1.0, camRot.y, camRot.z)
--     local rotLeft = vector3(camRot.x, camRot.y, camRot.z - 1.0)
--     local rotRight = vector3(camRot.x, camRot.y, camRot.z + 1.0)
--     local camRight = RotationToDirection(rotRight) - RotationToDirection(rotLeft)
--     local camUp = RotationToDirection(rotUp) - RotationToDirection(rotDown)
--     local rollRad = -(camRot.y * math.pi / 180.0)
--     local camRightRoll = camRight * math.cos(rollRad) - camUp * math.sin(rollRad)
--     local camUpRoll = camRight * math.sin(rollRad) + camUp * math.cos(rollRad)
--     local point3DZero = camPos + camForward * 1.0
--     local point3D = point3DZero + camRightRoll + camUpRoll
--     local point2D = World3DToScreen2D(point3D)
--     local point2DZero = World3DToScreen2D(point3DZero)
--     local scaleX = (cursor.x - point2DZero.x) / (point2D.x - point2DZero.x)
--     local scaleY = (cursor.y - point2DZero.y) / (point2D.y - point2DZero.y)
--     local point3Dret = point3DZero + camRightRoll * scaleX + camUpRoll * scaleY
--     local forwardDir = camForward + camRightRoll * scaleX + camUpRoll * scaleY
--     return point3Dret, forwardDir
-- end
 
-- function RotationToDirection(rotation)
--     local x = rotation.x * math.pi / 180.0
--     --local y = rotation.y * pi / 180.0
--     local z = rotation.z * math.pi / 180.0
--     local num = math.abs(math.cos(x))
--     return vector3((-math.sin(z) * num), (math.cos(z) * num), math.sin(x))
-- end
 
-- function World3DToScreen2D(pos)
--     local _, sX, sY = GetScreenCoordFromWorldCoord(pos.x, pos.y, pos.z)
--     return vector2(sX, sY)
-- end
-- function LocationInWorld(coords,camera)
--     local position = GetCamCoord(camera)

--     --- Getting Object umath.sing raycast
--     local ped = PlayerPedId()
--     print ("Start: "..position)
--     print ("End  : "..coords)
--     local raycast = StartShapeTestRay(position.x, position.y, position.z, coords.x, coords.y, coords.z, 8, ped, 0)
--     local retval, hit, endCoords, surfaceNormal, entity = GetShapeTestResult(raycast)

--     print (retval)
--     return entity
-- end

function mulNumber(vector1, value)
    local result = {}
    result.x = vector1.x * value
    result.y = vector1.y * value
    result.z = vector1.z * value
    return result
end

-- Add one vector to another.
function addVector3(vector1, vector2) 
    return {x = vector1.x + vector2.x, y = vector1.y + vector2.y, z = vector1.z + vector2.z}   
end

-- Subtract one vector from another.
function subVector3(vector1, vector2) 
    return {x = vector1.x - vector2.x, y = vector1.y - vector2.y, z = vector1.z - vector2.z}
end

function rotationToDirection(rotation) 
    local z = degToRad(rotation.z)
    local x = degToRad(rotation.x)
    local num = math.abs(math.cos(x))

    local result = {}
    result.x = -math.sin(z) * num
    result.y = math.cos(z) * num
    result.z = math.sin(x)
    return result
end

function w2s(position)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(position.x, position.y, position.z)
    if not onScreen then
        return nil
    end

    local newPos = {}
    newPos.x = (_x - 0.5) * 2
    newPos.y = (_y - 0.5) * 2
    newPos.z = 0
    return newPos
end

function processCoordinates(x, y) 
    local screenX, screenY = GetActiveScreenResolution()

    local relativeX = 1 - (x / screenX) * 1.0 * 2
    local relativeY = 1 - (y / screenY) * 1.0 * 2

    if relativeX > 0.0 then
        relativeX = -relativeX;
    else
        relativeX = math.abs(relativeX)
    end

    if relativeY > 0.0 then
        relativeY = -relativeY
    else
        relativeY = math.abs(relativeY)
    end

    return { x = relativeX, y = relativeY }
end

function s2w(camPos, relX, relY)
    local camRot = GetCamRot(exports['spawn_manager']:GetLoginCam())
    local camForward = rotationToDirection(camRot)
    local rotUp = addVector3(camRot, { x = 10, y = 0, z = 0 })
    local rotDown = addVector3(camRot, { x = -10, y = 0, z = 0 })
    local rotLeft = addVector3(camRot, { x = 0, y = 0, z = -10 })
    local rotRight = addVector3(camRot, { x = 0, y = 0, z = 10 })

    local camRight = subVector3(rotationToDirection(rotRight), rotationToDirection(rotLeft))
    local camUp = subVector3(rotationToDirection(rotUp), rotationToDirection(rotDown))

    local rollRad = -degToRad(camRot.y)
    -- print(rollRad)
    local camRightRoll = subVector3(mulNumber(camRight, math.cos(rollRad)), mulNumber(camUp, math.sin(rollRad)))
    local camUpRoll = addVector3(mulNumber(camRight, math.sin(rollRad)), mulNumber(camUp, math.cos(rollRad)))

    local point3D = addVector3(addVector3(addVector3(camPos, mulNumber(camForward, 10.0)), camRightRoll), camUpRoll)

    local point2D = w2s(point3D)

    if point2D == undefined then
        return addVector3(camPos, mulNumber(camForward, 10.0))
    end

    local point3DZero = addVector3(camPos, mulNumber(camForward, 10.0))
    local point2DZero = w2s(point3DZero)

    if point2DZero == nil then
        return addVector3(camPos, mulNumber(camForward, 10.0))
    end

    local eps = 0.001

    if math.abs(point2D.x - point2DZero.x) < eps or math.abs(point2D.y - point2DZero.y) < eps then
        return addVector3(camPos, mulNumber(camForward, 10.0))
    end

    local scaleX = (relX - point2DZero.x) / (point2D.x - point2DZero.x)
    local scaleY = (relY - point2DZero.y) / (point2D.y - point2DZero.y)
    local point3Dret = addVector3(addVector3(addVector3(camPos, mulNumber(camForward, 10.0)), mulNumber(camRightRoll, scaleX)), mulNumber(camUpRoll, scaleY))

    return point3Dret
end

function degToRad(deg)
    return (deg * math.pi) / 180.0
end

 -- Get entity, ground, etc. targeted by mouse position in 3D space.
function screenToWorld(flags, ignore, camPos)
    local x, y = GetNuiCursorPosition()
    local absoluteX = x
    local absoluteY = y

    local processedCoords = processCoordinates(absoluteX, absoluteY)
    local target = s2w(camPos, processedCoords.x, processedCoords.y)

    local dir = subVector3(target, camPos)
    local from = addVector3(camPos, mulNumber(dir, 0.05))
    local to = addVector3(camPos, mulNumber(dir, 300))

    local ray = StartShapeTestRay(from.x, from.y, from.z, to.x, to.y, to.z, 8, PlayerPedId(), 0)
	local _, hit, endCoords, surface, entity = GetShapeTestResult(ray)
    return hit, endCoords, surface, entity
end