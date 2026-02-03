--==================================
-- AmsHub | Fish It
-- Main.lua (Single File) + AUTO FISH
--==================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer

--==================================
-- AUTO FISH SYSTEM
--==================================
local AutoFish = {
    Enabled = false,
    Fishing = false,
    Cooldown = 5, -- seconds between casts
    LastCast = 0
}

-- Function to simulate fishing action
local function castFishingRod()
    if not LP.Character then return false end
    
    -- Cari fishing rod di inventory/backpack
    local rod = nil
    local backpack = LP:FindFirstChild("Backpack")
    if backpack then
        rod = backpack:FindFirstChild("FishingRod") or 
              backpack:FindFirstChild("Rod") or
              backpack:FindFirstChildWhichIsA("Tool")
    end
    
    -- Cari rod di tangan
    if not rod and LP.Character then
        rod = LP.Character:FindFirstChild("FishingRod") or 
              LP.Character:FindFirstChild("Rod") or
              LP.Character:FindFirstChildWhichIsA("Tool")
    end
    
    if rod then
        -- Equip rod
        if rod.Parent ~= LP.Character then
            rod.Parent = LP.Character
            task.wait(0.5)
        end
        
        -- Activate rod (click mouse)
        local success = pcall(function()
            -- Try to activate tool
            rod:Activate()
            
            -- Alternative: click at screen center
            local mouse = LP:GetMouse()
            local connection
            connection = RunService.Heartbeat:Connect(function()
                if AutoFish.Fishing then
                    -- Simulate click
                    if rod:FindFirstChild("RemoteEvent") then
                        rod.RemoteEvent:FireServer("Cast")
                    end
                else
                    connection:Disconnect()
                end
            end)
        end)
        
        return success
    end
    
    return false
end

-- Function to check if fish caught (placeholder)
local function checkFishCaught()
    -- Ini placeholder - perlu diadaptasi dengan game mechanic
    local chance = math.random(1, 100)
    return chance > 30 -- 70% success rate
end

-- Auto fishing loop
local fishConnection
local function startAutoFishing()
    if fishConnection then fishConnection:Disconnect() end
    
    AutoFish.Fishing = true
    fishConnection = RunService.Heartbeat:Connect(function()
        if not AutoFish.Enabled or not AutoFish.Fishing then
            fishConnection:Disconnect()
            return
        end
        
        local now = tick()
        if now - AutoFish.LastCast >= AutoFish.Cooldown then
            AutoFish.LastCast = now
            
            -- Cast fishing rod
            local success = castFishingRod()
            if success then
                -- Wait for fish bite
                task.wait(3)
                
                -- Check if fish caught
                if checkFishCaught() then
                    print("[Auto Fish] Fish caught!")
                    -- Reel in
                    task.wait(1)
                else
                    print("[Auto Fish] No bite, recasting...")
                end
            else
                print("[Auto Fish] No fishing rod found!")
            end
        end
    end)
end

local function stopAutoFishing()
    AutoFish.Fishing = false
    if fishConnection then
        fishConnection:Disconnect()
        fishConnection = nil
    end
    print("[Auto Fish] Stopped")
end

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
Main.Size = UDim2.new(0, 520, 0, 400) -- Increased height for auto fish
Main.Position = UDim2.new(0.5,-260,0.5,-200)
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
-- SIDEBAR BUTTONS (MENU SYSTEM)
--==================================
local MenuButtons = {
    TeleportBtn = nil,
    AutoFishBtn = nil,
    SettingsBtn = nil
}

-- TELEPORT BUTTON
MenuButtons.TeleportBtn = Instance.new("TextButton", Side)
MenuButtons.TeleportBtn.Name = "TeleportBtn"
MenuButtons.TeleportBtn.Size = UDim2.new(1,-10,0,40)
MenuButtons.TeleportBtn.Position = UDim2.new(0,5,0,10)
MenuButtons.TeleportBtn.Text = "📍 TELEPORT"
MenuButtons.TeleportBtn.Font = Enum.Font.GothamBold
MenuButtons.TeleportBtn.TextSize = 14
MenuButtons.TeleportBtn.TextColor3 = Color3.new(1,1,1)
MenuButtons.TeleportBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
Instance.new("UICorner", MenuButtons.TeleportBtn).CornerRadius = UDim.new(0,8)

