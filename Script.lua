--// HAZEYWARE - Rivals Visual GUI
--// Dark Textures + Grey Sky + Minimize

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

-- Main GUI
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 270, 0, 190)
Main.Position = UDim2.new(0.5, -135, 0.5, -95)
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
Title.TextColor3 = Color3.fromRGB(230,230,230)
Title.Parent = Main

-- Minimize Button
local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0,30,0,30)
Minimize.Position = UDim2.new(1,-70,0,5)
Minimize.BackgroundColor3 = Color3.fromRGB(60,60,60)
Minimize.Text = "-"
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 20
Minimize.TextColor3 = Color3.fromRGB(255,255,255)
Minimize.Parent = Main

Instance.new("UICorner", Minimize).CornerRadius = UDim.new(1,0)

-- Close Button
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0,30,0,30)
Close.Position = UDim2.new(1,-35,0,5)
Close.BackgroundColor3 = Color3.fromRGB(120,40,40)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.Parent = Main

Instance.new("UICorner", Close).CornerRadius = UDim.new(1,0)

-- Compact Button
local Compact = Instance.new("TextButton")
Compact.Size = UDim2.new(0,70,0,70)
Compact.Position = UDim2.new(0.5,-35,0.5,-35)
Compact.BackgroundColor3 = Color3.fromRGB(25,25,25)
Compact.Visible = false
Compact.Text = "HAZEY"
Compact.Font = Enum.Font.GothamBold
Compact.TextSize = 16
Compact.TextColor3 = Color3.fromRGB(255,255,255)
Compact.Parent = ScreenGui

Instance.new("UICorner", Compact).CornerRadius = UDim.new(0,18)

local CompactStroke = Instance.new("UIStroke")
CompactStroke.Color = Color3.fromRGB(120,120,120)
CompactStroke.Parent = Compact

-- Dragging Function
local function makeDraggable(frame, dragArea)
	local dragging = false
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	dragArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	dragArea.InputChanged:Connect(function(input)
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
end

makeDraggable(Main, Title)
makeDraggable(Compact, Compact)

-- Toggle Creator
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
			Toggle.BackgroundColor3 = Color3.fromRGB(120,120,120)
		else
			Toggle.Text = "OFF"
			Toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
		end

		return enabled
	end
end

-- DARK TEXTURES
local DarkToggle, DarkSwitch = CreateToggle("Dark Textures", 55)

local originalColors = {}
local darkEnabled = false

local function setDarkTextures(state)
	darkEnabled = state

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") then

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
					math.clamp(c.R * 0.45, 0, 1),
					math.clamp(c.G * 0.45, 0, 1),
					math.clamp(c.B * 0.45, 0, 1)
				)
			else
				obj.Color = originalColors[obj]
			end
		end
	end
end

DarkToggle.MouseButton1Click:Connect(function()
	setDarkTextures(DarkSwitch())
end)

-- GREY SKY
local SkyToggle, SkySwitch = CreateToggle("Grey Sky", 110)

local originalBrightness = Lighting.Brightness
local originalAmbient = Lighting.Ambient
local originalOutdoor = Lighting.OutdoorAmbient
local originalClock = Lighting.ClockTime
local originalFog = Lighting.FogColor

local skyEnabled = false

local function setGreySky(state)
	skyEnabled = state

	if state then
		local grey = Color3.fromRGB(156,133,131)

		Lighting.Ambient = grey
		Lighting.OutdoorAmbient = grey
		Lighting.FogColor = grey
		Lighting.ColorShift_Top = grey
		Lighting.ColorShift_Bottom = grey
		Lighting.ClockTime = 14
		Lighting.Brightness = 1

		-- Force remove all skyboxes
		for _, v in ipairs(Lighting:GetChildren()) do
			if v:IsA("Sky") then
				v.Parent = nil
			end
		end

	else
		Lighting.Brightness = originalBrightness
		Lighting.Ambient = originalAmbient
		Lighting.OutdoorAmbient = originalOutdoor
		Lighting.ClockTime = originalClock
		Lighting.FogColor = originalFog
		Lighting.ColorShift_Top = Color3.new(0,0,0)
		Lighting.ColorShift_Bottom = Color3.new(0,0,0)
	end
end

SkyToggle.MouseButton1Click:Connect(function()
	setGreySky(SkySwitch())
end)

-- MINIMIZE
Minimize.MouseButton1Click:Connect(function()
	Main.Visible = false
	Compact.Visible = true
end)

Compact.MouseButton1Click:Connect(function()
	Main.Visible = true
	Compact.Visible = false
end)

-- CLOSE
Close.MouseButton1Click:Connect(function()

	-- Restore textures
	setDarkTextures(false)

	-- Restore lighting
	setGreySky(false)

	ScreenGui:Destroy()
end)
