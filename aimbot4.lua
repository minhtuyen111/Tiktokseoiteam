local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ==========================================
-- 1. CẤU HÌNH TRẠNG THÁI (SETTINGS)
-- ==========================================
local Settings = {
    SkillAimEnabled = true,
    AutoM1Enabled = false,
    FOVRadius = 160,
    FOVVisible = true,
    MaxDistance = 500,          -- Khoảng cách aim mặc định (studs)
    UnlimitedDistance = true,   -- Mặc định BẬT không giới hạn khoảng cách
    TracerEnabled = true,
    ESPEnabled = true,
    WalkSpeed = 32,
    SpeedEnabled = false,
    JumpPower = 100,
    JumpEnabled = false
}

-- ==========================================
-- 2. ĐỒ HỌA DRAWING (FOV & TRACER)
-- ==========================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(0, 255, 170)
FOVCircle.Thickness = 2
FOVCircle.NumSides = 64
FOVCircle.Radius = Settings.FOVRadius
FOVCircle.Filled = false
FOVCircle.Visible = false

local AimLine = Drawing.new("Line")
AimLine.Color = Color3.fromRGB(255, 40, 40)
AimLine.Thickness = 2
AimLine.Transparency = 1
AimLine.Visible = false

-- Kiểm tra xem Player có đang bật PvP / Không ở Safe Zone
local function IsPvPActive(player)
    if not player or not player.Character then return false end
    if player.Character:FindFirstChild("InSafeZone") and player.Character.InSafeZone.Value == true then
        return false
    end
    local pvpValue = player:FindFirstChild("PvP") or player:FindFirstChild("EnablePvP")
    if pvpValue and pvpValue:IsA("BoolValue") then
        return pvpValue.Value
    end
    return true
end

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
    nameTag.Size = 13
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
-- 4. HÀM TÌM KẺ ĐỊCH GẦN TÂM MÀN HÌNH (CÓ KHOẢNG CÁCH)
-- ==========================================
local function GetClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = Settings.FOVRadius
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local targetHRP = player.Character.HumanoidRootPart

            if humanoid and humanoid.Health > 0 and IsPvPActive(player) then
                -- Kiểm tra khoảng cách World (Distance) nếu không bật Unlimited
                local worldDist = myHRP and (targetHRP.Position - myHRP.Position).Magnitude or 0
                if Settings.UnlimitedDistance or worldDist <= Settings.MaxDistance then
                    
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetHRP.Position)
                    if onScreen then
                        local fovDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if fovDist < shortestDistance then
                            shortestDistance = fovDist
                            closestPlayer = player
                        end
                    end

                end
            end
        end
    end
    return closestPlayer
end

-- ==========================================
-- 5. CƠ CHẾ SKILL AIM & AUTO M1
-- ==========================================
local function AimAtTarget(target)
    if not target or not target.Character then return end
    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if myHRP and targetHRP then
        local targetPos = targetHRP.Position
        myHRP.CFrame = CFrame.new(myHRP.Position, Vector3.new(targetPos.X, myHRP.Position.Y, targetPos.Z))
    end
end

-- Bắt phím bấm Skill (Z, X, C, V, F hoặc Click chuột)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local k = input.KeyCode
    if Settings.SkillAimEnabled and (
       k == Enum.KeyCode.Z or k == Enum.KeyCode.X or 
       k == Enum.KeyCode.C or k == Enum.KeyCode.V or 
       k == Enum.KeyCode.F or input.UserInputType == Enum.UserInputType.MouseButton1) then
        
        local target = GetClosestPlayerInFOV()
        if target then
            AimAtTarget(target)
        end
    end
end)

-- Vòng lặp Auto M1
task.spawn(function()
    while task.wait(0.1) do
        if Settings.AutoM1Enabled then
            local target = GetClosestPlayerInFOV()
            if target then
                AimAtTarget(target)
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2))
            end
        end
    end
end)

-- ==========================================
-- 6. GIAO DIỆN MENU PHÂN TAB
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxHubProMax"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Logo Đóng/Mở
local LogoBtn = Instance.new("TextButton")
LogoBtn.Size = UDim2.new(0, 50, 0, 50)
LogoBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
LogoBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
LogoBtn.Text = "⚡"
LogoBtn.TextColor3 = Color3.fromRGB(0, 255, 170)
LogoBtn.TextSize = 24
LogoBtn.Font = Enum.Font.SourceSansBold
LogoBtn.Active = true
LogoBtn.Draggable = true
LogoBtn.Parent = ScreenGui

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0.5, 0)
LogoCorner.Parent = LogoBtn

-- Frame Chính
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 370, 0, 340)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Tiêu Đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "🔥 BLOX FRUITS PVP HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Khung Thanh Tab
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 105, 1, -50)
TabBar.Position = UDim2.new(0, 8, 0, 42)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
TabBar.Parent = MainFrame

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 8)
TabCorner.Parent = TabBar

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabBar
TabList.Padding = UDim.new(0, 5)

