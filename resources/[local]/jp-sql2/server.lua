function db(str, data, cb)
    exports['jp-sql2']:execute(str, data, function(ret)
        if cb then 
            cb(ret)
        end
    end)
end

function dbSync(str, data)
    local queryDone = false
    local retval = nil
    exports['jp-sql2']:execute(str, data, function(ret)
        retval = ret
        queryDone = true
    end)
    repeat Wait(0) until queryDone
    return retval
end

function executeSync(str, data)
    return dbSync(str, data)
end

exports('executeSync', executeSync)
-- exports('execute', db)