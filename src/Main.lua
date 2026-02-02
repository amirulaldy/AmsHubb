-- FishItHub Main
-- Executor Safe | Single File Logic

if game.CoreGui:FindFirstChild("FishItHub") then
	game.CoreGui.FishItHub:Destroy()
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Anti AFK
pcall(function()
	for _,v in pairs(getconnections(player.Idled)) do
		v:Disable()
	end
end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FishItHub"
gui.IgnoreGuiInset = true
gui.Parent = game.CoreGui

-- MAIN PANEL
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.45, 0.4)
main.Position = UDim2.fromScale(0.275, 0.3)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

-- BACKGROUND IMAGE (ANIME)
local bg = Instance.new("ImageLabel", main)
bg.Size = UDim2.fromScale(1,1)
bg.BackgroundTransparency = 1
bg.ImageTransparency = 0.25
bg.ScaleType = Enum.ScaleType.Crop
bg.Image = "rbxassetid://YOUR_IMAGE_ID" -- GANTI
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

-- CLOSE BUTTON
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

-- TELEPORT DATA (Fish It – CONTOH KOORDINAT)
local Teleport = {
	Jungle  = CFrame.new(1200, 80, -450),
	Volcano = CFrame.new(-320, 95, 780),
	Ocean   = CFrame.new(0, 70, 0),
}

local function makeButton(text, y, cf)
	local b = Instance.new("TextButton", main)
	b.Size = UDim2.new(0.8,0,0,40)
	b.Position = UDim2.new(0.1,0,0,y)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

	b.MouseButton1Click:Connect(function()
		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = cf
		end
	end)
end

makeButton("Teleport Jungle", 60, Teleport.Jungle)
makeButton("Teleport Volcano", 110, Teleport.Volcano)
makeButton("Teleport Ocean", 160, Teleport.Ocean)

-- RIGHT SHIFT TOGGLE
UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.RightShift then
		main.Visible = not main.Visible
	end
end)
