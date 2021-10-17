local sql = exports['jp-sql2']

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local mult = 10
CreateThread(function()
	while true do
        for i,v in pairs (GetPlayers()) do
            local character = exports['players']:getCharacter(v)
            if character and character.jail_time > 0.0 then
                local newJailTime = round(character.jail_time - 1/mult, 1)
                exports['players']:modifyPlayerCurrentCharacter(v, 'jail_time', newJailTime)

                sql:executeSync('UPDATE characters SET jail_time=? WHERE cid=?', {newJailTime, character.cid})

                if newJailTime <= 0.0 then
                    local pos = {
                        x = 1839.9956054688,
                        y = 2590.1538085938,
                        z = 45.9443359375,
                        heading = 0.0
                    }

                    sql:executeSync('UPDATE characters SET jail_time=?, position=? WHERE cid=?', {0, json.encode(pos), character.cid})
                    exports['players']:modifyPlayerCurrentCharacter(v, 'jail_time', 0)
                    SetEntityCoords(GetPlayerPed(v), pos.x, pos.y, pos.z, 0, 0, 0, false)
                end
            end
        end
        Wait(60*1000/mult)
    end
end)