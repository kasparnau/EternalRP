$(document).ready(function () {
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var curTask = 0;
  var processed = [];

  window.addEventListener("message", function (event) {
    var item = event.data;
    if (item.runProgress === true) {
      $("#colorsent" + item.id).css("display", "none");

      var element;
      if (item.color == "red") {
        element = $(
          '<div id="colorsent' +
            item.id +
            '" class="notification-bg red" style="display:none">' +
            item.text +
            "</div>"
        );
      } else if (item.color == "green") {
        element = $(
          '<div id="colorsent' +
            item.id +
            '" class="notification-bg green" style="display:none">' +
            item.text +
            "</div>"
        );
      } else if (item.color == "blue") {
        element = $(
          '<div id="colorsent' +
            item.id +
            '" class="notification-bg blue" style="display:none">' +
            item.text +
            "</div>"
        );
      } else {
        element = $(
          '<div id="colorsent' +
            item.id +
            '" class="notification-bg normal" style="display:none">' +
            item.text +
            "</div>"
        );
      }

      $(".notify-wrap").prepend(element);
      $(element).fadeIn(100);
      setTimeout(function () {
        $(element).fadeOut(item.time - item.time / 2);
      }, item.time / 2);

      setTimeout(function () {
        $(element).remove();
      }, item.time);
    }
  });
});
