--==================================
-- AmsHub | Fish It - Advanced Auto Fishing
-- Auto Detect Rod + Custom Fishing System
--==================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

--==================================
-- ADVANCED AUTO FISH SYSTEM
--==================================
local AutoFish = {
    Enabled = false,
    Fishing = false,
    Cooldown = 3, -- seconds between casts
    LastCast = 0,
    CurrentRod = nil,
    RodTypes = {"FishingRod", "Rod", "WoodenRod", "IronRod", "GoldenRod", "DragonRod", "LegendaryRod"},
    FishCaught = 0,
    TotalAttempts = 0,
    SuccessRate = 0.7, -- 70% default
    DetectionRange = 50, -- Range to detect fishing spots
    FishingSpots = {}
}

--==================================
-- ROD DETECTION SYSTEM
--==================================
local function findFishingRod()
    print("[Rod Detection] Scanning for fishing rods...")
    
    -- Priority 1: Check character's hand
    if LP.Character then
        for _, rodName in ipairs(AutoFish.RodTypes) do
            local rod = LP.Character:FindFirstChild(rodName)
            if rod and rod:IsA("Tool") then
                print("[Rod Detection] Found equipped rod:", rod.Name)
                AutoFish.CurrentRod = rod
                return rod
            end
        end
        
        -- Check any tool that might be a rod
        for _, tool in ipairs(LP.Character:GetChildren()) do
            if tool:IsA("Tool") and (string.find(tool.Name:lower(), "rod") or 
               string.find(tool.Name:lower(), "fishing") or
               string.find(tool.Name:lower(), "pole")) then
                print("[Rod Detection] Found fishing tool:", tool.Name)
                AutoFish.CurrentRod = tool
                return tool
            end
        end
    end
    
    -- Priority 2: Check backpack
    local backpack = LP:FindFirstChild("Backpack")
    if backpack then
        for _, rodName in ipairs(AutoFish.RodTypes) do
            local rod = backpack:FindFirstChild(rodName)
            if rod and rod:IsA("Tool") then
                print("[Rod Detection] Found rod in backpack:", rod.Name)
                AutoFish.CurrentRod = rod
                return rod
            end
        end
        
        -- Search for any tool that looks like a rod
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                -- Check tool name or description
                if string.find(tool.Name:lower(), "rod") or 
                   string.find(tool.Name:lower(), "fishing") or
                   (tool:FindFirstChild("Handle") and tool.Handle:FindFirstChildWhichIsA("SpecialMesh")) then
                    print("[Rod Detection] Found potential fishing tool:", tool.Name)
                    AutoFish.CurrentRod = tool
                    return tool
                end
            end
        end
    end
    
    -- Priority 3: Check if player has fishing rod in starter gear
    local starterGear = game:GetService("StarterGear")
    if starterGear then
        for _, rodName in ipairs(AutoFish.RodTypes) do
            local rod = starterGear:FindFirstChild(rodName)
            if rod and rod:IsA("Tool") then
                print("[Rod Detection] Found rod in StarterGear:", rod.Name)
                AutoFish.CurrentRod = rod
                return rod
            end
        end
    end
    
    print("[Rod Detection] No fishing rod found!")
    return nil
end

--==================================
-- ADVANCED ROD EQUIP SYSTEM
--==================================
local function equipRod(rod)
    if not rod or not LP.Character then return false end
    
    -- Check if already equipped
    if rod.Parent == LP.Character then
        print("[Rod Equip] Rod already equipped")
        return true
    end
    
    -- Try to equip the rod
    local success = pcall(function()
        -- Store current tool if any
        local currentTool = nil
        for _, tool in ipairs(LP.Character:GetChildren()) do
            if tool:IsA("Tool") then
                currentTool = tool
                break
            end
        end
        
        -- Equip the rod
        rod.Parent = LP.Character
        
        -- Wait for rod to be equipped
        local startTime = tick()
        while tick() - startTime < 2 and rod.Parent ~= LP.Character do
            RunService.Heartbeat:Wait()
        end
        
        if rod.Parent == LP.Character then
            print("[Rod Equip] Successfully equipped:", rod.Name)
            
            -- Put previous tool back in backpack if needed
            if currentTool and currentTool ~= rod then
                currentTool.Parent = LP.Backpack
            end
            
            return true
        end
    end)
    
    if not success then
        print("[Rod Equip] Failed to equip rod")
    end
    
    return success
