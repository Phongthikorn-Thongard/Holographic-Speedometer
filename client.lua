local Keys = {
  ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,['~'] = 243, 
  ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
  ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
  ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, 
  ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,['HOME'] = 213, 
  ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,['NENTER'] = 201, ['N4'] = 108, ['N5'] = 60, 
  ['N6'] = 107, ['N+'] = 96, ['N-'] = 97, ['N7'] = 117, ['N8'] = 61, ['N9'] = 118
}

local speedMeter = nil
local onVehicle = false
local HologramURI = string.format("nui://%s/html/index.html", GetCurrentResourceName())
local duiObject = nil
local textureReplacementMade = false
local IsReady = true

--Car Event
Citizen.CreateThread(function()

  InstallDui()

  while true do
    Citizen.Wait(1000)
    
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if DoesEntityExist(vehicle) and IsPedInVehicle(playerPed, vehicle, false) and not onVehicle then --PLayer Enter Vehicle
      onVehicle = true
      TriggerEvent('SMH:showHologram', vehicle)
    elseif not DoesEntityExist(vehicle) and speedMeter ~= nil then --Player Exit Vehicle
      onVehicle = false
      TriggerEvent('SMH:hideHologram', speedMeter)
    end
  end
end)


--


function InstallDui()
  duiObject = CreateDui(HologramURI, 512, 512)

  repeat Citizen.Wait(0) until IsReady

  local txdHandle  = CreateRuntimeTxd("HologramDUI")
	local duiHandle  = GetDuiHandle(duiObject)
	local duiTexture = CreateRuntimeTextureFromDuiHandle(txdHandle, "DUI", duiHandle)
end

function CreateHologram(HologramModel, coords)

	hologramObject = CreateVehicle(HologramModel, coords.x, coords.y, coords.z, 0.0, false, true)
	SetVehicleIsConsideredByPlayer(hologramObject, false)
	SetVehicleEngineOn(hologramObject, true, true)
	SetEntityCollision(hologramObject, false, false)

	return hologramObject
end

AddEventHandler('SMH:showHologram', function(vehicle)

  local hash = `hologram_box_model` --Hash String
  RequestModel(hash)
	repeat Citizen.Wait(0) until HasModelLoaded(hash)
  
  local playerPed = GetPlayerPed(-1) 
  local playerVehicle = GetVehiclePedIsIn(playerPed, false) -- Get the vehicle the player is in
  local boneIndex = GetEntityBoneIndexByName(playerVehicle, "chassis")
  local coords = GetOffsetFromEntityInWorldCoords(playerVehicle, 0.0, 1.0, 0.0) -- Get the coordinates for the position where the screen will be spawned relative to the exhaust bone
  
  if DoesEntityExist(playerVehicle) then
    speedMeter = CreateHologram(hash, coords)
    if not textureReplacementMade then
      AddReplaceTexture("hologram_box_model", "p_hologram_box", "HologramDUI", "DUI")
      textureReplacementMade = true
    end
    SetModelAsNoLongerNeeded(HologramModel)


    local min, max = GetModelDimensions(GetEntityModel(playerVehicle))
    local width = max.x - min.x

    local x,y,z = (width), 0.5, 0.5 
    local rx,ry,rz = 0.0, 0.0, -25.0 
    
    AttachEntityToEntity(speedMeter, playerVehicle, boneIndex, x, y, z, rx, ry, rz, false, false, false, false, 2, true) -- Attach the screen to the exhaust bone of the vehicle

    if duiObject and IsReady then
      repeat
          vehicleSpeed = GetEntitySpeed(playerVehicle)
          fuel = GetVehicleFuelLevel(playerVehicle)
          health = GetVehicleEngineHealth(playerVehicle)
          SendDuiMessage(duiObject, json.encode({
            rawSpeed = vehicleSpeed,
            fuel = fuel,
            health = health
          }))
          Citizen.Wait(50)
        until (speedMeter == nil or not playerVehicle) 
      end
  end
end)

AddEventHandler('SMH:hideHologram', function(speedmeter)
  if DoesEntityExist(speedmeter) then
    DeleteVehicle(speedMeter) -- Delete the screen object
    speedMeter = nil -- Reset the speedMeter variable to nil
  end
end)


--Key Mapping

RegisterCommand("changescreendirection", function() 
  print("Change direction")
end)

DisableControlAction(0, Keys[Config.ChangeMeterDirection], true)
RegisterKeyMapping("changescreendirection", "Change Screen Direction to any direction of vehicle", "keyboard", Config.ChangeMeterDirection)


--Callback
RegisterNuiCallback('isDuiReady', function()
  IsReady = true
  cb({ok = true})
end)