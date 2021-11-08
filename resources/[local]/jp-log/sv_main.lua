local sql = exports['jp-sql2']

function AddLog(type, message, data)
    local info = sql:executeSync("INSERT INTO logs (type, message, data) VALUES (?, ?, ?)", {type, message, data})
    return info
end

exports("AddLog", AddLog)