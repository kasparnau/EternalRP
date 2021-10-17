--* JOBS
-- TAXI JOB
-- TRUCKER
-- POSTI
-- BUS DRIVER
-- NEWS REPORTER
-- PILOT FOR RESTOCKING (NEEDS TO COMPLETE TRAINING)

--? Whitelisted:
--! POLICE
--! EMS

--* CRIME:
-- METH
-- COCAINE
-- CRACK
-- WEED JOINT

-- HOUSE ROBBERIES
-- VALUABLES

-- -- MELTING VALUABLES FOR MATERIALS, GETTING MATERIALS FROM CARS

-- -- BANK ROBBERIES
-- --> VALUABLES LIKE MONEY, GOLD STUFF. NEED CARDS AND THERMITE TO ROB. BIG BANK HACKING MINIGAME
-- local events = exports['events']

-- RegisterCommand("setjob", function(source, args)
--     local rank = tonumber(args[3]) or 0
--     local job = args[2]
--     local target = tonumber(args[1])
--     if not job or not target then print "Invalid args" return end

--     local srcCharacter = exports['players']:getCharacter(source)
--     local trgCharacter = exports['players']:getCharacter(target)

--     if not srcCharacter or not trgCharacter then print "Invalid target player" return end

--     local hasPerms = jobRanks[job] and (srcCharacter.job == job and srcCharacter.jobRank >= 5)
--     if hasPerms then
--         exports['players']:modifyPlayerCurrentCharacter(target, "job", job)
--         MySQL.Sync.execute('UPDATE characters SET job = @job WHERE cid = @cid', {['job'] = job, ['jobRank'] = rank, ['cid'] = trgCharacter.cid})

--         local alertText = "You have promoted "..trgCharacter.first_name.." "..trgCharacter.last_name.." to "..job.." | "..jobRanks[job][rank]
--         TriggerClientEvent("alerts:SendNotification", source, 'Jobs', alertText, 'successAlert')
--     end
-- end)