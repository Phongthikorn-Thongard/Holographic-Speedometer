const Config = {};

Config.UseCustomGui = false //หากต้องการทำ ui เอง ให้ใส่ true จากนั้น theme-config จะไม่ทำงาน เพื่อให้สามารถสร้าง ui เองได้อย่างอิสระ

Config.htmls = { //ไฟล์ html ที่ต้องการให้แสดงข้างรถได้ สามารถสร้างกี่ไฟล์ก็ได้อย่างอิสระ และสามารถตั้งค่าได้ว่าจะให้แสดงไฟล์ไหนที่รถได้บ้าง
  //ตั้งชื่อให้ตรงกันทั้งไหน config.js และ config.lua เนื่องจากจะต้องใช้ในการตั้งค่า
  //อย่าลืมเพิิ่มไฟล์ชื่อเดียวกันนี้ที่ config.lua ด้วยนะ ^-^
  speed_meter: "speed-meter.html",
  car_performance: "car-performance.html"
};

Config.Theme = {
  speed_meter: {

  },

  car_performance : {
    
  }
}
