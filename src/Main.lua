--==================================
-- FIXED ROD SCANNER + UI STAY IN PANEL
--==================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer

--==================================
-- FIXED ROD DETECTION SYSTEM
--==================================
local RodDatabase = {
    {
        Name = "Diamond Rod",
        DisplayName = "Diamond Rod",
        Type = "Legendary",
        Speed = 167,
        Weight = 1000000,
        Tier = 5,
        Keywords = {"diamond", "legendary"}
    },
    {
        Name = "Element Rod",
        DisplayName = "Element Rod", 
        Type = "Epic",
        Speed = 130,
        Weight = 800,
        Tier = 4,
        Keywords = {"element", "epic"}
    },
    {
        Name = "Ghostfinn Rod",
        DisplayName = "Ghostfinn Rod",
        Type = "Rare",
        Speed = 118,
        Weight = 600,
        Tier = 3,
        Keywords = {"ghostfinn", "ghost", "rare"}
    },
    {
        Name = "Golden Rod",
        DisplayName = "Golden Rod",
        Type = "Epic",
        Speed = 140,
        Weight = 700,
        Tier = 4,
        Keywords = {"golden", "gold"}
    },
    {
        Name = "Crystal Rod",
        DisplayName = "Crystal Rod",
        Type = "Rare",
        Speed = 125,
        Weight = 550,
        Tier = 3,
        Keywords = {"crystal"}
    },
    {
        Name = "Iron Rod",
        DisplayName = "Iron Rod",
        Type = "Uncommon",
        Speed = 105,
        Weight = 400,
        Tier = 2,
        Keywords = {"iron"}
    },
    {
        Name = "Wooden Rod",
        DisplayName = "Wooden Rod",
        Type = "Common",
        Speed = 100,
        Weight = 300,
        Tier = 1,
        Keywords = {"wooden", "wood"}
    },
    {
        Name = "Basic Fishing Rod",
        DisplayName = "Basic Fishing Rod",
        Type = "Common",
        Speed = 95,
        Weight = 250,
        Tier = 1,
        Keywords = {"basic", "fishing"}
    }
}

