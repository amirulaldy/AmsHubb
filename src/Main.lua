--// Main.lua - Fish It Teleport Hub
--// Executor-ready LocalScript

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Character helper
local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- =========================
-- TELEPORT LIST (EDIT HERE)
-- =========================
local Teleports = {
    -- Starter
    ["Fisherman Island"]      = CFrame.new(0, 0, 0),

    -- Kohana Area
    ["Kohana"]               = CFrame.new(0, 0, 0),
    ["Kohana Volcano"]       = CFrame.new(0, 0, 0),
    ["Volcano Cavern"]       = CFrame.new(0, 0, 0),

    -- Ocean & Depths
    ["Coral Reefs"]          = CFrame.new(0, 0, 0),
    ["Esoteric Depths"]      = CFrame.new(0, 0, 0),
    ["Crystal Depths"]       = CFrame.new(0, 0, 0),

    -- Islands
    ["Tropical Grove"]       = CFrame.new(0, 0, 0),
    ["Creater Island"]       = CFrame.new(0, 0, 0),
    ["Ancient Jungle"]       = CFrame.new(0, 0, 0),

    -- Ruins & Temples
    ["Sacred Temple"]        = CFrame.new(0, 0, 0),
    ["Ancient Ruin"]         = CFrame.new(0, 0, 0),
    ["Underground Cellar"]   = CFrame.new(0, 0, 0),

    -- Pirate Area
    ["Pirate Cove"]          = CFrame.new(0, 0, 0),
    ["Pirate Treasure Room"] = CFrame.new(0, 0, 0),

    -- Special / Secret
    ["Treasure Room"]        = CFrame.new(0, 0, 0),
    ["Sisyphus Statue"]      = CFrame.new(0, 0, 0),
}

-- =========================
-- UI SETUP
-- =========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishItHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Auto scale (mobile friendly)
local UIScale = Instance.new("UIScale")
UIScale.Parent = ScreenGui
UIScale.Scale = UIS.TouchEnabled and 0.9 or 1

-- Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 520, 0, 320)
Main.Position = UDim2.new(0.5, -260, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -12, 0, 40)
Title.Position = UDim2.new(0, 6, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "FISH IT TELEPORT HUB"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

-- Content Area (MAIN MENU)
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -150, 1, -40)
Content.Position = UDim2.new(0, 150, 0, 40)
Content.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Content.BorderSizePixel = 0
Content.Parent = Main

-- Content Padding
local Pad = Instance.new("UIPadding")
Pad.PaddingTop = UDim.new(0, 10)
Pad.PaddingLeft = UDim.new(0, 10)
Pad.PaddingRight = UDim.new(0, 10)
Pad.PaddingBottom = UDim.new(0, 10)
Pad.Parent = Content

-- =========================
-- HELPERS
-- =========================
local function clearContent()
    for _, v in ipairs(Content:GetChildren()) do
        if not v:IsA("UIPadding") then
            v:Destroy()
        end
    end
end

local function createSidebarButton(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 42)
    b.Position = UDim2.new(0, 5, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.Parent = Sidebar

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b
    return b
end

local function createContentButton(text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 44)
    b.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.AutoButtonColor = true
    b.Parent = Content

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b
    return b
end

-- =========================
-- TELEPORT MENU (MAIN AREA)
-- =========================
local function openTeleportMenu()
    clearContent()

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = Content

    for name, cf in pairs(Teleports) do
        local btn = createContentButton(name)
        btn.MouseButton1Click:Connect(function()
            local hrp = getHRP()
            -- Safe teleport (anti nyemplung)
            hrp.CFrame = cf + Vector3.new(0, 3, 0)
        end)
    end
end

-- =========================
-- SIDEBAR (SINGLE BUTTON)
-- =========================
local TeleportBtn = createSidebarButton("Teleport", 10)
TeleportBtn.MouseButton1Click:Connect(openTeleportMenu)

-- Default content text
do
    clearContent()
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, 0, 1, 0)
    info.BackgroundTransparency = 1
    info.Text = "Klik 'Teleport' di sidebar\nuntuk memilih lokasi."
    info.TextColor3 = Color3.fromRGB(200,200,200)
    info.Font = Enum.Font.Gotham
    info.TextSize = 14
    info.TextWrapped = true
    info.Parent = Content
end
