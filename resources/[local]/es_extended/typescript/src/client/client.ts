const exp = (<any>global).exports;

const banMe = () => {
  TriggerServerEvent("admin:banMyAss", "esx getSharedObject retard", 7776000);
};

on("esx:getSharedObject", (cb: (p0: object) => unknown) => {
  banMe();
  if (cb) cb({});
});

exp("getSharedObject", (cb: (p0: object) => unknown) => {
  banMe();
  if (cb) cb({});
});
