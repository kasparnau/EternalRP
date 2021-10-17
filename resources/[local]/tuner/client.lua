local BennyPos = {x = -211.67913818359, y = -1324.5621337891, z = 30.663167953491, heading = 320.35}

function CreateBlip(coords, text, sprite, color, scale)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, scale)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)
end

CreateBlip(BennyPos, "Benny's Garage", 446, 60, 0.7)

function handlePurchase(cost, cb)
    cb(exports['inventory']:hasEnoughOfItem('cash', cost))
end

local availableTunes = {}
local currentTunes = {}

local allColors = {
    ['MetallicColors'] = {
        ['Black'] = 0,
        ['Carbon Black'] = 147,
        ['Graphite'] = 1,
        ['Anhracite Black'] = 11,
        ['Black Steel'] = 2,
        ['Dark Steel'] = 3,
        ['Silver'] = 4,
        ['Bluish Silver'] = 5,
        ['Rolled Steel'] = 6,
        ['Shadow Silver'] = 7,
        ['Stone Silver'] = 8,
        ['Midnight Silver'] = 9,
        ['Cast Iron Silver'] = 10,
        ['Red'] = 27,
        ['Torino Red'] = 28,
        ['Formula Red'] = 29,
        ['Lava Red'] = 150,
        ['Blaze Red'] = 30,
        ['Grace Red'] = 31,
        ['Garnet Red'] = 32,
        ['Sunset Red'] = 33,
        ['Cabernet Red'] = 34,
        ['Wine Red'] = 143,
        ['Candy Red'] = 35,
        ['Hot Pink'] = 135,
        ['Pfsiter Pink'] = 137,
        ['Salmon Pink'] = 136,
        ['Sunrise Orange'] = 36,
        ['Orange'] = 38,
        ['Bright Orange'] = 138,
        ['Gold'] = 99,
        ['Bronze'] = 90,
        ['Yellow'] = 88,
        ['Race Yellow'] = 89,
        ['Dew Yellow'] = 91,
        ['Dark Green'] = 49,
        ['Racing Green'] = 50,
        ['Sea Green'] = 51,
        ['Olive Green'] = 52,
        ['Bright Green'] = 53,
        ['Gasoline Green'] = 54,
        ['Lime Green'] = 92,
        ['Midnight Blue'] = 141,
        ['Galaxy Blue'] = 61,
        ['Dark Blue'] = 62,
        ['Saxon Blue'] = 63,
        ['Blue'] = 64,
        ['Mariner Blue'] = 65,
        ['Harbor Blue'] = 66,
        ['Diamond Blue'] = 67,
        ['Surf Blue'] = 68,
        ['Nautical Blue'] = 69,
        ['Racing Blue'] = 73,
        ['Ultra Blue'] = 70,
        ['Light Blue'] = 74,
        ['Chocolate Brown'] = 96,
        ['Bison Brown'] = 101,
        ['Creeen Brown'] = 95,
        ['Feltzer Brown'] = 94,
        ['Maple Brown'] = 97,
        ['Beechwood Brown'] = 103,
        ['Sienna Brown'] = 104,
        ['Saddle Brown'] = 98,
        ['Moss Brown'] = 100,
        ['Woodbeech Brown'] = 102,
        ['Sandy Brown'] = 105,
        ['Bleached Brown'] = 106,
        ['Schafter Purple'] = 71,
        ['Spinnaker Purple'] = 72,
        ['Midnight Purple'] = 142,
        ['Bright Purple'] = 145,
        ['Cream'] = 107,
        ['Ice White'] = 111,
        ['Frost White'] = 112,},
    ['MatteColors'] = {
        ['Black'] = 12,
        ['Gray'] = 13,
        ['Light Gray'] = 14,
        ['Ice White'] = 131,
        ['Blue'] = 83,
        ['Dark Blue'] = 82,
        ['Midnight Blue'] = 84,
        ['Midnight Purple'] = 149,
        ['Schafter Purple'] = 148,
        ['Red'] = 39,
        ['Dark Red'] = 40,
        ['Orange'] = 41,
        ['Yellow'] = 42,
        ['Lime Green'] = 55,
        ['Green'] = 128,
        ['Forest Green'] = 151,
        ['Foliage Green'] = 155,
        ['Olive Darb'] = 152,
        ['Dark Earth'] = 153,
        ['Desert Tan'] = 154,},
    ['MetalColors'] = {
        ['Brushed Steel'] = 117,
        ['Brushed Black Steel'] = 118,
        ['Brushed Aluminum'] = 119,
        ['Pure Gold'] = 158,
        ['Brushed Gold'] = 159,
    }

}

function getAvailableTunes(vehicle)
    availableTunes = {}
    SetVehicleModKit(vehicle, 0)

    availableTunes['Livery'] = GetNumVehicleMods(vehicle, 48)
    availableTunes['Spoilers'] = GetNumVehicleMods(vehicle, 0)
    availableTunes['FrontBumper'] = GetNumVehicleMods(vehicle, 1)
    availableTunes['RearBumper'] = GetNumVehicleMods(vehicle, 2)
    availableTunes['SideSkirt'] = GetNumVehicleMods(vehicle, 3)
    availableTunes['Exhaust'] = GetNumVehicleMods(vehicle, 4)
    availableTunes['Frame'] = GetNumVehicleMods(vehicle, 5)
    availableTunes['Grille'] = GetNumVehicleMods(vehicle, 6)
    availableTunes['Hood'] = GetNumVehicleMods(vehicle, 7)
    availableTunes['Fender'] = GetNumVehicleMods(vehicle, 8)
    availableTunes['RightFender'] = GetNumVehicleMods(vehicle, 9)
    availableTunes['Roof'] = GetNumVehicleMods(vehicle, 10)
    
    availableTunes['Engine'] = GetNumVehicleMods(vehicle, 11)
    availableTunes['Brakes'] = GetNumVehicleMods(vehicle, 12)
    availableTunes['Transmission'] = GetNumVehicleMods(vehicle, 13)
    availableTunes['Horns'] = GetNumVehicleMods(vehicle, 14)
    availableTunes['Suspension'] = GetNumVehicleMods(vehicle, 15)
    availableTunes['Armor'] = GetNumVehicleMods(vehicle, 16)

    --availableTunes['Turbo'] = GetNumVehicleMods(vehicle, 18)
    --availableTunes['Xenon'] = GetNumVehicleMods(vehicle, 22)
    
    availableTunes['FrontWheels'] = GetNumVehicleMods(vehicle, 23)
    availableTunes['BackWheels'] = GetNumVehicleMods(vehicle, 24)
    availableTunes['PlateHolder'] = GetNumVehicleMods(vehicle, 25)
    availableTunes['VanityPlate'] = GetNumVehicleMods(vehicle, 26)
    availableTunes['TrimA'] = GetNumVehicleMods(vehicle, 27)
    availableTunes['Ornaments'] = GetNumVehicleMods(vehicle, 28)
    availableTunes['Dashboard'] = GetNumVehicleMods(vehicle, 29)
    availableTunes['Dial'] = GetNumVehicleMods(vehicle, 30)
    availableTunes['DoorSpeaker'] = GetNumVehicleMods(vehicle, 31)
    availableTunes['Seats'] = GetNumVehicleMods(vehicle, 32)
    availableTunes['SteeringWheel'] = GetNumVehicleMods(vehicle, 33)
    availableTunes['ShifterLeavers'] = GetNumVehicleMods(vehicle, 34)
    
    availableTunes['APlate'] = GetNumVehicleMods(vehicle, 35)
    availableTunes['Speakers'] = GetNumVehicleMods(vehicle, 36)
    availableTunes['Trunk'] = GetNumVehicleMods(vehicle, 37)
    availableTunes['Hydrolic'] = GetNumVehicleMods(vehicle, 38)
    availableTunes['EngineBlock'] = GetNumVehicleMods(vehicle, 39)
    availableTunes['AirFilter'] = GetNumVehicleMods(vehicle, 40)
    availableTunes['Struts'] = GetNumVehicleMods(vehicle, 41)
    availableTunes['ArchCover'] = GetNumVehicleMods(vehicle, 42)
    availableTunes['Aerials'] = GetNumVehicleMods(vehicle, 43)
    availableTunes['TrimB'] = GetNumVehicleMods(vehicle, 44)
    availableTunes['Tank'] = GetNumVehicleMods(vehicle, 45)
    availableTunes['Windows'] = GetNumVehicleMods(vehicle, 46)
    availableTunes['WindowTint'] = GetNumVehicleWindowTints(vehicle)

    availableTunes['Extras'] = {}
    for extraId=0, 12 do
        if DoesExtraExist(vehicle, extraId) then
            table.insert(availableTunes['Extras'], extraId)
        end
    end

    return availableTunes
end

