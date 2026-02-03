--==================================
-- AmsHub | Fish It - Clean Version
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
    -- ISLAND (5 locations)
    {name="Fisherman Island", cat="Island", cf=CFrame.new(197.34857177734375, 2.6072463989257812, 2796.57373046875)},
    {name="Kohana", cat="Island", cf=CFrame.new(-624.4239501953125, 7.744749546051025, 676.2808227539062)},
    {name="Tropical Grove", cat="Island", cf=CFrame.new(-2033.400146484375, 6.2680158615112305, 3715.0341796875)},
    {name="Ancient Jungle", cat="Island", cf=CFrame.new(1463.75439453125, 7.6254987716674805, -321.6741943359375)},
    {name="Creater Island", cat="Island", cf=CFrame.new(1012.2926635742188, 3.6445138454437256, 5153.46435546875)},

    -- DEPTH (4 locations)
    {name="Coral Reefs", cat="Depth", cf=CFrame.new(-2920.48095703125, 3.2499992847442627, 2072.742919921875)},
    {name="Esoteric Depths", cat="Depth", cf=CFrame.new(3208.166259765625, -1302.8551025390625, 1446.6112060546875)},
    {name="Crystal Depths", cat="Depth", cf=CFrame.new(5637, -904.9847412109375, 15354)},
    {name="Kohana Volcano", cat="Depth", cf=CFrame.new(-424.22802734375, 7.2453107833862305, 123.47695922851562)},

    -- SECRET (7 locations)
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
-- COMPACT UI CREATION
--==================================
local gui = Instance.new("ScreenGui")
gui.Name = "AmsHubClean"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

-- MAIN FRAME (COMPACT SIZE)
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 400, 0, 320)
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
-- CLEAN SIDEBAR (TELEPORT ONLY)
--==================================
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 90, 1, -32)
Sidebar.Position = UDim2.new(0, 0, 0, 32)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Sidebar.ClipsDescendants = true

-- TELEPORT PARENT BUTTON
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

-- SETTINGS BUTTON (SIMPLE)
local SettingsBtn = Instance.new("TextButton", Sidebar)
SettingsBtn.Size = UDim2.new(1, -10, 0, 36)
SettingsBtn.Position = UDim2.new(0, 5, 0, 210)
SettingsBtn.Text = "⚙️ SETTINGS"
SettingsBtn.Font = Enum.Font.GothamBold
SettingsBtn.TextSize = 12
SettingsBtn.TextColor3 = Color3.new(1, 1, 1)
SettingsBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
SettingsBtn.AutoButtonColor = false
Instance.new("UICorner", SettingsBtn).CornerRadius = UDim.new(0, 6)

-- CATEGORY SUB-BUTTONS (HIDDEN INITIALLY)
local CategoryContainer = Instance.new("Frame", Sidebar)
CategoryContainer.Size = UDim2.new(1, -10, 0, 0)
CategoryContainer.Position = UDim2.new(0, 5, 0, 56)
CategoryContainer.BackgroundTransparency = 1
CategoryContainer.ClipsDescendants = true

local CategoryLayout = Instance.new("UIListLayout", CategoryContainer)
CategoryLayout.Padding = UDim.new(0, 4)
CategoryLayout.SortOrder = Enum.SortOrder.LayoutOrder

--==================================
-- CONTENT AREA (COMPACT)
--==================================
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -90, 1, -32)
Content.Position = UDim2.new(0, 90, 0, 32)
Content.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Content.ClipsDescendants = true

-- PANELS (TELEPORT & SETTINGS)
local Panels = {
    Teleport = Instance.new("Frame", Content),
    Settings = Instance.new("Frame", Content)
}

for name, panel in pairs(Panels) do
    panel.Size = UDim2.new(1, 0, 1, 0)
    panel.BackgroundTransparency = 1
    panel.Visible = false
end
Panels.Teleport.Visible = true

--==================================
-- TELEPORT PANEL
--==================================
local TeleportPanel = Panels.Teleport

-- HEADER
local TPHeader = Instance.new("Frame", TeleportPanel)
TPHeader.Size = UDim2.new(1, 0, 0, 45)
TPHeader.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TPHeader.BorderSizePixel = 0
Instance.new("UICorner", TPHeader).CornerRadius = UDim.new(0, 8)

