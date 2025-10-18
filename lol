local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")
local noclipBtn = Instance.new("TextButton") -- nút noclip

-- GUI Setup
main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.1, 0, 0.38, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)

-- Fly Buttons
up.Name = "up"; up.Parent = Frame; up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Size = UDim2.new(0, 44, 0, 28); up.Font = Enum.Font.SourceSans; up.Text = "UP"; up.TextColor3 = Color3.fromRGB(0, 0, 0); up.TextSize = 14
down.Name = "down"; down.Parent = Frame; down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.49, 0); down.Size = UDim2.new(0, 44, 0, 28); down.Font = Enum.Font.SourceSans; down.Text = "DOWN"; down.TextColor3 = Color3.fromRGB(0, 0, 0); down.TextSize = 14
onof.Name = "onof"; onof.Parent = Frame; onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.7, 0, 0.49, 0); onof.Size = UDim2.new(0, 56, 0, 28); onof.Font = Enum.Font.SourceSans; onof.Text = "FLY"; onof.TextColor3 = Color3.fromRGB(0,0,0); onof.TextSize = 14

-- Labels & Speed Controls
TextLabel.Parent = Frame; TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255); TextLabel.Position = UDim2.new(0.47, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28); TextLabel.Font = Enum.Font.SourceSans; TextLabel.Text = "FLY GUI V3"; TextLabel.TextColor3 = Color3.fromRGB(0,0,0); TextLabel.TextScaled = true; TextLabel.TextWrapped = true
plus.Name = "plus"; plus.Parent = Frame; plus.BackgroundColor3 = Color3.fromRGB(133,145,255); plus.Position = UDim2.new(0.23,0,0,0); plus.Size = UDim2.new(0,45,0,28)
plus.Font = Enum.Font.SourceSans; plus.Text = "+"; plus.TextColor3 = Color3.fromRGB(0,0,0); plus.TextScaled = true; plus.TextWrapped = true
speed.Name = "speed"; speed.Parent = Frame; speed.BackgroundColor3 = Color3.fromRGB(255,85,0); speed.Position = UDim2.new(0.47,0,0.49,0); speed.Size = UDim2.new(0,44,0,28)
speed.Font = Enum.Font.SourceSans; speed.Text = "1"; speed.TextColor3 = Color3.fromRGB(0,0,0); speed.TextScaled = true; speed.TextWrapped = true
mine.Name = "mine"; mine.Parent = Frame; mine.BackgroundColor3 = Color3.fromRGB(123,255,247); mine.Position = UDim2.new(0.23,0,0.49,0); mine.Size = UDim2.new(0,45,0,29)
mine.Font = Enum.Font.SourceSans; mine.Text = "-"; mine.TextColor3 = Color3.fromRGB(0,0,0); mine.TextScaled = true; mine.TextWrapped = true

-- Close & Minimize Buttons
closebutton.Name = "Close"; closebutton.Parent = Frame; closebutton.BackgroundColor3 = Color3.fromRGB(225,25,0)
closebutton.Font = Enum.Font.SourceSans; closebutton.Size = UDim2.new(0,45,0,28); closebutton.Text = "X"; closebutton.TextSize = 30; closebutton.Position = UDim2.new(0,0,-1,27)
mini.Name = "minimize"; mini.Parent = Frame; mini.BackgroundColor3 = Color3.fromRGB(192,150,230); mini.Size = UDim2.new(0,45,0,28); mini.Text = "-"; mini.TextSize = 40; mini.Position = UDim2.new(0,44,-1,27)
mini2.Name = "minimize2"; mini2.Parent = Frame; mini2.BackgroundColor3 = Color3.fromRGB(192,150,230); mini2.Size = UDim2.new(0,45,0,28); mini2.Text = "+"; mini2.TextSize = 40; mini2.Position = UDim2.new(0,44,-1,57); mini2.Visible = false