end

--==================================
-- FISHING SPOT DETECTION
--==================================
local function findFishingSpots()
    local spots = {}
    local character = LP.Character
    if not character then return spots end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return spots end
    
    local position = hrp.Position
    
    -- Look for water parts
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("Part") or part:IsA("MeshPart") then
            -- Check if it's water (blue color or named water)
            if part.Name:lower():find("water") or 
               part.Name:lower():find("river") or 
               part.Name:lower():find("lake") or
               part.Name:lower():find("ocean") or
               part.Name:lower():find("sea") or
               (part.Material == Enum.Material.Water) or
               (part.Color.r < 0.3 and part.Color.b > 0.5) then -- Blueish color
                
                local distance = (position - part.Position).Magnitude
                if distance <= AutoFish.DetectionRange then
                    table.insert(spots, {
                        Part = part,
                        Position = part.Position,
                        Distance = distance
                    })
                end
            end
        end
    end
    
    -- Look for fishing spot markers
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") and (obj.Name:find("Fish") or obj.Name:find("Fishing") or obj.Name:find("Spot")) then
            local distance = (position - obj.Position).Magnitude
            if distance <= AutoFish.DetectionRange then
                table.insert(spots, {
                    Part = obj,
                    Position = obj.Position,
                    Distance = distance,
                    IsMarker = true
                })
            end
        end
    end
    
    print("[Spot Detection] Found", #spots, "fishing spots")
    return spots
end

--==================================
-- SMART FISHING SIMULATION
--==================================
local function simulateFishingCast()
    if not LP.Character then return false end
    if not AutoFish.CurrentRod then return false end
    
    local character = LP.Character
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    print("[Fishing] Simulating cast...")
    
    -- Step 1: Find best fishing spot
    AutoFish.FishingSpots = findFishingSpots()
    if #AutoFish.FishingSpots == 0 then
        print("[Fishing] No fishing spots found nearby!")
        return false
    end
    
    -- Sort spots by distance
    table.sort(AutoFish.FishingSpots, function(a, b)
        return a.Distance < b.Distance
    end)
    
    local targetSpot = AutoFish.FishingSpots[1]
    
    -- Step 2: Face the fishing spot
    local lookVector = (targetSpot.Position - hrp.Position).Unit
    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookVector.X, 0, lookVector.Z))
    
    -- Step 3: Animate fishing cast (visual feedback)
    if character:FindFirstChild("Humanoid") then
        -- Play fishing animation if available
        local humanoid = character.Humanoid
        humanoid:LoadAnimation(Instance.new("Animation")):Play() -- Placeholder
    end
    
    -- Step 4: Visual rod swing
    if AutoFish.CurrentRod:FindFirstChild("Handle") then
        local handle = AutoFish.CurrentRod.Handle
        local originalPosition = handle.Position
        
        -- Simulate casting motion
        for i = 1, 10 do
            handle.CFrame = handle.CFrame * CFrame.new(0, 0, -0.5)
            RunService.Heartbeat:Wait()
        end
        
        task.wait(0.2)
        
        -- Return to original position
        handle.CFrame = CFrame.new(originalPosition)
    end
    
    print("[Fishing] Cast completed at spot:", targetSpot.Part.Name)
    return true
end

local function simulateFishBite()
    print("[Fishing] Waiting for bite...")
    
    -- Simulate wait time (2-5 seconds)
    local waitTime = math.random(2, 5)
    task.wait(waitTime)
    
    -- Determine if fish bites (based on success rate)
    AutoFish.TotalAttempts = AutoFish.TotalAttempts + 1
    local biteChance = math.random()
    
    if biteChance <= AutoFish.SuccessRate then
        print("[Fishing] Fish bite detected!")
        return true
    else
        print("[Fishing] No bite this time")
        return false
    end
end

