local PeekEntries = { ['model'] = {}, ['flag'] = {}, ['entity'] = {}, ['polytarget'] = {} }
local currentEntity = 0
local players = exports['players']

CurrentZones, CurrentTarget, CurrentTargetType, IsPeeking, IsPeakActive = {}, nil, nil, false, false
local pTarget, pContext, pParameters = nil

Citizen.CreateThread(function()
    RegisterCommand('+playerTarget', playerTargetEnable, false)
    RegisterCommand('-playerTarget', playerTargetDisable, false)
    exports['jp-keybinds']:registerKeyMapping("playerTarget", "Mängija", "Kolmas Silm", "+playerTarget", "-playerTarget", "LMENU")    
    TriggerEvent("chat:removeSuggestion", "/+playerTarget")
    TriggerEvent("chat:removeSuggestion", "/-playerTarget")
end)

function startRenderLoop(entry, pTarget, pContext, pParameters)
    if exports['progress']:doingAction() then return end
    success = true
    
    SendNUIMessage({response = "validTarget", data = entry["options"]})

    while success and targetActive and not exports['progress']:doingAction() do
        local plyCoords = GetEntityCoords(PlayerPedId())
        local hit, coords, entity = RayCastGamePlayCamera(20.0)

        DisablePlayerFiring(PlayerPedId(), true)

        if (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24)) then
            SetNuiFocus(true, true)
            SetCursorLocation(0.5, 0.5)
        end

        if GetEntityType(entity) == 0 or #(plyCoords - coords) > entry.distance then
            success = false
        end

        Citizen.Wait(1)
    end
    SendNUIMessage({response = "leftTarget"})
end

