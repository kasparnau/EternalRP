local enabled = false

--//CALL STUFF
local callNoti
local callerId
local inCall = false

local phones = {'phone', 'apple-iphone', 'nokia-phone', 'pixel-2-phone', 'samsung-s8'}
function hasPhone()
    for i,v in pairs (phones) do
        if exports['inventory']:hasEnoughOfItem(v, 1) then
            return true
        end
    end
    return false
end

function showUi()
    local character = exports['players']:GetClientVar('character')
    if not character then return end

    enabled = true
    SetNuiFocus(true, true)

    SendNUIMessage({
        show = true,
        character = character,
    })

    if not inCall then
        PhonePlayText()
    end
end

function hideUi()
    enabled = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        show = false
    })

    if not inCall then
        PhonePlayOut()
    end
end

exports('toggle', function()
    if enabled then 
        hideUi() 
    else
        if not exports['players']:GetClientVar('character') then return end 
        showUi() 
    end
end)

function enableCircleNoti(app)
    SendNUIMessage({
        addNotiCircle = app
    })
end

RegisterNetEvent("jp-phone:enableCircleNoti")
AddEventHandler("jp-phone:enableCircleNoti", function(app)
    enableCircleNoti(app)
end)

RegisterNetEvent("jp-phone:doPhoneNoti")
AddEventHandler("jp-phone:doPhoneNoti", function(title, desc, time, icon)
    local noti = addNoti(title, desc, nil, icon)
    if time then
        CreateThread(function()
            Wait(time)
            removeNoti(noti)
        end)
    end
end)

--[[ 
    ICONS:
        1: RED ALERT
        2: CALL
        3: TWITTER
]]

local newNotiId = 0

function addNoti(title, desc, buttons, icon)
    newNotiId = newNotiId + 1
    SendNUIMessage({
        addNoti = {id = newNotiId, title = title, desc = desc, buttons = buttons, icon = icon}
    })
    return newNotiId
end

function updateNoti(id, title, desc, buttons, icon)
    SendNUIMessage({
        updateNoti = {id = id, title = title, desc = desc, buttons = buttons, icon = icon}
    })
end

function removeNoti(id)
    SendNUIMessage({
        removeNoti = id
    })
end

RegisterNUICallback('nuiAction', function(data, cb)
    local content = data.data
    local action = data.action

    print ("NuiAction | "..json.encode(data))
    if (action == 'closeNui') then
        hideUi()
    elseif (action == 'fetchContactsPage') then
        local page = {}
        page.contacts = RPC.execute("getContacts")

        cb(page)
    elseif (action == 'addContact') then
        local success = RPC.execute("addContact", content)

        cb(success)
    elseif (action == 'removeContact') then
        local success = RPC.execute("removeContact", content.id)

        cb(success)
    elseif (action == 'fetchDetailsPage') then
        local character = exports['players']:GetClientVar("character")
        local data = {citizen_id = character.cid, phone_number = character.phone_number, 
        bank = character.bank, licenses = character.licenses, faction = character.faction, job = exports['npcjobs']:getJobEstonian(character.job)}

        cb(data)
    elseif (action == "fetchTwitterPage") then
        local page = {}
        page.tweets = RPC.execute("fetchTweets")

        cb(page)
    elseif (action == "addTweet") then
        local success = RPC.execute("addTweet", content.text)

        cb(success)
    elseif (action == "callPlayer") then
        callerId = ''
        if content.name then
            callerId = (("%s (%s)"):format(content.name, content.number))
        else
            callerId = content.number
        end
        callNoti = addNoti(callerId, "Helistab...", {no = true}, 2)

        RPC.execute("callPlayer", content.number, content.name)

        cb(success)
    elseif (action == "notiButton") then
        if content.id == callNoti then --// HANDLE CALLS
            if not inCall then
                SendNUIMessage({
                    playRingtone = false
                })
                local channel = RPC.execute("answerCall", content.value)
                if content.value == 'no' then
                    removeNoti(callNoti)
                    callNoti = nil
                elseif content.value == 'yes' then
                    exports['pma-voice']:setCallChannel(channel)
                    inCall = true
                    PhonePlayCall()
                    updateNoti(callNoti, callerId, "Kõne", {no = true}, 2)
                    startCallTimer()
                end
            else
                RPC.execute("stopCall")
            end
            cb(true)
        else
            TriggerEvent("jp-phone:notiAction", content.id, content.value == 'yes' and true or false)
            cb(true)
        end
    elseif (action == "sendPing") then
        local success = RPC.execute("sendPing", content.target)
        cb(success)
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
    local contacts = RPC.execute("getContacts")
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
        PhonePlayCall()
        updateNoti(callNoti, callerId, "Kõne", { no = true }, 2)
        startCallTimer()
    else
        removeNoti(callNoti)
        callNoti = nil
    end
end)

RegisterNetEvent("jp-phone:calls:stop")
AddEventHandler("jp-phone:calls:stop", function()
    inCall = false
    removeNoti(callNoti)

    if not enabled then
        PhonePlayOut()
    else
        PhonePlayText()
    end

    --// INCASE STILL CALLING
    SendNUIMessage({
        playRingtone = false
    })
end)

AddEventHandler("jp-weather:timeUpdated", function(hours, minutes)
    local clock = (hours..":"..(minutes >= 10 and minutes or ("0"..minutes)))
    SendNUIMessage({
        clock = clock
    })
end)

AddEventHandler("inventory:changed", function()
    SendNUIMessage({
        hasPhone = hasPhone()
    })
    if enabled and not hasPhone() then
        hideUi()
        PhonePlayOut()

        if callNoti then
            RPC.execute("answerCall", 'no')
            removeNoti(callNoti)
            callNoti = nil
        end
    end
end)

AddEventHandler("login:firstSpawn", function()
    Wait(1000) --// wait for inv to update
    SendNUIMessage({
        hasPhone = hasPhone()
    })
end)