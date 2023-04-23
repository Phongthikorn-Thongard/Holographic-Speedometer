$(document).ready(function() {
    const clamp = (num, min, max) => Math.min(Math.max(num, min), max);
    const SpeedDisplay = [
        document.querySelector("#speed-digit-1"),
        document.querySelector("#speed-digit-2"),
        document.querySelector("#speed-digit-3")
    ];

    console.log("javascript is ready to run!!!!!!!!!!!")
    window.addEventListener("message", function(event) {
        const data = event.data
        
        if (data.rawSpeed != undefined) {
            var speed = Math.floor(parseFloat(data.rawSpeed) * 3.6);
            var speedString = speed.toString().padStart(3, '&');

            if (speedString.length > 3) speedString = "999";

            for (let i = 0; i < 3; i++) {
                SpeedDisplay[i].innerHTML = speedString[i] == "&" ? "" : speedString[i]; 
            }
        }

        if (data.fuel != undefined) {
            vehiclefuel = clamp(data.fueld,0,65)
            $("#repair-bar-fill").css("width", vehiclefuel/65 * 100	 + "%");
			$('#repair-bar-text').text(Math.round(vehiclefuel/65 * 100) + "%")
        }

        if (data.health != undefined) {
            vehiclehealth = clamp(data.health,0,1000)
            $("#repair-bar-fill").css("width", vehiclehealth/1000 * 100	 + "%");
			$('#repair-bar-text').text(Math.round(vehiclehealth/1000 * 100) + "%")
        }
    })

    fetch(`https://${document.location.host}/isDuiReady`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            ok: true,
        })
    }).then(resp => resp.json())
})