local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- ===== Admin config =====
local Admins = {
    2858006390
}
local function isAdmin(userId)
    for _, id in ipairs(Admins) do
        if id == userId then return true end
    end
    return false
end

if not isAdmin(player.UserId) then
    return -- not an admin: stop the script
end
-- ========================

-- ===== Helpers =====
local function applyRounded(uiElement, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = uiElement
end

local function makeShadow(parent, size, pos)
    local shadow = Instance.new("Frame")
    shadow.Size = size or UDim2.new(1, 6, 1, 6)
    shadow.Position = pos or UDim2.new(0, 3, 0, 3)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.85
    shadow.ZIndex = 0
    shadow.Parent = parent
    applyRounded(shadow, 18)
    return shadow
end

-- ===== ScreenGui =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- ===== Toggle Button =====
local toggleBGShadow = makeShadow(screenGui, UDim2.new(0, 120, 0, 48), UDim2.new(0, 18, 0, 18))
local toggleBG = Instance.new("Frame")
toggleBG.Size = UDim2.new(0, 120, 0, 48)
toggleBG.Position = UDim2.new(0, 12, 0, 12)
toggleBG.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggleBG.ZIndex = 2
toggleBG.Parent = screenGui
applyRounded(toggleBG, 14)

local toggleText = Instance.new("TextLabel")
toggleText.Size = UDim2.new(1, 0, 1, 0)
toggleText.BackgroundTransparency = 1
toggleText.Font = Enum.Font.GothamBold
toggleText.TextSize = 16
toggleText.TextColor3 = Color3.fromRGB(28,28,28)
toggleText.Text = "Hide Menu"
toggleText.Parent = toggleBG
toggleText.ZIndex = 3

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 48)
toggleButton.Position = UDim2.new(0, 12, 0, 12)
toggleButton.BackgroundTransparency = 1
toggleButton.Text = ""
toggleButton.ZIndex = 4
toggleButton.Parent = screenGui

-- ===== Main Frame =====
local mainShadow = makeShadow(screenGui, UDim2.new(0, 320, 0, 420), UDim2.new(0, 18, 0, 78))
mainShadow.ZIndex = 1

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 420)
mainFrame.Position = UDim2.new(0, 12, 0, 78)
mainFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
mainFrame.ZIndex = 2
mainFrame.Parent = screenGui
applyRounded(mainFrame, 16)
mainFrame.ClipsDescendants = true

-- Header (drag handle)
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 60)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundTransparency = 1
header.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -24, 1, 0)
title.Position = UDim2.new(0, 12, 0, 12)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(28,28,28)
title.Text = "Teleport Menu"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Close/hide small icon (also clickable)
local smallToggle = Instance.new("TextButton")
smallToggle.Size = UDim2.new(0, 32, 0, 32)
smallToggle.Position = UDim2.new(1, -44, 0, 14)
smallToggle.BackgroundTransparency = 1
smallToggle.Font = Enum.Font.Gotham
smallToggle.TextSize = 18
smallToggle.Text = "✕"
smallToggle.TextColor3 = Color3.fromRGB(120,120,120)
smallToggle.Parent = header
smallToggle.ZIndex = 4

-- Divider
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -24, 0, 1)
divider.Position = UDim2.new(0, 12, 0, 60)
divider.BackgroundColor3 = Color3.fromRGB(240,240,240)
divider.Parent = mainFrame

-- Search box
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -132, 0, 44)
searchBox.Position = UDim2.new(0, 12, 0, 74)
searchBox.PlaceholderText = "Search players..."
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 16
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(28,28,28)
searchBox.BackgroundColor3 = Color3.fromRGB(248,248,248)
searchBox.Parent = mainFrame
applyRounded(searchBox, 12)
searchBox.ZIndex = 3

