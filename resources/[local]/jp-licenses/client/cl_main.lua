local char = exports['players']:GetClientVar('character')
myLicenses = char and char.licenses

AddEventHandler("players:CharacterVarChanged", function(name, old, new)
    if name == 'licenses' then
        myLicenses = new
        TriggerEvent("licenses:updated", new)
    end
end)