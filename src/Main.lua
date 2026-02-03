--==================================
-- AmsHub Fish It - Delta Optimized
--==================================

-- Wait for game
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Basic services (Delta compatible)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

print("🎣 AmsHub Fish It - Delta Version Loaded")

--==================================
-- SIMPLE TELEPORT DATA
--==================================
local Teleports = {
    -- ISLAND (GANTI KOORDINAT INI!)
    {name="Fisherman Island", cf=CFrame.new(100, 50, 100)},
    {name="Kohana", cf=CFrame.new(200, 50, -150)},
    {name="Tropical Grove", cf=CFrame.new(-300, 50, 200)},
    {name="Ancient Jungle", cf=CFrame.new(400, 50, -300)},
    {name="Crater Island", cf=CFrame.new(-100, 50, 400)},
    
    -- DEPTH
    {name="Coral Reefs", cf=CFrame.new(0, -50, 0)},
    {name="Esoteric Depths", cf=CFrame.new(0, -100, 0)},
    {name="Crystal Depths", cf=CFrame.new(0, -150, 0)},
    {name="Volcano Cavern", cf=CFrame.new(0, -200, 0)},
}

--==================================
-- SIMPLE TELEPORT FUNCTION
--==================================
local function teleportTo(cf)
    local char = LP.Character
    if not char then 
        warn("No character!")
        return 
    end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        warn("No HumanoidRootPart!")
        return
    end
    
    -- Simple instant teleport (Delta friendly)
    hrp.CFrame = cf + Vector3.new(0, 3, 0)
    
    -- Notifikasi simple
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "AmsHub",
        Text = "Teleported!",
        Duration = 2
    })
end

--==================================
-- GET CURRENT POSITION (FOR DELTA)
--==================================
local function getCurrentPos()
    local char = LP.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local cf = char.HumanoidRootPart.CFrame
        return string.format("CFrame.new(%.1f, %.1f, %.1f)", cf.X, cf.Y, cf.Z)
    end
    return "No character"
end

--==================================
-- SIMPLE GUI FOR DELTA
--==================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AmsHubDelta"
ScreenGui.Parent = LP:WaitForChild("PlayerGui")

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 400)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🎣 FISH IT TELEPORT | DELTA"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
Title.BorderSizePixel = 0
Title.Parent = MainFrame

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Current Position Display
local PosFrame = Instance.new("Frame")
PosFrame.Size = UDim2.new(1, -20, 0, 60)
PosFrame.Position = UDim2.new(0, 10, 0, 50)
PosFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PosFrame.BorderSizePixel = 0
PosFrame.Parent = MainFrame

local PosLabel = Instance.new("TextLabel")
PosLabel.Size = UDim2.new(1, -10, 1, -10)
PosLabel.Position = UDim2.new(0, 5, 0, 5)
PosLabel.Text = "Current Position: Waiting..."
PosLabel.TextColor3 = Color3.new(1, 1, 1)
PosLabel.Font = Enum.Font.Gotham
PosLabel.TextSize = 14
PosLabel.BackgroundTransparency = 1
PosLabel.TextWrapped = true
PosLabel.Parent = PosFrame

-- Copy Button
local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.5, -5, 0, 30)
CopyBtn.Position = UDim2.new(0, 10, 0, 120)
CopyBtn.Text = "📋 Copy Position"
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 14
CopyBtn.TextColor3 = Color3.new(1, 1, 1)
CopyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 180)
CopyBtn.Parent = MainFrame

CopyBtn.MouseButton1Click:Connect(function()
    local pos = getCurrentPos()
    if setclipboard then
        setclipboard(pos)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Copied!",
            Text = pos,
            Duration = 2
        })
    end
end)

-- Save Location Button
local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(0.5, -5, 0, 30)
SaveBtn.Position = UDim2.new(0.5, 5, 0, 120)
SaveBtn.Text = "💾 Save Location"
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextSize = 14
SaveBtn.TextColor3 = Color3.new(1, 1, 1)
SaveBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
SaveBtn.Parent = MainFrame

SaveBtn.MouseButton1Click:Connect(function()
    local char = LP.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local cf = char.HumanoidRootPart.CFrame
        local name = "Custom_" .. tostring(math.random(1000, 9999))
        table.insert(Teleports, {name=name, cf=cf})
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Saved!",
            Text = "Saved as: " .. name,
            Duration = 2
        })
        
        -- Refresh list
        createTeleportButtons()
    end
end)

-- Scroll Frame for Locations
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -180)
ScrollFrame.Position = UDim2.new(0, 10, 0, 160)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(220, 60, 60)
ScrollFrame.Parent = MainFrame

-- Function to create teleport buttons
local function createTeleportButtons()
    ScrollFrame:ClearAllChildren()
    
    for i, tp in ipairs(Teleports) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.Position = UDim2.new(0, 5, 0, (i-1) * 45)
        btn.Text = tp.name
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.BorderSizePixel = 0
        btn.Parent = ScrollFrame
        
        -- Hover effect
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end)
        
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end)
        
        -- Click to teleport
        btn.MouseButton1Click:Connect(function()
            teleportTo(tp.cf)
        end)
        
        -- Right click to copy
        btn.MouseButton2Click:Connect(function()
            if setclipboard then
                setclipboard(string.format("CFrame.new(%.1f, %.1f, %.1f)", 
                    tp.cf.X, tp.cf.Y, tp.cf.Z))
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Copied!",
                    Text = "CFrame copied",
                    Duration = 2
                })
            end
        end)
    end
    
    -- Set canvas size
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #Teleports * 45)
end

-- Update position display
game:GetService("RunService").RenderStepped:Connect(function()
    local pos = getCurrentPos()
    PosLabel.Text = "📍 Current Position:\n" .. pos
end)

-- Create buttons initially
createTeleportButtons()

--==================================
-- HOTKEY TOGGLE
--==================================
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

--==================================
-- MINIMIZE TO TRAY
--==================================
local TrayBtn = Instance.new("TextButton")
TrayBtn.Size = UDim2.new(0, 50, 0, 50)
TrayBtn.Position = UDim2.new(0, 20, 0.5, -25)
TrayBtn.Text = "🎣"
TrayBtn.Font = Enum.Font.GothamBold
TrayBtn.TextSize = 20
TrayBtn.TextColor3 = Color3.new(1, 1, 1)
TrayBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
TrayBtn.Visible = false
TrayBtn.Parent = ScreenGui

local TrayCorner = Instance.new("UICorner")
TrayCorner.CornerRadius = UDim.new(1, 0)
TrayCorner.Parent = TrayBtn

-- Minimize button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.Text = "_"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinBtn.Parent = MainFrame

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    TrayBtn.Visible = true
end)

TrayBtn.MouseButton1Click:Connect(function()
    TrayBtn.Visible = false
    MainFrame.Visible = true
end)

--==================================
-- INITIAL NOTIFICATION
--==================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "AmsHub Delta",
    Text = "Loaded! RightShift to toggle",
    Duration = 3
})

print("✅ AmsHub Delta successfully loaded!")
