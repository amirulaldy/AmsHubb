--==================================
-- AmsHub | Fish It v2.0
-- Enhanced UI with More Features
--==================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

--==================================
-- CONFIGURATION
--==================================
local CONFIG = {
    TELEPORT_OFFSET = Vector3.new(0, 3, 0),
    TELEPORT_TIME = 0.04,
    UI_ACCENT = Color3.fromRGB(220, 60, 60),  -- Red accent
    UI_DARK = Color3.fromRGB(15, 15, 15),
    UI_DARKER = Color3.fromRGB(10, 10, 10),
    UI_LIGHT = Color3.fromRGB(30, 30, 30),
    SAVE_KEY = "AmsHub_FishIt_Data"
}

--==================================
-- ENHANCED TELEPORT DATA WITH DEFAULT COORDS
--==================================
local Teleports = {
    -- ISLAND
    {name="Fisherman Island", cat="Island", cf=CFrame.new(0,0,0), desc="Starting island for beginners"},
    {name="Kohana", cat="Island", cf=CFrame.new(0,0,0), desc="Traditional Japanese themed island"},
    {name="Tropical Grove", cat="Island", cf=CFrame.new(0,0,0), desc="Lush tropical paradise"},
    {name="Ancient Jungle", cat="Island", cf=CFrame.new(0,0,0), desc="Mysterious ancient ruins"},
    {name="Crater Island", cat="Island", cf=CFrame.new(0,0,0), desc="Volcanic crater island"},
    
    -- DEPTH
    {name="Coral Reefs", cat="Depth", cf=CFrame.new(0,0,0), desc="Colorful coral formations"},
    {name="Esoteric Depths", cat="Depth", cf=CFrame.new(0,0,0), desc="Mysterious deep sea area"},
    {name="Crystal Depths", cat="Depth", cf=CFrame.new(0,0,0), desc="Glowing crystal caves"},
    {name="Volcano Cavern", cat="Depth", cf=CFrame.new(0,0,0), desc="Underwater volcanic vents"},
    
    -- SECRET
    {name="Ancient Ruin", cat="Secret", cf=CFrame.new(0,0,0), desc="Hidden ancient structure"},
    {name="Sacred Temple", cat="Secret", cf=CFrame.new(0,0,0), desc="Sacred fishing temple"},
    {name="Treasure Room", cat="Secret", cf=CFrame.new(0,0,0), desc="Secret treasure chamber"},
    {name="Pirate Cove", cat="Secret", cf=CFrame.new(0,0,0), desc="Hidden pirate hideout"},
    {name="Pirate Treasure Room", cat="Secret", cf=CFrame.new(0,0,0), desc="Pirate treasure vault"},
    {name="Sisyphus Statue", cat="Secret", cf=CFrame.new(0,0,0), desc="Mythical statue location"},
    
    -- NEW AREAS (2024-2025)
    {name="Arctic Depths", cat="Depth", cf=CFrame.new(0,0,0), desc="Frozen underwater caverns"},
    {name="Abyssal Trench", cat="Depth", cf=CFrame.new(0,0,0), desc="Deepest point in the ocean"},
    {name="Sky Archipelago", cat="Island", cf=CFrame.new(0,0,0), desc="Floating islands in the sky"},
    {name="Mermaid Grotto", cat="Secret", cf=CFrame.new(0,0,0), desc="Hidden mermaid sanctuary"}
}

--==================================
-- FAVORITES & SETTINGS SYSTEM
--==================================
local UserData = {
    favorites = {},
    customLocations = {},
    settings = {
        autoSave = true,
        showNotifications = true,
        teleportEffect = true,
        bypassCooldown = false
    }
}

-- Load saved data
local function loadData()
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(CONFIG.SAVE_KEY .. ".json"))
    end)
    if success and data then
        UserData = data
        return true
    end
    return false
end

-- Save data
local function saveData()
    if not UserData.settings.autoSave then return end
    pcall(function()
        writefile(CONFIG.SAVE_KEY .. ".json", HttpService:JSONEncode(UserData))
    end)
end

-- Try to load existing data
loadData()

