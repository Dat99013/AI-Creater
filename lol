-- Dat99013 Menu | Cleaned-up | No Mobile Buttons
-- Place in StarterPlayer -> StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Character refs
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
local hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")

local function refreshCharacterRefs()
	character = player.Character or player.CharacterAdded:Wait()
	humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
	hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
end

-- States
local flying, noclip, invisible = false, false, false
local FLY_SPEED, VERTICAL_SPEED = 50, 40
local velocity = Vector3.new()

-- ---------------- ScreenGui ----------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Dat99013MenuGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ---------------- Toggle Button ----------------
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.new(0,60,0,60)
toggleBtn.Position = UDim2.new(1,-80,1,-80)
toggleBtn.AnchorPoint = Vector2.new(0,0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(8,45,88)
toggleBtn.Text = "Menu"
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Parent = screenGui
toggleBtn.ZIndex = 50

local toggleCorner = Instance.new("UICorner", toggleBtn)
toggleCorner.CornerRadius = UDim.new(0,12)
local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = Color3.fromRGB(235,245,255)
toggleStroke.Transparency = 0.65
toggleStroke.Thickness = 1.4
local toggleGradient = Instance.new("UIGradient", toggleBtn)
toggleGradient.Color = ColorSequence.new(Color3.fromRGB(20,80,150), Color3.fromRGB(40,130,220))
toggleGradient.Rotation = 250
toggleGradient.Transparency = NumberSequence.new(0.15)

-- ---------------- Main Menu ----------------
local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.Size = UDim2.new(0,220,0,200)
panel.Position = UDim2.new(1,-280,1,-300)
panel.AnchorPoint = Vector2.new(0,0)
panel.BackgroundColor3 = Color3.fromRGB(6,40,85)
panel.BackgroundTransparency = 0.25
panel.BorderSizePixel = 0
panel.Parent = screenGui
panel.ZIndex = 49

local panelCorner = Instance.new("UICorner", panel)
panelCorner.CornerRadius = UDim.new(0,12)
local panelStroke = Instance.new("UIStroke", panel)
panelStroke.Color = Color3.fromRGB(220,240,255)
panelStroke.Transparency = 0.85
panelStroke.Thickness = 1
local panelGradient = Instance.new("UIGradient", panel)
panelGradient.Color = ColorSequence.new(Color3.fromRGB(10,60,120), Color3.fromRGB(30,110,200))
panelGradient.Rotation = 90
panelGradient.Transparency = NumberSequence.new(0.4,0.15)

-- Title
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1,-20,0,36)
title.Position = UDim2.new(0,10,0,6)
title.BackgroundTransparency = 1
title.Text = "Dat99013 Menu"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

local subtitle = Instance.new("TextLabel", panel)
subtitle.Size = UDim2.new(1,-20,0,16)
subtitle.Position = UDim2.new(0,10,0,40)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Drag to move • Tap title to hide"
subtitle.TextColor3 = Color3.fromRGB(220,230,240)
subtitle.Font = Enum.Font.SourceSans
subtitle.TextSize = 12
subtitle.TextXAlignment = Enum.TextXAlignment.Left

-- Buttons container
local buttonsFrame = Instance.new("Frame", panel)
buttonsFrame.Size = UDim2.new(1,-20,0,140)
buttonsFrame.Position = UDim2.new(0,10,0,60)
buttonsFrame.BackgroundTransparency = 1

-- Helper to create toggle buttons
local function makeToggleButton(name, y)
	local b = Instance.new("TextButton", buttonsFrame)
	b.Size = UDim2.new(1,0,0,40)
	b.Position = UDim2.new(0,0,0,y)
	b.BackgroundColor3 = Color3.fromRGB(12,60,115)
	b.BorderSizePixel = 0
	b.Text = name.." (OFF)"
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.TextScaled = true
	b.Font = Enum.Font.SourceSansSemibold
	b.AutoButtonColor = true
	local c = Instance.new("UICorner", b)
	c.CornerRadius = UDim.new(0,8)
	local s = Instance.new("UIStroke", b)
	s.Color = Color3.fromRGB(235,245,255)
	s.Transparency = 0.7
	s.Thickness = 1.4
	return b
end

local flyBtn = makeToggleButton("Fly",0)
local noclipBtn = makeToggleButton("Noclip",50)
local invisBtn = makeToggleButton("Invisible",100)

