--==================================
-- AmsHub | Fish It - Enhanced UI (FIXED)
-- Sidebar Toggle + Notification System
--==================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer

--==================================
-- CHARACTER UTILS
--==================================
local function getHRP()
    local char = LP.Character or LP.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

--==================================
-- TELEPORT SETTINGS
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
-- NOTIFICATION SYSTEM
--==================================
local function showNotification(title, message, color)
    color = color or Color3.fromRGB(0, 150, 255)
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, 10, 0.8, 0)
    notification.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    notification.BorderSizePixel = 0
    
    if gui then
        notification.Parent = gui
    else
        notification:Destroy()
        return
    end
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notification
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 2
    stroke.Parent = notification
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.Text = "  " .. title
    titleLabel.TextColor3 = color
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    -- Message
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -20, 1, -50)
    msgLabel.Position = UDim2.new(0, 10, 0, 40)
    msgLabel.Text = message
    msgLabel.TextColor3 = Color3.new(1, 1, 1)
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextSize = 12
    msgLabel.BackgroundTransparency = 1
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextYAlignment = Enum.TextYAlignment.Top
    msgLabel.TextWrapped = true
    msgLabel.Parent = notification
    
    -- Animate in
    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.3), {
        Position = UDim2.new(1, -310, notification.Position.Y.Scale, notification.Position.Y.Offset)
    })
    tweenIn:Play()
    
    -- Auto remove
    task.delay(3, function()
        if notification and notification.Parent then
            local tweenOut = TweenService:Create(notification, TweenInfo.new(0.3), {
                Position = UDim2.new(1, 10, notification.Position.Y.Scale, notification.Position.Y.Offset)
            })
            tweenOut:Play()
            tweenOut.Completed:Connect(function()
                if notification then
                    notification:Destroy()
                end
            end)
        end
    end)
    
    return notification
end

--==================================
-- FAST SMOOTH TELEPORT
--==================================
local function fastSmoothTeleport(cf, locationName)
    local hrp = getHRP()
    local targetCF = cf + TELEPORT_OFFSET

    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(TELEPORT_TIME, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
        {CFrame = targetCF}
    )
    tween:Play()
    
    -- Show notification
    showNotification("📍 Teleported", "Successfully teleported to:\n" .. locationName, Color3.fromRGB(0, 200, 100))
end

--==================================
-- UI CREATION
--==================================
local gui = Instance.new("ScreenGui")
gui.Name = "AmsHubEnhanced"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

-- MAIN FRAME
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 550, 0, 450)
Main.Position = UDim2.new(0.5, -275, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = Color3.fromRGB(0, 150, 255)
mainStroke.Thickness = 2

-- TITLE BAR
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner", TitleBar)
titleCorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "🎣 FISH IT TELEPORT HUB"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

--==================================
-- SIDEBAR TOGGLE SYSTEM
--==================================
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Sidebar.ClipsDescendants = true

-- SIDEBAR HEADER
local SidebarHeader = Instance.new("TextLabel", Sidebar)
SidebarHeader.Size = UDim2.new(1, 0, 0, 50)
SidebarHeader.Text = "📍 TELEPORT LOCATIONS"
SidebarHeader.TextColor3 = Color3.fromRGB(0, 150, 255)
SidebarHeader.Font = Enum.Font.GothamBold
SidebarHeader.TextSize = 14
SidebarHeader.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
SidebarHeader.BorderSizePixel = 0

-- CATEGORY TOGGLE BUTTONS
local Categories = {
    {name = "Island", icon = "🏝️", color = Color3.fromRGB(0, 180, 100)},
    {name = "Depth", icon = "🌊", color = Color3.fromRGB(0, 120, 255)},
    {name = "Secret", icon = "🔒", color = Color3.fromRGB(200, 0, 200)},
    {name = "All", icon = "📍", color = Color3.fromRGB(255, 150, 0)}
}

local CategoryButtons = {}
local SelectedCategory = "Island"

--==================================
-- CONTENT AREA
--==================================
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -160, 1, -40)
Content.Position = UDim2.new(0, 160, 0, 40)
Content.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Content.ClipsDescendants = true

-- LOCATION LIST HEADER
local ListHeader = Instance.new("Frame", Content)
ListHeader.Size = UDim2.new(1, 0, 0, 60)
ListHeader.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ListHeader.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner", ListHeader)
headerCorner.CornerRadius = UDim.new(0, 12)

local HeaderTitle = Instance.new("TextLabel", ListHeader)
HeaderTitle.Size = UDim2.new(1, -20, 0, 30)
HeaderTitle.Position = UDim2.new(0, 15, 0, 10)
HeaderTitle.Text = "ISLAND LOCATIONS"
HeaderTitle.TextColor3 = Color3.new(1, 1, 1)
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextSize = 18
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left

