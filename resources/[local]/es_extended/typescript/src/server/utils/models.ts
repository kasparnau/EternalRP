import blacklistedModels from "#shared/data/blacklisted_models";

const blacklistedModelsHashes: number[] = [];

for (let i = 0; i < blacklistedModels.length; i++) {
  const currModel = blacklistedModels[i];
  const currHash =
    typeof currModel === "string" ? GetHashKey(currModel) : currModel;
  blacklistedModelsHashes.push(currHash);
}

const IsLegalModel = (entity: number): boolean => {
  const model = GetEntityModel(entity);

  if (model !== null) {
    return !blacklistedModelsHashes.includes(model);
  }

  return true;
};

const GetModelNameFromHash = (hash: number): string => {
  if (blacklistedModelsHashes.includes(hash)) {
    for (let i = 0; i < blacklistedModels.length; i++) {
      if (GetHashKey(blacklistedModels[i]) === hash) {
        return blacklistedModels[i];
      }
    }
  }
  return ``;
};

const GetEntityOwner = (entity: number): number | null => {
  if (!DoesEntityExist(entity)) return null;

  const owner = NetworkGetEntityOwner(entity);
  return owner;
};

export { IsLegalModel, GetEntityOwner, GetModelNameFromHash };
