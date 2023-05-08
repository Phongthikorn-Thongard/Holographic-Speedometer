SMH.dui = {}

function SMH.CreateDuiObject(url, pixel_x, pixel_y, txd_name, texture_name, name)
    local dui = CreateDui(url, pixel_x, pixel_y)
    local txd_handle = CreateRuntimeTxd(txd_name)
    local dui_handle = GetDuiHandle(dui)
    local duiTexture = CreateRuntimeTextureFromDuiHandle(txd_handle, texture_name, dui_handle)

    table.insert(SMH.dui, { name = name, dui = dui, txd = txd_name, txn = texture_name, is_enable = false })
    return dui
end

function GetDuiDataFromDuiObject(dui_object)
    for i, data in pairs(SMH.dui) do
        if dui_object == data.dui then
            return data
        end
    end
end

function GetDuiDataFromName(name)
    for i, data in pairs(SMH.dui) do
        if name == data.name then
            return data
        end
    end
end
