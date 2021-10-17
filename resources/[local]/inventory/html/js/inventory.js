//https://stackoverflow.com/questions/16994662/count-animation-from-number-a-to-b
function animateValue(id, start, end, duration) {
  start = Number(start);
  end = Number(end);
  duration = Number(duration);
  if (start === end) return;
  var range = end - start;
  var current = start;
  var increment = end > start ? 1 : -1;
  var stepTime = Math.abs(Math.floor(duration / range));
  var obj = document.getElementById(id);
  var timer = setInterval(function () {
    current += increment;
    obj.innerHTML =
      "<span class='weight-current'>" + current.toFixed(2) + "</span";
    if (current == end) {
      clearInterval(timer);
    }
  }, stepTime);
}

//https://stackoverflow.com/questions/4399005/implementing-jquerys-shake-effect-with-animate
//Not adding jQuery UI :)
jQuery.fn.shake = function (interval, distance, times) {
  interval = typeof interval == "undefined" ? 100 : interval;
  distance = typeof distance == "undefined" ? 10 : distance;
  times = typeof times == "undefined" ? 3 : times;
  var jTarget = $(this);
  jTarget.css("position", "relative");
  for (var iter = 0; iter < times + 1; iter++) {
    jTarget.animate(
      { left: iter % 2 == 0 ? distance : distance * -1 },
      interval
    );
  }
  return jTarget.animate({ left: 0 }, interval);
};

var type = "normal";
var firstTier = 1;
var firstUsed = 0;
var firstItems = [];
var secondTier = 1;
var secondUsed = 0;
var secondItems = [];
var errorHighlightTimer = null;
var originOwner = false;
var destinationOwner = false;
var locked = false;

var dragging = false;
var origDrag = null;
var draggingItem = null;
var givingItem = null;
var mousedown = false;
var docWidth = document.documentElement.clientWidth;
var docHeight = document.documentElement.clientHeight;
var offset = [76, 81];
var cursorX = docWidth / 2;
var cursorY = docHeight / 2;

var successAudio = document.createElement("audio");
successAudio.controls = false;
successAudio.volume = 0.25;
successAudio.src = "./success.wav";

var failAudio = document.createElement("audio");
failAudio.controls = false;
failAudio.volume = 1.0;
failAudio.src = "./fail.wav";

window.addEventListener("message", function (event) {
  if (event.data.action == "display") {
    type = event.data.type;

    $("#action-bar").html("");

    if (type === "normal") {
      $("#inventoryTwo").parent().hide();
    } else if (type === "secondary") {
      $("#inventoryTwo").parent().show();
    }
    $("#seize").addClass("hidden");
    $("#steal").addClass("hidden");

    $(".ui").fadeIn(10);
  } else if (event.data.action == "hide") {
    $("#dialog").dialog("close");
    $(".ui").fadeOut(10);
  } else if (event.data.action == "setItems") {
    inventorySetup(event.data.invData);
  } else if (event.data.action == "setSecondInventoryItems") {
    secondTier = event.data.invTier;
    destinationOwner = event.data.invOwner;
    secondInventorySetup(event.data.invData);
  } else if (event.data.action == "setInfoText") {
    $(".info-div").html(event.data.text);
  } else if (
    event.data.action == "nearPlayersGive" ||
    event.data.action == "nearPlayersPay"
  ) {
    successAudio.play();
    givingItem = event.data.item;
    $(".near-players-wrapper").find(".popup-body").html("");
    $.each(event.data.players, function (index, player) {
      $(".near-players-list .popup-body").append(
        `<div class="player" data-id="${player.id}" data-action="${event.data.action}">${player.id} - ${player.name}</div>`
      );
    });
    $(".near-players-wrapper").fadeIn();
    EndDragging();
  } else if (event.data.action == "showSeize") {
    $("#seize").removeClass("hidden");
  } else if (event.data.action == "showSteal") {
    $("#steal").removeClass("hidden");
  } else if (event.data.action == "itemUsed") {
    ItemUsed(event.data.alerts);
  } else if (event.data.action == "showActionBar") {
    ActionBar(event.data.items);
  } else if (event.data.action == "actionbarUsed") {
    ActionBarUsed(event.data.index);
  } else if (event.data.action == "unlock") {
    UnlockInventory();
  } else if (event.data.action == "lock") {
    LockInventory();
  }
});