-- AUTO FISH BUTTON
MenuButtons.AutoFishBtn = Instance.new("TextButton", Side)
MenuButtons.AutoFishBtn.Name = "AutoFishBtn"
MenuButtons.AutoFishBtn.Size = UDim2.new(1,-10,0,40)
MenuButtons.AutoFishBtn.Position = UDim2.new(0,5,0,60)
MenuButtons.AutoFishBtn.Text = "🎣 AUTO FISH: OFF"
MenuButtons.AutoFishBtn.Font = Enum.Font.GothamBold
MenuButtons.AutoFishBtn.TextSize = 14
MenuButtons.AutoFishBtn.TextColor3 = Color3.new(1,1,1)
MenuButtons.AutoFishBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", MenuButtons.AutoFishBtn).CornerRadius = UDim.new(0,8)

-- SETTINGS BUTTON
MenuButtons.SettingsBtn = Instance.new("TextButton", Side)
MenuButtons.SettingsBtn.Name = "SettingsBtn"
MenuButtons.SettingsBtn.Size = UDim2.new(1,-10,0,40)
MenuButtons.SettingsBtn.Position = UDim2.new(0,5,0,110)
MenuButtons.SettingsBtn.Text = "⚙️ SETTINGS"
MenuButtons.SettingsBtn.Font = Enum.Font.GothamBold
MenuButtons.SettingsBtn.TextSize = 14
MenuButtons.SettingsBtn.TextColor3 = Color3.new(1,1,1)
MenuButtons.SettingsBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", MenuButtons.SettingsBtn).CornerRadius = UDim.new(0,8)

--==================================
-- CONTENT PANELS
--==================================
local Panels = {
    TeleportPanel = nil,
    AutoFishPanel = nil,
    SettingsPanel = nil
}

-- TELEPORT PANEL (Default)
Panels.TeleportPanel = Instance.new("Frame", Content)
Panels.TeleportPanel.Name = "TeleportPanel"
Panels.TeleportPanel.Size = UDim2.new(1,0,1,0)
Panels.TeleportPanel.BackgroundTransparency = 1
Panels.TeleportPanel.Visible = true

-- SEARCH BAR (in Teleport Panel)
local Search = Instance.new("TextBox", Panels.TeleportPanel)
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

-- SCROLLING LIST
local Scroll = Instance.new("ScrollingFrame", Panels.TeleportPanel)
Scroll.Position = UDim2.new(0,10,0,54)
Scroll.Size = UDim2.new(1,-20,1,-64)
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.ScrollBarImageTransparency = 0.2
Scroll.BackgroundTransparency = 1
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.None

-- AUTO FISH PANEL
Panels.AutoFishPanel = Instance.new("Frame", Content)
Panels.AutoFishPanel.Name = "AutoFishPanel"
Panels.AutoFishPanel.Size = UDim2.new(1,0,1,0)
Panels.AutoFishPanel.BackgroundTransparency = 1
Panels.AutoFishPanel.Visible = false

-- Auto Fish Title
local AutoFishTitle = Instance.new("TextLabel", Panels.AutoFishPanel)
AutoFishTitle.Size = UDim2.new(1,-20,0,40)
AutoFishTitle.Position = UDim2.new(0,10,0,10)
AutoFishTitle.Text = "🎣 AUTO FISHING SYSTEM"
AutoFishTitle.TextColor3 = Color3.new(1,1,1)
AutoFishTitle.Font = Enum.Font.GothamBold
AutoFishTitle.TextSize = 18
AutoFishTitle.BackgroundTransparency = 1
AutoFishTitle.TextXAlignment = Enum.TextXAlignment.Center