-- FIXED ROD SCANNER
local function deepScanForRods()
    print("[DEEP SCAN] Starting advanced rod detection...")
    local foundRods = {}
    
    -- Method 1: Check Player's Tools directly
    if LP.Character then
        for _, child in ipairs(LP.Character:GetDescendants()) do
            if child:IsA("Tool") then
                local toolName = child.Name:lower()
                for _, rodData in ipairs(RodDatabase) do
                    for _, keyword in ipairs(rodData.Keywords) do
                        if string.find(toolName, keyword:lower()) then
                            table.insert(foundRods, {
                                Object = child,
                                Data = rodData,
                                Location = "Character"
                            })
                            print("[DEEP SCAN] Found on character:", rodData.DisplayName)
                            break
                        end
                    end
                end
                
                -- Generic rod detection
                if string.find(toolName, "rod") or string.find(toolName, "pole") then
                    table.insert(foundRods, {
                        Object = child,
                        Data = {
                            DisplayName = child.Name,
                            Type = "Generic",
                            Speed = 100,
                            Weight = 300,
                            Tier = 1
                        },
                        Location = "Character"
                    })
                    print("[DEEP SCAN] Found generic rod:", child.Name)
                end
            end
        end
    end
    
    -- Method 2: Check Backpack with better detection
    local backpack = LP:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local toolName = tool.Name:lower()
                
                -- Check for exact matches first
                for _, rodData in ipairs(RodDatabase) do
                    local rodNameLower = rodData.Name:lower()
                    if toolName == rodNameLower then
                        table.insert(foundRods, {
                            Object = tool,
                            Data = rodData,
                            Location = "Backpack"
                        })
                        print("[DEEP SCAN] Exact match in backpack:", rodData.DisplayName)
                        break
                    end
                end
                
                -- Check for partial matches
                for _, rodData in ipairs(RodDatabase) do
                    for _, keyword in ipairs(rodData.Keywords) do
                        if string.find(toolName, keyword:lower()) then
                            table.insert(foundRods, {
                                Object = tool,
                                Data = rodData,
                                Location = "Backpack"
                            })
                            print("[DEEP SCAN] Partial match in backpack:", rodData.DisplayName)
                            break
                        end
                    end
                end
            end
        end
    end
    
    -- Method 3: Check StarterPack (common in fishing games)
    local starterPack = game:GetService("StarterPack")
    if starterPack then
        for _, tool in ipairs(starterPack:GetChildren()) do
            if tool:IsA("Tool") then
                local toolName = tool.Name:lower()
                if string.find(toolName, "rod") or string.find(toolName, "fishing") then
                    -- Try to clone it to backpack
                    local clone = tool:Clone()
                    clone.Parent = LP.Backpack
                    
                    table.insert(foundRods, {
                        Object = clone,
                        Data = {
                            DisplayName = tool.Name,
                            Type = "Starter",
                            Speed = 95,
                            Weight = 250,
                            Tier = 1
                        },
                        Location = "StarterPack"
                    })
                    print("[DEEP SCAN] Cloned from StarterPack:", tool.Name)
                end
            end
        end
    end
    
    -- Method 4: Check Workspace for fishing rods (some games place them there)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") and (obj.Name:find("Rod") or obj.Name:find("Fishing")) then
            if obj:FindFirstChild("Handle") then
                table.insert(foundRods, {
                    Object = obj,
                    Data = {
                        DisplayName = obj.Name,
                        Type = "Workspace",
                        Speed = 100,
                        Weight = 300,
                        Tier = 1
                    },
                    Location = "Workspace"
                })
                print("[DEEP SCAN] Found in Workspace:", obj.Name)
            end
        end
    end
    
    -- Method 5: MANUAL ROD CREATION (Jika tidak ada rod ditemukan)
    if #foundRods == 0 then
        print("[DEEP SCAN] No rods found, creating manual fishing rod...")
        
        -- Create a basic fishing rod tool
        local manualRod = Instance.new("Tool")
        manualRod.Name = "Basic Fishing Rod"
        manualRod.CanBeDropped = false
        
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(1, 4, 1)
        handle.Parent = manualRod
        
        manualRod.Parent = LP.Backpack
        
        table.insert(foundRods, {
            Object = manualRod,
            Data = {
                DisplayName = "Basic Fishing Rod",
                Type = "Manual",
                Speed = 95,
                Weight = 250,
                Tier = 1
            },
            Location = "Manual"
        })
    end
    
    print("[DEEP SCAN] Completed. Found", #foundRods, "rods")
    return foundRods
end

--==================================
-- FIXED UI PANEL (NO SCROLL ESCAPE)
--==================================
local gui = Instance.new("ScreenGui")
gui.Name = "AmsHubFixed"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

-- MAIN FRAME dengan CLIPS DESCENDANTS
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 600, 0, 450)
Main.Position = UDim2.new(0.5, -300, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true  -- INI YANG PENTING!
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- TITLE BAR (FIXED POSITION)
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 36)
Title.Text = "🎣 AmsHub | Fixed UI"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local TitlePadding = Instance.new("UIPadding")
TitlePadding.PaddingLeft = UDim.new(0, 12)
TitlePadding.Parent = Title

-- SIDEBAR (FIXED POSITION - NO SCROLL)
local Side = Instance.new("Frame", Main)
Side.Position = UDim2.new(0, 0, 0, 36)
Side.Size = UDim2.new(0, 150, 1, -36)
Side.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Side.ClipsDescendants = true

-- CONTENT AREA (FIXED POSITION)
local Content = Instance.new("Frame", Main)
Content.Position = UDim2.new(0, 150, 0, 36)
Content.Size = UDim2.new(1, -150, 1, -36)
Content.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Content.ClipsDescendants = true  -- INI JUGA!