--==================================
-- NOTIFICATION SYSTEM
--==================================
local Notifications = {}
local function showNotification(title, message, duration)
    if not UserData.settings.showNotifications then return end
    
    local notifGui = Instance.new("ScreenGui", LP.PlayerGui)
    notifGui.Name = "Notification_" .. HttpService:GenerateGUID(false)
    
    local frame = Instance.new("Frame", notifGui)
    frame.Size = UDim2.new(0, 300, 0, 80)
    frame.Position = UDim2.new(1, 10, 0.8, 0)
    frame.BackgroundColor3 = CONFIG.UI_DARK
    frame.BorderSizePixel = 0
    
    local uiCorner = Instance.new("UICorner", frame)
    uiCorner.CornerRadius = UDim.new(0, 8)
    
    local uiStroke = Instance.new("UIStroke", frame)
    uiStroke.Color = CONFIG.UI_ACCENT
    uiStroke.Thickness = 2
    
    local titleLabel = Instance.new("TextLabel", frame)
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.Text = "  " .. title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Color3.new(1,1,1)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local messageLabel = Instance.new("TextLabel", frame)
    messageLabel.Size = UDim2.new(1, -20, 1, -50)
    messageLabel.Position = UDim2.new(0, 10, 0, 40)
    messageLabel.Text = message
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 12
    messageLabel.TextColor3 = Color3.fromRGB(200,200,200)
    messageLabel.BackgroundTransparency = 1
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    
    -- Animate in
    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = UDim2.new(1, -310, frame.Position.Y.Scale, frame.Position.Y.Offset)
    })
    tweenIn:Play()
    
    -- Auto remove
    task.delay(duration or 3, function()
        local tweenOut = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, 10, frame.Position.Y.Scale, frame.Position.Y.Offset)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notifGui:Destroy()
        end)
    end)
    
    table.insert(Notifications, notifGui)
    return notifGui
end

--==================================
-- ENHANCED TELEPORT FUNCTION
--==================================
local function getHRP()
    local char = LP.Character or LP.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function fastSmoothTeleport(cf, locationName)
    if not cf then 
        showNotification("Error", "Invalid coordinates", 2)
        return
    end
    
    local hrp = getHRP()
    local targetCF = cf + CONFIG.TELEPORT_OFFSET
    
    if UserData.settings.teleportEffect then
        -- Create teleport effect
        local part = Instance.new("Part")
        part.Size = Vector3.new(2, 4, 2)
        part.CFrame = hrp.CFrame
        part.Anchored = true
        part.CanCollide = false
        part.Material = EnumMaterial.Neon
        part.Color = CONFIG.UI_ACCENT
        part.Transparency = 0.5
        part.Parent = workspace
        
        task.delay(1, function() part:Destroy() end)
    end
    
    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(CONFIG.TELEPORT_TIME, Enum.EasingStyle.Linear),
        {CFrame = targetCF}
    )
    tween:Play()
    
    showNotification("Teleport", "Teleported to: " .. (locationName or "Unknown"), 2)
end

--==================================
-- COORDINATE COLLECTOR
--==================================
local function getCurrentCoordinates()
    local char = LP.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local cf = char.HumanoidRootPart.CFrame
        return cf
    end
    return nil
end

local function copyToClipboard(text)
    pcall(function()
        setclipboard(tostring(text))
    end)
end

--==================================
-- MODERN UI CREATION
--==================================
local gui = Instance.new("ScreenGui")
gui.Name = "AmsHub_FishIt_v2"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

-- MAIN CONTAINER
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 650, 0, 500)
Main.Position = UDim2.new(0.5, -325, 0.5, -250)
Main.BackgroundColor3 = CONFIG.UI_DARK
Main.Active = true
Main.Draggable = true
Main.Visible = false

local mainCorner = Instance.new("UICorner", Main)
mainCorner.CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = CONFIG.UI_ACCENT
mainStroke.Thickness = 2

-- TITLE BAR
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = CONFIG.UI_DARKER
TitleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner", TitleBar)
titleCorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "🎣 AmsHub | Fish It v2.0"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseBtn.AutoButtonColor = false

local closeCorner = Instance.new("UICorner", CloseBtn)
closeCorner.CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    }):Play()
end)

CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    }):Play()
end)

-- MINIMIZE BUTTON
local MinBtn = Instance.new("TextButton", TitleBar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0.5, -15)
MinBtn.Text = "─"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.AutoButtonColor = false

local minCorner = Instance.new("UICorner", MinBtn)
minCorner.CornerRadius = UDim.new(1, 0)

-- TAB SYSTEM
local Tabs = {"Teleport", "Collector", "Favorites", "Settings"}
local CurrentTab = "Teleport"

