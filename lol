-- Dat99013 Menu — Glass Blue theme (draggable + hideable) with glow
-- Place this as a LocalScript in StarterPlayer -> StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Character refs (refreshed on respawn)
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
local hrp = character:FindFirstChild("HumanoidRootPart")

local function refreshCharacterRefs()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
    hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
end

-- States
local flying = false
local noclip = false
local invisible = false

-- Flight settings
local FLY_SPEED = 50
local VERTICAL_SPEED = 40
local velocity = Vector3.new()

-- ---------- UI ----------

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Dat99013MenuGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

-- Small Toggle button (bottom-right, always visible)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.new(0,66,0,66)
toggleBtn.Position = UDim2.new(1, -82, 1, -82) -- bottom-right with margin
toggleBtn.AnchorPoint = Vector2.new(0,0)
toggleBtn.BackgroundTransparency = 0
toggleBtn.BackgroundColor3 = Color3.fromRGB(8, 45, 88)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "Menu"
toggleBtn.TextScaled = true
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.Parent = screenGui
toggleBtn.ZIndex = 50
toggleBtn.AutoButtonColor = true
toggleBtn.ClipsDescendants = false

-- Add rounded corners and soft stroke (glow)
local toggleCorner = Instance.new("UICorner", toggleBtn)
toggleCorner.CornerRadius = UDim.new(0,12)
local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = Color3.fromRGB(235,245,255)
toggleStroke.Transparency = 0.65
toggleStroke.Thickness = 1.4

local toggleGradient = Instance.new("UIGradient", toggleBtn)
toggleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20,80,150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40,130,220))
}
toggleGradient.Rotation = 250
toggleGradient.Transparency = NumberSequence.new(0.15)

-- Main panel (glass blue)
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 260, 0, 240)
panel.Position = UDim2.new(1, -300, 1, -340) -- above toggle
panel.AnchorPoint = Vector2.new(0,0)
panel.BackgroundColor3 = Color3.fromRGB(6, 40, 85)
panel.BackgroundTransparency = 0.25
panel.BorderSizePixel = 0
panel.Parent = screenGui
panel.ZIndex = 49
panel.ClipsDescendants = false

-- Glass effect: gradient + subtle stroke + corner
local panelCorner = Instance.new("UICorner", panel)
panelCorner.CornerRadius = UDim.new(0,14)
local panelGradient = Instance.new("UIGradient", panel)
panelGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10,60,120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30,110,200))
}
panelGradient.Rotation = 90
panelGradient.Transparency = NumberSequence.new(0.45, 0.15)
local panelStroke = Instance.new("UIStroke", panel)
panelStroke.Color = Color3.fromRGB(220,240,255)
panelStroke.Transparency = 0.85
panelStroke.Thickness = 1

-- Title
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, -20, 0, 38)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Dat99013 Menu"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

local subtitle = Instance.new("TextLabel", panel)
subtitle.Size = UDim2.new(1, -20, 0, 18)
subtitle.Position = UDim2.new(0,10,0,44)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Drag to move • Tap title to hide"
subtitle.TextColor3 = Color3.fromRGB(220,230,240)
subtitle.Font = Enum.Font.SourceSans
subtitle.TextSize = 14
subtitle.TextXAlignment = Enum.TextXAlignment.Left

-- Buttons container
local buttonsFrame = Instance.new("Frame", panel)
buttonsFrame.Size = UDim2.new(1, -20, 0, 140)
buttonsFrame.Position = UDim2.new(0, 10, 0, 66)
buttonsFrame.BackgroundTransparency = 1

