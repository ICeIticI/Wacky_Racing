local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer

local RemoteEvent = ReplicatedStorage:FindFirstChildWhichIsA("RemoteEvent")

local ChooseVehicleUI = Player.PlayerGui:WaitForChild("ChooseVehicleUI")
local vehicleUIs = ChooseVehicleUI.Frame.vehicleUIs

-- Making every vehicle spawner button open the vehicle-choosing screen:
local vehicleSpawnersFolder = game.Workspace:WaitForChild("vehicleSpawners")
local currentSpawner -- will be set to whatever spawner the player last touched. Used to figure out where a car should spawn
local spawnScreenDebounce = false
for _, vSpawner in pairs(vehicleSpawnersFolder:GetChildren()) do
    vSpawner.Touched:Connect(function(touchedObj)
        if not spawnScreenDebounce and game.Players:GetPlayerFromCharacter(touchedObj.Parent) and not ChooseVehicleUI.Enabled then
            spawnScreenDebounce = true
            currentSpawner = vSpawner
            ChooseVehicleUI.Enabled = true
        end
    end)
end

-- Making each vehicle button choose the chosen vehicle and close the UI
for _, UIChild in pairs(vehicleUIs:GetChildren()) do
    if UIChild:IsA("ImageButton") then
        local vehicleButton = UIChild

        vehicleButton.Activated:Connect(function()
            RemoteEvent:FireServer("vehicelButtonActivated", {currentSpawnerName = currentSpawner.Name, buttonName = vehicleButton.Name})
            ChooseVehicleUI.Enabled = false
            task.wait(3)
            spawnScreenDebounce = false
        end)
    end
end