local TabContainer = Instance.new("Frame", Main)
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundTransparency = 1

local TabButtons = {}

for i, tabName in ipairs(Tabs) do
    local tabBtn = Instance.new("TextButton", TabContainer)
    tabBtn.Size = UDim2.new(0.25, 0, 1, 0)
    tabBtn.Position = UDim2.new((i-1)/4, 0, 0, 0)
    tabBtn.Text = tabName
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 13
    tabBtn.BackgroundTransparency = 1
    tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    
    local underline = Instance.new("Frame", tabBtn)
    underline.Size = UDim2.new(1, -20, 0, 3)
    underline.Position = UDim2.new(0, 10, 1, -3)
    underline.BackgroundColor3 = CONFIG.UI_ACCENT
    underline.BorderSizePixel = 0
    underline.Visible = tabName == "Teleport"
    
    tabBtn.MouseButton1Click:Connect(function()
        CurrentTab = tabName
        for _, btn in pairs(TabButtons) do
            btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            btn.Underline.Visible = false
        end
        tabBtn.TextColor3 = Color3.new(1,1,1)
        underline.Visible = true
        
        -- Update content based on tab
        updateContent(tabName)
    end)
    
    tabBtn.Underline = underline
    TabButtons[tabName] = tabBtn
end

-- CONTENT FRAME
local ContentFrame = Instance.new("Frame", Main)
ContentFrame.Size = UDim2.new(1, 0, 1, -80)
ContentFrame.Position = UDim2.new(0, 0, 0, 80)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ClipsDescendants = true

--==================================
-- TELEPORT TAB CONTENT
--==================================
local TeleportTab = Instance.new("Frame", ContentFrame)
TeleportTab.Size = UDim2.new(1, 0, 1, 0)
TeleportTab.BackgroundTransparency = 1
TeleportTab.Visible = true

-- Search Bar
local SearchContainer = Instance.new("Frame", TeleportTab)
SearchContainer.Size = UDim2.new(1, -20, 0, 50)
SearchContainer.Position = UDim2.new(0, 10, 0, 10)
SearchContainer.BackgroundColor3 = CONFIG.UI_LIGHT
SearchContainer.BorderSizePixel = 0

local searchCorner = Instance.new("UICorner", SearchContainer)
searchCorner.CornerRadius = UDim.new(0, 8)

local SearchIcon = Instance.new("TextLabel", SearchContainer)
SearchIcon.Size = UDim2.new(0, 40, 1, 0)
SearchIcon.Text = "🔍"
SearchIcon.Font = Enum.Font.Gotham
SearchIcon.TextSize = 16
SearchIcon.TextColor3 = Color3.fromRGB(150,150,150)
SearchIcon.BackgroundTransparency = 1

local SearchBox = Instance.new("TextBox", SearchContainer)
SearchBox.Size = UDim2.new(1, -50, 1, 0)
SearchBox.Position = UDim2.new(0, 40, 0, 0)
SearchBox.PlaceholderText = "Search locations..."
SearchBox.ClearTextOnFocus = false
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 14
SearchBox.TextColor3 = Color3.new(1,1,1)
SearchBox.BackgroundTransparency = 1
SearchBox.TextXAlignment = Enum.TextXAlignment.Left

-- Category Filter
local CategoryFrame = Instance.new("Frame", TeleportTab)
CategoryFrame.Size = UDim2.new(1, -20, 0, 40)
CategoryFrame.Position = UDim2.new(0, 10, 0, 70)
CategoryFrame.BackgroundTransparency = 1

local categories = {"All", "Island", "Depth", "Secret"}
local CategoryButtons = {}
local SelectedCategory = "All"

for i, cat in ipairs(categories) do
    local catBtn = Instance.new("TextButton", CategoryFrame)
    catBtn.Size = UDim2.new(0.25, -5, 1, 0)
    catBtn.Position = UDim2.new((i-1)/4, 0, 0, 0)
    catBtn.Text = cat
    catBtn.Font = Enum.Font.GothamBold
    catBtn.TextSize = 12
    catBtn.BackgroundColor3 = CONFIG.UI_LIGHT
    catBtn.TextColor3 = Color3.new(1,1,1)
    
    local catCorner = Instance.new("UICorner", catBtn)
    catCorner.CornerRadius = UDim.new(0, 6)
    
    if cat == "All" then
        catBtn.BackgroundColor3 = CONFIG.UI_ACCENT
    end
    
    catBtn.MouseButton1Click:Connect(function()
        SelectedCategory = cat
        for _, btn in pairs(CategoryButtons) do
            btn.BackgroundColor3 = CONFIG.UI_LIGHT
        end
        catBtn.BackgroundColor3 = CONFIG.UI_ACCENT
        rebuildTeleportList()
    end)
    
    CategoryButtons[cat] = catBtn
