SMH.model = {}

function SMH.AddModelData(model_name, original_txd, original_txn, types, ui, is_used)
    table.insert(SMH.model,
        { name = model_name, original_txd = original_txd, original_txn = original_txn, type = types, ui = ui, is_used = is_used })
end

function SMH.GetModelOriginalTexture(model_name)
    for i, model_data in pairs(SMH.model) do
        if model_data.name == model_name then
            return model_data.original_txd, model_data.original_txn
        end
    end
end

function SMH.IsUsed(model_name)
    for i, model_data in pairs(SMH.model) do
        if model_data.name == model_name then
            return model_data.is_used
        end
    end
end

function SMH.GetModelsByType(types)

    local modelbytype = {}

    for i, model_data in pairs(SMH.model) do
        if model_data.type == types then
            table.insert(modelbytype, model_data)
        end
    end

    return modelbytype
end

function SMH.SetModelUseByName(model_name, types)
    for i, model_data in pairs(SMH.model) do
        if model_data.name == model_name then
            model_data.type = types
        end
    end
end