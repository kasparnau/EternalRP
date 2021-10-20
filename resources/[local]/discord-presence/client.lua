Citizen.CreateThread(function()
	while true do
        SetDiscordAppId(897880577921941504)
		SetDiscordRichPresenceAsset('eternal_logo')
        SetDiscordRichPresenceAssetText('Eternal RP')
        SetDiscordRichPresenceAssetSmall('eternal_logo')
        SetDiscordRichPresenceAssetSmallText('EternalRP')
        SetRichPresence("Mängijaid: " ..#GetActivePlayers().. "/48")
        SetDiscordRichPresenceAction(0, "Koduleht", "https://eternalrp.me/")
        SetDiscordRichPresenceAction(1, "Discord", "https://discord.io/eternalinvite")

		Citizen.Wait(5000)
	end
end)