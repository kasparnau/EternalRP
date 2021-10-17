var speedstring = ('0<span class="smallertext">KPH</span>');
var beltstring = ('<span class="red">BELT</span>');
var fuelstring = ('0<span class="smallertext">FUEL</span>');

$(function(){
	window.onload = (e) => {
		window.addEventListener('message', (event) => {
			var item = event.data;
			if (item.display) {
				if (item.display === "true") {
                    $("#container").fadeIn();
                }
				if (item.display === "false") {
                    $("#container").fadeOut();
                }
            }
            if (item.speed) {
                speedstring = (item.speed + '<span class="smallertext">KPH</span>');
            }
            if (item.belt){
                if (item.belt === "true"){
                    beltstring = ('<span class="green">BELT</span>');
                }
                if (item.belt === "false"){
                    beltstring = ('<span class="red">BELT</span>');
                }
            }
            if (item.fuel){
                fuelstring = (item.fuel + '<span class="smallertext">FUEL</span>');
            }
            var gaugesthings =  document.getElementById("fuelspeedbelt");
            gaugesthings.innerHTML = (fuelstring + " " + speedstring + " " + beltstring);
            
            if (item.type === "time"){
                var timebox = document.getElementById("time");
                timebox.innerHTML = (item.hours + ":" + item.minutes);
            }
		});
	};
});