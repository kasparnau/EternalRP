AddPeekEntryByEntityType({2}, {
    options = {
        {
            event = "general:flipVehicle",
            icon = "fas fa-car-crash",
            label = "Flip Sõidukit",
        },
    },
    distance = 3.0,
    isEnabled = function(pEntity, pContext, pParams)
        return not IsVehicleOnAllWheels(pEntity)
    end
})

AddPeekEntryByEntityType({2}, {
    options = {
        {
            event = "vehicle:getInTrunk",
            icon = "fas fa-user-secret",
            label = "Roni Pagassi",
        },
    },
    distance = 1.8,
    isEnabled = function(pEntity, pContext, pParams)
        local lock = GetVehicleDoorLockStatus(pEntity)
        local doorValid = DoesVehicleHaveDoor(pEntity, 5)
        return doorValid and (lock == 4 or lock == 1 or lock == 0) and isCloseToBoot(pEntity, PlayerPedId(), 2.0, pContext.model) 
        and not exports['hideintrunk']:disabledCarCheck(pEntity) and isVehicleDoorOpen(pEntity, 5)
        -- return isCloseToBoot(pEntity, PlayerPedId(), 1.8, pContext.model) 
        -- and not exports['hideintrunk']:disabledCarCheck(pEntity)
        -- and GetVehicleDoorLockStatus(pEntity) ~= 2
    end
})

AddPeekEntryByEntityType({2}, {
    options = {
        {
            event = "vehicle:examineVehicle",
            icon = "fas fa-wrench",
            label = "Uuri sõidukit",
        },
    },
    distance = 5.0,
    isEnabled = function(pEntity, pContext, pParams)
        return isCloseToEngine(pEntity, PlayerPedId(), 1.8, pContext.model)
    end
})

AddPeekEntryByEntityType({2}, {
    options = {
        {
            event = "vehicle:addFakePlate",
            icon = "fas fa-screwdriver",
            label = "Pane võlts numbrimärk",
        },
    },
    distance = 1.8,
    isEnabled = function(pEntity, pContext, pParams)
        return (isCloseToHood(pEntity, PlayerPedId(), 2.0) or isCloseToBoot(pEntity, PlayerPedId(), 2.0, pContext.model)) and not IsPedInAnyVehicle(PlayerPedId(), false)
        and exports["keys"]:hasKeys(pEntity) and exports["inventory"]:hasEnoughOfItem("fake-plate", 1)
        and not exports["jp-flags"]:HasVehicleFlag(pEntity, 'fakePlate')
    end
})