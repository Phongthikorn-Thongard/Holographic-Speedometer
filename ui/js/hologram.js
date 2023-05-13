$(function(){
	window.onload = (e) => {
        /* 'links' the js with the Nui message from main.lua */
		window.addEventListener('message', (event) => {
            //document.querySelector("#logo").innerHTML = " "
			var item = event.all_dui;
            print(item)
			// if (item !== undefined && item.type === "ui") {
            //     /* if the display is true, it will show */
			// 	if (item.display === true) {
            //         $("#container").show();
            //          /* if the display is false, it will hide */
			// 	} else{
            //         $("#container").hide();
            //     }
			// }
		});
	};
});


$(document).ready(() => {
    console.log("javascript is ready to run!!!!!!!!!!!")
})
// console.log("Javascript")

// $(document).ready(() => {

//     console.log("Javascript ready");
//     window.addEventListener("message", (data) => {
//         console.log("Messgineas");

//         console.log(data.type);
//     })

//     // fetch(`https://${document.location.host}/isDuiReady`, {
//     //     method: 'POST',
//     //     headers: {
//     //         'Content-Type': 'application/json; charset=UTF-8',
//     //     },
//     //     body: JSON.stringify({
//     //         ok: true,
//     //     })
//     // }).then(resp => resp.json())
// })


//     // var htmlFiles = [
//     //     "html/car-performance.html",
//     //     "html/speedometer.html",
//     // ];


//     // htmlFiles.forEach(function(file) {
//     //     $.get(file, function(data) {
//     //         let tmpEl = document.createElement("div");
//     //         tmpEl.innerHTML = data;
//     //         console.log(tmpEl);
//     //         let hologram = tmpEl.querySelector("#hologram-container");
//     //         let content = hologram.innerHTML;
//     //         $(".hologram-container").append(content)
//     //     })
//     // })
    

    
