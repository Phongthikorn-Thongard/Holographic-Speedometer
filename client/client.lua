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
local currentDirection = Config.DefaultDirection
local HologramURI = string.format("nui://%s/html/index.html", GetCurrentResourceName())
local onVehicle = false
local duiObject = nil
local IsDisplay = false
local IsReady = false
local textureReplacementMade = false

--Car Event
Citizen.CreateThread(function()

  InstallDui()

  while true do
    Citizen.Wait(1000)
    
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if DoesEntityExist(vehicle) and IsPedInVehicle(playerPed, vehicle, false) and not onVehicle then --PLayer Enter Vehicle
      onVehicle = true
      TriggerEvent('SMH:showHologram')
    elseif not DoesEntityExist(vehicle) and speedMeter ~= nil then --Player Exit Vehicle
      onVehicle = false
      TriggerEvent('SMH:hideHologram')
    end
  end
end)


--###############
--#             #
--#   Function  #
--#             #
--###############

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

function GetOffsetFromConfig(table,width,length,height) 
  local newOffset = {0.0,0.0,0.0}


  for i, offset in pairs(table) do
    if type(offset) == "number" then
      newOffset[i] = offset + 0.0
    else
      offset = offset:gsub("@VehicleWidth", width)
      offset = offset:gsub("@VehicleHeight", height)
      offset = offset:gsub("@VehicleLength", length)
      local offsetvalue = assert(load("return " ..offset))
      newOffset[i] = offsetvalue() + 0.0
    end
  end
  return newOffset
end

function GetNextIndexInTable(table,currentState)
  local currentIndex = 0
  for i, state in ipairs(table) do
    if state == currentState then
      currentIndex = i
      break
    end
  end

  local nextIndex = currentIndex + 1
  if nextIndex > #table then
    nextIndex = 1
  end

  return table[nextIndex]

end


--###############
--#             #
--#    Event    #
--#             #
--###############
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

    TriggerEvent("SMH:updateHologramDirection", speedMeter, playerVehicle, currentDirection)
    IsDisplay = true

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
    --TODO: Check if player's hologram is show before do anything
end)
  
AddEventHandler('SMH:hideHologram', function()
  if DoesEntityExist(speedMeter) then
    DeleteVehicle(speedMeter) -- Delete the screen object
    speedMeter = nil -- Reset the speedMeter variable to nil
    IsDisplay = false
  end
end)
  
AddEventHandler('SMH:updateHologramDirection', function(speedMeter, vehicle, direction)

  if speedMeter == nil then
    print("Speed Meter hasn't load yet.")
  end

  local min, max = GetModelDimensions(GetEntityModel(vehicle))
  local width = max.x - min.x
  local length = max.y - min.y
  local height = max.z - min.z
  print(width,length,height)
  local PositionOffset = GetOffsetFromConfig(Config.Direction_Position_Offset[direction],width,length,height)
  local RotationOffset = GetOffsetFromConfig(Config.Direction_Rotation_Offset[direction],width,length,height)
  print(PositionOffset,RotationOffset)

  local x,y,z = PositionOffset[1], PositionOffset[2], PositionOffset[3] 
  local rx,ry,rz = RotationOffset[1], RotationOffset[2], RotationOffset[3]  

  AttachEntityToEntity(speedMeter, vehicle, boneIndex, x, y, z, rx, ry, rz, false, false, false, false, 2, true) -- Attach the screen to the exhaust bone of the vehicle
end)



--###############
--#             #
--# Key Mapping #
--#             #
--###############
RegisterCommand("changescreendirection", function() 
  print(currentDirection.." Before")
  local nextDirection = GetNextIndexInTable(Config.AllowDirection, currentDirection)
  local playerVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
  currentDirection = nextDirection

  print(currentDirection.." After")
  TriggerEvent("SMH:updateHologramDirection", speedMeter, playerVehicle, currentDirection)
end)

DisableControlAction(0, Keys[Config.ChangeMeterDirection], true)
RegisterKeyMapping("changescreendirection", "Change Screen Direction to any direction of vehicle", "keyboard", Config.ChangeMeterDirection)

RegisterCommand("toggledisplay", function(source) 
  if IsDisplay then
    TriggerEvent("SMH:hideHologram")
    IsDisplay = false
  else
    TriggerEvent("SMH:showHologram")
    IsDisplay = true
  end
end)

DisableControlAction(0, Keys[Config.CloseMeter], true)
RegisterKeyMapping("toggledisplay", "Change Screen Direction to any direction of vehicle", "keyboard", Config.CloseMeter)



--###############
--#             #
--#  Call Back  #
--#             #
--###############
RegisterNuiCallback('isDuiReady', function()
  IsReady = true
end)

AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end

  TriggerEvent('SMH:hideHologram')
  print('The resource ' .. resourceName .. ' was stopped.')
end)

