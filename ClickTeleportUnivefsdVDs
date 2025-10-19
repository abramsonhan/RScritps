local player = game.Players.LocalPlayer

-- Function to create and give the teleport tool
local function giveTool()
    local mouse = player:GetMouse()
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "Tp tool (Equip to Click TP)"
    
    tool.Activated:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = mouse.Hit.Position + Vector3.new(0, 2.5, 0)
            player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end)
    
    tool.Parent = player.Backpack
end

-- Give the tool when the player respawns
player.CharacterAdded:Connect(function()
    task.wait(1) -- Wait a bit to ensure the Backpack is ready
    if not player.Backpack:FindFirstChild("Tp tool (Equip to Click TP)") then
        giveTool()
    end
end)

-- Give the tool at the start if the character is already loaded
if player.Character then
    giveTool()
end
