local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ==========================================
-- 1. CẤU HÌNH (SETTINGS)
-- ==========================================
local Settings = {
    SilentAim = true,
    SilentAimMode = "FOV", -- FOV / Distance
    FOVCircle = true,
    FOVSize = 350,
    FOVMode = "Middle", -- Middle / Touch
    AimRange = 1000,
    CheckPvP = false, -- Để false để aim được cả NPC/Mob
    ESPEnabled = true,
    WalkSpeed = 32,
    SpeedEnabled = false
}

-- ==========================================
-- 2. ĐỒ HỌA FOV CIRCLE (MÀU ĐỎ NHƯ TRONG ẢNH)
-- ==========================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 50, 50)
FOVCircle.Thickness = 2
FOVCircle.NumSides = 100
FOVCircle.Radius = Settings.FOVSize
FOVCircle.Filled = false
FOVCircle.Visible = Settings.FOVCircle

-- ==========================================
-- 3. HÀM TÌM TARGET CHUẨN (PLAYERS & MOBS)
-- ==========================================
local function GetClosestTarget()
    local closest = nil
    local shortestDistance = Settings.FOVSize
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    -- Scan Players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local char = player.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            if hum and hum.Health > 0 then
                -- Kiểm tra PvP nếu bật
                local isPvp = true
                if Settings.CheckPvP then
                    if char:FindFirstChild("InSafeZone") and char.InSafeZone.Value == true then isPvp = false end
                end

                if isPvp then
                    local hrp = char.HumanoidRootPart
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if dist < shortestDistance then
                            shortestDistance = dist
                            closest = hrp
                        end
                    end
                end
            end
        end
    end

    -- Scan Enemies/NPCs (Nếu không thấy Player)
    if not closest and Workspace:FindFirstChild("Enemies") then
        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                if enemy.Humanoid.Health > 0 then
                    local hrp = enemy.HumanoidRootPart
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if dist < shortestDistance then
                            shortestDistance = dist
                            closest = hrp
                        end
                    end
                end
            end
        end
    end

    return closest
end

-- ==========================================
-- 4. FIX TRIỆT ĐỂ MOBILE: HOOK NAMECALL (REMOTEEVENT)
-- ==========================================
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index
setreadonly(mt, false)

-- Hook Remote Event khi xài Skill trên Mobile
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if Settings.SilentAim and (method == "FireServer" or method == "InvokeServer") then
        local targetHRP = GetClosestTarget()
        if targetHRP then
            -- Duyệt qua các argument để thay thế Vector3/CFrame điểm bấm ngón tay thành tọa độ Target
            for i, arg in pairs(args) do
                if type(arg) == "Vector3" then
                    args[i] = targetHRP.Position
                elseif typeof(arg) == "CFrame" then
                    args[i] = CFrame.new(targetHRP.Position)
                end
            end
            return oldNamecall(self, unpack(args))
        end
    end

    return oldNamecall(self, ...)
end)

-- Hook Mouse Hit
mt.__index = newcclosure(function(self, index)
    if Settings.SilentAim and not checkcaller() and self == LocalPlayer:GetMouse() then
        if index == "Hit" or index == "hit" then
            local targetHRP = GetClosestTarget()
            if targetHRP then
                return targetHRP.CFrame
            end
        elseif index == "Target" or index == "target" then
            local targetHRP = GetClosestTarget()
            if targetHRP then
                return targetHRP
            end
        end
    end
    return oldIndex(self, index)
end)

setreadonly(mt, true)

-- ==========================================
-- 5. GUI ĐEN ĐỎ (Y HỆT HERMANOS'DEV TRONG ẢNH)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HermanosRedUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Nút Icon Toggle Logo Đỏ
local LogoBtn = Instance.new("TextButton")
LogoBtn.Size = UDim2.new(0, 45, 0, 45)
LogoBtn.Position = UDim2.new(0.48, 0, 0.01, 0)
LogoBtn.BackgroundColor3 = Color3.fromRGB(20, 15, 15)
LogoBtn.Text = "🥷"
LogoBtn.TextSize = 22
LogoBtn.Active = true
LogoBtn.Draggable = true
LogoBtn.Parent = ScreenGui

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 10)
LogoCorner.Parent = LogoBtn

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(220, 30, 30)
LogoStroke.Thickness = 1.5
LogoStroke.Parent = LogoBtn

-- Main Frame Thiết Kế Y Hệt Trong Ảnh
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 320)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 22, 24)
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Hermanos'Dev | PVP"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 200, 0, 15)
SubTitle.Position = UDim2.new(0, 12, 0, 22)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "[⚔️] - Blox Fruit"
SubTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.SourceSans
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

