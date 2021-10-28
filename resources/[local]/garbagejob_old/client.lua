local players = exports['players']
local events = exports['events']

local playerPed = PlayerPedId()
local playerJob = exports['players']:GetClientVar("character") and exports['players']:GetClientVar("character").job or "Unemployed"

local keys = exports['modules']:getModule("Enums").Keys
local blips = {
	{
		['coords'] = vector3(-321.70, -1545.94, 31.02),
		['name'] = 'Car'
	}
}
local jobVehicle = nil
local randomGarbage = vector3(0,0,0)
local cancelled = false
local missionBlip = nil
local garbageBlip = nil
local trashbag = nil

local trashCoords = {
    {x = 114.83280181885, y = -1462.3127441406, z = 29.295083999634},
    {x = -6.0481648445129, y = -1566.2338867188, z = 29.209197998047},
    {x = -1.8858588933945, y = -1729.5538330078, z = 29.300233840942},
    {x = 159.09, y = -1816.69, z = 27.9},
    {x = 358.94696044922, y = -1805.0723876953, z = 28.966590881348},
    {x = 481.36560058594, y = -1274.8297119141, z = 29.64475440979},
    {x = 254.70010375977, y = -985.32482910156, z = 29.196590423584},
    {x = 240.08079528809, y = -826.91204833984, z = 30.018426895142},
    {x = 342.78308105469, y = -1036.4720458984, z = 29.194206237793},
    {x = 462.17517089844, y = -949.51434326172, z = 27.959424972534},
    {x = 317.53698730469, y = -737.95416259766, z = 29.278547286987},
    {x = 410.22503662109, y = -795.30517578125, z = 29.20943069458},
    {x = 398.36038208008, y = -716.35577392578, z = 29.282489776611},
    {x = 443.96984863281, y = -574.33978271484, z = 28.494501113892},
    {x = -1332.53, y = -1198.49, z = 4.62},
    {x = -45.443946838379, y = -191.32261657715, z = 52.161594390869},
    {x = -31.948055267334, y = -93.437454223633, z = 57.249073028564},
    {x = 283.10873413086, y = -164.81878662109, z = 60.060565948486},
    {x = 441.89678955078, y = 125.97653198242, z = 99.887702941895},
}
local Dumpsters = {
    "prop_dumpster_01a",
    "prop_dumpster_02a",
    "prop_dumpster_02b",
    "prop_dumpster_3a",
    "prop_dumpster_4a",
    "prop_dumpster_4b",
    "prop_skip_01a",
    "prop_skip_02a",
    "prop_skip_06a",
    "prop_skip_05a",
    "prop_skip_03",
    "prop_skip_10a"
}

local availableTrash = {}

local myBlips = {}
local amountOfTrashRequired = 15
local amountOfTrash = 0

AddEventHandler("jp:onPedChange", function(ped)
	playerPed = ped
end)

local playerVehicle = IsPedInAnyVehicle(playerPed) and GetVehiclePedIsIn(playerPed, false) or nil
AddEventHandler('baseevents:enteredVehicle', function(pCurrentVehicle, currentSeat, vehicleDisplayName)
	playerVehicle = pCurrentVehicle
end)
AddEventHandler('baseevents:leftVehicle', function(pCurrentVehicle, pCurrentSeat, vehicleDisplayName)
	playerVehicle = nil
end)  

AddEventHandler("login:firstSpawn", function(newChar)
	playerJob = newChar.job
	handleJob()
end)

AddEventHandler("players:CharacterVarChanged", function(name, old, new)
	if name == 'job' then
		playerJob = new
	end

	if name == 'job' then handleJob() end
end)

CreateThread(function()
	while true do
		if (playerJob == 'Sanitation') and not exports['missions']:ongoing() then
			local plrCoords = GetEntityCoords(playerPed)

			if not playerVehicle then
				if #(plrCoords - vector3(-321.70, -1545.94, 31.02)) < 2.5 then
					DrawText3D(-321.70, -1545.94, 31.02, "[E] Rendi prügiauto")
					if IsControlJustPressed(0, keys["E"]) then
						local spawnPointClear = exports['modules']:getModule("Game").IsSpawnPointClear(vector3(-323.53, -1523.58, 27.00), 3.0)
						if spawnPointClear then
							exports['modules']:getModule("Game").SpawnVehicle("trash2", vector3(-323.53, -1523.58, 27.00), 269.7, function(vehicle)
								SetPedIntoVehicle(playerPed, vehicle, -1)
								exports['keys']:addKeys(vehicle)
								jobVehicle = vehicle
								Wait(500)
								TriggerEvent("engine:toggleEngine")
								startMission()
							end)
						else
							exports['alerts']:notify('Prügimees', "Seda sõidukit ei saa tekitada! Midagi on spawni kohal ees.", 'errorAlert')
						end
					end
				end
			end

			Wait(1)
		else
			Wait(200)
		end
	end
end)

