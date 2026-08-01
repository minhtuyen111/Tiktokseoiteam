local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ==========================================
-- 1. CẤU HÌNH TRẠNG THÁI (SETTINGS)
-- ==========================================
local Settings = {
    SkillAimEnabled = true,   -- Bẻ skill/tấn công vào địch (Silent Aim)
    FOVRadius = 150,          -- Bán kính vòng ngắm
    FOVVisible = true,        -- Hiện vòng FOV
    TracerEnabled = true,     -- Đường kẻ nối tới mục tiêu
    ESPEnabled = true,        -- ESP Khung và Máu
    WalkSpeed = 32,           -- Tốc độ chạy tùy chỉnh
    SpeedEnabled = false,     -- Bật/tắt chạy nhanh
    JumpPower = 100,          -- Độ cao nhảy tùy chỉnh
    JumpEnabled = false       -- Bật/tắt nhảy cao
}

-- ==========================================
-- 2. ĐỒ HỌA DRAWING (FOV & TRACER)
-- ==========================================
-- Vòng FOV cố định ở tâm màn hình
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(0, 255, 170)
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = Settings.FOVRadius
FOVCircle.Filled = false
FOVCircle.Visible = Settings.FOVVisible

-- Đường kẻ Aimbot nối từ tâm màn hình đến target
local AimLine = Drawing.new("Line")
AimLine.Color = Color3.fromRGB(255, 50, 50)
AimLine.Thickness = 2
AimLine.Transparency = 1
AimLine.Visible = false

-- ==========================================
-- 3. HỆ THỐNG ESP (KHUNG & HP)
-- ==========================================
local ESPObjects = {}

local function CreateESP(player)
    if player == LocalPlayer then return end

    local box = Drawing.new("Square")
    box.Color = Color3.fromRGB(0, 255, 255)
    box.Thickness = 1.5
    box.Filled = false
    box.Visible = false

    local nameTag = Drawing.new("Text")
    nameTag.Text = player.Name
    nameTag.Size = 14
    nameTag.Color = Color3.fromRGB(255, 255, 255)
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.Visible = false

    ESPObjects[player] = {Box = box, NameTag = nameTag}
end

local function RemoveESP(player)
    if ESPObjects[player] then
        ESPObjects[player].Box:Remove()
        ESPObjects[player].NameTag:Remove()
        ESPObjects[player] = nil
    end
end

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)

-- ==========================================
-- 4. HÀM TÌM KẺ ĐỊCH GẦN TÂM MÀN HÌNH NHẤT
-- ==========================================
local function GetClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = Settings.FOVRadius
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local hrp = player.Character.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
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
-- 5. BẺ HƯỚNG TẤN CÔNG / SKILL (AUTO-AIM)
-- ==========================================
-- Cách 1: Bẻ vị trí con trỏ chuột Mouse.Hit cho các Tool/Skill nhận vị trí chuột
local oldIndex
if hookmetamethod then
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
end

-- Cách 2: Tự động xoay nhân vật nhanh về phía mục tiêu khi tung skill (cho game Studio)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    -- Khi click chuột hoặc bấm phím skill (Z, X, C, V)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.KeyCode == Enum.KeyCode.Z or input.KeyCode == Enum.KeyCode.X or 
       input.KeyCode == Enum.KeyCode.C or input.KeyCode == Enum.KeyCode.V then
        
        if Settings.SkillAimEnabled then
            local target = GetClosestPlayerInFOV()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    local targetPos = target.Character.HumanoidRootPart.Position
                    myHRP.CFrame = CFrame.new(myHRP.Position, Vector3.new(targetPos.X, myHRP.Position.Y, targetPos.Z))
                end
            end
        end
    end
end)

-- ==========================================
-- 6. GIAO DIỆN MENU (GUI HUB)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxSkillAimGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Nút Logo Đóng/Mở Menu
local LogoBtn = Instance.new("TextButton")
LogoBtn.Name = "LogoButton"
LogoBtn.Size = UDim2.new(0, 45, 0, 45)
LogoBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
LogoBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
LogoBtn.Text = "⚡"
LogoBtn.TextColor3 = Color3.fromRGB(0, 255, 170)
LogoBtn.TextSize = 22
LogoBtn.Font = Enum.Font.SourceSansBold
LogoBtn.Active = true
LogoBtn.Draggable = true
LogoBtn.Parent = ScreenGui

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0.5, 0)
LogoCorner.Parent = LogoBtn

-- Khung Main Frame Menu
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 310, 0, 390)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Tiêu đề Menu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
Title.Text = "   🔥 SKILL AIM & VISUALS MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Scrolling Frame chứa danh sách các mục
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -16, 1, -50)
Scroll.Position = UDim2.new(0, 8, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 480)
Scroll.ScrollBarThickness = 4
Scroll.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Scroll
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)

