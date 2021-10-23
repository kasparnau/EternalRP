/// <reference path="../../node_modules/fivem-js/lib/index.d.ts"/>
/// <reference path="../../node_modules/@citizenfx/client/natives_universal.d.ts"/>

const SQL = exports["jp-sql2"];

interface VehicleInfo {
  ownerId: number;
}

export const AddPlayerVehicle = async (
  pCharId: number,
  pVehicleInfo: VehicleInfo
): Promise<boolean> => {
  let result = await SQL.executeSync("SELECT * FROM VEHICLES");
  return result;
};

RegisterCommand(
  "xd",
  async (source: number, args: string[]) => {
    console.log(JSON.stringify(await AddPlayerVehicle(1, { ownerId: 1 })));
  },
  false
);
