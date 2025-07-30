_G.HeadSize = 10
_G.Disabled = true

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local LocalPlayer = Players.LocalPlayer
local MobsFolder = workspace:FindFirstChild("Mobs")

local function applyPropertiesToPart(part)
    if part then
        part.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
        part.Transparency = 0.7
        part.BrickColor = BrickColor.new("Really blue")
        part.Material = Enum.Material.Neon
        part.CanCollide = false
    end
end

local function applyHighlight(model, color)
    if not model:FindFirstChild("HighlightESP") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "HighlightESP"
        highlight.FillColor = color
        highlight.OutlineColor = Color3.new(0, 0, 0)
        highlight.FillTransparency = 0.3
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = model
        highlight.Adornee = model
    end
end

RunService.RenderStepped:Connect(function()
    if _G.Disabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    applyPropertiesToPart(player.Character.HumanoidRootPart)
                    applyHighlight(player.Character, Color3.fromRGB(0, 170, 255))
                end)
            end
        end

        if MobsFolder then
            for _, mob in ipairs(MobsFolder:GetChildren()) do
                if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        applyPropertiesToPart(mob.HumanoidRootPart)
                        applyHighlight(mob, Color3.fromRGB(255, 0, 0))
                    end)
                end
            end
        end
    end
end)
