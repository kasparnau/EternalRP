polyChecks = {
    bennys = { isInside = false, data = nil },
}

function IsDisabled()
    return exports['players']:GetClientVar("isDead") 
    or exports['players']:GetClientVar("isCuffed")
    or not exports['players']:GetClientVar("inGame") 
    or IsPedInAnyVehicle(PlayerPedId())
end

function GetPedContext(pEntity, pContext)
    local npcId = DecorGetInt(pEntity, 'NPC_ID')

    return npcId
end

function GetEntityContext(pEntity, pEntityType, pEntityModel)
    local context = { flags = {}, model = nil, type = nil, zones = {} }

    if not pEntity then return context end

    context.type = pEntityType or GetEntityType(pEntity)
    context.model = pEntityModel or GetEntityModel(pEntity)

    if context.type == 1 then
        context.flags = exports['jp-flags']:GetPedFlags(pEntity)
        context.flags['isPlayer'] = IsPedAPlayer(pEntity)
        if context.flags['isNPC'] then 
            context.npcId = DecorGetInt(pEntity, 'NPC_ID')
            --GetPedContext(pEntity, context) 
        end
    elseif context.type == 2 then
        context.flags = exports['jp-flags']:GetVehicleFlags(pEntity)
    elseif context.type == 3 then
        context.flags = exports['jp-flags']:GetObjectFlags(pEntity)
    end

    if ModelFlags[context.model] then
        for _, flag in ipairs(ModelFlags[context.model]) do
            context.flags[flag] = true
        end
    end

    return context
end

exports('GetEntityContext', GetEntityContext)

function GetBoneDistance(pEntity, pType, pBone)
    local bone

    if pType == 1 then
        bone = GetPedBoneIndex(pEntity, pBone)
    else
        bone = GetEntityBoneIndexByName(pEntity, pBone)
    end

    local boneCoords = GetWorldPositionOfEntityBone(pEntity, bone)
    local playerCoords = GetEntityCoords(PlayerPedId())

    return #(boneCoords - playerCoords)
end

exports("GetBoneDistance", GetBoneDistance)

function HasWeaponEquipped(pWeaponHash)
    return GetSelectedPedWeapon(PlayerPedId()) == pWeaponHash
end

function isPersonBeingHeldUp(pEntity)
  return (IsEntityPlayingAnim(pEntity, "dead", "dead_a", 3) or IsEntityPlayingAnim(pEntity, "amb@code_human_cower_stand@male@base", "base", 3) or IsEntityPlayingAnim(pEntity, "amb@code_human_cower@male@base", "base", 3) or IsEntityPlayingAnim(pEntity, "random@arrests@busted", "idle_a", 3) or IsEntityPlayingAnim(pEntity, "mp_arresting", "idle", 3) or IsEntityPlayingAnim(pEntity, "random@mugging3", "handsup_standing_base", 3) or IsEntityPlayingAnim(pEntity, "missfbi5ig_22", "hands_up_anxious_scientist", 3) or IsEntityPlayingAnim(pEntity, "missfbi5ig_22", "hands_up_loop_scientist", 3) or IsEntityPlayingAnim(pEntity, "missminuteman_1ig_2", "handsup_base", 3))
end

function getTrunkOffset(pEntity)
  local minDim, maxDim = GetModelDimensions(GetEntityModel(pEntity))
  return GetOffsetFromEntityInWorldCoords(pEntity, 0.0, minDim.y - 0.5, 0.0)
end

function getFrontOffset(pEntity)
    local minDim, maxDim = GetModelDimensions(GetEntityModel(pEntity))
    return GetOffsetFromEntityInWorldCoords(pEntity, 0.0, maxDim.y + 0.5, 0.0)
  end

function isCloseToTrunk(pEntity, pPlayerPed, pDistance, pMustBeOpen)
  return #(getTrunkOffset(pEntity) - GetEntityCoords(pPlayerPed)) <= (pDistance or 1.0) and GetVehicleDoorLockStatus(pEntity) == 1 and (not pMustBeOpen or GetVehicleDoorAngleRatio(pEntity, 5) >= 0.1)
end

