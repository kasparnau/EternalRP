function startLoops()
    local playerPed = PlayerPedId()
    local pedVehicle = GetVehiclePedIsIn(playerPed,false)
    local pedVehicleModel = GetEntityModel(pedVehicle)
    local isPedInAnyVehicle = IsPedInAnyVehicle(playerPed, false)

    CreateThread(function()
        while true do
            playerPed = PlayerPedId()
            playerId = PlayerId()
            isPedInAnyVehicle = IsPedInAnyVehicle(playerPed, false)

            if isPedInAnyVehicle then
                pedVehicle = GetVehiclePedIsIn(playerPed,false)
                pedVehicleModel = GetEntityModel(pedVehicle)    
            end

            Wait(500)
        end
    end)

    local flyingCars = {
        [`oppressor`] = true,
        [`oppressor2`] = true,
        [`deluxo`] = true,
    }

    CreateThread(function()
        while true do
            if isPedInAnyVehicle then
                if GetPedInVehicleSeat(pedVehicle, 0) == playerPed then    
                    if GetIsTaskActive(playerPed, 165) then
                        SetPedIntoVehicle(playerPed, pedVehicle, 0)
                    end
                elseif GetPedInVehicleSeat(pedVehicle, -1) == playerPed then
                    local model = GetEntityModel(pedVehicle)
                    local roll = GetEntityRoll(pedVehicle)
              
                    if not IsThisModelABoat(model)
                      and not IsThisModelAHeli(model)
                      and not IsThisModelAPlane(model)
                      and not IsThisModelABicycle(model)
                      and not IsThisModelABike(model)
                      and not IsThisModelAJetski(model)
                      and not IsThisModelAQuadbike(model)
                      and not flyingCars[model]
                      and (IsEntityInAir(pedVehicle) or (roll < -50 or roll > 50)) then
                        DisableControlAction(0, 59) -- leaning left/right
                        DisableControlAction(0, 60) -- leaning up/down
                    end
                end
            end
            Wait(1)
        end
    end)
end

startLoops()

AddEventHandler("general:flipVehicle", function()
    local vehInDirection = exports['modules']:getModule("Game").GetVehicleInDirection()
	if vehInDirection then
        local roll = GetEntityRoll(vehInDirection)
        if (roll > 75.0 or roll < -75.0) then
            exports['progress']:Progress({
                name = "FlippingVehicle",
                duration = 7500,
                label = 'Flipping Vehicle',
                useWhileDead = false,
                canCancel = true,
                controlDisables = {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,},
                animation = {animDict = "missfinale_c2ig_11",anim = "pushcar_offcliff_m"},
                }, function(cancelled)
                ClearPedTasksImmediately(PlayerPedId())
                if not cancelled and DoesEntityExist(vehInDirection) then
                    local roll = GetEntityRoll(vehInDirection)
                    if (roll > 75.0 or roll < -75.0) then
                        SetVehicleOnGroundProperly(vehInDirection)
                    end
                end
            end)
        end
	end
end)


