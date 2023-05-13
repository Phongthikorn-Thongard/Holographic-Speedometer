RegisterNetEvent("smh:showSpeedMeterHologram")
AddEventHandler("smh:showSpeedMeterHologram", function(types)
    local player_ped = PlayerPedId()
    local current_vehicle = GetVehiclePedIsIn(player_ped)

    for i, dui in pairs(SMH.dui) do
        print(dui.type, types)
        if dui.type == types then
            matching_hologram = SMH.FindUsedHologram(SMH.used_direction, dui.direction)
            if matching_hologram then
                AddDuiDataToHologram(dui, matching_hologram)
            else
                print("New Model: ", dui.name)
                target_model = SMH.GetModelsByType(types)[i]
                target_model_name = target_model.name
                
                new_hologram = SMH.CreateHologramObject(
                    "hologram_1",
                    target_model.name,
                    { dui },
                    GetEntityCoords(current_vehicle),
                    Config.DefaultDirection[dui.name],
                    SMH.Hologram_Type.Speed_Meter
                )

                target_model.is_used = true
                table.insert(SMH.used_direction, {direction = Config.DefaultDirection[dui.name],hologram = GetHologramObjectFromObject(new_hologram) })

                SetModelAsNoLongerNeeded(target_model_name)
            end
        end
    end
    SMH.UpdateHologram(current_vehicle)
    print("------------------Update Hologram direction-------------")
end)
