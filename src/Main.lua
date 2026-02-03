--==================================
-- AmsHub | Fish It
-- Main.lua (Single File)
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
-- TELEPORT SETTINGS (FAST, NO FREEZE)
--==================================
local TELEPORT_OFFSET = Vector3.new(0, 3, 0) -- kecil, presisi
local TELEPORT_TIME = 0.04 -- makin kecil makin instan (0.03–0.06 recommended)

--==================================
-- TELEPORT DATA (EDIT KOORDINAT DI SINI)
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
-- FAST SMOOTH TELEPORT (NO FREEZE)
--==================================
local function fastSmoothTeleport(cf)
    local hrp = getHRP()
    local targetCF = cf + TELEPORT_OFFSET

    -- Tween sangat cepat & linear → halus, instan, tidak mengganggu aksi (mancing)
    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(TELEPORT_TIME, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
        {CFrame = targetCF}
    )
    tween:Play()
end

--==================================
-- UI CREATION
--==================================
local gui = Instance.new("ScreenGui")
gui.Name = "AmsHub"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

-- MAIN FRAME
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 520, 0, 340)
Main.Position = UDim2.new(0.5,-260,0.5,-170)
Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

-- TITLE BAR
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,36)
Title.Text = "AmsHub | Fish It"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local TitlePadding = Instance.new("UIPadding")
TitlePadding.PaddingLeft = UDim.new(0,12)
TitlePadding.Parent = Title

-- SIDEBAR
local Side = Instance.new("Frame", Main)
Side.Position = UDim2.new(0,0,0,36)
Side.Size = UDim2.new(0,140,1,-36)
Side.BackgroundColor3 = Color3.fromRGB(20,20,20)

-- CONTENT
local Content = Instance.new("Frame", Main)
Content.Position = UDim2.new(0,140,0,36)
Content.Size = UDim2.new(1,-140,1,-36)
Content.BackgroundColor3 = Color3.fromRGB(10,10,10)

--==================================
-- SIDEBAR BUTTON (COLLAPSE)
--==================================
local TeleportBtn = Instance.new("TextButton", Side)
TeleportBtn.Size = UDim2.new(1,-10,0,40)
TeleportBtn.Position = UDim2.new(0,5,0,10)
TeleportBtn.Text = "TELEPORT"
TeleportBtn.Font = Enum.Font.GothamBold
TeleportBtn.TextSize = 14
TeleportBtn.TextColor3 = Color3.new(1,1,1)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
Instance.new("UICorner", TeleportBtn).CornerRadius = UDim.new(0,8)

--==================================
-- SEARCH BAR
--==================================
local Search = Instance.new("TextBox", Content)
Search.Size = UDim2.new(1,-20,0,34)
Search.Position = UDim2.new(0,10,0,10)
Search.PlaceholderText = "Search location..."
Search.Text = ""
Search.ClearTextOnFocus = false
Search.Font = Enum.Font.Gotham
Search.TextSize = 14
Search.TextColor3 = Color3.new(1,1,1)
Search.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", Search).CornerRadius = UDim.new(0,8)

--==================================
-- SCROLLING LIST (RAPI & SCROLL)
--==================================
local Scroll = Instance.new("ScrollingFrame", Content)
Scroll.Position = UDim2.new(0,10,0,54)
Scroll.Size = UDim2.new(1,-20,1,-64)
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.ScrollBarImageTransparency = 0.2
Scroll.BackgroundTransparency = 1
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.None

local function rebuildList(filter)
    Scroll:ClearAllChildren()

    local layout = Instance.new("UIListLayout", Scroll)
    layout.Padding = UDim.new(0,6)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
    end)

    for _,tp in ipairs(Teleports) do
        if (not filter) or string.find(tp.name:lower(), filter:lower(), 1, true) then
            local b = Instance.new("TextButton", Scroll)
            b.Size = UDim2.new(1,0,0,42)
            b.Text = tp.name.."  ["..tp.cat.."]"
            b.Font = Enum.Font.GothamBold
            b.TextSize = 13
            b.TextColor3 = Color3.new(1,1,1)
            b.BackgroundColor3 = Color3.fromRGB(120,0,0)
            Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

            b.MouseButton1Click:Connect(function()
                fastSmoothTeleport(tp.cf)
            end)
        end
    end
end

TeleportBtn.MouseButton1Click:Connect(function()
    rebuildList(Search.Text ~= "" and Search.Text or nil)
end)

Search:GetPropertyChangedSignal("Text"):Connect(function()
    rebuildList(Search.Text ~= "" and Search.Text or nil)
end)

--==================================
-- MINIMIZE TO BUBBLE (DRAGGABLE)
--==================================
local Bubble = Instance.new("TextButton", gui)
Bubble.Size = UDim2.new(0,50,0,50)
Bubble.Position = UDim2.new(0,20,0.5,-25)
Bubble.Text = "A"
Bubble.Visible = false
Bubble.BackgroundColor3 = Color3.fromRGB(120,0,0)
Bubble.TextColor3 = Color3.new(1,1,1)
Bubble.Font = Enum.Font.GothamBold
Bubble.TextSize = 18
Bubble.Active = true
Bubble.Draggable = true
Instance.new("UICorner", Bubble).CornerRadius = UDim.new(1,0)

local MinBtn = Instance.new("TextButton", Title)
MinBtn.Size = UDim2.new(0,30,0,30)
MinBtn.Position = UDim2.new(1,-40,0,3)
MinBtn.Text = "-"
MinBtn.BackgroundTransparency = 1
MinBtn.TextColor3 = Color3.new(1,1,1)

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    Bubble.Visible = true
end)

Bubble.MouseButton1Click:Connect(function()
    Bubble.Visible = false
    Main.Visible = true
end)

--==================================
-- RIGHT SHIFT HIDE / SHOW
--==================================
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
        Bubble.Visible = false
    end
end)

-- INITIAL LOAD
rebuildList()
