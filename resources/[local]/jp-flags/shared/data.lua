Flags = {}

Flags["VehicleFlags"] = {
    isPlayerVehicle = 2,
    isRentalVehicle = 4,
    fakePlate = 8,
}

local curPedFlag = 1
local function prevPedFlag()
  curPedFlag = curPedFlag * 2
  return curPedFlag / 2
end
Flags["PedFlags"] = {
    isNPC = prevPedFlag(),
    isShopKeeper = prevPedFlag(), --/// GROCERY SHOP KEEPER
    isToolShopNPC = prevPedFlag(),
    isWeaponShopNPC = prevPedFlag(),
    --//PLAYER STUFF
    isSittingOnChair = prevPedFlag(),
}


Flags["ObjectFlags"] = {}
