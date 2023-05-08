local is_on_car
is_hologram_display = false

Citizen.CreateThread(function()
    -- add_model_direction("hologram_box_model", "hologram_box_model", "p_hologram_box")

    SMH.AddModelData("hologram_box_model", "hologram_box_model", "p_hologram_box", false)

    SMH.CreateDuiObject(string.format("nui://%s/html/index.html", GetCurrentResourceName()), 512, 512,
        "speedometer_dui", "speedometer_texture", "speedometer")

    SMH.CreateDuiObject(string.format("nui://%s/html/index.html", GetCurrentResourceName()), 512, 512,
        "car_performance_dui", "car_performance_texture", "car_performance")

    if Config.OnVehicleEventCheck then
        while true do
            Citizen.Wait(50)
            local player_ped = PlayerPedId()
            if IsPedInAnyVehicle(player_ped) then
                is_on_car = true
                if not is_hologram_display then
                    is_hologram_display = true
                    TriggerEvent("smh:showHologram")
                end
            else
                is_on_car = false
            end
        end
    end
end)
