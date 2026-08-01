-- [[ IOS 26 ULTRA HUB - ROBLOX STUDIO EDITION ]] --
-- Hỗ trợ Mobile | Blox Fruits & PVP Games

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Config System
local Config = {
    Aimbot = false,
    FOVSize = 120,
    Speed = false,
    SpeedValue = 80,
    Jump = false,
    JumpValue = 120,
    WaterWalk = false,
    AutoTeleSkill = false
}

--------------------------------------------------------------------------------
-- 1. TẠO GIAO DIỆN PHONG CÁCH IOS 26 (UI DESIGN)
--------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "iOS26Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Nút Logo Bật/Tắt Menu (Mobile Floating Button)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleBtn.Text = ""
ToggleBtn.TextColor3 = Color3.fromRGB(0, 195, 255)
ToggleBtn.TextSize = 28
ToggleBtn.Font = Enum.Font.FredokaOne
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

local BtnUICorner = Instance.new("UICorner", ToggleBtn)
BtnUICorner.CornerRadius = UDim.new(0, 15)
local BtnUIStroke = Instance.new("UIStroke", ToggleBtn)
BtnUIStroke.Color = Color3.fromRGB(0, 195, 255)
BtnUIStroke.Thickness = 2

-- Khung Main Menu (Glassmorphism Style)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 380)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.25
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner", MainFrame)
FrameCorner.CornerRadius = UDim.new(0, 20)
local FrameStroke = Instance.new("UIStroke", MainFrame)
FrameStroke.Color = Color3.fromRGB(255, 255, 255)
FrameStroke.Transparency = 0.8

-- Title iOS 26
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "iOS 26 Ultra Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Thanh Cuộn (Scroll Frame)
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(0.9, 0, 0.82, 0)
Scroll.Position = UDim2.new(0.05, 0, 0.14, 0)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 400)
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 195, 255)
Scroll.Parent = MainFrame

local UIList = Instance.new("UIListLayout", Scroll)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 10)

-- Hàm Tạo Toggle Switch Chuẩn iOS
local function CreateToggle(text, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -10, 0, 45)
    Container.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Container.BackgroundTransparency = 0.4
    Container.Parent = Scroll
    
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 10)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0.05, 0, 0, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(240, 240, 240)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.BackgroundTransparency = 1
    Label.Parent = Container

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 45, 0, 24)
    Switch.Position = UDim2.new(0.8, -10, 0.5, -12)
    Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    Switch.Text = ""
    Switch.Parent = Container
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 18, 0, 18)
    Circle.Position = UDim2.new(0, 3, 0.5, -9)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Parent = Switch
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local toggled = false
    Switch.MouseButton1Click:Connect(function()
        toggled = not toggled
        local goalSwitch = toggled and Color3.fromRGB(48, 209, 88) or Color3.fromRGB(60, 60, 75)
        local goalCircle = toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        
        TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = goalSwitch}):Play()
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = goalCircle}):Play()
        
        callback(toggled)
    end)
end

-- Bật / Tắt Menu khi bấm vào Logo
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

--------------------------------------------------------------------------------
-- 2. VẼ VÒNG TRÒN FOV (SILENT AIM FOV)
--------------------------------------------------------------------------------
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(0, 195, 255)
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 60
FOVCircle.Radius = Config.FOVSize
FOVCircle.Filled = false
FOVCircle.Visible = false

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = Config.FOVSize
    FOVCircle.Visible = Config.Aimbot
end)

-- Tìm đối thủ gần tâm màn hình nhất
local function GetClosestPlayer()
    local target = nil
    local maxDist = Config.FOVSize
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid").Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist < maxDist then
                    maxDist = dist
                    target = v.Character.HumanoidRootPart
                end
            end
        end
    end
    return target
end

--------------------------------------------------------------------------------
-- 3. TẠO CÁC NÚT TÍNH NĂNG TRÊN MENU
--------------------------------------------------------------------------------

-- 1. Silent Aim Target Lock
CreateToggle("Silent Aim (360° FOV)", function(state)
    Config.Aimbot = state
end)

-- 2. Đi Trên Nước (Water Walk)
CreateToggle("Đi Trên Biển (Water Walk)", function(state)
    Config.WaterWalk = state
    local seaPart = workspace:FindFirstChild("iOS_SeaPlatform")
    if not seaPart then
        seaPart = Instance.new("Part")
        seaPart.Name = "iOS_SeaPlatform"
        seaPart.Size = Vector3.new(20000, 1, 20000)
        seaPart.Position = Vector3.new(0, 0, 0) -- Độ cao mặt nước chuẩn Blox Fruits
        seaPart.Anchored = true
        seaPart.Transparency = 1
        seaPart.Parent = workspace
    end
    seaPart.CanCollide = state
end)

-- 3. Chạy Nhanh (Speed Hack)
CreateToggle("Chạy Nhanh (Speed 80)", function(state)
    Config.Speed = state
end)

-- 4. Nhảy Cao (High Jump)
CreateToggle("Nhảy Cao (Jump 120)", function(state)
    Config.Jump = state
end)

-- 5. Auto Teleport Skill (Tự Áp Sát Khi Tung Chiêu)
CreateToggle("Auto Teleport Skill", function(state)
    Config.AutoTeleSkill = state
end)

--------------------------------------------------------------------------------
-- 4. VÒNG LẶP XỬ LÝ LOGIC (GAMEPLAY LOOPS)
--------------------------------------------------------------------------------

-- Xử lý Speed, Jump & Silent Aim Camera Lock
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if Config.Speed then
            char.Humanoid.WalkSpeed = Config.SpeedValue
        end
        if Config.Jump then
            char.Humanoid.JumpPower = Config.JumpValue
        end
    end

    -- Khóa Aim mượt mà vào mục tiêu trong FOV
    if Config.Aimbot then
        local targetPart = GetClosestPlayer()
        if targetPart then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
        end
    end
end)

-- Xử lý Auto Teleport Skill khi người dùng nhấn phím/chiêu thức
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Kiểm tra phím kỹ năng (Z, X, C, V trên Mobile / PC)
    local skillKeys = {Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V}
    if table.find(skillKeys, input.KeyCode) and Config.AutoTeleSkill then
        local target = GetClosestPlayer()
        local char = LocalPlayer.Character
        if target and char and char:FindFirstChild("HumanoidRootPart") then
            -- Dịch chuyển tức thời đến phía sau lưng đối thủ 3 Studs
            char.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, 0, 3)
        end
    end
end)