function isCloseToHood(pEntity, pPlayerPed, pDistance, pMustBeOpen)
    return #(getFrontOffset(pEntity) - GetEntityCoords(pPlayerPed)) <= (pDistance or 1.0) and GetVehicleDoorLockStatus(pEntity) == 1 and (not pMustBeOpen or GetVehicleDoorAngleRatio(pEntity, 4) >= 0.1)
end

local ModelData = {}

function GetModelData(pEntity, pModel)
    if ModelData[pModel] then return ModelData[pModel] end

    local modelInfo = {}

    local coords = getTrunkOffset(pEntity)
    local boneCoords, engineCoords = GetWorldPositionOfEntityBone(pEntity, GetEntityBoneIndexByName(pEntity, 'engine'))

    if #(boneCoords - coords) <= 2.0 then
        engineCoords = coords
        modelInfo = { engine = { position = 'trunk', door = 4 }, trunk = { position = 'front', door = 5 } }
    else
        engineCoords = getFrontOffset(pEntity)
        modelInfo = { engine = { position = 'front', door = 4 }, trunk = { position = 'trunk', door = 5 } }
    end

    local hasBonnet = DoesVehicleHaveDoor(pEntity, 4)
    local hasTrunk = DoesVehicleHaveDoor(pEntity, 5)

    if hasBonnet then
        local bonnetCoords = GetWorldPositionOfEntityBone(pEntity, GetEntityBoneIndexByName(pEntity, 'bonnet'))
        
        if #(engineCoords - bonnetCoords) <= 2.0 then
            modelInfo.engine.door = 4
            modelInfo.trunk.door = hasTrunk and 5 or 3
        elseif hasTrunk then
            modelInfo.engine.door = 5
            modelInfo.trunk.door = 4
        end
    elseif hasTrunk then
        local bootCoords = GetWorldPositionOfEntityBone(pEntity, GetEntityBoneIndexByName(pEntity, 'boot'))

        if #(engineCoords - bootCoords) <= 2.0 then
            modelInfo.engine.door = 5
        end
    end

    ModelData[pModel] = modelInfo

    return modelInfo
end

function isCloseToEngine(pEntity, pPlayerPed, pDistance, pModel)
    local model = pModel or GetEntityModel(pEntity)
    local modelData = GetModelData(pEntity, model)

    local playerCoords = GetEntityCoords(pPlayerPed)

    local engineCoords = modelData.engine.position == 'front' and getFrontOffset(pEntity) or getTrunkOffset(pEntity)

    return #(engineCoords - playerCoords) <= pDistance
end

function isCloseToBoot(pEntity, pPlayerPed, pDistance, pModel)
    local model = pModel or GetEntityModel(pEntity)
    local modelData = GetModelData(pEntity, model)

    local playerCoords = GetEntityCoords(pPlayerPed)

    local engineCoords = modelData.trunk.position == 'front' and getFrontOffset(pEntity) or getTrunkOffset(pEntity)

    return #(engineCoords - playerCoords) <= pDistance
end

exports('isCloseToBoot', isCloseToBoot)

local CachedEntity, CachedEngineDoor, CachedTrunkDoor = nil, nil, nil

function getEngineDoor(pEntity, pModel)
    if CachedEntity == pEntity and CachedEngineDoor then return CachedEngineDoor end

    local model = pModel or GetEntityModel(pEntity)
    local modelData = GetModelData(pEntity, model)

    CachedEntity, CachedEngineDoor = pEntity, modelData.engine.door

    return modelData.engine.door
end

function getTrunkDoor(pEntity, pModel)
    if CachedEntity == pEntity and CachedTrunkDoor then return CachedTrunkDoor end

    local model = pModel or GetEntityModel(pEntity)
    local modelData = GetModelData(pEntity, model)

    CachedEntity, CachedTrunkDoor = pEntity, modelData.trunk.door

    return modelData.trunk.door
end

function isVehicleDoorOpen(pEntity, pDoor)
    return GetVehicleDoorAngleRatio(pEntity, pDoor) >= 0.1
end

AddEventHandler("jp-polyzone:enter", function(zone, data)
    print ("Entered zone: "..zone)
    if zone == "bennys" then
        local plyPed = PlayerPedId()

        polyChecks.bennys = { isInside = true, polyData = data }
    end
end)

AddEventHandler("jp-polyzone:exit", function(zone)
    print ("Left zone: "..zone)
    if zone == "bennys" then polyChecks.bennys = { isInside = false, polyData = nil } end
end)