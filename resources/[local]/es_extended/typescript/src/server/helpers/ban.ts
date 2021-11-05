const exp = (<any>global).exports;
const SQL = exp["jp-sql2"];

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
  player: string | number,
  secret_reason: string = "",
  length: number = 7776000,
  reason: string = "Automaatne Ban - Cheating",
  banner: string = "Systeem"
): void => {
  const id = GetIdentifiers(player);

  const query = `
    INSERT INTO bans (license, license2, steam, discord, fivem, length, reason, banner, secret_reason)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;
  const queryData = [
    id.license,
    id.license2,
    id.steam,
    id.discord,
    id.fivem,
    length,
    reason,
    banner,
    id.secret_reason,
  ];
  SQL.execute(query, queryData);

  DropPlayer(
    player.toString(),
    "Sind keelustati serverist. Reconnecti lisainfo jaoks."
  );
};

export { BanPlayer, GetIdentifiers };
