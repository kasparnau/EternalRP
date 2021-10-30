interface PlayerIdentifiers {
  license: string;
  license2: string;
  steam: string;
  discord: string;
  fivem: string;
  ip: string;
  [key: string]: string;
}

const GetIdentifiers = (player: string | number): PlayerIdentifiers => {
  const pIdentifiers = getPlayerIdentifiers(player);

  const GetIdentifier = (identifier: string): string => {
    return pIdentifiers.filter((e) => e.startsWith(identifier))[0] || "";
  };

  const identifiers = {
    license: GetIdentifier("license"),
    license2: GetIdentifier("license2"),
    steam: GetIdentifier("steam"),
    discord: GetIdentifier("discord"),
    fivem: GetIdentifier("fivem"),
    ip: GetIdentifier("ip"),
  };

  return identifiers;
};

const BanPlayer = (
  player: string,
  length: number = 7776000,
  secret_reason: string = "anti-cheat",
  reason: string = "Automaatne Ban - Cheating",
  banner: string = "Systeem"
): void => {
  const identifiers = GetIdentifiers(player);

  // //@ts-ignore
  // exp.admin.banPlayer(player, reason, banner, length, secret_reason);
};

export { BanPlayer, GetIdentifiers };
