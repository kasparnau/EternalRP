local cuffed = exports['players']:GetClientVar('isCuffed') or Entity(PlayerPedId()).state.isCuffed
local dict = "mp_arresting"
local anim = "idle"
local flags = 49
local ped = PlayerPedId()
AddEventHandler("jp:onPedChange", function(nped)
	ped = nped
end)
local changed = false
local forceUpdate = false
local prevMaleVariation = 0
local prevFemaleVariation = 0
local femaleHash = GetHashKey("mp_f_freemode_01")
local maleHash = GetHashKey("mp_m_freemode_01")

local isDead = exports['players']:GetClientVar('isDead')
AddEventHandler("players:ClientVarChanged", function(name, old, new)
    if name == "isCuffed" then
        cuffed = new
    elseif name == 'isDead' then
        isDead = new
    end
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function cuff(playerHeading, playerCoords, playerLocation)
    ped = GetPlayerPed(-1)

    SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
    --[[
	local x, y, z   = table.unpack(playerCoords + playerLocation * 1.0)
	SetEntityCoords(ped, x, y, z)
    SetEntityHeading(ped, playerHeading)
    ]]
    Citizen.Wait(250)
	loadAnimDict('mp_arrest_paired')
	TaskPlayAnim(ped, 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)

    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end

    if GetEntityModel(ped) == femaleHash then
        prevFemaleVariation = GetPedDrawableVariation(ped, 7)
        SetPedComponentVariation(ped, 7, 25, 0, 0)
    elseif GetEntityModel(ped) == maleHash then
        prevMaleVariation = GetPedDrawableVariation(ped, 7)
        SetPedComponentVariation(ped, 7, 41, 0, 0)
    end

    SetEnableHandcuffs(ped, true)

    TaskPlayAnim(ped, dict, anim, 8.0, -8, -1, flags, 0, 0, 0, 0)

    cuffed = true
    Entity(ped).state:set('isCuffed', true, true)
    exports['players']:SetClientVar('isCuffed', cuffed)
    changed = true
end

function uncuff(playerHeading, playerCoords, playerLocation)
    ped = GetPlayerPed(-1)

    local x, y, z   = table.unpack(playerCoords + playerLocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerHeading)
	Citizen.Wait(250)
	loadAnimDict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)

    ClearPedTasks(ped)
    SetEnableHandcuffs(ped, false)
    UncuffPed(ped)

    if GetEntityModel(ped) == femaleHash then -- mp female
        SetPedComponentVariation(ped, 7, prevFemaleVariation, 0, 0)
    elseif GetEntityModel(ped) == maleHash then -- mp male
        SetPedComponentVariation(ped, 7, prevMaleVariation, 0, 0)
    end

    cuffed = false
    Entity(ped).state:set('isCuffed', false, true)
    exports['players']:SetClientVar('isCuffed', cuffed)
    changed = true
end

RegisterNetEvent('handcuffs:cuffToggle')
AddEventHandler('handcuffs:cuffToggle', function(playerHeading, playerCoords, playerLocation)
    if cuffed then uncuff(playerHeading, playerCoords, playerLocation) else cuff(playerHeading, playerCoords, playerLocation) end
end)

RegisterNetEvent('handcuffs:cuff')
AddEventHandler('handcuffs:cuff', function(playerHeading, playerCoords, playerLocation, hard)
    if not cuffed then
        local success = exports['skill-checks']:start(0.4, math.random(150, 270))
        if not success then
            cuff(playerHeading, playerCoords, playerLocation, hard) 
        else
            TriggerEvent("DoLongHudText", "Libisesid raudadest!", "green")
        end
    end
end)

RegisterNetEvent('handcuffs:uncuff')
AddEventHandler('handcuffs:uncuff', function(playerHeading, playerCoords, playerLocation)
    if cuffed then uncuff(playerHeading, playerCoords, playerLocation) end
end)

RegisterNetEvent('handcuffs:makeHard')
AddEventHandler('handcuffs:makeHard', function(hard)
    if cuffed then 
        flags = hard and 9 or 49
        ped = PlayerPedId()

        ClearPedTasksImmediately(PlayerPedId())
        TaskPlayAnim(ped, dict, anim, 8.0, -8, -1, flags, 0, 0, 0, 0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not changed then
            ped = PlayerPedId()
            if not isDead and cuffed and not IsEntityPlayingAnim(PlayerPedId(), dict, anim, 3) then
                Citizen.Wait(0)
                TaskPlayAnim(ped, dict, anim, 8.0, -8, -1, flags, 0, 0, 0, 0)
            end
        else
            changed = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        ped = PlayerPedId()
        if cuffed then
            DisableControlAction(0, 69, true) -- INPUT_VEH_ATTACK
            DisableControlAction(0, 92, true) -- INPUT_VEH_PASSENGER_ATTACK
            DisableControlAction(0, 114, true) -- INPUT_VEH_FLY_ATTACK
            DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
            DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
            DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE
            DisableControlAction(0, 257, true) -- INPUT_ATTACK2
            DisableControlAction(0, 263, true) -- INPUT_MELEE_ATTACK1
            DisableControlAction(0, 264, true) -- INPUT_MELEE_ATTACK2
            DisableControlAction(0, 24, true) -- INPUT_ATTACK
            DisableControlAction(0, 25, true) -- INPUT_AIM
			DisableControlAction(0, 21, true) -- SHIFT
			DisableControlAction(0, 22, true) -- SPACE
			DisableControlAction(0, 288, true) -- F1
			DisableControlAction(0, 289, true) -- F2
			DisableControlAction(0, 170, true) -- F3
			DisableControlAction(0, 167, true) -- F6
			DisableControlAction(0, 168, true) -- F7
			DisableControlAction(0, 57, true) -- F10
            DisableControlAction(0, 73, true) -- X
            DisableControlAction(0, 59, true) -- MOVE VEH LEFT/RIGHT
            DisableControlAction(0, 23, true) -- ENTER VEH F
            DisableControlAction(0, 75, true) -- EXIT VEH  F
        end
    end
end)