-- Các hàm tạo UI Helper
local function CreateSection(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.Text = "--- " .. text .. " ---"
    lbl.TextColor3 = Color3.fromRGB(0, 255, 170)
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 13
    lbl.Parent = Scroll
end

local function CreateToggle(text, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(35, 55, 45) or Color3.fromRGB(30, 30, 38)
    btn.Text = text .. (defaultState and " [ON]" or " [OFF]")
    btn.TextColor3 = defaultState and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = Scroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        btn.TextColor3 = state and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(180, 180, 180)
        btn.BackgroundColor3 = state and Color3.fromRGB(35, 55, 45) or Color3.fromRGB(30, 30, 38)
        callback(state)
    end)
end

local function CreateInput(placeholder, defaultValue, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 32)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    box.PlaceholderText = placeholder
    box.Text = tostring(defaultValue)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 14
    box.Parent = Scroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = box

    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then callback(val) end
    end)
end

-- ==========================================
-- 7. KHỞI TẠO CÁC NÚT BẤM VÀ CÀI ĐẶT
-- ==========================================
CreateSection("SKILL & AIMBOT")
CreateToggle("Silent Skill Aim (Tự Trúng Skill)", Settings.SkillAimEnabled, function(s) Settings.SkillAimEnabled = s end)
CreateToggle("Đường Kẻ Aim (Tracer Line)", Settings.TracerEnabled, function(s) Settings.TracerEnabled = s end)
CreateToggle("Hiện Vòng FOV Tâm Màn Hình", Settings.FOVVisible, function(s) Settings.FOVVisible = s end)
CreateInput("Bán Kính FOV Radius", Settings.FOVRadius, function(v) Settings.FOVRadius = v end)

CreateSection("VISUALS (ESP)")
CreateToggle("Bật ESP Khung & Tên/Máu", Settings.ESPEnabled, function(s) Settings.ESPEnabled = s end)

CreateSection("NHÂN VẬT")
CreateToggle("Bật Chạy Nhanh", Settings.SpeedEnabled, function(s) Settings.SpeedEnabled = s end)
CreateInput("Tốc độ WalkSpeed", Settings.WalkSpeed, function(v) Settings.WalkSpeed = v end)
CreateToggle("Bật Nhảy Cao", Settings.JumpEnabled, function(s) Settings.JumpEnabled = s end)
CreateInput("Lực nhảy JumpPower", Settings.JumpPower, function(v) Settings.JumpPower = v end)

-- Thu nhỏ / Mở menu khi bấm vào nút Logo
LogoBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ==========================================
-- 8. VÒNG LẶP RENDER CHÍNH (RENDERSTEPPED)
-- ==========================================
RunService.RenderStepped:Connect(function()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    -- Cập nhật FOV cố định ở tâm màn hình
    FOVCircle.Position = screenCenter
    FOVCircle.Radius = Settings.FOVRadius
    FOVCircle.Visible = Settings.FOVVisible

    -- Lấy đối thủ gần nhất trong FOV
    local target = GetClosestPlayerInFOV()

    -- Xử lý đường kẻ Tracer Line
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrpPos = target.Character.HumanoidRootPart.Position
        local screenPos, onScreen = Camera:WorldToViewportPoint(hrpPos)

        if Settings.TracerEnabled and onScreen then
            AimLine.From = screenCenter
            AimLine.To = Vector2.new(screenPos.X, screenPos.Y)
            AimLine.Visible = true
        else
            AimLine.Visible = false
        end
    else
        AimLine.Visible = false
    end

    -- Xử lý ESP Players (Khung & Tên/Máu)
    for player, esp in pairs(ESPObjects) do
        if Settings.ESPEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

            if head and humanoid and humanoid.Health > 0 then
                local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

                if onScreen then
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height / 1.8

                    esp.Box.Size = Vector2.new(width, height)
                    esp.Box.Position = Vector2.new(hrpPos.X - width / 2, hrpPos.Y - height / 2)
                    esp.Box.Visible = true

                    esp.NameTag.Text = string.format("%s [%d HP]", player.Name, math.floor(humanoid.Health))
                    esp.NameTag.Position = Vector2.new(hrpPos.X, hrpPos.Y - height / 2 - 18)
                    esp.NameTag.Visible = true
                else
                    esp.Box.Visible = false
                    esp.NameTag.Visible = false
                end
            else
                esp.Box.Visible = false
                esp.NameTag.Visible = false
            end
        else
            esp.Box.Visible = false
            esp.NameTag.Visible = false
        end
    end

    -- Xử lý Speed / Jump của nhân vật
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.WalkSpeed = Settings.SpeedEnabled and Settings.WalkSpeed or 16
        if Settings.JumpEnabled then
            hum.UseJumpPower = true
            hum.JumpPower = Settings.JumpPower
        else
            hum.JumpPower = 50
        end
    end
end)