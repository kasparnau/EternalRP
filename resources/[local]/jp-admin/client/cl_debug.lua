
local pi, sin, cos, abs = math.pi, math.sin, math.cos, math.abs
local function RotationToDirection(rotation)
  local piDivBy180 = pi / 180
  local adjustedRotation = vector3(
    piDivBy180 * rotation.x,
    piDivBy180 * rotation.y,
    piDivBy180 * rotation.z
  )
  local direction = vector3(
    -sin(adjustedRotation.z) * abs(cos(adjustedRotation.x)),
    cos(adjustedRotation.z) * abs(cos(adjustedRotation.x)),
    sin(adjustedRotation.x)
  )
  return direction
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    --local right, direction, up, pos = GetCamMatrix(GetRenderingCam())
    --local cameraCoord = pos
    local direction = RotationToDirection(cameraRotation)
    local destination = vector3(
      cameraCoord.x + direction.x * distance,
      cameraCoord.y + direction.y * distance,
      cameraCoord.z + direction.z * distance
    )
    local ray = StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z,
    destination.x, destination.y, destination.z, 26, -1, 4)
    local rayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(ray)
    return hit, endCoords, entityHit, surfaceNormal
end

function DrawSphere(pos, radius, r, g, b, a)
    DrawMarker(28, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, radius, radius, radius, r, g, b, a, false, false, 2, nil, nil, false)
end

local debug = false
RegisterCommand('adminn', function()
    debug = not debug
    Citizen.CreateThread(function()
        while debug do
			DisableControlAction(0, 24, true)

			local hit, pos, ent, _ = RayCastGamePlayCamera(100.0)
			if hit then
				-- DrawSphere(pos, 0.2, 255, 0, 0, 255)
				-- activePos = pos

				if ent then
					local entCoords = GetEntityCoords(ent)
					local min, max = GetModelDimensions(GetEntityModel(ent))
					DrawMarker(1, entCoords.x, entCoords.y, entCoords.z-1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 0, 0, 255, false, false, 2, nil, nil, false)

					if (IsDisabledControlJustPressed(0, 24)) then
						local MenuData = {}
						if GetEntityType(ent) == 2 then
							
						end
					end
				end
			end
			Wait(0)
		end
    end)
    
    -- if enabled then
    --     hideUi() 
    -- else
    --     local admin_level = RPC.execute("getLevel")
    --     if admin_level then
    --         showUi(admin_level) 
    --     end
    -- end
end)
