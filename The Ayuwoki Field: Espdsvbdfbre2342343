getgenv().espPlayers = false
getgenv().espAyuwoki = false
getgenv().fullbright = false
local distance
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
Rayfield:Notify({
   Title = "Changelog: 1.1",
   Content = "Made the code less complex. Yeah, that's it.",
   Duration = 6,
   Image = "vibrate",
})
local main = Rayfield:CreateWindow({
   Name = "Ayucocky Keyless",
   Icon = "square-user",
   LoadingTitle = "I woke up...",
   LoadingSubtitle = "by TritiDium",
   ShowText = "Ayucocky",
   Theme = "Default",

   ToggleUIKeybind = "H",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "tritidiumscripts",
      FileName = "ayucocky"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local firstTab = main:CreateTab("Game", 4483362458)
local timerSection = firstTab:CreateSection("time")
local distSection = firstTab:CreateSection("distance")
local lastErrorTime = {}

local healthPercent
local function playerEsp()
    for i,v in pairs(game.Players:GetPlayers()) do
        if v.Character and v:HasAppearanceLoaded() then
            if v.Character:FindFirstChild("Humanoid") then
                healthPercent = v.Character.Humanoid.Health / v.Character.Humanoid.MaxHealth
            else
                
            end
            if not v.Character:FindFirstChild("plrESP") then
                print("No ESP for player ".. v.Name .. " present, creating new...")
                local plrEsp = Instance.new("Highlight")
                plrEsp.Parent = v.Character
                plrEsp.Name = "plrESP"
                plrEsp.Adornee = v.Character
            else
                if healthPercent ~= nil and v.Character:FindFirstChild("plrESP") then
                    v.Character:FindFirstChild("plrESP").Enabled = getgenv().espPlayers
                    if v.Character:FindFirstChild("Humanoid") then
                        if v.Character.Humanoid.Health <= 0 then
                            v.Character:FindFirstChild("plrESP").FillColor = Color3.new(0, 0, 0)
                            v.Character:FindFirstChild("plrESP").OutlineColor = Color3.new(0, 0, 0)
                        else
                            v.Character:FindFirstChild("plrESP").FillColor = Color3.new(1 - healthPercent, healthPercent, 0)
                            v.Character:FindFirstChild("plrESP").OutlineColor = Color3.new(1 - healthPercent - 0.1, healthPercent - 0.1, 0)
                        end
                    else
                        
                    end
                end
            end
        else
            local now = tick()
            if not lastErrorTime[v] or now - lastErrorTime[v] >= 15 then
                print("Can't create ESP for player ".. v.Name.. ", player isn't loaded. Retrying in 15 seconds...")
                lastErrorTime[v] = now
            end
        end
    end
end
game.ReplicatedStorage.Values.Timer:GetPropertyChangedSignal("Value"):Connect(function()
    if game.ReplicatedStorage.Values.Day.Value == true then
        timerSection:Set(tostring(game.ReplicatedStorage.Values.Timer.Value).. " seconds till night")
    else
        timerSection:Set(tostring(game.ReplicatedStorage.Values.Timer.Value).. " seconds till day")
    end
end)
game.ReplicatedStorage.Values.Rage:GetPropertyChangedSignal("Value"):Connect(function()
    if game.Workspace:FindFirstChild("Ayuwoki"):FindFirstChild("AyuwokiESP") then
        game.Workspace:FindFirstChild("Ayuwoki"):FindFirstChild("AyuwokiESP").OutlineColor = Color3.new(game.ReplicatedStorage.Values.Rage.Value/10,0,0)
        game.Workspace:FindFirstChild("Ayuwoki"):FindFirstChild("AyuwokiESP").FillColor = Color3.new(game.ReplicatedStorage.Values.Rage.Value/10 + 0.1,0,0)
    else
        print("No ayuwoki model present, can't change ESP's parameters")
    end
end)
local infoDiv = firstTab:CreateDivider()
local espAyuwoki = firstTab:CreateToggle({
   Name = "Ayuwoki ESP",
   CurrentValue = false,
   Flag = "esp1",
   Callback = function(Value)
       getgenv().espAyuwoki = Value
   end,
})
local espPlayers = firstTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Flag = "esp2",
   Callback = function(Value)
       getgenv().espPlayers = Value
   end,
})
local fullbrightBtn = firstTab:CreateToggle({
   Name = "Fullbright",
   CurrentValue = false,
   Flag = "fullbright",
   Callback = function(Value)
       getgenv().fullbright = Value
   end,
})
local distErrorCount = 0
local lastDistErrorTime = 0
local distCooldownUntil = 0

game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().fullbright == true then
        game.Lighting.ClockTime = 12
        game.Lighting.Ambient = Color3.new(1,1,1)
        game.Lighting.FogEnd = 1000
    else
        game.Lighting.ClockTime = 0
        game.Lighting.Ambient = Color3.new(0,0,0)
        game.Lighting.FogEnd = 60
    end

    if game.Workspace:FindFirstChild("Ayuwoki") then
        if not game.Workspace:FindFirstChild("Ayuwoki"):FindFirstChild("AyuwokiESP") then
            print("No ESP present, creating new...")
            local ayuwokiEsp = Instance.new("Highlight")
            ayuwokiEsp.Parent = game.Workspace:FindFirstChild("Ayuwoki")
            ayuwokiEsp.Name = "AyuwokiESP"
            ayuwokiEsp.Adornee = game.Workspace:FindFirstChild("Ayuwoki")
        else
            game.Workspace:FindFirstChild("Ayuwoki"):FindFirstChild("AyuwokiESP").Enabled = getgenv().espAyuwoki
            if game.Players.LocalPlayer.Character and game.Workspace:FindFirstChild("Ayuwoki") then
                distance = (game.Workspace:FindFirstChild("Ayuwoki"):GetBoundingBox().Position - game.Players.LocalPlayer.Character:GetBoundingBox().Position).Magnitude
            end
        end

        if distance ~= nil then
            distSection:Set("The Ayuwoki is " .. math.round(distance) .. " studs from you")
            distErrorCount = 0
        else
            local now = tick()
            if now >= distCooldownUntil then
                if now - lastDistErrorTime >= 5 then
                    distErrorCount += 1
                    if distErrorCount < 3 then
                        print("No distance present. The player wasn't loaded or the Ayuwoki doesn't exist yet. Retrying in 5 seconds.")
                    else
                        print("Too many distance errors! Pausing messages for 15 seconds...")
                        distCooldownUntil = now + 15
                        distErrorCount = 0
                    end
                    lastDistErrorTime = now
                end
            end
        end
    else
        distSection:Set("He's gone.")
    end

    playerEsp()
end)
