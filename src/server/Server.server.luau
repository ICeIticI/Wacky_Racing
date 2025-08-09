local Players = game:GetService("Players")

local explosionSound = Instance.new("Sound")
explosionSound.Name = "explosionSound"
explosionSound.Volume = 5
explosionSound.SoundId = "rbxassetid://7405939280"

local screamSound = Instance.new("Sound")
screamSound.Name = "screamSound"
screamSound.SoundId = "rbxassetid://18623229993"

local function onCharacterAdded(character)
    -- character.HumanoidRootPart.CFrame = lobby.PrimaryPart.CFrame

    local diedConnection
    diedConnection = character:WaitForChild("Humanoid").Died:Connect(function()
        local explosion = Instance.new("Explosion")
        explosion.DestroyJointRadiusPercent = 0
        explosion.Position = character.HumanoidRootPart.Position
        explosion.Parent = character
        
        explosionSound.Parent = character
        explosionSound:Play()
        
        screamSound.Parent = character
        screamSound:Play()

        diedConnection:Disconnect()
    end)
end

local function onPlayerAdded(player)

    player.CharacterAdded:Connect(function(character)
        onCharacterAdded(character)
    end)
    
end

Players.PlayerAdded:Connect(function(player)
    onPlayerAdded(player)
end)

for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end