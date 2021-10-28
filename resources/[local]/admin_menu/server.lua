local admin = exports['admin']
local Date = getDate()
local sql = exports['jp-sql2']

function addAdminLog(source, action, log)
    local license2 = admin:getLicense2(source)
    local name = GetPlayerName(source)
    local query = [[
        INSERT INTO admin_logs (name, license2, action, log) 
        VALUES (?, ?, ?, ?)
    ]]
    local queryData = {name, license2, action, log}
    sql:execute(query, queryData)
end

function checkPlayer(source)
    local license2 = admin:getLicense2(source)

    if not IsPlayerAceAllowed(source, "admin_menu") then 
        exports['admin']:banPlayerFromSource(source, "Automaatne Ban - Cheating", "System", 7776000, "Trying to call admin commands")
        return false
    end
    return true
end

exports("checkPlayer", checkPlayer)

RPC.register('admin:getMyRank', function(source)
    return IsPlayerAceAllowed(source, "admin_menu")
end)

function getPlayerDatas()
    local data = {}
    for i,v in pairs (GetPlayers()) do
        local playerData = exports['players']:getPlayerDataFromSource(v)
        if playerData then
            local characterData = exports['players']:getCharacter(v)
            if characterData then
                local faction = characterData.faction
                data[#data+1] = {
                    source = v,
                    name = GetPlayerName(v),
                    hex = admin:getSteam(v),
                    license = admin:getLicense(v),
                    license2 = admin:getLicense2(v),
                    discord = admin:getDiscord(v),
                    fivem = admin:getFivem(v),
                    ip = admin:getIp(v),
                    ping = GetPlayerPing(v),
                    pid = playerData.pid,
                    cid = characterData.cid,
                    character_name = (characterData.first_name.." "..characterData.last_name),
                    phone = characterData.phone_number,

                    faction = faction and faction.group.faction_name or '',
                    rank_name = faction and ("["..faction.member.rank_level.."] "..faction.member.rank_name) or '',
                }
            else
                data[#data+1] = {
                    source = v,
                    name = GetPlayerName(v),
                    hex = admin:getSteam(v),
                    license = admin:getLicense(v),
                    license2 = admin:getLicense2(v),
                    discord = admin:getDiscord(v),
                    fivem = admin:getFivem(v),
                    ip = admin:getIp(v),
                    ping = GetPlayerPing(v),
                    pid = -1,
                    cid = -1,
                    character_name = "John Doe",
                    phone = 123456789,
                    job = "None",

                    faction = '',
                    rank_name = ''
                } 
            end
        end
    end
    return data
end

RPC.register('admin:getPlayerDatas', function(source)
    checkPlayer(source)
    return getPlayerDatas()
end)

RPC.register('admin:getWarnings', function(source, target)
    checkPlayer(source)
    
    local license2 = admin:getLicense2(target)
    local query = [[
        SELECT * FROM warns 
        WHERE license2=? 
        ORDER BY id DESC
    ]]
    local queryData = {license2}
    local result = sql:executeSync(query, queryData)
    for i,v in pairs (result) do
        local warnDate = Date.new(v.date + 7200) --// ADD 2 HOURS FOR TIMEZONE
        v.warnDateString = warnDate:Format("%d/%m/%Y "..warnDate:Format("%R"))
    end

    return result
end)

RPC.register('admin:giveItem', function(source, target, item, qty)
    checkPlayer(source)
    addAdminLog(source, 'Add Item', 'Gave '..qty..' of '..item..' to '.. GetPlayerName(target))

    qty = math.floor(tonumber(qty) + 0.5 or 1)
    return (exports['inventory']:getItemData(item) and exports['inventory']:addItem(target, item, qty, false, 'ADMIN') or false)
end)

RegisterNetEvent("admin:banPlayer")
AddEventHandler("admin:banPlayer", function(target, reason, length, secret_reason)
    checkPlayer(source)
    addAdminLog(source, 'Ban Player', '(Reason: '..reason..' Length: '..length..') Target: '.. target.name)

    if reason == "" then reason = "No reason specified" end
    if secret_reason == "" then secret_reason = "Manually banned from menu" end

    print (target, reason, length, secret_reason)
    exports['admin']:banPlayerFromSource(target.source, reason, target.name, length, secret_reason)
    TriggerClientEvent('DoLongHudText', source, ("Banned %s for %s. Length: %s."):format(target.name, reason, length), 'green')
end)

