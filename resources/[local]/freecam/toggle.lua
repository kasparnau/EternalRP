local Freecam = exports.freecam

-- Toggles the freecam by pressing F5
Citizen.CreateThread(function ()
  while true do
    Citizen.Wait(0)
    if IsDisabledControlJustPressed(0, 166) then
      local isActive = Freecam:IsActive()
      Freecam:SetActive(not isActive)
    end
  end
end)