local HeaderSubtitle = Instance.new("TextLabel", ListHeader)
HeaderSubtitle.Size = UDim2.new(1, -20, 0, 20)
HeaderSubtitle.Position = UDim2.new(0, 15, 0, 35)
HeaderSubtitle.Text = "Click any location to teleport"
HeaderSubtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
HeaderSubtitle.Font = Enum.Font.Gotham
HeaderSubtitle.TextSize = 12
HeaderSubtitle.BackgroundTransparency = 1
HeaderSubtitle.TextXAlignment = Enum.TextXAlignment.Left

-- SEARCH BAR
local SearchContainer = Instance.new("Frame", Content)
SearchContainer.Size = UDim2.new(1, -20, 0, 50)
SearchContainer.Position = UDim2.new(0, 10, 0, 70)
SearchContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Instance.new("UICorner", SearchContainer).CornerRadius = UDim.new(0, 10)

local SearchIcon = Instance.new("TextLabel", SearchContainer)
SearchIcon.Size = UDim2.new(0, 40, 1, 0)
SearchIcon.Text = "🔍"
SearchIcon.Font = Enum.Font.Gotham
SearchIcon.TextSize = 16
SearchIcon.TextColor3 = Color3.fromRGB(150, 150, 150)
SearchIcon.BackgroundTransparency = 1

local SearchBox = Instance.new("TextBox", SearchContainer)
SearchBox.Size = UDim2.new(1, -50, 1, 0)
SearchBox.Position = UDim2.new(0, 40, 0, 0)
SearchBox.PlaceholderText = "Search location by name..."
SearchBox.Text = ""
SearchBox.ClearTextOnFocus = false
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 14
SearchBox.TextColor3 = Color3.new(1, 1, 1)
SearchBox.BackgroundTransparency = 1
SearchBox.TextXAlignment = Enum.TextXAlignment.Left

-- LOCATION LIST (SCROLLING)
local LocationScroll = Instance.new("ScrollingFrame", Content)
LocationScroll.Size = UDim2.new(1, -20, 1, -140)
LocationScroll.Position = UDim2.new(0, 10, 0, 130)
LocationScroll.BackgroundTransparency = 1
LocationScroll.ScrollBarThickness = 6
LocationScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
LocationScroll.ClipsDescendants = true

local LocationContainer = Instance.new("Frame", LocationScroll)
LocationContainer.Size = UDim2.new(1, 0, 1, 0)
LocationContainer.BackgroundTransparency = 1
LocationContainer.ClipsDescendants = true

local LocationLayout = Instance.new("UIListLayout", LocationContainer)
LocationLayout.Padding = UDim.new(0, 10)
LocationLayout.SortOrder = Enum.SortOrder.LayoutOrder

--==================================
-- HELPER FUNCTIONS (DEFINED BEFORE USE)
--==================================
local function countLocations(category)
    if category == "All" then
        return #Teleports
    end
    
    local count = 0
    for _, tp in ipairs(Teleports) do
        if tp.cat == category then
            count = count + 1
        end
    end
    return count
end

local function updateHeader()
    local count = countLocations(SelectedCategory)
    local icon = ""
    local color = Color3.fromRGB(0, 150, 255)
    
    for _, cat in ipairs(Categories) do
        if cat.name == SelectedCategory then
            icon = cat.icon
            color = cat.color
            break
        end
    end
    
    HeaderTitle.Text = icon .. " " .. SelectedCategory:upper() .. " LOCATIONS"
    HeaderTitle.TextColor3 = color
    HeaderSubtitle.Text = count .. " locations available • Click to teleport"
end

