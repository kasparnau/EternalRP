local SmokeEnabled, SmokeR, SmokeG, SmokeB, SmokeSize = false, 0.0, 0.0, 0.0, 1.0

local PlayerSmokeSettings = {}

RegisterNetEvent('JM36-FSRP:PlaneSmokeSettingsUpdate')
AddEventHandler('JM36-FSRP:PlaneSmokeSettingsUpdate', function(Data)
	PlayerSmokeSettings = Data
end)

local function UpdatePlaneSmokeSettings(sEnabled, sR, sG, sB, sSize)
	SmokeEnabled, SmokeR, SmokeG, SmokeB, SmokeSize = sEnabled, sR, sG, sB, sSize
	TriggerServerEvent("JM36-FSRP:PlaneSmokeSettingsUpdate", {SmokeEnabled, SmokeR, SmokeG, SmokeB, SmokeSize})
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(0, 20) and IsPedInAnyPlane(PlayerPedId()) then
			UpdatePlaneSmokeSettings(not SmokeEnabled, SmokeR, SmokeG, SmokeB, SmokeSize)
		end
	end
end)

local ActiveFx = {}

Citizen.CreateThread(function()
	local particleDictionary = "scr_ar_planes"
	local particleName = "scr_ar_trail_smoke"
	RequestNamedPtfxAsset(particleDictionary)
	while not HasNamedPtfxAssetLoaded(particleDictionary) do
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(0)
		
		for _, player in ipairs(GetActivePlayers()) do
			local ped = GetPlayerPed(player)
			local veh = GetVehiclePedIsUsing(ped)
			local Data = PlayerSmokeSettings[GetPlayerServerId(player)]
			if Data ~= nil then
				local SmokeEnabled, SmokeR, SmokeG, SmokeB, SmokeSize = table.unpack(Data)
				if (IsPedInAnyPlane(ped) and not IsEntityDead(veh)) and SmokeEnabled then
					if not ActiveFx[veh] then
						UseParticleFxAssetNextCall(particleDictionary)
						local ox, oy, oz = 0.0, 0.0, 0.0
						ActiveFx[veh] = StartNetworkedParticleFxLoopedOnEntityBone(particleName, veh, ox, oy, oz, 0.0, 0.0, 0.0, -1, SmokeSize + 0.0, ox, oy, oz)
					elseif ActiveFx[veh] and not IsEntityDead(veh) then
						SetParticleFxLoopedScale(ActiveFx[veh], SmokeSize+0.0)
						SetParticleFxLoopedRange(ActiveFx[veh], 10000.0)
						SetParticleFxLoopedColour(ActiveFx[veh], SmokeR + 0.0, SmokeG + 0.0, SmokeB + 0.0)
					end
				else
					if ActiveFx[veh] or IsEntityDead(veh) or not veh then
						StopParticleFxLooped(ActiveFx[veh], 0)
						ActiveFx[veh] = nil
					end
				end
			end
		end
	end
end)

RegisterCommand("smokecolor", function(source, args, raw)
	UpdatePlaneSmokeSettings(SmokeEnabled, tonumber(args[1]) + 0.0, tonumber(args[2]) + 0.0, tonumber(args[3]) + 0.0, SmokeSize)
end)

RegisterCommand("smokesize", function(source, args, raw)
	local SmokeSize = tonumber(args[1]) + 0.0
	if SmokeSize > 5.0 then SmokeSize = 5.0 elseif SmokeSize <= 0.0 then SmokeSize = 0.1 end
	UpdatePlaneSmokeSettings(SmokeEnabled, SmokeR, SmokeG, SmokeB, SmokeSize)
end)

UpdatePlaneSmokeSettings(SmokeEnabled, SmokeR, SmokeG, SmokeB, SmokeSize)