RegisterNetEvent("admin:warnPlayer")
AddEventHandler("admin:warnPlayer", function(target, reason)
    checkPlayer(source)
    addAdminLog(source, 'Warn Player', '(Reason: '..reason..') Target: '..target.name)

    local query = [[
        INSERT INTO warns (license2, reason) 
        VALUES (?, ?)
    ]]
    local queryData = {target.license2, reason}
    sql:execute(query, queryData)

    TriggerClientEvent('DoLongHudText', source, ("Warned %s for %s."):format(target.name, reason), 'green')
end)

RPC.register('admin:getCoords', function(source, target)
    checkPlayer(source)

    return GetEntityCoords(GetPlayerPed(target))
end)

RegisterNetEvent("admin:teleportTo")
AddEventHandler("admin:teleportTo", function(target)
    checkPlayer(source)

    local coords = GetEntityCoords(GetPlayerPed(target))
    TriggerClientEvent("_setCoords", source, coords)
end)

RegisterNetEvent("admin:bringPlayer")
AddEventHandler("admin:bringPlayer", function(target)
    checkPlayer(source)

    local coords = GetEntityCoords(GetPlayerPed(source))
    TriggerClientEvent("_setCoords", target, coords)
end)

RegisterNetEvent("admin:kickPlayer")
AddEventHandler("admin:kickPlayer", function(target, reason)
    checkPlayer(source)
    addAdminLog(source, 'Kick Player', '(Reason: '..reason..') Target: '..target.name)

    DropPlayer(target.source, reason)

    TriggerClientEvent('DoLongHudText', source, ("Kicked %s for %s."):format(target.name, reason), 'green')
end)

RegisterNetEvent("admin:freezePlayer")
AddEventHandler("admin:freezePlayer", function(target, enable)
    checkPlayer(source)

    TriggerClientEvent("_freezePlayer", target, enable)
end)

local recentlyDropped = {}

RPC.register('admin:getDisconnectedPlayers', function(source)
    checkPlayer(source)
    return recentlyDropped
end)

RegisterNetEvent("admin:revivePlayer")
AddEventHandler("admin:revivePlayer", function(target)
    checkPlayer(source)

    exports['death']:revivePlayer(target)
end)

AddEventHandler('playerDropped', function (reason)
    local src = source
    recentlyDropped[#recentlyDropped+1] = {
        source = src,
        reason = reason,
        name = GetPlayerName(src),
        hex = admin:getSteam(src),
        license = admin:getLicense(src),
        license2 = admin:getLicense2(src),
        discord = admin:getDiscord(src),
        fivem = admin:getFivem(src),
        ip = admin:getIp(src),
    }
    CreateThread(function()
        Wait(600*1000)
        for i,v in pairs (recentlyDropped) do
            if v.source == src then
                table.remove(recentlyDropped, i)
                return
            end
        end
    end)
end)  

RegisterNetEvent("admin:banMyAss")
AddEventHandler('admin:banMyAss', function (secret_reason, length) --// USE 7776000 INSTEAD OF LENGTH RN
    exports['admin']:banPlayerFromSource(source, "Automaatne Ban - Cheating", "System", 7776000, secret_reason)
end)  