local function simulateReelIn()
    print("[Fishing] Reeling in...")
    
    -- Visual feedback
    if AutoFish.CurrentRod and AutoFish.CurrentRod:FindFirstChild("Handle") then
        local handle = AutoFish.CurrentRod.Handle
        
        -- Reeling animation
        for i = 1, 15 do
            handle.CFrame = handle.CFrame * CFrame.new(0, 0, 0.3)
            RunService.Heartbeat:Wait()
        end
    end
    
    task.wait(0.5)
    
    -- Increment fish count
    AutoFish.FishCaught = AutoFish.FishCaught + 1
    print("[Fishing] Fish caught! Total:", AutoFish.FishCaught)
    
    return true
end

--==================================
-- MAIN AUTO FISHING LOOP
--==================================
local fishConnection
local function startAdvancedAutoFishing()
    if fishConnection then fishConnection:Disconnect() end
    
    AutoFish.Fishing = true
    
    -- Find and equip rod first
    local rod = findFishingRod()
    if not rod then
        print("[Auto Fish] ERROR: No fishing rod found!")
        AutoFish.Enabled = false
        return
    end
    
    equipRod(rod)
    
    fishConnection = RunService.Heartbeat:Connect(function()
        if not AutoFish.Enabled or not AutoFish.Fishing then
            fishConnection:Disconnect()
            return
        end
        
        local now = tick()
        if now - AutoFish.LastCast >= AutoFish.Cooldown then
            AutoFish.LastCast = now
            
            -- Fishing Process
            local castSuccess = simulateFishingCast()
            if not castSuccess then
                print("[Auto Fish] Cast failed, trying again...")
                return
            end
            
            -- Wait for bite
            local biteSuccess = simulateFishBite()
            if biteSuccess then
                -- Reel in the fish
                simulateReelIn()
            else
                -- Reel back anyway
                task.wait(1)
                print("[Auto Fish] Recasing...")
            end
            
            -- Update UI
            if AutoFishUI then
                AutoFishUI.updateStats()
            end
        end
    end)
end

local function stopAdvancedAutoFishing()
    AutoFish.Fishing = false
    if fishConnection then
        fishConnection:Disconnect()
        fishConnection = nil
    end
    print("[Auto Fish] Stopped")
end

--==================================
-- CHARACTER UTILS
--==================================
local function getHRP()
    local char = LP.Character or LP.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

--==================================
-- TELEPORT SETTINGS (FAST, NO FREEZE)
--==================================
local TELEPORT_OFFSET = Vector3.new(0, 3, 0)
local TELEPORT_TIME = 0.04

--==================================
-- TELEPORT DATA
--==================================
local Teleports = {
    -- ISLAND
    {name="Fisherman Island", cat="Island", cf=CFrame.new(197.34857177734375, 2.6072463989257812, 2796.57373046875)},
    {name="Kohana", cat="Island", cf=CFrame.new(-624.4239501953125, 7.744749546051025, 676.2808227539062)},
    {name="Tropical Grove", cat="Island", cf=CFrame.new(-2033.400146484375, 6.2680158615112305, 3715.0341796875)},
    {name="Ancient Jungle", cat="Island", cf=CFrame.new(1463.75439453125, 7.6254987716674805, -321.6741943359375)},
    {name="Creater Island", cat="Island", cf=CFrame.new(1012.2926635742188, 3.6445138454437256, 5153.46435546875)},

    -- DEPTH
    {name="Coral Reefs", cat="Depth", cf=CFrame.new(-2920.48095703125, 3.2499992847442627, 2072.742919921875)},
    {name="Esoteric Depths", cat="Depth", cf=CFrame.new(3208.166259765625, -1302.8551025390625, 1446.6112060546875)},
    {name="Crystal Depths", cat="Depth", cf=CFrame.new(5637, -904.9847412109375, 15354)},
    {name="Kohana Volcano", cat="Depth", cf=CFrame.new(-424.22802734375, 7.2453107833862305, 123.47695922851562)},

    -- SECRET
    {name="Ancient Ruin", cat="Secret", cf=CFrame.new(6098.16845703125, -585.92431640625, 4649.107421875)},
    {name="Sacred Temple", cat="Secret", cf=CFrame.new(1467.5760498046875, -22.1250057220459, -651.3453979492188)},
    {name="Treasure Room", cat="Secret", cf=CFrame.new(-3631.212646484375, -279.07427978515625, -1599.5411376953125)},
    {name="Pirate Cove", cat="Secret", cf=CFrame.new(3474.528076171875, 4.192470550537109, 3489.54150390625)},
    {name="Pirate Treasure Room", cat="Secret", cf=CFrame.new(3301.19775390625, -305.0702819824219, 3039.332763671875)},
    {name="Sisyphus Statue", cat="Secret", cf=CFrame.new(-3785.260009765625, -135.07435607910156, -951.13818359375)},
}

