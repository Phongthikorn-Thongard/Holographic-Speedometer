local speedMeter = nil
local onVehicle = false

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0) -- Wait for the next frame
    
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if DoesEntityExist(vehicle) and IsPedInVehicle(playerPed, vehicle, false) and not onVehicle then
      onVehicle = true
      TriggerEvent('playerEnteredVehicle', vehicle)
    elseif not DoesEntityExist(vehicle) and speedMeter ~= nil then
      onVehicle = false
      TriggerEvent('playerExitedVehicle', speedMeter)
    end
  end
end)


AddEventHandler('playerEnteredVehicle', function(vehicle)
  local hash = `screen` --Hash String
  RequestModel(hash)
  print("Requesting model...")
  
  while not HasModelLoaded(hash) do
    Wait(500)
    print("Loading Crate...")
  end
  
  local playerPed = GetPlayerPed(-1) 
  local playerVehicle = GetVehiclePedIsIn(playerPed, false) -- Get the vehicle the player is in
  local boneIndex = GetEntityBoneIndexByName(playerVehicle, "exhaust")
  local coords = GetOffsetFromEntityInWorldCoords(playerVehicle, 0.0, 1.0, 0.0) -- Get the coordinates for the position where the screen will be spawned relative to the exhaust bone
  
  if DoesEntityExist(playerVehicle) then
    speedMeter = CreateObject(hash, coords.x, coords.y, coords.z, true, true, true)
    print("Spawned object:", speedMeter)
  
    if DoesEntityExist(speedMeter) then
      local x,y,z = 2.5, 0.5, 0.5 
      local rx,ry,rz = 0.0, 0, 90.0 
      
      AttachEntityToEntity(speedMeter, playerVehicle, boneIndex, x, y, z, rx, ry, rz, false, false, false, false, 2, true) -- Attach the screen to the exhaust bone of the vehicle
    end
  end
  
end)


AddEventHandler('playerExitedVehicle', function(vehicle)
  if DoesEntityExist(vehicle) then
    DeleteEntity(speedMeter) -- Delete the screen object
    speedMeter = nil -- Reset the speedMeter variable to nil
  end
end)

