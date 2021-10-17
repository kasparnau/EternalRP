local blips = {
    {id = "casino", name = "Diamond Casino & Resort", scale = 0.7, color = 5, sprite = 207, x = 925.329, y = 46.152, z = 80.908 },
    {id = "hospital", name = "Haigla", scale = 0.7, color = 2, sprite = 61, x = 357.43, y= -593.36, z= 28.79},
    {id = "veh_rentals", name = "Autorendibüroo", scale = 0.7, color = 2, sprite = 326, x=108.77, y=-1088.88, z=29.3},
    {id = "PDM", name = "Premium Deluxe Motorsports", scale = 0.7, color = 7, sprite = 326, x=-33.737, y=-1102.322, z= 26.422},
    {id = "bicycles", name = "Jalgrattapood", scale = 0.7, color = 7, sprite = 226, x=-1100.69, y= -1702.88, z= 4.38},
    {id = 'harmony_repairs', name = 'Harmony Repairs', scale = 0.7, color = 12, sprite = 478, x = 1183.18, y = 2651.66, z = 37.81},
    {id = "driving_school", name = "Autokool", scale = 0.7, color = 44, sprite = 380, x = 239.90, y= -1380.32, z= 33.728},
    {id = "job_center", name = "Töötukassa", scale = 0.7, color = 44, sprite = 525, x = -268.49670410156, y = -958.19342041016, z = 31.217529296875},
    {id = "mrpd", name = "Mission Row Politseijaoskond", scale = 0.7, color = 74, sprite = 60, x = 452.67694091797, y = -987.94287109375, z = 43.686401367188},
}

local BlipManager = exports['blipmanager']

AddEventHandler("players:playerSessionStarted", function()
    Citizen.CreateThread(function()
        for k,v in ipairs(blips) do
            BlipManager:CreateBlip(v.id, v)
        end
    end)
end)

Citizen.CreateThread(function()
    for k,v in ipairs(blips) do
        BlipManager:CreateBlip(v.id, v)
    end
end)