local TPHeaderTitle = Instance.new("TextLabel", TPHeader)
TPHeaderTitle.Size = UDim2.new(1, -15, 0, 25)
TPHeaderTitle.Position = UDim2.new(0, 10, 0, 5)
TPHeaderTitle.Text = "🏝️ ISLAND LOCATIONS"
TPHeaderTitle.TextColor3 = Color3.fromRGB(0, 180, 100)
TPHeaderTitle.Font = Enum.Font.GothamBold
TPHeaderTitle.TextSize = 14
TPHeaderTitle.BackgroundTransparency = 1
TPHeaderTitle.TextXAlignment = Enum.TextXAlignment.Left

local TPHeaderSubtitle = Instance.new("TextLabel", TPHeader)
TPHeaderSubtitle.Size = UDim2.new(1, -15, 0, 15)
TPHeaderSubtitle.Position = UDim2.new(0, 10, 0, 27)
TPHeaderSubtitle.Text = "5 locations"
TPHeaderSubtitle.TextColor3 = Color3.fromRGB(150, 150, 170)
TPHeaderSubtitle.Font = Enum.Font.Gotham
TPHeaderSubtitle.TextSize = 10
TPHeaderSubtitle.BackgroundTransparency = 1
TPHeaderSubtitle.TextXAlignment = Enum.TextXAlignment.Left

-- SEARCH BAR
local TPSearchContainer = Instance.new("Frame", TeleportPanel)
TPSearchContainer.Size = UDim2.new(1, -15, 0, 36)
TPSearchContainer.Position = UDim2.new(0, 7.5, 0, 55)
TPSearchContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Instance.new("UICorner", TPSearchContainer).CornerRadius = UDim.new(0, 6)

local TPSearchIcon = Instance.new("TextLabel", TPSearchContainer)
TPSearchIcon.Size = UDim2.new(0, 30, 1, 0)
TPSearchIcon.Text = "🔍"
TPSearchIcon.Font = Enum.Font.Gotham
TPSearchIcon.TextSize = 14
TPSearchIcon.TextColor3 = Color3.fromRGB(120, 120, 140)
TPSearchIcon.BackgroundTransparency = 1

local TPSearchBox = Instance.new("TextBox", TPSearchContainer)
TPSearchBox.Size = UDim2.new(1, -35, 1, 0)
TPSearchBox.Position = UDim2.new(0, 30, 0, 0)
TPSearchBox.PlaceholderText = "Search..."
TPSearchBox.Text = ""
TPSearchBox.ClearTextOnFocus = false
TPSearchBox.Font = Enum.Font.Gotham
TPSearchBox.TextSize = 12
TPSearchBox.TextColor3 = Color3.new(1, 1, 1)
TPSearchBox.BackgroundTransparency = 1
TPSearchBox.TextXAlignment = Enum.TextXAlignment.Left

-- LOCATION LIST
local TPScroll = Instance.new("ScrollingFrame", TeleportPanel)
TPScroll.Size = UDim2.new(1, -15, 1, -105)
TPScroll.Position = UDim2.new(0, 7.5, 0, 100)
TPScroll.BackgroundTransparency = 1
TPScroll.ScrollBarThickness = 4
TPScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 120, 255)
TPScroll.ClipsDescendants = true

local TPContainer = Instance.new("Frame", TPScroll)
TPContainer.Size = UDim2.new(1, 0, 1, 0)
TPContainer.BackgroundTransparency = 1
TPContainer.ClipsDescendants = true

local TPLayout = Instance.new("UIListLayout", TPContainer)
TPLayout.Padding = UDim.new(0, 6)
TPLayout.SortOrder = Enum.SortOrder.LayoutOrder

--==================================
-- SETTINGS PANEL (EMPTY - READY TO FILL)
--==================================
local SettingsPanel = Panels.Settings

-- SETTINGS HEADER
local SetHeader = Instance.new("Frame", SettingsPanel)
SetHeader.Size = UDim2.new(1, 0, 0, 45)
SetHeader.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
SetHeader.BorderSizePixel = 0
Instance.new("UICorner", SetHeader).CornerRadius = UDim.new(0, 8)

local SetHeaderTitle = Instance.new("TextLabel", SetHeader)
SetHeaderTitle.Size = UDim2.new(1, -15, 0, 25)
SetHeaderTitle.Position = UDim2.new(0, 10, 0, 5)
SetHeaderTitle.Text = "⚙️ SETTINGS PANEL"
SetHeaderTitle.TextColor3 = Color3.fromRGB(255, 140, 0)
SetHeaderTitle.Font = Enum.Font.GothamBold
SetHeaderTitle.TextSize = 14
SetHeaderTitle.BackgroundTransparency = 1
SetHeaderTitle.TextXAlignment = Enum.TextXAlignment.Left

