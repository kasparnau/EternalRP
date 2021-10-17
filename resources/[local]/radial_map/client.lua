-- posX = -0.02
-- posY = -0.05-- 0.0152

-- width = 0.183
-- height = 0.26--0.354

-- Citizen.CreateThread(function()
-- 	RequestStreamedTextureDict("circlemap", false)
-- 	while not HasStreamedTextureDictLoaded("circlemap") do
-- 		Wait(0)
-- 	end

-- 	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
-- 	AddReplaceTexture("platform:/textures/graphics", "radarmasklg", "circlemap", "radarmasklg")

--     SetBlipAlpha(GetNorthRadarBlip(), 0.0)
    
-- 	SetMinimapClipType(1)
-- 	SetMinimapComponentPosition('minimap', 'L', 'B', posX, posY, width, height)
-- 	--SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.0, 0.032, 0.101, 0.259)
-- 	SetMinimapComponentPosition('minimap_mask', 'L', 'B', posX, posY, width, height)
-- 	SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.0188, 0.023, 0.256, 0.337)

--     local minimap = RequestScaleformMovie("minimap")
--     SetRadarBigmapEnabled(true, false)
--     Wait(0)
--     SetRadarBigmapEnabled(false, false)

--     while true do
--         Wait(0)
--         BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
--         ScaleformMovieMethodAddParamInt(3)
--         EndScaleformMovieMethod()
--     end
-- end)

posX = -0.02
posY = -0.05-- 0.0152

width = 0.183
height = 0.26--0.354

Citizen.CreateThread(function()
	RequestStreamedTextureDict("circlemap", false)
	while not HasStreamedTextureDictLoaded("circlemap") do
		Wait(100)
	end

	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

	SetMinimapClipType(1)
    SetMinimapComponentPosition('minimap', 'L', 'B', posX, posY, width, height)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', posX, posY, width, height)       
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.0188, 0.0, 0.256, 0.337)

    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)

    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)

local uiHidden = false

Citizen.CreateThread(function()
	while true do
		Wait(100)
        local w, h = GetActiveScreenResolution()
        local is1080p = (w == 1920) and (h == 1080)
		if IsBigmapActive() or IsRadarHidden() or IsPauseMenuActive() or not is1080p then
			if not uiHidden then
				SendNUIMessage({
					action = "hideUI"
				})
				uiHidden = true
			end
		elseif uiHidden and is1080p then
			SendNUIMessage({
				action = "displayUI"
			})
			uiHidden = false
		end
	end
end)
