let Promises = {};
let CallIdentifier = 0;
const Resource = GetCurrentResourceName();

let RPC = {};

const ClearPromise = (callID) => {
  setTimeout(() => {
    Promises[callID] = undefined;
  }, 5000);
};

const Packer = (...params) => {
  let pack = {};
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

RPC.execute = async (name, ...args) => {
  let callID = CallIdentifier;
  let solved = false;
  CallIdentifier = CallIdentifier + 1;

  let resolve, reject;
  let prom = new Promise((pResolve, pReject) => {
    (resolve = pResolve), (reject = pReject);
  });
  Promises[callID] = { prom: prom, resolve: resolve, reject: reject };

  TriggerServerEvent("rpc:request", Resource, name, callID, Packer(args));
  setTimeout(() => {
    if (!solved) {
      Promises[callID].resolve({ nil });
      TriggerServerEvent("rpc:server:timeout", name);
    }
  }, 20000);
  let response = await Promises[callID].prom;
  console.log(`here: ${JSON.stringify(response)}`);
  solved = true;

  ClearPromise(callID);

  console.log(JSON.stringify(UnPacker(response)));
  return UnPacker(response);
};

RegisterNetEvent("rpc:response");
onNet("rpc:response", (origin, callID, ...args) => {
  if (Resource === origin && Promises[callID]) {
    Promises[callID].resolve(...args);
  }
});
