STX.Core = {}

exports('getModule', function(module)
    if not STX[module] then print("Warning: '" .. tostring(module) .. "' module doesn't exist") return false end
    return STX[module]
end)