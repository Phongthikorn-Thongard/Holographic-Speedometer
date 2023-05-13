$(document).ready(() => {
    const clamp = (num, min, max) => Math.min(Math.max(num, min), max);
    const SpeedDisplay = [
        document.querySelector("#speed-digit-1"),
        document.querySelector("#speed-digit-2"),
        document.querySelector("#speed-digit-3")
    ];

    console.log("javascript is ready to run!!!!!!!!!!!")
    window.addEventListener("message", (event) => {
        const data = event.data
        
        if (data.rawSpeed !== undefined) {
            const speed = Math.floor(parseFloat(data.rawSpeed) * 3.6);
            const speedString = speed.toString().padStart(3, '&');
            const displayStrings = [...speedString].map((char) => char === '&' ? '' : char);

            if (speedString.length > 3) speedString = "999";

            for (let i = 0; i < 3; i++) {
              SpeedDisplay[i].innerHTML = displayStrings[i];
            }
          }
          
          if (data.health !== undefined) {
            const vehiclehealth = clamp(data.health, 0, 1000);
            const healthPercent = Math.round(vehiclehealth / 1000 * 100);
            $("#repair-bar_fill").css("width", healthPercent + "%");
            $('#repair-bar_text').text(healthPercent + "%");
          }
          
          if (data.fuel !== undefined) {
            const vehiclefuel = clamp(data.fuel, 0, 65);
            const fuelPercent = Math.round(vehiclefuel / 65 * 100);
            $("#fuel-bar_fill").css("width", fuelPercent + "%");
            $('#fuel-bar_text').text(fuelPercent + "%");
          }
          
          if (data.gear !== undefined) {
            $("#gear").text(data.gear);
          }
          
          if (data.lamp !== undefined) {
            const lampColor = data.lamp !== 0 ? "rgb(255, 45, 45)" : "rgb(153, 153, 153)";
            $("#lamp-icon").css("color", lampColor);
          }

          if (data.belt !== undefined) {
            const beltColor = data.belt !== 0 ? "rgb(255, 45, 45)" : "rgb(153, 153, 153)";
            $("#belt-icon").css("color", beltColor);
          }

          if (data.lock !== undefined) {
            const lockColor = data.lock !== 0 ? "rgb(255, 45, 45)" : "rgb(153, 153, 153)";
            $("#lock-icon").css("color", lockColor);
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