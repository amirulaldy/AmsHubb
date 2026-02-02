--==================================================
-- AMS HUB | Fish It
-- UI FIXED + TELEPORT SYSTEM
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- SAFE HRP
local function getHRP()
    local c = LP.Character or LP.CharacterAdded:Wait()
    return c:WaitForChild("HumanoidRootPart")
end

-- OFFSET (anti stuck)
local SAFE_OFFSET = Vector3.new(0, 5, 0)

--==================================================
-- TELEPORT DATA (EDIT COORDINAT SENDIRI)
--==================================================
local Teleports = {
    Island = {
        ["Fisherman Island"] = CFrame.new(0,0,0),
        ["Kohana"] = CFrame.new(0,0,0),
        ["Kohana Volcano"] = CFrame.new(0,0,0),
        ["Tropical Grove"] = CFrame.new(0,0,0),
        ["Pirate Cove"] = CFrame.new(0,0,0),
        ["Creater Island"] = CFrame.new(0,0,0),
    },
    Depth = {
        ["Coral Reefs"] = CFrame.new(0,0,0),
        ["Esoteric Depths"] = CFrame.new(0,0,0),
        ["Volcano Cavern"] = CFrame.new(0,0,0),
        ["Crystal Depths"] = CFrame.new(0,0,0),
        ["Underground Cellar"] = CFrame.new(0,0,0),
    },
    Secret = {
        ["Treasure Room"] = CFrame.new(0,0,0),
        ["Pirate Treasure Room"] = CFrame.new(0,0,0),
        ["Ancient Jungle"] = CFrame.new(0,0,0),
        ["Sacred Temple"] = CFrame.new(0,0,0),
        ["Ancient Ruin"] = CFrame.new(0,0,0),
        ["Sisyphus Statue"] = CFrame.new(0,0,0),
    }
}

--==================================================
-- UI ROOT
--==================================================
local GUI = Instance.new("ScreenGui")
GUI.Name = "AmsHub"
GUI.ResetOnSpawn = false
GUI.Parent = LP.PlayerGui

--==================================================
-- MAIN FRAME
--==================================================
local Main = Instance.new("Frame", GUI)
Main.Size = UDim2.new(0, 520, 0, 360)
Main.Position = UDim2.new(0.5,-260,0.5,-180)
Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.Visible = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

-- DRAG
do
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = Main.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

--==================================================
-- TOP BAR
--==================================================
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1,0,0,36)
Top.BackgroundColor3 = Color3.fromRGB(10,10,10)

local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(1,-80,1,0)
Title.Position = UDim2.new(0,10,0,0)
Title.Text = "AMS HUB - Fish It"
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1

-- MINIMIZE
local MinBtn = Instance.new("TextButton", Top)
MinBtn.Size = UDim2.new(0,30,0,30)
MinBtn.Position = UDim2.new(1,-35,0,3)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
MinBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1,0)

--==================================================
-- BUBBLE ICON
--==================================================
local Bubble = Instance.new("TextButton", GUI)
Bubble.Size = UDim2.new(0,48,0,48)
Bubble.Position = UDim2.new(0,30,0.5,0)
Bubble.Text = "AMS"
Bubble.Visible = false
Bubble.BackgroundColor3 = Color3.fromRGB(120,0,0)
Bubble.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Bubble).CornerRadius = UDim.new(1,0)

-- DRAG BUBBLE
do
    local dragging, dragStart, startPos
    Bubble.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = Bubble.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            Bubble.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    Bubble.Visible = true
end)

Bubble.MouseButton1Click:Connect(function()
    Main.Visible = true
    Bubble.Visible = false
end)

--==================================================
-- SIDEBAR
--==================================================
local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0,120,1,-36)
Side.Position = UDim2.new(0,0,0,36)
Side.BackgroundColor3 = Color3.fromRGB(12,12,12)

local TeleportBtn = Instance.new("TextButton", Side)
TeleportBtn.Size = UDim2.new(1,-10,0,36)
TeleportBtn.Position = UDim2.new(0,5,0,10)
TeleportBtn.Text = "Teleport"
TeleportBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
TeleportBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", TeleportBtn).CornerRadius = UDim.new(0,8)

--==================================================
-- CONTENT
--==================================================
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1,-120,1,-36)
Content.Position = UDim2.new(0,120,0,36)
Content.BackgroundColor3 = Color3.fromRGB(18,18,18)

-- SEARCH BAR
local Search = Instance.new("TextBox", Content)
Search.Size = UDim2.new(1,-20,0,32)
Search.Position = UDim2.new(0,10,0,10)
Search.PlaceholderText = "Search location..."
Search.Text = ""
Search.BackgroundColor3 = Color3.fromRGB(25,25,25)
Search.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Search).CornerRadius = UDim.new(0,8)

-- SCROLL
local Scroll = Instance.new("ScrollingFrame", Content)
Scroll.Position = UDim2.new(0,10,0,52)
Scroll.Size = UDim2.new(1,-20,1,-62)
Scroll.ScrollBarImageTransparency = 0.3
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.None
Scroll.BackgroundTransparency = 1

--==================================================
-- BUILD TELEPORT LIST (SAFE)
--==================================================
local function buildList(filter)
    Scroll:ClearAllChildren()

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,8)
    layout.Parent = Scroll

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
    end)

    filter = filter and filter:lower() or ""

    for category, places in pairs(Teleports) do
        local header = Instance.new("TextLabel", Scroll)
        header.Size = UDim2.new(1,0,0,26)
        header.Text = category
        header.Font = Enum.Font.GothamBold
        header.TextSize = 13
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.TextColor3 = Color3.fromRGB(255,80,80)
        header.BackgroundTransparency = 1

        for name, cf in pairs(places) do
            if filter == "" or name:lower():find(filter) then
                local b = Instance.new("TextButton", Scroll)
                b.Size = UDim2.new(1,0,0,40)
                b.Text = name
                b.Font = Enum.Font.Gotham
                b.TextSize = 14
                b.BackgroundColor3 = Color3.fromRGB(120,0,0)
                b.TextColor3 = Color3.new(1,1,1)
                Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

                b.MouseButton1Click:Connect(function()
                    getHRP().CFrame = cf + SAFE_OFFSET
                end)
            end
        end
    end
end

TeleportBtn.MouseButton1Click:Connect(function()
    buildList(Search.Text)
end)

Search:GetPropertyChangedSignal("Text"):Connect(function()
    buildList(Search.Text)
end)

--==================================================
-- RIGHT SHIFT TOGGLE
--==================================================
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
        Bubble.Visible = not Main.Visible
    end
end)
