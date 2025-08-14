local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteEvent = Instance.new("RemoteEvent")
RemoteEvent.Parent = ReplicatedStorage

local currentCarTable = {} -- table with the index being the player and it associates them with their current car. Useful so we destroy their old one when they pick a new one

RemoteEvent.OnServerEvent:Connect(function(player, reason, data)
    if reason == "vehicelButtonActivated" then
        -- destroy their old car if they have one:
        if currentCarTable[player.Name] then
            currentCarTable[player.Name]:Destroy()
        end
        
        -- Inside each button is a viewport frame, containing the car model they chose.
        currentCarTable[player.Name] = player.PlayerGui.ChooseVehicleUI.Frame.vehicleUIs:FindFirstChild(data.buttonName).ViewportFrame.Car:Clone()
        currentCarTable[player.Name]:PivotTo(game.Workspace.vehicleSpawners:FindFirstChild(data.currentSpawnerName).CFrame * CFrame.new(0,15,-30) * CFrame.Angles(math.rad(-90),math.rad(180),0))
        currentCarTable[player.Name].Parent = game.Workspace
    end
end)

local idStarter = "rbxassetid://"
local screamIdsTable = {
    idStarter.."6108540937",
    idStarter.."7772283448",
    idStarter.."18564431123",
    idStarter.."8749386406",
    idStarter.."80156405968805",
    idStarter.."6108540937",
    idStarter.."108277187006018",
    idStarter.."5853668794",
    idStarter.."18623229993",
    idStarter.."2357464981",
    idStarter.."9125712561",
    idStarter.."91412024101709",
    idStarter.."1973317014",
    idStarter.."4771846035",
    idStarter.."160718677",
}

local explosionIdsTable = {
    idStarter.."7405939280",
    idStarter.."5801257793",
    idStarter.."165969964",
    idStarter.."3802269741",
    idStarter.."7128851174",
    idStarter.."4418405082",
}

local explosionSound = Instance.new("Sound")
explosionSound.Name = "explosionSound"
explosionSound.Volume = 3
explosionSound.SoundId = explosionIdsTable[math.random(1, #explosionIdsTable)]

local screamSound = Instance.new("Sound")
screamSound.Name = "screamSound"
screamSound.Volume = 3
screamSound.SoundId = screamIdsTable[math.random(1, #screamIdsTable)]


local function onCharacterAdded(character)
    
    screamSound.SoundId = screamIdsTable[math.random(1, #screamIdsTable)]
    explosionSound.SoundId = explosionIdsTable[math.random(1, #explosionIdsTable)]


    local diedConnection
    diedConnection = character:WaitForChild("Humanoid").Died:Connect(function()
        
        local explosion = Instance.new("Explosion")
        explosion.DestroyJointRadiusPercent = 0
        explosion.Position = character.HumanoidRootPart.Position
        explosion.Parent = character
        
        explosionSound.Parent = character
        explosionSound:Play()
        
        screamSound.Parent = character.Head
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