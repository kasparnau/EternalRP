const exp = (<any>global).exports;

import {
  IsLegalModel,
  GetEntityOwner,
  GetModelNameFromHash,
} from "#server/utils/models";
import { BanPlayer } from "#server/helpers/ban";
import { DoDiscordLog } from "#server/helpers/discord";

AddEventHandler("entityCreating", (entity: number): void => {
  const owner = GetEntityOwner(entity);
  const legal = IsLegalModel(entity);
  if (!legal) {
    if (owner) {
      DoDiscordLog(
        owner,
        `wow spawnis midagi illegaalset: ${GetModelNameFromHash(
          GetEntityModel(entity)
        )}`,
        "oi oi banned"
      );
    }
    CancelEvent();
  }
});

// RegisterCommand(
//   "tokens",
//   (source: string) => {
//     const numTokens = GetNumPlayerTokens(source);
//     let tokens = [];
//     for (let i = 0; i < numTokens; i++) {
//       tokens.push(GetPlayerToken(source, i));
//     }
//     console.log(JSON.stringify(tokens));
//   },
//   false
// );
