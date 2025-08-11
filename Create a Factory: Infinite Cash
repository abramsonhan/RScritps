-- Auto-set ReplicatedStorage.Gears.NoneGear.Value to infinity
local RS = game:GetService("ReplicatedStorage")

-- Wait for all the parts of the path to load
local Gears = RS:WaitForChild("Gears", 10)
local NoneGear = Gears:WaitForChild("NoneGear", 10)
local ValueObj = NoneGear:WaitForChild("Value", 10)

-- Function to set to infinity
local function setInf()
    if ValueObj:IsA("NumberValue") then
        ValueObj.Value = math.huge
    elseif ValueObj:IsA("IntValue") then
        ValueObj.Value = 999999999
    else
        warn("Value is not a NumberValue/IntValue")
    end
end

-- Initial set
setInf()

-- Keep forcing if game changes it
ValueObj.Changed:Connect(function()
    task.wait(0.01)
    setInf()
end)

-- Extra backup loop
while task.wait(1) do
    setInf()
end
