-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Settings
local Settings = {
    AimbotEnabled = false,
    FOV = 150,
    AimbotKey = Enum.UserInputType.MouseButton2,
    HeadOffset = Vector3.new(0,0.5,0),
    MaxDistance = 500,
    SmoothingFactor = 1,
    EnemyColor = Color3.fromRGB(255,170,60),
    TargetColor = Color3.fromRGB(255,0,0),
    HealthColor = Color3.fromRGB(0,255,0),
    HealthTransparency = 0.5
}

local State = {TrackedCharacters = {}}

-- FOV circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Radius = Settings.FOV
FOVCircle.Filled = false
FOVCircle.Color = Settings.TargetColor
FOVCircle.Thickness = 2
FOVCircle.Visible = true

-- ESP creation
local function makeESP(char, player)
    if State.TrackedCharacters[char] then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local folder = Instance.new("Folder")
    folder.Name = "ESPVisual"
    folder.Parent = char

    local highlight = Instance.new("Highlight")
    highlight.Adornee = char
    highlight.Parent = folder
    highlight.Enabled = true
    highlight.OutlineColor = Settings.EnemyColor
    highlight.FillColor = Settings.EnemyColor
    highlight.FillTransparency = Settings.HealthTransparency
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0,150,0,40)
    billboard.StudsOffset = Vector3.new(0,3,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = folder

    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1,0,1,0)
    frame.Parent = billboard

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0.5,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextScaled = true
    nameLabel.TextColor3 = Color3.new(1,1,1)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = player.Name
    nameLabel.Parent = frame

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1,0,0.5,0)
    healthLabel.Position = UDim2.new(0,0,0.5,0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextScaled = true
    healthLabel.TextColor3 = Color3.new(0,1,0)
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.Parent = frame

    State.TrackedCharacters[char] = {
        Highlight = highlight,
        Billboard = billboard,
        HealthLabel = healthLabel
    }
end

local function rmESP(char)
    local d = State.TrackedCharacters[char]
    if d then
        if d.Highlight and d.Highlight.Parent then d.Highlight.Parent:Destroy() end
        State.TrackedCharacters[char] = nil
    end
end

local function updESP(char, isTarget)
    local data = State.TrackedCharacters[char]
    if not data then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if not hum or hum.Health <= 0 or not root then
        rmESP(char)
        return
    end

    data.Highlight.OutlineColor = isTarget and Settings.TargetColor or Settings.EnemyColor
    data.Highlight.FillColor = isTarget and Settings.TargetColor or Settings.EnemyColor

    local hp = hum.Health
    local max = hum.MaxHealth
    local percent = hp / max

    data.HealthLabel.Text = "HP: "..math.floor(hp).."/"..math.floor(max)
    data.HealthLabel.TextColor3 = Settings.HealthColor:lerp(Color3.fromRGB(255,0,0), 1-percent)
end

-- Target finder
local function aimlock()
    local localChar = LocalPlayer.Character
    if not localChar or not localChar:FindFirstChild("HumanoidRootPart") then return end

    local best = nil
    local bestDist = math.huge
    local sc = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToScreenPoint(
                    p.Character.HumanoidRootPart.Position + Settings.HeadOffset
                )

                if onScreen then
                    local dist = (Vector2.new(pos.X,pos.Y) - sc).Magnitude
                    local worldDist = (p.Character.HumanoidRootPart.Position - localChar.HumanoidRootPart.Position).Magnitude

                    if dist <= Settings.FOV and worldDist <= Settings.MaxDistance and dist < bestDist then
                        bestDist = dist
                        best = p.Character
                    end
                end
            end
        end
    end
    return best
end

-- Aiming
local function lockAim(target)
    if not target then return end
    local head = target:FindFirstChild("Head")
    if not head then return end

    local desired = CFrame.new(Camera.CFrame.Position, head.Position)
    Camera.CFrame = Camera.CFrame:Lerp(desired, 1 / Settings.SmoothingFactor)
end

-- Player tracking
local function track(p)
    if p == LocalPlayer then return end

    p.CharacterAdded:Connect(function(char)
        wait(0.1)
        makeESP(char, p)
    end)

    p.CharacterRemoving:Connect(function(char)
        rmESP(char)
    end)

    if p.Character then
        makeESP(p.Character, p)
    end
end

for _, plr in pairs(Players:GetPlayers()) do track(plr) end
Players.PlayerAdded:Connect(track)

-- GUI toggle
local GUI = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
GUI.ResetOnSpawn = false

local ToggleLabel = Instance.new("TextLabel", GUI)
ToggleLabel.Position = UDim2.new(0.5,-150,0.9,0)
ToggleLabel.Size = UDim2.new(0,300,0,30)
ToggleLabel.BackgroundColor3 = Color3.new(0,0,0)
ToggleLabel.BackgroundTransparency = 0.4
ToggleLabel.TextScaled = true
ToggleLabel.TextColor3 = Color3.new(1,1,1)
ToggleLabel.Text = "Aimbot: OFF (Hold RMB | Press 'L')"

UserInputService.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.L then
        Settings.AimbotEnabled = not Settings.AimbotEnabled
        ToggleLabel.Text = "Aimbot: "..(Settings.AimbotEnabled and "ON" or "OFF").." (Hold RMB | Press 'L')"
    end
end)

RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        local c = p.Character
        if p ~= LocalPlayer and c and not State.TrackedCharacters[c] then
            makeESP(c, p)
        end
    end
end)

-- ml
RunService.RenderStepped:Connect(function()
    local target = aimlock()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    if Settings.AimbotEnabled and UserInputService:IsMouseButtonPressed(Settings.AimbotKey) then
        lockAim(target)
    end

    for char,_ in pairs(State.TrackedCharacters) do
        updESP(char, char == target)
    end
end)
