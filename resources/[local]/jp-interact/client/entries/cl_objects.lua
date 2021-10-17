-- HEISTS

AddPeekEntryByModel({ 303280717 }, {
    options = {
        {
            event = "jp-heists:shops:breakInToRegister",
            icon = "fas fa-hammer",
            label = "Röövi!",
        },
    },
    distance = 1,
    isEnabled = function(pEntity)
        return GetObjectFragmentDamageHealth(pEntity, true) < 1.0
    end
})

-- JOBS
AddPeekEntryByFlag({ 'isTrash' }, {
    options = {
        {
            event = "garbagejob:pickupTrash",
            icon = "fas fa-trash",
            label = "Korja prügi",
        },
    },
    distance = 1.7,
    isEnabled = function(pEntity, pContext, pParams)
        return exports['players']:GetClientVar("character").job == 'Sanitation'
    end
})

local payphoneModels = {
    `p_phonebox_02_s`,
    `prop_phonebox_03`,
    `prop_phonebox_02`,
    `prop_phonebox_04`,
    `prop_phonebox_01c`,
    `prop_phonebox_01a`,
    `prop_phonebox_01b`,
    `p_phonebox_01b_s`,
}
AddPeekEntryByModel(payphoneModels, {
    options = {
        {
            event = "phone-makecall",
            icon = "fas fa-phone-volume",
            label = "Helista",
        },
    },
    distance = 1.5,
    isEnabled = function()
        return true
    end
})

AddPeekEntryByFlag({ 'isATM' }, {
    options = {
        {
            event = "bank:useATM",
            icon = "fas fa-money-check-alt",
            label = "Kasuta sularahaautomaati",
        },
    },
    distance = 1.5,
    isEnabled = function(pEntity, pContext, pParams)
        return exports['bank']:IsNearATM()
    end
})

AddPeekEntryByFlag({ 'isChair' }, {
    options = {
        {
            event = "jp-emotes:sitOnChair",
            icon = "fas fa-chair",
            label = "Istu",
        },
    },
    distance = 1.5
})

AddPeekEntryByFlag({ 'isVendingMachineFood' }, {
    options = {
        {
            event = "jp-shops:openShop",
            icon = "fas fa-hamburger",
            label = "Ava Müügiautomaat",
        },
    },
    params = {12},
    distance = 1.5
})

AddPeekEntryByFlag({ 'isVendingMachineBeverage' }, {
    options = {
        {
            event = "jp-shops:openShop",
            icon = "fas fa-water",
            label = "Ava Müügiautomaat",
        },
    },
    params = {11},
    distance = 1.5
})