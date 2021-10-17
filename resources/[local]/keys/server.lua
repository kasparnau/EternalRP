RPC.register("transferKeys", function(source, target, netId)
    TriggerClientEvent("vehicles:transferKeysTo", target, netId)
end)