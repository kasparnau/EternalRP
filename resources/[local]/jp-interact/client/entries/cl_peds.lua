AddPeekEntryByFlag({ 'isShopKeeper' }, {
    options = {
        {
            event = "jp-shops:openShop",
            icon = "fas fa-shopping-basket",
            label = "Ava Pood",
        },
    },
    params = { 10 },
    distance = 2.5
})

AddPeekEntryByFlag({ 'isToolShopNPC' }, {
    options = {
        {
            event = "jp-shops:openShop",
            icon = "fas fa-toolbox",
            label = "Osta Tööriistu",
        },
    },
    params = { 13 },
    distance = 2.5
})

AddPeekEntryByFlag({ 'isWeaponShopNPC' }, {
    options = {
        {
            event = "jp-shops:openShop",
            icon = "fas fa-shopping-basket",
            label = "Osta Relvi",
        },
    },
    params = { 2 },
    distance = 2.5
})

AddPeekEntryByFlag({ 'isNPC' }, {
    options = {
        {
            event = "jp-rentals:browse",
            icon = "fas fa-car",
            label = "Vaata Rendikaid",
        },
    },
    distance = 2.5,
    isEnabled = function(pEntity, pContext, pParams)
        return GetEntityContext(pEntity).npcId == `rental_npc` 
    end
})

AddPeekEntryByFlag({ 'isNPC' }, {
    options = {
        {
            event = "jp-garages:browseImpound",
            icon = "fas fa-car",
            label = "Vaata Impoundi",
        },
    },
    distance = 2.5,
    isEnabled = function(pEntity, pContext, pParams)
        return GetEntityContext(pEntity).npcId == `impound_npc` 
    end
})

AddPeekEntryByFlag({ 'isNPC' }, {
    options = {
        {
            event = "npcjobs:openMenu",
            icon = "fa-solid fa-briefcase-blank",
            label = "Vaata Töökohti",
        },
    },
    distance = 2.5,
    isEnabled = function(pEntity, pContext, pParams)
        return GetEntityContext(pEntity).npcId == `job_center` 
    end
})