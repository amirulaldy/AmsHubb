--// AmsHub - Fish It Teleport Hub (Stable)
--// Executor Ready

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- =====================
-- CONFIG (UBAH DI SINI)
-- =====================
local PANEL_WIDTH  = 520
local PANEL_HEIGHT = 330
local SAFE_OFFSET  = Vector3.new(0, 3, 0)

-- =====================
-- TELEPORT LIST (EDIT KOORDINAT SAJA)
-- =====================
local Teleports = {
    ["Fisherman Island"]      = CFrame.new(0,0,0),
    ["Kohana"]               = CFrame.new(0,0,0),
    ["Kohana Volcano"]       = CFrame.new(0,0,0),
    ["Volcano Cavern"]       = CFrame.new(0,0,0),
    ["Coral Reefs"]          = CFrame.new(0,0,0),
    ["Esoteric Depths"]      = CFrame.new(0,0,0),
    ["Crystal Depths"]       = CFrame.new(0,0,0),
    ["Tropical Grove"]       = CFrame.new(0,0,0),
    ["Creater Island"]       = CFrame.new(0,0,0),
    ["Treasure Room"]        = CFrame.new(0,0,0),
    ["Sisyphus Statue"]      = CFrame.new(0,0,0),
    ["Ancient Jungle"]       = CFrame.new(0,0,0),
    ["Sacred Temple"]        = CFrame.new(0,0,0),
    ["Underground Cellar"]   = CFrame.new(0,0,0),
    ["Ancient Ruin"]         = CFrame.new(0,0,0),
    ["Pirate Cove"]          = CFrame.new(0,0,0),
    ["Pirate Treasure Room"] = CFrame.new(0,0,0),
}

-- =====================
-- HELPER
-- =====================
local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- =====================
-- UI ROOT
-- =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AmsHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Auto scale mobile
local UIScale = Instance.new("UIScale")
UIScale.Parent = ScreenGui
UIScale.Scale = UIS.TouchEnabled and 0.9 or 1

-- =====================
-- MAIN PANEL
-- =====================
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, PANEL_WIDTH, 0, PANEL_HEIGHT)
Main.Position = UDim2.new(0.5, -PANEL_WIDTH/2, 0.5, -PANEL_HEIGHT/2)
Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

-- =====================
-- TITLE BAR
-- =====================
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,40)
TopBar.BackgroundTransparency = 1
TopBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-80,1,0)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.Text = "AmsHub - Fish It"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Minimize button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,30,0,30)
MinBtn.Position = UDim2.new(1,-40,0,5)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Parent = TopBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,6)

-- =====================
-- SIDEBAR
-- =====================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,150,1,-40)
Sidebar.Position = UDim2.new(0,0,0,40)
Sidebar.BackgroundColor3 = Color3.fromRGB(20,20,20)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

-- Sidebar Button
local TeleportBtn = Instance.new("TextButton")
TeleportBtn.Size = UDim2.new(1,-10,0,42)
TeleportBtn.Position = UDim2.new(0,5,0,10)
TeleportBtn.Text = "Teleport"
TeleportBtn.Font = Enum.Font.GothamBold
TeleportBtn.TextSize = 14
TeleportBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
TeleportBtn.TextColor3 = Color3.new(1,1,1)
TeleportBtn.Parent = Sidebar
Instance.new("UICorner", TeleportBtn).CornerRadius = UDim.new(0,8)

-- =====================
-- CONTENT AREA
-- =====================
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-150,1,-40)
Content.Position = UDim2.new(0,150,0,40)
Content.BackgroundColor3 = Color3.fromRGB(10,10,10)
Content.BorderSizePixel = 0
Content.Parent = Main

-- SCROLLING TELEPORT LIST
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1,-20,1,-20)
Scroll.Position = UDim2.new(0,10,0,10)
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.ScrollBarThickness = 6
Scroll.BackgroundTransparency = 1
Scroll.Visible = false
Scroll.Parent = Content

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.Parent = Scroll

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
end)

-- TELEPORT BUTTON CREATOR
local function createTP(name, cf)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,44)
    b.Text = name
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.BackgroundColor3 = Color3.fromRGB(120,0,0)
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = Scroll
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

    b.MouseButton1Click:Connect(function()
        getHRP().CFrame = cf + SAFE_OFFSET
    end)
end

-- OPEN TELEPORT MENU
TeleportBtn.MouseButton1Click:Connect(function()
    Scroll.Visible = true
    Scroll:ClearAllChildren()
    Layout.Parent = Scroll

    for name, cf in pairs(Teleports) do
        createTP(name, cf)
    end
end)

-- =====================
-- MINIMIZE → BUBBLE
-- =====================
local Bubble = Instance.new("TextButton")
Bubble.Size = UDim2.new(0,50,0,50)
Bubble.Position = UDim2.new(0.1,0,0.5,0)
Bubble.Text = "A"
Bubble.Font = Enum.Font.GothamBold
Bubble.TextSize = 20
Bubble.BackgroundColor3 = Color3.fromRGB(120,0,0)
Bubble.TextColor3 = Color3.new(1,1,1)
Bubble.Visible = false
Bubble.Active = true
Bubble.Draggable = true
Bubble.Parent = ScreenGui
Instance.new("UICorner", Bubble).CornerRadius = UDim.new(1,0)

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    Bubble.Visible = true
end)

Bubble.MouseButton1Click:Connect(function()
    Bubble.Visible = false
    Main.Visible = true
end)
