local ammoTable = {}

function _ammoTypeCheck(atype)
	if type(atype) == "number" then
		if ammoTable[tostring(atype)] == nil then
			ammoTable[tostring(atype)] = {}
			ammoTable[tostring(atype)]["ammo"] = 0
			ammoTable[tostring(atype)]["type"] = atype
		end
	end
end

function getWeaponAmmo(hash)
	_ammoTypeCheck(hash)
    if not ammoTable[tostring(hash)] then return 0 end
	return ammoTable[tostring(hash)].ammo
end

function getAmmoTypeHash(weaponHash)
	local ped = PlayerPedId()
	local ammoType = Citizen.InvokeNative(0x7FEAD38B326B9F74, ped, weaponHash)

	return ammoType
end

function updateAmmo(hash, new)
    if not ammoTable[tostring(hash)] then return false end
    ammoTable[tostring(hash)].ammo = new

    CreateThread(function()
        Wait(1000)
        if ammoTable[tostring(hash)] and ammoTable[tostring(hash)].ammo == new then
            TriggerServerEvent("inventory:weapons:updateAmmo", hash, new)
        end
    end)
end

function addAmmo(hash, amount)
	_ammoTypeCheck(hash)

    ammoTable[tostring(hash)].ammo = ammoTable[tostring(hash)].ammo + amount
	if ammoTable[tostring(hash)].ammo > 150 then ammoTable[tostring(hash)].ammo = 150 end

	SetPedAmmoByType(PlayerPedId(), hash, ammoTable[tostring(hash)].ammo)
end

Citizen.CreateThread( function()
	while true do
		Wait(0)
		
		local ped = PlayerPedId()
		if IsPedShooting(ped) then
            local hash = GetSelectedPedWeapon(ped)
            local id = getItemIdFromHash(hash)
            print (`WEAPON_BRICK`.." | "..hash.." | "..tostring(id))
            -- if not id or not exports['inventory']:hasEnoughOfItem(id, 1) then
            --     TriggerEvent("DoLongHudText", "Sa tulistasid relvaga mida sa ei oma!!!! >:( automaatne ban peale kui poleks vMenu XD", "red", 5000)
            --     -- TriggerServerEvent("admin:banMyAss", ("Fired not owned weapon: %s (%s)"):format(hash, id), 5259492)
            --     -- return
            -- end

            if (lastEquippedThrowable) then
                exports['inventory']:removeItem(getItemIdFromHash(lastEquippedThrowable), 1)

            -- if (isThrowableWeapon(hash) and getItemIdFromHash(hash)) then
            --     exports['inventory']:removeItem(getItemIdFromHash(hash), 1)
            else
                local ammoType = Citizen.InvokeNative(0x7FEAD38B326B9F74, ped, hash)
                newammo = GetPedAmmoByType(ped, ammoType)
                updateAmmo(ammoType, newammo)
            end
        end
    end
end)

RegisterNetEvent("inventory:weapons:refreshAmmo")
AddEventHandler("inventory:weapons:refreshAmmo", function(newAmmoTable)
    ammoTable = {}
    for i,v in pairs (newAmmoTable) do
        ammoTable[tostring(v.hash)] = {
            hash = v.hash,
            ammo = v.ammo
        }
    end
	print (json.encode(ammoTable))
end)

CreateThread(function()
    if exports['players']:GetClientVar("inGame") then --* IF RESTARTED SCRIPT, AKA ALREADY IN GAME 
        TriggerServerEvent("inventory:weapons:requestAmmo")
    end
end)