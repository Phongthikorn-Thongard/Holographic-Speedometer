SMH.model = {}

function SMH.AddModelData(model_name, original_txd, original_txn, is_used)
    table.insert(SMH.model,
        { name = model_name, original_txd = original_txd, original_txn = original_txn, is_used = is_used })
end

function SMH.GetModelOriginalTexture(model_name)
    for i, model_data in pairs(SMH.model) do
        if model_data.name == model_name then
            -- for _, v in pairs(model_data) do
            --     print("model_data:",v)
            -- end
            print("Returning: ", model_data.original_txd, model_data.original_txn)
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
