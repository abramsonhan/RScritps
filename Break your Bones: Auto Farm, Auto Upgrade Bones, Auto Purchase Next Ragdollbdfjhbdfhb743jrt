-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- Settings
local runningAutofarm = false
local runningUpgrade = false
local runningNextRagdoll = false
local runningRefine = false
local slamDuration = 20
local slamVelocity = 100

-- Freeze/unfreeze
local function setFrozen(char, state)
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.Anchored = state end
end

-- Safe teleport character
local function safeTeleport(char, cframeAbove)
    local parts = {}
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            parts[#parts+1] = part
            part.Anchored = true
            part.AssemblyLinearVelocity = Vector3.new()
            part.AssemblyAngularVelocity = Vector3.new()
        end
    end

    for _, part in pairs(parts) do
        part.CFrame = cframeAbove + Vector3.new(math.random(-1,1), 0, math.random(-1,1))
    end

    -- small wait to let physics settle
    task.wait(0.3)

    -- unanchor parts
    for _, part in pairs(parts) do
        part.Anchored = false
    end
end

-- Fire ragdoll
local function fireRagdollTouch()
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local ragdollPart = workspace:FindFirstChild("RagdollParts") and workspace.RagdollParts:FindFirstChild("RagdollCollission")
    if hrp and ragdollPart then
        local touchInterest = ragdollPart:FindFirstChildOfClass("TouchTransmitter")
        if touchInterest then
            firetouchinterest(hrp, ragdollPart, 0)
            task.wait()
            firetouchinterest(hrp, ragdollPart, 1)
        end
    end
end

-- Autofarm loop
local function autofarmLoop()
    while runningAutofarm do
        local char = plr.Character
        if not char then
            task.wait(1)
        else
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local spawnFolder = workspace:FindFirstChild("Spawn")
            if hrp and head and spawnFolder then
                local targetPart = workspace:GetChildren()[50]
                local teleportTarget = spawnFolder:GetChildren()[84]
                if targetPart and teleportTarget then
                    fireRagdollTouch()
                    local startTime = tick()
                    while tick()-startTime < slamDuration and runningAutofarm do
                        if not (hrp and head and targetPart) then break end
                        local direction = (targetPart.Position - hrp.Position).Unit
                        local velocity = direction * slamVelocity
                        for _, partName in pairs({"HumanoidRootPart","Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"}) do
                            local part = char:FindFirstChild(partName)
                            if part then
                                part.AssemblyLinearVelocity = velocity + Vector3.new(0,15,0)
                            end
                        end
                        task.wait(0.15)
                    end
                    -- Freeze + safe teleport
                    setFrozen(char,true)
                    safeTeleport(char, teleportTarget.CFrame + Vector3.new(0,10,0))
                    setFrozen(char,false)
                    -- Wait respawn
                    local oldChar = char
                    repeat task.wait(0.5) until not runningAutofarm or (plr.Character ~= oldChar and plr.Character:FindFirstChild("HumanoidRootPart"))
                    if not runningAutofarm then return end
                    task.wait(1)
                    fireRagdollTouch()
                else
                    task.wait(1)
                end
            else
                task.wait(1)
            end
        end
    end
end

-- Auto upgrade
local function autoUpgradeLoop()
    while runningUpgrade do
        Remotes.PurchaseBoneUpgrade:FireServer("Head")
        Remotes.PurchaseBoneUpgrade:FireServer("Torso")
        Remotes.PurchaseBoneUpgrade:FireServer("Arm")
        Remotes.PurchaseBoneUpgrade:FireServer("Leg")
        task.wait(0.2)
    end
end

-- Auto next ragdoll
local function autoNextRagdollLoop()
    while runningNextRagdoll do
        Remotes.PurchaseNextRagdoll:FireServer()
        task.wait(0.5)
    end
end

-- Auto refine
local function autoRefineLoop()
    while runningRefine do
        Remotes.RefineRagdoll:FireServer()
        task.wait(0.5)
    end
end

local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()
 
local Window = Library:CreateWindow{
    Title = `Break your Bones`,
    SubTitle = "by Fatigue",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true, -- Resize this ^ Size according to a 1920x1080 screen, good for mobile users but may look weird on some devices
    MinSize = Vector2.new(470, 380),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl -- Used when theres no MinimizeKeybind
}

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "phosphor-users-bold"
    },
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    }
}

-- Autofarm toggle
local Toggle = Tabs.Main:CreateToggle("AutofarmToggle",{Title="Autofarm",Default=false}):OnChanged(function(v)
    runningAutofarm = v
    if v then task.spawn(autofarmLoop) end
end)

-- Slam Duration
local Slider = Tabs.Main:CreateSlider("SlamDuration",{Title="Slam Duration",Min=5,Max=60,Default=20,Rounding=1}):OnChanged(function(val)
    slamDuration = val
end)

-- Slam Velocity
local Slider = Tabs.Main:CreateSlider("SlamVelocity",{Title="Slam Velocity",Min=50,Max=500,Default=100,Rounding=1}):OnChanged(function(val)
    slamVelocity = val
end)

-- Auto Upgrade Bones
local Toggle = Tabs.Main:CreateToggle("AutoUpgrade",{Title="Auto Upgrade Bones",Default=false}):OnChanged(function(v)
    runningUpgrade = v
    if v then task.spawn(autoUpgradeLoop) end
end)

-- Auto Next Ragdoll
local Toggle = Tabs.Main:CreateToggle("AutoNextRagdoll",{Title="Auto Purchase Next Ragdoll",Default=false}):OnChanged(function(v)
    runningNextRagdoll = v
    if v then task.spawn(autoNextRagdollLoop) end
end)

-- Auto Refine
local Toggle = Tabs.Main:CreateToggle("AutoRefine",{Title="Auto Refine Ragdoll",Default=false}):OnChanged(function(v)
    runningRefine = v
    if v then task.spawn(autoRefineLoop) end
end)

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes{}

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/BreakYourBones")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