function playerTargetEnable()
    if IsDisabled() then return end
    if success then return end
    if IsPedArmed(PlayerPedId(), 6) then return end

    targetActive = true

    SendNUIMessage({response = "openTarget"})

    while targetActive do
        DisablePlayerFiring(PlayerPedId(), true)

        local plyCoords = GetEntityCoords(PlayerPedId())
        local hit, coords, entity = RayCastGamePlayCamera(20.0)

        if hit == 1 then
            if GetEntityType(entity) ~= 0  then
                local maxDist = 0.0
                local options = {}

                local distance = #(plyCoords - coords)
                local context = GetEntityContext(entity)

                if PeekEntries['entity'][context.type] then
                    for id,entry in pairs (PeekEntries['entity'][context.type]) do
                        if distance < entry.distance and (not entry.isEnabled) or (distance < entry.distance and entry.isEnabled and entry.isEnabled(entity, context, entry.params)) then
                            pTarget = entity
                            pContext = context
                            pParameters = entry.params
                            if entry.distance > maxDist then maxDist = entry.distance end
                            options[#options+1] = entry.options
                            --startRenderLoop(entry, pTarget, pContext, pParameters)
                        end
                    end
                end

                if PeekEntries['model'][context.model] then
                    for i,entry in pairs (PeekEntries['model'][context.model]) do
                        if distance < entry.distance and (not entry.isEnabled) or (distance < entry.distance and entry.isEnabled and entry.isEnabled(entity, context, entry.params)) then
                            pTarget = entity
                            pContext = context
                            pParameters = entry.params
                            if entry.distance > maxDist then maxDist = entry.distance end
                            options[#options+1] = entry.options
                            --startRenderLoop(entry, pTarget, pContext, pParameters)
                        end    
                    end
                end

                for flag, active in pairs(context.flags) do
                    if active and PeekEntries['flag'][flag] then
                        for id, entry in pairs(PeekEntries['flag'][flag]) do
                            if distance < entry.distance and (not entry.isEnabled) or (distance < entry.distance and entry.isEnabled and entry.isEnabled(entity, context, entry.params)) then
                                pTarget = entity
                                pContext = context
                                pParameters = entry.params
                                if entry.distance > maxDist then maxDist = entry.distance end
                                options[#options+1] = entry.options
                                --startRenderLoop(entry, pTarget, pContext, pParameters)
                            end
                        end
                    end
                end

                if #options > 0 then
                    local pOptions = {}
                    for i = 1,#options do
                        local v = options[i]
                        for j=1,#v do
                            local k = v[j]
                            pOptions[#pOptions+1] = k
                        end
                    end
                    local nEntry = {
                        options = pOptions,
                        distance = maxDist
                    }
                    print(json.encode(nEntry))
                    startRenderLoop(nEntry, pTarget, pContext, pParameters) 
                end    
            end

            for _,zone in pairs (PeekEntries['polytarget']) do
                if zone:isPointInside(coords) then
                    if #(plyCoords - zone.center) <= zone.targetoptions.distance then
                        if (not zone.targetoptions.isEnabled) or (zone.targetoptions.isEnabled and zone.targetoptions.isEnabled(zone, zone.targetoptions.params)) then
                            pTarget = zone
                            pContext = {}
                            pParameters = zone.targetoptions.params
                            
                            success = true

                            SendNUIMessage({response = "validTarget", data = zone["targetoptions"]["options"]})
                            while success and targetActive do
                                local plyCoords = GetEntityCoords(PlayerPedId())
                                local hit, coords, entity = RayCastGamePlayCamera(20.0)

                                DisablePlayerFiring(PlayerPedId(), true)

                                if (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24)) then
                                    SetNuiFocus(true, true)
                                    SetCursorLocation(0.5, 0.5)
                                end

                                if not zone:isPointInside(coords) or #(plyCoords - zone.center) > zone.targetoptions.distance then
                                    success = false
                                end

                                Citizen.Wait(1)
                            end
                            SendNUIMessage({response = "leftTarget"})
                        end
                    end
                end
            end
        end

        Citizen.Wait(1)
    end
end

function AddPeekEntryByModel(pModel, pData)
    for i,v in pairs (pModel) do
        if not PeekEntries['model'][v] then PeekEntries['model'][v] = {} end
        PeekEntries['model'][v][#PeekEntries['model'][v]+1] = pData
    end
end

exports('AddPeekEntryByModel', AddPeekEntryByModel)

function AddPeekEntryByFlag(pFlag, pData)
    for i,v in pairs (pFlag) do
        if not PeekEntries['flag'][v] then PeekEntries['flag'][v] = {} end
        PeekEntries['flag'][v][#PeekEntries['flag'][v]+1] = pData
    end
end

exports('AddPeekEntryByFlag', AddPeekEntryByFlag)

function AddPeekEntryByEntityType(pEntityType, pData)
    for i,v in pairs (pEntityType) do
        if not PeekEntries['entity'][v] then PeekEntries['entity'][v] = {} end
        PeekEntries['entity'][v][#PeekEntries['entity'][v]+1] = pData
    end
end

exports('AddPeekEntryByEntityType', AddPeekEntryByEntityType)

function AddPeekEntryByPolyTarget(pName, pCenter, pLength, pWidth, pOptions, pTargetOptions)
    local pZone = BoxZone:Create(pCenter, pLength, pWidth, pOptions)
    pZone.targetoptions = pTargetOptions

    PeekEntries['polytarget'][#PeekEntries['polytarget']+1] = pZone
end

exports('AddPeekEntryByPolyTarget', AddPeekEntryByPolyTarget)

function playerTargetDisable()
    if success then return end

    targetActive = false

    SendNUIMessage({response = "closeTarget"})
end

--NUI CALL BACKS

RegisterNUICallback('selectTarget', function(data, cb)
    SetNuiFocus(false, false)

    success = false

    targetActive = false

    TriggerEvent(data.event, pTarget, pContext, pParameters)
end)

RegisterNUICallback('closeTarget', function(data, cb)
    SetNuiFocus(false, false)

    success = false

    targetActive = false
end)

--Functions from https://forum.cfx.re/t/get-camera-coordinates/183555/14

function RotationToDirection(rotation)
    local adjustedRotation =
    {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction =
    {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination =
    {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
    return b, c, e
end