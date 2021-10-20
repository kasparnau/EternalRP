let enabled = false;

const phones = exports.inventory.getPhones();

const showUi = () => {
  const character = exports.players.getCharacter();
  if (!character) return;

  enabled = true;
  SetNuiFocus(true, true);

  SendNUIMessage({
    show: true,
    character: character,
    hasPhone: true,
  });

  if (!inCall) {
    console.log("textanim");
  }
};

const hideUi = () => {
  enabled = false;
  SetNuiFocus(true, true);
  SendNUIMessage({
    show: false,
  });
  if (!inCall) {
    console.log("playout anim");
  }
};

exports("toggle", () => {
  if (enabled) {
    hideUi();
  } else {
    if (!exports.players.getCharacter()) return;
    showUi();
  }
});

const enableCircleNoti = (app) => {
  SendNUIMessage({
    addNotiCircle: app,
  });
};

RegisterNetEvent("jp-phone:enableCircleNoti");
AddEventHandler("jp-phone:enableCircleNoti", (app) => {
  enableCircleNoti(app);
});

RegisterNetEvent("jp-phone:enableCircleNoti");
AddEventHandler("jp-phone:enableCircleNoti", (title, desc, time, icon) => {
  const noti = addNoti(title, desc, null, icon);
  if (time) {
    setTimeout(() => {
      removeNoti(noti);
    }, time);
  }
});

// ICONS:
// 	1: RED ALERT
// 	2: CALL
// 	3: TWITTER

let newNotiId = 0;

RegisterNuiCallbackType("nuiAction");
on("__cfx_nui:nuiAction", async (data, cb) => {
  const content = data.data;
  const action = data.action;

  console.log(`NUI: ${JSON.stringify(data)}`);

  if (action == "closeNui") {
    hideUi();
  } else if (action == "fetchContactsPage") {
    console.log("here");

    const contacts = await RPC.execute("getContacts");
    console.log("contacts: " + JSON.stringify(contacts));
    let page = {
      contacts: contacts,
    };
    cb(page);
  } else if (action == "addContact") {
  }
});