local SetHeaderSubtitle = Instance.new("TextLabel", SetHeader)
SetHeaderSubtitle.Size = UDim2.new(1, -15, 0, 15)
SetHeaderSubtitle.Position = UDim2.new(0, 10, 0, 27)
SetHeaderSubtitle.Text = "Add your custom settings here"
SetHeaderSubtitle.TextColor3 = Color3.fromRGB(150, 150, 170)
SetHeaderSubtitle.Font = Enum.Font.Gotham
SetHeaderSubtitle.TextSize = 10
SetHeaderSubtitle.BackgroundTransparency = 1
SetHeaderSubtitle.TextXAlignment = Enum.TextXAlignment.Left

-- SETTINGS CONTAINER (EMPTY SCROLL FRAME)
local SetScroll = Instance.new("ScrollingFrame", SettingsPanel)
SetScroll.Size = UDim2.new(1, -15, 1, -60)
SetScroll.Position = UDim2.new(0, 7.5, 0, 55)
SetScroll.BackgroundTransparency = 1
SetScroll.ScrollBarThickness = 4
SetScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 120, 255)
SetScroll.ClipsDescendants = true

local SetContainer = Instance.new("Frame", SetScroll)
SetContainer.Size = UDim2.new(1, 0, 1, 0)
SetContainer.BackgroundTransparency = 1
SetContainer.ClipsDescendants = true

local SetLayout = Instance.new("UIListLayout", SetContainer)
SetLayout.Padding = UDim.new(0, 8)
SetLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- PLACEHOLDER MESSAGE
local PlaceholderLabel = Instance.new("TextLabel", SetContainer)
PlaceholderLabel.Size = UDim2.new(1, 0, 0, 100)
PlaceholderLabel.Text = "⚙️ Settings Panel\n\nAdd your custom settings here\n\n• Toggle buttons\n• Sliders\n• Input fields\n• Etc..."
PlaceholderLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
PlaceholderLabel.Font = Enum.Font.Gotham
PlaceholderLabel.TextSize = 12
PlaceholderLabel.BackgroundTransparency = 1
PlaceholderLabel.TextWrapped = true
PlaceholderLabel.TextYAlignment = Enum.TextYAlignment.Center

--==================================
-- HELPER FUNCTIONS
--==================================
local CategoryData = {
    Island = {icon = "🏝️", color = Color3.fromRGB(0, 180, 100)},
    Depth = {icon = "🌊", color = Color3.fromRGB(0, 100, 255)},
    Secret = {icon = "🔒", color = Color3.fromRGB(180, 0, 180)},
    All = {icon = "📍", color = Color3.fromRGB(255, 140, 0)}
}

local CategoryButtons = {}
local SelectedCategory = "Island"
local DropdownOpen = false

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

--==================================
-- LOCATION CARD CREATION
--==================================
local function createLocationCard(location, index)
    local card = Instance.new("Frame", TPContainer)
    card.Size = UDim2.new(1, 0, 0, 50)
    card.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
    
    -- Category indicator
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
    
    -- Teleport button
    local teleportBtn = Instance.new("TextButton", card)
    teleportBtn.Size = UDim2.new(1, 0, 1, 0)
    teleportBtn.BackgroundTransparency = 1
    teleportBtn.Text = ""
    teleportBtn.AutoButtonColor = false
    
    -- Hover effect
    teleportBtn.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        }):Play()
    end)
    
    teleportBtn.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        }):Play()
    end)
    
    -- Click to teleport
    teleportBtn.MouseButton1Click:Connect(function()
        fastSmoothTeleport(location.cf, location.name)
    end)
end

