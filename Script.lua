--// HAZEYWARE - Rivals Visual GUI
--// Dark Textures + Grey Sky Toggle

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Remove old GUI
pcall(function()
	if PlayerGui:FindFirstChild("HazeyVisuals") then
		PlayerGui.HazeyVisuals:Destroy()
	end
end)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HazeyVisuals"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 260, 0, 180)
Main.Position = UDim2.new(0.5, -130, 0.5, -90)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(90,90,90)
Stroke.Thickness = 1.5
Stroke.Parent = Main

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "HAZEYWARE"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(220,220,220)
Title.Parent = Main

-- Dragging
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	Main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

Title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Title.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Toggle creator
local function CreateToggle(text, yPos)
	local Holder = Instance.new("Frame")
	Holder.Size = UDim2.new(1,-20,0,45)
	Holder.Position = UDim2.new(0,10,0,yPos)
	Holder.BackgroundColor3 = Color3.fromRGB(30,30,30)
	Holder.BorderSizePixel = 0
	Holder.Parent = Main

	Instance.new("UICorner", Holder).CornerRadius = UDim.new(0,10)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.7,0,1,0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 16
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextColor3 = Color3.fromRGB(230,230,230)
	Label.Parent = Holder

	local Toggle = Instance.new("TextButton")
	Toggle.Size = UDim2.new(0,60,0,26)
	Toggle.Position = UDim2.new(1,-70,0.5,-13)
	Toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
	Toggle.Text = "OFF"
	Toggle.Font = Enum.Font.GothamBold
	Toggle.TextSize = 14
	Toggle.TextColor3 = Color3.fromRGB(255,255,255)
	Toggle.Parent = Holder

	Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1,0)

	local enabled = false

	return Toggle, function()
		enabled = not enabled

		if enabled then
			Toggle.Text = "ON"
			TweenService:Create(
				Toggle,
				TweenInfo.new(0.2),
				{BackgroundColor3 = Color3.fromRGB(120,120,120)}
			):Play()
		else
			Toggle.Text = "OFF"
			TweenService:Create(
				Toggle,
				TweenInfo.new(0.2),
				{BackgroundColor3 = Color3.fromRGB(50,50,50)}
			):Play()
		end

		return enabled
	end
end

-- DARK TEXTURES
local DarkToggle, DarkSwitch = CreateToggle("Dark Textures", 55)

local originalColors = {}

local function setDarkTextures(state)
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") then

			-- Ignore tools/items/characters
			if obj.Parent:FindFirstChildOfClass("Humanoid")
			or obj.Parent:IsA("Tool") then
				continue
			end

			if not originalColors[obj] then
				originalColors[obj] = obj.Color
			end

			if state then
				local c = originalColors[obj]
				obj.Color = Color3.new(
					c.R * 0.45,
					c.G * 0.45,
					c.B * 0.45
				)
			else
				obj.Color = originalColors[obj]
			end
		end
	end
end

DarkToggle.MouseButton1Click:Connect(function()
	local state = DarkSwitch()
	setDarkTextures(state)
end)

-- GREY SKY
local SkyToggle, SkySwitch = CreateToggle("Grey Sky", 110)

local originalAmbient = Lighting.Ambient
local originalOutdoor = Lighting.OutdoorAmbient
local originalFog = Lighting.FogColor

local skybox = Lighting:FindFirstChildOfClass("Sky")

SkyToggle.MouseButton1Click:Connect(function()
	local state = SkySwitch()

	if state then
		Lighting.Ambient = Color3.fromRGB(156,133,131)
		Lighting.OutdoorAmbient = Color3.fromRGB(156,133,131)
		Lighting.FogColor = Color3.fromRGB(156,133,131)

		if skybox then
			skybox.Parent = nil
		end
	else
		Lighting.Ambient = originalAmbient
		Lighting.OutdoorAmbient = originalOutdoor
		Lighting.FogColor = originalFog

		if skybox and not skybox.Parent then
			skybox.Parent = Lighting
		end
	end
end)