-- Refresh button
local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0, 92, 0, 44)
refreshBtn.Position = UDim2.new(1, -104, 0, 74)
refreshBtn.Text = "Refresh"
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 15
refreshBtn.TextColor3 = Color3.fromRGB(28,28,28)
refreshBtn.BackgroundColor3 = Color3.fromRGB(250,250,250)
refreshBtn.Parent = mainFrame
applyRounded(refreshBtn, 12)
refreshBtn.ZIndex = 3

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -24, 0, 36)
statusLabel.Position = UDim2.new(0, 12, 1, -48)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.TextColor3 = Color3.fromRGB(110,110,110)
statusLabel.Text = "Tap a player to teleport"
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame
statusLabel.ZIndex = 3

-- Scrolling list
local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(1, -24, 0, 250)
listFrame.Position = UDim2.new(0, 12, 0, 128)
listFrame.BackgroundTransparency = 1
listFrame.ScrollBarThickness = 6
listFrame.Parent = mainFrame
listFrame.ZIndex = 3

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0, 8)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = listFrame

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 6)
uiPadding.PaddingLeft = UDim.new(0, 6)
uiPadding.PaddingRight = UDim.new(0, 6)
uiPadding.PaddingBottom = UDim.new(0, 6)
uiPadding.Parent = listFrame

-- Template size for each player entry (used for layout consistency)
local ENTRY_HEIGHT = 64

-- ===== Dragging logic (works for mouse & touch) =====
local dragging = false
local dragStart = Vector2.new()
local startPos = Vector2.new()

local function beginDrag(input)
    dragging = true
    dragStart = input.Position
    local absPos = mainFrame.AbsolutePosition
    startPos = Vector2.new(absPos.X, absPos.Y)
    UserInputService.InputChanged:Connect(function(move)
        if dragging and move.UserInputType == input.UserInputType then
            local delta = move.Position - dragStart
            local newPos = startPos + delta
            -- keep onscreen bounds (optional clamp)
            local screenSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920,1080)
            local clampedX = math.clamp(newPos.X, 0, screenSize.X - mainFrame.AbsoluteSize.X)
            local clampedY = math.clamp(newPos.Y, 0, screenSize.Y - mainFrame.AbsoluteSize.Y)
            mainFrame.Position = UDim2.new(0, clampedX, 0, clampedY)
        end
    end)
end

local function endDrag()
    dragging = false
end

-- Connect to header for dragging (both mouse & touch)
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        beginDrag(input)
    end
end)
header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        endDrag()
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        endDrag()
    end
end)

-- ===== Utilities: create player entry with avatar =====
local function getAvatarUrlAsync(userId)
    -- returns a headshot thumbnail URL (size 48) or nil on failure
    local thumbnail
    local ok, result = pcall(function()
        return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    end)
    if ok and type(result) == "string" then
        thumbnail = result
    end
    return thumbnail
end

