local function ToInteger(number)
    return math.floor(tonumber(number) + 0.5 or error("Could not cast '" .. tostring(number) .. "' to number.'"))
end

RegisterServerEvent('fuel:pay')
AddEventHandler('fuel:pay', function(price)
	price = ToInteger(price)
	if price < 0 then
		exports['admin']:banPlayerFromSource(source, "Automaatne Ban - (Cheating)", "System", 2628288, ("Tried to buy fuel for "..price))
		return
	end
	price = math.floor(price + 0.5)
	exports['inventory']:removeItem(source, "cash", price)
end)