end

-- Location List
local LocationScroll = Instance.new("ScrollingFrame", TeleportTab)
LocationScroll.Size = UDim2.new(1, -20, 1, -130)
LocationScroll.Position = UDim2.new(0, 10, 0, 120)
LocationScroll.BackgroundTransparency = 1
LocationScroll.ScrollBarThickness = 4
LocationScroll.ScrollBarImageColor3 = CONFIG.UI_ACCENT
LocationScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

--==================================
-- COLLECTOR TAB CONTENT
--==================================
local CollectorTab = Instance.new("Frame", ContentFrame)
CollectorTab.Size = UDim2.new(1, 0, 1, 0)
CollectorTab.BackgroundTransparency = 1
CollectorTab.Visible = false

local CollectorTitle = Instance.new("TextLabel", CollectorTab)
CollectorTitle.Size = UDim2.new(1, -20, 0, 30)
CollectorTitle.Position = UDim2.new(0, 10, 0, 10)
CollectorTitle.Text = "📌 Coordinate Collector"
CollectorTitle.Font = Enum.Font.GothamBold
CollectorTitle.TextSize = 16
CollectorTitle.TextColor3 = Color3.new(1,1,1)
CollectorTitle.BackgroundTransparency = 1
CollectorTitle.TextXAlignment = Enum.TextXAlignment.Left

local CurrentCoordDisplay = Instance.new("TextLabel", CollectorTab)
CurrentCoordDisplay.Size = UDim2.new(1, -20, 0, 60)
CurrentCoordDisplay.Position = UDim2.new(0, 10, 0, 50)
CurrentCoordDisplay.Text = "Current Position: \nX: 0, Y: 0, Z: 0"
CurrentCoordDisplay.Font = Enum.Font.Gotham
CurrentCoordDisplay.TextSize = 14
CurrentCoordDisplay.TextColor3 = Color3.new(1,1,1)
CurrentCoordDisplay.BackgroundColor3 = CONFIG.UI_LIGHT
CurrentCoordDisplay.TextWrapped = true

local coordCorner = Instance.new("UICorner", CurrentCoordDisplay)
coordCorner.CornerRadius = UDim.new(0, 8)

-- Auto-update coordinates
RunService.RenderStepped:Connect(function()
    local cf = getCurrentCoordinates()
    if cf then
        CurrentCoordDisplay.Text = string.format(
            "Current Position:\nX: %.1f, Y: %.1f, Z: %.1f\n\nRight Click → Copy CFrame",
            cf.X, cf.Y, cf.Z
        )
    end
end)

CurrentCoordDisplay.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        local cf = getCurrentCoordinates()
        if cf then
            copyToClipboard(string.format("CFrame.new(%.1f, %.1f, %.1f)", cf.X, cf.Y, cf.Z))
            showNotification("Collector", "CFrame copied to clipboard!", 2)
        end
    end
end)

local SaveLocationBtn = Instance.new("TextButton", CollectorTab)
SaveLocationBtn.Size = UDim2.new(1, -20, 0, 40)
SaveLocationBtn.Position = UDim2.new(0, 10, 0, 130)
SaveLocationBtn.Text = "💾 Save Current Location"
SaveLocationBtn.Font = Enum.Font.GothamBold
SaveLocationBtn.TextSize = 14
SaveLocationBtn.TextColor3 = Color3.new(1,1,1)
SaveLocationBtn.BackgroundColor3 = CONFIG.UI_ACCENT

local saveCorner = Instance.new("UICorner", SaveLocationBtn)
saveCorner.CornerRadius = UDim.new(0, 8)

SaveLocationBtn.MouseButton1Click:Connect(function()
    local cf = getCurrentCoordinates()
    if cf then
        local name = "Custom_" .. os.time()
        table.insert(Teleports, {
            name = name,
            cat = "Custom",
            cf = cf,
            desc = "Custom saved location"
        })
        showNotification("Collector", "Location saved as: " .. name, 2)
        rebuildTeleportList()
    end
end)

