--==================================
-- AmsHub | Fish It - Compact Collapsible UI
--==================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

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
local TELEPORT_TIME = 0.03

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
-- NOTIFICATION SYSTEM (COMPACT)
--==================================
local function showNotification(title, message, color)
    color = color or Color3.fromRGB(0, 150, 255)
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 250, 0, 65)
    notification.Position = UDim2.new(1, 10, 0.85, 0)
    notification.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    notification.BorderSizePixel = 0
    
    if gui then
        notification.Parent = gui
    else
        notification:Destroy()
        return
    end
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 1.5
    stroke.Parent = notification
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -15, 0, 20)
    titleLabel.Position = UDim2.new(0, 10, 0, 8)
    titleLabel.Text = "  " .. title
    titleLabel.TextColor3 = color
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 12
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    -- Message
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -15, 1, -35)
    msgLabel.Position = UDim2.new(0, 10, 0, 28)
    msgLabel.Text = message
    msgLabel.TextColor3 = Color3.new(1, 1, 1)
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextSize = 11
    msgLabel.BackgroundTransparency = 1
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextYAlignment = Enum.TextYAlignment.Top
    msgLabel.TextWrapped = true
    msgLabel.Parent = notification
    
    -- Animate in
    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.25), {
        Position = UDim2.new(1, -260, notification.Position.Y.Scale, notification.Position.Y.Offset)
    })
    tweenIn:Play()
    
    -- Auto remove
    task.delay(2.5, function()
        if notification and notification.Parent then
            local tweenOut = TweenService:Create(notification, TweenInfo.new(0.25), {
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
    
    showNotification("📍 Teleported", locationName, Color3.fromRGB(0, 200, 100))
end

--==================================
-- COMPACT UI CREATION (50% SMALLER)
--==================================
local gui = Instance.new("ScreenGui")
gui.Name = "AmsHubCompact"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

-- MAIN FRAME (COMPACT SIZE)
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 400, 0, 320)  -- 50% lebih kecil dari 550x450
Main.Position = UDim2.new(0.5, -200, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = Color3.fromRGB(0, 120, 255)
mainStroke.Thickness = 1.5

-- TITLE BAR (COMPACT)
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner", TitleBar)
titleCorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "🎣 FISH HUB"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

--==================================
-- COLLAPSIBLE SIDEBAR SYSTEM
--==================================
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 90, 1, -32)  -- Lebih sempit
Sidebar.Position = UDim2.new(0, 0, 0, 32)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Sidebar.ClipsDescendants = true

-- MAIN TELEPORT BUTTON (PARENT)
local TeleportParentBtn = Instance.new("TextButton", Sidebar)
TeleportParentBtn.Size = UDim2.new(1, -10, 0, 36)
TeleportParentBtn.Position = UDim2.new(0, 5, 0, 10)
TeleportParentBtn.Text = "📍 TELEPORT"
TeleportParentBtn.Font = Enum.Font.GothamBold
TeleportParentBtn.TextSize = 12
TeleportParentBtn.TextColor3 = Color3.new(1, 1, 1)
TeleportParentBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
TeleportParentBtn.AutoButtonColor = false
Instance.new("UICorner", TeleportParentBtn).CornerRadius = UDim.new(0, 6)

-- DROPDOWN ARROW
local DropdownArrow = Instance.new("TextLabel", TeleportParentBtn)
DropdownArrow.Size = UDim2.new(0, 20, 1, 0)
DropdownArrow.Position = UDim2.new(1, -22, 0, 0)
DropdownArrow.Text = "▼"
DropdownArrow.TextColor3 = Color3.new(1, 1, 1)
DropdownArrow.Font = Enum.Font.GothamBold
DropdownArrow.TextSize = 10
DropdownArrow.BackgroundTransparency = 1
DropdownArrow.TextXAlignment = Enum.TextXAlignment.Center

-- CATEGORY SUB-BUTTONS (HIDDEN INITIALLY)
local CategoryContainer = Instance.new("Frame", Sidebar)
CategoryContainer.Size = UDim2.new(1, -10, 0, 0)
CategoryContainer.Position = UDim2.new(0, 5, 0, 56)
CategoryContainer.BackgroundTransparency = 1
CategoryContainer.ClipsDescendants = true

local CategoryLayout = Instance.new("UIListLayout", CategoryContainer)
CategoryLayout.Padding = UDim.new(0, 4)
CategoryLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- CATEGORY DATA
local CategoryData = {
    Island = {icon = "🏝️", color = Color3.fromRGB(0, 180, 100)},
    Depth = {icon = "🌊", color = Color3.fromRGB(0, 100, 255)},
    Secret = {icon = "🔒", color = Color3.fromRGB(180, 0, 180)},
    All = {icon = "📍", color = Color3.fromRGB(255, 140, 0)}
}

local CategoryButtons = {}
local SelectedCategory = "Island"
local DropdownOpen = false

-- Function to create category sub-buttons
local function createCategoryButton(categoryName, layoutOrder)
    local categoryInfo = CategoryData[categoryName]
    if not categoryInfo then return end
    
    local catBtn = Instance.new("TextButton", CategoryContainer)
    catBtn.Size = UDim2.new(1, 0, 0, 30)  -- Compact size
    catBtn.LayoutOrder = layoutOrder
    catBtn.Text = categoryInfo.icon .. " " .. categoryName
    catBtn.Font = Enum.Font.GothamSemibold
    catBtn.TextSize = 11
    catBtn.TextColor3 = Color3.new(1, 1, 1)
    catBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    catBtn.AutoButtonColor = false
    catBtn.Visible = false
    Instance.new("UICorner", catBtn).CornerRadius = UDim.new(0, 5)
    
    -- Highlight selected category
    if categoryName == "Island" then
        catBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        catBtn.TextColor3 = categoryInfo.color
    end
    
    -- Store button reference
    CategoryButtons[categoryName] = {
        Button = catBtn,
        OriginalColor = categoryInfo.color
    }
    
    -- Click handler
    catBtn.MouseButton1Click:Connect(function()
        -- Reset all buttons
        for name, data in pairs(CategoryButtons) do
            if data.Button and data.Button.Parent then
                data.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                data.Button.TextColor3 = Color3.new(1, 1, 1)
            end
        end
        
        -- Highlight selected
        if catBtn and catBtn.Parent then
            catBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            catBtn.TextColor3 = categoryInfo.color
        end
        
        -- Update selection
        SelectedCategory = categoryName
        updateLocationList()
        
        -- Collapse dropdown
        toggleDropdown()
        
        -- Show notification
        showNotification("📂 " .. categoryName, countLocations(categoryName) .. " locations", categoryInfo.color)
    end)
    
    return catBtn
end

-- Create category buttons
createCategoryButton("Island", 1)
createCategoryButton("Depth", 2)
createCategoryButton("Secret", 3)
createCategoryButton("All", 4)

-- Toggle dropdown function
local function toggleDropdown()
    DropdownOpen = not DropdownOpen
    
    if DropdownOpen then
        -- Open dropdown
        DropdownArrow.Text = "▲"
        CategoryContainer.Size = UDim2.new(1, -10, 0, 136) -- 4 buttons * 30 + 3*4 padding
        
        -- Show all category buttons
        for _, data in pairs(CategoryButtons) do
            if data.Button then
                data.Button.Visible = true
            end
        end
        
        -- Highlight main button
        TeleportParentBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    else
        -- Close dropdown
        DropdownArrow.Text = "▼"
        CategoryContainer.Size = UDim2.new(1, -10, 0, 0)
        
        -- Hide all category buttons
        for _, data in pairs(CategoryButtons) do
            if data.Button then
                data.Button.Visible = false
            end
        end
        
        -- Reset main button color
        TeleportParentBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    end
end

TeleportParentBtn.MouseButton1Click:Connect(toggleDropdown)

--==================================
-- CONTENT AREA (COMPACT)
--==================================
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -90, 1, -32)
Content.Position = UDim2.new(0, 90, 0, 32)
Content.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Content.ClipsDescendants = true

-- HEADER (COMPACT)
local Header = Instance.new("Frame", Content)
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Header.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner", Header)
headerCorner.CornerRadius = UDim.new(0, 8)

local HeaderTitle = Instance.new("TextLabel", Header)
HeaderTitle.Size = UDim2.new(1, -15, 0, 25)
HeaderTitle.Position = UDim2.new(0, 10, 0, 5)
HeaderTitle.Text = "🏝️ ISLAND LOCATIONS"
HeaderTitle.TextColor3 = Color3.fromRGB(0, 180, 100)
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextSize = 14
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left

local HeaderSubtitle = Instance.new("TextLabel", Header)
HeaderSubtitle.Size = UDim2.new(1, -15, 0, 15)
HeaderSubtitle.Position = UDim2.new(0, 10, 0, 27)
HeaderSubtitle.Text = "5 locations"
HeaderSubtitle.TextColor3 = Color3.fromRGB(150, 150, 170)
HeaderSubtitle.Font = Enum.Font.Gotham
HeaderSubtitle.TextSize = 10
HeaderSubtitle.BackgroundTransparency = 1
HeaderSubtitle.TextXAlignment = Enum.TextXAlignment.Left

-- SEARCH BAR (COMPACT)
local SearchContainer = Instance.new("Frame", Content)
SearchContainer.Size = UDim2.new(1, -15, 0, 36)
SearchContainer.Position = UDim2.new(0, 7.5, 0, 55)
SearchContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Instance.new("UICorner", SearchContainer).CornerRadius = UDim.new(0, 6)

local SearchIcon = Instance.new("TextLabel", SearchContainer)
SearchIcon.Size = UDim2.new(0, 30, 1, 0)
SearchIcon.Text = "🔍"
SearchIcon.Font = Enum.Font.Gotham
SearchIcon.TextSize = 14
SearchIcon.TextColor3 = Color3.fromRGB(120, 120, 140)
SearchIcon.BackgroundTransparency = 1

local SearchBox = Instance.new("TextBox", SearchContainer)
SearchBox.Size = UDim2.new(1, -35, 1, 0)
SearchBox.Position = UDim2.new(0, 30, 0, 0)
SearchBox.PlaceholderText = "Search..."
SearchBox.Text = ""
SearchBox.ClearTextOnFocus = false
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 12
SearchBox.TextColor3 = Color3.new(1, 1, 1)
SearchBox.BackgroundTransparency = 1
SearchBox.TextXAlignment = Enum.TextXAlignment.Left

-- LOCATION LIST (COMPACT SCROLLING)
local LocationScroll = Instance.new("ScrollingFrame", Content)
LocationScroll.Size = UDim2.new(1, -15, 1, -105)
LocationScroll.Position = UDim2.new(0, 7.5, 0, 100)
LocationScroll.BackgroundTransparency = 1
LocationScroll.ScrollBarThickness = 4
LocationScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 120, 255)
LocationScroll.ClipsDescendants = true

