let Functions = {};
let RPC = {};

RPC.register = (name, func) => {
  Functions[name] = func;
};

RPC.remove = (name) => {
  Functions[name] = undefined;
};

const ParamPacker = (params) => {
  let pack = {};
  for (let i = 0; i < 15; i++) {
    pack[i] = { param: params[i] };
  }
  return pack;
};

const ParamUnpacker = (params, index) => {
  let idx = index || 0;
  if (idx <= params.length) {
    return [params[idx]["param"], ParamUnpacker(params, idx + 1)];
  }
};

const UnPacker = (params, index) => {
  let idx = index || 0;
  if (idx <= 15) {
    return [params[idx], UnPacker(params, idx + 1)];
  }
};

RegisterNetEvent("rpc:request");
onNet("rpc:request", (resource, name, callID, params) => {
  let response;
  if (Functions[name] === undefined) return;

  try {
    response = ParamPacker(Functions[name](source, ParamUnpacker(params)));
  } catch {
    console.log("Error: " + error);
    return;
  }

  if (response === undefined) {
    response = {};
  }

  emitNet("rpc:response", resource, source, callID, response);
});