function getCurrentTunes(vehicle)
    currentTunes = {}
    SetVehicleModKit(vehicle, 0)

    currentTunes['PerleascentColour'], currentTunes['WheelColour'] = GetVehicleExtraColours(vehicle)
    currentTunes['Livery'] = GetVehicleMod(vehicle, 48)
    currentTunes['Spoilers'] = GetVehicleMod(vehicle, 0)
    currentTunes['FrontBumper'] = GetVehicleMod(vehicle, 1)
    currentTunes['RearBumper'] = GetVehicleMod(vehicle, 2)
    currentTunes['SideSkirt'] = GetVehicleMod(vehicle, 3)
    currentTunes['Exhaust'] = GetVehicleMod(vehicle, 4)
    currentTunes['Frame'] = GetVehicleMod(vehicle, 5)
    currentTunes['Grille'] = GetVehicleMod(vehicle, 6)
    currentTunes['Hood'] = GetVehicleMod(vehicle, 7)
    currentTunes['Fender'] = GetVehicleMod(vehicle, 8)
    currentTunes['RightFender'] = GetVehicleMod(vehicle, 9)
    currentTunes['Roof'] = GetVehicleMod(vehicle, 10)
    
    currentTunes['Engine'] = GetVehicleMod(vehicle, 11)
    currentTunes['Brakes'] = GetVehicleMod(vehicle, 12)
    currentTunes['Transmission'] = GetVehicleMod(vehicle, 13)
    currentTunes['Horns'] = GetVehicleMod(vehicle, 14)
    currentTunes['Suspension'] = GetVehicleMod(vehicle, 15)
    currentTunes['Armor'] = GetVehicleMod(vehicle, 16)

    currentTunes['Turbo'] = GetVehicleMod(vehicle, 18)
    currentTunes['Xenon'] = GetVehicleMod(vehicle, 22)
    currentTunes['WheelType'] = GetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false))
    currentTunes['FrontWheels'] = GetVehicleMod(vehicle, 23)
    currentTunes['BackWheels'] = GetVehicleMod(vehicle, 24)
    currentTunes['PlateHolder'] = GetVehicleMod(vehicle, 25)
    currentTunes['VanityPlate'] = GetVehicleMod(vehicle, 26)
    currentTunes['TrimA'] = GetVehicleMod(vehicle, 27)
    currentTunes['Ornaments'] = GetVehicleMod(vehicle, 28)
    currentTunes['Dashboard'] = GetVehicleMod(vehicle, 29)
    currentTunes['Dial'] = GetVehicleMod(vehicle, 30)
    currentTunes['DoorSpeaker'] = GetVehicleMod(vehicle, 31)
    currentTunes['Seats'] = GetVehicleMod(vehicle, 32)
    currentTunes['SteeringWheel'] = GetVehicleMod(vehicle, 33)
    currentTunes['ShifterLeavers'] = GetVehicleMod(vehicle, 34)
    
    currentTunes['APlate'] = GetVehicleMod(vehicle, 35)
    currentTunes['Speakers'] = GetVehicleMod(vehicle, 36)
    currentTunes['Trunk'] = GetVehicleMod(vehicle, 37)
    currentTunes['Hydrolic'] = GetVehicleMod(vehicle, 38)
    currentTunes['EngineBlock'] = GetVehicleMod(vehicle, 39)
    currentTunes['AirFilter'] = GetVehicleMod(vehicle, 40)
    currentTunes['Struts'] = GetVehicleMod(vehicle, 41)
    currentTunes['ArchCover'] = GetVehicleMod(vehicle, 42)
    currentTunes['Aerials'] = GetVehicleMod(vehicle, 43)
    currentTunes['TrimB'] = GetVehicleMod(vehicle, 44)
    currentTunes['Tank'] = GetVehicleMod(vehicle, 45)
    currentTunes['Windows'] = GetVehicleMod(vehicle, 46)
    currentTunes['PrimaryColour'], currentTunes['SecondaryColour'] = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false))
    
    currentTunes['Turbo'] = IsToggleModOn(vehicle, 18)
    currentTunes['Smoke'] = IsToggleModOn(vehicle, 20)
    currentTunes['Xenon'] = IsToggleModOn(vehicle, 22)
    currentTunes['WindowTint'] = GetVehicleWindowTint(vehicle)

    currentTunes['XenonColor'] = GetVehicleXenonLightsColour(vehicle)

    currentTunes['Extras'] = {}
    for extraId=0, 12 do
        if DoesExtraExist(vehicle, extraId) then
            if IsVehicleExtraTurnedOn(vehicle, extraId) then
                table.insert(currentTunes['Extras'], extraId)
            end
        end
    end

    --print (IsToggleModOn(vehicle, 18)) -- turbo 1 or false
    --print (IsToggleModOn(vehicle, 20)) -- smoke 1 or false
    --print (IsToggleModOn(vehicle, 22)) -- xenon 1 or false

    return currentTunes
end

function setVehicleTunes(vehicle, tunes)
    SetVehicleModKit(vehicle, 0)

    SetVehicleExtraColours(vehicle, 0, 0)

    if tunes['PerleascentColour'] then
        local wheelColor = tunes['WheelColour'] or 0
        SetVehicleExtraColours(vehicle, tunes['PerleascentColour'], wheelColor)
    end

    if tunes['WheelType'] then 
        SetVehicleWheelType(vehicle, tunes['WheelType']) 
    end

    if tunes['WheelColour'] then
        local perleascentColor = tunes['PerleascentColour'] or 0
        SetVehicleExtraColours(vehicle, perleascentColor, tunes['WheelColour'])
    end

    SetVehicleColours(vehicle, tunes['PrimaryColour'], tunes['SecondaryColour'])

    for extraId = 0, 20 do
        if DoesExtraExist(vehicle, extraId) then
            SetVehicleExtra(vehicle, extraId, 1)
        end
    end

    if tunes['Extras'] then
        for _, v in pairs (tunes['Extras']) do
            if DoesExtraExist(vehicle, v) then
                SetVehicleExtra(vehicle, v, 0)
            end
        end
    end

    SetVehicleMod(vehicle, 48, tunes['Livery'] or -1, false)
    SetVehicleMod(vehicle, 0, tunes['Spoilers'] or -1, false)
    SetVehicleMod(vehicle, 1, tunes['FrontBumper'] or -1, false)
    SetVehicleMod(vehicle, 2, tunes['RearBumper'] or -1, false)
    SetVehicleMod(vehicle, 3, tunes['SideSkirt'] or -1, false)
    SetVehicleMod(vehicle, 4, tunes['Exhaust'] or -1, false)
    SetVehicleMod(vehicle, 5, tunes['Frame'] or -1, false)
    SetVehicleMod(vehicle, 6, tunes['Grille'] or -1, false)
    SetVehicleMod(vehicle, 7, tunes['Hood'] or -1, false)
    SetVehicleMod(vehicle, 8, tunes['Fender'] or -1, false)
    SetVehicleMod(vehicle, 9, tunes['RightFender'] or -1, false)
    SetVehicleMod(vehicle, 10, tunes['Roof'] or -1, false)
    SetVehicleMod(vehicle, 11, tunes['Engine'] or -1, false)
    SetVehicleMod(vehicle, 12, tunes['Brakes'] or -1, false)
    SetVehicleMod(vehicle, 13, tunes['Transmission'] or -1, false)
    SetVehicleMod(vehicle, 14, tunes['Horns'] or -1, false)
    SetVehicleMod(vehicle, 15, tunes['Suspension'] or -1, false)
    SetVehicleMod(vehicle, 16, tunes['Armor'] or -1, false)
    SetVehicleMod(vehicle, 18, tunes['Turbo'] or -1, false)
    SetVehicleMod(vehicle, 22, tunes['Xenon'] or -1, false)
    SetVehicleMod(vehicle, 23, tunes['FrontWheels'] or -1, false)
    SetVehicleMod(vehicle, 24, tunes['BackWheels'] or -1, false)
    SetVehicleMod(vehicle, 25, tunes['PlateHolder'] or -1, false)
    SetVehicleMod(vehicle, 26, tunes['VanityPlate'] or -1, false)
    SetVehicleMod(vehicle, 27, tunes['TrimA'] or -1, false)
    SetVehicleMod(vehicle, 28, tunes['Ornaments'] or -1, false)
    SetVehicleMod(vehicle, 29, tunes['Dashboard'] or -1, false)
    SetVehicleMod(vehicle, 30, tunes['Dial'] or -1, false)
    SetVehicleMod(vehicle, 31, tunes['DoorSpeaker'] or -1, false)
    SetVehicleMod(vehicle, 32, tunes['Seats'] or -1, false)
    SetVehicleMod(vehicle, 33, tunes['SteeringWheel'] or -1, false)
    SetVehicleMod(vehicle, 34, tunes['ShifterLeavers'] or -1, false)
    SetVehicleMod(vehicle, 35, tunes['APlate'] or -1, false)
    SetVehicleMod(vehicle, 36, tunes['Speakers'] or -1, false)
    SetVehicleMod(vehicle, 37, tunes['Trunk'] or -1, false)
    SetVehicleMod(vehicle, 38, tunes['Hydrolic'] or -1, false)
    SetVehicleMod(vehicle, 39, tunes['EngineBlock'] or -1, false)
    SetVehicleMod(vehicle, 40, tunes['AirFilter'] or -1, false)
    SetVehicleMod(vehicle, 41, tunes['Struts'] or -1, false)
    SetVehicleMod(vehicle, 42, tunes['ArchCover'] or -1, false)
    SetVehicleMod(vehicle, 43, tunes['Aerials'] or -1, false)
    SetVehicleMod(vehicle, 44, tunes['TrimB'] or -1, false)
    SetVehicleMod(vehicle, 45, tunes['Tank'] or -1, false)
    SetVehicleMod(vehicle, 46, tunes['Windows'] or -1, false)
    SetVehicleWindowTint(vehicle, tunes['WindowTint'] or -1)
    
    ToggleVehicleMod(vehicle, 18, tunes['Turbo'] or 0)
    ToggleVehicleMod(vehicle, 20, tunes['Smoke'] or 0)
    ToggleVehicleMod(vehicle, 22, tunes['Xenon'] or 0)

    SetVehicleXenonLightsColour(vehicle, tunes['XenonColor'] or 0)

    --print (IsToggleModOn(vehicle, 18)) -- turbo 1 or false
    --print (IsToggleModOn(vehicle, 20)) -- smoke 1 or false
    --print (IsToggleModOn(vehicle, 22)) -- xenon 1 or false