--==================================
-- FAST SMOOTH TELEPORT
--==================================
local function fastSmoothTeleport(cf)
    local hrp = getHRP()
    local targetCF = cf + TELEPORT_OFFSET

    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(TELEPORT_TIME, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
        {CFrame = targetCF}
    )
    tween:Play()
end

--==================================
-- UI CREATION
--==================================
local gui = Instance.new("ScreenGui")
gui.Name = "AmsHubAdvanced"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

-- MAIN FRAME
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 600, 0, 450) -- Increased size
Main.Position = UDim2.new(0.5,-300,0.5,-225)
Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

-- TITLE BAR
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,36)
Title.Text = "🎣 AmsHub | Advanced Auto Fish"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local TitlePadding = Instance.new("UIPadding")
TitlePadding.PaddingLeft = UDim.new(0,12)
TitlePadding.Parent = Title

-- SIDEBAR
local Side = Instance.new("Frame", Main)
Side.Position = UDim2.new(0,0,0,36)
Side.Size = UDim2.new(0,150,1,-36)
Side.BackgroundColor3 = Color3.fromRGB(20,20,20)

-- CONTENT
local Content = Instance.new("Frame", Main)
Content.Position = UDim2.new(0,150,0,36)
Content.Size = UDim2.new(1,-150,1,-36)
Content.BackgroundColor3 = Color3.fromRGB(10,10,10)

--==================================
-- SIDEBAR MENU
--==================================
local MenuButtons = {
    TeleportBtn = nil,
    AutoFishBtn = nil
}

MenuButtons.TeleportBtn = Instance.new("TextButton", Side)
MenuButtons.TeleportBtn.Name = "TeleportBtn"
MenuButtons.TeleportBtn.Size = UDim2.new(1,-10,0,40)
MenuButtons.TeleportBtn.Position = UDim2.new(0,5,0,10)
MenuButtons.TeleportBtn.Text = "📍 TELEPORT"
MenuButtons.TeleportBtn.Font = Enum.Font.GothamBold
MenuButtons.TeleportBtn.TextSize = 14
MenuButtons.TeleportBtn.TextColor3 = Color3.new(1,1,1)
MenuButtons.TeleportBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
Instance.new("UICorner", MenuButtons.TeleportBtn).CornerRadius = UDim.new(0,8)

MenuButtons.AutoFishBtn = Instance.new("TextButton", Side)
MenuButtons.AutoFishBtn.Name = "AutoFishBtn"
MenuButtons.AutoFishBtn.Size = UDim2.new(1,-10,0,40)
MenuButtons.AutoFishBtn.Position = UDim2.new(0,5,0,60)
MenuButtons.AutoFishBtn.Text = "🎣 AUTO FISH"
MenuButtons.AutoFishBtn.Font = Enum.Font.GothamBold
MenuButtons.AutoFishBtn.TextSize = 14
MenuButtons.AutoFishBtn.TextColor3 = Color3.new(1,1,1)
MenuButtons.AutoFishBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", MenuButtons.AutoFishBtn).CornerRadius = UDim.new(0,8)

--==================================
-- AUTO FISH UI
--==================================
local AutoFishUI = {
    Panel = nil,
    updateStats = function() end
}

Panels = {}
Panels.TeleportPanel = Instance.new("Frame", Content)
Panels.TeleportPanel.Name = "TeleportPanel"
Panels.TeleportPanel.Size = UDim2.new(1,0,1,0)
Panels.TeleportPanel.BackgroundTransparency = 1
Panels.TeleportPanel.Visible = true