local LocationContainer = Instance.new("Frame", LocationScroll)
LocationContainer.Size = UDim2.new(1, 0, 1, 0)
LocationContainer.BackgroundTransparency = 1
LocationContainer.ClipsDescendants = true

local LocationLayout = Instance.new("UIListLayout", LocationContainer)
LocationLayout.Padding = UDim.new(0, 6)
LocationLayout.SortOrder = Enum.SortOrder.LayoutOrder

--==================================
-- HELPER FUNCTIONS
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
    local categoryInfo = CategoryData[SelectedCategory] or CategoryData["Island"]
    
    HeaderTitle.Text = categoryInfo.icon .. " " .. SelectedCategory:upper() .. " LOCATIONS"
    HeaderTitle.TextColor3 = categoryInfo.color
    HeaderSubtitle.Text = count .. " locations • Click to teleport"
end

local function createLocationCard(location, index)
    local card = Instance.new("Frame", LocationContainer)
    card.Size = UDim2.new(1, 0, 0, 50)  -- Compact size
    card.LayoutOrder = index
    card.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    
    local cardCorner = Instance.new("UICorner", card)
    cardCorner.CornerRadius = UDim.new(0, 6)
    
    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = Color3.fromRGB(50, 50, 60)
    cardStroke.Thickness = 1
    
    -- Category indicator (small left border)
    local indicator = Instance.new("Frame", card)
    indicator.Size = UDim2.new(0, 4, 1, -10)
    indicator.Position = UDim2.new(0, 3, 0, 5)
    
    if location.cat == "Island" then
        indicator.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    elseif location.cat == "Depth" then
        indicator.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    elseif location.cat == "Secret" then
        indicator.BackgroundColor3 = Color3.fromRGB(180, 0, 180)
    end
    
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 2)
    
    -- Location name
    local nameLabel = Instance.new("TextLabel", card)
    nameLabel.Size = UDim2.new(1, -25, 0, 30)
    nameLabel.Position = UDim2.new(0, 15, 0, 5)
    nameLabel.Text = location.name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Category tag
    local tagLabel = Instance.new("TextLabel", card)
    tagLabel.Size = UDim2.new(0, 50, 0, 18)
    tagLabel.Position = UDim2.new(0, 15, 0, 32)
    tagLabel.Text = location.cat
    tagLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    tagLabel.Font = Enum.Font.GothamSemibold
    tagLabel.TextSize = 9
    tagLabel.BackgroundTransparency = 1
    tagLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Teleport button (entire card)
    local teleportBtn = Instance.new("TextButton", card)
    teleportBtn.Size = UDim2.new(1, 0, 1, 0)
    teleportBtn.BackgroundTransparency = 1
    teleportBtn.Text = ""
    teleportBtn.AutoButtonColor = false
    
    -- Hover effect
    teleportBtn.MouseEnter:Connect(function()
        if card and card.Parent then
            TweenService:Create(card, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            }):Play()
        end
    end)
    
    teleportBtn.MouseLeave:Connect(function()
        if card and card.Parent then
            TweenService:Create(card, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            }):Play()
        end
    end)
    
    -- Click to teleport
    teleportBtn.MouseButton1Click:Connect(function()
        fastSmoothTeleport(location.cf, location.name)
        
        -- Quick flash feedback
        if card and card.Parent then
            local originalColor = card.BackgroundColor3
            TweenService:Create(card, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            }):Play()
            
            task.wait(0.1)
            
            TweenService:Create(card, TweenInfo.new(0.2), {
                BackgroundColor3 = originalColor
            }):Play()
        end
    end)