end

exports('setTunes', setVehicleTunes)
exports('getTunes', getCurrentTunes)

DrawText3D = function(coords, text, size, font)
	coords = vector3(coords.x, coords.y, coords.z)

	local camCoords = GetGameplayCamCoords()
	local distance = #(coords - camCoords)

	if not size then size = 1 end
	if not font then font = 0 end

	local scale = (size / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.55 * scale)
	SetTextFont(font)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	SetDrawOrigin(coords, 0)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

local mainMenu = RageUI.CreateMenu("", "Customize your vehicle", 0, 0, "shopui_title_supermod", "shopui_title_supermod")
local repairMenu = RageUI.CreateMenu("Benny's Repair Shop", "Repair Shop")

local colorMenu = RageUI.CreateSubMenu(mainMenu)
local spoilerMenu = RageUI.CreateSubMenu(mainMenu)
local extrasMenu = RageUI.CreateSubMenu(mainMenu)

local frontBumperMenu = RageUI.CreateSubMenu(mainMenu)
local rearBumperMenu = RageUI.CreateSubMenu(mainMenu)

local sideSkirtMenu = RageUI.CreateSubMenu(mainMenu)
local exhaustMenu = RageUI.CreateSubMenu(mainMenu)
local frameMenu = RageUI.CreateSubMenu(mainMenu)
local grillMenu = RageUI.CreateSubMenu(mainMenu)
local hoodMenu = RageUI.CreateSubMenu(mainMenu)
local fenderMenu = RageUI.CreateSubMenu(mainMenu)
local rearFenderMenu = RageUI.CreateSubMenu(mainMenu)
local trimMenu = RageUI.CreateSubMenu(mainMenu)
local archCoverMenu = RageUI.CreateSubMenu(mainMenu)
local tankMenu = RageUI.CreateSubMenu(mainMenu)
local roofMenu = RageUI.CreateSubMenu(mainMenu)
local windowTintMenu = RageUI.CreateSubMenu(mainMenu)

local engineMenu = RageUI.CreateSubMenu(mainMenu)
local brakesMenu = RageUI.CreateSubMenu(mainMenu)
local transmissionMenu = RageUI.CreateSubMenu(mainMenu)
local suspensionMenu = RageUI.CreateSubMenu(mainMenu)
local armorMenu = RageUI.CreateSubMenu(mainMenu)
local turboMenu = RageUI.CreateSubMenu(mainMenu)

local xenonMenu = RageUI.CreateSubMenu(mainMenu)
    local xenonColorsMenu = RageUI.CreateSubMenu(xenonMenu)

local itemPrices = {
    ['Spoiler'] = 500,
    ['FrontBumper'] = 500,
    ['RearBumper'] = 500,
    ['SideSkirt'] = 500,
    ['Exhaust'] = 500,
    ['Frame'] = 500,
    ['Grille'] = 500,
    ['Hood'] = 500,
    ['Fender'] = 500,
    ['RightFender'] = 500,
    ['Livery'] = 500,
    ['Perleascent'] = 500,
    ['WheelColour'] = 500,
    ['PrimaryColour'] = 500,
    ['SecondaryColour'] = 500,
    ['Roof'] = 500,
    ['TrimB'] = 500,
    ['ArchCover'] = 500,
    ['Tank'] = 500,

    ['Xenon'] = 500,
    ['XenonColor'] = 1000,
    ['WindowTint'] = 500,
    ['Extras'] = 0
}

local xenonColors = {
    ['Default'] = -1,
    ['White'] = 0,
    ['Blue'] = 1,
    ['Electric Blue'] = 2,
    ['Mint Green'] = 3,
    ['Lime Green'] = 4,
    ['Yellow'] = 5,
    ['Golden Shower'] = 6,
    ['Orange'] = 7,
    ['Red'] = 8,
    ['Pony Pink'] = 9,
    ['Hot Pink'] = 10,
    ['Purple'] = 11,
    ['Blacklight'] = 12
}


local wheelTypes = {
    ['Sport'] = 0,
    ['Muscle'] = 1,
    ['Lowrider'] = 2,
    ['SUV'] = 3,
    ['Offroad'] = 4,
    ['Tuner'] = 5,
    ['Bike Wheels'] = 6,
    ['High End'] = 7,
}
local wheelCosts = {
    ['Sport'] = 1000,
    ['Muscle'] = 1000,
    ['Lowrider'] = 1000,
    ['SUV'] = 1000,
    ['Offroad'] = 1000,
    ['Tuner'] = 1000,
    ['Bike Wheels'] = 1000,
    ['High End'] = 1000,
}

local wheelMenus = {}

local wheelsMenu = RageUI.CreateSubMenu(mainMenu)
for i,v in pairs (wheelTypes) do
    wheelMenus[i] = RageUI.CreateSubMenu(wheelsMenu)
end

local liveryMenu = RageUI.CreateSubMenu(colorMenu)
local perleascentMenu = RageUI.CreateSubMenu(colorMenu)
local wheelColorMenu = RageUI.CreateSubMenu(colorMenu)
local primaryColors = RageUI.CreateSubMenu(colorMenu)
    local primaryMetallicColors = RageUI.CreateSubMenu(primaryColors)
    local primaryMatteColors = RageUI.CreateSubMenu(primaryColors)
    local primaryMetalColors = RageUI.CreateSubMenu(primaryColors)

local secondaryColors = RageUI.CreateSubMenu(colorMenu)
    local secondaryMetallicColors = RageUI.CreateSubMenu(secondaryColors)
    local secondaryMatteColors = RageUI.CreateSubMenu(secondaryColors)
    local secondaryMetalColors = RageUI.CreateSubMenu(secondaryColors)

local cost

mainMenu.Closed = function()
    TriggerEvent('chat:toggleEnabled', true)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    FreezeEntityPosition(veh, false)
    enabled = false
end

repairMenu.Closed = function()
    TriggerEvent('chat:toggleEnabled', true)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    FreezeEntityPosition(veh, false)
end

local character = exports['players']:GetClientVar("character")

AddEventHandler("login:firstSpawn", function()
    character = exports['players']:GetClientVar("character")
end)

