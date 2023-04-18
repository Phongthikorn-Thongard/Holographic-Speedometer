-- ESX = exports["es_extended"]:getSharedObject()

-- RegisterNetEvent("spawn_model")
-- AddEventHandler("spawn_model", function(playerSrc)
-- print(source)
--   local modelHash = GetHashKey('screen')
--   print("Model hash:", modelHash)

--   local playerPed = GetPlayerPed(source)
--   local coords = GetEntityCoords(playerPed)
--   local heading = GetEntityHeading(playerPed)

--   local spawnedObject = CreateObject(modelHash, coords.x, coords.y, coords.z, true, true, true)
--   print("Spawned object:", spawnedObject)

--   if DoesEntityExist(spawnedObject) then
--     TriggerClientEvent("model_spawned", source, true)
--   else
--     TriggerClientEvent("model_spawned", source, false)
--   end
-- end)
