local drawable_names = {"face", "masks", "hair", "torsos", "legs", "bags", "shoes", "neck", "undershirts", "vest", "decals", "jackets"}
local prop_names = {"hats", "glasses", "earrings", "mouth", "lhand", "rhand", "watches", "braclets"}
local head_overlays = {"Blemishes","FacialHair","Eyebrows","Ageing","Makeup","Blush","Complexion","SunDamage","Lipstick","MolesFreckles","ChestHair","BodyBlemishes","AddBodyBlemishes"}
local face_features = {"Nose_Width","Nose_Peak_Hight","Nose_Peak_Lenght","Nose_Bone_High","Nose_Peak_Lowering","Nose_Bone_Twist","EyeBrown_High","EyeBrown_Forward","Cheeks_Bone_High","Cheeks_Bone_Width","Cheeks_Width","Eyes_Openning","Lips_Thickness","Jaw_Bone_Width","Jaw_Bone_Back_Lenght","Chimp_Bone_Lowering","Chimp_Bone_Lenght","Chimp_Bone_Width","Chimp_Hole","Neck_Thikness"}
tatCategory = nil
tattooHashList = nil

function SetSkin(ped, model)
    SetPedHeadBlendData(ped, 0, 0, 0, 15, 0, 0, 0, 1.0, 0, false)
    SetPedComponentVariation(ped, 11, 0, 11, 0)
    SetPedComponentVariation(ped, 8, 0, 1, 0)
    SetPedComponentVariation(ped, 6, 1, 2, 0)
    SetPedHeadOverlayColor(ped, 1, 1, 0, 0)
    SetPedHeadOverlayColor(ped, 2, 1, 0, 0)
    SetPedHeadOverlayColor(ped, 4, 2, 0, 0)
    SetPedHeadOverlayColor(ped, 5, 2, 0, 0)
    SetPedHeadOverlayColor(ped, 8, 2, 0, 0)
    SetPedHeadOverlayColor(ped, 10, 1, 0, 0)
    SetPedHeadOverlay(ped, 1, 0, 0.0)
    SetPedHairColor(ped, 1, 1)
end

function LoadPed(ped, data, model, gender)
    if data.new then
        SetSkin(ped, gender == 0 and `mp_m_freemode_01` or `mp_f_freemode_01`)
        return
    end
    SetClothing(ped, data.drawables, data.props, data.drawtextures, data.proptextures)
    Citizen.Wait(500)
    if (model == `mp_f_freemode_01` or model == `mp_m_freemode_01`) then
        SetPedHeadBlend(ped, data.headBlend)
        SetHeadStructure(ped, data.headStructure)
        SetHeadOverlayData(ped, data.headOverlay)
        SetPedHairColor(ped, tonumber(data.hairColor[1]), tonumber(data.hairColor[2]))
        if data.fadeStyle and data.fadeStyle > 0 and data.fadeStyle ~= 255 then
          local fadeConfig = FADE_CONFIGURATIONS[model == `mp_m_freemode_01` and "male" or "female"][data.fadeStyle]
          ClearPedFacialDecorations(ped)
          Wait(1)
          SetPedFacialDecoration(ped, fadeConfig[1], fadeConfig[2])
        end
    end
    return
end

function SetClothing(ped,drawables, props, drawTextures, propTextures)
    for i = 1, #drawable_names do
        if drawables[0] == nil then
            if drawable_names[i] == "undershirts" and drawables[tostring(i-1)][2] == -1 then
                SetPedComponentVariation(ped, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(ped, i-1, drawables[tostring(i-1)][2], drawTextures[i][2], 2)
            end
        else
            if drawable_names[i] == "undershirts" and drawables[i-1][2] == -1 then
                SetPedComponentVariation(ped, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(ped, i-1, drawables[i-1][2], drawTextures[i][2], 2)
            end
        end
    end

    for i = 1, #prop_names do
        local propZ = (drawables[0] == nil and props[tostring(i-1)][2] or props[i-1][2])
        ClearPedProp(ped, i-1)
        SetPedPropIndex(
            ped,
            i-1,
            propZ,
            propTextures[i][2], true)
    end
end


function SetPedHeadBlend(ped,data)
    SetPedHeadBlendData(ped,
        tonumber(data['shapeFirst']),
        tonumber(data['shapeSecond']),
        tonumber(data['shapeThird']),
        tonumber(data['skinFirst']),
        tonumber(data['skinSecond']),
        tonumber(data['skinThird']),
        tonumber(data['shapeMix']),
        tonumber(data['skinMix']),
        tonumber(data['thirdMix']),
        false)
end

function SetHeadStructure(ped,data)
    for i = 1, #face_features do
        SetPedFaceFeature(ped, i-1, data[i])
    end
end

function SetHeadOverlayData(ped,data)
    if json.encode(data) ~= "[]" then
        for i = 1, #head_overlays do
            SetPedHeadOverlay(ped,  i-1, tonumber(data[i].overlayValue),  tonumber(data[i].overlayOpacity))
            -- SetPedHeadOverlayColor(ped, i-1, data[i].colourType, data[i].firstColour, data[i].secondColour)
        end

        SetPedHeadOverlayColor(ped, 0, 0, tonumber(data[1].firstColour), tonumber(data[1].secondColour))
        SetPedHeadOverlayColor(ped, 1, 1, tonumber(data[2].firstColour), tonumber(data[2].secondColour))
        SetPedHeadOverlayColor(ped, 2, 1, tonumber(data[3].firstColour), tonumber(data[3].secondColour))
        SetPedHeadOverlayColor(ped, 3, 0, tonumber(data[4].firstColour), tonumber(data[4].secondColour))
        SetPedHeadOverlayColor(ped, 4, 2, tonumber(data[5].firstColour), tonumber(data[5].secondColour))
        SetPedHeadOverlayColor(ped, 5, 2, tonumber(data[6].firstColour), tonumber(data[6].secondColour))
        SetPedHeadOverlayColor(ped, 6, 0, tonumber(data[7].firstColour), tonumber(data[7].secondColour))
        SetPedHeadOverlayColor(ped, 7, 0, tonumber(data[8].firstColour), tonumber(data[8].secondColour))
        SetPedHeadOverlayColor(ped, 8, 2, tonumber(data[9].firstColour), tonumber(data[9].secondColour))
        SetPedHeadOverlayColor(ped, 9, 0, tonumber(data[10].firstColour), tonumber(data[10].secondColour))
        SetPedHeadOverlayColor(ped, 10, 1, tonumber(data[11].firstColour), tonumber(data[11].secondColour))
        SetPedHeadOverlayColor(ped, 11, 0, tonumber(data[12].firstColour), tonumber(data[12].secondColour))
    end
end