-- Tab Sidebar (Bên Trái)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -48)
Sidebar.Position = UDim2.new(0, 8, 0, 44)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local SideList = Instance.new("UIListLayout")
SideList.Parent = Sidebar
SideList.Padding = UDim.new(0, 4)

-- Content Container (Bên Phải)
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -140, 1, -48)
Content.Position = UDim2.new(0, 132, 0, 44)
Content.BackgroundTransparency = 1
Content.CanvasSize = UDim2.new(0, 0, 0, 360)
Content.ScrollBarThickness = 2
Content.Parent = MainFrame

local ContentList = Instance.new("UIListLayout")
ContentList.Parent = Content
ContentList.Padding = UDim.new(0, 8)

-- NÚT TOGGLE CÔNG TẮC XANH/XÁM Y HỆT TRONG ẢNH
local function AddToggle(titleText, subText, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -5, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    frame.Parent = Content

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame

    local tLabel = Instance.new("TextLabel")
    tLabel.Size = UDim2.new(1, -50, 0, 20)
    tLabel.Position = UDim2.new(0, 10, 0, 6)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = titleText
    tLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    tLabel.Font = Enum.Font.SourceSansBold
    tLabel.TextSize = 13
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.Parent = frame

    local sLabel = Instance.new("TextLabel")
    sLabel.Size = UDim2.new(1, -50, 0, 15)
    sLabel.Position = UDim2.new(0, 10, 0, 26)
    sLabel.BackgroundTransparency = 1
    sLabel.Text = subText
    sLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
    sLabel.Font = Enum.Font.SourceSans
    sLabel.TextSize = 10
    sLabel.TextXAlignment = Enum.TextXAlignment.Left
    sLabel.Parent = frame

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 36, 0, 20)
    switch.Position = UDim2.new(1, -44, 0.5, -10)
    switch.BackgroundColor3 = defaultState and Color3.fromRGB(30, 144, 255) or Color3.fromRGB(50, 50, 55)
    switch.Text = ""
    switch.Parent = frame

    local swCorner = Instance.new("UICorner")
    swCorner.CornerRadius = UDim.new(1, 0)
    swCorner.Parent = switch

    local state = defaultState
    switch.MouseButton1Click:Connect(function()
        state = not state
        switch.BackgroundColor3 = state and Color3.fromRGB(30, 144, 255) or Color3.fromRGB(50, 50, 55)
        callback(state)
    end)
end

-- SLIDER KÉO Y HỆT TRONG ẢNH
local function AddSlider(titleText, subText, minVal, maxVal, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -5, 0, 55)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    frame.Parent = Content

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame

    local tLabel = Instance.new("TextLabel")
    tLabel.Size = UDim2.new(0, 150, 0, 20)
    tLabel.Position = UDim2.new(0, 10, 0, 6)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = titleText
    tLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    tLabel.Font = Enum.Font.SourceSansBold
    tLabel.TextSize = 13
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.Parent = frame

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0, 50, 0, 20)
    valLabel.Position = UDim2.new(1, -60, 0, 6)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(defaultVal)
    valLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    valLabel.Font = Enum.Font.SourceSans
    valLabel.TextSize = 12
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 4)
    sliderBg.Position = UDim2.new(0, 10, 0, 38)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    sliderBg.Parent = frame

    local fill = Instance.new("Frame")
    local startFactor = (defaultVal - minVal) / (maxVal - minVal)
    fill.Size = UDim2.new(startFactor, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    fill.Parent = sliderBg

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.Position = UDim2.new(1, -5, 0.5, -5)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = fill

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local dragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(minVal + (maxVal - minVal) * pos)
        valLabel.Text = tostring(val)
        callback(val)
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            Update(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            Update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- TẠO CÁC NÚT ĐÚNG TRONG ẢNH
AddToggle("Silent Aim", "Silent aim skill, gun shot", Settings.SilentAim, function(s) Settings.SilentAim = s end)
AddToggle("FOV Circle", "Show the FOV circle on the screen", Settings.FOVCircle, function(s) Settings.FOVCircle = s end)
AddSlider("FOV Size", "The size of the FOV circle", 50, 800, Settings.FOVSize, function(v) 
    Settings.FOVSize = v 
    FOVCircle.Radius = v
end)

LogoBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Vòng lặp RenderStepped liên tục cập nhật FOV Circle
RunService.RenderStepped:Connect(function()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Position = screenCenter
    FOVCircle.Visible = Settings.FOVCircle
end)