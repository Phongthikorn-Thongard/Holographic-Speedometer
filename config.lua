Config = {}

Config.ChangeMeterDirection = "F3" --ปุ่มเปลี่ยนทิศทาง
Config.CloseMeter = "K"            --ปุ่มปิด Hologram
Config.OnVehicleEventCheck = true  -- ให้เช็คว่าผู้เล่นอยู่บนรถด้วยสคริปต์นี้ไหม หากมีสคริปต์์ที่เช็คอยู่แล้วสามารถ ใช้สคริปต์นั้น แล้วยิง event มาเพื่อเปิดปิด gui แทนได้

Config.DisplayHologram = {
    -- เลือกว่าต้องการแสดงผล hologram อันไหน
    speedometer = true,
    car_performance = true
}

Config.AllowToChangeDirection = false               --อนุญาตให้ผู้เล่นกดปุ่มเพื่อเปลี่ยนทิศทางได้หรือไม่
Config.AllowDirection = { "right", "left", "back" } --ให้ผู้เล่นเปลี่ยน Hologram ไปที่ทิศทางไหนได้บ้าง
Config.DefaultDirection = {
    --ทิศทางของ hologram เมื่อขึ้นรถ
    speedometer = "right",
    car_performance = "right"
}


--@VehicleWidth จะถูกแทนที่ด้วยความกว้างของรถ และสามารถนำไป + กับตัวเลขที่เพิ่มเข้าได้เช่น "$VehicleWidth + 0.1" ถ้ารถยาว 2.1 : Offset จะเป็น 2.2 (2.1 + 0.1)
--@VehiclLength จะถูกแทนที่ด้วยขนาดความสูงของรถ
--@VehicleHeight จะถูกแทนที่ด้วยขนาดความสูงของรถ

--x คือ ซ้าย ขวา (+x = ไปทางขวา -x = ไปทางซ้าย)
--y คือ หน้า หลัง (+y = ไปข้างหน้า -y = ไปข้างหลัง)
--z คือ บน ล่าง (+z = ไปข้างบน -z = ไปข้างล่าง)

Config.Direction_Position_Offset = {
    --ตำแหน่งของ Hologram ของแต่ละทิศทาง
    right = { "@VehicleWidth + 0.1", 0.5, 0.5 },
    left = { "-@VehicleWidth + (-0.1)", 0.5, 0.5 },
    front = { 0.0, 0.0, 0.0 },
    back = { 0.0, "-@VehicleLength - (-2)", 0.5 },
    top = { 0.0, 0.0, 0.0 },
    bottom = { 0.0, 0.0, 0.0 }
}

Config.Direction_Rotation_Offset = {
    --การหมุนของ Hologram ของแต่ละทิศทาง
    right = { 0.0, 0.0, -25.0 },
    left = { 0.0, 0.0, 25.0 },
    front = { 0.0, 0.0, 0.0 },
    back = { 0.0, 0.0, 0.0 },
    top = { 0.0, 0.0, 0.0 },
    bottom = { 0.0, 0.0, 0.0 }
}


Config.Hologram = { speedometer, car_performance } --อะไรก็ตามที่อยู่ในนี้จะถูกโหลดเป็น gui (หากแก้ไจจะทำให้เกิดปัญหาได้)
