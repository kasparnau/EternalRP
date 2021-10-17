local sql = exports['jp-sql2']

exports("revivePlayer", function(target)
	if GetPlayerName(target) == nil then return end
	TriggerClientEvent('death:revivePlayer', target)
end)

RegisterNetEvent("death:live")
AddEventHandler("death:live", function()
	local trgCharacter = exports['players']:getCharacter(source)
	if trgCharacter then
		sql:execute('UPDATE characters SET dead=0 WHERE cid=?', {trgCharacter.cid})
	end
end)

RegisterNetEvent("death:died")
AddEventHandler("death:died", function()
	local trgCharacter = exports['players']:getCharacter(source)
	if trgCharacter then
		sql:execute('UPDATE characters SET dead=1 WHERE cid=?', {trgCharacter.cid})
	end
end)

RegisterCommand("revive", function(source, args, raw)
	local player = args[1] and args[1] or source
	exports['death']:revivePlayer(player)
end)

RegisterNetEvent("death:reviveSomeone")
AddEventHandler("death:reviveSomeone", function(target)
	print ("target: "..target)
	exports['death']:revivePlayer(target)
end)

RegisterCommand("checkit", function(source, args, raw)
	print ("A: "..tostring(Player(source).state.alive))
end)