const exp = (<any>global).exports;

const BanMe = () => {
  emitNet("ac:banMe", "esx:getSharedObject retard");
};

on("esx:getSharedObject", (cb: (p0: object) => unknown) => {
  BanMe();
  if (cb) cb({});
});

exp("getSharedObject", (cb: (p0: object) => unknown) => {
  BanMe();
  if (cb) cb({});
});