--==================================
-- SCROLLING SYSTEM YANG TIDAK KELUAR PANEL
--==================================
local function createFixedScrollFrame(parent, position, size)
    local scrollFrame = Instance.new("ScrollingFrame", parent)
    scrollFrame.Size = size
    scrollFrame.Position = position
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(120, 0, 0)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ClipsDescendants = true  -- INI PENTING!
    
    -- Container untuk konten (supaya tidak keluar)
    local container = Instance.new("Frame", scrollFrame)
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.ClipsDescendants = true
    
    -- UIListLayout di dalam container
    local listLayout = Instance.new("UIListLayout", container)
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Update canvas size tapi tetap dalam bounds
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local contentHeight = listLayout.AbsoluteContentSize.Y
        local maxHeight = scrollFrame.AbsoluteSize.Y
        
        -- Pastikan tidak melebihi max height
        if contentHeight > maxHeight then
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
            container.Size = UDim2.new(1, 0, 0, contentHeight)
        else
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
            container.Size = UDim2.new(1, 0, 1, 0)
        end
    end)
    
    return scrollFrame, container
end

--==================================
-- SIDEBAR MENU (FIXED - TIDAK SCROLL)
--==================================
local MenuButtons = {}

MenuButtons.Teleport = Instance.new("TextButton", Side)
MenuButtons.Teleport.Size = UDim2.new(1, -10, 0, 40)
MenuButtons.Teleport.Position = UDim2.new(0, 5, 0, 10)
MenuButtons.Teleport.Text = "📍 TELEPORT"
MenuButtons.Teleport.Font = Enum.Font.GothamBold
MenuButtons.Teleport.TextSize = 14
MenuButtons.Teleport.TextColor3 = Color3.new(1, 1, 1)
MenuButtons.Teleport.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
MenuButtons.Teleport.AutoButtonColor = false
Instance.new("UICorner", MenuButtons.Teleport).CornerRadius = UDim.new(0, 8)

MenuButtons.AutoFish = Instance.new("TextButton", Side)
MenuButtons.AutoFish.Size = UDim2.new(1, -10, 0, 40)
MenuButtons.AutoFish.Position = UDim2.new(0, 5, 0, 60)
MenuButtons.AutoFish.Text = "🎣 AUTO FISH"
MenuButtons.AutoFish.Font = Enum.Font.GothamBold
MenuButtons.AutoFish.TextSize = 14
MenuButtons.AutoFish.TextColor3 = Color3.new(1, 1, 1)
MenuButtons.AutoFish.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MenuButtons.AutoFish.AutoButtonColor = false
Instance.new("UICorner", MenuButtons.AutoFish).CornerRadius = UDim.new(0, 8)

MenuButtons.RodScanner = Instance.new("TextButton", Side)
MenuButtons.RodScanner.Size = UDim2.new(1, -10, 0, 40)
MenuButtons.RodScanner.Position = UDim2.new(0, 5, 0, 110)
MenuButtons.RodScanner.Text = "🔍 SCAN RODS"
MenuButtons.RodScanner.Font = Enum.Font.GothamBold
MenuButtons.RodScanner.TextSize = 14
MenuButtons.RodScanner.TextColor3 = Color3.new(1, 1, 1)
MenuButtons.RodScanner.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MenuButtons.RodScanner.AutoButtonColor = false
Instance.new("UICorner", MenuButtons.RodScanner).CornerRadius = UDim.new(0, 8)

--==================================
-- CONTENT PANELS (FIXED SCROLL)
--==================================
local Panels = {}

-- TELEPORT PANEL
Panels.Teleport = Instance.new("Frame", Content)
Panels.Teleport.Size = UDim2.new(1, 0, 1, 0)
Panels.Teleport.BackgroundTransparency = 1
Panels.Teleport.Visible = true

-- Search bar (FIXED POSITION - tidak ikut scroll)
local SearchBar = Instance.new("Frame", Panels.Teleport)
SearchBar.Size = UDim2.new(1, -20, 0, 50)
SearchBar.Position = UDim2.new(0, 10, 0, 10)
SearchBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(0, 8)

local SearchBox = Instance.new("TextBox", SearchBar)
SearchBox.Size = UDim2.new(1, -20, 1, -10)
SearchBox.Position = UDim2.new(0, 10, 0, 5)
SearchBox.PlaceholderText = "Search locations..."
SearchBox.Text = ""
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 14
SearchBox.TextColor3 = Color3.new(1, 1, 1)
SearchBox.BackgroundTransparency = 1

