let Promises = {};
let CallIdentifier = 0;
const Resource = GetCurrentResourceName();

let RPC = {};

const ClearPromise = (callID) => {
  setTimeout(() => {
    Promises[callID] = undefined;
  }, 5000);
};

const ParamPacker = (...params) => {
  let pack = {};
  for (let i = 1; i < 15; i++) {
    pack[i] = { param: params[i] };
  }
  return pack;
};

const ParamUnpacker = (params, index) => {
  let idx = index || 0;
  if (idx <= params.length) {
    console.log(JSON.stringify(params) + " |||| ");
    console.log(`2: ${JSON.stringify(params[idx])}`);
    return [params[idx]["param"], ParamUnpacker(params, idx + 1)];
  }
};

const UnPacker = (params, index) => {
  let idx = index || 0;
  if (idx <= 15) {
    return [params[idx], UnPacker(params, idx + 1)];
  }
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

  TriggerServerEvent("rpc:request", Resource, name, callID, ParamPacker(args));
  setTimeout(() => {
    if (!solved) {
      Promises[callID].resolve({ nil });
      TriggerServerEvent("rpc:server:timeout", name);
    }
  }, 20000);
  let response = await Promises[callID].prom;

  solved = true;

  ClearPromise(callID);

  console.log(JSON.stringify(ParamUnpacker(response)));

  return ParamUnpacker(response);
};

RegisterNetEvent("rpc:response");
onNet("rpc:response", (origin, callID, ...args) => {
  if (Resource === origin && Promises[callID]) {
    Promises[callID].resolve(...args);
  }
});