local function clearPlayerList()
    for _, child in ipairs(listFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("ImageButton") then
            child:Destroy()
        end
    end
    -- UIListLayout & UIPadding remain
end

local function createPlayerEntry(pl)
    local entry = Instance.new("Frame")
    entry.Size = UDim2.new(1, -12, 0, ENTRY_HEIGHT)
    entry.BackgroundTransparency = 1
    entry.Parent = listFrame

    -- Button covers entry
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(250,250,250)
    btn.AutoButtonColor = true
    btn.Font = Enum.Font.Gotham
    btn.Text = ""
    btn.Parent = entry
    applyRounded(btn, 10)

    -- Avatar image
    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 48, 0, 48)
    avatar.Position = UDim2.new(0, 6, 0.5, -24)
    avatar.BackgroundColor3 = Color3.fromRGB(235,235,235)
    avatar.Parent = btn
    applyRounded(avatar, 999)
    avatar.ZIndex = 5

    -- Player name label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -80, 1, 0)
    nameLabel.Position = UDim2.new(0, 68, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 16
    nameLabel.TextColor3 = Color3.fromRGB(28,28,28)
    nameLabel.Text = pl.Name
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = btn

    -- UserId small label
    local idLabel = Instance.new("TextLabel")
    idLabel.Size = UDim2.new(0.4, -80, 0, 20)
    idLabel.Position = UDim2.new(0.6, 0, 0.5, 6)
    idLabel.BackgroundTransparency = 1
    idLabel.Font = Enum.Font.Gotham
    idLabel.TextSize = 12
    idLabel.TextColor3 = Color3.fromRGB(120,120,120)
    idLabel.Text = "ID: ".. tostring(pl.UserId)
    idLabel.TextXAlignment = Enum.TextXAlignment.Left
    idLabel.Parent = btn

    -- Set avatar image async
    spawn(function()
        local url = getAvatarUrlAsync(pl.UserId)
        if url then
            -- pcall in case of race conditions
            pcall(function() avatar.Image = url end)
        else
            -- fallback blank color (already set)
        end
    end)

    -- Teleport on click
    btn.MouseButton1Click:Connect(function()
        local targetChar = pl.Character
        local myChar = player.Character
        if not myChar then
            statusLabel.Text = "You have no character."
            return
        end
        if not targetChar then
            statusLabel.Text = pl.Name .. " has no character."
            return
        end
        local targetPart = targetChar:FindFirstChild("HumanoidRootPart") or targetChar.PrimaryPart
        if not targetPart then
            statusLabel.Text = "Target has no root part."
            return
        end
        local ok, err = pcall(function()
            myChar:MoveTo(targetPart.Position)
        end)
        if ok then
            statusLabel.Text = "Teleported to " .. pl.Name
        else
            statusLabel.Text = "Teleport failed: " .. tostring(err)
        end
    end)

    return entry
end

-- ===== Build & update list =====
local function updatePlayerEntries(filter)
    filter = filter and filter:lower() or ""
    clearPlayerList()
    local playersAdded = 0
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= player then
            local nameLower = (pl.Name or ""):lower()
            local displayNameLower = (pl.DisplayName or ""):lower()
            if filter == "" or nameLower:find(filter, 1, true) or displayNameLower:find(filter, 1, true) then
                createPlayerEntry(pl)
                playersAdded = playersAdded + 1
            end
        end
    end
    if playersAdded == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(1, -12, 0, 48)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Font = Enum.Font.Gotham
        emptyLabel.TextSize = 14
        emptyLabel.TextColor3 = Color3.fromRGB(140,140,140)
        emptyLabel.Text = "No players found."
        emptyLabel.Parent = listFrame
    end
end

-- Manual refresh action
local function doRefresh()
    statusLabel.Text = "Refreshing player list..."
    updatePlayerEntries(searchBox.Text)
    statusLabel.Text = "Player list refreshed"
    -- clear message after a short delay
    delay(2, function()
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "Tap a player to teleport"
        end
    end)
end

-- Connect Refresh button
refreshBtn.MouseButton1Click:Connect(doRefresh)

-- Search live filtering
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local txt = searchBox.Text
    updatePlayerEntries(txt)
end)

-- Toggle hide/show
local function setMenuVisible(visible)
    mainFrame.Visible = visible
    if visible then
        toggleText.Text = "Hide Menu"
    else
        toggleText.Text = "Show Menu"
    end
end

toggleButton.MouseButton1Click:Connect(function()
    setMenuVisible(not mainFrame.Visible)
end)
smallToggle.MouseButton1Click:Connect(function()
    setMenuVisible(false)
end)

-- Auto-update on joins/leaves (but manual Refresh still available)
Players.PlayerAdded:Connect(function()
    -- update only if currently visible or if search empty (avoid disrupting)
    if mainFrame.Visible then
        updatePlayerEntries(searchBox.Text)
    end
end)
Players.PlayerRemoving:Connect(function()
    if mainFrame.Visible then
        updatePlayerEntries(searchBox.Text)
    end
end)

-- initial population
updatePlayerEntries("")

-- Clean up on destroy (optional safety)
screenGui.Destroying:Connect(function()
    -- nothing special required
end)

-- Done
