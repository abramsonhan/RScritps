local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Remotes = LocalPlayer:WaitForChild("Remotes")
local HitEvent = Remotes:WaitForChild("HitEvent")

local function getCharacter(player)
	return player and player.Character
end

local function getHumanoid(character)
	return character and character:FindFirstChildOfClass("Humanoid")
end

local function canAttack(player)
	if player == LocalPlayer then return false end
	local character = getCharacter(player)
	local humanoid = getHumanoid(character)
	if humanoid and humanoid.Health > 0 and character and character:FindFirstChild("HumanoidRootPart") then
		return true
	end
	return false
end

local function getClosestPlayer(range)
	local closestPlayer = nil
	local shortestDistance = range

	for _, player in pairs(Players:GetPlayers()) do
		if canAttack(player) then
			local char = player.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if hrp and localHRP then
				local distance = (hrp.Position - localHRP.Position).Magnitude
				if distance < shortestDistance then
					shortestDistance = distance
					closestPlayer = player
				end
			end
		end
	end

	return closestPlayer
end

local ATTACK_RANGE = 20 -- adjust as needed
local ATTACK_COOLDOWN = 0.1 -- seconds between attacks
local lastAttack = 0

RunService.Heartbeat:Connect(function(deltaTime)
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("LeftHand") then return end
	if tick() - lastAttack < ATTACK_COOLDOWN then return end

	local targetPlayer = getClosestPlayer(ATTACK_RANGE)
	if not targetPlayer then return end

	local char = targetPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local rightUpperArm = char and char:FindFirstChild("RightUpperArm")
	local localLeftHand = LocalPlayer.Character:FindFirstChild("LeftHand")

	if hrp and rightUpperArm and localLeftHand then
		lastAttack = tick()
		local args = {
			"HitEvent",
			"Punch",
			{
				Normal = (hrp.CFrame.LookVector).Unit,
				Instance = rightUpperArm,
				Position = hrp.Position
			},
			{
				Limb = localLeftHand,
				NonHit = false,
				Combo = 3
			}
		}
		HitEvent:FireServer(unpack(args))
	end
end)
