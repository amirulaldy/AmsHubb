--==================================
-- AmsHub Fish It | Premium Dashboard
-- UI Complex & Smooth
--==================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

--==================================
-- CONFIGURATION
--==================================
local CONFIG = {
    PRIMARY = Color3.fromRGB(0, 122, 255),      -- Blue accent
    SECONDARY = Color3.fromRGB(40, 40, 60),     -- Dark blue
    DARK = Color3.fromRGB(18, 18, 24),          -- Dark background
    LIGHT = Color3.fromRGB(28, 28, 36),         -- Light background
    SUCCESS = Color3.fromRGB(76, 175, 80),      -- Green
    WARNING = Color3.fromRGB(255, 193, 7),      -- Yellow
    DANGER = Color3.fromRGB(244, 67, 54),       -- Red
    TEXT = Color3.fromRGB(240, 240, 240),       -- White text
    SUBTEXT = Color3.fromRGB(180, 180, 200)     -- Gray text
}

--==================================
-- UTILITY FUNCTIONS
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

local function tween(obj, props, duration, easing)
    local tweenInfo = TweenInfo.new(duration or 0.3, easing or Enum.EasingStyle.Quad)
    local tween = TweenService:Create(obj, tweenInfo, props)
    tween:Play()
    return tween
end

--==================================
-- TELEPORT DATABASE
--==================================
local Locations = {
    Islands = {
        {Name = "Fisherman Island", Desc = "Starting island", Icon = "🏝️", CF = CFrame.new(0,50,0)},
        {Name = "Kohana", Desc = "Japanese themed", Icon = "🎎", CF = CFrame.new(100,50,0)},
        {Name = "Tropical Grove", Desc = "Lush paradise", Icon = "🌴", CF = CFrame.new(200,50,0)},
        {Name = "Ancient Jungle", Desc = "Mysterious ruins", Icon = "🌿", CF = CFrame.new(300,50,0)},
        {Name = "Crater Island", Desc = "Volcanic area", Icon = "🌋", CF = CFrame.new(400,50,0)},
    },
    Depths = {
        {Name = "Coral Reefs", Desc = "Colorful corals", Icon = "🐠", CF = CFrame.new(0,-50,0)},
        {Name = "Esoteric Depths", Desc = "Mysterious deep", Icon = "🌀", CF = CFrame.new(0,-100,0)},
        {Name = "Crystal Depths", Desc = "Glowing crystals", Icon = "💎", CF = CFrame.new(0,-150,0)},
        {Name = "Volcano Cavern", Desc = "Underwater volcano", Icon = "🔥", CF = CFrame.new(0,-200,0)},
    },
    Secret = {
        {Name = "Ancient Ruin", Desc = "Hidden structure", Icon = "🏛️", CF = CFrame.new(500,50,0)},
        {Name = "Sacred Temple", Desc = "Sacred fishing spot", Icon = "🛕", CF = CFrame.new(600,50,0)},
        {Name = "Treasure Room", Desc = "Secret chamber", Icon = "💎", CF = CFrame.new(700,50,0)},
        {Name = "Pirate Cove", Desc = "Pirate hideout", Icon = "🏴‍☠️", CF = CFrame.new(800,50,0)},
    }
}

--==================================
-- MAIN GUI CONTAINER
--==================================
local MainGUI = create("ScreenGui", {
    Name = "FishHubPremium",
    Parent = LP:WaitForChild("PlayerGui"),
    ResetOnSpawn = false
})

-- Main Container (Full Dashboard)
local MainContainer = create("Frame", {
    Name = "Dashboard",
    Parent = MainGUI,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = CONFIG.DARK,
    BorderSizePixel = 0
})

--==================================
-- LEFT SIDEBAR (WALLET & NAV)
--==================================
local LeftSidebar = create("Frame", {
    Name = "Sidebar",
    Parent = MainContainer,
    Size = UDim2.new(0, 260, 1, 0),
    BackgroundColor3 = CONFIG.SECONDARY,
    BorderSizePixel = 0
})