-- Auto Fish Panel
Panels.AutoFishPanel = Instance.new("Frame", Content)
Panels.AutoFishPanel.Name = "AutoFishPanel"
Panels.AutoFishPanel.Size = UDim2.new(1,0,1,0)
Panels.AutoFishPanel.BackgroundTransparency = 1
Panels.AutoFishPanel.Visible = false

-- Header
local AFHeader = Instance.new("TextLabel", Panels.AutoFishPanel)
AFHeader.Size = UDim2.new(1,-20,0,40)
AFHeader.Position = UDim2.new(0,10,0,10)
AFHeader.Text = "🎣 ADVANCED AUTO FISHING"
AFHeader.TextColor3 = Color3.new(1,1,1)
AFHeader.Font = Enum.Font.GothamBold
AFHeader.TextSize = 18
AFHeader.BackgroundTransparency = 1
AFHeader.TextXAlignment = Enum.TextXAlignment.Center

-- Status Card
local StatusCard = Instance.new("Frame", Panels.AutoFishPanel)
StatusCard.Size = UDim2.new(1,-20,0,120)
StatusCard.Position = UDim2.new(0,10,0,60)
StatusCard.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", StatusCard).CornerRadius = UDim.new(0,10)

local StatusTitle = Instance.new("TextLabel", StatusCard)
StatusTitle.Size = UDim2.new(1,-20,0,30)
StatusTitle.Position = UDim2.new(0,10,0,5)
StatusTitle.Text = "SYSTEM STATUS"
StatusTitle.TextColor3 = Color3.fromRGB(200,200,200)
StatusTitle.Font = Enum.Font.GothamBold
StatusTitle.TextSize = 14
StatusTitle.BackgroundTransparency = 1
StatusTitle.TextXAlignment = Enum.TextXAlignment.Left

local StatusText = Instance.new("TextLabel", StatusCard)
StatusText.Size = UDim2.new(1,-20,0,30)
StatusText.Position = UDim2.new(0,10,0,35)
StatusText.Text = "🔴 INACTIVE"
StatusText.TextColor3 = Color3.fromRGB(255,100,100)
StatusText.Font = Enum.Font.GothamBold
StatusText.TextSize = 16
StatusText.BackgroundTransparency = 1
StatusText.TextXAlignment = Enum.TextXAlignment.Left

local RodText = Instance.new("TextLabel", StatusCard)
RodText.Size = UDim2.new(1,-20,0,25)
RodText.Position = UDim2.new(0,10,0,70)
RodText.Text = "Rod: Not Found"
RodText.TextColor3 = Color3.fromRGB(200,200,200)
RodText.Font = Enum.Font.Gotham
RodText.TextSize = 13
RodText.BackgroundTransparency = 1
RodText.TextXAlignment = Enum.TextXAlignment.Left

-- Stats Card
local StatsCard = Instance.new("Frame", Panels.AutoFishPanel)
StatsCard.Size = UDim2.new(1,-20,0,100)
StatsCard.Position = UDim2.new(0,10,0,190)
StatsCard.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", StatsCard).CornerRadius = UDim.new(0,10)

local StatsTitle = Instance.new("TextLabel", StatsCard)
StatsTitle.Size = UDim2.new(1,-20,0,30)
StatsTitle.Position = UDim2.new(0,10,0,5)
StatsTitle.Text = "FISHING STATS"
StatsTitle.TextColor3 = Color3.fromRGB(200,200,200)
StatsTitle.Font = Enum.Font.GothamBold
StatsTitle.TextSize = 14
StatsTitle.BackgroundTransparency = 1
StatsTitle.TextXAlignment = Enum.TextXAlignment.Left

local FishCountText = Instance.new("TextLabel", StatsCard)
FishCountText.Size = UDim2.new(0.5,-10,0,25)
FishCountText.Position = UDim2.new(0,10,0,40)
FishCountText.Text = "Fish: 0"
FishCountText.TextColor3 = Color3.new(1,1,1)
FishCountText.Font = Enum.Font.GothamBold
FishCountText.TextSize = 14
FishCountText.BackgroundTransparency = 1
FishCountText.TextXAlignment = Enum.TextXAlignment.Left