-- Container Chứa Các Mục
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -127, 1, -50)
Container.Position = UDim2.new(0, 119, 0, 42)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local Pages = {}

local function CreateTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 32)
    tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextSize = 13
    tabBtn.Parent = TabBar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 0, 360)
    page.ScrollBarThickness = 3
    page.Visible = false
    page.Parent = Container

    local pageList = Instance.new("UIListLayout")
    pageList.Parent = page
    pageList.Padding = UDim.new(0, 6)

    Pages[name] = {Button = tabBtn, Page = page}

    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do
            p.Page.Visible = false
            p.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            p.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        page.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
        tabBtn.TextColor3 = Color3.fromRGB(15, 15, 20)
    end)

    return page
end

local AimPage = CreateTab("🎯 Aim & M1")
local VisualPage = CreateTab("👁️ Visuals")
local SpeedPage = CreateTab("⚡ Tốc Độ")

Pages["🎯 Aim & M1"].Page.Visible = true
Pages["🎯 Aim & M1"].Button.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
Pages["🎯 Aim & M1"].Button.TextColor3 = Color3.fromRGB(15, 15, 20)

local function AddToggle(parent, text, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 32)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 180, 120) or Color3.fromRGB(32, 32, 42)
    btn.Text = "  " .. text .. (defaultState and " [ON]" or " [OFF]")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = "  " .. text .. (state and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 120) or Color3.fromRGB(32, 32, 42)
        callback(state)
    end)
end

local function AddInput(parent, placeholder, defaultVal, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -6, 0, 32)
    box.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
    box.PlaceholderText = placeholder
    box.Text = tostring(defaultVal)
    box.TextColor3 = Color3.fromRGB(0, 255, 170)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 13
    box.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = box

    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v then callback(v) end
    end)
end

-- ==========================================
-- 7. NỘI DUNG CÁC TAB
-- ==========================================
-- Tab 1: Aim & M1
AddToggle(AimPage, "Skill Auto Aim", Settings.SkillAimEnabled, function(s) Settings.SkillAimEnabled = s end)
AddToggle(AimPage, "Auto Đánh M1", Settings.AutoM1Enabled, function(s) Settings.AutoM1Enabled = s end)
AddToggle(AimPage, "Không Giới Hạn Distance", Settings.UnlimitedDistance, function(s) Settings.UnlimitedDistance = s end)
AddInput(AimPage, "Khoảng cách Max Distance", Settings.MaxDistance, function(v) Settings.MaxDistance = v end)
AddInput(AimPage, "Bán kính FOV Radius", Settings.FOVRadius, function(v) Settings.FOVRadius = v end)

-- Tab 2: Visuals
AddToggle(VisualPage, "Hiện FOV Tâm Màn Hình", Settings.FOVVisible, function(s) Settings.FOVVisible = s end)
AddToggle(VisualPage, "Đường Kẻ Aim (PvP)", Settings.TracerEnabled, function(s) Settings.TracerEnabled = s end)
AddToggle(VisualPage, "ESP Players (Khung/HP)", Settings.ESPEnabled, function(s) Settings.ESPEnabled = s end)

-- Tab 3: Speed & Jump
AddToggle(SpeedPage, "Bật Chạy Nhanh", Settings.SpeedEnabled, function(s) Settings.SpeedEnabled = s end)
AddInput(SpeedPage, "Tốc độ WalkSpeed", Settings.WalkSpeed, function(v) Settings.WalkSpeed = v end)
AddToggle(SpeedPage, "Bật Nhảy Cao", Settings.JumpEnabled, function(s) Settings.JumpEnabled = s end)
AddInput(SpeedPage, "Lực nhảy JumpPower", Settings.JumpPower, function(v) Settings.JumpPower = v end)

LogoBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ==========================================
-- 8. VÒNG LẶP RENDERSTEPPED
-- ==========================================
RunService.RenderStepped:Connect(function()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local localPvP = IsPvPActive(LocalPlayer)

    FOVCircle.Position = screenCenter
    FOVCircle.Radius = Settings.FOVRadius
    FOVCircle.Visible = Settings.FOVVisible and localPvP

    local target = GetClosestPlayerInFOV()

    -- Tracer Line
    if Settings.TracerEnabled and localPvP and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrpPos = target.Character.HumanoidRootPart.Position
        local screenPos, onScreen = Camera:WorldToViewportPoint(hrpPos)

        if onScreen then
            AimLine.From = screenCenter
            AimLine.To = Vector2.new(screenPos.X, screenPos.Y)
            AimLine.Visible = true
        else
            AimLine.Visible = false
        end
    else
        AimLine.Visible = false
    end

    -- ESP
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

    -- Speed / Jump
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