function startMission()
	exports['missions']:show()
	amountOfTrash = 0
	cancelled = false

	availableTrash = trashCoords

	CreateThread(function()
		while exports['missions']:ongoing() and not cancelled do
			local playerPos = GetEntityCoords(playerPed)
			local dist = #(GetEntityCoords(jobVehicle) - playerPos)

			if dist > 100.0 then
				cancelled = true
				if missionBlip then 
					SetBlipRoute(missionBlip, false)
					RemoveBlip(missionBlip)
				end
				if garbageBlip then RemoveBlip(garbageBlip) end
				if trashbag then DeleteObject(trashbag) end
				exports['missions']:hide()

				exports['alerts']:notify('Prügimees', "Jooksid oma sõidukist liiga kaugele ja ebaõnnistusid missiooni.", 'errorAlert', 3000)
			end
			Wait(100)
		end
	end)

	for i = 1, amountOfTrashRequired do
		local randomNumber = math.random(1, #availableTrash)
		randomGarbage = vector3(availableTrash[randomNumber].x, availableTrash[randomNumber].y, availableTrash[randomNumber].z)
		table.remove(availableTrash, randomNumber)

		missionBlip = AddBlipForCoord(randomGarbage)
		SetBlipRoute(missionBlip, true)
		SetBlipRouteColour(missionBlip, 11)
		SetBlipColour(missionBlip, 11)

		local arrived = false
		local waitTime = 100

		while not arrived and not cancelled do
			Wait(waitTime)

			if playerVehicle ~= jobVehicle then
				exports['missions']:update({
					title = ("Garbage Pickup  ("..amountOfTrash.."/"..amountOfTrashRequired..")"),
					desc = ("Mine enda prügiautosse.")
				})
			else
				exports['missions']:update({
					title = ("Garbage Pickup  ("..amountOfTrash.."/"..amountOfTrashRequired..")"),
					desc = ("Sõida järgmisesse prügipunkti.")
				})		
			end
			
			local playerPos = GetEntityCoords(playerPed)
			local dist = #(randomGarbage - playerPos)

			if dist < 5 then
				waitTime = 5
				arrived = true
                SetBlipRoute(missionBlip, false)
				RemoveBlip(missionBlip)
				findTrashBins()
				amountOfTrash = amountOfTrash + 1
			else
				waitTime = 100
			end
		end
	end

	if cancelled then return end

	local submitCoords = vector3(-354.28,-1560.88,24.9)

	local arrived = false
	local waitTime = 100

	missionBlip = AddBlipForCoord(submitCoords)
	SetBlipRoute(missionBlip, true)
	SetBlipRouteColour(missionBlip, 11)
	SetBlipColour(missionBlip, 11)

	while not arrived do
		Wait(waitTime)

		if playerVehicle ~= jobVehicle then
			exports['missions']:update({
				title = ("Garbage Pickup  ("..amountOfTrash.."/"..amountOfTrashRequired..")"),
				desc = ("Mine enda prügiautosse.")
			})
		else
			exports['missions']:update({
				title = ("Garbage Pickup  ("..amountOfTrash.."/"..amountOfTrashRequired..")"),
				desc = ("Sõida prügimüügipunkti ja kogu oma raha.")
			})
		end

		if playerVehicle == jobVehicle then
			local playerPos = GetEntityCoords(playerPed)
			local dist = #(submitCoords - playerPos)
	
			if dist < 10 then
				waitTime = 5
	
				DrawMarker(20, submitCoords + vector3(0.0,0.0,2.5), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 50, false, true, 2, false, false, false, false)
				BeginTextCommandDisplayHelp("STRING")
				AddTextComponentSubstringPlayerName("Vajuta ~INPUT_CONTEXT~ et prügi ära visata.")
				EndTextCommandDisplayHelp(0, 0, 1, -1)

				if IsControlJustPressed(1, 46) then
					SetBlipRoute(missionBlip, false)
					RemoveBlip(missionBlip)
					
					print "GET MONEY"
					exports['modules']:getModule("Game").DeleteVehicle(jobVehicle)
					exports['missions']:hide()

					arrived = true
					return
				end
			else
				waitTime = 100
			end	
		end
	end
end

function findTrashBins()
	exports['missions']:update({
		title = ("Garbage Pickup ("..amountOfTrash.."/"..amountOfTrashRequired..")"),
		desc = ("Korja prügikastist prügi.")
	})

    local boneindex = GetPedBoneIndex(playerPed, 57005)

	if not HasAnimDictLoaded("anim@heists@narcotics@trash") then
        RequestAnimDict("anim@heists@narcotics@trash")
    end
    while not HasAnimDictLoaded("anim@heists@narcotics@trash") do
        Citizen.Wait(0)
    end

	for i = 1, #Dumpsters do 
		local NewBin = GetClosestObjectOfType(randomGarbage.x, randomGarbage.y, randomGarbage.z, 10.0, GetHashKey(Dumpsters[i]), false)
		print (NewBin)
		if NewBin ~= 0 then
			local dumpCoords = GetEntityCoords(NewBin)

			local dist = #(dumpCoords - GetEntityCoords(playerPed))
			garbageBlip = AddBlipForCoord(dumpCoords)
			SetBlipSprite(garbageBlip, 420)
			SetBlipScale (garbageBlip, 0.8)
			SetBlipColour(garbageBlip, 25)
			while not cancelled do
				Wait(5) 
				local userDist = GetDistanceBetweenCoords(dumpCoords,GetEntityCoords(GetPlayerPed(-1)),true) 
				if userDist < 20 then
					DrawMarker(20, dumpCoords + vector3(0.0,0.0,2.5), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 50, false, true, 2, false, false, false, false)
					if userDist < 5 and not playerVehicle then
						BeginTextCommandDisplayHelp("STRING")
						AddTextComponentSubstringPlayerName("Vajuta ~INPUT_CONTEXT~ et korjata prügi.")
						EndTextCommandDisplayHelp(0, 0, 1, -1)		
						if IsControlJustReleased(1,46) then
							local geeky = CreateObject(GetHashKey("hei_prop_heist_binbag"), 0, 0, 0, true, true, true)
							AttachEntityToEntity(geeky, playerPed, boneindex, 0.12, 0.0, 0.00, 25.0, 270.0, 180.0, true, true, false, true, 1, true)
							TaskPlayAnim(PlayerPedId(-1), 'anim@heists@narcotics@trash', 'walk', 1.0, -1.0,-1,49,0,0, 0,0)
							RemoveBlip(garbageBlip)
							CollectedTrash(geeky,jobVehicle,randomGarbage)
							return
						end
					end
				end
			end
			return
		end
	end
end

function CollectedTrash(geeky,vehicle,location)
	exports['missions']:update({
		title = ("Garbage Pickup ("..amountOfTrash.."/"..amountOfTrashRequired..")"),
		desc = ("Viska prügi oma prügiautosse.")
	})

    local wait = 100
    trashbag = geeky
    local pressed = false
    while not cancelled do
        Wait(wait)
        local trunkcoord = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "platelight"))
        local tdistance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),trunkcoord)
        if tdistance < 20 then
            wait = 5
            DrawMarker(20, trunkcoord + vector3(0.0,0.0,0.5), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 50, false, true, 2, false, false, false, false)
            if tdistance < 2 then
                BeginTextCommandDisplayHelp("STRING")
				AddTextComponentSubstringPlayerName("Vajuta ~INPUT_CONTEXT~ et visata prügi.")
				EndTextCommandDisplayHelp(0, 0, 1, -1)		
                if IsControlJustReleased(1, 46) and not pressed then
                    pressed = true
                    ClearPedTasksImmediately(GetPlayerPed(-1))
					TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@narcotics@trash', 'throw_b', 1.0, -1.0,-1,2,0,0, 0,0)
                    Citizen.Wait(1000)
					DeleteObject(trashbag)
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    pressed = false
                    return
                end
            end
        end
    end
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function handleJob()
	for i,v in pairs (myBlips) do
		RemoveBlip(v)
	end
	myBlips = {}
	if playerJob == "Sanitation" then
		for i,v in pairs (blips) do
			currentBlip = AddBlipForCoord(v.coords)

			SetBlipSprite(currentBlip, 318)
			SetBlipColour(currentBlip, 43)
			SetBlipScale(currentBlip, 1.0)
			SetBlipAsShortRange(currentBlip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Sanitaartöötaja - '..v.name)
			EndTextCommandSetBlipName(currentBlip)

			myBlips[#myBlips+1] = currentBlip
		end
	end
end

handleJob()

AddEventHandler("garbagejob:pickupTrash", function(pEntity, pContext, pParams)
	local currentTargetCoords = GetEntityCoords(pEntity)

	local trashId = string.format("%.2f", currentTargetCoords.x) .. "_"
        .. string.format("%.2f", currentTargetCoords.y) .. "_"
        .. string.format("%.2f", currentTargetCoords.z)

	events:Trigger('garbagejob:sv_pickupTrash', function(success)
		if success then
			print "PICKUP"
		end
	end, trashId)
end)