end

-- MAIN FUNCTION TO UPDATE LOCATION LIST
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
                           (string.find(location.name:lower(), searchText, 1, true))
        
        if categoryMatch and searchMatch then
            createLocationCard(location, i)
            locationsAdded = locationsAdded + 1
        end
    end
    
    -- Update scroll size
    local cardHeight = 56  -- 50 height + 6 padding
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
        noResults.Size = UDim2.new(1, 0, 0, 80)
        noResults.Text = "🔍 No locations found"
        noResults.TextColor3 = Color3.fromRGB(120, 120, 140)
        noResults.Font = Enum.Font.Gotham
        noResults.TextSize = 12
        noResults.BackgroundTransparency = 1
        noResults.TextWrapped = true
    end
end

--==================================
-- EVENT LISTENERS
--==================================
SearchBox:GetPropertyChangedSignal("Text"):Connect(updateLocationList)

--==================================
-- MINIMIZE SYSTEM (COMPACT)
--==================================
local Bubble = Instance.new("TextButton", gui)
Bubble.Size = UDim2.new(0, 40, 0, 40)  -- Smaller
Bubble.Position = UDim2.new(0, 15, 0.5, -20)
Bubble.Text = "🎣"
Bubble.Visible = false
Bubble.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Bubble.TextColor3 = Color3.new(1, 1, 1)
Bubble.Font = Enum.Font.GothamBold
Bubble.TextSize = 16
Bubble.Active = true
Bubble.Draggable = true
Bubble.AutoButtonColor = false
Instance.new("UICorner", Bubble).CornerRadius = UDim.new(1, 0)

local MinBtn = Instance.new("TextButton", TitleBar)
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -30, 0.5, -12.5)
MinBtn.Text = "-"
MinBtn.BackgroundTransparency = 1
MinBtn.TextColor3 = Color3.new(1, 1, 1)

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    Bubble.Visible = true
    showNotification("📱 Minimized", "Click bubble to restore", Color3.fromRGB(255, 140, 0))
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
        if Main.Visible then
            updateLocationList()
        end
    end
end)

--==================================
-- INITIALIZATION
--==================================
updateLocationList()

-- Initial notification
task.wait(0.5)
showNotification("🎣 Compact Hub", #Teleports .. " locations loaded", Color3.fromRGB(0, 150, 255))

print("✅ Compact Teleport Hub Loaded!")
print("📱 Size: 400×320 (50% smaller)")
print("📍 Categories in dropdown menu")
print("🎯 RightShift to toggle")