local function makeToggleButton(name, y)
    local b = Instance.new("TextButton", buttonsFrame)
    b.Name = name .. "Btn"
    b.Size = UDim2.new(1, 0, 0, 44)
    b.Position = UDim2.new(0, 0, 0, y)
    b.BackgroundTransparency = 0
    b.BackgroundColor3 = Color3.fromRGB(12, 60, 115)
    b.BorderSizePixel = 0
    b.Text = name .. " (OFF)"
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.TextScaled = true
    b.Font = Enum.Font.SourceSansSemibold
    b.AutoButtonColor = true

    -- glass-ish gradient
    local g = Instance.new("UIGradient", b)
    g.Transparency = NumberSequence.new(0.1, 0)
    g.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 90, 170)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40,130,220))
    }
    g.Rotation = 90

    -- rounded corners and glow stroke
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0,10)
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(235,245,255)
    s.Transparency = 0.7
    s.Thickness = 1.6

    return b
end

local flyBtn = makeToggleButton("Fly", 0)
local noclipBtn = makeToggleButton("Noclip", 50)
local invisBtn = makeToggleButton("Invisible", 100)

-- Movement helper buttons (appear only while flying)
local movementFrame = Instance.new("Frame", panel)
movementFrame.Size = UDim2.new(1, -20, 0, 36)
movementFrame.Position = UDim2.new(0,10,0,214-36)
movementFrame.BackgroundTransparency = 1
movementFrame.Visible = false

local function makeSmallBtn(label, xScale)
    local b = Instance.new("TextButton", movementFrame)
    b.Size = UDim2.new(0.22, 0, 1, 0)
    b.AnchorPoint = Vector2.new(0.5, 0.5)
    b.Position = UDim2.new(xScale, 0, 0.5, 0)
    b.BackgroundColor3 = Color3.fromRGB(14, 55, 105)
    b.BorderSizePixel = 0
    b.Text = label
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.TextScaled = true
    b.Font = Enum.Font.SourceSansBold
    b.AutoButtonColor = true

    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0,8)
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(240,250,255)
    s.Transparency = 0.75
    s.Thickness = 1.1
    return b
end

local forwardBtn = makeSmallBtn("↑", 0.2)
local backBtn    = makeSmallBtn("↓", 0.5)
local upBtn      = makeSmallBtn("U", 0.8)
local downBtn    = makeSmallBtn("D", 0.95)

-- ---------- Dragging logic (mouse & touch) ----------
local dragging = false
local dragInput, dragStartPos, startPos

local function updatePanelPosition(input)
    local delta = input.Position - dragStartPos
    panel.Position = UDim2.new(
        math.clamp(startPos.X.Scale, 0, 1),
        math.clamp(startPos.X.Offset + delta.X, -2000, 2000),
        math.clamp(startPos.Y.Scale, 0, 1),
        math.clamp(startPos.Y.Offset + delta.Y, -2000, 2000)
    )
end

local function beginDrag(input)
    dragging = true
    dragInput = input
    dragStartPos = input.Position
    startPos = panel.Position

    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
    end)
end

-- Start drag when user presses panel area (title/subtitle are children; capture parent)
panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        beginDrag(input)
    end
end)

panel.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updatePanelPosition(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updatePanelPosition(input)
    end
end)

-- ---------- Toggle show/hide ----------
local panelVisible = true
toggleBtn.MouseButton1Click:Connect(function()
    panelVisible = not panelVisible
    panel.Visible = panelVisible
    toggleBtn.Text = panelVisible and "Menu" or "Show"
end)

-- Tap title to hide/show quickly
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        panelVisible = not panelVisible
        panel.Visible = panelVisible
        toggleBtn.Text = panelVisible and "Menu" or "Show"
    end
end)

-- ---------- Functionality ----------
local function applyNoclip(state)
    noclip = state
    noclipBtn.Text = "Noclip (" .. (state and "ON" or "OFF") .. ")"
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function()
                    part.CanCollide = not state and true or false
                end)
            end
        end
    end
end

local function applyInvisible(state)
    invisible = state
    invisBtn.Text = "Invisible (" .. (state and "ON" or "OFF") .. ")"
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function()
                    -- LocalTransparencyModifier = local-only invis (safe for client-only)
                    part.LocalTransparencyModifier = state and 1 or 0
                end)
                pcall(function()
                    if state then part.CanCollide = false end
                end)
            elseif part:IsA("Decal") then
                pcall(function() part.Transparency = state and 1 or 0 end)
            end
        end
    end
