-- FishItHub Main (UPDATED)
-- Sidebar | Save Config | Mobile Scale | Theme Switch

if game.CoreGui:FindFirstChild("FishItHub") then
	game.CoreGui.FishItHub:Destroy()
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local isMobile = UIS.TouchEnabled

-- Anti AFK
pcall(function()
	for _,v in pairs(getconnections(player.Idled)) do
		v:Disable()
	end
end)

-- CONFIG (SESSION SAVE)
local Config = {
	LastTeleport = nil,
	Theme = "Dark"
}

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FishItHub"
gui.IgnoreGuiInset = true

-- AUTO SCALE (MOBILE)
local scale = Instance.new("UIScale", gui)
scale.Scale = isMobile and 0.9 or 1

-- MAIN FRAME
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.55, 0.45)
main.Position = UDim2.fromScale(0.225, 0.275)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

-- THEMES
local Themes = {
	Dark = {
		BG = Color3.fromRGB(15,15,15),
		Side = Color3.fromRGB(25,25,25),
		Btn = Color3.fromRGB(35,35,35),
	},
	Anime = {
		BG = Color3.fromRGB(20,10,25),
		Side = Color3.fromRGB(40,20,50),
		Btn = Color3.fromRGB(60,30,80),
	}
}

local function applyTheme(name)
	Config.Theme = name
	main.BackgroundColor3 = Themes[name].BG
	side.BackgroundColor3 = Themes[name].Side
end

-- BACKGROUND IMAGE (ANIME)
local bg = Instance.new("ImageLabel", main)
bg.Size = UDim2.fromScale(1,1)
bg.BackgroundTransparency = 1
bg.ImageTransparency = 0.25
bg.ScaleType = Enum.ScaleType.Crop
bg.Image = "rbxassetid://YOUR_IMAGE_ID" -- ganti
bg.ZIndex = 0

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Fish It Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.ZIndex = 2

-- CLOSE
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,40,0,40)
close.Position = UDim2.new(1,-40,0,0)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.TextColor3 = Color3.fromRGB(255,80,80)
close.BackgroundTransparency = 1
close.ZIndex = 2

-- MINIMIZE BUBBLE
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.fromOffset(50,50)
bubble.Position = UDim2.fromScale(0.05,0.5)
bubble.Text = "🐟"
bubble.TextSize = 22
bubble.BackgroundColor3 = Color3.fromRGB(20,20,20)
bubble.Visible = false
bubble.ZIndex = 5
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1,0)

close.MouseButton1Click:Connect(function()
	main.Visible = false
	bubble.Visible = true
end)

bubble.MouseButton1Click:Connect(function()
	main.Visible = true
	bubble.Visible = false
end)

-- SIDEBAR
side = Instance.new("Frame", main)
side.Size = UDim2.new(0,160,1,-40)
side.Position = UDim2.new(0,0,0,40)
side.BorderSizePixel = 0

-- CONTENT
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-160,1,-40)
content.Position = UDim2.new(0,160,0,40)
content.BackgroundTransparency = 1

-- TELEPORT DATA (Fish It – contoh)
local Teleports = {
	Jungle  = CFrame.new(1200, 80, -450),
	Volcano = CFrame.new(-320, 95, 780),
	Ocean   = CFrame.new(0, 70, 0),
}

-- SIDEBAR BUTTON
local function sideBtn(text,y,cb)
	local b = Instance.new("TextButton", side)
	b.Size = UDim2.new(1,-20,0,36)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Themes.Dark.Btn
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	b.MouseButton1Click:Connect(cb)
end

-- TELEPORT BUTTONS
local y = 10
for name,cf in pairs(Teleports) do
	sideBtn("TP "..name, y, function()
		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = cf
			Config.LastTeleport = name
		end
	end)
	y += 46
end

-- THEME SWITCH
sideBtn("Theme: Dark", y, function()
	applyTheme("Dark")
end)
y += 46

sideBtn("Theme: Anime", y, function()
	applyTheme("Anime")
end)

applyTheme(Config.Theme)

-- RESTORE LAST TELEPORT (OPTIONAL)
task.delay(2, function()
	if Config.LastTeleport and Teleports[Config.LastTeleport] then
		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = Teleports[Config.LastTeleport]
		end
	end
end)

-- RIGHT SHIFT TOGGLE
UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.RightShift then
		main.Visible = not main.Visible
	end
end)
