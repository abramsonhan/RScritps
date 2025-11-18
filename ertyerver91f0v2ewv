local lp = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local chars = workspace:WaitForChild("Characters")

local enabled = true
local range = 20
local count = 0



local function getTool()
	return lp:WaitForChild("Inventory"):FindFirstChild("Old Axe")
		or lp.Inventory:FindFirstChild("Good Axe")
		or lp.Inventory:FindFirstChild("Strong Axe")
		or lp.Inventory:FindFirstChild("Chainsaw")
end

local function damage(t, tool)
	if not tool then return end
	local evt = rs:FindFirstChild("RemoteEvents") and rs.RemoteEvents:FindFirstChild("ToolDamageObject")
	if not evt then return end
	evt:InvokeServer(t, tool, tostring(count).."_7367831688", t:FindFirstChild("HumanoidRootPart") and t.HumanoidRootPart.CFrame or CFrame.new())
end

uis.InputBegan:Connect(function(i, g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.X then
		enabled = not enabled
	end
end)

task.spawn(function()
	while true do
		task.wait()
		if not enabled then continue end

		local tool = getTool()
		if not tool or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then continue end

		for _, v in ipairs(chars:GetChildren()) do
			if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v ~= lp.Character then
				local d = (v.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
				if d <= range then
					count += 1
					damage(v, tool)
				end
			end
		end
	end
end)
--Remember it only works with Axe Tool.
