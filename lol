-- Dat99013 Fly GUI V11 | Fly + Noclip | Joystick + Rainbow + No Gravity
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- GUI setup (Frame, buttons, labels) - rainbow theme
local main = Instance.new("ScreenGui")
main.Name = "FlyGUI"
main.Parent = player:WaitForChild("PlayerGui")
main.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Parent = main
Frame.Position = UDim2.new(0.05,0,0.3,0)
Frame.Size = UDim2.new(0,220,0,100)
Frame.Active = true
Frame.Draggable = true

local TextLabel = Instance.new("TextLabel")
TextLabel.Parent = Frame
TextLabel.Size = UDim2.new(1,0,0,28)
TextLabel.Position = UDim2.new(0,0,0,0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "FLY GUI V11"
TextLabel.TextScaled = true
TextLabel.Font = Enum.Font.SourceSansBold

-- Buttons
local function createButton(name,pos,text)
	local btn = Instance.new("TextButton")
	btn.Parent = Frame
	btn.Size = UDim2.new(0,80,0,28)
	btn.Position = pos
	btn.Text = text
	btn.TextScaled = true
	btn.Font = Enum.Font.SourceSans
	btn.TextColor3 = Color3.fromRGB(0,0,0)
	return btn
end

local flyBtn = createButton("Fly", UDim2.new(0.05,0,0.35,0), "Fly: OFF")
local noclipBtn = createButton("Noclip", UDim2.new(0.55,0,0.35,0), "Noclip: OFF")
local plus = createButton("Plus", UDim2.new(0.7,0,0.65,0), "+")
local mine = createButton("Minus", UDim2.new(0.85,0,0.65,0), "-")
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = Frame
speedLabel.Size = UDim2.new(0,44,0,28)
speedLabel.Position = UDim2.new(0.55,0,0.65,0)
speedLabel.BackgroundColor3 = Color3.fromRGB(0,100,200)
speedLabel.TextColor3 = Color3.fromRGB(255,255,255)
speedLabel.Text = "1"
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.SourceSans

-- Minimize buttons
local mini = Instance.new("TextButton")
mini.Parent = Frame
mini.Size = UDim2.new(0,28,0,28)
mini.Position = UDim2.new(0.9,0,0,0)
mini.Text = "-"
mini.TextScaled = true
local mini2 = mini:Clone()
mini2.Text = "+"
mini2.Position = UDim2.new(0.9,0,0,0)
mini2.Visible = false
mini2.Parent = Frame

-- Fly logic
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
local function rainbowColor(tick,speed)
	local hue = tick*speed % 1
	return Color3.fromHSV(hue,1,1)
end

-- Fly/Noclip/No Gravity loop
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e5,1e5,1e5)
bv.Velocity = Vector3.new(0,0,0)
bv.Parent = hrp

RunService.Heartbeat:Connect(function(dt)
	local tick = os.clock()
	-- Rainbow animation
	Frame.BackgroundColor3 = rainbowColor(tick,0.1)
	TextLabel.TextColor3 = rainbowColor(tick,0.2)
	for _, btn in pairs(Frame:GetChildren()) do
		if btn:IsA("TextButton") then
			btn.BackgroundColor3 = rainbowColor(tick,0.15)
		end
	end

	if flying then
		local move = hum.MoveDirection
		bv.Velocity = move.Unit * speedVal * 50 -- joystick-controlled flying
	else
		bv.Velocity = Vector3.new(0,0,0)
	end

	if noclip then
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
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
