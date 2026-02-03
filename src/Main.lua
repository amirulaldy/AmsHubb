--==================================
-- AmsHub Fish It | Mobile UI
-- Compact & Minimalist
--==================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

--==================================
-- CONFIG
--==================================
local CONFIG = {
    PRIMARY = Color3.fromRGB(0, 150, 255),      -- Blue
    SECONDARY = Color3.fromRGB(30, 30, 40),     -- Dark
    LIGHT = Color3.fromRGB(45, 45, 55),         -- Card bg
    TEXT = Color3.fromRGB(240, 240, 240),       -- White
    SUBTEXT = Color3.fromRGB(180, 180, 200)     -- Gray
}

--==================================
-- UTILITIES
--==================================
local function create(class, props)
    local obj = Instance.new(class)
    for prop, val in pairs(props) do
        if prop ~= "Parent" then
            obj[prop] = val
        end
    end
    obj.Parent = props.Parent
    return obj
end

local function tween(obj, props, duration)
    local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.2), props)
    tween:Play()
    return tween
end

--==================================
-- LOCATIONS DATA
--==================================
local Locations = {
    Islands = {
        {Name = "Fisherman Island", Icon = "🏝️", CF = CFrame.new(197.34857177734375, 2.6072463989257812, 2796.57373046875)},
        {Name = "Kohana", Icon = "🎎", CF = CFrame.new(200,50,-150)},
        {Name = "Tropical Grove", Icon = "🌴", CF = CFrame.new(-300,50,200)},
        {Name = "Ancient Jungle", Icon = "🌿", CF = CFrame.new(400,50,-300)},
        {Name = "Crater Island", Icon = "🌋", CF = CFrame.new(-100,50,400)},
    },
    Depths = {
        {Name = "Coral Reefs", Icon = "🐠", CF = CFrame.new(0,-50,0)},
        {Name = "Esoteric Depths", Icon = "🌀", CF = CFrame.new(0,-100,0)},
        {Name = "Crystal Depths", Icon = "💎", CF = CFrame.new(0,-150,0)},
        {Name = "Volcano Cavern", Icon = "🔥", CF = CFrame.new(0,-200,0)},
    },
    Secret = {
        {Name = "Ancient Ruin", Icon = "🏛️", CF = CFrame.new(6098.16845703125, -585.92431640625, 4649.107421875)},
        {Name = "Sacred Temple", Icon = "🛕", CF = CFrame.new(600,50,0)},
        {Name = "Treasure Room", Icon = "💎", CF = CFrame.new(700,50,0)},
        {Name = "Pirate Cove", Icon = "🏴‍☠️", CF = CFrame.new(3474.528076171875, 4.192470550537109, 3489.54150390625)},
        {Name = "Sisyphus Statue", Icon = "🗿", CF = CFrame.new(900,50,0)},
    }
}

--==================================
-- FLOATING ICON (DRAGGABLE)
--==================================
local MainGUI = create("ScreenGui", {
    Name = "FishHubMobile",
    Parent = LP:WaitForChild("PlayerGui"),
    ResetOnSpawn = false
})

-- Floating Icon (Always visible)
local FloatingIcon = create("TextButton", {
    Name = "FloatingIcon",
    Parent = MainGUI,
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0, 20, 0.5, -25),
    Text = "🎣",
    TextColor3 = CONFIG.TEXT,
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    BackgroundColor3 = CONFIG.PRIMARY,
    AutoButtonColor = false,
    Draggable = true,
    Active = true
})

create("UICorner", {Parent = FloatingIcon, CornerRadius = UDim.new(1, 0)})
create("UIStroke", {Parent = FloatingIcon, Color = Color3.new(1,1,1), Thickness = 2})

-- Icon pulse animation
task.spawn(function()
    while true do
        tween(FloatingIcon, {Size = UDim2.new(0, 55, 0, 55)}, 0.5)
        task.wait(0.5)
        tween(FloatingIcon, {Size = UDim2.new(0, 50, 0, 50)}, 0.5)
        task.wait(2)
    end
end)

