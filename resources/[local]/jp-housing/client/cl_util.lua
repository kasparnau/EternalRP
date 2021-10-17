function generateZoneList()
    for k,v in pairs(Housing.info) do
        local zone = GetZoneAtCoords(v[1])
        local zoneName = GetNameOfZone(v[1])

        if Housing.zone[zoneName] == nil then
            Housing.zone[zoneName] = {
                locations = {},
                zoneName = zoneName
            }
        end
        Housing.zone[zoneName].locations[k] = vec3FromVec4(v[1])
    end
end

function vec3FromVec4(vec4)
    return vector3(vec4.x,vec4.y,vec4.z)
end

Citizen.CreateThread(function()
    generateZoneList()
end)