function randomizePlate()
    local chars = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
    local plate = ""
    for i = 1, 8 do
        if (math.random(1, 100)>50) then
            plate = (plate..chars[math.random(1, #chars)])
        else
            plate = (plate..math.random(0,9))
        end
    end
    return plate
end

exports('randomPlate', randomizePlate)

---////////
local vehicle

local function getField(field)
    return GetVehicleHandlingFloat(vehicle, 'CHandlingData', field)
end

local statsCache = {}
local function calculateStats(pVehicle)
    if pVehicle then vehicle = pVehicle end
    local info = {}
  
    local model = GetEntityModel(vehicle)
    --if statsCache[model] then return statsCache[model].info, statsCache[model].vehClass, statsCache[model].perfRating end
  
    local isMotorCycle = IsThisModelABike(model)
  
    local fInitialDriveMaxFlatVel = getField("fInitialDriveMaxFlatVel")
    local fInitialDriveForce = getField("fInitialDriveForce")
    local fDriveBiasFront = getField("fDriveBiasFront")
    local fInitialDragCoeff = getField("fInitialDragCoeff")
    local fTractionCurveMax = getField("fTractionCurveMax")
    local fTractionCurveMin = getField("fTractionCurveMin")
    local fSuspensionReboundDamp = getField("fSuspensionReboundDamp")
    local fBrakeForce = getField("fBrakeForce")
    
    -- Acceleration: (fInitialDriveMaxFlatVel x fInitialDriveForce)/10
    -- If the fDriveBiasFront is greater than 0 but less than 1, multiply fInitialDriveForce by 1.1.
    local force = fInitialDriveForce
    if fInitialDriveForce > 0 and fInitialDriveForce < 1 then
      force = force * 1.1
    end
    local accel = (fInitialDriveMaxFlatVel * force) / 10
    info[#info + 1] = { name = "Acceleration", value = accel }
  
    -- Speed:
    -- ((fInitialDriveMaxFlatVel / fInitialDragCoeff) x (fTractionCurveMax + fTractionCurveMin))/40
    local speed = ((fInitialDriveMaxFlatVel / fInitialDragCoeff) * (fTractionCurveMax + fTractionCurveMin)) / 40
    if isMotorCycle then
      speed = speed * 2
    end
    info[#info + 1] = { name = "Speed", value = speed }
  
    -- Handling:
    -- (fTractionCurveMax + fSuspensionReboundDamp) x fTractionCurveMin
    local handling = (fTractionCurveMax + fSuspensionReboundDamp) * fTractionCurveMin
    if isMotorCycle then
      handling = handling / 2
    end
    info[#info + 1] = { name = "Handling", value = handling }
  
    -- Braking:
    -- ((fTractionCurveMin / fInitialDragCoeff) x fBrakeForce) x 7
    local braking = ((fTractionCurveMin / fInitialDragCoeff) * fBrakeForce) * 7
    info[#info + 1] = { name = "Braking", value = braking }
  
    -- Overall Performance Bracket:
    -- ((Acceleration x 5) + Speed + Handling + Braking) * 15
    -- X Class: >1000
    -- S Class: >650
    -- A Class: >500
    -- B Class: >400
    -- C Class: >325
    -- D Class: =<325
    local perfRating = ((accel * 5) + speed + handling + braking) * 15
    local vehClass = "F"
    if isMotorCycle then
      vehClass = "M"
    elseif perfRating > 900 then
      vehClass = "X"
    elseif perfRating > 700 then
      vehClass = "S"
    elseif perfRating > 550 then
      vehClass = "A"
    elseif perfRating > 400 then
      vehClass = "B"
    elseif perfRating > 325 then
      vehClass = "C"
    else
      vehClass = "D"
    end
    statsCache[model] = { info = info, vehClass = vehClass, perfRating = perfRating }
    return info, vehClass, perfRating
end

RegisterCommand("doit", function()
    vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local info, vehClass = calculateStats()
    print ("Klass: "..vehClass)
    print ("Info: "..json.encode(info))
end)


CreateThread(function()
    AddEventHandler("vehicle:examineVehicle", function(pEntity, pContext, pParams)
        local data, vehClass, perfRating = calculateStats(pEntity)
        local info = ("Klass: %s | Reiting: %s"):format(vehClass, math.ceil(perfRating))
        local MenuData = {
            {
                title = "Sõiduki Informatsioon",
                desc = info
            },
            {
                title = "Sõiduki Diagnostika",
                desc = "Coming soon..."
            }
        }
        exports['jp-menu']:showContextMenu(MenuData, "Sõiduki Uuring")
    end)
end)

-- RemoveReplaceTexture('vw_prop_vw_luckywheel_01a', 'script_rt_casinowheel')
-- local wheelDui = CreateDui("https://gta-files.nopixel.net/casinowheel/", 1024, 1024)
-- local dui = GetDuiHandle(wheelDui)
-- local txd = CreateRuntimeTxd("duiTxdCasinoWheel")
-- local tx = CreateRuntimeTextureFromDuiHandle(txd, 'duiTexCasinoWheel', dui)
-- CreateThread(function()
--     Wait(2000)
--     AddReplaceTexture('vw_prop_vw_luckywheel_01a', 'script_rt_casinowheel', 'duiTxdCasinoWheel', 'duiTexCasinoWheel')
-- end)

local modifiedVehicles = {}

function getVehicleHandling(pVehicleIdentifier, pCurrentVehicleHandle, pHandling)
    if pVehicleIdentifier and pHandling then
        if modifiedVehicles[pVehicleIdentifier] ~= nil and modifiedVehicles[pVehicleIdentifier][pHandling] ~= nil then
            return true, modifiedVehicles[pVehicleIdentifier][pHandling]
        else
            return false, GetVehicleHandlingFloat(pCurrentVehicleHandle, 'CHandlingData', pHandling)
        end
    end
end
  
function setVehicleHandling(pVehicleIdentifier, pCurrentVehicleHandle, pHandling, pFactor)
    local isModified, fValue = getVehicleHandling(pVehicleIdentifier, pCurrentVehicleHandle, pHandling)
    if not isModified then 
        fValue = (fValue * pFactor)
    end
    print (("Set %s to %s"):format(pHandling, fValue))
    modifiedVehicles[pVehicleIdentifier][pHandling] = fValue
    SetVehicleHandlingFloat(pCurrentVehicleHandle, 'CHandlingData', pHandling, fValue)
end

function processVehicleHandling(pCurrentVehicle)
    local vehicleIdentifier = GetVehiclePedIsIn(PlayerPedId())
    if vehicleIdentifier then
      currentVehicleIdentifier = vehicleIdentifier
      SetVehiclePetrolTankHealth(pCurrentVehicle, 4000.0)
      SetVehicleHandlingFloat(pCurrentVehicle, 'CHandlingData', 'fWeaponDamageMult', 5.500000)
      SetVehicleHandlingFloat(pCurrentVehicle, 'CHandlingData', 'fDeformationDamageMult', 1.000000)
  
      local isModified, fSteeringLock = getVehicleHandling(vehicleIdentifier, pCurrentVehicle, 'fSteeringLock')
      if not isModified then 
        fSteeringLock = math.ceil((fSteeringLock * 0.6)) + 0.1
        print ("fSteeringLock: "..fSteeringLock)
      end
      if not modifiedVehicles[vehicleIdentifier] then modifiedVehicles[vehicleIdentifier] = {} end 
      modifiedVehicles[vehicleIdentifier]['fSteeringLock'] = fSteeringLock
      SetVehicleHandlingFloat(pCurrentVehicle, 'CHandlingData', 'fSteeringLock', fSteeringLock)
  
      if IsThisModelABike(GetEntityModel(pCurrentVehicle)) then
          setVehicleHandling(vehicleIdentifier, pCurrentVehicle, 'fTractionCurveMin', 0.6)
          setVehicleHandling(vehicleIdentifier, pCurrentVehicle, 'fTractionCurveMax', 0.6)
          setVehicleHandling(vehicleIdentifier, pCurrentVehicle, 'fInitialDriveForce', 2.2)
          setVehicleHandling(vehicleIdentifier, pCurrentVehicle, 'fBrakeForce', 1.4)
          SetVehicleHandlingFloat(pCurrentVehicle, 'CHandlingData', 'fSuspensionReboundDamp', 5.000000)
          SetVehicleHandlingFloat(pCurrentVehicle, 'CHandlingData', 'fSuspensionCompDamp', 5.000000)
          SetVehicleHandlingFloat(pCurrentVehicle, 'CHandlingData', 'fSuspensionForce', 22.000000)
          SetVehicleHandlingFloat(pCurrentVehicle, 'CHandlingData', 'fCollisionDamageMult', 2.500000)
          SetVehicleHandlingFloat(pCurrentVehicle, 'CHandlingData', 'fEngineDamageMult', 0.120000)
      else
          setVehicleHandling(vehicleIdentifier, pCurrentVehicle, 'fTractionCurveMin', 1.0)
          setVehicleHandling(vehicleIdentifier, pCurrentVehicle, 'fBrakeForce', 0.5)
          SetVehicleHandlingFloat(pCurrentVehicle, 'CHandlingData', 'fEngineDamageMult', 0.250000)
          SetVehicleHandlingFloat(pCurrentVehicle, 'CHandlingData', 'fCollisionDamageMult', 2.900000)
      end
  
      modifiedVehicles[vehicleIdentifier].fInitialDriveMaxFlatVel = GetVehicleHandlingFloat(pCurrentVehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel')
      modifiedVehicles[vehicleIdentifier].fTractionLossMult = GetVehicleHandlingFloat(pCurrentVehicle, 'CHandlingData', 'fTractionLossMult')
      modifiedVehicles[vehicleIdentifier].fLowSpeedTractionLossMult = GetVehicleHandlingFloat(pCurrentVehicle, 'CHandlingData', 'fLowSpeedTractionLossMult')
      modifiedVehicles[vehicleIdentifier].fDriveBiasFront = GetVehicleHandlingFloat(pCurrentVehicle, 'CHandlingData', 'fDriveBiasFront')
      modifiedVehicles[vehicleIdentifier].fDriveInertia = GetVehicleHandlingFloat(pCurrentVehicle, 'CHandlingData', 'fDriveInertia')
  
      -- print("fTractionLoss", modifiedVehicles[currentVehicleIdentifier].fTractionLossMult)
      -- print("fTractionCurveMin", modifiedVehicles[currentVehicleIdentifier].fTractionCurveMin)
      -- print("fLowSpeedTractionLossMult", modifiedVehicles[currentVehicleIdentifier].fLowSpeedTractionLossMult)
  
      SetVehicleHasBeenOwnedByPlayer(pCurrentVehicle, true)
    end
end  

RegisterCommand("bike", function()
    processVehicleHandling(GetVehiclePedIsIn(PlayerPedId()))
end)