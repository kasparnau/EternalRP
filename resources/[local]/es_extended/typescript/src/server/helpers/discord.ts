import fetch from "node-fetch";
import { GetIdentifiers } from "#server/helpers/ban";

const webhookURL =
  "https://discord.com/api/webhooks/903770470774628425/oM7ghMi0p0vocygXbHbayKu-PWUEsq8M2Zi4X6MOQ2a9kzwmeGukPbfNQa-0y7mq7LB2";

const DoDiscordLog = (
  player: string | number,
  title: string,
  message: string
): void => {
  const identifiers = GetIdentifiers(player);

  let descIdStr = `\n`;
  Object.keys(identifiers).map((key: string, index: number): void => {
    const val: string = identifiers[key];
    descIdStr += `**${key}:** ${val} \n`;
  });

  const embeds = [
    {
      color: 16711680,
      title: `**noob alert: ** [${GetPlayerName(
        player.toString()
      )}] (${title})`,
      description: `${message} ${descIdStr}`,
    },
  ];

  fetch(webhookURL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      username: "istoprocent",
      embeds,
    }),
  });
};

export { DoDiscordLog };

// method: 'post',
// headers: {
//   'Content-Type': 'application/json',
// },
