local sql = exports['jp-sql2']

RegisterNetEvent("clothes:setCurrentOutfit")
AddEventHandler("clothes:setCurrentOutfit", function(data)
    local playerId = source

    local playerData = exports['players']:getPlayerDataFromSource(playerId)
    local charData = exports['players']:getCharacter(playerId)

    if (exports['modules']:getModule("Util").compareTables(charData.outfit, data)) then
        print ("^5[Clothes]^7 ^3[WARN]^7 PID: "..playerData.pid.." | License: "..playerData.license.." | CID: "..charData.cid.." | Attempted to save set the same outfit")
        return
    end

    exports['players']:modifyPlayerCurrentCharacter(playerId, "outfit", data)
    local outfit = json.encode(data)
    local result = sql:executeSync('UPDATE characters SET outfit=? WHERE cid=? and pid=?', {outfit, charData.cid, playerData.pid})
    print ("^5[Clothes]^7 PID: "..playerData.pid.." | License: "..playerData.license.." | CID: "..charData.cid.." | Set Outfit: "..string.sub(outfit, 1, 50).."...")
end)

-- local bitch = '{"model":1885233650,"proptextures":[["hats",-1],["glasses",1],["earrings",-1],["mouth",-1],["lhand",-1],["rhand",-1],["watches",-1],["braclets",-1]],"hairColor":[15,1],"headStructure":[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,1.0,1.0,-1.0,0.0],"headOverlay":[{"colourType":0,"overlayValue":255,"secondColour":0,"firstColour":0,"name":"Blemishes","overlayOpacity":1.0},{"colourType":1,"overlayValue":255,"secondColour":0,"firstColour":0,"name":"FacialHair","overlayOpacity":0.0},{"colourType":1,"overlayValue":255,"secondColour":0,"firstColour":0,"name":"Eyebrows","overlayOpacity":1.0},{"colourType":0,"overlayValue":255,"secondColour":0,"firstColour":0,"name":"Ageing","overlayOpacity":1.0},{"colourType":2,"overlayValue":255,"secondColour":0,"firstColour":0,"name":"Makeup","overlayOpacity":1.0},{"colourType":2,"overlayValue":255,"secondColour":0,"firstColour":0,"name":"Blush","overlayOpacity":1.0},{"colourType":0,"overlayValue":255,"secondColour":0,"firstColour":0,"name":"Complexion","overlayOpacity":1.0},{"colourType":0,"overlayValue":255,"secondColour":0,"firstColour":0,"name":"SunDamage","overlayOpacity":1.0},{"colourType":2,"overlayValue":255,"secondColour":0,"firstColour":0,"name":"Lipstick","overlayOpacity":1.0},{"colourType":0,"overlayValue":255,"secondColour":0,"firstColour":0,"name":"MolesFreckles","overlayOpacity":1.0},{"colourType":1,"overlayValue":255,"secondColour":0,"firstColour":0,"name":"ChestHair","overlayOpacity":1.0},{"colourType":0,"overlayValue":255,"secondColour":0,"firstColour":0,"name":"BodyBlemishes","overlayOpacity":1.0},{"colourType":0,"overlayValue":255,"secondColour":0,"firstColour":0,"name":"AddBodyBlemishes","overlayOpacity":1.0}],"headBlend":{"shapeFirst":4,"skinMix":1.0,"skinFirst":15,"shapeMix":0.0,"shapeSecond":3,"shapeThird":0,"skinSecond":0,"skinThird":0,"thirdMix":0.0,"hasParent":false},"drawtextures":[["face",0],["masks",0],["hair",0],["torsos",0],["legs",0],["bags",0],["shoes",0],["neck",0],["undershirts",0],["vest",0],["decals",0],["jackets",0]],"props":{"1":["glasses",5],"2":["earrings",-1],"3":["mouth",-1],"4":["lhand",-1],"5":["rhand",-1],"6":["watches",-1],"7":["braclets",-1],"0":["hats",-1]},"drawables":{"1":["masks",0],"2":["hair",57],"3":["torsos",0],"4":["legs",75],"5":["bags",0],"6":["shoes",51],"7":["neck",0],"8":["undershirts",59],"9":["vest",0],"10":["decals",0],"11":["jackets",56],"0":["face",0]}}'
-- function doP()
--     local new = {}
--     local tbl = json.decode(bitch)
--     for i,v in pairs (tbl) do
--         if i == 'drawables' or i == 'props' or i == 'drawtextures' or i == 'proptextures' then
--             new[i] = v
--         end
--     end
--     print (json.encode(new))
-- end
-- doP()

RegisterNetEvent("printclothes")
AddEventHandler("printclothes", function(clothes)
    local new = {}
    for i,v in pairs (clothes) do
        if i == 'drawables' or i == 'props' or i == 'drawtextures' or i == 'proptextures' then
            new[i] = v
        end
    end
    print (json.encode(new))
end)