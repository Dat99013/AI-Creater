-- Dat99013 Fly GUI V5 | Blue Theme & White Font | Fly + Noclip
-- Place in StarterPlayer -> StarterPlayerScripts

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
Frame.BackgroundColor3 = Color3.fromRGB(20, 60, 150)
Frame.BorderColor3 = Color3.fromRGB(15, 45, 120)
Frame.Position = UDim2.new(0.1,0,0.4,0)
Frame.Size = UDim2.new(0, 220, 0, 60)
Frame.Active = true
Frame.Draggable = true

-- Title
local TextLabel = Instance.new("TextLabel")
TextLabel.Parent = Frame
TextLabel.Size = UDim2.new(1,0,0,28)
TextLabel.Position = UDim2.new(0,0,0,0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "FLY GUI V5"
TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
TextLabel.TextScaled = true
TextLabel.Font = Enum.Font.SourceSansBold

-- Fly toggle
local onof = Instance.new("TextButton")
onof.Parent = Frame
onof.Size = UDim2.new(0, 60, 0, 28)
onof.Position = UDim2.new(0.6, 0, 0.5, 0)
onof.BackgroundColor3 = Color3.fromRGB(0, 120, 230)
onof.TextColor3 = Color3.fromRGB(255,255,255)
onof.Text = "Fly: OFF"
onof.Font = Enum.Font.SourceSans
onof.TextScaled = true

-- Noclip toggle
local noclipBtn = Instance.new("TextButton")
noclipBtn.Parent = Frame
noclipBtn.Size = UDim2.new(0, 60, 0, 28)
noclipBtn.Position = UDim2.new(0.8, 0, 0.5, 0)
noclipBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
noclipBtn.TextColor3 = Color3.fromRGB(255,255,255)
noclipBtn.Text = "Noclip: OFF"
noclipBtn.Font = Enum.Font.SourceSans
noclipBtn.TextScaled = true

-- Up / Down buttons
local up = Instance.new("TextButton")
up.Parent = Frame
up.Size = UDim2.new(0, 44, 0, 28)
up.Position = UDim2.new(0,0,0.5,0)
up.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
up.Text = "UP"
up.TextColor3 = Color3.fromRGB(255,255,255)
up.Font = Enum.Font.SourceSans
up.TextScaled = true

local down = Instance.new("TextButton")
down.Parent = Frame
down.Size = UDim2.new(0, 44, 0, 28)
down.Position = UDim2.new(0.25,0,0.5,0)
down.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(255,255,255)
down.Font = Enum.Font.SourceSans
down.TextScaled = true

-- Speed
local plus = Instance.new("TextButton")
plus.Parent = Frame
plus.Size = UDim2.new(0, 40,0,28)
plus.Position = UDim2.new(0.25,0,0,0)
plus.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(255,255,255)
plus.Font = Enum.Font.SourceSans
plus.TextScaled = true

local mine = Instance.new("TextButton")
mine.Parent = Frame
mine.Size = UDim2.new(0, 40,0,28)
mine.Position = UDim2.new(0,0,0,0)
mine.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(255,255,255)
mine.Font = Enum.Font.SourceSans
mine.TextScaled = true

local speed = Instance.new("TextLabel")
speed.Parent = Frame
speed.Size = UDim2.new(0, 44,0,28)
speed.Position = UDim2.new(0.5,0,0,0)
speed.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
speed.TextColor3 = Color3.fromRGB(255,255,255)
speed.Text = "1"
speed.TextScaled = true
speed.Font = Enum.Font.SourceSans

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

-- ---------------- Fly & Noclip Logic ----------------
local flying = false
local noclip = false
local speedVal = 1
local flyUp, flyDown = false, false

speed.Text = tostring(speedVal)

onof.MouseButton1Click:Connect(function()
	flying = not flying
	onof.Text = "Fly: "..(flying and "ON" or "OFF")
	hum.PlatformStand = flying
end)

noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = "Noclip: "..(noclip and "ON" or "OFF")
end)

plus.MouseButton1Click:Connect(function()
	speedVal = speedVal + 1
	speed.Text = tostring(speedVal)
end)

mine.MouseButton1Click:Connect(function()
	if speedVal > 1 then
		speedVal = speedVal - 1
		speed.Text = tostring(speedVal)
	end
end)

up.MouseButton1Click:Connect(function()
	flyUp = true
end)
up.MouseButton1Release:Connect(function()
	flyUp = false
end)

down.MouseButton1Click:Connect(function()
	flyDown = true
end)
down.MouseButton1Release:Connect(function()
	flyDown = false
end)

-- Heartbeat fly/noclip
RunService.Heartbeat:Connect(function(dt)
	if flying then
		local move = Vector3.new()
		if flyUp then move = move + Vector3.new(0,1,0) end
		if flyDown then move = move + Vector3.new(0,-1,0) end
		hrp.CFrame = hrp.CFrame + move * speedVal * dt * 50
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