local AttemptsText = Instance.new("TextLabel", StatsCard)
AttemptsText.Size = UDim2.new(0.5,-10,0,25)
AttemptsText.Position = UDim2.new(0.5,0,0,40)
AttemptsText.Text = "Attempts: 0"
AttemptsText.TextColor3 = Color3.fromRGB(200,200,200)
AttemptsText.Font = Enum.Font.Gotham
AttemptsText.TextSize = 13
AttemptsText.BackgroundTransparency = 1
AttemptsText.TextXAlignment = Enum.TextXAlignment.Left

local RateText = Instance.new("TextLabel", StatsCard)
RateText.Size = UDim2.new(1,-20,0,25)
RateText.Position = UDim2.new(0,10,0,65)
RateText.Text = "Success Rate: 70%"
RateText.TextColor3 = Color3.fromRGB(200,200,200)
RateText.Font = Enum.Font.Gotham
RateText.TextSize = 13
RateText.BackgroundTransparency = 1
RateText.TextXAlignment = Enum.TextXAlignment.Left

-- Control Card
local ControlCard = Instance.new("Frame", Panels.AutoFishPanel)
ControlCard.Size = UDim2.new(1,-20,0,80)
ControlCard.Position = UDim2.new(0,10,0,300)
ControlCard.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", ControlCard).CornerRadius = UDim.new(0,10)

local ControlTitle = Instance.new("TextLabel", ControlCard)
ControlTitle.Size = UDim2.new(1,-20,0,30)
ControlTitle.Position = UDim2.new(0,10,0,5)
ControlTitle.Text = "CONTROLS"
ControlTitle.TextColor3 = Color3.fromRGB(200,200,200)
ControlTitle.Font = Enum.Font.GothamBold
ControlTitle.TextSize = 14
ControlTitle.BackgroundTransparency = 1
ControlTitle.TextXAlignment = Enum.TextXAlignment.Left

local StartBtn = Instance.new("TextButton", ControlCard)
StartBtn.Size = UDim2.new(0.5,-15,0,35)
StartBtn.Position = UDim2.new(0,10,0,40)
StartBtn.Text = "▶ START"
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextSize = 14
StartBtn.TextColor3 = Color3.new(1,1,1)
StartBtn.BackgroundColor3 = Color3.fromRGB(0,180,0)
Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0,8)

local DetectBtn = Instance.new("TextButton", ControlCard)
DetectBtn.Size = UDim2.new(0.5,-15,0,35)
DetectBtn.Position = UDim2.new(0.5,5,0,40)
DetectBtn.Text = "🔍 SCAN ROD"
DetectBtn.Font = Enum.Font.GothamBold
DetectBtn.TextSize = 12
DetectBtn.TextColor3 = Color3.new(1,1,1)
DetectBtn.BackgroundColor3 = Color3.fromRGB(0,120,200)
Instance.new("UICorner", DetectBtn).CornerRadius = UDim.new(0,8)

-- Settings Card
local SettingsCard = Instance.new("Frame", Panels.AutoFishPanel)
SettingsCard.Size = UDim2.new(1,-20,0,100)
SettingsCard.Position = UDim2.new(0,10,0,390)
SettingsCard.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", SettingsCard).CornerRadius = UDim.new(0,10)

local SettingsTitle = Instance.new("TextLabel", SettingsCard)
SettingsTitle.Size = UDim2.new(1,-20,0,30)
SettingsTitle.Position = UDim2.new(0,10,0,5)
SettingsTitle.Text = "SETTINGS"
SettingsTitle.TextColor3 = Color3.fromRGB(200,200,200)
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.TextSize = 14
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left

local CooldownLabel = Instance.new("TextLabel", SettingsCard)
CooldownLabel.Size = UDim2.new(0.6,-10,0,25)
CooldownLabel.Position = UDim2.new(0,10,0,40)
CooldownLabel.Text = "Cooldown: " .. AutoFish.Cooldown .. "s"
CooldownLabel.TextColor3 = Color3.fromRGB(200,200,200)
CooldownLabel.Font = Enum.Font.Gotham
CooldownLabel.TextSize = 13
CooldownLabel.BackgroundTransparency = 1
CooldownLabel.TextXAlignment = Enum.TextXAlignment.Left

