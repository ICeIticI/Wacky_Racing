local Players = game:GetService("Players")



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