function formatCurrency(x) {
  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function EndDragging() {
  $(origDrag).removeClass("orig-dragging");
  $("#use").removeClass("disabled");
  $("#drop").removeClass("disabled");
  $("#give").removeClass("disabled");
  $(draggingItem).remove();
  origDrag = null;
  draggingItem = null;
  dragging = false;
}

function closeInventory() {
  InventoryLog("closing");
  EndDragging();
  $(".near-players-wrapper").fadeOut(0);
  $.post("https://inventory/NUIFocusOff", JSON.stringify({}));
}

function updateSideWeightBar(side, weight) {
  if (side === "#inventoryOne") {
    let construct = !!$("#playerWeight").html();
    let maxFirstWeight = $("#inventoryOne").data("invMaxWeight");
    if (!construct) {
      $("#wrapPersonalWeight").html(
        "<div class='weightcontainer'><div class='weightbar'>" +
          "<div id='playerWeight' class='weightfill' style='width:" +
          (weight / maxFirstWeight) * 100 +
          "%;'><span class='weight-current' id='playerWeightNum'>" +
          weight.toFixed(2) +
          "</div>"
      );
    } else {
      $("#playerWeight").css("width", (weight / maxFirstWeight) * 100 + "%");
      $("#playerWeightNum").text(weight.toFixed(2));
    }
  }

  if (side === "#inventoryTwo") {
    let construct = !!$("#wrapSecondaryWeight").html();
    let maxSecondWeight = $("#inventoryTwo").data("invMaxWeight");
    if (!construct) {
      $("#wrapSecondaryWeight").html(
        "<div class='weightcontainer'><div class='weightbar'>" +
          "<div id='secondaryWeight' class='weightfill' style='width:" +
          (weight / maxSecondWeight) * 100 +
          "%;'><span class='weight-current' id='secondWeightNum'>" +
          weight.toFixed(2) +
          "</div>"
      );
    } else {
      $("#secondaryWeight").css(
        "width",
        (weight / maxSecondWeight) * 100 + "%"
      );
      $("#secondWeightNum").text(weight.toFixed(2));
    }
  }
}

function calculateSideWeight(invName) {
  let playerWeight = 0;

  var mySlots = $(invName).find(".slot");
  for (let i = 0; i < mySlots.length; i++) {
    var name = $($(invName).find(".slot")[i])
      .find(".item")
      .find(".item-name")
      .text();
    if (name != "" && name != " " && name != null) {
      const itemData = $($($(invName).find(".slot")[i]))
        .find(".item")
        .data("item");
      playerWeight += itemData.qty * itemData.weight;
    }
  }

  updateSideWeightBar(invName, playerWeight);
  return playerWeight;
}

function reCalculateWeight() {
  // var playerUsed = 0;
  // var mySlots = $('#inventoryOne').find('.slot');
  // for (let i=0; i < mySlots.length; i++) {
  //     var name = ($($('#inventoryOne').find('.slot')[i]).find('.item').find('.item-name').text())
  //     if (name != "" && name != " " && name != null) {
  //         const itemData = $($($('#inventoryOne').find('.slot')[i])).find('.item').data('item');
  //         console.log(itemData)
  //         playerUsed += 1
  //     }
  // }

  // $('#player-used').html(playerUsed);

  // var otherUsed = 0;
  // var otherSlots = $('#inventoryTwo').find('.slot');
  // for (let i=0; i < otherSlots.length; i++) {
  //     var name = ($($('#inventoryTwo').find('.slot')[i]).find('.item').find('.item-name').text())
  //     if (name != "" && name != " " && name != null) {
  //         otherUsed += 1
  //     }
  // }
  // $('#other-used').html(otherUsed);

  $("#player-used").html(calculateSideWeight("#inventoryOne"));
  $("#other-used").html(calculateSideWeight("#inventoryTwo"));
}

function inventorySetup(inventory) {
  if (dragging) {
    EndDragging();
  }

  setupPlayerSlots(inventory.invSlots, inventory.maxWeight);
  $("#player-inv-label").html("Mängija");
  $("#player-inv-id").html();
  $("#inventoryOne").data("invOwner", inventory.invType);
  $("#inventoryOne").data("invTier", inventory.id);
  $("#inventoryOne").data("invMaxWeight", inventory.maxWeight);

  //$('#cash').html('<img src="img/cash.png" class="moneyIcon"> $' + formatCurrency(money.cash));
  //$('#bank').html('<img src="img/bank.png" class="moneyIcon"> $' + formatCurrency(money.bank));
  //$('#black_money').html('<img src="img/black_money.png" class="moneyIcon"> $' + formatCurrency(money.black_money));

  firstUsed = 0;
  $.each(inventory.items, function (index, item) {
    var slot = $("#inventoryOne")
      .find(".slot")
      .filter(function () {
        return $(this).data("slot") === item.slot;
      });
    firstUsed++;
    var slotId = $(slot).data("slot");
    firstItems[slotId] = item;
    AddItemToSlot(slot, item);
  });

  $("#player-used").html(calculateSideWeight("#inventoryOne"));
  $("#inventoryOne > .slot:lt(5) .item").append(
    '<div class="item-keybind"></div>'
  );

  $("#inventoryOne .item-keybind").each(function (index) {
    $(this).html(index + 1);
  });
}

function secondInventorySetup(inventory) {
  if (dragging) {
    EndDragging();
  }

  setupSecondarySlots(inventory.invSlots, inventory.maxWeight);
  var invName = "Unknown";

  switch (inventory.invType) {
    case "player":
      invName = "Teine Mängija";
      break;
    case "plyglovebox":
      invName = "Kindalaegas";
      break;
    case "glovebox":
      invName = "Kindalaegas";
      break;
    case "trunk":
      invName = "Pagass";
      break;
    case "plytrunk":
      invName = "Pagass";
      break;
    case "locker":
      invName = "Kapp";
      break;
    case "drop":
      invName = "Maa";
      break;
    case "shop":
      invName = "Pood";
      break;
    case "housestash":
      invName = "Stash";
      break;
    default:
      invName = inventory.invType;
  }

  $("#other-inv-label").html(invName);
  $("#other-inv-id").html();
  $("#inventoryTwo").data("invOwner", inventory.invType);
  $("#inventoryTwo").data("invTier", inventory.id);
  $("#inventoryTwo").data("invMaxWeight", inventory.maxWeight);

  if (inventory.invType === "shop") {
    $("#wrapSecondaryWeight").css("display", "none");
  } else {
    $("#wrapSecondaryWeight").css("display", "block");
  }

  $.each(inventory.items, function (index, item) {
    var slot = $("#inventoryTwo")
      .find(".slot")
      .filter(function () {
        return $(this).data("slot") === item.slot;
      });
    var slotId = $(slot).data("slot");
    secondItems[slotId] = item;
    AddItemToSlot(slot, item);
  });

  $("#other-used").html(calculateSideWeight("#inventoryTwo"));
}

function setupPlayerSlots(slots, maxWeight) {
  $("#inventoryOne").html("");
  $("#player-inv-id").html("");
  $("#inventoryOne").removeData("invOwner");
  $("#inventoryOne").removeData("invTier");
  $("#player-max").html(maxWeight);
  for (i = 1; i <= slots; i++) {
    $("#inventoryOne").append($(".slot-template").clone());
    $("#inventoryOne").find(".slot-template").data("slot", i);
    $("#inventoryOne").find(".slot-template").data("inventory", "inventoryOne");
    $("#inventoryOne").find(".slot-template").removeClass("slot-template");
  }
}

function setupSecondarySlots(slots, maxWeight) {
  $("#inventoryTwo").html("");
  $("#other-inv-id").html("");
  $("#inventoryTwo").removeData("invOwner");
  $("#inventoryTwo").removeData("invTier");
  $("#other-max").html(maxWeight);
  for (i = 1; i <= slots; i++) {
    $("#inventoryTwo").append($(".slot-template").clone());
    $("#inventoryTwo").find(".slot-template").data("slot", i);
    $("#inventoryTwo").find(".slot-template").data("inventory", "inventoryTwo");

    /*
        if (owner.startsWith("drop") || owner.startsWith("container") || owner.startsWith("car") || owner.startsWith("pd-trash")) {
            $('#inventoryTwo').find('.slot-template').addClass('temporary');
        } else if (owner.startsWith("pv") || owner.startsWith("stash")) {
            $('#inventoryTwo').find('.slot-template').addClass('storage');
        } else if (owner.startsWith("steam")) {
            $('#inventoryTwo').find('.slot-template').addClass('player');
        } else if (owner.startsWith("pd-evidence")) {
            $('#inventoryTwo').find('.slot-template').addClass('evidence');
        }
        */
    $("#inventoryTwo").find(".slot-template").removeClass("slot-template");
  }
}

document.addEventListener(
  "mousemove",
  function (event) {
    event.preventDefault();
    cursorX = event.clientX;
    cursorY = event.clientY;
    if (dragging) {
      if (draggingItem !== undefined && draggingItem !== null) {
        draggingItem.css("left", cursorX - offset[0] + "px");
        draggingItem.css("top", cursorY - offset[1] + "px");
      }
    }
  },
  true
);

$("#count").on("keyup blur", function (e) {
  if (e.which == 8 || e.which == undefined || e.which == 0) {
    e.preventDefault();
  }

  if ($(this).val() == "") {
    $(this).val("0");
  } else {
    $(this).val(parseInt($(this).val()));
  }
});

$(document).ready(function () {
  $(document).on("mousedown mouseup", function (e) {
    let slot = e.target.offsetParent;

    const IS_USE_BUTTON =
      e.target.id === "use" ||
      e.target.offsetParent === "use" ||
      e.target.className === "fas fa-hand-holding";
    const IS_SLOT = e.target.offsetParent.className === "slot";

    if (!IS_SLOT && !IS_USE_BUTTON) {
      if (dragging) {
        EndDragging();
        failAudio.play();
      }
      return;
    }

    if (e.type == "mouseup" && !dragging) {
      return;
    }

    if (locked) {
      return;
    }

    itemData = $(slot).find(".item").data("item");
    if (itemData == null && !dragging) {
      return;
    }

    if (dragging) {
      if (IS_USE_BUTTON) {
        // USE
        itemData = $(draggingItem).find(".item").data("item");
        if (!itemData.nonUsable) {
          InventoryLog("Using " + itemData.label);
          $.post(
            "https://inventory/UseItem",
            JSON.stringify({
              owner: $(draggingItem).data("invOwner"),
              slot: $(draggingItem).data("slot"),
              id: $(draggingItem).data("invTier"),
              item: itemData,
            })
          );
          if (itemData.closeUi) {
            closeInventory();
          }
          successAudio.play();
        } else {
          failAudio.play();
        }
        EndDragging();
      } else {
        if (
          ($(slot).data("slot") !== undefined &&
            $(origDrag).data("slot") !== $(slot).data("slot")) ||
          ($(slot).data("slot") !== undefined &&
            $(origDrag).data("invOwner") !== $(slot).parent().data("invOwner"))
        ) {
          if ($(slot).find(".item").data("item") !== undefined) {
            AttemptDropInOccupiedSlot(
              origDrag,
              $(slot),
              parseInt($("#count").val())
            );
          } else {
            AttemptDropInEmptySlot(
              origDrag,
              $(slot),
              parseInt($("#count").val())
            );
          }
        } else {
          successAudio.play();
        }
        reCalculateWeight();
        EndDragging();
      }
    } else {
      if (itemData !== undefined) {
        // Store a reference because JS is retarded
        origDrag = $(slot);
        AddItemToSlot(origDrag, itemData);
        $(origDrag).data("slot", $(slot).data("slot"));
        $(origDrag).data("invOwner", $(slot).parent().data("invOwner"));
        $(origDrag).addClass("orig-dragging");

        // Clone slot shit for dragging
        draggingItem = $(slot).clone();
        AddItemToSlot(draggingItem, itemData);
        $(draggingItem).data("slot", $(slot).data("slot"));
        $(draggingItem).data("invOwner", $(slot).parent().data("invOwner"));
        //console.log($(slot).parent().data('invOwner'));
        $(draggingItem).data("invTier", $(slot).parent().data("invTier"));
        $(draggingItem).addClass("dragging");

        $(draggingItem).css("pointer-events", "none");
        $(draggingItem).css("left", cursorX - offset[0] + "px");
        $(draggingItem).css("top", cursorY - offset[1] + "px");
        $(".ui").append(draggingItem);

        if (itemData.nonUsable) {
          $("#use").addClass("disabled");
        }

        if (!itemData.canRemove) {
          $("#drop").addClass("disabled");
          $("#give").addClass("disabled");
        }
      }
      dragging = true;
    }
  });

  $(".close-ui").click(function (event, ui) {
    closeInventory();
  });

  // $('#use').click(function (event, ui) {
  //     if (dragging) {
  //         itemData = $(draggingItem).find('.item').data("item");
  //         if (!itemData.nonUsable) {
  //             InventoryLog('Using ' + itemData.label);
  //             $.post("https://inventory/UseItem", JSON.stringify({
  //                 owner: $(draggingItem).data('invOwner'),
  //                 slot: $(draggingItem).data('slot'),
  //                 id: $(draggingItem).data('invTier'),
  //                 item: itemData
  //             }));
  //             if (itemData.closeUi) {
  //                 closeInventory();
  //             }
  //             successAudio.play();
  //         } else {
  //             failAudio.play();
  //         }
  //         EndDragging();
  //     }
  // });

  $("#use")
    .mouseenter(function () {
      if (draggingItem != null && !$(this).hasClass("disabled")) {
        $(this).addClass("hover");
      }
    })
    .mouseleave(function () {
      $(this).removeClass("hover");
    });

  $("#inventoryOne, #inventoryTwo").on("mouseenter", ".slot", function () {
    var itemData = $(this).find(".item").data("item");
    if (itemData !== undefined) {
      $(".tooltip-div").find(".tooltip-name").html(itemData.label);

      if (itemData.description !== undefined) {
        $(".tooltip-div").find(".tooltip-desc").html(itemData.description);
      } else {
        $(".tooltip-div").find(".tooltip-desc").html("");
      }

      if (itemData.metadata !== undefined) {
        $.each(itemData.metadata, function (index, item) {
          $(".tooltip-div")
            .find(".tooltip-meta")
            .append(
              '<div class="meta-entry"><div class="meta-key">' +
                index +
                '</div>: <div class="meta-val">' +
                item +
                "</div></div>"
            );
        });
      } else {
        $(".tooltip-div")
          .find(".tooltip-meta")
          .html("This Item Has No Information");
      }

      /*
            if (itemData.staticMeta !== undefined || itemData.staticMeta !== "") {
                if (itemData.type === 1) {
                    $('.tooltip-div').find('.tooltip-meta').append('<div class="meta-entry"><div class="meta-key">Registered Owner</div> : <div class="meta-val">' + itemData.staticMeta.owner + '</div></div>');
                } else if (itemData.itemId === 'license') {
                    $('.tooltip-div').find('.tooltip-meta').append('<div class="meta-entry"><div class="meta-key">Name</div> : <div class="meta-val">' + itemData.staticMeta.name + '</div></div>');
                    $('.tooltip-div').find('.tooltip-meta').append('<div class="meta-entry"><div class="meta-key">Issued On</div> : <div class="meta-val">' + itemData.staticMeta.issuedDate + '</div></div>');
                    $('.tooltip-div').find('.tooltip-meta').append('<div class="meta-entry"><div class="meta-key">Height</div> : <div class="meta-val">' + itemData.staticMeta.height + '</div></div>');
                    $('.tooltip-div').find('.tooltip-meta').append('<div class="meta-entry"><div class="meta-key">Date of Birth</div> : <div class="meta-val">' + itemData.staticMeta.dob + '</div></div>');
                    $('.tooltip-div').find('.tooltip-meta').append('<div class="meta-entry"><div class="meta-key">Phone Number</div> : <div class="meta-val">' + itemData.staticMeta.phone + '</div></div>');
                    $('.tooltip-div').find('.tooltip-meta').append('<div class="meta-entry"><div class="meta-key">Citizen ID</div> : <div class="meta-val">' + itemData.staticMeta.cid + '</div></div>');
                    if (itemData.staticMeta.endorsements !== undefined) {
                        $('.tooltip-div').find('.tooltip-meta').append('<div class="meta-entry"><div class="meta-key">Endorsement</div> : <div class="meta-val">' + itemData.staticMeta.endorsements + '</div></div>');
                    }
                } else if (itemData.itemId === 'gold') {
                    $('.tooltip-div').find('.tooltip-meta').append('<div class="meta-entry"><div class="meta-key"></div> : <div class="meta-val">This Bar Has A Serial Number Engraved Into It Registered To San Andreas Federal Reserve</div></div>');
                }
            } else {
                $('.tooltip-div').find('.tooltip-meta').html("This Item Has No Information");
            }
            */
      $(".tooltip-div").show();
    }
  });

  $("#inventoryOne, #inventoryTwo").on("mouseleave", ".slot", function () {
    $(".tooltip-div").hide();
    $(".tooltip-div").find(".tooltip-name").html("");
    $(".tooltip-div").find(".tooltip-uniqueness").html("");
    $(".tooltip-div").find(".tooltip-meta").html("");
  });

  $("body").on("keyup", function (data) {
    if (data.key == "Escape") {
      closeInventory();
    }
  });
});

$(".popup-body").on("click", ".cashchoice", function () {
  $.post(
    "https://inventory/GetNearPlayers",
    JSON.stringify({
      action: "pay",
      item: $(this).data("id"),
    })
  );
});

function AttemptDropInEmptySlot(origin, destination, moveQty) {
  var result = ErrorCheck(origin, destination, moveQty);
  if (result === -1) {
    $(".slot.error").removeClass("error");
    var item = origin.find(".item").data("item");

    if (item == null) {
      return;
    }

    if (moveQty > item.qty || moveQty === 0) {
      moveQty = item.qty;
    }

    if (moveQty === item.qty) {
      ResetSlotToEmpty(origin);
      item.slot = destination.data("slot");
      AddItemToSlot(destination, item);
      successAudio.play();

      InventoryLog(
        "Moving " +
          item.qty +
          " " +
          item.label +
          " " +
          " from " +
          origin.data("invOwner") +
          " slot " +
          origin.data("slot") +
          " to " +
          destination.parent().data("invOwner") +
          " slot " +
          item.slot
      );
      $.post(
        "https://inventory/MoveToEmpty",
        JSON.stringify({
          originOwner: origin.parent().data("invOwner"),
          originSlot: origin.data("slot"),
          originId: origin.parent().data("invTier"),

          destinationOwner: destination.parent().data("invOwner"),
          destinationSlot: item.slot,
          destinationId: destination.parent().data("invTier"),
        })
      );
    } else {
      $.post(
        "https://inventory/EmptySplitStack",
        JSON.stringify({
          originOwner: origin.parent().data("invOwner"),
          originSlot: origin.data("slot"),
          originId: origin.parent().data("invTier"),

          destinationOwner: destination.parent().data("invOwner"),
          destinationSlot: destination.data("slot"),
          destinationId: destination.parent().data("invTier"),

          moveQty: moveQty,
        })
      );

      var item2 = Object.create(item);
      item2.slot = destination.data("slot");
      item2.qty = moveQty;
      item.qty = item.qty - moveQty;
      AddItemToSlot(origin, item);
      AddItemToSlot(destination, item2);
      successAudio.play();

      InventoryLog(
        "Moving " +
          moveQty +
          " " +
          item.label +
          " from " +
          origin.data("invOwner") +
          " slot " +
          item.slot +
          " to " +
          destination.parent().data("invOwner") +
          " slot " +
          item2.slot
      );
    }
  } else {
    failAudio.play();
    if (result === 1) {
      origin.addClass("error");
      setTimeout(function () {
        origin.removeClass("error");
      }, 1000);
      destination.addClass("error");
      setTimeout(function () {
        destination.removeClass("error");
      }, 1000);
      InventoryLog("Destination Inventory Owner Was Undefined");
    }
  }
}

function AttemptDropInOccupiedSlot(origin, destination, moveQty) {
  var result = ErrorCheck(origin, destination, moveQty);

  var originItem = origin.find(".item").data("item");
  var destinationItem = destination.find(".item").data("item");

  if (originItem == undefined || destinationItem == undefined) {
    return;
  }

  if (result === -1) {
    $(".slot.error").removeClass("error");
    if (
      originItem.itemId === destinationItem.itemId &&
      destinationItem.stackable
    ) {
      if (moveQty > originItem.qty || moveQty === 0) {
        moveQty = originItem.qty;
      }

      if (
        moveQty != originItem.qty &&
        destinationItem.qty + moveQty <= destinationItem.max
      ) {
        originItem.qty -= moveQty;
        destinationItem.qty += moveQty;
        AddItemToSlot(origin, originItem);
        AddItemToSlot(destination, destinationItem);

        successAudio.play();
        InventoryLog(
          "Moving " +
            moveQty +
            " " +
            originItem.label +
            " in " +
            origin.data("invOwner") +
            " slot " +
            originItem.slot +
            " to " +
            destination.parent().data("invOwner") +
            " slot" +
            destinationItem.slot
        );
        $.post(
          "https://inventory/SplitStack",
          JSON.stringify({
            originOwner: origin.parent().data("invOwner"),
            originSlot: originItem.slot,
            originId: origin.parent().data("invTier"),

            destinationOwner: destination.parent().data("invOwner"),
            destinationSlot: destinationItem.slot,
            destinationId: destination.parent().data("invTier"),

            moveQty: moveQty,
          })
        );
      } else {
        if (destinationItem.qty === destinationItem.max) {
          destinationItem.slot = origin.data("slot");
          originItem.slot = destination.data("slot");

          ResetSlotToEmpty(origin);
          AddItemToSlot(origin, destinationItem);
          ResetSlotToEmpty(destination);
          AddItemToSlot(destination, originItem);
          successAudio.play();

          InventoryLog(
            "Swapping " +
              originItem.label +
              " in  " +
              destination.parent().data("invOwner") +
              " slot " +
              originItem.slot +
              " with " +
              destinationItem.label +
              " in " +
              origin.data("invOwner") +
              " slot " +
              destinationItem.slot
          );
          $.post(
            "https://inventory/SwapItems",
            JSON.stringify({
              originOwner: origin.parent().data("invOwner"),
              originSlot: origin.data("slot"),
              originId: origin.parent().data("invTier"),

              destinationOwner: destination.parent().data("invOwner"),
              destinationSlot: destination.data("slot"),
              destinationId: destination.parent().data("invTier"),
            })
          );
        } else if (
          originItem.qty + destinationItem.qty <=
          destinationItem.max
        ) {
          ResetSlotToEmpty(origin);
          destinationItem.qty += originItem.qty;
          AddItemToSlot(destination, destinationItem);

          successAudio.play();
          InventoryLog(
            "Merging stack of " +
              originItem.label +
              " in " +
              origin.data("invOwner") +
              " slot " +
              originItem.slot +
              " to " +
              destination.parent().data("invOwner") +
              " slot " +
              destinationItem.slot
          );
          $.post(
            "https://inventory/CombineStack",
            JSON.stringify({
              originOwner: origin.parent().data("invOwner"),
              originSlot: origin.data("slot"),
              originId: origin.parent().data("invTier"),

              destinationOwner: destination.parent().data("invOwner"),
              destinationSlot: destinationItem.slot,
              destinationId: destination.parent().data("invTier"),

              destinationQty: destinationItem.qty,
            })
          );
        } else if (destinationItem.qty < destinationItem.max) {
          var newOrigQty = destinationItem.max - destinationItem.qty;
          originItem.qty -= newOrigQty;
          AddItemToSlot(origin, originItem);
          destinationItem.qty = destinationItem.max;
          AddItemToSlot(destination, destinationItem);

          successAudio.play();

          InventoryLog(
            "Adding " +
              originItem.label +
              " to existing stack in inventory " +
              destination.parent().data("invOwner") +
              " slot " +
              destinationItem.slot
          );
          $.post(
            "https://inventory/TopoffStack",
            JSON.stringify({
              originOwner: origin.parent().data("invOwner"),
              originSlot: originItem.slot,
              originId: origin.parent().data("invTier"),

              destinationOwner: destination.parent().data("invOwner"),
              destinationSlot: destinationItem.slot,
              destinationId: destination.parent().data("invTier"),

              originItem: origin.find(".item").data("item"),
              destinationItem: destination.find(".item").data("item"),
            })
          );
        } else {
          DisplayMoveError(origin, destination, "Stack At Max Items");
        }
      }
    } else {
      let destInv = destination.parent().data("invOwner");
      let origInv = origin.data("invOwner");
      if (destInv === "shop" || origInv === "shop") {
        failAudio.play();
        return;
      }

      destinationItem.slot = origin.data("slot");
      originItem.slot = destination.data("slot");

      ResetSlotToEmpty(origin);
      AddItemToSlot(origin, destinationItem);
      ResetSlotToEmpty(destination);
      AddItemToSlot(destination, originItem);
      successAudio.play();

      InventoryLog(
        "Swapping " +
          originItem.label +
          " in " +
          destination.parent().data("invOwner") +
          " slot " +
          originItem.slot +
          " with " +
          destinationItem.label +
          " in " +
          origin.data("invOwner") +
          " slot " +
          destinationItem.slot
      );
      //InventoryLog("SwapItems2 : Origin: " + origin.data('invOwner') + " Origin Slot: " + origin.data('slot') + " Destination: " + destination.parent().data('invOwner') + " Destination Slot: " + destination.data('slot'));
      $.post(
        "https://inventory/SwapItems",
        JSON.stringify({
          originOwner: origin.parent().data("invOwner"),
          originSlot: origin.data("slot"),
          originId: origin.parent().data("invTier"),

          destinationOwner: destination.parent().data("invOwner"),
          destinationSlot: destination.data("slot"),
          destinationId: destination.parent().data("invTier"),
        })
      );
    }

    let originInv = origin.parent().data("invOwner");
    let destInv = destination.parent().data("invOwner");
  } else {
    failAudio.play();

    if (result === 1) {
      origin.addClass("error");
      setTimeout(function () {
        origin.removeClass("error");
      }, 1000);
      destination.addClass("error");
      setTimeout(function () {
        destination.removeClass("error");
      }, 1000);
      InventoryLog("Destination Inventory Owner Was Undefined");
    }
  }
}

function ErrorCheck(origin, destination, moveQty) {
  var originOwner = origin.parent().data("invOwner");
  var destinationOwner = destination.parent().data("invOwner");
  var item = origin.find(".item").data("item");
  if (moveQty > item.qty) {
    moveQty = item.qty;
  }

  if (destinationOwner === undefined) {
    return 1;
  }

  var sameInventory = originOwner === destinationOwner;
  var status = -1;

  let shakeTarget = 0;
  if (originOwner === "player") {
    shakeTarget = 1;
  } else {
    shakeTarget = 0;
  }

  if (sameInventory) {
    if (originOwner === "shop") {
      status = 0;
    }
  } else if (destinationOwner === "shop") {
    status = 0;
  } else if (
    originOwner === $("#inventoryOne").data("invOwner") &&
    destinationOwner === $("#inventoryTwo").data("invOwner")
  ) {
    const secondaryWeight = calculateSideWeight("#inventoryTwo");
    const newWeight = secondaryWeight + item.weight * (moveQty || item.qty);
    const invMaxWeight = $("#inventoryTwo").data("invMaxWeight");

    if (newWeight > invMaxWeight) {
      status = 0;

      $(".weightcontainer").eq(shakeTarget).shake();
    }
  } else {
    const primaryWeight = calculateSideWeight("#inventoryOne");
    const newWeight = primaryWeight + item.weight * (moveQty || item.qty);
    const invMaxWeight = $("#inventoryOne").data("invMaxWeight");

    if (newWeight > invMaxWeight) {
      status = 0;

      $(".weightcontainer").eq(shakeTarget).shake();
    }
  }

  return status;
}

function ResetSlotToEmpty(slot) {
  slot.find(".item").addClass("empty-item");
  slot.find(".item").css("background-image", "none");
  slot.find(".item-count").html(" ");
  slot.find(".item-name").html(" ");
  slot.find(".item-price").html(" ");
  slot.find(".item").removeData("item");
}

function AddItemToSlot(slot, data) {
  slot.find(".empty-item").removeClass("empty-item");
  slot
    .find(".item")
    .css("background-image", "url('img/items/" + data.itemId + ".png')");
  slot.find(".item").css("background-size", "contain");
  slot.find(".item-count").html(`${data.qty} (${data.weight.toFixed(2)})`);
  slot.find(".item-name").html(data.label.toUpperCase());
  if (data.price !== undefined && data.price !== 0) {
    slot.find(".item-price").html("$" + data.price);
    slot.find(".item-count").html(" ");
  }
  slot.find(".item").data("item", data);
}

function ClearLog() {
  $(".inv-log").html("");
}

function InventoryLog(log) {
  $(".inv-log").html(log + "<br>" + $(".inv-log").html());
}

function DisplayMoveError(origin, destination, error) {
  failAudio.play();
  origin.addClass("error");
  destination.addClass("error");
  if (errorHighlightTimer != null) {
    clearTimeout(errorHighlightTimer);
  }
  errorHighlightTimer = setTimeout(function () {
    origin.removeClass("error");
    destination.removeClass("error");
  }, 1000);

  InventoryLog(error);
}

$(".exit-popup").on("click", function () {
  givingItem = null;
  $(".near-players-wrapper")
    .fadeOut("normal")
    .promise()
    .then(function () {
      $(this).find(".popup-body").html("");
    });
});

$(".popup-body").on("click", ".player", function () {
  let target = $(this).data("id");
  let action = $(this).data("action");
  let count = parseInt($("#count").val());
  if (action === "nearPlayersGive") {
    if (givingItem != null) {
      if (count === 0 || count > givingItem.qty) {
        count = givingItem.qty;
      }
      InventoryLog(
        `Giving ${count} ${givingItem.label} To Nearby Player With Server ID ${target}`
      );
      $.post(
        "https://inventory/GiveItem",
        JSON.stringify({
          target: target,
          item: givingItem,
          count: count,
        }),
        function (status) {
          if (status) {
            $(".near-players-wrapper").fadeOut();

            if (count == givingItem.qty) {
              ResetSlotToEmpty(givingItem.slot);
            }

            givingItem = null;
          }
        }
      );
    }
  } else if (action === "nearPlayersPay") {
    InventoryLog(
      `Giving ${count} ${givingItem} To Nearby Player With Server ID ${target}`
    );
    $.post(
      "https://inventory/GiveCash",
      JSON.stringify({
        target: target,
        item: givingItem,
        count: count,
      }),
      function (status) {
        if (status) {
          $(".near-players-wrapper").fadeOut();
        }
      }
    );
  }
});

var alertTimer = null;

function ItemUsed(alerts) {
  clearTimeout(alertTimer);
  $("#use-alert").hide("slide", { direction: "left" }, 100, function () {
    $("#use-alert .slot").remove();

    $.each(alerts, function (index, data) {
      $("#use-alert")
        .append(
          `<div class="slot alert-${index}""><div class="item"><div class="item-count">${data.qty}</div><div class="item-name">${data.item.label}</div></div><div class="alert-text">${data.message}</div></div>`
        )
        .ready(function () {
          $(`.alert-${index}`)
            .find(".item")
            .css(
              "background-image",
              "url('img/items/" + data.item.itemId + ".png')"
            );
          if (data.item.slot <= 5) {
            $(`.alert-${index}`)
              .find(".item")
              .append(`<div class="item-keybind">${data.item.slot}</div>`);
          }
        });
    });
  });

  $("#use-alert").show("slide", { direction: "left" }, 100, function () {
    alertTimer = setTimeout(function () {
      $("#use-alert .slot").addClass("expired");
      $("#use-alert").hide("slide", { direction: "left" }, 100, function () {
        $("#use-alert .slot.expired").remove();
      });
    }, 2500);
  });
}

var actionBarTimer = null;

function ActionBar(items, timer) {
  clearTimeout(actionBarTimer);

  $("#action-bar").html("");

  for (let i = 1; i < 6; i++) {
    var found = false;
    $.each(items, function (index, item) {
      if (item.slot == i) {
        $("#action-bar").append(
          `<div class="slot slot-${item.slot}"><div class="item"><div class="item-count">${item.qty}</div><div class="item-name">${item.label}</div><div class="item-keybind">${item.slot}</div></div></div>`
        );
        $(`.slot-${item.slot}`)
          .find(".item")
          .css("background-image", "url('img/items/" + item.itemId + ".png')");
        found = true;
      }
    });
    if (!found) {
      $("#action-bar").append(
        `<div class="slot slot-${i}" data-empty="true"><div class="item"><div class="item-count"></div><div class="item-name"></div><div class="item-keybind">${i}</div></div></div>`
      );
      $(`.slot-${i}`).find(".item").css("background-image", "none");
    }
  }

  $("#action-bar").show();
  actionBarTimer = setTimeout(
    function () {
      $("#action-bar .slot").addClass("expired");
      $("#action-bar").hide("slide", { direction: "down" }, 0, function () {
        $("#action-bar .slot.expired").remove();
      });
    },
    timer == null ? 2500 : timer
  );
}

var usedActionTimer = null;

function ActionBarUsed(index) {
  clearTimeout(usedActionTimer);

  if ($("#action-bar .slot").is(":visible")) {
    if ($(`.slot-${index - 1}`).data("empty") != null) {
      $(`.slot-${index - 1}`).addClass("empty-used");
    } else {
      $(`.slot-${index - 1}`).addClass("used");
    }
    usedActionTimer = setTimeout(function () {
      $(`.slot-${index - 1}`).removeClass("used");
      $(`.slot-${index - 1}`).removeClass("empty-used");
    }, 1000);
  }
}

function LockInventory() {
  locked = true;
  $("#inventoryOne").addClass("disabled");
  $("#inventoryTwo").addClass("disabled");
}

function UnlockInventory() {
  locked = false;
  $("#inventoryOne").removeClass("disabled");
  $("#inventoryTwo").removeClass("disabled");
}