--==================================
-- FAVORITES TAB CONTENT
--==================================
local FavoritesTab = Instance.new("Frame", ContentFrame)
FavoritesTab.Size = UDim2.new(1, 0, 1, 0)
FavoritesTab.BackgroundTransparency = 1
FavoritesTab.Visible = false

--==================================
-- SETTINGS TAB CONTENT
--==================================
local SettingsTab = Instance.new("Frame", ContentFrame)
SettingsTab.Size = UDim2.new(1, 0, 1, 0)
SettingsTab.BackgroundTransparency = 1
SettingsTab.Visible = false

-- Settings options
local settingsY = 10
local function createSetting(text, key)
    local frame = Instance.new("Frame", SettingsTab)
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, settingsY)
    frame.BackgroundColor3 = CONFIG.UI_LIGHT
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggle = Instance.new("TextButton", frame)
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -60, 0.5, -12.5)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 12
    toggle.Text = UserData.settings[key] and "ON" : "OFF"
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.BackgroundColor3 = UserData.settings[key] and CONFIG.UI_ACCENT or Color3.fromRGB(80,80,80)
    
    local toggleCorner = Instance.new("UICorner", toggle)
    toggleCorner.CornerRadius = UDim.new(1, 0)
    
    toggle.MouseButton1Click:Connect(function()
        UserData.settings[key] = not UserData.settings[key]
        toggle.Text = UserData.settings[key] and "ON" : "OFF"
        toggle.BackgroundColor3 = UserData.settings[key] and CONFIG.UI_ACCENT or Color3.fromRGB(80,80,80)
        saveData()
    end)
    
    settingsY = settingsY + 50
end

createSetting("Auto-save data", "autoSave")
createSetting("Show notifications", "showNotifications")
createSetting("Teleport effects", "teleportEffect")
createSetting("Bypass cooldowns", "bypassCooldown")

local SaveSettingsBtn = Instance.new("TextButton", SettingsTab)
SaveSettingsBtn.Size = UDim2.new(1, -20, 0, 40)
SaveSettingsBtn.Position = UDim2.new(0, 10, 0, settingsY + 10)
SaveSettingsBtn.Text = "💾 Save All Settings"
SaveSettingsBtn.Font = Enum.Font.GothamBold
SaveSettingsBtn.TextSize = 14
SaveSettingsBtn.TextColor3 = Color3.new(1,1,1)
SaveSettingsBtn.BackgroundColor3 = CONFIG.UI_ACCENT

local saveSetCorner = Instance.new("UICorner", SaveSettingsBtn)
saveSetCorner.CornerRadius = UDim.new(0, 8)

SaveSettingsBtn.MouseButton1Click:Connect(function()
    saveData()
    showNotification("Settings", "All settings saved!", 2)
end)

