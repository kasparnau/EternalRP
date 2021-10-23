let Functions = {};
let RPC = {};

RPC.register = (name, func) => {
  Functions[name] = func;
};

RPC.remove = (name) => {
  Functions[name] = undefined;
};

const Packer = (params) => {
  let pack = [];
  for (let i = 0; i < 15; i++) {
    pack[i] = { param: params[i] };
  }
  return pack;
};

const UnPacker = (params) => {
  let shit = [];
  for (let i = 0; i < params.length; i++) {
    shit.push(params[i].param);
  }
  return shit;
};

RegisterNetEvent("rpc:request");
onNet("rpc:request", (resource, name, callID, params) => {
  let response;
  if (Functions[name] === undefined) return;
  try {
    response = Packer(Functions[name](source, UnPacker(params)));
  } catch {
    console.log("Error: " + error);
    return;
  }
  if (response === undefined) {
    response = {};
  }
  console.log("returning response: " + JSON.stringify(response));
  emitNet("rpc:response", source, resource, callID, response);
});

RPC.register("yess", () => {
  return ["yeah", undefined, "xdxdds"];
});