-- Scroll frame untuk locations (FIXED - tidak keluar panel)
local TeleportScroll, TeleportContainer = createFixedScrollFrame(
    Panels.Teleport,
    UDim2.new(0, 10, 0, 70),
    UDim2.new(1, -20, 1, -80)
)

-- AUTO FISH PANEL
Panels.AutoFish = Instance.new("Frame", Content)
Panels.AutoFish.Size = UDim2.new(1, 0, 1, 0)
Panels.AutoFish.BackgroundTransparency = 1
Panels.AutoFish.Visible = false

-- Rod Scanner Panel
Panels.RodScanner = Instance.new("Frame", Content)
Panels.RodScanner.Size = UDim2.new(1, 0, 1, 0)
Panels.RodScanner.BackgroundTransparency = 1
Panels.RodScanner.Visible = false

--==================================
-- ROD SCANNER UI (FIXED SCROLL)
--==================================
local ScannerTitle = Instance.new("TextLabel", Panels.RodScanner)
ScannerTitle.Size = UDim2.new(1, -20, 0, 40)
ScannerTitle.Position = UDim2.new(0, 10, 0, 10)
ScannerTitle.Text = "🔍 ROD SCANNER"
ScannerTitle.TextColor3 = Color3.new(1, 1, 1)
ScannerTitle.Font = Enum.Font.GothamBold
ScannerTitle.TextSize = 18
ScannerTitle.BackgroundTransparency = 1
ScannerTitle.TextXAlignment = Enum.TextXAlignment.Center

local ScanButton = Instance.new("TextButton", Panels.RodScanner)
ScanButton.Size = UDim2.new(1, -20, 0, 50)
ScanButton.Position = UDim2.new(0, 10, 0, 60)
ScanButton.Text = "START DEEP SCAN"
ScanButton.Font = Enum.Font.GothamBold
ScanButton.TextSize = 16
ScanButton.TextColor3 = Color3.new(1, 1, 1)
ScanButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Instance.new("UICorner", ScanButton).CornerRadius = UDim.new(0, 10)

local StatusLabel = Instance.new("TextLabel", Panels.RodScanner)
StatusLabel.Size = UDim2.new(1, -20, 0, 40)
StatusLabel.Position = UDim2.new(0, 10, 0, 120)
StatusLabel.Text = "Status: Ready to scan"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Scroll frame untuk hasil scan (FIXED)
local ResultScroll, ResultContainer = createFixedScrollFrame(
    Panels.RodScanner,
    UDim2.new(0, 10, 0, 170),
    UDim2.new(1, -20, 1, -180)
)

--==================================
-- PANEL MANAGEMENT
--==================================
local function showPanel(panelName)
    -- Hide all panels
    for name, panel in pairs(Panels) do
        panel.Visible = false
    end
    
    -- Reset button colors
    for name, btn in pairs(MenuButtons) do
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
    
    -- Show selected panel
    if Panels[panelName] then
        Panels[panelName].Visible = true
        if MenuButtons[panelName] then
            MenuButtons[panelName].BackgroundColor3 = Color3.fromRGB(120, 0, 0)
        end
    end
end

MenuButtons.Teleport.MouseButton1Click:Connect(function()
    showPanel("Teleport")
end)

MenuButtons.AutoFish.MouseButton1Click:Connect(function()
    showPanel("AutoFish")
end)

MenuButtons.RodScanner.MouseButton1Click:Connect(function()
    showPanel("RodScanner")
end)