--==================================
-- UPDATE LOCATION LIST
--==================================
local function updateLocationList()
    -- Clear previous cards
    for _, child in ipairs(TPContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local searchText = TPSearchBox.Text:lower()
    local locationsAdded = 0
    
    -- Filter and create cards
    for i, location in ipairs(Teleports) do
        local categoryMatch = (SelectedCategory == "All") or (location.cat == SelectedCategory)
        local searchMatch = (searchText == "") or (string.find(location.name:lower(), searchText, 1, true))
        
        if categoryMatch and searchMatch then
            createLocationCard(location, i)
            locationsAdded = locationsAdded + 1
        end
    end
    
    -- Update scroll size
    local cardHeight = 56
    local totalHeight = locationsAdded * cardHeight
    if totalHeight > TPScroll.AbsoluteSize.Y then
        TPScroll.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        TPContainer.Size = UDim2.new(1, 0, 0, totalHeight)
    end
    
    -- Update header
    local categoryInfo = CategoryData[SelectedCategory] or CategoryData["Island"]
    TPHeaderTitle.Text = categoryInfo.icon .. " " .. SelectedCategory:upper() .. " LOCATIONS"
    TPHeaderTitle.TextColor3 = categoryInfo.color
    TPHeaderSubtitle.Text = locationsAdded .. " locations"
end

--==================================
-- CATEGORY BUTTONS
--==================================
local function createCategoryButton(categoryName, layoutOrder)
    local categoryInfo = CategoryData[categoryName]
    if not categoryInfo then return end
    
    local catBtn = Instance.new("TextButton", CategoryContainer)
    catBtn.Size = UDim2.new(1, 0, 0, 30)
    catBtn.LayoutOrder = layoutOrder
    catBtn.Text = categoryInfo.icon .. " " .. categoryName
    catBtn.Font = Enum.Font.GothamSemibold
    catBtn.TextSize = 11
    catBtn.TextColor3 = Color3.new(1, 1, 1)
    catBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    catBtn.AutoButtonColor = false
    catBtn.Visible = false
    Instance.new("UICorner", catBtn).CornerRadius = UDim.new(0, 5)
    
    if categoryName == "Island" then
        catBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        catBtn.TextColor3 = categoryInfo.color
    end
    
    CategoryButtons[categoryName] = {
        Button = catBtn,
        OriginalColor = categoryInfo.color
    }
    
    catBtn.MouseButton1Click:Connect(function()
        for name, data in pairs(CategoryButtons) do
            if data.Button then
                data.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                data.Button.TextColor3 = Color3.new(1, 1, 1)
            end
        end
        
        if catBtn then
            catBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            catBtn.TextColor3 = categoryInfo.color
        end
        
        SelectedCategory = categoryName
        updateLocationList()
        toggleDropdown()
        
        showNotification("📂 " .. categoryName, countLocations(categoryName) .. " locations", categoryInfo.color)
    end)
end

-- Create category buttons
createCategoryButton("Island", 1)
createCategoryButton("Depth", 2)
createCategoryButton("Secret", 3)
createCategoryButton("All", 4)

--==================================
-- DROPDOWN TOGGLE
--==================================
local function toggleDropdown()
    DropdownOpen = not DropdownOpen
    
    if DropdownOpen then
        DropdownArrow.Text = "▲"
        CategoryContainer.Size = UDim2.new(1, -10, 0, 136)
        for _, data in pairs(CategoryButtons) do
            if data.Button then
                data.Button.Visible = true
            end
        end
        TeleportParentBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    else
        DropdownArrow.Text = "▼"
        CategoryContainer.Size = UDim2.new(1, -10, 0, 0)
        for _, data in pairs(CategoryButtons) do
            if data.Button then
                data.Button.Visible = false
            end
        end
        TeleportParentBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    end
end

--==================================
-- PANEL MANAGEMENT
--==================================
local function showPanel(panelName)
    for name, panel in pairs(Panels) do
        panel.Visible = false
    end
    
    -- Reset button colors
    TeleportParentBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    SettingsBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    
    if Panels[panelName] then
        Panels[panelName].Visible = true
        
        -- Highlight active button
        if panelName == "Teleport" then
            TeleportParentBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            if DropdownOpen then
                TeleportParentBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            end
        elseif panelName == "Settings" then
            SettingsBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        end
    end
end

--==================================
-- EVENT LISTENERS
--==================================
TeleportParentBtn.MouseButton1Click:Connect(function()
    if not DropdownOpen then
        showPanel("Teleport")
    end
    toggleDropdown()
end)

TPSearchBox:GetPropertyChangedSignal("Text"):Connect(updateLocationList)

SettingsBtn.MouseButton1Click:Connect(function()
    if DropdownOpen then toggleDropdown() end
    showPanel("Settings")
end)

--==================================
-- MINIMIZE SYSTEM
--==================================
local Bubble = Instance.new("TextButton", gui)
Bubble.Size = UDim2.new(0, 40, 0, 40)
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
showPanel("Teleport")

-- Initial notification
task.wait(0.5)
showNotification("🎣 Clean Hub Loaded", 
    "Teleport: " .. #Teleports .. " locations\nSettings: Empty panel ready", 
    Color3.fromRGB(0, 150, 255))

print("✅ Clean Hub Loaded!")
print("📍 Teleport: " .. #Teleports .. " locations")
print("⚙️ Settings: Empty panel ready for customization")
print("🎯 RightShift to toggle")
print("📱 Size: 400×320 pixels")