local function createLocationCard(location, index)
    local card = Instance.new("Frame", LocationContainer)
    card.Size = UDim2.new(1, 0, 0, 70)
    card.LayoutOrder = index
    card.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    
    local cardCorner = Instance.new("UICorner", card)
    cardCorner.CornerRadius = UDim.new(0, 10)
    
    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = Color3.fromRGB(50, 50, 60)
    cardStroke.Thickness = 2
    
    -- Category badge
    local badge = Instance.new("Frame", card)
    badge.Size = UDim2.new(0, 80, 0, 22)
    badge.Position = UDim2.new(0, 15, 0, 10)
    
    local badgeColor = Color3.fromRGB(0, 150, 255)
    if location.cat == "Island" then
        badgeColor = Color3.fromRGB(0, 180, 100)
    elseif location.cat == "Depth" then
        badgeColor = Color3.fromRGB(0, 120, 255)
    elseif location.cat == "Secret" then
        badgeColor = Color3.fromRGB(200, 0, 200)
    end
    
    badge.BackgroundColor3 = badgeColor
    Instance.new("UICorner", badge).CornerRadius = UDim.new(1, 0)
    
    local badgeText = Instance.new("TextLabel", badge)
    badgeText.Size = UDim2.new(1, 0, 1, 0)
    badgeText.Text = location.cat:upper()
    badgeText.TextColor3 = Color3.new(1, 1, 1)
    badgeText.Font = Enum.Font.GothamBold
    badgeText.TextSize = 10
    badgeText.BackgroundTransparency = 1
    
    -- Location name
    local nameLabel = Instance.new("TextLabel", card)
    nameLabel.Size = UDim2.new(1, -110, 0, 30)
    nameLabel.Position = UDim2.new(0, 110, 0, 10)
    nameLabel.Text = location.name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 16
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Coordinates (simplified)
    local coordLabel = Instance.new("TextLabel", card)
    coordLabel.Size = UDim2.new(1, -110, 0, 20)
    coordLabel.Position = UDim2.new(0, 110, 0, 40)
    coordLabel.Text = string.format("X: %.0f  Y: %.0f  Z: %.0f", 
        location.cf.X, location.cf.Y, location.cf.Z)
    coordLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    coordLabel.Font = Enum.Font.Gotham
    coordLabel.TextSize = 11
    coordLabel.BackgroundTransparency = 1
    coordLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Teleport button (entire card)
    local teleportBtn = Instance.new("TextButton", card)
    teleportBtn.Size = UDim2.new(1, 0, 1, 0)
    teleportBtn.BackgroundTransparency = 1
    teleportBtn.Text = ""
    teleportBtn.AutoButtonColor = false
    
    -- Hover effect
    teleportBtn.MouseEnter:Connect(function()
        if card and card.Parent then
            TweenService:Create(card, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            }):Play()
            TweenService:Create(cardStroke, TweenInfo.new(0.2), {
                Color = badgeColor
            }):Play()
        end
    end)
    
    teleportBtn.MouseLeave:Connect(function()
        if card and card.Parent then
            TweenService:Create(card, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            }):Play()
            TweenService:Create(cardStroke, TweenInfo.new(0.2), {
                Color = Color3.fromRGB(50, 50, 60)
            }):Play()
        end
    end)
    
    -- Click to teleport
    teleportBtn.MouseButton1Click:Connect(function()
        fastSmoothTeleport(location.cf, location.name)
        
        -- Visual feedback on card
        if card and card.Parent then
            local originalColor = card.BackgroundColor3
            TweenService:Create(card, TweenInfo.new(0.1), {
                BackgroundColor3 = badgeColor
            }):Play()
            
            task.wait(0.1)
            
            TweenService:Create(card, TweenInfo.new(0.3), {
                BackgroundColor3 = originalColor
            }):Play()
        end
    end)
    
    return card
end