--==================================
-- LOCATION LIST BUILDER
--==================================
local function rebuildTeleportList()
    LocationScroll:ClearAllChildren()
    
    local filtered = {}
    for _, tp in ipairs(Teleports) do
        local matchesSearch = SearchBox.Text == "" or 
                            string.find(tp.name:lower(), SearchBox.Text:lower(), 1, true) or
                            string.find(tp.desc:lower(), SearchBox.Text:lower(), 1, true)
        local matchesCategory = SelectedCategory == "All" or tp.cat == SelectedCategory
        
        if matchesSearch and matchesCategory then
            table.insert(filtered, tp)
        end
    end
    
    local yPos = 0
    for i, tp in ipairs(filtered) do
        local entry = Instance.new("Frame", LocationScroll)
        entry.Size = UDim2.new(1, 0, 0, 70)
        entry.Position = UDim2.new(0, 0, 0, yPos)
        entry.BackgroundColor3 = CONFIG.UI_LIGHT
        entry.BorderSizePixel = 0
        
        local entryCorner = Instance.new("UICorner", entry)
        entryCorner.CornerRadius = UDim.new(0, 8)
        
        local nameLabel = Instance.new("TextLabel", entry)
        nameLabel.Size = UDim2.new(0.7, -10, 0, 30)
        nameLabel.Position = UDim2.new(0, 10, 0, 10)
        nameLabel.Text = tp.name
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.TextColor3 = Color3.new(1,1,1)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local catLabel = Instance.new("TextLabel", entry)
        catLabel.Size = UDim2.new(0.3, -10, 0, 20)
        catLabel.Position = UDim2.new(0.7, 0, 0, 10)
        catLabel.Text = "[" .. tp.cat .. "]"
        catLabel.Font = Enum.Font.Gotham
        catLabel.TextSize = 11
        catLabel.TextColor3 = CONFIG.UI_ACCENT
        catLabel.BackgroundTransparency = 1
        catLabel.TextXAlignment = Enum.TextXAlignment.Right
        
        local descLabel = Instance.new("TextLabel", entry)
        descLabel.Size = UDim2.new(1, -20, 0, 30)
        descLabel.Position = UDim2.new(0, 10, 0, 35)
        descLabel.Text = tp.desc or "No description"
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 11
        descLabel.TextColor3 = Color3.fromRGB(180,180,180)
        descLabel.BackgroundTransparency = 1
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local teleportBtn = Instance.new("TextButton", entry)
        teleportBtn.Size = UDim2.new(1, 0, 1, 0)
        teleportBtn.BackgroundTransparency = 1
        teleportBtn.Text = ""
        
        teleportBtn.MouseButton1Click:Connect(function()
            fastSmoothTeleport(tp.cf, tp.name)
        end)
        
        -- Favorite button
        local favBtn = Instance.new("TextButton", entry)
        favBtn.Size = UDim2.new(0, 25, 0, 25)
        favBtn.Position = UDim2.new(1, -30, 0.5, -12.5)
        favBtn.Text = UserData.favorites[tp.name] and "★" : "☆"
        favBtn.Font = Enum.Font.GothamBold
        favBtn.TextSize = 16
        favBtn.TextColor3 = UserData.favorites[tp.name] and Color3.fromRGB(255,215,0) or Color3.fromRGB(150,150,150)
        favBtn.BackgroundTransparency = 1
        
        favBtn.MouseButton1Click:Connect(function()
            if UserData.favorites[tp.name] then
                UserData.favorites[tp.name] = nil
                favBtn.Text = "☆"
                favBtn.TextColor3 = Color3.fromRGB(150,150,150)
            else
                UserData.favorites[tp.name] = true
                favBtn.Text = "★"
                favBtn.TextColor3 = Color3.fromRGB(255,215,0)
            end
            saveData()
        end)
        
        yPos = yPos + 80
    end
    
    LocationScroll.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

--==================================
-- TAB CONTENT UPDATER
--==================================
local function updateContent(tabName)
    TeleportTab.Visible = tabName == "Teleport"
    CollectorTab.Visible = tabName == "Collector"
    FavoritesTab.Visible = tabName == "Favorites"
    SettingsTab.Visible = tabName == "Settings"
    
    if tabName == "Teleport" then
        rebuildTeleportList()
    end
end

--==================================
-- SEARCH FUNCTIONALITY
--==================================
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    rebuildTeleportList()
end)

--==================================
-- MINIMIZE BUBBLE
--==================================
local Bubble = Instance.new("TextButton", gui)
Bubble.Size = UDim2.new(0, 50, 0, 50)
Bubble.Position = UDim2.new(0, 20, 0.5, -25)
Bubble.Text = "🎣"
Bubble.Visible = false
Bubble.BackgroundColor3 = CONFIG.UI_ACCENT
Bubble.TextColor3 = Color3.new(1,1,1)
Bubble.Font = Enum.Font.GothamBold
Bubble.TextSize = 20
Bubble.Active = true
Bubble.Draggable = true
Bubble.AutoButtonColor = false

local bubbleCorner = Instance.new("UICorner", Bubble)
bubbleCorner.CornerRadius = UDim.new(1, 0)

local bubbleStroke = Instance.new("UIStroke", Bubble)
bubbleStroke.Color = Color3.new(1,1,1)
bubbleStroke.Thickness = 2

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    Bubble.Visible = true
end)

Bubble.MouseButton1Click:Connect(function()
    Bubble.Visible = false
    Main.Visible = true
    updateContent(CurrentTab)
end)

--==================================
-- TOGGLE KEYBIND
--==================================
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
        Bubble.Visible = false
        if Main.Visible then
            updateContent(CurrentTab)
        end
    end
end)

--==================================
-- INITIALIZATION
--==================================
rebuildTeleportList()
showNotification("AmsHub v2", "Loaded successfully! Press RightShift to toggle", 3)

-- Auto-save on exit
game:BindToClose(function()
    saveData()
end)
