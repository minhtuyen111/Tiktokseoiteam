local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ==========================================
-- CẤU HÌNH TRẠNG THÁI (SETTINGS)
-- ==========================================
local Settings = {
    AimbotEnabled = false,
    SkillAimEnabled = false,
    FOVRadius = 150,
    FOVVisible = true,
    WalkSpeed = 16,
    JumpPower = 50,
    SpeedEnabled = false,
    JumpEnabled = false
}

-- ==========================================
-- VẼ VÒNG FOV (DRAW FOV CIRCLE)
-- ==========================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(0, 255, 150)
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = Settings.FOVRadius
FOVCircle.Filled = false
FOVCircle.Visible = Settings.FOVVisible

-- ==========================================
-- HÀM TÌM NGUỜI CHƠI GẦN NHẤT TRONG FOV
-- ==========================================
local function GetClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = Settings.FOVRadius
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid.Health > 0 then
                local hrp = player.Character.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- ==========================================
-- TẠO GIAO DIỆN (GUI MENU)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModMenuGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Nút Logo Thu/Mở Menu
local LogoBtn = Instance.new("TextButton")
LogoBtn.Name = "LogoButton"
LogoBtn.Size = UDim2.new(0, 50, 0, 50)
LogoBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
LogoBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
LogoBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
LogoBtn.Text = "⚡"
LogoBtn.TextSize = 24
LogoBtn.Font = Enum.Font.SourceSansBold
LogoBtn.Active = true
LogoBtn.Draggable = true
LogoBtn.Parent = ScreenGui

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0.5, 0)
LogoCorner.Parent = LogoBtn

-- Khung Menu Chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 10)
FrameCorner.Parent = MainFrame

-- Tiêu đề Menu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Title.Text = "  ⚡ MOD MENU HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Thanh Cuộn (ScrollingFrame)
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -50)
Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 420)
Scroll.ScrollBarThickness = 6
Scroll.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Scroll
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)

-- Hàm hỗ trợ tạo Nút Toggle (Bật/Tắt)
local function CreateToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = Scroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = text .. " [ON]"
            btn.TextColor3 = Color3.fromRGB(0, 255, 150)
            btn.BackgroundColor3 = Color3.fromRGB(50, 60, 70)
        else
            btn.Text = text .. " [OFF]"
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        end
        callback(state)
    end)
end

-- Hàm hỗ trợ tạo ô nhập số (Input Box)
local function CreateInput(placeholder, defaultVal, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -10, 0, 35)
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    box.PlaceholderText = placeholder
    box.Text = tostring(defaultVal)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 14
    box.Parent = Scroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = box

    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num then
            callback(num)
        end
    end)
end

-- ==========================================
-- TẠO CÁC NÚT ĐIỀU KHIỂN TRONG MENU
-- ==========================================
CreateToggle("Aimbot Camera", function(state)
    Settings.AimbotEnabled = state
end)

CreateToggle("Skill Aim (Hỗ trợ Skill)", function(state)
    Settings.SkillAimEnabled = state
end)

CreateToggle("Hiện Vòng FOV", function(state)
    Settings.FOVVisible = state
end)

CreateInput("Bán kính FOV (Mặc định: 150)", Settings.FOVRadius, function(val)
    Settings.FOVRadius = val
end)

CreateToggle("Bật Chạy Nhanh", function(state)
    Settings.SpeedEnabled = state
end)

CreateInput("Tốc độ chạy (WalkSpeed)", Settings.WalkSpeed, function(val)
    Settings.WalkSpeed = val
end)

CreateToggle("Bật Nhảy Cao", function(state)
    Settings.JumpEnabled = state
end)

CreateInput("Độ cao nhảy (JumpPower)", Settings.JumpPower, function(val)
    Settings.JumpPower = val
end)

-- Sự kiện click Logo để Ẩn/Hiện Menu
LogoBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ==========================================
-- VÒNG LẶP XỬ LÝ GAME (RENDER LOOP)
-- ==========================================
RunService.RenderStepped:Connect(function()
    -- Cập nhật vị trí và kích thước vòng FOV theo chuột
    local mousePos = UserInputService:GetMouseLocation()
    FOVCircle.Position = mousePos
    FOVCircle.Radius = Settings.FOVRadius
    FOVCircle.Visible = Settings.FOVVisible

    -- Lấy đối tượng gần nhất trong FOV
    local target = GetClosestPlayerInFOV()

    -- 1. Aimbot Camera (Xoay góc nhìn)
    if Settings.AimbotEnabled and target and target.Character and target.Character:FindFirstChild("Head") then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
    end

    -- 2. Thay đổi đặc tính Nhân vật (Speed / Jump)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        if Settings.SpeedEnabled then
            humanoid.WalkSpeed = Settings.WalkSpeed
        else
            humanoid.WalkSpeed = 16
        end

        if Settings.JumpEnabled then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = Settings.JumpPower
        else
            humanoid.JumpPower = 50
        end
    end
end)

-- 3. Skill Aim (Ép vị trí Mouse.Hit vào vị trí đối thủ gần nhất)
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if not checkcaller() and Settings.SkillAimEnabled and self == Mouse then
        if key == "Hit" or key == "Target" then
            local target = GetClosestPlayerInFOV()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                if key == "Hit" then
                    return target.Character.HumanoidRootPart.CFrame
                elseif key == "Target" then
                    return target.Character.HumanoidRootPart
                end
            end
        end
    end
    return oldIndex(self, key)
end)