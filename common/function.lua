SMH = {}

SMH.Hologram_Type = {
    Speed_Meter = "speed_meter",
    Player_Status = "player_status",
    Notification = "notification"
}

function GetOffsetFromConfig(table, width, length, height)
    local newOffset = { 0.0, 0.0, 0.0 }

    for i, offset in pairs(table) do
        if type(offset) == "number" then
            newOffset[i] = offset + 0.0
        else
            offset = offset:gsub("@VehicleWidth", width)
            offset = offset:gsub("@VehicleHeight", height)
            offset = offset:gsub("@VehicleLength", length)
            local offsetvalue = assert(load("return " .. offset))
            newOffset[i] = offsetvalue() + 0.0
        end
    end
    return newOffset
end

function GetNextIndexInTable(table, currentState)
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
