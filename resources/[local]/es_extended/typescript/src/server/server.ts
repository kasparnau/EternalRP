const exp = (<any>global).exports;

import {
  IsLegalModel,
  GetEntityOwner,
  GetModelNameFromHash,
} from "#server/utils/models";

import { BanPlayer } from "#server/helpers/ban";
import { DoDiscordLog } from "#server/helpers/discord";

onNet("ac:banMe", (reason: string, length: number = 7776000) => {
  DoDiscordLog(source, reason, "prolly 100% hacker, BANNED");
  BanPlayer(source, reason, length);
});

AddEventHandler("entityCreating", (entity: number): void => {
  const owner = GetEntityOwner(entity);
  const legal = IsLegalModel(entity);

  if (!legal) {
    // TYPE: OBJECT
    if (owner && GetEntityType(entity) === 3) {
      DoDiscordLog(
        owner,
        `YRITAS SPAWNIDA KEELATUD OBJECTI: ${GetModelNameFromHash(
          GetEntityModel(entity)
        )}`,
        "vb hacker, BANNED. pole 100% hacker niiet kui viriseb saab unbannida olenevalt et mis object oli"
      );
      BanPlayer(
        owner,
        `SPAWN ILLEGAL OBJECT: ${GetModelNameFromHash(GetEntityModel(entity))}`
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
