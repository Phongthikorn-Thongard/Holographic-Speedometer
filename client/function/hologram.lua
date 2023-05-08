SMH.hologram_object = {}

print("HELLO")

function SMH.CreateHologramObject(name, model, dui_object, coords, direction, types)
    if not HasModelLoaded(model) then
        RequestModel(model)
        repeat
            Citizen.Wait(50)
            print("loading...")
        until HasModelLoaded(model)
    end

    hologramObject = CreateVehicle(model, coords, 0.0, false, true)
    SetVehicleIsConsideredByPlayer(hologramObject, false)
    SetVehicleEngineOn(hologramObject, true, true)
    SetEntityCollision(hologramObject, false, false)

    if type(dui_object) ~= "table" then
        dui_object = { dui_object }
    end

    table.insert(SMH.hologram_object,
        { name = name, object = hologramObject, type = types, model = model, dui_object = dui_object,
            direction = direction })

    print("Loading Complete")
    return hologramObject
end

function GetHologramObjectFromModel(model)
    for i, data in pairs(SMH.hologram_object) do
        if model == data.model then
            return data
        end
    end
end

function GetHologramObjectFromDuiData(dui_data)
    for _, data in pairs(SMH.hologram_object) do
        for _, dui in pairs(data.dui_object) do
            if dui == dui_data then
                return data
            end
        end
    end
end

function AddDuiDataToHologram(dui_data, hologram_object)
    table.insert(hologram_object.dui, dui_data)
end

function RemoveDuiDataFromHologram(dui_data)
    for i, dui in pairs(hologram_object.dui) do
        if dui.name == dui_data.name then
            table.remove(hologramObject, i)
        end
    end
end

function SetDuiDataEnableState(hologram_object, dui_data, is_enable)
    for i, dui in pairs(hologram_object.dui) do
        if dui.name == dui_data.name then
            dui.is_enable = is_enable
        end
    end
end

function SMH.UpdateHologramAttach(vehicle)
    local boneIndex = GetEntityBoneIndexByName(vehicle, "chassis")

    for _, hologram in pairs(SMH.hologram_object) do
        local min, max = GetModelDimensions(GetEntityModel(vehicle))
        local width = max.x - min.x
        local length = max.y - min.y
        local height = max.z - min.z
        local position_offset = GetOffsetFromConfig(Config.Direction_Position_Offset[hologram.direction], width, length,
            height)
        local rotation_offset = GetOffsetFromConfig(Config.Direction_Rotation_Offset[hologram.direction], width, length,
            height)

        local x, y, z = position_offset[1], position_offset[2], position_offset[3]
        local rx, ry, rz = rotation_offset[1], rotation_offset[2], rotation_offset[3]

        AttachEntityToEntity(hologram.object, vehicle, boneIndex, x, y, z, rx, ry, rz, false, false, false, false, 2,
            true)
    end
end