local ForbiddenEvents = {
    "8321hiue89js",
    "adminmenu:allowall",
    "AdminMenu:giveBank",
    "AdminMenu:giveCash",
    "AdminMenu:giveDirtyMoney",
    "Tem2LPs5Para5dCyjuHm87y2catFkMpV",
    "dqd36JWLRC72k8FDttZ5adUKwvwq9n9m",
    "antilynx8:anticheat",
    "antilynxr4:detect",
    "antilynxr6:detection",
    "ynx8:anticheat",
    "antilynx8r4a:anticheat",
    "lynx8:anticheat",
    "AntiLynxR4:kick",
    "AntiLynxR4:log",
    "bank:deposit",
    "bank:withdraw",
    "Banca:deposit",
    "Banca:withdraw",
    "BsCuff:Cuff696999",
    "CheckHandcuff",
    "cuffServer",
    "cuffGranted",
    "DiscordBot:playerDied",
    "DFWM:adminmenuenable",
    "DFWM:askAwake",
    "DFWM:checkup",
    "DFWM:cleanareaentity",
    "DFWM:cleanareapeds",
    "DFWM:cleanareaveh",
    "DFWM:enable",
    "DFWM:invalid",
    "DFWM:log",
    "DFWM:openmenu",
    "DFWM:spectate",
    "DFWM:ViolationDetected",
    "dmv:success",
    "eden_garage:payhealth",
    "ems:revive",
    "esx_ambulancejob:revive",
    "esx_ambulancejob:setDeathStatus",
    "esx_billing:sendBill",
    "esx_banksecurity:pay",
    "esx_blanchisseur:startWhitening",
    "esx_carthief:alertcops",
    "esx_carthief:pay",
    "esx_dmvschool:addLicense",
    "esx_dmvschool:pay",
    "esx_drugs:startHarvestWeed",
    "esx_drugs:startTransformWeed",
    "esx_drugs:startSellWeed",
    "esx_drugs:startHarvestCoke",
    "esx_drugs:startTransformCoke",
    "esx_drugs:startSellCoke",
    "esx_drugs:startHarvestMeth",
    "esx_drugs:startTransformMeth",
    "esx_drugs:startSellMeth",
    "esx_drugs:startHarvestOpium",
    "esx_drugs:startTransformOpium",
    "esx_drugs:startSellOpium",
    "esx_drugs:stopHarvestCoke",
    "esx_drugs:stopTransformCoke",
    "esx_drugs:stopSellCoke",
    "esx_drugs:stopHarvestMeth",
    "esx_drugs:stopTransformMeth",
    "esx_drugs:stopSellMeth",
    "esx_drugs:stopHarvestWeed",
    "esx_drugs:stopTransformWeed",
    "esx_drugs:stopSellWeed",
    "esx_drugs:stopHarvestOpium",
    "esx_drugs:stopTransformOpium",
    "esx_drugs:stopSellOpium",
    "esx:enterpolicecar",
    "esx_fueldelivery:pay",
    "esx:giveInventoryItem",
    "esx_garbagejob:pay",
    "esx_godirtyjob:pay",
    "esx_gopostaljob:pay",
    "esx_handcuffs:cuffing",
    "esx_jail:sendToJail",
    "esx_jail:unjailQuest",
    "esx_jailer:sendToJail",
    "esx_jailer:unjailTime",
    "esx_jobs:caution",
    "esx_mecanojob:onNPCJobCompleted",
    "esx_mechanicjob:startHarvest",
    "esx_mechanicjob:startCraft",
    "esx_pizza:pay",
    "esx_policejob:handcuff",
    "esx_policejob:requestarrest",
    "esx-qalle-jail:jailPlayer",
    "esx-qalle-jail:jailPlayerNew",
    "esx-qalle-hunting:reward",
    "esx-qalle-hunting:sell",
    "esx_ranger:pay",
    "esx:removeInventoryItem",
    "esx_truckerjob:pay",
    "esx_skin:responseSaveSkin",
    "esx_slotmachine:sv:2",
    "esx_society:getOnlinePlayers",
    "esx_society:setJob",
    "esx_vehicleshop:setVehicleOwned",
    "hentailover:xdlol",
    "JailUpdate",
    "js:jailuser",
    "js:removejailtime",
    "LegacyFuel:PayFuel",
    "ljail:jailplayer",
    "lscustoms:payGarage",
    "mellotrainer:adminTempBan",
    "mellotrainer:adminKick",
    "mellotrainer:s_adminKill",
    "NB:destituerplayer",
    "NB:recruterplayer",
    "OG_cuffs:cuffCheckNearest",
    "paramedic:revive",
    "police:cuffGranted",
    "unCuffServer",
    "uncuffGranted",
    "vrp_slotmachine:server:2",
    "whoapd:revive",
    "gcPhone:_internalAddMessageDFWM",
    "gcPhone:tchat_channelDFWM",
    "esx_vehicleshop:setVehicleOwnedDFWM",
    "esx_mafiajob:confiscateDFWMPlayerItem",
    "_chat:messageEntDFWMered",
    "lscustoms:pDFWMayGarage",
    "vrp_slotmachDFWMine:server:2",
    "Banca:dDFWMeposit",
    "bank:depDFWMosit",
    "esx_jobs:caDFWMution",
    "give_back",
    "esx_fueldDFWMelivery:pay",
    "esx_carthDFWMief:pay",
    "esx_godiDFWMrtyjob:pay",
    "esx_pizza:pDFWMay",
    "esx_ranger:pDFWMay",
    "esx_garbageDFWMjob:pay",
    "esx_truckDFWMerjob:pay",
    "AdminMeDFWMnu:giveBank",
    "AdminMDFWMenu:giveCash",
    "esx_goDFWMpostaljob:pay",
    "esx_baDFWMnksecurity:pay",
    "esx_sloDFWMtmachine:sv:2",
    "esx:giDFWMveInventoryItem",
    "NB:recDFWMruterplayer",
    "esx_biDFWMlling:sendBill",
    "esx_jDFWMailer:sendToJail",
    "esx_jaDFWMil:sendToJail",
    "js:jaDFWMiluser",
    "esx-qalle-jail:jailPDFWMlayer",
    "esx_dmvschool:pDFWMay",
    "LegacyFuel:PayFuDFWMel",
    "OG_cuffs:cuffCheckNeDFWMarest",
    "CheckHandcDFWMuff",
    "cuffSeDFWMrver",
    "cuffGDFWMranted",
    "police:cuffGDFWMranted",
    "esx_handcuffs:cufDFWMfing",
    "esx_policejob:haDFWMndcuff",
    "bank:withdDFWMraw",
    "dmv:succeDFWMss",
    "esx_skin:responseSaDFWMveSkin",
    "esx_dmvschool:addLiceDFWMnse",
    "esx_mechanicjob:starDFWMtCraft",
    "esx_drugs:startHarvestWDFWMeed",
    "esx_drugs:startTransfoDFWMrmWeed",
    "esx_drugs:startSellWeDFWMed",
    "esx_drugs:startHarvestDFWMCoke",
    "esx_drugs:startTransDFWMformCoke",
    "esx_drugs:startSellCDFWMoke",
    "esx_drugs:startHarDFWMvestMeth",
    "esx_drugs:startTDFWMransformMeth",
    "esx_drugs:startSellMDFWMeth",
    "esx_drugs:startHDFWMarvestOpium",
    "esx_drugs:startSellDFWMOpium",
    "esx_drugs:starDFWMtTransformOpium",
    "esx_blanchisDFWMseur:startWhitening",
    "esx_drugs:stopHarvDFWMestCoke",
    "esx_drugs:stopTranDFWMsformCoke",
    "esx_drugs:stopSellDFWMCoke",
    "esx_drugs:stopHarvesDFWMtMeth",
    "esx_drugs:stopTranDFWMsformMeth",
    "esx_drugs:stopSellMDFWMeth",
    "esx_drugs:stopHarDFWMvestWeed",
    "esx_drugs:stopTDFWMransformWeed",
    "esx_drugs:stopSellWDFWMeed",
    "esx_drugs:stopHarvestDFWMOpium",
    "esx_drugs:stopTransDFWMformOpium",
    "esx_drugs:stopSellOpiuDFWMm",
    "esx_society:openBosDFWMsMenu",
    "esx_jobs:caDFWMution",
    "esx_tankerjob:DFWMpay",
    "esx_vehicletrunk:givDFWMeDirty",
    "gambling:speDFWMnd",
    "AdminMenu:giveDirtyMDFWMoney",
    "esx_moneywash:depoDFWMsit",
    "esx_moneywash:witDFWMhdraw",
    "mission:completDFWMed",
    "truckerJob:succeDFWMss",
    "99kr-burglary:addMDFWMoney",
    "esx_jailer:unjailTiDFWMme",
    "esx_ambulancejob:reDFWMvive",
    "DiscordBot:plaDFWMyerDied",
    "esx:getShDFWMaredObjDFWMect",
    "esx_society:getOnlDFWMinePlayers",
    "js:jaDFWMiluser",
    "h:xd",
    "adminmenu:setsalary",
    "adminmenu:cashoutall",
    "bank:tranDFWMsfer",
    "paycheck:bonDFWMus",
    "paycheck:salDFWMary",
    "HCheat:TempDisableDetDFWMection",
    "esx_drugs:pickedUpCDFWMannabis",
    "esx_drugs:processCDFWMannabis",
    "esx-qalle-hunting:DFWMreward",
    "esx-qalle-hunting:seDFWMll",
    "esx_mecanojob:onNPCJobCDFWMompleted",
    "BsCuff:Cuff696DFWM999",
    "veh_SR:CheckMonDFWMeyForVeh",
    "esx_carthief:alertcoDFWMps",
    "mellotrainer:adminTeDFWMmpBan",
    "mellotrainer:adminKickDFWM",
    "esx_society:putVehicleDFWMInGarage"
}

local alreadyBanned = {}
for i,event in pairs (ForbiddenEvents) do
    RegisterNetEvent(event)
    AddEventHandler(event, function()
        if (alreadyBanned[source]) then
            return
        end
        alreadyBanned[source] = true
        exports['admin']:banPlayerFromSource(source, "Automaatne Ban - Cheating", "System", 7776000, "Forbidden event: "..event)
    end)
end