end

local function applyFly(state)
    flying = state
    flyBtn.Text = "Fly (" .. (state and "ON" or "OFF") .. ")"
    if humanoid then
        pcall(function() humanoid.PlatformStand = state end)
    end
    movementFrame.Visible = state
    if not state then velocity = Vector3.new() end
end

-- Button connections
flyBtn.MouseButton1Click:Connect(function() applyFly(not flying) end)
noclipBtn.MouseButton1Click:Connect(function() applyNoclip(not noclip) end)
invisBtn.MouseButton1Click:Connect(function() applyInvisible(not invisible) end)

-- Movement helper behavior (press & hold)
local holdForward, holdBack, holdUp, holdDown = false, false, false, false

local function bindHold(button, setter)
    button.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            setter(true)
        end
    end)
    button.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            setter(false)
        end
    end)
end

bindHold(forwardBtn, function(v) holdForward = v end)
bindHold(backBtn,    function(v) holdBack    = v end)
bindHold(upBtn,      function(v) holdUp      = v end)
bindHold(downBtn,    function(v) holdDown    = v end)

-- Keyboard support for PC
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local k = input.KeyCode
        if k == Enum.KeyCode.W then holdForward = true end
        if k == Enum.KeyCode.S then holdBack = true end
        if k == Enum.KeyCode.Space then holdUp = true end
        if k == Enum.KeyCode.LeftShift then holdDown = true end
        -- quick toggles
        if k == Enum.KeyCode.F then applyFly(not flying) end
        if k == Enum.KeyCode.N then applyNoclip(not noclip) end
        if k == Enum.KeyCode.G then applyInvisible(not invisible) end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local k = input.KeyCode
        if k == Enum.KeyCode.W then holdForward = false end
        if k == Enum.KeyCode.S then holdBack = false end
        if k == Enum.KeyCode.Space then holdUp = false end
        if k == Enum.KeyCode.LeftShift then holdDown = false end
    end
end)

-- ---------- Heartbeat: enforce noclip/invis and apply fly ----------
RunService.Heartbeat:Connect(function(dt)
    if not character or not character.Parent then
        refreshCharacterRefs()
        if noclip then applyNoclip(true) end
        if invisible then applyInvisible(true) end
        if flying then applyFly(true) end
    end

    if noclip and character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part.CanCollide = false end)
            end
        end
    end

    if flying and hrp and humanoid and hrp.Parent then
        local cam = workspace.CurrentCamera
        local camCF = cam and cam.CFrame or CFrame.new()
        local forward = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z)
        if forward.Magnitude > 0 then forward = forward.Unit end
        local right = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z)
        if right.Magnitude > 0 then right = right.Unit end

        local moveDir = Vector3.new(0,0,0)
        if holdForward then moveDir = moveDir + forward end
        if holdBack then moveDir = moveDir - forward end

        local vy = 0
        if holdUp then vy = vy + 1 end
        if holdDown then vy = vy - 1 end

        local desired = moveDir * FLY_SPEED + Vector3.new(0, vy * VERTICAL_SPEED, 0)
        velocity = desired
        hrp.CFrame = hrp.CFrame + velocity * dt
    end
end)

-- Cleanup on leaving (restore defaults where possible)
local function cleanup()
    if humanoid then pcall(function() humanoid.PlatformStand = false end) end
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part.LocalTransparencyModifier = 0 end)
                pcall(function() part.CanCollide = true end)
            elseif part:IsA("Decal") then
                pcall(function() part.Transparency = 0 end)
            end
        end
    end
end

-- Restore on respawn
player.CharacterAdded:Connect(function()
    wait(0.5)
    refreshCharacterRefs()
    if noclip then applyNoclip(true) end
    if invisible then applyInvisible(true) end
    if flying then applyFly(true) end
end)

game:BindToClose(function() cleanup() end)

-- ensure visible initially
panel.Visible = true
toggleBtn.Text = "Menu"
