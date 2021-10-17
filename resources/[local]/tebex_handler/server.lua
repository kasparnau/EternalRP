local priorityOptions = 

RegisterCommand("boughtPriority", function(_, arg)
    print (json.encode(arg))
end, true)


RegisterCommand("expiredPriority", function(_, arg)
    print (json.encode(arg))
end, true)

RegisterCommand("refundPriority", function(_, arg)
    print (json.encode(arg))
end, true)

RegisterCommand("chargebackPriority", function(_, arg)
    print (json.encode(arg))
end, true)


RegisterCommand("checkTeb", function(source, args, raw)
    print (json.encode(GetPlayerIdentifiers(source)))
end)