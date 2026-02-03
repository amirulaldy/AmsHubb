--==================================
-- AmsHub | Fish It - Complete Rod Database
--==================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local MarketplaceService = game:GetService("MarketplaceService")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

--==================================
-- COMPLETE ROD DATABASE
--==================================
local RodDatabase = {
    -- LEGENDARY RODS
    {
        Name = "Diamond Rod",
        DisplayName = "Diamond Rod",
        Type = "Legendary",
        Speed = 167, -- Percentage
        Weight = 1000000, -- 1M kg
        Value = 5000000,
        Tier = 5,
        Keywords = {"diamond", "legendary", "diamondrod"},
        SpecialAbility = "Increased rare fish chance"
    },
    {
        Name = "Element Rod",
        DisplayName = "Element Rod",
        Type = "Epic",
        Speed = 130, -- Percentage
        Weight = 800, -- kg
        Value = 1000000,
        Tier = 4,
        Keywords = {"element", "epic", "elementrod"},
        SpecialAbility = "Elemental fish attraction"
    },
    {
        Name = "Ghostfinn Rod",
        DisplayName = "Ghostfinn Rod",
        Type = "Rare",
        Speed = 118, -- Percentage
        Weight = 600, -- kg
        Value = 500000,
        Tier = 3,
        Keywords = {"ghostfinn", "ghost", "rare", "ghostfinnrod"},
        SpecialAbility = "Ghost fish detection"
    },
    -- ADD MORE RODS AS DISCOVERED
    {
        Name = "Golden Rod",
        DisplayName = "Golden Rod",
        Type = "Epic",
        Speed = 140,
        Weight = 700,
        Value = 750000,
        Tier = 4,
        Keywords = {"golden", "gold", "goldenrod"},
        SpecialAbility = "Gold fish magnet"
    },
    {
        Name = "Crystal Rod",
        DisplayName = "Crystal Rod",
        Type = "Rare",
        Speed = 125,
        Weight = 550,
        Value = 300000,
        Tier = 3,
        Keywords = {"crystal", "crystalrod"},
        SpecialAbility = "Crystal fish finder"
    },
    {
        Name = "Iron Rod",
        DisplayName = "Iron Rod",
        Type = "Uncommon",
        Speed = 105,
        Weight = 400,
        Value = 100000,
        Tier = 2,
        Keywords = {"iron", "ironrod"},
        SpecialAbility = "None"
    },
    {
        Name = "Wooden Rod",
        DisplayName = "Wooden Rod",
        Type = "Common",
        Speed = 100,
        Weight = 300,
        Value = 50000,
        Tier = 1,
        Keywords = {"wooden", "wood", "woodenrod", "starter"},
        SpecialAbility = "None"
    },
    {
        Name = "Fishing Rod",
        DisplayName = "Basic Fishing Rod",
        Type = "Common",
        Speed = 95,
        Weight = 250,
        Value = 10000,
        Tier = 1,
        Keywords = {"fishing", "basic", "starter", "rod"},
        SpecialAbility = "None"
    }
}

--==================================
-- ADVANCED AUTO FISH SYSTEM
--==================================
local AutoFish = {
    Enabled = false,
    Fishing = false,
    Cooldown = 3,
    LastCast = 0,
    CurrentRod = nil,
    CurrentRodData = nil,
    FishCaught = 0,
    TotalAttempts = 0,
    SuccessRate = 0.7,
    DetectionRange = 50,
    FishingSpots = {},
    
    -- Performance tracking
    StartTime = 0,
    TotalEarnings = 0,
    RareFishCount = 0,
    CommonFishCount = 0
}