-- Status Display
local StatusFrame = Instance.new("Frame", Panels.AutoFishPanel)
StatusFrame.Size = UDim2.new(1,-20,0,100)
StatusFrame.Position = UDim2.new(0,10,0,60)
StatusFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", StatusFrame).CornerRadius = UDim.new(0,10)

local StatusLabel = Instance.new("TextLabel", StatusFrame)
StatusLabel.Size = UDim2.new(1,-20,0,40)
StatusLabel.Position = UDim2.new(0,10,0,10)
StatusLabel.Text = "Status: OFF"
StatusLabel.TextColor3 = Color3.fromRGB(255,100,100)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 16
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local FishCountLabel = Instance.new("TextLabel", StatusFrame)
FishCountLabel.Size = UDim2.new(1,-20,0,40)
FishCountLabel.Position = UDim2.new(0,10,0,50)
FishCountLabel.Text = "Fish Caught: 0"
FishCountLabel.TextColor3 = Color3.fromRGB(200,200,200)
FishCountLabel.Font = Enum.Font.Gotham
FishCountLabel.TextSize = 14
FishCountLabel.BackgroundTransparency = 1
FishCountLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Toggle Button
local ToggleButton = Instance.new("TextButton", Panels.AutoFishPanel)
ToggleButton.Size = UDim2.new(1,-20,0,50)
ToggleButton.Position = UDim2.new(0,10,0,170)
ToggleButton.Text = "▶ START AUTO FISH"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0,150,0)
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0,10)

-- Settings
local SettingsFrame = Instance.new("Frame", Panels.AutoFishPanel)
SettingsFrame.Size = UDim2.new(1,-20,0,120)
SettingsFrame.Position = UDim2.new(0,10,0,230)
SettingsFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", SettingsFrame).CornerRadius = UDim.new(0,10)

local SettingsTitle = Instance.new("TextLabel", SettingsFrame)
SettingsTitle.Size = UDim2.new(1,-20,0,30)
SettingsTitle.Position = UDim2.new(0,10,0,5)
SettingsTitle.Text = "Settings"
SettingsTitle.TextColor3 = Color3.fromRGB(200,200,200)
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.TextSize = 14
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Cooldown Slider
local CooldownLabel = Instance.new("TextLabel", SettingsFrame)
CooldownLabel.Size = UDim2.new(1,-20,0,25)
CooldownLabel.Position = UDim2.new(0,10,0,40)
CooldownLabel.Text = "Cast Cooldown: " .. AutoFish.Cooldown .. "s"
CooldownLabel.TextColor3 = Color3.fromRGB(200,200,200)
CooldownLabel.Font = Enum.Font.Gotham
CooldownLabel.TextSize = 13
CooldownLabel.BackgroundTransparency = 1
CooldownLabel.TextXAlignment = Enum.TextXAlignment.Left

local CooldownSlider = Instance.new("TextBox", SettingsFrame)
CooldownSlider.Size = UDim2.new(1,-20,0,30)
CooldownSlider.Position = UDim2.new(0,10,0,70)
CooldownSlider.Text = tostring(AutoFish.Cooldown)
CooldownSlider.PlaceholderText = "Seconds"
CooldownSlider.Font = Enum.Font.Gotham
CooldownSlider.TextSize = 14
CooldownSlider.TextColor3 = Color3.new(1,1,1)
CooldownSlider.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", CooldownSlider).CornerRadius = UDim.new(0,6)

-- SETTINGS PANEL
Panels.SettingsPanel = Instance.new("Frame", Content)
Panels.SettingsPanel.Name = "SettingsPanel"
Panels.SettingsPanel.Size = UDim2.new(1,0,1,0)
Panels.SettingsPanel.BackgroundTransparency = 1
Panels.SettingsPanel.Visible = false

local SettingsPanelTitle = Instance.new("TextLabel", Panels.SettingsPanel)
SettingsPanelTitle.Size = UDim2.new(1,-20,0,40)
SettingsPanelTitle.Position = UDim2.new(0,10,0,10)
SettingsPanelTitle.Text = "⚙️ SETTINGS"
SettingsPanelTitle.TextColor3 = Color3.new(1,1,1)
SettingsPanelTitle.Font = Enum.Font.GothamBold
SettingsPanelTitle.TextSize = 18
SettingsPanelTitle.BackgroundTransparency = 1
SettingsPanelTitle.TextXAlignment = Enum.TextXAlignment.Center

