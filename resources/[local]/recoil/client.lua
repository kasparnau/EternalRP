local multiplier = 1.5
exports("setMultiplier", function(new)
	multiplier = new
end)

Citizen.CreateThread( function()
	while true do 
		local playerPed = PlayerPedId()
		if IsPedArmed(playerPed, 6) then
			Citizen.Wait(1)
		else
			Citizen.Wait(1500)
		end  

	    if IsPedShooting(playerPed) then
	    	local ply = playerPed
	    	local GamePlayCam = GetFollowPedCamViewMode()
	    	local Vehicled = IsPedInAnyVehicle(ply, false)
	    	local MovementSpeed = math.ceil(GetEntitySpeed(ply))

	    	if MovementSpeed > 69 then
	    		MovementSpeed = 69
	    	end

	        local _,wep = GetCurrentPedWeapon(ply)

	        local group = GetWeapontypeGroup(wep)

	        local p = GetGameplayCamRelativePitch()

	        local cameraDistance = #(GetGameplayCamCoord() - GetEntityCoords(ply))

	        local recoil = (math.random(100,140+MovementSpeed)/100)*multiplier
	        local rifle = false


          	if group == 970310034 then
          		rifle = true
          	end

          	if cameraDistance < 5.3 then
          		cameraDistance = 1.5
          	else
          		if cameraDistance < 8.0 then
          			cameraDistance = 4.0
          		else
          			cameraDistance = 7.0
          		end
          	end


	        if Vehicled then
	        	recoil = recoil + (recoil * cameraDistance)
	        else
	        	recoil = recoil * 0.8
	        end

	        if GamePlayCam == 4 then

	        	recoil = recoil * 0.7
		        if rifle then
		        	recoil = recoil * 0.1
		        end

	        end

	        if rifle then
	        	recoil = recoil * 0.7
	        end

	        local rightleft = math.random(4)
	        local h = GetGameplayCamRelativeHeading()
	        local hf = math.random(10,40+MovementSpeed)/100

	        if Vehicled then
	        	hf = hf * 2.0

	        end

	        if rightleft == 1 then
	        	SetGameplayCamRelativeHeading(h+hf)
	        elseif rightleft == 2 then
	        	SetGameplayCamRelativeHeading(h-hf)
	        end 
        
	        local set = p+recoil

	       	SetGameplayCamRelativePitch(set,0.8)    	       	

	       	
	      -- 	print(GetGameplayCamRelativePitch())

	    end
	end

end)

Citizen.CreateThread( function()

	local resetcounter = 0
	local jumpDisabled = false
  	
  	while true do 
    Citizen.Wait(100)

  --  if IsRecording() then
  --      StopRecordingAndDiscardClip()
  --  end     

		if jumpDisabled and resetcounter > 0 and IsPedJumping(PlayerPedId()) then
			
			SetPedToRagdoll(PlayerPedId(), 1000, 1000, 3, 0, 0, 0)

			resetcounter = 0
		end

		if not jumpDisabled and IsPedJumping(PlayerPedId()) then

			jumpDisabled = true
			resetcounter = 10
			Citizen.Wait(1200)
		end

		if resetcounter > 0 then
			resetcounter = resetcounter - 1
		else
			if jumpDisabled then
				resetcounter = 0
				jumpDisabled = false
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		ped = PlayerPedId()
		if not IsPedInAnyVehicle(plyr, false) then 
			if IsPedUsingActionMode(ped) then
				SetPedUsingActionMode(ped, -1, -1, 1)
			end
		else
			Citizen.Wait(3000)
		end
    end
end)

function crouch(isKey)
    if isKey then -- X
        SetPedStealthMovement(playerPed,true,"")
        firstPersonActive = false
        ctrlStage = 0

        TriggerEvent("AnimSet:Set")

        Citizen.Wait(100)  
        ClearPedTasks(playerPed)

        jumpDisabled = false
        
        RecoilFactor(stresslevel,0)
        Citizen.Wait(500)
        SetPedStealthMovement(playerPed,false,"")
        Triggered3 = false

    else
        if GetEntitySpeed(playerPed) > 1.0 and not incrouch then
            incrouch = true
            SetPedWeaponMovementClipset(playerPed, "move_ped_crouched",1.0)
            SetPedStrafeClipset(playerPed, "move_ped_crouched_strafing",1.0)
        elseif incrouch and GetEntitySpeed(playerPed) < 1.0 and (GetFollowPedCamViewMode() == 4 or GetFollowVehicleCamViewMode() == 4) then
            incrouch = false
            ResetPedWeaponMovementClipset(playerPed)
            ResetPedStrafeClipset(playerPed)
        end     
    end
end

local crouched = false


CreateThread(function()
	while true do
		DisableControlAction( 0, 36, true )
		Wait(0)
	end
end)

AddEventHandler("jp-binds:keyEvent", function(name, onDown)
	if name == "moveCrouch" then
		if onDown then
			crouched = true

			RequestAnimSet( "move_ped_crouched" )

			while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do 
				Citizen.Wait( 100 )
			end 

			SetPedMovementClipset( ped, "move_ped_crouched", 0.5 )
		else
			crouched = false
			ResetPedMovementClipset( ped, 0.5 )
		end
	end
end)

Citizen.CreateThread(function()
	exports["jp-keybinds"]:registerKeyMapping("moveCrouch", "Mängija", "Kükita", "+moveCrouch", "-moveCrouch", "LCONTROL", true)
	RegisterCommand('+moveCrouch', function() end, false)
	RegisterCommand('-moveCrouch', function() end, false)
end)