--==================================
-- ROD SCANNER FUNCTION
--==================================
ScanButton.MouseButton1Click:Connect(function()
    StatusLabel.Text = "Scanning... Please wait"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    
    -- Clear previous results
    for _, child in ipairs(ResultContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    task.wait(0.5)
    
    -- Start deep scan
    local foundRods = deepScanForRods()
    
    if #foundRods == 0 then
        StatusLabel.Text = "❌ No rods found"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        -- Show "no rods" message
        local noRodsFrame = Instance.new("Frame", ResultContainer)
        noRodsFrame.Size = UDim2.new(1, 0, 0, 100)
        noRodsFrame.BackgroundTransparency = 1
        
        local message = Instance.new("TextLabel", noRodsFrame)
        message.Size = UDim2.new(1, 0, 1, 0)
        message.Text = "⚠️ No fishing rods found!\n\nMake sure you have a fishing rod in your:\n• Backpack\n• Character\n• StarterPack"
        message.TextColor3 = Color3.fromRGB(255, 150, 150)
        message.Font = Enum.Font.Gotham
        message.TextSize = 14
        message.BackgroundTransparency = 1
        message.TextWrapped = true
        
    else
        StatusLabel.Text = "✅ Found " .. #foundRods .. " rods"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Display found rods
        for i, rodInfo in ipairs(foundRods) do
            local rodFrame = Instance.new("Frame", ResultContainer)
            rodFrame.Size = UDim2.new(1, 0, 0, 80)
            rodFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            Instance.new("UICorner", rodFrame).CornerRadius = UDim.new(0, 8)
            
            local rodName = Instance.new("TextLabel", rodFrame)
            rodName.Size = UDim2.new(1, -20, 0, 30)
            rodName.Position = UDim2.new(0, 10, 0, 10)
            rodName.Text = rodInfo.Data.DisplayName
            rodName.TextColor3 = Color3.new(1, 1, 1)
            rodName.Font = Enum.Font.GothamBold
            rodName.TextSize = 16
            rodName.BackgroundTransparency = 1
            rodName.TextXAlignment = Enum.TextXAlignment.Left
            
            local rodStats = Instance.new("TextLabel", rodFrame)
            rodStats.Size = UDim2.new(1, -20, 0, 40)
            rodStats.Position = UDim2.new(0, 10, 0, 40)
            rodStats.Text = string.format("Type: %s\nSpeed: %d%% | Weight: %dkg",
                rodInfo.Data.Type,
                rodInfo.Data.Speed,
                rodInfo.Data.Weight)
            rodStats.TextColor3 = Color3.fromRGB(180, 180, 200)
            rodStats.Font = Enum.Font.Gotham
            rodStats.TextSize = 12
            rodStats.BackgroundTransparency = 1
            rodStats.TextXAlignment = Enum.TextXAlignment.Left
            
            local locationTag = Instance.new("TextLabel", rodFrame)
            locationTag.Size = UDim2.new(0, 80, 0, 20)
            locationTag.Position = UDim2.new(1, -90, 0, 10)
            locationTag.Text = rodInfo.Location
            locationTag.TextColor3 = Color3.fromRGB(150, 150, 150)
            locationTag.Font = Enum.Font.GothamSemibold
            locationTag.TextSize = 10
            locationTag.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            locationTag.BackgroundTransparency = 0.5
            Instance.new("UICorner", locationTag).CornerRadius = UDim.new(0, 4)
        end
    end
end)

--==================================
-- MINIMIZE SYSTEM (FIXED)
--==================================
local Bubble = Instance.new("TextButton", gui)
Bubble.Size = UDim2.new(0, 50, 0, 50)
Bubble.Position = UDim2.new(0, 20, 0.5, -25)
Bubble.Text = "🎣"
Bubble.Visible = false
Bubble.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
Bubble.TextColor3 = Color3.new(1, 1, 1)
Bubble.Font = Enum.Font.GothamBold
Bubble.TextSize = 20
Bubble.Active = true
Bubble.Draggable = true
Bubble.AutoButtonColor = false
Instance.new("UICorner", Bubble).CornerRadius = UDim.new(1, 0)

local MinBtn = Instance.new("TextButton", Title)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -40, 0, 3)
MinBtn.Text = "-"
MinBtn.BackgroundTransparency = 1
MinBtn.TextColor3 = Color3.new(1, 1, 1)

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    Bubble.Visible = true
end)

Bubble.MouseButton1Click:Connect(function()
    Bubble.Visible = false
    Main.Visible = true
end)

--==================================
-- HOTKEY TOGGLE
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
showPanel("Teleport")

-- Add some sample teleport locations
for i = 1, 20 do
    local btn = Instance.new("TextButton", TeleportContainer)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.LayoutOrder = i
    btn.Text = "Location " .. i .. "  [Island]"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
end

print("✅ Fixed UI Loaded!")
print("🎣 Rod Scanner Ready!")
print("📱 UI will not escape panel bounds!")
