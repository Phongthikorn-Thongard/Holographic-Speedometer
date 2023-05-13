local is_on_car = false
is_hologram_display = false

Citizen.CreateThread(function()
    -- add_model_direction("hologram_box_model", "hologram_box_model", "p_hologram_box")

    SMH.AddModelData("hologram_box_1", "hologram_box_1", "hologram_box_1_texture", SMH.Hologram_Type.Speed_Meter,
        "nui://%s/ui/speedometer_1.html", false)
    SMH.AddModelData("hologram_box_2", "hologram_box_2", "hologram_box_2_texture", SMH.Hologram_Type.Speed_Meter,
        "nui://%s/ui/speedometer_2.html", false)

        
        SMH.CreateDuiObject(string.format("nui://%s/ui/html/car-performance.html", GetCurrentResourceName()), 512, 512,
        "car_performance_dui", "car_performance_texture", "car_performance", SMH.Hologram_Type.Speed_Meter)
        
        SMH.CreateDuiObject(string.format("nui://%s/ui/html/speedometer.html", GetCurrentResourceName()), 512, 512,
            "speedometer_dui", "speedometer_texture", "speedometer", SMH.Hologram_Type.Speed_Meter)
            
    if Config.OnVehicleEventCheck then
        while true do
            Citizen.Wait(50)
            local player_ped = PlayerPedId()
            if IsPedInAnyVehicle(player_ped) then
                is_on_car = true
                if not is_hologram_display then
                    is_hologram_display = true
                    TriggerEvent("smh:showSpeedMeterHologram", SMH.Hologram_Type.Speed_Meter)
                end
            else
                is_on_car = false
            end
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    print('The resource ' .. resourceName .. ' has been started.')
end)


AddEventHandler('onResourceStop', function(resourceName)
    TriggerServerEvent("message", "resource stopping")

    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    for _, dui in pairs(SMH.dui) do
        DestroyDui(dui.dui)
        TriggerServerEvent("message", "Destroy DUI complete")
    end
    TriggerServerEvent("message", "Ready to trigger delete hologram")
    for _, hologram in pairs(SMH.hologram_object) do
        TriggerServerEvent("message", "running to delete hologram")
        if DoesEntityExist(hologram.object) then
            TriggerServerEvent("message", "found hologram")
            TriggerServerEvent("message", hologram.object)
            DeleteVehicle(hologram.object)
            repeat
                Citizen.Wait(0)
            until DoesEntityExist(hologram.object)
            RemoveReplaceTexture(SMH.GetModelOriginalTexture(hologram.model)[1],
                SMH.GetModelOriginalTexture(hologram.model)[2])
            TriggerServerEvent("message", "delete hologram")
        end
    end
end)
