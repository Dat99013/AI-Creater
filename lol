-- Dat99013 Fly GUI V10 | Fly + Noclip | Joystick Control + Rainbow Theme
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- GUI
local main = Instance.new("ScreenGui")
main.Name = "FlyGUI"
main.Parent = player:WaitForChild("PlayerGui")
main.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(20,60,150)
Frame.BorderColor3 = Color3.fromRGB(15,45,120)
Frame.Position = UDim2.new(0.05,0,0.3,0)
Frame.Size = UDim2.new(0,220,0,100)
Frame.Active = true
Frame.Draggable = true

-- Title
local TextLabel = Instance.new("TextLabel")
TextLabel.Parent = Frame
TextLabel.Size = UDim2.new(1,0,0,28)
TextLabel.Position = UDim2.new(0,0,0,0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "FLY GUI V10"
TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
TextLabel.TextScaled = true
TextLabel.Font = Enum.Font.SourceSansBold

-- Fly toggle
local flyBtn = Instance.new("TextButton")
flyBtn.Parent = Frame
flyBtn.Size = UDim2.new(0,80,0,28)
flyBtn.Position = UDim2.new(0.05,0,0.35,0)
flyBtn.BackgroundColor3 = Color3.fromRGB(0,120,230)
flyBtn.TextColor3 = Color3.fromRGB(255,255,255)
flyBtn.Text = "Fly: OFF"
flyBtn.TextScaled = true
flyBtn.Font = Enum.Font.SourceSans

-- Noclip toggle
local noclipBtn = Instance.new("TextButton")
noclipBtn.Parent = Frame
noclipBtn.Size = UDim2.new(0,80,0,28)
noclipBtn.Position = UDim2.new(0.55,0,0.35,0)
noclipBtn.BackgroundColor3 = Color3.fromRGB(0,200,120)
noclipBtn.TextColor3 = Color3.fromRGB(255,255,255)
noclipBtn.Text = "Noclip: OFF"
noclipBtn.TextScaled = true
noclipBtn.Font = Enum.Font.SourceSans

-- Speed controls
local plus = Instance.new("TextButton")
plus.Parent = Frame
plus.Size = UDim2.new(0,40,0,28)
plus.Position = UDim2.new(0.7,0,0.65,0)
plus.BackgroundColor3 = Color3.fromRGB(0,180,255)
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(255,255,255)
plus.TextScaled = true
plus.Font = Enum.Font.SourceSans

local mine = Instance.new("TextButton")
mine.Parent = Frame
mine.Size = UDim2.new(0,40,0,28)
mine.Position = UDim2.new(0.85,0,0.65,0)
mine.BackgroundColor3 = Color3.fromRGB(0,180,255)
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(255,255,255)
mine.TextScaled = true
mine.Font = Enum.Font.SourceSans

local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = Frame
speedLabel.Size = UDim2.new(0,44,0,28)
speedLabel.Position = UDim2.new(0.55,0,0.65,0)
speedLabel.BackgroundColor3 = Color3.fromRGB(0,100,200)
speedLabel.TextColor3 = Color3.fromRGB(255,255,255)
speedLabel.Text = "1"
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.SourceSans

-- Minimize / Restore
local mini = Instance.new("TextButton")
mini.Parent = Frame
mini.Size = UDim2.new(0,28,0,28)
mini.Position = UDim2.new(0.9,0,0,0)
mini.BackgroundColor3 = Color3.fromRGB(0,0,100)
mini.Text = "-"
mini.TextColor3 = Color3.fromRGB(255,255,255)
mini.Font = Enum.Font.SourceSans
mini.TextScaled = true

local mini2 = Instance.new("TextButton")
mini2.Parent = Frame
mini2.Size = UDim2.new(0,28,0,28)
mini2.Position = UDim2.new(0.9,0,0,0)
mini2.BackgroundColor3 = Color3.fromRGB(0,0,100)
mini2.Text = "+"
mini2.TextColor3 = Color3.fromRGB(255,255,255)
mini2.Font = Enum.Font.SourceSans
mini2.TextScaled = true
mini2.Visible = false

-- ---------------- Fly & Noclip ----------------
local flying = false
local noclip = false
local speedVal = 1
speedLabel.Text = tostring(speedVal)

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = "Fly: "..(flying and "ON" or "OFF")
	hum.PlatformStand = flying
end)

noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = "Noclip: "..(noclip and "ON" or "OFF")
end)

plus.MouseButton1Click:Connect(function()
	speedVal = speedVal + 1
	speedLabel.Text = tostring(speedVal)
end)

mine.MouseButton1Click:Connect(function()
	if speedVal > 1 then
		speedVal = speedVal - 1
		speedLabel.Text = tostring(speedVal)
	end
end)

-- Rainbow Theme Helper
local function rainbowColor(tick, speed)
	local hue = tick * speed % 1
	return Color3.fromHSV(hue,1,1)
end

-- Fly with joystick & Noclip loop
RunService.Heartbeat:Connect(function(dt)
	if flying then
		local move = hum.MoveDirection
		if move.Magnitude > 0 then
			hrp.CFrame = hrp.CFrame + move.Unit * speedVal * dt * 50
		end
	end
	if noclip then
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
	-- Rainbow animation
	local tick = os.clock()
	Frame.BackgroundColor3 = rainbowColor(tick,0.1)
	TextLabel.TextColor3 = rainbowColor(tick,0.2)
	for _, btn in pairs(Frame:GetChildren()) do
		if btn:IsA("TextButton") then
			btn.BackgroundColor3 = rainbowColor(tick,0.15)
			btn.TextColor3 = Color3.fromRGB(0,0,0)
		end
	end
end)

-- Minimize / Restore
mini.MouseButton1Click:Connect(function()
	for i,v in pairs(Frame:GetChildren()) do
		if v:IsA("TextButton") or v:IsA("TextLabel") then
			if v ~= mini and v ~= mini2 then
				v.Visible = false
			end
		end
	end
	mini.Visible = false
	mini2.Visible = true
end)

mini2.MouseButton1Click:Connect(function()
	for i,v in pairs(Frame:GetChildren()) do
		if v:IsA("TextButton") or v:IsA("TextLabel") then
			v.Visible = true
		end
	end
	mini.Visible = true
	mini2.Visible = false
end)
