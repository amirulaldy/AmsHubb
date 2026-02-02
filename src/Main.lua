-- FishItHub Main FINAL
-- Sidebar Collapse | Full Map Teleport | Black & Red UI

if game.CoreGui:FindFirstChild("FishItHub") then
	game.CoreGui.FishItHub:Destroy()
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local isMobile = UIS.TouchEnabled

-- Anti AFK
pcall(function()
	for _,v in pairs(getconnections(player.Idled)) do
		v:Disable()
	end
end)

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FishItHub"
gui.IgnoreGuiInset = true

-- Auto scale mobile
local scale = Instance.new("UIScale", gui)
scale.Scale = isMobile and 0.9 or 1

-- MAIN FRAME
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.6, 0.48)
main.Position = UDim2.fromScale(0.2, 0.26)
main.BackgroundColor3 = Color3.fromRGB(0,0,0)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Fish It Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)

-- CLOSE
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,40,0,40)
close.Position = UDim2.new(1,-40,0,0)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.TextColor3 = Color3.fromRGB(255,60,60)
close.BackgroundTransparency = 1

-- MINIMIZE BUBBLE
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.fromOffset(50,50)
bubble.Position = UDim2.fromScale(0.05,0.5)
bubble.Text = "🐟"
bubble.TextSize = 22
bubble.BackgroundColor3 = Color3.fromRGB(0,0,0)
bubble.TextColor3 = Color3.fromRGB(255,60,60)
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
local side = Instance.new("Frame", main)
side.Position = UDim2.new(0,0,0,40)
side.Size = UDim2.new(0,180,1,-40)
side.BackgroundColor3 = Color3.fromRGB(10,10,10)
side.BorderSizePixel = 0

-- CONTENT
local content = Instance.new("Frame", main)
content.Position = UDim2.new(0,180,0,40)
content.Size = UDim2.new(1,-180,1,-40)
content.BackgroundTransparency = 1

-- COLLAPSE BUTTON
local collapsed = false
local collapseBtn = Instance.new("TextButton", side)
collapseBtn.Size = UDim2.new(1,-20,0,32)
collapseBtn.Position = UDim2.new(0,10,0,10)
collapseBtn.Text = "<"
collapseBtn.Font = Enum.Font.GothamBold
collapseBtn.TextSize = 16
collapseBtn.TextColor3 = Color3.new(1,1,1)
collapseBtn.BackgroundColor3 = Color3.fromRGB(180,0,0)
Instance.new("UICorner", collapseBtn).CornerRadius = UDim.new(0,8)

local function toggleSidebar()
	collapsed = not collapsed
	local sideSize = collapsed and UDim2.new(0,50,1,-40) or UDim2.new(0,180,1,-40)
	local contentPos = collapsed and UDim2.new(0,50,0,40) or UDim2.new(0,180,0,40)
	local contentSize = collapsed and UDim2.new(1,-50,1,-40) or UDim2.new(1,-180,1,-40)

	TweenService:Create(side, TweenInfo.new(0.25), {Size = sideSize}):Play()
	TweenService:Create(content, TweenInfo.new(0.25), {
		Position = contentPos,
		Size = contentSize
	}):Play()

	collapseBtn.Text = collapsed and ">" or "<"
end

collapseBtn.MouseButton1Click:Connect(toggleSidebar)

-- TELEPORT DATA (Fish It – FULL MAP)
-- Jika ada spot meleset dikit, tinggal edit angka CFrame
local Teleports = {
	["Spawn"]        = CFrame.new(0, 70, 0),
	["Ocean"]        = CFrame.new(220, 75, -180),
	["Deep Ocean"]   = CFrame.new(480, 60, -620),
	["Jungle"]       = CFrame.new(1180, 85, -460),
	["Ancient Ruins"]= CFrame.new(1420, 90, -880),
	["Volcano"]      = CFrame.new(-360, 95, 760),
	["Ice Land"]     = CFrame.new(-980, 90, -240),
	["Sky Island"]   = CFrame.new(0, 420, 0),
}

-- BUTTON CREATOR
local function sideBtn(text, y, cf)
	local b = Instance.new("TextButton", side)
	b.Size = UDim2.new(1,-20,0,36)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = collapsed and "" or text
	b.Font = Enum.Font.Gotham
	b.TextSize = 13
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(180,0,0)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

	b.MouseButton1Click:Connect(function()
		local char = player.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = cf
		end
	end)

	return b
end

-- CREATE TELEPORT BUTTONS
local y = 52
for name, cf in pairs(Teleports) do
	sideBtn("TP "..name, y, cf)
	y += 42
end

-- RIGHT SHIFT TOGGLE (PC)
UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.RightShift then
		main.Visible = not main.Visible
	end
end)
