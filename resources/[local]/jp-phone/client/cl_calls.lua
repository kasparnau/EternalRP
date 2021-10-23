local callNoti
local callerId
inCall = false

local isDead = false
AddEventHandler("players:ClientVarChanged", function(name, old, new)
    if name == 'isDead' then
        isDead = new
    end
end)

AddEventHandler("jp-phone:notiAction", function(id, accept)
    if id == callNoti then
        if not inCall then
            SendNUIMessage({
                playRingtone = false
            })
            local channel = RPC.execute("answerCall", accept)
            if not accept then
                removeNoti(callNoti)
                callNoti = nil
            elseif accept then
                exports['pma-voice']:setCallChannel(channel)
                inCall = true
                playPhoneCallAnim()
                updateNoti(callNoti, callerId, "Kõne", {no = true}, 2)
                startCallTimer()
            end
        else
            RPC.execute("stopCall")
        end
    end
end)

function startCallTimer()
    CreateThread(function()
        local minutes = 0
        local seconds = 0
        while true do
            if not inCall then return end
            
            seconds = seconds + 1
            if seconds >= 60 then
                minutes = minutes + 1
                seconds = 0
            end
            local minStr, secStr
            secStr = seconds < 10 and ("0"..seconds) or seconds
            minStr = minutes < 10 and ("0"..minutes) or minutes
            updateNoti(callNoti, ("Kõne (%s:%s)"):format(minStr, secStr), callerId, {no = true}, 2)

            Wait(1000)
        end
    end)
end

exports("isInCall", function()
    return inCall
end)

RegisterNetEvent("jp-phone:callRequest")
AddEventHandler("jp-phone:callRequest", function(from_number)
    local contacts = cachedContacts
    callerId = from_number
    for i,v in pairs (contacts) do
        if (tonumber(v.number) == tonumber(from_number)) then
            callerId = (("%s (%s)"):format(v.name, from_number))
        end
    end
    callNoti = addNoti(callerId, "Sissetulev Kõne", {yes = true, no = true}, 2)
    SendNUIMessage({
        playRingtone = true
    })
end)

RegisterNetEvent("jp-phone:callRequest:answer", function(answered, channel)
    if answered then
        exports['pma-voice']:setCallChannel(channel)
        inCall = true
        playPhoneCallAnim()
        updateNoti(callNoti, callerId, "Kõne", { no = true }, 2)
        startCallTimer()
    else
        removeNoti(callNoti)
        callNoti = nil
    end
end)

RegisterNUICallback("nuiAction", function(data, cb)
    local content = data.data
    local action = data.action

    if (action == "callPlayer") then
        callerId = ''
        if content.name then
            callerId = (("%s (%s)"):format(content.name, content.number))
        else
            callerId = content.number
        end
        callNoti = addNoti(callerId, "Helistab...", {no = true}, 2)

        RPC.execute("callPlayer", content.number, content.name)

        cb(success)
    end
end)

RegisterNetEvent("jp-phone:calls:stop")
AddEventHandler("jp-phone:calls:stop", function()
    inCall = false
    removeNoti(callNoti)

    if not enabled then
        PhonePlayOut()
    else
        PhonePlayOut()
        PhonePlayText()
    end

    --// INCASE STILL CALLING
    SendNUIMessage({
        playRingtone = false
    })
end)

local phoneProp = 0
local phoneModel = 'prop_npc_phone_02'

function attachPhoneProp()
	deletePhone()
	RequestModel(phoneModel)
	while not HasModelLoaded(phoneModel) do
		Citizen.Wait(1)
	end
	phoneProp = CreateObject(phoneModel, 1.0, 1.0, 1.0, 1, 1, 0)
	local bone = GetPedBoneIndex(PlayerPedId(), 28422)
	AttachEntityToEntity(phoneProp, PlayerPedId(), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
end

function deletePhoneProp()
	if phoneProp ~= 0 then
		Citizen.InvokeNative(0xAE3CBE5BF394C9C9 , Citizen.PointerValueIntInitialized(phoneProp))
		phoneProp = 0
	end
end

function LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
  
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
        end
    end
end

function playPhoneCallAnim()
    local dict, anim = "cellphone@", "cellphone_text_to_call"

    Citizen.CreateThread(function() 
        LoadAnimDict(dict)

        local playerPed = PlayerPedId()

        while (inCall or callNoti) and not isDead do
            if not IsEntityPlayingAnim(playerPed, dict, anim, 3) then
                TaskPlayAnim(playerPed, dict, anim, 3.0, -1, -1, 50, 0, false, false, false)
            end

            Citizen.Wait(5000)
        end
    end)
end