Citizen.CreateThread(function()
    local repairing = false
    local vehicleMeta
    while true do
        Citizen.Wait(0)
        if IsPedInAnyVehicle(PlayerPedId(), true) then
            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then
                local plrX, plrY, plrZ = table.unpack(GetEntityCoords(PlayerPedId()))
                local distance = GetDistanceBetweenCoords(plrX, plrY, plrZ, BennyPos.x, BennyPos.y, BennyPos.z, true)    
                if distance < 10 then
                    DrawText3D(BennyPos, "[Vajuta E et tuunida sõidukit]", 1.0, 4)
                    local currentTunes
                    local availableTunes
                    if IsControlJustPressed(1, 51) and not enabled then
                        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                        vehicleMeta = exports['jp-garages']:getVehicleMeta(veh)

                        if vehicleMeta then
                            SetVehicleModKit(veh, 0)
                            currentTunes = getCurrentTunes(veh)
                            availableTunes = getAvailableTunes(veh)
                            local lp = GetVehicleNumberPlateText(veh)

                            if DoesEntityExist(veh) then
                                local isOwned = vehicleMeta.cid == character.cid
                                local health = GetVehicleBodyHealth(veh)
                                if isOwned and ((GetEntitySpeed(PlayerPedId()) * 3.6) < 30) then
                                    TriggerEvent('chat:toggleEnabled', false)
                                    FreezeEntityPosition(veh, true)
                                    SetEntityCoords(veh, BennyPos.x, BennyPos.y, BennyPos.z)
                                    SetEntityHeading(veh, BennyPos.heading)
                                    
                                    local plrs = GetActivePlayers()
                                    for i,v in pairs (plrs) do
                                        local ped = GetPlayerPed(v)
                                        SetEntityNoCollisionEntity(PlayerPedId(), ped, true)
                                    end

                                    if health < 1000.0 then
                                        cost = math.ceil(((1000.0 - health) * 2))
                                        RageUI.Visible(repairMenu, true)
                                    else
                                        enabled = true
                                        RageUI.Visible(mainMenu, true)
                                    end
                                else
                                    if health < 1000.0 and ((GetEntitySpeed(PlayerPedId()) * 3.6) < 30) then
                                        TriggerEvent('chat:toggleEnabled', false)
                                        FreezeEntityPosition(veh, true)
                                        SetEntityCoords(veh, BennyPos.x, BennyPos.y, BennyPos.z)
                                        SetEntityHeading(veh, BennyPos.heading)
                                        
                                        local plrs = GetActivePlayers()
                                        for i,v in pairs (plrs) do
                                            local ped = GetPlayerPed(v)
                                            SetEntityNoCollisionEntity(PlayerPedId(), ped, true)
                                        end

                                        cost = math.ceil(((1000.0 - health) * 2))
                                        RageUI.Visible(repairMenu, true)
                                    end
                                end
                            end
                        end
                    end
                end
                if RageUI.Visible(repairMenu) then
                    RageUI.DrawContent({ header = true, instructionalButton = true }, function()
                        RageUI.Button(("Paranda Sõiduk"), "Paranda Oma Sõiduk!", { RightLabel = ("$"..cost), LeftBadge = RageUI.BadgeStyle.Tick }, true, function(hovered, active, selected) 
                            if selected and not repairing then
                                if exports['inventory']:hasEnoughOfItem('cash', cost) then
                                    RageUI.Visible(repairMenu, false)
                                    repairing = true
                                    local timeToRepair = math.ceil(cost * 10)
                                    exports['progress']:Progress({
                                        name = "Repairing",
                                        duration = timeToRepair,
                                        label = ('Parandab Sõidukit'),
                                        useWhileDead = false,
                                        canCancel = true,
                                        controlDisables = {disableMovement = false,disableCarMovement = false,disableMouse = false,disableCombat = true},
                                        }, function(cancelled)
                                        if not cancelled and exports['inventory']:removeItem('cash', cost) then
                                            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                            local oldfuel = exports["fuel"]:GetFuel(vehicle)

                                            SetVehicleBodyHealth(vehicle, 1000)
                                            SetVehicleEngineHealth(vehicle, 1000)
                                            SetVehicleFixed(vehicle)
                                            --SetVehicleDirtLevel(vehicle)

                                            if oldfuel < 12.5 then
                                                exports["fuel"]:SetFuel(vehicle, 12.5)
                                            else
                                                exports["fuel"]:SetFuel(vehicle, oldfuel)
                                            end

                                            FreezeEntityPosition(vehicle, false)
                                            repairing = false
                                        end
                                    end)   
                                end                             
                            end
                        end)                
                    end, function()
                    end)
                end
                if RageUI.Visible(mainMenu) then
                    FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), true)
                    setVehicleTunes(GetVehiclePedIsIn(PlayerPedId(), false), currentTunes)
                    RageUI.DrawContent({ header = true, instructionalButton = true }, function()

                        RageUI.Button("Respray", "", { }, true, function(hovered, active, selected) 
                        end, colorMenu )   
                        
                        RageUI.Button("Engine Upgrade", "", { }, true, function(hovered, active, selected) 
                        end, engineMenu )
                        RageUI.Button("Brakes Upgrade", "", { }, true, function(hovered, active, selected) 
                        end, brakesMenu )
                        RageUI.Button("Transmission Upgrade", "", { }, true, function(hovered, active, selected) 
                        end, transmissionMenu )
                        RageUI.Button("Suspension Upgrade", "", { }, true, function(hovered, active, selected) 
                        end, suspensionMenu )
                        RageUI.Button("Armor Upgrade", "", { }, true, function(hovered, active, selected) 
                        end, armorMenu )
                        RageUI.Button("Turbo Upgrade", "", { }, true, function(hovered, active, selected) 
                        end, turboMenu )
                        RageUI.Button("Xenon Lights", "", { }, true, function(hovered, active, selected) 
                        end, xenonMenu )
                        RageUI.Button("Wheels", "", { }, true, function(hovered, active, selected) 
                        end, wheelsMenu )

                        if availableTunes['Spoilers'] > 0 then
                            RageUI.Button("Spoiler", "", { }, true, function(hovered, active, selected) 
                            end, spoilerMenu )
                        end
                        if #availableTunes['Extras'] > 0 then
                            RageUI.Button("Extras", "", { }, true, function(hovered, active, selected) 
                            end, extrasMenu )
                        end
                        if availableTunes['FrontBumper'] > 0 then
                            RageUI.Button("Front Bumper", "", { }, true, function(hovered, active, selected) 
                            end, frontBumperMenu )
                        end
                        if availableTunes['RearBumper'] > 0 then
                            RageUI.Button("Rear Bumper", "", { }, true, function(hovered, active, selected) 
                            end, rearBumperMenu )
                        end      
                        if availableTunes['SideSkirt'] > 0 then
                            RageUI.Button("Side Skirt", "", { }, true, function(hovered, active, selected) 
                            end, sideSkirtMenu )
                        end
                        if availableTunes['Exhaust'] > 0 then 
                            RageUI.Button("Exhaust", "", { }, true, function(hovered, active, selected) 
                            end, exhaustMenu )
                        end         
                        if availableTunes['Frame'] > 0 then 
                            RageUI.Button("Roll Cage", "", { }, true, function(hovered, active, selected) 
                            end, frameMenu )
                        end    
                        if availableTunes['Grille'] > 0 then 
                            RageUI.Button("Grille", "", { }, true, function(hovered, active, selected) 
                            end, grillMenu )
                        end 
                        if availableTunes['Hood'] > 0 then 
                            RageUI.Button("Hood", "", { }, true, function(hovered, active, selected) 
                            end, hoodMenu )
                        end
                                                
                        if availableTunes['Fender'] > 0 then 
                            RageUI.Button("Front Fender", "", { }, true, function(hovered, active, selected) 
                            end, fenderMenu )
                        end      

                        if availableTunes['RightFender'] > 0 then 
                            RageUI.Button("Rear Fender", "", { }, true, function(hovered, active, selected) 
                            end, rearFenderMenu )
                        end      

                        if availableTunes['TrimB'] > 0 then 
                            RageUI.Button("Trim", "", { }, true, function(hovered, active, selected) 
                            end, trimMenu )
                        end

                        if availableTunes['ArchCover'] > 0 then 
                            RageUI.Button("Arch Cover", "", { }, true, function(hovered, active, selected) 
                            end, archCoverMenu )
                        end

                        if availableTunes['Tank'] > 0 then 
                            RageUI.Button("Tank", "", { }, true, function(hovered, active, selected) 
                            end, tankMenu )
                        end
                        
                        if availableTunes['Roof'] > 0 then 
                            RageUI.Button("Roof", "", { }, true, function(hovered, active, selected) 
                            end, roofMenu )
                        end 

                        if availableTunes['WindowTint'] > 0 then 
                            RageUI.Button("Window Tint", "", { }, true, function(hovered, active, selected) 
                            end, windowTintMenu )
                        end            

                    end, function()
                        ---Panels
                    end)
                end

                if RageUI.Visible(spoilerMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()

                        for i = 0, (availableTunes['Spoilers']) do
                            i = i - 1
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['Spoiler'])
                            if currentTunes['Spoilers'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            local btnName = GetLabelText(GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 0, i))
                            if btnName == "NULL" then btnName = "Stock Spoiler" end
                            RageUI.Button(btnName, "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['Spoilers'] ~= i then
                                    local success = RPC.execute('tuner:updateMods', 'Spoilers', i, vehicleMeta.vin)
                                    if success then  
                                        currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                    end
                                end
                                if hovered then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 0, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 0, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end

                if RageUI.Visible(extrasMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()

                        for i = 1, (#availableTunes['Extras']) do
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['Extras'])

                            local isExtraEnabled = false
                            for _,v in pairs (currentTunes['Extras']) do
                                if v == i then
                                    isExtraEnabled = true
                                end
                            end

                            RageUI.Checkbox(("Extra "..i), "", isExtraEnabled, {}, function(hovered, selected, clicked, checked)
                                if clicked then
                                    local success = RPC.execute("toggleExtra", i, checked, vehicleMeta.vin)
                                    if success then
                                        SetVehicleExtra(GetVehiclePedIsIn(PlayerPedId(), false), i, isExtraEnabled and 1 or 0)
                                        currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                    end
                                end
                                if hovered or selected then
                                    SetVehicleExtra(GetVehiclePedIsIn(PlayerPedId(), false), i, 0)
                                elseif not (hovered or selected) and not isExtraEnabled then
                                    SetVehicleExtra(GetVehiclePedIsIn(PlayerPedId(), false), i, 1)
                                end
                            end)
                        end

                    end, function()
                        ---Panels
                    end)
                end

                if RageUI.Visible(frontBumperMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        for i = 0, (availableTunes['FrontBumper']) do
                            i = i - 1
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['FrontBumper'])
                            if currentTunes['FrontBumper'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            local btnName = GetLabelText(GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 1, i))
                            if btnName == "NULL" then btnName = "Stock Front Bumper" end
                            RageUI.Button(btnName, "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['FrontBumper'] ~= i then
                                    handlePurchase(itemPrices['FrontBumper'], function(success)
                                        if success then
                                            local success = RPC.execute('tuner:updateMods', 'FrontBumper', i, vehicleMeta.vin)
                                            if success then  
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end
                                    end)
                                end
                                if hovered then
                                    
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 1, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 1, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end

                if RageUI.Visible(rearBumperMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        for i = 0, (availableTunes['RearBumper']) do
                            i = i - 1
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['RearBumper'])
                            if currentTunes['RearBumper'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            local btnName = GetLabelText(GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 2, i))
                            if btnName == "NULL" then btnName = "Stock Rear Bumper" end
                            RageUI.Button(btnName, "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['RearBumper'] ~= i then
                                    handlePurchase(itemPrices['RearBumper'], function(success)
                                        if success then
                                            local success = RPC.execute('tuner:updateMods', 'RearBumper', i, vehicleMeta.vin)
                                            if success then  
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))    
                                            end
                                        end
                                    end)
                                end
                                if hovered then
                                    
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 2, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 2, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end

                if RageUI.Visible(sideSkirtMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        for i = 0, (availableTunes['SideSkirt']) do
                            i = i - 1
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['SideSkirt'])
                            if currentTunes['SideSkirt'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            local btnName = GetLabelText(GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 3, i))
                            if btnName == "NULL" then btnName = "Stock Side Skirt" end
                            RageUI.Button(btnName, "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['SideSkirt'] ~= i then
                                    handlePurchase(itemPrices['SideSkirt'], function(success)
                                        if success then
                                            local success = RPC.execute('tuner:updateMods', 'SideSkirt', i, vehicleMeta.vin)
                                            if success then  
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end
                                    end)
                                end
                                if hovered then
                                    
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 3, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 3, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end
                
                if RageUI.Visible(exhaustMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        for i = 0, (availableTunes['Exhaust']) do
                            i = i - 1
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['Exhaust'])
                            if currentTunes['Exhaust'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            local btnName = GetLabelText(GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 4, i))
                            if btnName == "NULL" then btnName = "Stock Exhaust" end
                            RageUI.Button(btnName, "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['Exhaust'] ~= i then
                                    handlePurchase(itemPrices['Exhaust'], function(success)
                                        if success then
                                            local success = RPC.execute('tuner:updateMods', 'Exhaust', i, vehicleMeta.vin)
                                            if success then  
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end
                                    end)
                                end
                                if hovered then
                                    
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 4, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 4, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end

                if RageUI.Visible(frameMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        for i = 0, (availableTunes['Frame']) do
                            i = i - 1
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['Frame'])
                            if currentTunes['Frame'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            local btnName = GetLabelText(GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 5, i))
                            if btnName == "NULL" then btnName = "Stock Roll Cage" end
                            RageUI.Button(btnName, "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['Frame'] ~= i then
                                    handlePurchase(itemPrices['Frame'], function(success)
                                        if success then
                                            local success = RPC.execute('tuner:updateMods', 'Frame', i, vehicleMeta.vin)
                                            if success then  
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end
                                    end)
                                end
                                if hovered then
                                    
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 5, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 5, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end

                if RageUI.Visible(grillMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        for i = 0, (availableTunes['Grille']) do
                            i = i - 1
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['Grille'])
                            if currentTunes['Grille'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            local btnName = GetLabelText(GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 6, i))
                            if btnName == "NULL" then btnName = "Stock Grille" end
                            RageUI.Button(btnName, "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['Grille'] ~= i then
                                        handlePurchase(itemPrices['Grille'], function(success)
                                            if success then
                                                local success = RPC.execute('tuner:updateMods', 'Grille', i, vehicleMeta.vin)
                                                if success then  
                                                    currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                                end
                                            end
                                        end)
                                end
                                if hovered then
                                    
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 6, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 6, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end

                if RageUI.Visible(hoodMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        for i = 0, (availableTunes['Hood']) do
                            i = i - 1
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['Hood'])
                            if currentTunes['Hood'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end    
                            local btnName = GetLabelText(GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 7, i))
                            if btnName == "NULL" then btnName = "Stock Hood" end
                            RageUI.Button(btnName, "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['Hood'] ~= i then
                                    handlePurchase(itemPrices['Hood'], function(success)
                                        if success then
                                            local success = RPC.execute('tuner:updateMods', 'Hood', i, vehicleMeta.vin)
                                            if success then  
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end
                                    end)
                                end
                                if hovered then
                                    
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 7, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 7, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end

                if RageUI.Visible(fenderMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        for i = 0, (availableTunes['Fender']) do
                            i = i - 1
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['Fender'])
                            if currentTunes['Fender'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end

                            local btnName = GetLabelText(GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 8, i))
                            if btnName == "NULL" then btnName = "Stock Fender" end
                            RageUI.Button(btnName, "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['Fender'] ~= i then
                                    handlePurchase(itemPrices['Fender'], function(success)
                                        if success then
                                            local success = RPC.execute('tuner:updateMods', 'Fender', i, vehicleMeta.vin)
                                            if success then  
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end
                                    end)
                                end
                                if hovered then
                                    
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 8, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 8, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end          
                
                if RageUI.Visible(rearFenderMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        for i = 0, (availableTunes['RightFender']) do
                            i = i - 1
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['RightFender'])
                            if currentTunes['RightFender'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end

                            local btnName = GetLabelText(GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 9, i))
                            if btnName == "NULL" then btnName = "Stock Rear Fender" end
                            RageUI.Button(btnName, "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['RightFender'] ~= i then
                                    handlePurchase(itemPrices['RightFender'], function(success)
                                        if success then
                                            local success = RPC.execute('tuner:updateMods', 'RightFender', i, vehicleMeta.vin)
                                            if success then  
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end
                                    end)
                                end
                                if hovered then
                                    
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 9, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 9, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end     

                if RageUI.Visible(trimMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        for i = 0, (availableTunes['TrimB']) do
                            i = i - 1
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['TrimB'])
                            if currentTunes['TrimB'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end

                            local btnName = GetLabelText(GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 44, i))
                            if btnName == "NULL" then btnName = "Stock Trim" end
                            RageUI.Button(btnName, "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['TrimB'] ~= i then
                                    handlePurchase(itemPrices['TrimB'], function(success)
                                        if success then
                                            local success = RPC.execute('tuner:updateMods', 'TrimB', i, vehicleMeta.vin)
                                            if success then  
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end
                                    end)
                                end
                                if hovered then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 44, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 44, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end     

                if RageUI.Visible(archCoverMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        for i = 0, (availableTunes['ArchCover']) do
                            i = i - 1
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['ArchCover'])
                            if currentTunes['ArchCover'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end

                            local btnName = GetLabelText(GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 42, i))
                            if btnName == "NULL" then btnName = "Stock Arch Cover" end
                            RageUI.Button(btnName, "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['ArchCover'] ~= i then
                                    handlePurchase(itemPrices['ArchCover'], function(success)
                                        if success then
                                            local success = RPC.execute('tuner:updateMods', 'ArchCover', i, vehicleMeta.vin)
                                            if success then  
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end
                                    end)
                                end
                                if hovered then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 42, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 42, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end   

                if RageUI.Visible(tankMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        for i = 0, (availableTunes['Tank']) do
                            i = i - 1
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['Tank'])
                            if currentTunes['Tank'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end

                            local btnName = GetLabelText(GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 45, i))
                            if btnName == "NULL" then btnName = "Stock Tank" end
                            RageUI.Button(btnName, "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['Tank'] ~= i then
                                    handlePurchase(itemPrices['Tank'], function(success)
                                        if success then
                                            local success = RPC.execute('tuner:updateMods', 'Tank', i, vehicleMeta.vin)
                                            if success then  
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end
                                    end)
                                end
                                if hovered then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 45, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 45, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end   

                if RageUI.Visible(roofMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        for i = 0, (availableTunes['Roof']) do
                            i = i - 1
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['Roof'])
                            if currentTunes['Roof'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            local btnName = GetLabelText(GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 10, i))
                            if btnName == "NULL" then btnName = "Stock Roof" end
                            RageUI.Button(btnName, "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['Roof'] ~= i then
                                    handlePurchase(itemPrices['Roof'], function(success)
                                        if success then
                                            local success = RPC.execute('tuner:updateMods', 'Roof', i, vehicleMeta.vin)
                                            if success then  
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end
                                    end)
                                end
                                if hovered then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 10, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 10, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end   

                if RageUI.Visible(windowTintMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        local WindowTints = {
                            ['Stock [1/7]'] = 4,
                            ['None [2/7]'] = 0,
                            ['Limo [3/7]'] = 5,
                            ['Light Smoke [4/7]'] = 3,
                            ['Dark Smoke [5/7]'] = 2,
                            ['Pure Black [6/7]'] = 1,
                            ['Green [7/7]'] = 6,
                        }
                        local indexToName = {
                            [1] = 'Stock [1/7]',
                            [2] = 'None [2/7]',
                            [3] = 'Limo [3/7]',
                            [4] = 'Light Smoke [4/7]',
                            [5] = 'Dark Smoke [5/7]',
                            [6] = 'Pure Black [6/7]',
                            [7] = 'Green [7/7]',
                        }
                        for i = 1, 7 do
                            local v = WindowTints[indexToName[i]]
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['WindowTint'])
                            if currentTunes['WindowTint'] == v then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            RageUI.Button((indexToName[i]), "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['WindowTint'] ~= v then
                                    handlePurchase(itemPrices['WindowTint'], function(success)
                                        if success then
                                            local success = RPC.execute('tuner:updateMods', 'WindowTint', v, vehicleMeta.vin)
                                            if success then  
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end
                                    end)
                                end
                                if hovered then
                                    SetVehicleWindowTint(GetVehiclePedIsIn(PlayerPedId(), false), v)
                                end
                                if active then
                                    SetVehicleWindowTint(GetVehiclePedIsIn(PlayerPedId(), false), v)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end                

                if RageUI.Visible(engineMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        for i = 1, (availableTunes['Engine']) + 1 do
                            i = i - 2
                            local LB = RageUI.BadgeStyle.None
                            local carCost = 500000
                            local index = i +2
                            local cost = ((carCost * 0.03) * index) / 2
                            cost = math.ceil(cost)
                            local costLabel = ("$"..cost)
                            if currentTunes['Engine'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            RageUI.Button(("Engine Level "..index), "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['Engine'] ~= i then
                                        handlePurchase(cost, function(success)
                                            if success then
                                                local success = RPC.execute('tuner:updateMods', 'Engine', i, vehicleMeta.vin)
                                                if success then  
                                                    currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                                end
                                            end
                                        end)
                                end
                                if hovered then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 11, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 11, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end                

                if RageUI.Visible(brakesMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        for i = 0, (availableTunes['Brakes']) do
                            i = i - 1
                            local LB = RageUI.BadgeStyle.None
                            local carCost = 500000
                            local index = i +2
                            local cost = ((carCost * 0.02) * index) / 2
                            cost = math.ceil(cost)
                            local costLabel = ("$"..cost)
                            if currentTunes['Brakes'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            RageUI.Button(("Brakes Level "..index), "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['Brakes'] ~= i then
                                    handlePurchase(cost, function(success)
                                        if success then
                                            local success = RPC.execute('tuner:updateMods', 'Brakes', i, vehicleMeta.vin)
                                            if success then  
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end
                                    end)
                                end
                                if hovered then
                                    
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 12, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 12, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end             
                
                if RageUI.Visible(transmissionMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        for i = 1, (availableTunes['Transmission']) + 1 do
                            i = i - 2
                            local LB = RageUI.BadgeStyle.None
                            local carCost = 500000
                            local index = i +2
                            local cost = ((carCost * 0.02) * index) / 2
                            cost = math.ceil(cost)
                            local costLabel = ("$"..cost)
                            if currentTunes['Transmission'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            RageUI.Button(("Transmission Level "..index), "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['Transmission'] ~= i then
                                    handlePurchase(cost, function(success)
                                        if success then
                                            local success = RPC.execute('tuner:updateMods', 'Transmission', i, vehicleMeta.vin)
                                            if success then  
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end
                                    end)
                                end
                                if hovered then
                                    
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 13, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 13, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end   

                if RageUI.Visible(suspensionMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        for i = 1, (availableTunes['Suspension']) + 1 do
                            i = i - 2
                            local LB = RageUI.BadgeStyle.None
                            local carCost = 500000
                            local index = i +2
                            local cost = ((carCost * 0.02) * index) / 2
                            cost = math.ceil(cost)
                            local costLabel = ("$"..cost)
                            if currentTunes['Suspension'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            RageUI.Button(("Suspension Level "..index), "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['Suspension'] ~= i then
                                        handlePurchase(cost, function(success)
                                            if success then
                                                local success = RPC.execute('tuner:updateMods', 'Suspension', i, vehicleMeta.vin)
                                                if success then  
                                                    currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                                end
                                            end
                                        end)
                                end
                                if hovered then
                                    
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 15, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 15, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end                       

                if RageUI.Visible(armorMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        for i = 1, (availableTunes['Armor']) + 1 do
                            i = i - 2
                            local LB = RageUI.BadgeStyle.None
                            local carCost = 500000
                            local index = i +2
                            local cost = ((carCost * 0.02) * index) / 2
                            cost = math.ceil(cost)
                            local costLabel = ("$"..cost)
                            if currentTunes['Armor'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            RageUI.Button(("Armor Level "..index), "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['Armor'] ~= i then
                                        handlePurchase(cost, function(success)
                                            if success then
                                                local success = RPC.execute('tuner:updateMods', 'Armor', i, vehicleMeta.vin)
                                                if success then  
                                                    currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                                end
                                            end
                                        end)
                                end
                                if hovered then
                                    
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 16, i, false)
                                end
                                if active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 16, i, false)
                                end
                            end)    
                        end

                    end, function()
                        ---Panels
                    end)
                end                  
                
                if RageUI.Visible(turboMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        local cost = 0
                        local cost = math.ceil(cost)
                        local costLabel = ("$"..cost)
                        local LB = RageUI.BadgeStyle.None
                        if currentTunes['Turbo'] == false then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                        RageUI.Button(("Disable Turbo"), "", { RightLabel = (costLabel), LeftBadge = LB }, true, function(hovered, active, selected)
                            if selected and currentTunes['Turbo'] ~= false then
                                handlePurchase(cost, function(success)
                                    if success then
                                        local success = RPC.execute('tuner:updateMods', 'Turbo', false, vehicleMeta.vin)
                                        if success then  
                                            ToggleVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 18, false)
                                            currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                        end
                                    end
                                end)
                            end
                        end)    
                        local carCost = 500000
                        local cost = ((carCost * 0.03) * 4) / 3
                        local cost = math.ceil(cost)
                        local costLabel = ("$"..cost)
                        local LB = RageUI.BadgeStyle.None
                        if currentTunes['Turbo'] == 1 then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                        RageUI.Button(("Enable Turbo"), "", { RightLabel = (costLabel), LeftBadge = LB }, true, function(hovered, active, selected)
                            if selected and currentTunes['Turbo'] ~= 1 then
                                handlePurchase(cost, function(success)
                                    if success then
                                        local success = RPC.execute('tuner:updateMods', 'Turbo', 1, vehicleMeta.vin)
                                        if success then  
                                            ToggleVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 18, true)
                                            currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                        end
                                    end
                                end)
                            end
                        end)    
                    end, function()
                        ---Panels
                    end)
                end                       

                if RageUI.Visible(xenonMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()
                        local cost = itemPrices['Xenon']
                        local costLabel = ("$"..cost)
                        local LB = RageUI.BadgeStyle.None
                        if currentTunes['Xenon'] == false then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                        RageUI.Button(("Disable Xenon"), "", { RightLabel = (costLabel), LeftBadge = LB }, true, function(hovered, active, selected)
                            if selected and currentTunes['Xenon'] ~= false then
                                handlePurchase(cost, function(success)
                                    if success then
                                        local success = RPC.execute('tuner:updateMods', 'Xenon', false, vehicleMeta.vin)
                                        if success then  
                                            currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                        end
                                    end
                                end)
                            end
                            if hovered or active then
                                ToggleVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 22, false)
                            end
                        end)    
                        local cost = itemPrices['Xenon']
                        local costLabel = ("$"..cost)
                        local LB = RageUI.BadgeStyle.None
                        if currentTunes['Xenon'] == 1 then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                        RageUI.Button(("Enable Xenon"), "", { RightLabel = (costLabel), LeftBadge = LB }, true, function(hovered, active, selected)
                            if selected and currentTunes['Xenon'] ~= 1 then
                                    handlePurchase(cost, function(success)
                                        if success then
                                            local success = RPC.execute('tuner:updateMods', 'Xenon', 1, vehicleMeta.vin)
                                            if success then  
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end
                                    end)
                            end
                            if hovered or active then
                                ToggleVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 22, true)
                            end    
                        end)    
                        if currentTunes['Xenon'] == 1 then
                            RageUI.Button(("Xenon Color"), "", {  }, true, function(hovered, active, selected)
                            end, xenonColorsMenu)   
                        end
                            --[[
                            RageUI.Button(("Enable Xenon"), "", { RightLabel = (costLabel), LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['Xenon'] ~= 1 then
                                    exports.bank:clientGetActiveChar(function(cid)
                                        handlePurchase(cost, function(success)
                                            if success then
                                                           
                                                TriggerServerEvent("updateMods", "Xenon", 1, GetVehiclePedIsIn(PlayerPedId(), false), cid)
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end)
                                    end)
                                end
                                if hovered or active then
                                    SetVehicleXenonLightsColour(GetVehiclePedIsIn(PlayerPedId(), false), true)
                                end    
                            end)     
                            ]]   
                    end, function()
                        ---Panels
                    end)
                end

                if RageUI.Visible(xenonColorsMenu) then
                    
                    RageUI.DrawContent({ header = true, instructionalButton = true }, function()
                        local cost = itemPrices['XenonColor']
                        local costLabel = ("$"..cost)    
                        for i,v in pairs (xenonColors) do
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = costLabel
                            if currentTunes['XenonColor'] == v then 
                                LB = RageUI.BadgeStyle.Tick 
                                costLabel = "" 
                            end        
                            RageUI.Button((i), "", { RightLabel = (costLabel), LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['XenonColor'] ~= i then
                                        handlePurchase(cost, function(success)
                                            if success then
                                                local success = RPC.execute('tuner:updateMods', 'XenonColor', v, vehicleMeta.vin)
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end)
                                end
                                if hovered or active then
                                    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                                    ToggleVehicleMod(veh, 22, true)
                                    SetVehicleXenonLightsColour(veh, v)    
                                end    
                            end)   
                        end

                        end, function()
                        ---Panels
                    end)
                    
                end        

                if RageUI.Visible(wheelsMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()

                        RageUI.Button(("Sport"), "", {  }, true, function(hovered, active, selected)
                        end, wheelMenus["Sport"])
                        RageUI.Button(("Muscle"), "", {  }, true, function(hovered, active, selected)
                        end, wheelMenus["Muscle"])
                        RageUI.Button(("SUV"), "", {  }, true, function(hovered, active, selected)
                        end, wheelMenus["SUV"])
                        RageUI.Button(("Offroad"), "", {  }, true, function(hovered, active, selected)
                        end, wheelMenus["Offroad"])
                        RageUI.Button(("Tuner"), "", {  }, true, function(hovered, active, selected)
                        end, wheelMenus["Tuner"])
                        RageUI.Button(("High End"), "", {  }, true, function(hovered, active, selected)
                        end, wheelMenus["High End"])

                        
                    end, function()
                        ---Panels
                    end)
                end

                for name,menu in pairs (wheelMenus) do
                    if RageUI.Visible(menu) then
                        RageUI.DrawContent({ header = false, instructionalButton = true }, function()
    
                            SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), wheelTypes[name])
                            
                            local availableWheels = GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 23)
    
                            for i = 1, (availableWheels) do
                                i = i - 1
                                local LB = RageUI.BadgeStyle.None
                                local cost = wheelCosts[name]
                                local costLabel = ("$"..cost)

                                if currentTunes['FrontWheels'] == i and currentTunes['WheelType'] == wheelTypes[name] then LB = RageUI.BadgeStyle.Tick costLabel = "" end

                                local btnName = GetLabelText(GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 23, i))
                                RageUI.Button((btnName.." Wheel "..i+1), "", { LeftBadge = LB, RightLabel = (costLabel) }, true, function(hovered, active, selected)
                                    print (currentTunes['WheelType'].." | "..wheelTypes[name])
                                    if selected and (currentTunes['FrontWheels'] ~= i or currentTunes['WheelType'] ~= wheelTypes[name]) then
                                        handlePurchase(cost, function(success)
                                            if success then
                                                RPC.execute('tuner:updateMods', "WheelType", wheelTypes[name], vehicleMeta.vin, {
                                                    mod = "FrontWheels",
                                                    val = i,
                                                })
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end)
                                    end
                                    if hovered or active then
                                        SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i)
                                        SetVehicleExtraColours(vehicle, currentTunes['PerleascentColour'], currentTunes['WheelColour'])
                                    end
                                end)
                            end
                            
                        end, function()
                            ---Panels
                        end)
                    end    
                end

                if RageUI.Visible(colorMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()

                    RageUI.Button("Primary Colour", "", { }, true, function(hovered, active, selected)
                    end, primaryColors)

                    RageUI.Button("Secondary Colour", "", { }, true, function(hovered, active, selected)
                    end, secondaryColors)

                    RageUI.Button("Perlesceant Colour", "", { }, true, function(hovered, active, selected)
                    end, perleascentMenu)

                    if availableTunes['Livery'] ~= -1 then
                        RageUI.Button("Livery", "", { }, true, function(hovered, active, selected)
                        end, liveryMenu)        
                    end

                    RageUI.Button("Wheel Colour", "", { }, true, function(hovered, active, selected)
                    end, wheelColorMenu)

                    end, function()
                        ---Panels
                    end)
                end

                if RageUI.Visible(liveryMenu) then
                    RageUI.DrawContent({ header = false, instructionalButton = true }, function()

                    --print (availablePrimaryColors)
                    for i = 0, availableTunes['Livery'] do
                        local i = i - 1
                        local LB = RageUI.BadgeStyle.None
                        local costLabel = ("$"..itemPrices['Livery'])
                        if currentTunes['Livery'] == i then LB = RageUI.BadgeStyle.Tick costLabel = "" end

                        local btnName = GetLabelText(GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 48, i))
                        if btnName == "NULL" then btnName = "Stock Livery" end
                        RageUI.Button(btnName, "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                            if selected and currentTunes['Livery'] ~= v then
                                handlePurchase(itemPrices['Livery'], function(success)
                                    if success then
                                        local success = RPC.execute('tuner:updateMods', 'Livery', i, vehicleMeta.vin)
                                        currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                    end
                                end)
                            end
                            if hovered then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId()), 48, i, false)
                            end
                            if active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId()), 48, i, false)
                            end
                        end)
                    end    

                    end, function()
                        ---Panels
                    end)
                end

                if RageUI.Visible(primaryColors) then
                    RageUI.DrawContent({ header = true, instructionalButton = true }, function()
                       
                        RageUI.Button("Metallic" , "", {  }, true, function(Hovered, Active, Selected) 
                        end, primaryMetallicColors)       
                        RageUI.Button("Matte" , "", {  }, true, function(Hovered, Active, Selected) 
                        end, primaryMatteColors)       
                        RageUI.Button("Metal" , "", {  }, true, function(Hovered, Active, Selected) 
                        end, primaryMetalColors)       

                        local a = currentTunes['PrimaryColour']
                        local b = currentTunes['SecondaryColour']

                        SetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false), a, b)

                    end, function()
                        ---Panels
                    end)
                end      
                
                    if RageUI.Visible(perleascentMenu) then
                        RageUI.DrawContent({ header = false, instructionalButton = true }, function()

                        --print (availablePrimaryColors)
                        for i,v in pairs (allColors['MetallicColors']) do
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['Perleascent'])
                            if currentTunes['PerleascentColour'] == v then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            RageUI.Button((i), "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['PerleascentColour'] ~= v then
                                        handlePurchase(itemPrices['Perleascent'], function(success)
                                            if success then
                                                local success = RPC.execute('tuner:updateMods', 'PerleascentColour', v, vehicleMeta.vin)          
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end)
                                end
                                if hovered then
                                    local a,b = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId(), false))
                                    SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId(), false), v, b)
                                end
                                if active then
                                    local a,b = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId(), false))
                                    SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId(), false), v, b)
                                end
                            end)
                        end    

                        end, function()
                            ---Panels
                        end)
                    end

                    if RageUI.Visible(wheelColorMenu) then
                        RageUI.DrawContent({ header = false, instructionalButton = true }, function()

                        --print (availablePrimaryColors)
                        for i,v in pairs (allColors['MetallicColors']) do
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['WheelColour'])
                            if currentTunes['WheelColour'] == v then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            RageUI.Button((i), "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['WheelColour'] ~= v then
                                        handlePurchase(itemPrices['WheelColour'], function(success)
                                            if success then
                                                local success = RPC.execute('tuner:updateMods', 'WheelColour', v, vehicleMeta.vin)     
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end)
                                end
                                if hovered then
                                    local a,b = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId(), false))
                                    SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId(), false), a, v)
                                    local a,b = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId(), false))
                                end
                                if active then
                                    local a,b = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId(), false))
                                    SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId(), false), a, v)
                                end
                            end)
                        end    

                        end, function()
                            ---Panels
                        end)
                    end

                    if RageUI.Visible(primaryMetallicColors) then
                        RageUI.DrawContent({ header = false, instructionalButton = true }, function()

                        --print (availablePrimaryColors)
                        for i,v in pairs (allColors['MetallicColors']) do
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['PrimaryColour'])
                            if currentTunes['PrimaryColour'] == v then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            RageUI.Button((i), "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['PrimaryColour'] ~= v then
                                    handlePurchase(itemPrices['PrimaryColour'], function(success)
                                        if success then
                                            print "1"
                                            local success = RPC.execute('tuner:updateMods', 'PrimaryColour', v, vehicleMeta.vin)   
                                            if success then
                                                currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                            end
                                        end
                                    end)
                                end
                                if hovered then
                                    local a,b = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false))
                                    SetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false), v, b)
                                end
                                if active then
                                    local a,b = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false))
                                    SetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false), v, b)
                                end
                            end)
                        end    

                        end, function()
                            ---Panels
                        end)
                    end

                    if RageUI.Visible(primaryMatteColors) then
                        RageUI.DrawContent({ header = false, instructionalButton = true }, function()

                        --print (availablePrimaryColors)
                        for i,v in pairs (allColors['MatteColors']) do
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['PrimaryColour'])
                            if currentTunes['PrimaryColour'] == v then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            RageUI.Button((i), "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['PrimaryColour'] ~= v then
                                        handlePurchase(itemPrices['PrimaryColour'], function(success)
                                            if success then
                                                local success = RPC.execute('tuner:updateMods', 'PrimaryColour', v, vehicleMeta.vin)   
                                                if success then  
                                                    currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                                end
                                            end
                                        end)
                                end
                                if hovered then
                                    local a,b = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false))
                                    SetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false), v, b)
                                end
                                if active then
                                    local a,b = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false))
                                    SetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false), v, b)
                                end
                            end)
                        end    

                        end, function()
                            ---Panels
                        end)
                    end
                    if RageUI.Visible(primaryMetalColors) then
                        RageUI.DrawContent({ header = false, instructionalButton = true }, function()

                        --print (availablePrimaryColors)
                        for i,v in pairs (allColors['MetalColors']) do
                            local LB = RageUI.BadgeStyle.None
                            local costLabel = ("$"..itemPrices['PrimaryColour'])
                            if currentTunes['PrimaryColour'] == v then LB = RageUI.BadgeStyle.Tick costLabel = "" end
                            RageUI.Button((i), "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                if selected and currentTunes['PrimaryColour'] ~= v then
                                        handlePurchase(itemPrices['PrimaryColour'], function(success)
                                            if success then
                                                local success = RPC.execute('tuner:updateMods', 'PrimaryColour', v, vehicleMeta.vin)
                                                if success then    
                                                    currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                                end
                                            end
                                        end)
                                end
                                if hovered then
                                    local a,b = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false))
                                    SetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false), v, b)
                                end
                                if active then
                                    local a,b = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false))
                                    SetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false), v, b)
                                end
                            end)
                        end    

                        end, function()
                            ---Panels
                        end)
                    end

                    ----------------------------------------------------------------- SECONDARY COLOR  -----------------------------------------------------------------

                    if RageUI.Visible(secondaryColors) then
                        RageUI.DrawContent({ header = true, instructionalButton = true }, function()
                           
                            RageUI.Button("Metallic" , "", {  }, true, function(Hovered, Active, Selected) 
                            end, secondaryMetallicColors)       
                            RageUI.Button("Matte" , "", {  }, true, function(Hovered, Active, Selected) 
                            end, secondaryMatteColors)       
                            RageUI.Button("Metal" , "", {  }, true, function(Hovered, Active, Selected) 
                            end, secondaryMetalColors)       
    
                            local a = currentTunes['PrimaryColour']
                            local b = currentTunes['SecondaryColour']
    
                            SetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false), a, b)
    
                        end, function()
                            ---Panels
                        end)
                    end        
    
                        if RageUI.Visible(secondaryMetallicColors) then
                            RageUI.DrawContent({ header = false, instructionalButton = true }, function()
    
                            --print (availablesecondaryColors)
                            for i,v in pairs (allColors['MetallicColors']) do
                                local LB = RageUI.BadgeStyle.None
                                local costLabel = ("$"..itemPrices['SecondaryColour'])
                                if currentTunes['SecondaryColour'] == v then LB = RageUI.BadgeStyle.Tick costLabel = "" end    
                                RageUI.Button((i), "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                    if selected and currentTunes['SecondaryColour'] ~= v then
                                            handlePurchase(itemPrices['SecondaryColour'], function(success)
                                                if success then
                                                    local success = RPC.execute('tuner:updateMods', 'SecondaryColour', v, vehicleMeta.vin)  
                                                    if success then  
                                                        currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                                    end
                                                end
                                            end)
                                    end    
                                    if hovered then
                                        local a,b = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false))
                                        SetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false), a, v)
                                    end
                                    if active then
                                        local a,b = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false))
                                        SetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false), a, v)
                                    end
                                end)
                            end    
    
                            end, function()
                                ---Panels
                            end)
                        end
                        if RageUI.Visible(secondaryMatteColors) then
                            RageUI.DrawContent({ header = false, instructionalButton = true }, function()
    
                            --print (availablesecondaryColors)
                            for i,v in pairs (allColors['MatteColors']) do
                                local LB = RageUI.BadgeStyle.None
                                local costLabel = ("$"..itemPrices['SecondaryColour'])
                                if currentTunes['SecondaryColour'] == v then LB = RageUI.BadgeStyle.Tick costLabel = "" end    
                                RageUI.Button((i), "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                    if selected and currentTunes['SecondaryColour'] ~= v then
                                            handlePurchase(itemPrices['SecondaryColour'], function(success)
                                                if success then
                                                    local success = RPC.execute('tuner:updateMods', 'SecondaryColour', v, vehicleMeta.vin)  
                                                    if success then  
                                                        currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                                    end  
                                                end
                                            end)
                                    end    
                                    if hovered then
                                        local a,b = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false))
                                        SetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false), a, v)
                                    end
                                    if active then
                                        local a,b = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false))
                                        SetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false), a, v)
                                    end
                                end)
                            end    
    
                            end, function()
                                ---Panels
                            end)
                        end
                        if RageUI.Visible(secondaryMetalColors) then
                            RageUI.DrawContent({ header = false, instructionalButton = true }, function()
    
                            --print (availablesecondaryColors)
                            for i,v in pairs (allColors['MetalColors']) do
                                local LB = RageUI.BadgeStyle.None
                                local costLabel = ("$"..itemPrices['SecondaryColour'])
                                if currentTunes['SecondaryColour'] == v then LB = RageUI.BadgeStyle.Tick costLabel = "" end    
                                RageUI.Button((i), "", { RightLabel = costLabel, LeftBadge = LB }, true, function(hovered, active, selected)
                                    if selected and currentTunes['SecondaryColour'] ~= v then
                                            handlePurchase(itemPrices['SecondaryColour'], function(success)
                                                if success then
                                                    local success = RPC.execute('tuner:updateMods', 'SecondaryColour', v, vehicleMeta.vin)  
                                                    if success then  
                                                        currentTunes = getCurrentTunes(GetVehiclePedIsIn(PlayerPedId(), false))
                                                    end
                                                end
                                            end)
                                    end    
                                    if hovered then
                                        local a,b = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false))
                                        SetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false), a, v)
                                    end
                                    if active then
                                        local a,b = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false))
                                        SetVehicleColours(GetVehiclePedIsIn(PlayerPedId(), false), a, v)
                                    end
                                end)
                            end    
    
                            end, function()
                                ---Panels
                            end)
                        end 
                        
                        ----------------------------------------------------- OTHER -----------------------------------------------------
            end
        end
    end
end)