-- ---------------- Drag & Snap Helper ----------------
local function makeDraggable(frame,snapPadding)
	local dragging, dragInput, dragStartPos, startPos = false,nil,Vector2.new(),UDim2.new()
	frame.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
			dragging=true; dragInput=input; dragStartPos=input.Position; startPos=frame.Position
			input.Changed:Connect(function()
				if input.UserInputState==Enum.UserInputState.End then
					dragging=false
					local xOffset = frame.Position.X.Offset
					local yOffset = frame.Position.Y.Offset
					local screen = workspace.CurrentCamera.ViewportSize
					if xOffset + frame.Size.X.Offset/2 < screen.X/2 then xOffset = snapPadding else xOffset = screen.X - frame.Size.X.Offset - snapPadding end
					if yOffset < snapPadding then yOffset = snapPadding elseif yOffset + frame.Size.Y.Offset > screen.Y - snapPadding then yOffset = screen.Y - frame.Size.Y.Offset - snapPadding end
					frame.Position = UDim2.new(0,xOffset,0,yOffset)
				end
			end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input==dragInput and dragging then
			local delta = input.Position - dragStartPos
			frame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input==dragInput and dragging then
			local delta = input.Position - dragStartPos
			frame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
		end
	end)
end

makeDraggable(panel,8)
makeDraggable(toggleBtn,8)

-- ---------------- Hide/Show ----------------
local panelVisible=true
toggleBtn.MouseButton1Click:Connect(function()
	panelVisible=not panelVisible
	panel.Visible=panelVisible
	toggleBtn.Text = panelVisible and "Menu" or "Show"
end)
title.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
		panelVisible=not panelVisible
		panel.Visible=panelVisible
		toggleBtn.Text = panelVisible and "Menu" or "Show"
	end
end)

-- ---------------- Functionality ----------------
local function applyNoclip(state)
	noclip=state
	noclipBtn.Text="Noclip ("..(state and "ON" or "OFF")..")"
	if character then
		for _,p in ipairs(character:GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide = not state end
		end
	end
end

local function applyInvisible(state)
	invisible=state
	invisBtn.Text="Invisible ("..(state and "ON" or "OFF")..")"
	if character then
		for _,p in ipairs(character:GetDescendants()) do
			if p:IsA("BasePart") then p.LocalTransparencyModifier = state and 1 or 0 end
			if p:IsA("Decal") then p.Transparency = state and 1 or 0 end
		end
	end
end

local function applyFly(state)
	flying=state
	flyBtn.Text="Fly ("..(state and "ON" or "OFF")..")"
	if humanoid then pcall(function() humanoid.PlatformStand=state end) end
	if not state then velocity=Vector3.new() end
end

-- ---------------- Button Events ----------------
flyBtn.MouseButton1Click:Connect(function() applyFly(not flying) end)
noclipBtn.MouseButton1Click:Connect(function() applyNoclip(not noclip) end)
invisBtn.MouseButton1Click:Connect(function() applyInvisible(not invisible) end)

-- ---------------- Keyboard support ----------------
local holdForward,holdBack,holdUp,holdDown=false,false,false,false
UserInputService.InputBegan:Connect(function(input,processed)
	if processed then return end
	if input.UserInputType==Enum.UserInputType.Keyboard then
		local k=input.KeyCode
		if k==Enum.KeyCode.W then holdForward=true end
		if k==Enum.KeyCode.S then holdBack=true end
		if k==Enum.KeyCode.Space then holdUp=true end
		if k==Enum.KeyCode.LeftShift then holdDown=true end
		if k==Enum.KeyCode.F then applyFly(not flying) end
		if k==Enum.KeyCode.N then applyNoclip(not noclip) end
		if k==Enum.KeyCode.G then applyInvisible(not invisible) end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.Keyboard then
		local k=input.KeyCode
		if k==Enum.KeyCode.W then holdForward=false end
		if k==Enum.KeyCode.S then holdBack=false end
		if k==Enum.KeyCode.Space then holdUp=false end
		if k==Enum.KeyCode.LeftShift then holdDown=false end
	end
end)

-- ---------------- Heartbeat ----------------
RunService.Heartbeat:Connect(function(dt)
	if not character or not character.Parent then
		refreshCharacterRefs()
		if noclip then applyNoclip(true) end
		if invisible then applyInvisible(true) end
		if flying then applyFly(true) end
	end

	if noclip and character then
		for _,p in ipairs(character:GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide=false end
		end
	end

	if flying and hrp and humanoid and hrp.Parent then
		local cam = workspace.CurrentCamera
		local camCF = cam and cam.CFrame or CFrame.new()
		local forward = Vector3.new(camCF.LookVector.X,0,camCF.LookVector.Z)
		if forward.Magnitude>0 then forward=forward.Unit end
		local moveDir = Vector3.new()
		if holdForward then moveDir = moveDir + forward end
		if holdBack then moveDir = moveDir - forward end
		local vy=0
		if holdUp then vy=vy+1 end
		if holdDown then vy=vy-1 end
		local desired = moveDir*FLY_SPEED + Vector3.new(0,vy*VERTICAL_SPEED,0)
		velocity = desired
		hrp.CFrame = hrp.CFrame + velocity*dt
	end
end)

-- ---------------- Respawn / Cleanup ----------------
player.CharacterAdded:Connect(function()
	wait(0.5)
	refreshCharacterRefs()
	if noclip then applyNoclip(true) end
	if invisible then applyInvisible(true) end
	if flying then applyFly(true) end
end)
