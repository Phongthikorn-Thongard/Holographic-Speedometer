local Keys = {
  ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,['~'] = 243, 
  ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
  ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
  ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, 
  ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,['HOME'] = 213, 
  ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,['NENTER'] = 201, ['N4'] = 108, ['N5'] = 60, 
  ['N6'] = 107, ['N+'] = 96, ['N-'] = 97, ['N7'] = 117, ['N8'] = 61, ['N9'] = 118
}

local speed_meter = nil
local current_direction = Config.DefaultDirection
local hologram_url = string.format("nui://%s/html/index.html", GetCurrentResourceName())
local is_on_vehicle = false
local dui_object = nil
local is_displayed = false
local is_ready = false
local texture_replacement_made = false
local is_lamp_on = false
local is_belt_on = false
local is_locked = false

--Car Event
Citizen.CreateThread(function()

  install_dui()

  while true do
    Citizen.Wait(1000)
    
    local player_ped = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(player_ped, false)
    
    if DoesEntityExist(vehicle) and IsPedInVehicle(player_ped, vehicle, false) and not is_on_vehicle then --PLayer Enter Vehicle
      
      is_on_vehicle = true
      TriggerEvent('SMH:showHologram')
    elseif not DoesEntityExist(vehicle) and speed_meter ~= nil then --Player Exit Vehicle
      is_on_vehicle = false
      TriggerEvent('SMH:hideHologram')
    end
  end
end)


--###############
--#             #
--#   Function  #
--#             #
--###############

function install_dui()
  dui_object = CreateDui(hologram_url, 512, 512)

  repeat Citizen.Wait(0) until is_ready

  local txd_handle  = CreateRuntimeTxd("HologramDUI")
	local dui_handle  = GetDuiHandle(dui_object)
	local duiTexture = CreateRuntimeTextureFromDuiHandle(txd_handle, "DUI", dui_handle)
end

function CreateHologram(HologramModel, coords)

	local hologram_object = CreateVehicle(HologramModel, coords.x, coords.y, coords.z, 0.0, false, true)
	SetVehicleIsConsideredByPlayer(hologram_object, false)
	SetVehicleEngineOn(hologram_object, true, true)
	SetEntityCollision(hologram_object, false, false)

	return hologram_object
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
  local current_index = 0
  for i, state in ipairs(table) do
    if state == currentState then
      current_index = i
      break
    end
  end

  local next_index = current_index + 1
  if next_index > #table then
    next_index = 1
  end

  return table[next_index]

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
  
  local player_ped = GetPlayerPed(-1) 
  local player_vehicle = GetVehiclePedIsIn(player_ped, false) -- Get the vehicle the player is in
  --local boneIndex = GetEntityBoneIndexByName(player_vehicle, "chassis")
  local coords = GetOffsetFromEntityInWorldCoords(player_vehicle, 0.0, 1.0, 0.0) -- Get the coordinates for the position where the screen will be spawned relative to the exhaust bone
  
  if DoesEntityExist(player_vehicle) then
    speed_meter = CreateHologram(hash, coords)
    if not texture_replacement_made then
      AddReplaceTexture("hologram_box_model", "p_hologram_box", "HologramDUI", "DUI")
      texture_replacement_made = true
    end
    SetModelAsNoLongerNeeded(HologramModel)

    TriggerEvent("SMH:updateHologramDirection", speed_meter, player_vehicle, current_direction)
    is_displayed = true

    if dui_object and is_ready then
      repeat
          vehicleSpeed = GetEntitySpeed(player_vehicle)
          fuel = GetVehicleFuelLevel(player_vehicle)
          health = GetVehicleEngineHealth(player_vehicle)
          gear = GetVehicleCurrentGear(player_vehicle)

          SendDuiMessage(dui_object, json.encode({
            rawSpeed = vehicleSpeed,
            fuel = fuel,
            health = health,
            gear = gear,
            lamp = is_lamp_on,
            belt = is_belt_on,
            lock = is_locked
          }))
          Citizen.Wait(50)
        until (speed_meter == nil or not player_vehicle) 
      end
    end
end)
  
AddEventHandler('SMH:hideHologram', function()
  if DoesEntityExist(speed_meter) then
    DeleteVehicle(speed_meter) -- Delete the screen object
    speed_meter = nil -- Reset the speed_meter variable to nil
    is_displayed = false
  end
end)
  
AddEventHandler('SMH:updateHologramDirection', function(speed_meter, vehicle, direction)

  if speed_meter == nil then
    print("Speed Meter hasn't load yet.")
  end

  local min, max = GetModelDimensions(GetEntityModel(vehicle))
  local width = max.x - min.x
  local length = max.y - min.y
  local height = max.z - min.z
  local position_offset = GetOffsetFromConfig(Config.Direction_Position_Offset[direction],width,length,height)
  local rotation_offset = GetOffsetFromConfig(Config.Direction_Rotation_Offset[direction],width,length,height)

  local x,y,z = position_offset[1], position_offset[2], position_offset[3] 
  local rx,ry,rz = rotation_offset[1], rotation_offset[2], rotation_offset[3]  

  AttachEntityToEntity(speed_meter, vehicle, boneIndex, x, y, z, rx, ry, rz, false, false, false, false, 2, true)
end)




--###############
--#             #
--# Key Mapping #
--#             #
--###############
RegisterCommand("changescreendirection", function() 
  print(current_direction.." Before")
  local nextDirection = GetNextIndexInTable(Config.AllowDirection, current_direction)
  local playerVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
  current_direction = nextDirection

  print(current_direction.." After")
  TriggerEvent("SMH:updateHologramDirection", speed_meter, playerVehicle, current_direction)
end)

DisableControlAction(0, Keys[Config.ChangeMeterDirection], true)
RegisterKeyMapping("changescreendirection", "Change Screen Direction to any direction of vehicle", "keyboard", Config.ChangeMeterDirection)

RegisterCommand("toggledisplay", function(source) 
  if is_displayed then
    TriggerEvent("SMH:hideHologram")
    is_displayed = false
  else
    TriggerEvent("SMH:showHologram")
    is_displayed = true
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
  is_ready = true
end)

AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end

  TriggerEvent('SMH:hideHologram')
  print('The resource ' .. resourceName .. ' was stopped.')
end)

