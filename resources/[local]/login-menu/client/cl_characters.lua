local pedSpawnLoc = {
    [1] = vector4(1766.9494140625,-1658.6889892578,111.70324707031, 280.0),
    [2] = vector4(1767.5845947266,-1657.6889892578,111.70324707031, 240.0),
    [3] = vector4(1767.5845947266,-1656.6889892578,111.70324707031, 240.0),
    [4] = vector4(1767.5845947266,-1655.6889892578,111.70324707031, 240.0),
}

currentPedChoices = {}

function CanPedBeDeleted(ped)
    if ped == nil then
        return false
    end
    if ped == PlayerPedId() then
        return false
    end
    if not DoesEntityExist(ped) then
        return false
    end
    return true
end

function CleanUpArea()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if CanPedBeDeleted(ped) and distance < 90.0 then
            distanceFrom = distance
            DeleteEntity(ped)
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
end

function RequestPedModel(model, callback)
    CreateThread(function()
        local modelHash
        
        if type(model) == "number" then
            modelHash = model
            model = false
        else
            modelHash = GetHashKey(model)
        end

        if not IsModelInCdimage(modelHash) then
            callback(false, model, modelHash)
            error("Model: " .. tostring(model or modelHash) .. " doesn't exist!")
        end

        RequestModel(modelHash)

        local timeOut = GetGameTimer()
        local breakOut = false

        while not HasModelLoaded(modelHash) and not breakOut do
            Wait(100)

            if GetGameTimer() - timeOut >= 10000 then
                callback(false, model, modelHash)
                error("Model: " .. tostring(model or modelHash) .. " request timed while loading!")
                breakOut = true
            end
        end

        callback(true, model, modelHash)
        return
    end)
end

function CreatePlayerCharacterPeds(characters)
    ClearSpawnedPeds()
    CleanUpArea()
    
    for _, char in pairs (characters) do
        local cModel 

        if char.gender == 1 then
            cModel = GetHashKey("mp_f_freemode_01")
        else
            cModel = GetHashKey("mp_m_freemode_01")
        end

        local outfit = json.decode(char.outfit)
        if outfit and outfit.model then
            cModel = outfit.model
        end
        
        local function CreatePedPCall(pHash, pX, pY, pZ)
            local ped = CreatePed(3, pHash, pX, pY, pZ, 0.72, false, false)
            return ped
        end

        RequestPedModel(cModel, function(loaded, model, modelHash) 
            if loaded then
                local newPed

                local success, rData = pcall(CreatePedPCall, modelHash, pedSpawnLoc[_].x, pedSpawnLoc[_].y, pedSpawnLoc[_].z, pedSpawnLoc[_].w, false)
                if success then
                    newPed = rData
                else
                    print("MODEL FAILED TO LOAD IN SPAWN: " .. modelHash)
                    goto skip_ped
                end
                -- SetEntityAlpha(newPed,204,false)
                SetEntityAlpha(newPed, 204, false)
                SetEntityHeading(newPed, pedSpawnLoc[_].w)
                LoadPed(newPed, json.decode(char.outfit), modelHash, char.gender)
                TaskLookAtCoord(newPed, vector3(1771.68,-1659.61,113.03),-1, 0, 2)
                FreezeEntityPosition(newPed, true)
                SetEntityInvincible(newPed, true)
                SetBlockingOfNonTemporaryEvents(newPed, true)

                table.insert(currentPedChoices, {
                    ped = newPed,
                    char = char,
                    pos = _,
                    alpha = 204
                })

                ::skip_ped::
            end
        end)
    end

    if (#characters) == 0 then
        SendNUIMessage({
            firstTime = true
        })
    else
        CreateThread(function()
            local loginCam = exports['spawn_manager']:GetLoginCam()

            while enabled do        
                if (#characters > 0) then
                    local hit, endCoords, surface, entity = screenToWorld(8, PlayerPedId(), GetCamCoord(loginCam))
                    local found

                    if (hit and entity and entity ~= 0) then
                        for _,v in pairs (currentPedChoices) do
                            if (v.ped == entity) then
                                found = v
                                break
                            end
                        end
                    end
                    
                    for i,v in pairs (currentPedChoices) do
                        if (found and v.ped == found.ped) or (currentPed and v.ped == currentPed) then
                            if v.alpha ~= 255 then
                                v.alpha = 255
                                SetEntityAlpha(v.ped, 255, false)    
                            end
                        else
                            if (v.alpha ~= 204) and (not currentPed or currentPed ~= v.ped) then
                                v.alpha = 204
                                SetEntityAlpha(v.ped, 204, false)    
                            end
                        end
                    end
                end
                Wait(0)
            end
        end)
    end
end

function DeleteCamera()
	ClearFocus()
	DestroyAllCams(true)
	RenderScriptCams(false, true, 1, true, true)
end

function ClearSpawnedPeds()
	for _, spawnedPed in pairs(currentPedChoices) do
		DeletePed(spawnedPed.ped)
	end
    currentPedChoices = {}
end

AddEventHandler("onResourceStop", function()
	ClearSpawnedPeds()
end)