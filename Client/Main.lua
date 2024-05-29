Citizen.CreateThread(function()
    DebugPrint("Script Active")
    while true do -- start checking for vehicles to update gear ratios
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        DebugPrint("Checking if player is in vehicle/driver seat")
        if (GetPedInVehicleSeat(vehicle, -1) == playerPed) then -- check if player is driver/in a vehicle
            DebugPrint("Player is in vehicle/driver seat")
            DebugPrint("Checking if vehicle is in config")
            if (Config.Vehicles[GetEntityModel(vehicle)]) then -- check if vehicle model is in config
                DebugPrint("Vehicle found applying ratios")
                local vehicleData = Config.Vehicles[GetEntityModel(vehicle)]
                if (GetVehicleMod(vehicle, 13) ~= -1) then
                    SetVehicleModKit(vehicle, 0)
                    SetVehicleMod(vehicle, 13, -1)
                end
                if (GetVehicleHandlingInt(vehicle, "CHandlingData", "nInitialDriveGears") ~= #vehicleData.GearRatios-1) then -- set vehicle number of gears
                    SetVehicleHandlingInt(vehicle, "CHandlingData", "nInitialDriveGears", #vehicleData.GearRatios-1)
                end
                if (GetVehicleHighGear(vehicle) ~= #vehicleData.GearRatios-1) then -- set vehicle number of gears
                    SetVehicleHighGear(vehicle, #vehicleData.GearRatios-1)
                end                    
                for key,value in pairs (vehicleData.GearRatios) do -- iterate list of gear ratios and apply them
                    SetVehicleGearRatio(vehicle, key-1, value)
                    DebugPrint("Gear: " .. key-1 .. " Ratio: " .. value)
                end
            end
        end
        Wait(0) -- wait 0ms to prevent dead loop crashing the client
    end
end)


function DebugPrint(printMessage) -- debug printing function
    if (Config.DebugInConsole) then
        print(printMessage)
    end    
end