--==================================
-- MAIN PANEL (HIDDEN BY DEFAULT)
--==================================
local MainPanel = create("Frame", {
    Name = "MainPanel",
    Parent = MainGUI,
    Size = UDim2.new(0.85, 0, 0.9, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = CONFIG.SECONDARY,
    Visible = false
})

create("UICorner", {Parent = MainPanel, CornerRadius = UDim.new(0, 16)})
create("UIStroke", {Parent = MainPanel, Color = CONFIG.PRIMARY, Thickness = 2})

-- Header with time
local Header = create("Frame", {
    Parent = MainPanel,
    Size = UDim2.new(1, 0, 0, 70),
    BackgroundColor3 = CONFIG.PRIMARY,
    BorderSizePixel = 0
})

create("UICorner", {
    Parent = Header,
    CornerRadius = UDim.new(0, 16)
})

-- Time display
local TimeLabel = create("TextLabel", {
    Parent = Header,
    Size = UDim2.new(0.5, -10, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    Text = "08:53 AM",
    TextColor3 = CONFIG.TEXT,
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Update time
RunService.Heartbeat:Connect(function()
    TimeLabel.Text = os.date("%I:%M %p")
end)

-- Title
create("TextLabel", {
    Parent = Header,
    Size = UDim2.new(0.5, -10, 0.5, 0),
    Position = UDim2.new(0.5, 5, 0, 5),
    Text = "FISH HUB",
    TextColor3 = CONFIG.TEXT,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Right
})

create("TextLabel", {
    Parent = Header,
    Size = UDim2.new(0.5, -10, 0.5, 0),
    Position = UDim2.new(0.5, 5, 0.5, -5),
    Text = "Teleport System",
    TextColor3 = CONFIG.SUBTEXT,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Right
})

-- Close button
local CloseBtn = create("TextButton", {
    Parent = Header,
    Size = UDim2.new(0, 40, 0, 40),
    Position = UDim2.new(1, -45, 0.5, -20),
    Text = "×",
    TextColor3 = CONFIG.TEXT,
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    BackgroundColor3 = Color3.fromRGB(255, 60, 60),
    AutoButtonColor = false
})

create("UICorner", {Parent = CloseBtn, CornerRadius = UDim.new(1, 0)})

CloseBtn.MouseButton1Click:Connect(function()
    tween(MainPanel, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, 0.3)
    task.wait(0.3)
    MainPanel.Visible = false
    FloatingIcon.Visible = true
end)

--==================================
-- COMPACT LOCATION LIST
--==================================
local ScrollFrame = create("ScrollingFrame", {
    Parent = MainPanel,
    Size = UDim2.new(1, -20, 1, -150),
    Position = UDim2.new(0, 10, 0, 80),
    BackgroundTransparency = 1,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = CONFIG.PRIMARY,
    CanvasSize = UDim2.new(0, 0, 0, 0)
})

local CategoryTabs = {"ALL", "ISLANDS", "DEPTHS", "SECRET"}
local SelectedTab = "ALL"

-- Category buttons (compact)
local TabContainer = create("Frame", {
    Parent = MainPanel,
    Size = UDim2.new(1, -20, 0, 40),
    Position = UDim2.new(0, 10, 0, 140),
    BackgroundTransparency = 1
})

for i, tab in ipairs(CategoryTabs) do
    local tabBtn = create("TextButton", {
        Parent = TabContainer,
        Size = UDim2.new(0.25, -5, 1, 0),
        Position = UDim2.new((i-1)/4, 0, 0, 0),
        Text = tab,
        TextColor3 = CONFIG.TEXT,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        BackgroundColor3 = CONFIG.LIGHT,
        AutoButtonColor = false
    })
    
    create("UICorner", {Parent = tabBtn, CornerRadius = UDim.new(0, 8)})
    
    if tab == "ALL" then
        tabBtn.BackgroundColor3 = CONFIG.PRIMARY
    end
    
    tabBtn.MouseButton1Click:Connect(function()
        SelectedTab = tab
        for _, btn in pairs(TabContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = CONFIG.LIGHT
            end
        end
        tabBtn.BackgroundColor3 = CONFIG.PRIMARY
        updateLocationList()
    end)
end

-- Function to create compact location item
local function createLocationItem(location, category, index)
    local item = create("Frame", {
        Name = location.Name,
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = CONFIG.LIGHT,
        Parent = ScrollFrame
    })
    
    create("UICorner", {Parent = item, CornerRadius = UDim.new(0, 10)})
    
    -- Icon
    create("TextLabel", {
        Parent = item,
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0, 10, 0.5, -25),
        Text = location.Icon,
        TextColor3 = CONFIG.PRIMARY,
        Font = Enum.Font.GothamBold,
        TextSize = 24,
        BackgroundTransparency = 1
    })
    
    -- Name
    create("TextLabel", {
        Parent = item,
        Size = UDim2.new(0.5, -70, 0, 25),
        Position = UDim2.new(0, 70, 0, 10),
        Text = location.Name,
        TextColor3 = CONFIG.TEXT,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Category badge
    local badge = create("Frame", {
        Parent = item,
        Size = UDim2.new(0, 60, 0, 20),
        Position = UDim2.new(0, 70, 0, 35),
        BackgroundColor3 = CONFIG.PRIMARY
    })
    
    create("UICorner", {Parent = badge, CornerRadius = UDim.new(1, 0)})
    
    create("TextLabel", {
        Parent = badge,
        Size = UDim2.new(1, 0, 1, 0),
        Text = category:upper(),
        TextColor3 = CONFIG.TEXT,
        Font = Enum.Font.GothamSemibold,
        TextSize = 10,
        BackgroundTransparency = 1
    })
    
    -- Teleport button (compact)
    local tpBtn = create("TextButton", {
        Parent = item,
        Size = UDim2.new(0, 70, 0, 30),
        Position = UDim2.new(1, -80, 0.5, -15),
        Text = "GO",
        TextColor3 = CONFIG.TEXT,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        BackgroundColor3 = CONFIG.PRIMARY,
        AutoButtonColor = false
    })
    
    create("UICorner", {Parent = tpBtn, CornerRadius = UDim.new(0, 8)})
    
    -- Button effects
    tpBtn.MouseEnter:Connect(function()
        tween(tpBtn, {BackgroundColor3 = Color3.fromRGB(30, 170, 255)}, 0.2)
    end)
    
    tpBtn.MouseLeave:Connect(function()
        tween(tpBtn, {BackgroundColor3 = CONFIG.PRIMARY}, 0.2)
    end)
    
    -- Teleport function
    tpBtn.MouseButton1Click:Connect(function()
        local char = LP.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = location.CF + Vector3.new(0, 5, 0)
            showNotification("📍 Teleported to " .. location.Name)
            
            -- Auto close panel after teleport
            task.wait(0.5)
            if MainPanel.Visible then
                CloseBtn.MouseButton1Click:Fire()
            end
        end
    end)
    
    return item
end

-- Update location list
function updateLocationList()
    ScrollFrame:ClearAllChildren()
    
    local yPos = 0
    local itemCount = 0
    
    for categoryName, category in pairs(Locations) do
        if SelectedTab == "ALL" or SelectedTab == categoryName:upper() then
            for _, location in ipairs(category) do
                local item = createLocationItem(location, categoryName, itemCount + 1)
                item.Position = UDim2.new(0, 0, 0, yPos)
                yPos = yPos + 80
                itemCount = itemCount + 1
            end
        end
    end
    
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
    
    -- Show message if no locations
    if itemCount == 0 then
        local msg = create("TextLabel", {
            Parent = ScrollFrame,
            Size = UDim2.new(1, 0, 0, 100),
            Position = UDim2.new(0, 0, 0, 50),
            Text = "No locations found\nSelect a different category",
            TextColor3 = CONFIG.SUBTEXT,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            BackgroundTransparency = 1,
            TextWrapped = true
        })
    end
end

--==================================
-- QUESTS PANEL (COMPACT)
--==================================
local QuestsPanel = create("Frame", {
    Parent = MainPanel,
    Size = UDim2.new(1, -20, 0, 180),
    Position = UDim2.new(0, 10, 1, -190),
    BackgroundColor3 = CONFIG.LIGHT,
    Visible = false  -- Hidden by default
})

create("UICorner", {Parent = QuestsPanel, CornerRadius = UDim.new(0, 12)})

create("TextLabel", {
    Parent = QuestsPanel,
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 0, 10),
    Text = "📜 QUESTS",
    TextColor3 = CONFIG.TEXT,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Toggle quests button
local ToggleQuests = create("TextButton", {
    Parent = MainPanel,
    Size = UDim2.new(0, 40, 0, 40),
    Position = UDim2.new(1, -50, 1, -50),
    Text = "📜",
    TextColor3 = CONFIG.TEXT,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    BackgroundColor3 = CONFIG.PRIMARY,
    AutoButtonColor = false
})

create("UICorner", {Parent = ToggleQuests, CornerRadius = UDim.new(1, 0)})

ToggleQuests.MouseButton1Click:Connect(function()
    QuestsPanel.Visible = not QuestsPanel.Visible
    if QuestsPanel.Visible then
        ScrollFrame.Size = UDim2.new(1, -20, 1, -340)
    else
        ScrollFrame.Size = UDim2.new(1, -20, 1, -150)
    end
end)

-- Quest items
local quests = {
    "Own a Legendary Quest",
    "Exchange a Curved Roken", 
    "Catch an Epicant Gran Maja",
    "Legendary Crystal Red Mutation",
    "Complete Crystal Quest",
    "Collect 50 Rare Fish",
    "Reach Depth Level 100"
}

local questY = 50
for i, quest in ipairs(quests) do
    if i <= 5 then  -- Show only 5 quests
        local questItem = create("Frame", {
            Size = UDim2.new(1, -20, 0, 25),
            Position = UDim2.new(0, 10, 0, questY),
            BackgroundTransparency = 1,
            Parent = QuestsPanel
        })
        
        create("TextLabel", {
            Parent = questItem,
            Size = UDim2.new(0.8, 0, 1, 0),
            Text = "• " .. quest,
            TextColor3 = CONFIG.SUBTEXT,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local checkbox = create("Frame", {
            Parent = questItem,
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(1, -20, 0.5, -9),
            BackgroundColor3 = CONFIG.SECONDARY
        })
        
        create("UICorner", {Parent = checkbox, CornerRadius = UDim.new(0, 4)})
        create("UIStroke", {Parent = checkbox, Color = CONFIG.SUBTEXT, Thickness = 1})
        
        questY = questY + 30
    end
end

--==================================
-- NOTIFICATION SYSTEM
--==================================
function showNotification(message)
    local notif = create("Frame", {
        Parent = MainGUI,
        Size = UDim2.new(0, 250, 0, 60),
        Position = UDim2.new(0.5, -125, 0.2, 0),
        BackgroundColor3 = CONFIG.SECONDARY,
        BorderSizePixel = 0
    })
    
    create("UICorner", {Parent = notif, CornerRadius = UDim.new(0, 10)})
    create("UIStroke", {Parent = notif, Color = CONFIG.PRIMARY, Thickness = 2})
    
    create("TextLabel", {
        Parent = notif,
        Size = UDim2.new(1, -20, 1, -10),
        Position = UDim2.new(0, 10, 0, 5),
        Text = message,
        TextColor3 = CONFIG.TEXT,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        BackgroundTransparency = 1,
        TextWrapped = true
    })
    
    -- Animate
    tween(notif, {Position = UDim2.new(0.5, -125, 0.15, 0)}, 0.3)
    
    task.delay(2, function()
        tween(notif, {Position = UDim2.new(0.5, -125, 0.1, 0)}, 0.3)
        task.wait(0.3)
        notif:Destroy()
    end)
end

--==================================
-- INTERACTION HANDLERS
--==================================
-- Floating icon click
FloatingIcon.MouseButton1Click:Connect(function()
    FloatingIcon.Visible = false
    MainPanel.Visible = true
    MainPanel.Size = UDim2.new(0, 0, 0, 0)
    MainPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    tween(MainPanel, {
        Size = UDim2.new(0.85, 0, 0.9, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, 0.3)
    
    updateLocationList()
end)

-- Right shift toggle
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        if MainPanel.Visible then
            CloseBtn.MouseButton1Click:Fire()
        else
            FloatingIcon.MouseButton1Click:Fire()
        end
    end
end)

--==================================
-- INITIALIZE
--==================================
updateLocationList()
showNotification("🎣 Fish Hub Mobile Ready!\nTap icon to open")

print("✅ Mobile Fish Hub Loaded!")