local CooldownBox = Instance.new("TextBox", SettingsCard)
CooldownBox.Size = UDim2.new(0.4,-20,0,25)
CooldownBox.Position = UDim2.new(0.6,0,0,40)
CooldownBox.Text = tostring(AutoFish.Cooldown)
CooldownBox.Font = Enum.Font.Gotham
CooldownBox.TextSize = 13
CooldownBox.TextColor3 = Color3.new(1,1,1)
CooldownBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", CooldownBox).CornerRadius = UDim.new(0,6)

local RateLabel = Instance.new("TextLabel", SettingsCard)
RateLabel.Size = UDim2.new(0.6,-10,0,25)
RateLabel.Position = UDim2.new(0,10,0,70)
RateLabel.Text = "Success Rate: " .. (AutoFish.SuccessRate * 100) .. "%"
RateLabel.TextColor3 = Color3.fromRGB(200,200,200)
RateLabel.Font = Enum.Font.Gotham
RateLabel.TextSize = 13
RateLabel.BackgroundTransparency = 1
RateLabel.TextXAlignment = Enum.TextXAlignment.Left

local RateBox = Instance.new("TextBox", SettingsCard)
RateBox.Size = UDim2.new(0.4,-20,0,25)
RateBox.Position = UDim2.new(0.6,0,0,70)
RateBox.Text = tostring(AutoFish.SuccessRate * 100)
RateBox.Font = Enum.Font.Gotham
RateBox.TextSize = 13
RateBox.TextColor3 = Color3.new(1,1,1)
RateBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", RateBox).CornerRadius = UDim.new(0,6)

-- Update stats function
AutoFishUI.updateStats = function()
    local statusColor = AutoFish.Enabled and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,100,100)
    local statusText = AutoFish.Enabled and "🟢 ACTIVE" or "🔴 INACTIVE"
    
    StatusText.Text = statusText
    StatusText.TextColor3 = statusColor
    
    local rodName = AutoFish.CurrentRod and AutoFish.CurrentRod.Name or "Not Found"
    RodText.Text = "Rod: " .. rodName
    
    FishCountText.Text = "Fish: " .. AutoFish.FishCaught
    AttemptsText.Text = "Attempts: " .. AutoFish.TotalAttempts
    
    local rate = AutoFish.TotalAttempts > 0 and 
                 math.floor((AutoFish.FishCaught / AutoFish.TotalAttempts) * 100) or 0
    RateText.Text = "Success Rate: " .. rate .. "%"
    
    -- Update button
    StartBtn.Text = AutoFish.Enabled and "⏹ STOP" or "▶ START"
    StartBtn.BackgroundColor3 = AutoFish.Enabled and Color3.fromRGB(200,0,0) or Color3.fromRGB(0,180,0)
end

--==================================
-- TELEPORT UI
--==================================
local Search = Instance.new("TextBox", Panels.TeleportPanel)
Search.Size = UDim2.new(1,-20,0,34)
Search.Position = UDim2.new(0,10,0,10)
Search.PlaceholderText = "Search location..."
Search.Text = ""
Search.ClearTextOnFocus = false
Search.Font = Enum.Font.Gotham
Search.TextSize = 14
Search.TextColor3 = Color3.new(1,1,1)
Search.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", Search).CornerRadius = UDim.new(0,8)

local Scroll = Instance.new("ScrollingFrame", Panels.TeleportPanel)
Scroll.Position = UDim2.new(0,10,0,54)
Scroll.Size = UDim2.new(1,-20,1,-64)
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.ScrollBarImageTransparency = 0.2
Scroll.BackgroundTransparency = 1
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.None

local function rebuildList(filter)
    Scroll:ClearAllChildren()

    local layout = Instance.new("UIListLayout", Scroll)
    layout.Padding = UDim.new(0,6)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
    end)

    for _,tp in ipairs(Teleports) do
        if (not filter) or string.find(tp.name:lower(), filter:lower(), 1, true) then
            local b = Instance.new("TextButton", Scroll)
            b.Size = UDim2.new(1,0,0,42)
            b.Text = tp.name.."  ["..tp.cat.."]"
            b.Font = Enum.Font.GothamBold
            b.TextSize = 13
            b.TextColor3 = Color3.new(1,1,1)
            b.BackgroundColor3 = Color3.fromRGB(120,0,0)
            Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

            b.MouseButton1Click:Connect(function()
                fastSmoothTeleport(tp.cf)
            end)
        end
    end