--==================================
-- PANEL MANAGEMENT
--==================================
local function showPanel(panelName)
    -- Hide all panels
    for name, panel in pairs(Panels) do
        panel.Visible = false
    end
    
    -- Reset all button colors
    for name, btn in pairs(MenuButtons) do
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    end
    
    -- Show selected panel
    if Panels[panelName] then
        Panels[panelName].Visible = true
        if MenuButtons[panelName:gsub("Panel", "Btn")] then
            MenuButtons[panelName:gsub("Panel", "Btn")].BackgroundColor3 = Color3.fromRGB(120,0,0)
        end
    end
    
    -- Update auto fish button text
    if panelName == "AutoFishPanel" then
        MenuButtons.AutoFishBtn.Text = "🎣 AUTO FISH"
    else
        MenuButtons.AutoFishBtn.Text = "🎣 AUTO FISH: " .. (AutoFish.Enabled and "ON" or "OFF")
    end
end

-- Button click handlers
MenuButtons.TeleportBtn.MouseButton1Click:Connect(function()
    showPanel("TeleportPanel")
end)

MenuButtons.AutoFishBtn.MouseButton1Click:Connect(function()
    showPanel("AutoFishPanel")
end)

MenuButtons.SettingsBtn.MouseButton1Click:Connect(function()
    showPanel("SettingsPanel")
end)

--==================================
-- AUTO FISH FUNCTIONS
--==================================
local fishCaughtCount = 0

local function updateAutoFishStatus()
    if AutoFish.Enabled then
        StatusLabel.Text = "Status: ACTIVE"
        StatusLabel.TextColor3 = Color3.fromRGB(100,255,100)
        ToggleButton.Text = "⏹ STOP AUTO FISH"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
        MenuButtons.AutoFishBtn.Text = "🎣 AUTO FISH: ON"
    else
        StatusLabel.Text = "Status: OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(255,100,100)
        ToggleButton.Text = "▶ START AUTO FISH"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0,150,0)
        MenuButtons.AutoFishBtn.Text = "🎣 AUTO FISH: OFF"
    end
    FishCountLabel.Text = "Fish Caught: " .. fishCaughtCount
end

ToggleButton.MouseButton1Click:Connect(function()
    AutoFish.Enabled = not AutoFish.Enabled
    
    if AutoFish.Enabled then
        startAutoFishing()
        print("[Auto Fish] Started")
    else
        stopAutoFishing()
        print("[Auto Fish] Stopped")
    end
    
    updateAutoFishStatus()
end)

CooldownSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(CooldownSlider.Text)
        if num and num >= 1 and num <= 30 then
            AutoFish.Cooldown = num
            CooldownLabel.Text = "Cast Cooldown: " .. num .. "s"
            print("[Auto Fish] Cooldown set to " .. num .. " seconds")
        else
            CooldownSlider.Text = tostring(AutoFish.Cooldown)
        end
    end
end)

--==================================
-- TELEPORT LIST FUNCTIONS
--==================================
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

-- Initialize teleport list
Search:GetPropertyChangedSignal("Text"):Connect(function()
    rebuildList(Search.Text ~= "" and Search.Text or nil)
end)

--==================================
-- MINIMIZE TO BUBBLE (DRAGGABLE)
--==================================
local Bubble = Instance.new("TextButton", gui)
Bubble.Size = UDim2.new(0,50,0,50)
Bubble.Position = UDim2.new(0,20,0.5,-25)
Bubble.Text = "🎣"
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

--==================================
-- INITIAL LOAD
--==================================
rebuildList()
updateAutoFishStatus()
showPanel("TeleportPanel") -- Show teleport panel by default

print("AmsHub Fish It Loaded!")
print("Auto Fish System Ready!")
print("RightShift to toggle UI")
