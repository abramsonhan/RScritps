local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local SkeletonSettings = {
    Color = Color3.new(0, 1, 0),
    Thickness = 2,
    Transparency = 1
}

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local skeletons = {}

local function createLine()
    local line = Drawing.new("Line")
    return line
end

local function removeSkeleton(skeleton)
    for _, line in pairs(skeleton) do
        line:Remove()
    end
end

local function trackPlayer(plr)
    local skeleton = {}

    local function updateSkeleton()
        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            for _, line in pairs(skeleton) do
                line.Visible = false
            end
            return
        end

        local character = plr.Character
        local humanoid = character:FindFirstChild("Humanoid")

        if humanoid and humanoid.RigType == Enum.HumanoidRigType.R15 then
            joints = {
                ["Head"] = character:FindFirstChild("Head"),
                ["UpperTorso"] = character:FindFirstChild("UpperTorso"),
                ["LowerTorso"] = character:FindFirstChild("LowerTorso"),
                ["LeftUpperArm"] = character:FindFirstChild("LeftUpperArm"),
                ["LeftLowerArm"] = character:FindFirstChild("LeftLowerArm"),
                ["LeftHand"] = character:FindFirstChild("LeftHand"),
                ["RightUpperArm"] = character:FindFirstChild("RightUpperArm"),
                ["RightLowerArm"] = character:FindFirstChild("RightLowerArm"),
                ["RightHand"] = character:FindFirstChild("RightHand"),
                ["LeftUpperLeg"] = character:FindFirstChild("LeftUpperLeg"),
                ["LeftLowerLeg"] = character:FindFirstChild("LeftLowerLeg"),
                ["RightUpperLeg"] = character:FindFirstChild("RightUpperLeg"),
                ["RightLowerLeg"] = character:FindFirstChild("RightLowerLeg"),
            }
        elseif humanoid and humanoid.RigType == Enum.HumanoidRigType.R6 then
            joints = {
                ["Head"] = character:FindFirstChild("Head"),
                ["Torso"] = character:FindFirstChild("Torso"),
                ["LeftLeg"] = character:FindFirstChild("Left Leg"),
                ["RightLeg"] = character:FindFirstChild("Right Leg"),
                ["LeftArm"] = character:FindFirstChild("Left Arm"),
                ["RightArm"] = character:FindFirstChild("Right Arm"),
            }
        end

        local connections = {}

        if humanoid and humanoid.RigType == Enum.HumanoidRigType.R15 then
            connections = {
                { "Head", "UpperTorso" },
                { "UpperTorso", "LowerTorso" },
                { "LowerTorso", "LeftUpperLeg" },
                { "LeftUpperLeg", "LeftLowerLeg" },
                { "LowerTorso", "RightUpperLeg" },
                { "RightUpperLeg", "RightLowerLeg" },
                { "UpperTorso", "LeftUpperArm" },
                { "LeftUpperArm", "LeftLowerArm" },
                { "LeftLowerArm", "LeftHand" },
                { "UpperTorso", "RightUpperArm" },
                { "RightUpperArm", "RightLowerArm" },
                { "RightLowerArm", "RightHand" },
            }
        elseif humanoid and humanoid.RigType == Enum.HumanoidRigType.R6 then
            connections = {
                { "Head", "Torso" },
                { "Torso", "LeftArm" },
                { "Torso", "RightArm" },
                { "Torso", "LeftLeg" },
                { "Torso", "RightLeg" },
            }
        end

        for index, connection in ipairs(connections) do
            local jointA = joints[connection[1]]
            local jointB = joints[connection[2]]

            if jointA and jointB then
                local posA, onScreenA = camera:WorldToViewportPoint(jointA.Position)
                local posB, onScreenB = camera:WorldToViewportPoint(jointB.Position)

                local line = skeleton[index] or createLine()
                skeleton[index] = line

                line.Color = SkeletonSettings.Color
                line.Thickness = SkeletonSettings.Thickness
                line.Transparency = SkeletonSettings.Transparency

                if onScreenA and onScreenB then
                    if connection[2] == "LeftArm" or connection[2] == "RightArm" then
                        local offsetY = 0.5
                        posB = camera:WorldToViewportPoint(jointB.Position + Vector3.new(0, offsetY, 0))
                    end

                    line.From = Vector2.new(posA.X, posA.Y)
                    line.To = Vector2.new(posB.X, posB.Y)
                    line.Visible = true
                else
                    line.Visible = false
                end
            elseif skeleton[index] then
                skeleton[index].Visible = false
            end
        end
    end

    skeletons[plr] = skeleton

    RunService.RenderStepped:Connect(function()
        if plr and plr.Parent then
            updateSkeleton()
        else
            removeSkeleton(skeleton)
        end
    end)
end

local function untrackPlayer(plr)
    if skeletons[plr] then
        removeSkeleton(skeletons[plr])
        skeletons[plr] = nil
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        trackPlayer(plr)
    end
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= player then
        trackPlayer(plr)
    end
end)

Players.PlayerRemoving:Connect(untrackPlayer)