end

Search:GetPropertyChangedSignal("Text"):Connect(function()
    rebuildList(Search.Text ~= "" and Search.Text or nil)
end)

--==================================
-- PANEL MANAGEMENT
--==================================
local function showPanel(panelName)
    for name, panel in pairs(Panels) do
        panel.Visible = false
    end
    
    for name, btn in pairs(MenuButtons) do
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    end
    
    if Panels[panelName] then
        Panels[panelName].Visible = true
        local btnName = panelName:gsub("Panel", "Btn")
        if MenuButtons[btnName] then
            MenuButtons[btnName].BackgroundColor3 = Color3.fromRGB(120,0,0)
        end
    end
    
    AutoFishUI.updateStats()
end

MenuButtons.TeleportBtn.MouseButton1Click:Connect(function()
    showPanel("TeleportPanel")
end)

MenuButtons.AutoFishBtn.MouseButton1Click:Connect(function()
    showPanel("AutoFishPanel")
end)

--==================================
-- AUTO FISH CONTROLS
--==================================
StartBtn.MouseButton1Click:Connect(function()
    AutoFish.Enabled = not AutoFish.Enabled
    
    if AutoFish.Enabled then
        startAdvancedAutoFishing()
    else
        stopAdvancedAutoFishing()
    end
    
    AutoFishUI.updateStats()
end)

DetectBtn.MouseButton1Click:Connect(function()
    local rod = findFishingRod()
    if rod then
        equipRod(rod)
        AutoFishUI.updateStats()
    end
end)

CooldownBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(CooldownBox.Text)
        if num and num >= 1 and num <= 10 then
            AutoFish.Cooldown = num
            CooldownLabel.Text = "Cooldown: " .. num .. "s"
        else
            CooldownBox.Text = tostring(AutoFish.Cooldown)
        end
    end
end)

RateBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(RateBox.Text)
        if num and num >= 1 and num <= 100 then
            AutoFish.SuccessRate = num / 100
            RateLabel.Text = "Success Rate: " .. num .. "%"
        else
            RateBox.Text = tostring(AutoFish.SuccessRate * 100)
        end
    end
end)

--==================================
-- MINIMIZE SYSTEM
--==================================
local Bubble = Instance.new("TextButton", gui)
Bubble.Size = UDim2.new(0,50,0,50)
Bubble.Position = UDim2.new(0,20,0.5,-25)
Bubble.Text = "🎣"
Bubble.Visible = false
Bubble.BackgroundColor3 = Color3.fromRGB(120,0,0)
Bubble.TextColor3 = Color3.new(1,1,1)
Bubble.Font = Enum.Font.GothamBold
Bubble.TextSize = 18
Bubble.Active = true
Bubble.Draggable = true
Instance.new("UICorner", Bubble).CornerRadius = UDim.new(1,0)

local MinBtn = Instance.new("TextButton", Title)
MinBtn.Size = UDim2.new(0,30,0,30)
MinBtn.Position = UDim2.new(1,-40,0,3)
MinBtn.Text = "-"
MinBtn.BackgroundTransparency = 1
MinBtn.TextColor3 = Color3.new(1,1,1)

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    Bubble.Visible = true
end)

Bubble.MouseButton1Click:Connect(function()
    Bubble.Visible = false
    Main.Visible = true
end)

--==================================
-- HOTKEY
--==================================
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
        Bubble.Visible = false
    end
end)

--==================================
-- INITIALIZATION
--==================================
rebuildList()
showPanel("TeleportPanel")
AutoFishUI.updateStats()

-- Initial rod detection
task.wait(1)
local rod = findFishingRod()
if rod then
    equipRod(rod)
    AutoFishUI.updateStats()
end

print("🎣 Advanced Auto Fishing System Loaded!")
print("System will auto-detect fishing rods")
print("RightShift to toggle UI")
