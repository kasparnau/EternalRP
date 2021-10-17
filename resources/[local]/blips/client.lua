local myBlips = {}

function addBlip(data)
    local success, err = pcall(function()
        local myBlip = AddBlipForCoord(data.blipCoords)

        SetBlipSprite(myBlip, data.blipId)
        SetBlipColour(myBlip, data.colour)
        SetBlipScale(myBlip, data.scale)
        SetBlipAsShortRange(myBlip, true)   

        if data.displayName then
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(data.displayName)
            EndTextCommandSetBlipName(myBlip)    
        end

        myBlips[myBlips+1] = myBlip
    end)

    if not success then print ("Blip Error: "..err.. " with the blip: "..json.encode(item)) end
end

function getBlip(name)
    for i = 1, #myBlips do
        local blip = myBlips[i]
        if blip.displayName and blip.displayName == name then return blip end
    end
    return false
end

exports('addBlip', addBlip)
exports('getBlip', getBlip)