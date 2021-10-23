enabled = false
cachedContacts = {}

local phones = exports['inventory']:getPhones()
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
    elseif action == 'updateContactsCache' then
        cachedContacts = content.contacts
    elseif (action == 'addContact') then
        local addedContactId = RPC.execute("addContact", content)

        cb(addedContactId)
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
    elseif (action == "notiButton") then
        TriggerEvent("jp-phone:notiAction", content.id, content.value == 'yes' and true or false)
        cb(true)
    elseif (action == "sendPing") then
        local success = RPC.execute("sendPing", content.target)
        cb(success)
    end
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

AddEventHandler("login:firstSpawn", function()
    cachedContacts = {}
    SendNUIMessage({
        resetData = true
    })
end)