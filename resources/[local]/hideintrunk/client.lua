exports['players']:SetClientVar("inTrunk", false)

local disabledTrunk = {
    [1] = "penetrator",
    [2] = "vacca",
    [3] = "monroe",
    [4] = "turismor",
    [5] = "osiris",
    [6] = "comet",
    [7] = "ardent",
    [8] = "jester",
    [9] = "nero",
    [10] = "nero2",
    [11] = "vagner",
    [12] = "infernus",
    [13] = "zentorno",
    [14] = "comet2",
    [15] = "comet3",
    [16] = "comet4",
    [17] = "lp700r",
    [18] = "r8ppi",
    [19] = "911turbos",
    [20] = "rx7rb",
    [21] = "fnfrx7",
    [22] = "delsoleg",
    [23] = "s15rb",
    [24] = "gtr",
    [25] = "fnf4r34",
    [26] = "ap2",
    [27] = "bullet",
    [28] = "divo",
}

function disabledCarCheck(veh)
    for i=1,#disabledTrunk do
        if GetEntityModel(veh) == GetHashKey(disabledTrunk[i]) then
            return true
        end
    end
    return false
end
exports('disabledCarCheck', disabledCarCheck)

local inTrunk = false

AddEventHandler("players:ClientVarChanged", function(name, old, new)
    if name == "inTrunk" then
        inTrunk = new
    end
end)

local trunkVeh = 0
local cam = 0

function CamTrunk()
    if(not DoesCamExist(cam)) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamCoord(cam, GetEntityCoords(PlayerPedId()))
        SetCamRot(cam, 0.0, 0.0, 0.0)
        SetCamActive(cam,  true)
        RenderScriptCams(true,  false,  0,  true,  true)
        SetCamCoord(cam, GetEntityCoords(PlayerPedId()))
    end
    
    AttachCamToEntity(cam, PlayerPedId(), 0.0,-2.5,1.0, true)
    SetCamRot(cam, -30.0, 0.0, GetEntityHeading(PlayerPedId()) )
end

function CamDisable()
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
end

local offsets = {
	[1] = { ["name"] = "taxi", ["yoffset"] = 0.0, ["zoffset"] = -0.5 },
    [2] = { ["name"] = "buccaneer", ["yoffset"] = 0.5, ["zoffset"] = 0.0 },
    [3] = { ["name"] = "peyote", ["yoffset"] = 0.35, ["zoffset"] = -0.15 },
    [4] = { ["name"] = "regina", ["yoffset"] = 0.2, ["zoffset"] = -0.35 },
    [5] = { ["name"] = "pigalle", ["yoffset"] = 0.2, ["zoffset"] = -0.15 },
    [6] = { ["name"] = "pol3", ["yoffset"] = 0.1, ["zoffset"] = -0.2 },
    [7] = { ["name"] = "glendale", ["yoffset"] = 0.0, ["zoffset"] = -0.35 },
}

function TrunkOffset(veh)
    for i=1,#offsets do
        if GetEntityModel(veh) == GetHashKey(offsets[i]["name"]) then
            return i
        end
    end
    return 0
end

function DrawText3DTest(x,y,z, text, opac)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, opac)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 40, 10, 10, 68)
end

