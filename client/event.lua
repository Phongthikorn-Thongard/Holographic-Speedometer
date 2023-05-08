RegisterNetEvent("smh:showHologram")
AddEventHandler("smh:showHologram", function()
    local player_ped = PlayerPedId()
    local current_vehicle = GetVehiclePedIsIn(player_ped)

    for i, dui in pairs(SMH.dui) do
        if dui.name == "speedometer" then
            model_name = "hologram_box_model"
            new_hologram = SMH.CreateHologramObject(
                "hologram_1",
                GetHashKey(model_name),
                { dui },
                GetEntityCoords(current_vehicle),
                Config.DefaultDirection["speedometer"],
                SMH.Hologram_Type.Speed_Meter
            )

            if DoesEntityExist(new_hologram) then
                print("Exist")
            else
                print("Hello nah!")
            end

            original_txd, original_txn = SMH.GetModelOriginalTexture(model_name)
            AddReplaceTexture(original_txd, original_txn, dui.txd, dui.txn)

            SMH.UpdateHologramAttach(current_vehicle)
        end
    end
end)