-- MAIN FUNCTION TO UPDATE LOCATION LIST (MUST BE DEFINED BEFORE BEING CALLED)
local function updateLocationList()
    -- Clear previous cards
    for _, child in ipairs(LocationContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local searchText = SearchBox.Text:lower()
    local locationsAdded = 0
    
    -- Filter and create cards
    for i, location in ipairs(Teleports) do
        -- Category filter
        local categoryMatch = (SelectedCategory == "All") or (location.cat == SelectedCategory)
        
        -- Search filter
        local searchMatch = (searchText == "") or 
                           (string.find(location.name:lower(), searchText, 1, true)) or
                           (string.find(location.cat:lower(), searchText, 1, true))
        
        if categoryMatch and searchMatch then
            createLocationCard(location, i)
            locationsAdded = locationsAdded + 1
        end
    end
    
    -- Update scroll size
    local cardHeight = 80  -- 70 height + 10 padding
    local totalHeight = locationsAdded * cardHeight
    local maxHeight = LocationScroll.AbsoluteSize.Y
    
    if totalHeight > maxHeight then
        LocationScroll.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        LocationContainer.Size = UDim2.new(1, 0, 0, totalHeight)
    else
        LocationScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        LocationContainer.Size = UDim2.new(1, 0, 1, 0)
    end
    
    -- Update header
    updateHeader()
    
    -- If no results
    if locationsAdded == 0 then
        local noResults = Instance.new("TextLabel", LocationContainer)
        noResults.Size = UDim2.new(1, 0, 0, 100)
        noResults.Text = "🔍 No locations found\nTry a different search or category"
        noResults.TextColor3 = Color3.fromRGB(150, 150, 170)
        noResults.Font = Enum.Font.Gotham
        noResults.TextSize = 14
        noResults.BackgroundTransparency = 1
        noResults.TextWrapped = true
    end
end

--==================================
-- CREATE CATEGORY BUTTONS (SETUP AFTER FUNCTIONS ARE DEFINED)
--==================================
for i, cat in ipairs(Categories) do
    local catBtn = Instance.new("TextButton", Sidebar)
    catBtn.Size = UDim2.new(1, -10, 0, 45)
    catBtn.Position = UDim2.new(0, 5, 0, 60 + (i-1)*55)
    catBtn.Text = cat.icon .. " " .. cat.name:upper()
    catBtn.Font = Enum.Font.GothamBold
    catBtn.TextSize = 13
    catBtn.TextColor3 = Color3.new(1, 1, 1)
    catBtn.BackgroundColor3 = cat.color
    catBtn.AutoButtonColor = false
    Instance.new("UICorner", catBtn).CornerRadius = UDim.new(0, 8)
    
    -- Highlight selected category
    if cat.name == "Island" then
        catBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        catBtn.TextColor3 = cat.color
    end
    
    -- Store original color
    catBtn.OriginalColor = cat.color
    CategoryButtons[cat.name] = catBtn
end

--==================================
-- EVENT LISTENERS (SETUP AFTER FUNCTIONS ARE DEFINED)
--==================================
-- Category button click handlers
for _, cat in ipairs(Categories) do
    local catBtn = CategoryButtons[cat.name]
    if catBtn then
        catBtn.MouseButton1Click:Connect(function()
            -- Reset all buttons
            for btnName, btn in pairs(CategoryButtons) do
                if btn and btn.Parent then
                    btn.BackgroundColor3 = btn.OriginalColor
                    btn.TextColor3 = Color3.new(1, 1, 1)
                end
            end
            
            -- Highlight selected
            if catBtn and catBtn.Parent then
                catBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                catBtn.TextColor3 = cat.color
            end
            
            -- Update selection
            SelectedCategory = cat.name
            updateLocationList()
            
            -- Show notification
            showNotification("📂 Category Selected", 
                "Now viewing: " .. cat.name .. " locations\n(" .. countLocations(cat.name) .. " available)",
                cat.color)
        end)
    end
end

-- Search box listener
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    if updateLocationList then
        updateLocationList()
    end
end)

--==================================
-- MINIMIZE SYSTEM
--==================================
local Bubble = Instance.new("TextButton", gui)
Bubble.Size = UDim2.new(0, 50, 0, 50)
Bubble.Position = UDim2.new(0, 20, 0.5, -25)
Bubble.Text = "🎣"
Bubble.Visible = false
Bubble.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Bubble.TextColor3 = Color3.new(1, 1, 1)
Bubble.Font = Enum.Font.GothamBold
Bubble.TextSize = 20
Bubble.Active = true
Bubble.Draggable = true
Bubble.AutoButtonColor = false
Instance.new("UICorner", Bubble).CornerRadius = UDim.new(1, 0)

local MinBtn = Instance.new("TextButton", TitleBar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -40, 0.5, -15)
MinBtn.Text = "-"
MinBtn.BackgroundTransparency = 1
MinBtn.TextColor3 = Color3.new(1, 1, 1)

MinBtn.MouseButton1Click:Connect(function()
    if Main and Main.Parent then
        Main.Visible = false
    end
    if Bubble and Bubble.Parent then
        Bubble.Visible = true
    end
    showNotification("📱 Minimized", "UI minimized to bubble\nClick bubble or press RightShift", 
        Color3.fromRGB(255, 150, 0))
end)

if Bubble then
    Bubble.MouseButton1Click:Connect(function()
        if Bubble and Bubble.Parent then
            Bubble.Visible = false
        end
        if Main and Main.Parent then
            Main.Visible = true
        end
        showNotification("📱 Restored", "Teleport hub restored", 
            Color3.fromRGB(0, 200, 100))
    end)
end

--==================================
-- HOTKEY TOGGLE
--==================================
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if Main and Main.Parent then
            Main.Visible = not Main.Visible
        end
        if Bubble and Bubble.Parent then
            Bubble.Visible = false
        end
        if Main and Main.Visible then
            showNotification("🎣 Hub Opened", "Teleport hub is now open", 
                Color3.fromRGB(0, 150, 255))
        end
    end
end)

--==================================
-- INITIALIZATION
--==================================
-- Initialize location list
if updateLocationList then
    updateLocationList()
end

-- Initial notification
task.wait(0.5)
showNotification("🎣 Welcome!", "Fish It Teleport Hub loaded!\n" .. #Teleports .. " locations available", 
    Color3.fromRGB(0, 150, 255))

print("✅ Enhanced Teleport Hub Loaded Successfully!")
print("📍 Categories: Island, Depth, Secret, All")
print("🔔 Notification system active")
print("🎯 RightShift to toggle UI")
