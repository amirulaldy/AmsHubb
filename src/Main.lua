--// AmsHubb Fish It
--// GitHub Ready | No Autofarm | Mobile Safe

if game.CoreGui:FindFirstChild("AmsHubb") then
	game.CoreGui.AmsHub:Destroy()
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Player = Players.LocalPlayer

--// Anti AFK
Player.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.zero, workspace.CurrentCamera.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.zero, workspace.CurrentCamera.CFrame)
end)

--// GUI
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "AmsHub"
Gui.ResetOnSpawn = false

--// Main Panel
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromScale(0.45, 0.45)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,16)

--// Mobile scale
if UIS.TouchEnabled then
	Instance.new("UIScale", Main).Scale = 1.15
end

--// Anime Background
local Anime = Instance.new("ImageLabel", Main)
Anime.Size = UDim2.fromScale(1,1)
Anime.BackgroundTransparency = 1
Anime.ImageTransparency = 0.85
Anime.Image = "rbxassetid://PUT_ANIME_IMAGE_ID"
Anime.ScaleType = Enum.ScaleType.Crop
Anime.ZIndex = 0

--// Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,-80,0,40)
Title.Position = UDim2.new(0,15,0,5)
Title.Text = "AmsHub • Fish It"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.ZIndex = 2

--// Minimize
local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.new(0,30,0,30)
Min.Position = UDim2.new(1,-40,0,8)
Min.Text = "–"
Min.TextSize = 20
Min.BackgroundColor3 = Color3.fromRGB(35,35,35)
Min.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Min).CornerRadius = UDim.new(1,0)

--// Content
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1,-20,1,-60)
Content.Position = UDim2.new(0,10,0,50)
Content.BackgroundTransparency = 1
Content.ZIndex = 2

--// Button maker
local function btn(text,y)
	local b = Instance.new("TextButton", Content)
	b.Size = UDim2.new(1,0,0,42)
	b.Position = UDim2.new(0,0,0,y)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	return b
end

--// Fish It Teleport (STABLE WORLD POSITIONS)
local TP = {
	Jungle = CFrame.new(128, 18, -356),
	Ocean  = CFrame.new(-245, 12, 190),
	Shop   = CFrame.new(52, 8, 74),
	Ruins  = CFrame.new(-510, 22, -920),
	Volcano = CFrame.new(310, 25, -1180)
}

local function teleport(cf)
	local char = Player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = cf
	end
end

btn("TP Jungle",0).MouseButton1Click:Connect(function() teleport(TP.Jungle) end)
btn("TP Ocean",52).MouseButton1Click:Connect(function() teleport(TP.Ocean) end)
btn("TP Shop",104).MouseButton1Click:Connect(function() teleport(TP.Shop) end)
btn("TP Ruins",156).MouseButton1Click:Connect(function() teleport(TP.Ruins) end)
btn("TP Volcano",208).MouseButton1Click:Connect(function() teleport(TP.Volcano) end)

--// Bubble minimize
local Bubble = Instance.new("TextButton", Gui)
Bubble.Size = UDim2.new(0,55,0,55)
Bubble.Position = UDim2.fromScale(0.1,0.5)
Bubble.Text = "🫧"
Bubble.TextSize = 26
Bubble.Visible = false
Bubble.BackgroundColor3 = Color3.fromRGB(20,20,20)
Bubble.TextColor3 = Color3.new(1,1,1)
Bubble.Active = true
Bubble.Draggable = true
Instance.new("UICorner", Bubble).CornerRadius = UDim.new(1,0)

Min.MouseButton1Click:Connect(function()
	Main.Visible = false
	Bubble.Visible = true
end)

Bubble.MouseButton1Click:Connect(function()
	Main.Visible = true
	Bubble.Visible = false
end)

--// RightShift toggle
UIS.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.RightShift then
		Main.Visible = not Main.Visible
	end
end)