--==================================
-- SMART ROD SCANNING SYSTEM
--==================================
local function scanForRods()
    print("[Rod Scanner] Starting comprehensive scan...")
    local foundRods = {}
    
    -- SCAN 1: Character (equipped tools)
    if LP.Character then
        for _, tool in ipairs(LP.Character:GetChildren()) do
            if tool:IsA("Tool") then
                local rodData = identifyRod(tool)
                if rodData then
                    table.insert(foundRods, {
                        Rod = tool,
                        Data = rodData,
                        Location = "Equipped",
                        Priority = 10
                    })
                    print("[Scanner] Found equipped rod:", rodData.DisplayName)
                end
            end
        end
    end
    
    -- SCAN 2: Backpack
    local backpack = LP:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local rodData = identifyRod(tool)
                if rodData then
                    table.insert(foundRods, {
                        Rod = tool,
                        Data = rodData,
                        Location = "Backpack",
                        Priority = rodData.Tier + 5
                    })
                    print("[Scanner] Found rod in backpack:", rodData.DisplayName)
                end
            end
        end
    end
    
    -- SCAN 3: StarterGear
    local starterGear = game:GetService("StarterGear")
    if starterGear then
        for _, tool in ipairs(starterGear:GetChildren()) do
            if tool:IsA("Tool") then
                local rodData = identifyRod(tool)
                if rodData then
                    table.insert(foundRods, {
                        Rod = tool,
                        Data = rodData,
                        Location = "StarterGear",
                        Priority = rodData.Tier
                    })
                    print("[Scanner] Found rod in StarterGear:", rodData.DisplayName)
                end
            end
        end
    end
    
    -- SCAN 4: ReplicatedStorage (game rods)
    local repStorage = game:GetService("ReplicatedStorage")
    if repStorage then
        local toolsFolder = repStorage:FindFirstChild("Tools") or repStorage:FindFirstChild("Rods")
        if toolsFolder then
            for _, tool in ipairs(toolsFolder:GetChildren()) do
                if tool:IsA("Tool") then
                    local rodData = identifyRod(tool)
                    if rodData then
                        table.insert(foundRods, {
                            Rod = tool:Clone(),
                            Data = rodData,
                            Location = "ReplicatedStorage",
                            Priority = rodData.Tier
                        })
                        print("[Scanner] Found rod template:", rodData.DisplayName)
                    end
                end
            end
        end
    end
    
    -- Sort rods by priority (best rod first)
    table.sort(foundRods, function(a, b)
        return a.Priority > b.Priority
    end)
    
    print("[Rod Scanner] Scan complete. Found", #foundRods, "rods")
    return foundRods
end

-- Function to identify rod from database
local function identifyRod(tool)
    if not tool or not tool:IsA("Tool") then return nil end
    
    local toolName = tool.Name:lower()
    local toolDisplayName = tool.Name
    
    -- Check for display name in tool
    if tool:FindFirstChild("DisplayName") then
        toolDisplayName = tool.DisplayName.Value
    end
    
    -- Search database
    for _, rodData in ipairs(RodDatabase) do
        -- Check exact name match
        if toolName == rodData.Name:lower() then
            return rodData
        end
        
        -- Check display name match
        if toolDisplayName:lower() == rodData.DisplayName:lower() then
            return rodData
        end
        
        -- Check keyword match
        for _, keyword in ipairs(rodData.Keywords) do
            if string.find(toolName, keyword:lower()) then
                return rodData
            end
        end
        
        -- Check if tool name contains rod type
        if string.find(toolName, "rod") and string.find(toolName, rodData.Type:lower():sub(1, 4)) then
            return rodData
        end
    end
    
    -- Check if it's a generic fishing tool
    if string.find(toolName, "rod") or string.find(toolName, "fishing") or string.find(toolName, "pole") then
        return {
            Name = tool.Name,
            DisplayName = toolDisplayName,
            Type = "Unknown",
            Speed = 100,
            Weight = 300,
            Value = 10000,
            Tier = 1,
            Keywords = {"generic"},
            SpecialAbility = "Unknown"
        }
    end
    
    return nil
end

--==================================
-- ROD MANAGEMENT SYSTEM
--==================================
local function findBestRod()
    local rods = scanForRods()
    
    if #rods == 0 then
        print("[Rod Manager] No rods found!")
        return nil, nil
    end
    
    -- Get the best rod (highest priority/tier)
    local bestRod = rods[1]
    print("[Rod Manager] Best rod found:", bestRod.Data.DisplayName)
    print("  Type:", bestRod.Data.Type)
    print("  Speed:", bestRod.Data.Speed .. "%")
    print("  Weight:", bestRod.Data.Weight .. "kg")
    print("  Value:", "$" .. bestRod.Data.Value)
    print("  Location:", bestRod.Location)
    
    return bestRod.Rod, bestRod.Data
end

local function equipBestRod()
    local rod, rodData = findBestRod()
    
    if not rod then
        print("[Rod Manager] Cannot equip: No rod found")
        return false
    end
    
    -- Check if already equipped
    if rod.Parent == LP.Character then
        print("[Rod Manager] Rod already equipped")
        AutoFish.CurrentRod = rod
        AutoFish.CurrentRodData = rodData
        return true
    end
    
    -- Try to equip
    local success = pcall(function()
        -- Unequip current tool if any
        if LP.Character then
            for _, tool in ipairs(LP.Character:GetChildren()) do
                if tool:IsA("Tool") and tool ~= rod then
                    tool.Parent = LP.Backpack
                end
            end
        end
        
        -- Equip the rod
        rod.Parent = LP.Character
        
        -- Wait for equip
        local startTime = tick()
        while tick() - startTime < 2 and rod.Parent ~= LP.Character do
            RunService.Heartbeat:Wait()
        end
        
        if rod.Parent == LP.Character then
            print("[Rod Manager] Successfully equipped:", rodData.DisplayName)
            AutoFish.CurrentRod = rod
            AutoFish.CurrentRodData = rodData
            
            -- Update cooldown based on rod speed
            AutoFish.Cooldown = math.max(1, 3 * (100 / rodData.Speed))
            print("[Rod Manager] Adjusted cooldown to:", AutoFish.Cooldown .. "s")
            
            return true
        end
    end)
    
    if not success then
        print("[Rod Manager] Failed to equip rod")
        return false
    end
    
    return true
end

--==================================
-- ENHANCED FISHING SYSTEM
--==================================
local function calculateCatchChance()
    if not AutoFish.CurrentRodData then return 0.7 end
    
    local baseChance = 0.7
    local rodBonus = (AutoFish.CurrentRodData.Tier - 1) * 0.05
    local speedBonus = (AutoFish.CurrentRodData.Speed - 100) * 0.001
    
    return math.min(0.95, baseChance + rodBonus + speedBonus)
end

local function simulateFishingWithRod()
    if not LP.Character or not AutoFish.CurrentRod then return false end
    
    local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    print("[Fishing] Using", AutoFish.CurrentRodData.DisplayName)
    print("  Speed:", AutoFish.CurrentRodData.Speed .. "%")
    print("  Catch chance:", math.floor(calculateCatchChance() * 100) .. "%")
    
    -- Visual feedback based on rod tier
    local tierColor = {
        [1] = Color3.fromRGB(139, 69, 19), -- Brown (Common)
        [2] = Color3.fromRGB(192, 192, 192), -- Silver (Uncommon)
        [3] = Color3.fromRGB(255, 215, 0), -- Gold (Rare)
        [4] = Color3.fromRGB(128, 0, 128), -- Purple (Epic)
        [5] = Color3.fromRGB(0, 255, 255)  -- Cyan (Legendary)
    }
    
    -- Create fishing effect
    if AutoFish.CurrentRod:FindFirstChild("Handle") then
        local handle = AutoFish.CurrentRod.Handle
        
        -- Tier-based glow effect
        local glow = Instance.new("PointLight", handle)
        glow.Brightness = AutoFish.CurrentRodData.Tier * 0.5
        glow.Range = 5
        glow.Color = tierColor[AutoFish.CurrentRodData.Tier] or Color3.new(1,1,1)
        
        -- Casting animation
        for i = 1, 10 do
            handle.CFrame = handle.CFrame * CFrame.new(0, 0, -0.5)
            RunService.Heartbeat:Wait()
        end
        
        task.wait(0.5)
        glow:Destroy()
    end
    
    return true
end

--==================================
-- MAIN FISHING LOOP
--==================================
local fishConnection
local function startSmartFishing()
    if fishConnection then fishConnection:Disconnect() end
    
    -- First, find and equip best rod
    if not equipBestRod() then
        print("[Auto Fish] ERROR: Cannot start without a rod!")
        AutoFish.Enabled = false
        return
    end
    
    AutoFish.Fishing = true
    AutoFish.StartTime = tick()
    
    print("[Auto Fish] Starting with", AutoFish.CurrentRodData.DisplayName)
    print("  Type:", AutoFish.CurrentRodData.Type)
    print("  Special:", AutoFish.CurrentRodData.SpecialAbility)
    
    fishConnection = RunService.Heartbeat:Connect(function()
        if not AutoFish.Enabled or not AutoFish.Fishing then
            fishConnection:Disconnect()
            return
        end
        
        local now = tick()
        if now - AutoFish.LastCast >= AutoFish.Cooldown then
            AutoFish.LastCast = now
            AutoFish.TotalAttempts = AutoFish.TotalAttempts + 1
            
            -- Cast with current rod
            local castSuccess = simulateFishingWithRod()
            if not castSuccess then return end
            
            -- Wait for bite with rod-speed adjusted time
            local waitTime = math.random(2, 4) * (100 / AutoFish.CurrentRodData.Speed)
            task.wait(waitTime)
            
            -- Calculate catch chance
            local catchChance = calculateCatchChance()
            local random = math.random()
            
            if random <= catchChance then
                -- Fish caught!
                AutoFish.FishCaught = AutoFish.FishCaught + 1
                
                -- Determine fish rarity based on rod
                local isRare = random <= (catchChance * 0.3)
                if isRare and AutoFish.CurrentRodData.Tier >= 3 then
                    AutoFish.RareFishCount = AutoFish.RareFishCount + 1
                    print("[Auto Fish] 🎣 RARE FISH CAUGHT!")
                else
                    AutoFish.CommonFishCount = AutoFish.CommonFishCount + 1
                    print("[Auto Fish] 🐟 Fish caught!")
                end
                
                -- Calculate earnings
                local baseValue = AutoFish.CurrentRodData.Value * 0.01
                local multiplier = isRare and 5 or 1
                local earnings = math.floor(baseValue * multiplier)
                AutoFish.TotalEarnings = AutoFish.TotalEarnings + earnings
                
                -- Reel animation
                task.wait(1)
                
            else
                print("[Auto Fish] No bite this time")
            end
            
            -- Update UI
            if AutoFishUI then
                AutoFishUI.updateStats()
            end
        end
    end)
end

--==================================
-- (KEEP THE REST OF YOUR ORIGINAL CODE FOR TELEPORT, UI, ETC)
-- JUST REPLACE THE AUTO FISH FUNCTIONS WITH THESE ENHANCED VERSIONS
--==================================

--==================================
-- ENHANCED AUTO FISH UI
--==================================
-- In your Auto Fish Panel, add these displays:

local function createEnhancedAutoFishUI()
    -- ... (your existing UI creation code)
    
    -- Add Rod Info Card
    local RodInfoCard = Instance.new("Frame", Panels.AutoFishPanel)
    RodInfoCard.Size = UDim2.new(1,-20,0,100)
    RodInfoCard.Position = UDim2.new(0,10,0,130)
    RodInfoCard.BackgroundColor3 = Color3.fromRGB(30,30,40)
    Instance.new("UICorner", RodInfoCard).CornerRadius = UDim.new(0,10)

    local RodTitle = Instance.new("TextLabel", RodInfoCard)
    RodTitle.Size = UDim2.new(1,-20,0,30)
    RodTitle.Position = UDim2.new(0,10,0,5)
    RodTitle.Text = "CURRENT ROD"
    RodTitle.TextColor3 = Color3.fromRGB(200,200,255)
    RodTitle.Font = Enum.Font.GothamBold
    RodTitle.TextSize = 14
    RodTitle.BackgroundTransparency = 1
    RodTitle.TextXAlignment = Enum.TextXAlignment.Left

    local RodNameText = Instance.new("TextLabel", RodInfoCard)
    RodNameText.Name = "RodNameText"
    RodNameText.Size = UDim2.new(1,-20,0,25)
    RodNameText.Position = UDim2.new(0,10,0,35)
    RodNameText.Text = "None"
    RodNameText.TextColor3 = Color3.new(1,1,1)
    RodNameText.Font = Enum.Font.GothamBold
    RodNameText.TextSize = 16
    RodNameText.BackgroundTransparency = 1
    RodNameText.TextXAlignment = Enum.TextXAlignment.Left

    local RodStatsText = Instance.new("TextLabel", RodInfoCard)
    RodStatsText.Name = "RodStatsText"
    RodStatsText.Size = UDim2.new(1,-20,0,40)
    RodStatsText.Position = UDim2.new(0,10,0,60)
    RodStatsText.Text = "Speed: 0%\nWeight: 0kg"
    RodStatsText.TextColor3 = Color3.fromRGB(180,180,200)
    RodStatsText.Font = Enum.Font.Gotham
    RodStatsText.TextSize = 12
    RodStatsText.BackgroundTransparency = 1
    RodStatsText.TextXAlignment = Enum.TextXAlignment.Left
    RodStatsText.TextYAlignment = Enum.TextYAlignment.Top
    
    -- Update the updateStats function:
    AutoFishUI.updateStats = function()
        -- ... (your existing update code)
        
        -- Update rod info
        if AutoFish.CurrentRodData then
            local tierColor = {
                [1] = Color3.fromRGB(139, 69, 19),    -- Brown
                [2] = Color3.fromRGB(192, 192, 192),  -- Silver
                [3] = Color3.fromRGB(255, 215, 0),    -- Gold
                [4] = Color3.fromRGB(128, 0, 128),    -- Purple
                [5] = Color3.fromRGB(0, 255, 255)     -- Cyan
            }
            
            RodNameText.Text = AutoFish.CurrentRodData.DisplayName
            RodNameText.TextColor3 = tierColor[AutoFish.CurrentRodData.Tier] or Color3.new(1,1,1)
            
            RodStatsText.Text = string.format("Type: %s\nSpeed: %d%%\nWeight: %s kg",
                AutoFish.CurrentRodData.Type,
                AutoFish.CurrentRodData.Speed,
                formatNumber(AutoFish.CurrentRodData.Weight))
        else
            RodNameText.Text = "No Rod"
            RodNameText.TextColor3 = Color3.fromRGB(150,150,150)
            RodStatsText.Text = "Scan for rods first"
        end
        
        -- Update earnings
        EarningsText.Text = string.format("Earnings: $%s\nRare: %d | Common: %d",
            formatNumber(AutoFish.TotalEarnings),
            AutoFish.RareFishCount,
            AutoFish.CommonFishCount)
    end
end

-- Helper function to format large numbers
local function formatNumber(num)
    if num >= 1000000 then
        return string.format("%.1fM", num/1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num/1000)
    else
        return tostring(num)
    end
end

--==================================
-- INITIALIZATION
--==================================
-- Add this to your initialization:
task.wait(2) -- Wait for game to load
print("🎣 Loading Fish It Rod Database...")
print("Supported rods:")
for _, rod in ipairs(RodDatabase) do
    print(string.format("  %s (%s) - Speed: %d%%, Weight: %dkg",
        rod.DisplayName, rod.Type, rod.Speed, rod.Weight))
end

-- Initial scan
local rods = scanForRods()
if #rods > 0 then
    print("✅ Found", #rods, "rods")
    equipBestRod()
else
    print("⚠️ No rods found. Make sure you have a fishing rod!")
end
