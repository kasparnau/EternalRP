local Date = getDate()
local sql = exports['jp-sql2']

local WHITELIST_ONLY = true

local cachedPrio = {}

Queue.OnReady(function()
    Queue.OnJoin(function(source, allow)    
        local steam = exports['admin']:getSteam(source)
        if steam ~= "none" then
            Queue.RemovePriority(steam)

            local banData = exports['admin']:checkBanFromSource(source)

            if banData then
                local success, err = pcall(function()
                    local banEnd = Date.new(banData.date + banData.length + 10800) --* 7200 = 3 HOURS FOR GMT +3
                    local banString = banEnd:Format("%B, %d %Y "..banEnd:ToTimeString())
                    allow("Sa oled keelustatud mu serverist :). \nhttps://eternalrp.me, Ban ID: "..banData.id.."\nLõppeb: "..banString.." (GMT +3)\nPõhjus: "..banData.reason.."\nSind Bannis: "..banData.banner)    
                    return
                end)
                if not success then
                    allow("Probleem bannide checkimisega wtf: "..tostring(err))
                    return
                end
            else
                local result
                if cachedPrio[steam] then
                    result = cachedPrio[steam]
                else
                    result = sql:executeSync('SELECT priority FROM whitelist WHERE steam=? ORDER by id DESC LIMIT 1', {steam})
                    cachedPrio[steam] = result
                    CreateThread(function()
                        Wait(1000*60) -- 1 MINUTE
                        cachedPrio[steam] = nil
                    end)
                end

                if result[1] and result[1].priority > 0 then
                    Queue.AddPriority(steam, result[1].priority)
                end

                if WHITELIST_ONLY and not result[1] then
                    allow("\nSa pole whitelisted! \nArenduse stream: https://www.twitch.tv/klicerl\n\nJälgi arendust: https://discord.io/eternalinvite \nVeebileht: https://www.eternalrp.me/")
                    -- allow("\n\nYou aren't whitelisted! Join our discord and fill an application on our website!\nDiscord: discord.io/eternalinvite\nWebpage: www.eternalrp.me.")
                    return
                end

                allow()
                return
            end
        else
            allow("Sul pole Steam lahti! Palun ava/restarti Steam ja ava FiveM uuesti kui Steam on lahti!")
            return
        end
    end)

    -- local list = {}
    -- MySQL.Async.fetchAll('SELECT steam, priority, date, length FROM priority ORDER BY priority ASC', {}, function(result)
    --     for _,v in pairs (result) do
    --         if v.date + v.length > os.time() then
    --             list[v.steam] = v.priority
    --         end
    --     end
    --     Queue.AddPriority(list)
    -- end)
end)