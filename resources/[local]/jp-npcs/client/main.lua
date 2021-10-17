Handler = NPCHandler:new()

Citizen.CreateThread(function()
    Handler:startThread(500)
end)

-- TODO: Better integration with external scripts and animation handler

function GetNPC(id)
    if not Handler:npcExists(id) then return end
    return Handler.npcs[id]["npc"]
end

exports("GetNPC", GetNPC)

function RegisterNPC(data)
    if not Handler:npcExists(data.id) then
        local npc = NPC:new(data.id, data.pedType, data.model, data.position, (type(data.appearance) == "string" and json.decode(data.appearance) or data.appearance), data.animation, data.networked, data.settings, data.flags, data.scenario, data.blip)

        Handler:addNPC(npc, data.distance)

        return npc
    else
        Handler.npcs[data.id]["npc"]["position"] = data.position

        return Handler.npcs[data.id]["npc"]
    end
end

exports("RegisterNPC", RegisterNPC)

function RemoveNPC(id)
    if not Handler:npcExists(id) then return end
    Handler:removeNPC(id)
end

exports("RemoveNPC", RemoveNPC)

function DisableNPC(id)
    if not Handler:npcExists(id) then return end
    Handler:disableNPC(id)
end

exports("DisableNPC", DisableNPC)

function EnableNPC(id)
    if not Handler:npcExists(id) then return end
    Handler:enableNPC(id)
end

exports("EnableNPC", EnableNPC)

function UpdateNPCData(id, key, value)
    if not Handler:npcExists(id) then return end
    Handler.npcs[id]["npc"][key] = value
end

exports("UpdateNPCData", UpdateNPCData)

function FindNPCByHash(hash)
    local found, npc = false

    for _, data in pairs(Handler.npcs) do
        if GetHashKey(data.npc.id) == hash then
            found, npc = true, data.npc
            break
        end
    end

    return found, npc
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    for _, data in pairs(Handler.npcs) do
        data["npc"]:delete()
    end
end)

--//MISC

for i,v in pairs (Generic.ShopKeeperLocations) do
    local blip = AddBlipForCoord(v.x, v.y, v.z)
    SetBlipSprite(blip, 59)
    SetBlipScale (blip, 0.7)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Grocery Store')
    EndTextCommandSetBlipName(blip)
end