-- Sidebar Header
local SidebarHeader = create("Frame", {
    Name = "Header",
    Parent = LeftSidebar,
    Size = UDim2.new(1, 0, 0, 80),
    BackgroundColor3 = CONFIG.PRIMARY,
    BorderSizePixel = 0
})

create("TextLabel", {
    Parent = SidebarHeader,
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 20, 0, 0),
    Text = "🎣 FISH HUB PRO",
    TextColor3 = CONFIG.TEXT,
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Wallet Section
local WalletSection = create("Frame", {
    Name = "Wallet",
    Parent = LeftSidebar,
    Size = UDim2.new(1, -20, 0, 120),
    Position = UDim2.new(0, 10, 0, 90),
    BackgroundColor3 = CONFIG.LIGHT,
    BorderSizePixel = 0
})

create("UICorner", {Parent = WalletSection, CornerRadius = UDim.new(0, 12)})

create("TextLabel", {
    Parent = WalletSection,
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 15, 0, 15),
    Text = "💰 WALLET",
    TextColor3 = CONFIG.SUBTEXT,
    Font = Enum.Font.GothamSemibold,
    TextSize = 14,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left
})

local BalanceLabel = create("TextLabel", {
    Parent = WalletSection,
    Size = UDim2.new(1, -20, 0, 40),
    Position = UDim2.new(0, 15, 0, 45),
    Text = "$ 0.00",
    TextColor3 = CONFIG.TEXT,
    Font = Enum.Font.GothamBold,
    TextSize = 28,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Navigation Buttons
local navButtons = {
    {Text = "📊 Dashboard", Icon = "📊"},
    {Text = "📍 Teleport", Icon = "📍"},
    {Text = "⚙️ Settings", Icon = "⚙️"},
    {Text = "📈 Stats", Icon = "📈"},
    {Text = "👥 Players", Icon = "👥"},
    {Text = "🎣 Auto Fish", Icon = "🎣"}
}

local NavContainer = create("Frame", {
    Name = "Navigation",
    Parent = LeftSidebar,
    Size = UDim2.new(1, -20, 0, #navButtons * 55),
    Position = UDim2.new(0, 10, 0, 230),
    BackgroundTransparency = 1
})

for i, btn in ipairs(navButtons) do
    local navBtn = create("TextButton", {
        Name = btn.Text,
        Parent = NavContainer,
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, (i-1) * 55),
        Text = "   " .. btn.Icon .. "  " .. btn.Text,
        TextColor3 = CONFIG.SUBTEXT,
        Font = Enum.Font.Gotham,
        TextSize = 16,
        BackgroundColor3 = CONFIG.LIGHT,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    })
    
    create("UICorner", {Parent = navBtn, CornerRadius = UDim.new(0, 10)})
    
    -- Hover effects
    navBtn.MouseEnter:Connect(function()
        tween(navBtn, {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}, 0.2)
    end)
    
    navBtn.MouseLeave:Connect(function()
        tween(navBtn, {BackgroundColor3 = CONFIG.LIGHT}, 0.2)
    end)
end

--==================================
-- MAIN CONTENT AREA
--==================================
local ContentArea = create("Frame", {
    Name = "Content",
    Parent = MainContainer,
    Size = UDim2.new(1, -280, 1, -100),
    Position = UDim2.new(0, 270, 0, 80),
    BackgroundTransparency = 1
})

-- Content Header
local ContentHeader = create("Frame", {
    Name = "Header",
    Parent = ContentArea,
    Size = UDim2.new(1, 0, 0, 60),
    BackgroundTransparency = 1
})

create("TextLabel", {
    Parent = ContentHeader,
    Size = UDim2.new(1, 0, 1, 0),
    Text = "📍 TELEPORT SYSTEM",
    TextColor3 = CONFIG.TEXT,
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left
})

create("TextLabel", {
    Parent = ContentHeader,
    Size = UDim2.new(1, 0, 1, 0),
    Text = "Fast travel to any fishing location",
    TextColor3 = CONFIG.SUBTEXT,
    Font = Enum.Font.Gotham,
    TextSize = 14,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Bottom
})

-- Teleport Card Grid
local TeleportGrid = create("ScrollingFrame", {
    Name = "TeleportGrid",
    Parent = ContentArea,
    Size = UDim2.new(1, 0, 1, -70),
    Position = UDim2.new(0, 0, 0, 70),
    BackgroundTransparency = 1,
    ScrollBarImageColor3 = CONFIG.PRIMARY,
    ScrollBarThickness = 6,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y
})

local UIListLayout = create("UIListLayout", {
    Parent = TeleportGrid,
    Padding = UDim.new(0, 15)
})

local UIPadding = create("UIPadding", {
    Parent = TeleportGrid,
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 5),
    PaddingTop = UDim.new(0, 5)
})

-- Function to create location cards
local function createLocationCard(location, category)
    local Card = create("Frame", {
        Name = location.Name,
        Size = UDim2.new(0, 280, 0, 140),
        BackgroundColor3 = CONFIG.LIGHT
    })
    
    create("UICorner", {Parent = Card, CornerRadius = UDim.new(0, 12)})
    
    create("UIStroke", {
        Parent = Card,
        Color = CONFIG.SECONDARY,
        Thickness = 2
    })
    
    -- Icon
    create("TextLabel", {
        Parent = Card,
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0, 15, 0, 15),
        Text = location.Icon or "📍",
        TextColor3 = CONFIG.PRIMARY,
        Font = Enum.Font.GothamBold,
        TextSize = 28,
        BackgroundTransparency = 1
    })
    
    -- Name
    create("TextLabel", {
        Parent = Card,
        Size = UDim2.new(1, -90, 0, 30),
        Position = UDim2.new(0, 80, 0, 15),
        Text = location.Name,
        TextColor3 = CONFIG.TEXT,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Category badge
    local Badge = create("Frame", {
        Parent = Card,
        Size = UDim2.new(0, 80, 0, 22),
        Position = UDim2.new(0, 80, 0, 45),
        BackgroundColor3 = CONFIG.PRIMARY
    })
    
    create("UICorner", {Parent = Badge, CornerRadius = UDim.new(1, 0)})
    
    create("TextLabel", {
        Parent = Badge,
        Size = UDim2.new(1, 0, 1, 0),
        Text = category,
        TextColor3 = CONFIG.TEXT,
        Font = Enum.Font.GothamSemibold,
        TextSize = 11,
        BackgroundTransparency = 1
    })
    
    -- Description
    create("TextLabel", {
        Parent = Card,
        Size = UDim2.new(1, -30, 0, 40),
        Position = UDim2.new(0, 15, 0, 80),
        Text = location.Desc,
        TextColor3 = CONFIG.SUBTEXT,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    })
    
    -- Teleport Button
    local TeleportBtn = create("TextButton", {
        Parent = Card,
        Size = UDim2.new(1, -30, 0, 32),
        Position = UDim2.new(0, 15, 1, -42),
        Text = "TELEPORT",
        TextColor3 = CONFIG.TEXT,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        BackgroundColor3 = CONFIG.PRIMARY,
        AutoButtonColor = false
    })
    
    create("UICorner", {Parent = TeleportBtn, CornerRadius = UDim.new(0, 8)})
    
    -- Button effects
    TeleportBtn.MouseEnter:Connect(function()
        tween(TeleportBtn, {BackgroundColor3 = Color3.fromRGB(30, 144, 255)}, 0.2)
    end)
    
    TeleportBtn.MouseLeave:Connect(function()
        tween(TeleportBtn, {BackgroundColor3 = CONFIG.PRIMARY}, 0.2)
    end)
    
    TeleportBtn.MouseButton1Click:Connect(function()
        -- Teleport function
        local char = LP.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = location.CF + Vector3.new(0, 5, 0)
            
            -- Success notification
            createNotification("✅ Teleported to " .. location.Name, CONFIG.SUCCESS)
        end
    end)
    
    return Card
end

-- Populate teleport grid
local cardCount = 0
for category, locations in pairs(Locations) do
    for _, location in ipairs(locations) do
        local card = createLocationCard(location, category:upper())
        card.Parent = TeleportGrid
        cardCount = cardCount + 1
    end
end

-- Update grid size
TeleportGrid.CanvasSize = UDim2.new(0, 0, 0, math.ceil(cardCount/2) * 155)

--==================================
-- RIGHT SIDEBAR (QUESTS & INFO)
--==================================
local RightSidebar = create("Frame", {
    Name = "RightPanel",
    Parent = MainContainer,
    Size = UDim2.new(0, 300, 1, -100),
    Position = UDim2.new(1, -310, 0, 80),
    BackgroundColor3 = CONFIG.SECONDARY,
    BorderSizePixel = 0
})

create("TextLabel", {
    Parent = RightSidebar,
    Size = UDim2.new(1, -20, 0, 40),
    Position = UDim2.new(0, 15, 0, 15),
    Text = "📜 CRYSTALLINE SECRETS",
    TextColor3 = CONFIG.TEXT,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Quest List
local quests = {
    "Own a Legendary Quest",
    "Exchange a Curved Roken",
    "Catch an Epicant Gran Maja",
    "Legendary Crystal Red Mutation",
    "Complete Crystal Quest",
    "Collect 50 Rare Fish",
    "Reach Depth Level 100",
    "Unlock All Secret Areas"
}

local QuestContainer = create("ScrollingFrame", {
    Name = "Quests",
    Parent = RightSidebar,
    Size = UDim2.new(1, -20, 0, 300),
    Position = UDim2.new(0, 10, 0, 70),
    BackgroundTransparency = 1,
    ScrollBarThickness = 4,
    CanvasSize = UDim2.new(0, 0, 0, #quests * 45)
})

for i, quest in ipairs(quests) do
    local questFrame = create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, (i-1) * 45),
        BackgroundColor3 = CONFIG.LIGHT,
        Parent = QuestContainer
    })
    
    create("UICorner", {Parent = questFrame, CornerRadius = UDim.new(0, 8)})
    
    create("TextLabel", {
        Parent = questFrame,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = "• " .. quest,
        TextColor3 = CONFIG.TEXT,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Checkbox
    local checkbox = create("Frame", {
        Parent = questFrame,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0.5, -10),
        BackgroundColor3 = CONFIG.DARK,
        BorderSizePixel = 0
    })
    
    create("UICorner", {Parent = checkbox, CornerRadius = UDim.new(0, 4)})
    create("UIStroke", {Parent = checkbox, Color = CONFIG.SUBTEXT, Thickness = 1})
end

-- Player Stats
create("TextLabel", {
    Parent = RightSidebar,
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 15, 0, 390),
    Text = "📊 PLAYER STATS",
    TextColor3 = CONFIG.TEXT,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left
})

local stats = {
    {"Friend Luck", "85.14M"},
    {"Pirate Cove", "Active"},
    {"Fishing Level", "42"},
    {"Total Fish", "1,247"},
    {"Net Worth", "$2.4M"}
}

for i, stat in ipairs(stats) do
    create("TextLabel", {
        Parent = RightSidebar,
        Size = UDim2.new(1, -30, 0, 25),
        Position = UDim2.new(0, 15, 0, 425 + (i-1)*30),
        Text = stat[1],
        TextColor3 = CONFIG.SUBTEXT,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    create("TextLabel", {
        Parent = RightSidebar,
        Size = UDim2.new(1, -30, 0, 25),
        Position = UDim2.new(0, 15, 0, 425 + (i-1)*30),
        Text = stat[2],
        TextColor3 = CONFIG.TEXT,
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Right
    })
end

--==================================
-- TOP BAR (TIME & CONTROLS)
--==================================
local TopBar = create("Frame", {
    Name = "TopBar",
    Parent = MainContainer,
    Size = UDim2.new(1, -280, 0, 80),
    Position = UDim2.new(0, 270, 0, 0),
    BackgroundColor3 = CONFIG.SECONDARY,
    BorderSizePixel = 0
})

-- Time Display
local TimeLabel = create("TextLabel", {
    Parent = TopBar,
    Size = UDim2.new(0, 120, 1, 0),
    Position = UDim2.new(0, 20, 0, 0),
    Text = "11:12 PM",
    TextColor3 = CONFIG.TEXT,
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    BackgroundTransparency = 1
})

-- Update time
RunService.Heartbeat:Connect(function()
    local time = os.date("%I:%M %p")
    TimeLabel.Text = time
end)

-- Control Buttons
local controls = {"Sprint", "Auto", "More", "Exit"}
local controlSize = 70

for i, control in ipairs(controls) do
    local controlBtn = create("TextButton", {
        Parent = TopBar,
        Size = UDim2.new(0, controlSize, 0, 40),
        Position = UDim2.new(1, -((#controls - i + 1) * (controlSize + 10)), 0.5, -20),
        Text = control,
        TextColor3 = CONFIG.TEXT,
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        BackgroundColor3 = CONFIG.LIGHT,
        AutoButtonColor = false
    })
    
    create("UICorner", {Parent = controlBtn, CornerRadius = UDim.new(0, 8)})
    
    -- Button effects
    controlBtn.MouseEnter:Connect(function()
        tween(controlBtn, {BackgroundColor3 = CONFIG.PRIMARY}, 0.2)
    end)
    
    controlBtn.MouseLeave:Connect(function()
        tween(controlBtn, {BackgroundColor3 = CONFIG.LIGHT}, 0.2)
    end)
    
    if control == "Exit" then
        controlBtn.MouseButton1Click:Connect(function()
            MainGUI:Destroy()
        end)
    end
end

--==================================
-- NOTIFICATION SYSTEM
--==================================
local function createNotification(message, color)
    local notif = create("Frame", {
        Name = "Notification",
        Parent = MainGUI,
        Size = UDim2.new(0, 300, 0, 70),
        Position = UDim2.new(1, 10, 0.8, 0),
        BackgroundColor3 = CONFIG.DARK,
        BorderSizePixel = 0
    })
    
    create("UICorner", {Parent = notif, CornerRadius = UDim.new(0, 10)})
    create("UIStroke", {Parent = notif, Color = color, Thickness = 2})
    
    create("TextLabel", {
        Parent = notif,
        Size = UDim2.new(1, -20, 1, -10),
        Position = UDim2.new(0, 10, 0, 5),
        Text = message,
        TextColor3 = CONFIG.TEXT,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        BackgroundTransparency = 1,
        TextWrapped = true
    })
    
    -- Animate in
    tween(notif, {Position = UDim2.new(1, -310, notif.Position.Y.Scale, notif.Position.Y.Offset)}, 0.3)
    
    -- Auto remove
    task.delay(3, function()
        tween(notif, {Position = UDim2.new(1, 10, notif.Position.Y.Scale, notif.Position.Y.Offset)}, 0.3)
        task.wait(0.3)
        notif:Destroy()
    end)
end

--==================================
-- HOTKEY TOGGLE
--==================================
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainContainer.Visible = not MainContainer.Visible
    end
end)

--==================================
-- INITIALIZATION
--==================================
createNotification("🎣 Fish Hub Premium Loaded!", CONFIG.SUCCESS)

-- Initial teleport instruction
task.wait(1)
createNotification("📍 Click any card to teleport", CONFIG.PRIMARY)

print("✅ Fish Hub Premium Dashboard Loaded Successfully!")
