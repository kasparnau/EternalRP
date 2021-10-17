local Functions, CallIdentifier = {}, {}, 0

RPC = {}

function RPC.register(name, func)
    Functions[name] = func
end

function RPC.remove(name)
    Functions[name] = nil
end

function ParamPacker(...)
    local params, pack = {...} , {}

    for i = 1, 15, 1 do
        pack[i] = {param = params[i]}
    end

    return pack
end

function ParamUnpacker(params, index)
    local idx = index or 1

    if idx <= #params then
        return params[idx]["param"], ParamUnpacker(params, idx + 1)
    end
end

function UnPacker(params, index)
    local idx = index or 1

    if idx <= 15 then
        return params[idx], UnPacker(params, idx + 1)
    end
end

RegisterNetEvent("rpc:request")
AddEventHandler("rpc:request", function(name, callID, params)
    local response
    local source = source

    if Functions[name] == nil then return end

    local success, error = pcall(function()
        response = ParamPacker(Functions[name](source, ParamUnpacker(params)))
    end)

    if not success then
        print ("Error: "..error)
        -- TriggerServerEvent("rpc:client:error", origin, name, error)
    end

    if response == nil then
        response = {}
    end

    TriggerClientEvent("rpc:response", source, callID, response)
end)