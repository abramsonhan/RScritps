_G.Auto = true --true or false

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Event = ReplicatedStorage.RemoteEvents.CarnivalCompleteShootingGallery

local function findTargets(parent, depth)
    if depth > 3 then return {} end
    
    local targets = {}
    
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("BasePart") then
            table.insert(targets, child)
        end
        
        for _, subTarget in ipairs(findTargets(child, depth + 1)) do
            table.insert(targets, subTarget)
        end
    end
    
    return targets
end

spawn(function()
    while task.wait(3) do
    
        local targets = {}
        local areas = {
            workspace.Map,
            workspace.Items, 
            workspace.Characters
        }
        
        for _, area in ipairs(areas) do
            for _, target in ipairs(findTargets(area, 0)) do
                table.insert(targets, target)
            end
        end
        
        for index, target in ipairs(targets) do
            if not _G.Auto then break end
            
            local success = pcall(function()
                Event:FireServer(target)
            end)
            task.wait(0.05)
        end
    end
end)