-- Noclip Button
noclipBtn.Name = "noclip"; noclipBtn.Parent = Frame; noclipBtn.BackgroundColor3 = Color3.fromRGB(255,128,0)
noclipBtn.Position = UDim2.new(0.6,0,0,0); noclipBtn.Size = UDim2.new(0,60,0,28); noclipBtn.Font = Enum.Font.SourceSans; noclipBtn.Text = "Noclip OFF"; noclipBtn.TextColor3 = Color3.fromRGB(0,0,0); noclipBtn.TextScaled = true; noclipBtn.TextWrapped = true

-- Variables
local speeds = 1
local nowe = false
local noclipEnabled = false
local tpwalking = false
local player = game.Players.LocalPlayer
Frame.Active = true
Frame.Draggable = true

-- Noclip Function
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    local chr = player.Character
    if not chr then return end

    if noclipEnabled then
        noclipBtn.Text = "Noclip ON"
        game:GetService("RunService").Stepped:Connect(function()
            if noclipEnabled then
                for _, part in pairs(chr:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        noclipBtn.Text = "Noclip OFF"
        for _, part in pairs(chr:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

noclipBtn.MouseButton1Click:Connect(toggleNoclip)

-- Fly Logic
local ctrl = {f=0,b=0,l=0,r=0}
local lastctrl = {f=0,b=0,l=0,r=0}

local function startFly()
    nowe = true
    local chr = player.Character
    local hum = chr:FindFirstChildWhichIsA("Humanoid")
    if not hum then return end
    hum.PlatformStand = true

    local torso = chr:FindFirstChild("Torso") or chr:FindFirstChild("UpperTorso")
    local bg = Instance.new("BodyGyro", torso)
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.CFrame = torso.CFrame
    local bv = Instance.new("BodyVelocity", torso)
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Velocity = Vector3.new(0,0.1,0)

    spawn(function()
        local rs = game:GetService("RunService").RenderStepped
        local speed = speeds
        while nowe and hum.Health>0 do
            rs:Wait()
            local moveDir = ((workspace.CurrentCamera.CFrame.lookVector * (ctrl.f+ctrl.b)) + ((workspace.CurrentCamera.CFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - workspace.CurrentCamera.CFrame.p)) * speed
            bv.Velocity = moveDir
            bg.CFrame = workspace.CurrentCamera.CFrame
        end
        bv:Destroy()
        bg:Destroy()
        hum.PlatformStand = false
    end)
end

local function stopFly()
    nowe = false
    local chr = player.Character
    local hum = chr:FindFirstChildWhichIsA("Humanoid")
    if hum then hum.PlatformStand = false end
end

onof.MouseButton1Click:Connect(function()
    if nowe then stopFly() else startFly() end
end)

-- GUI Events: UP/DOWN
up.MouseButton1Down:Connect(function()
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0,1,0) end
end)

down.MouseButton1Down:Connect(function()
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0,-1,0) end
end)

-- Speed Buttons
plus.MouseButton1Click:Connect(function()
    speeds = speeds + 1
    speed.Text = speeds
end)

mine.MouseButton1Click:Connect(function()
    if speeds>1 then speeds = speeds -1 end
    speed.Text = speeds
end)

-- Close / Minimize
closebutton.MouseButton1Click:Connect(function() main:Destroy() end)
mini.MouseButton1Click:Connect(function()
    up.Visible=false; down.Visible=false; onof.Visible=false; plus.Visible=false; speed.Visible=false; mine.Visible=false; mini.Visible=false; mini2.Visible=true; noclipBtn.Visible=false
    Frame.BackgroundTransparency=1; closebutton.Position=UDim2.new(0,0,-1,57)
end)
mini2.MouseButton1Click:Connect(function()
    up.Visible=true; down.Visible=true; onof.Visible=true; plus.Visible=true; speed.Visible=true; mine.Visible=true; mini.Visible=true; mini2.Visible=false; noclipBtn.Visible=true
    Frame.BackgroundTransparency=0; closebutton.Position=UDim2.new(0,0,-1,27)
end)
