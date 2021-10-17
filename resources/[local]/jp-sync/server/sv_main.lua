RegisterNetEvent("sync:request")
AddEventHandler("sync:request", function(native, target, entity) 
    print ("SYNC REQUEST: "..native.." | "..target.." | "..entity)
end)