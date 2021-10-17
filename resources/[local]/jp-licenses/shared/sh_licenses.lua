LicenseIdToNameMap = {
    [1] = "Juhiluba",
    [2] = "Relvaluba",
    [3] = "Lennuluba"
}

LicenseNameToIdMap = {}

for i,v in pairs (LicenseIdToNameMap) do
    LicenseNameToIdMap[v] = i
end

function GetLicenseId(name)
    return LicenseNameToIdMap[name] or nil
end

function GetLicenseName(id)
    return LicenseIdToNameMap[id] or nil
end

exports('GetLicenseName', GetLicenseName)
exports('GetLicenseId', GetLicenseId)