function getInTrunk(veh)
    if disabledCarCheck(veh) then return end

    if not DoesVehicleHaveDoor(veh, 6) and DoesVehicleHaveDoor(veh, 5) and IsThisModelACar(GetEntityModel(veh)) then
        SetVehicleDoorOpen(veh, 5, 1, 1)
        local playerPed = PlayerPedId()

        local d1,d2 = GetModelDimensions(GetEntityModel(veh))
        if d2["z"] > 1.4 then
            return
        end

        exports['players']:SetClientVar("inTrunk", true)
        inTrunk = true

        local testdic = "fin_ext_p1-7"
        local testanim = "cs_devin_dual-7"

        RequestAnimDict(testdic)
        while not HasAnimDictLoaded(testdic) do
            Citizen.Wait(0)
        end

        SetBlockingOfNonTemporaryEvents(playerPed, true)      
        SetPedSeeingRange(playerPed, 0.0)     
        SetPedHearingRange(playerPed, 0.0)        
        SetPedFleeAttributes(playerPed, 0, false)     
        SetPedKeepTask(playerPed, true)   
        DetachEntity(playerPed)
        ClearPedTasks(playerPed)
        TaskPlayAnim(playerPed, testdic, testanim, 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)

        local OffSet = TrunkOffset(veh)

        if OffSet > 0 then
        	AttachEntityToEntity(playerPed, veh, 0, -0.1,(d1["y"]+0.85) + offsets[OffSet]["yoffset"],(d2["z"]-0.87) + offsets[OffSet]["zoffset"], 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
        else
        	AttachEntityToEntity(playerPed, veh, 0, -0.1,d1["y"]+0.85,d2["z"]-0.87, 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
        end

        trunkVeh = veh

        while inTrunk do
            CamTrunk()

            local DropPosition = GetOffsetFromEntityInWorldCoords(veh, 0.0,d1["y"]-0.2,0.0)
            DrawText3DTest(DropPosition["x"],DropPosition["y"],DropPosition["z"],"[F] Roni välja | [G] Ava/Sulge", 180)

            if IsControlJustReleased(0,47) then
                if GetVehicleDoorAngleRatio(veh, 5) > 0.0 then
                    SetVehicleDoorShut(veh, 5, 1, true)
                else
                    SetVehicleDoorOpen(veh, 5, 1, true)
                end                    
            end

            if IsControlJustReleased(0,23) then
                exports['players']:SetClientVar("inTrunk", false)
                inTrunk = false
            end        
            
            if GetVehicleEngineHealth(veh) < 100.0 or not DoesEntityExist(veh) then
                exports['players']:SetClientVar("inTrunk", false)
                SetVehicleDoorOpen(trunkVeh, 5, 1, 1)
                inTrunk = false
                trunkVeh = 0
            end
            
            if not IsEntityPlayingAnim(playerPed, testdic, testanim, 3) then
                TaskPlayAnim(playerPed, testdic, testanim, 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
            end
    
            Citizen.Wait(1)
    
        end

        DoScreenFadeOut(10)
        CamDisable()

        SetVehicleDoorOpen(veh, 5, 1, true)

        DetachEntity(playerPed)
        
        if DoesEntityExist(veh) then
            local DropPosition = GetOffsetFromEntityInWorldCoords(veh, 0.0,d1["y"]-0.5,0.0)
            SetEntityCoords(playerPed,DropPosition["x"],DropPosition["y"],DropPosition["z"])
        end

        DoScreenFadeIn(2000)    
        Wait(2000)
        SetVehicleDoorShut(veh, 5, false)
    end
end

RegisterCommand("trunk", function()
    local vehInDirection = exports['modules']:getModule("Game").GetVehicleInDirection()
    if vehInDirection and GetVehicleDoorLockStatus(vehInDirection) ~= 2 and not exports['players']:GetClientVar("inTrunk") then
        local model = GetEntityModel(vehInDirection)
        local coords = GetModelDimensions(model)

        local playerPed = PlayerPedId()
        local startPosition = GetOffsetFromEntityInWorldCoords(playerPed, 0, 0.5, 0);
        local back = GetOffsetFromEntityInWorldCoords(vehInDirection, 0.0, coords[2] - 0.5, 0.0);
        local distanceRear = GetDistanceBetweenCoords(startPosition[1],startPosition[2],startPosition[3], back[1], back[2], back[3]);

        if distanceRear < 3 then
            getInTrunk(vehInDirection) 
        end
    end
end)

AddEventHandler("vehicle:getInTrunk", function(vehicle)
    getInTrunk(vehicle)
end)

exports('getInTrunk', getInTrunk)