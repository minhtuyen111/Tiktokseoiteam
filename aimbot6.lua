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
    FOVRadius = 200,
    FOVVisible = true,
    MaxDistance = 600,
    UnlimitedDistance = true,
    TracerEnabled = true,
    ESPEnabled = true,
    WalkSpeed = 32,
    SpeedEnabled = false,
    JumpPower = 100,
    JumpEnabled = false
}

-- ==========================================
-- 2. ĐỒ HỌA DRAWING (MÀU ĐỎ/XANH)
-- ==========================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 60, 60)
FOVCircle.Thickness = 2
FOVCircle.NumSides = 64
FOVCircle.Radius = Settings.FOVRadius
FOVCircle.Filled = false
FOVCircle.Visible = false

local AimLine = Drawing.new("Line")
AimLine.Color = Color3.fromRGB(255, 30, 30)
AimLine.Thickness = 2.5
AimLine.Transparency = 1
AimLine.Visible = false

-- CHECK ĐỐI THỦ CÓ BẬT PVP VÀ KHÔNG TRONG SAFE ZONE
local function IsEligiblePvPTarget(player)
    if not player or not player.Character then return false end
    local char = player.Character

    -- Nếu ở trong Safe Zone -> Không Aim
    if char:FindFirstChild("InSafeZone") and char.InSafeZone.Value == true then
        return false
    end

    -- Kiểm tra cờ PvP
    local pvpValue = player:FindFirstChild("PvP") or player:FindFirstChild("EnablePvP") or char:FindFirstChild("PvP")
    if pvpValue and pvpValue:IsA("BoolValue") then
        return pvpValue.Value
    end

    return true
end

-- ==========================================
-- 3. HỆ THỐNG ESP PLAYERS (MÀU ĐỎ TÔNG XUYỆN TÔNG)
-- ==========================================
local ESPObjects = {}

local function CreateESP(player)
    if player == LocalPlayer then return end

    local box = Drawing.new("Square")
    box.Color = Color3.fromRGB(255, 50, 50)
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
-- 4. HÀM TÌM KẺ ĐỊCH GẦN TÂM MÀN HÌNH NHẤT
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

            if humanoid and humanoid.Health > 0 and IsEligiblePvPTarget(player) then
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
-- 5. CƠ CHẾ FIX AIM MOBILE (EP ANH BẰNG HARD LOCK CAMERA)
-- ==========================================
local isAimingNow = false
local currentAimTarget = nil

local function ForceAimMobile(target)
    if not target or not target.Character then return end
    currentAimTarget = target
    isAimingNow = true

    -- Khóa góc nhìn liên tục trong 0.4s để đè hoàn toàn thao tác chạm ngón tay trên mobile
    task.spawn(function()
        local startTime = tick()
        while tick() - startTime < 0.4 do
            if currentAimTarget and currentAimTarget.Character and currentAimTarget.Character:FindFirstChild("HumanoidRootPart") then
                local targetHRP = currentAimTarget.Character.HumanoidRootPart
                local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                if myHRP then
                    -- 1. Bẻ hướng nhân vật
                    local targetPos = targetHRP.Position
                    myHRP.CFrame = CFrame.new(myHRP.Position, Vector3.new(targetPos.X, myHRP.Position.Y, targetPos.Z))
                    
                    -- 2. Ép Camera nhìn thẳng vào ngực đối thủ (Xóa bỏ điểm chạm cảm ứng)
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHRP.Position + Vector3.new(0, 1.5, 0))
                end
            end
            RunService.RenderStepped:Wait()
        end
        isAimingNow = false
    end)
end

-- Bắt sự kiện bấm Skill / Cảm ứng màn hình
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local k = input.KeyCode
    local inputType = input.UserInputType

    if Settings.SkillAimEnabled and (
       k == Enum.KeyCode.Z or k == Enum.KeyCode.X or 
       k == Enum.KeyCode.C or k == Enum.KeyCode.V or 
       k == Enum.KeyCode.F or inputType == Enum.UserInputType.MouseButton1 or 
       inputType == Enum.UserInputType.Touch) then
        
        local target = GetClosestPlayerInFOV()
        if target then
            ForceAimMobile(target)
        end
    end
end)

-- Vòng lặp Auto M1
task.spawn(function()
    while task.wait(0.08) do
        if Settings.AutoM1Enabled then
            local target = GetClosestPlayerInFOV()
            if target then
                ForceAimMobile(target)
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2))
            end
        end
    end
end)

-- ==========================================
-- 6. GIAO DIỆN MENU MÀU ĐỎ (RED THEME)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxHubRedEdition"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Nút Logo Đóng/Mở (Màu Đỏ)
local LogoBtn = Instance.new("TextButton")
LogoBtn.Size = UDim2.new(0, 50, 0, 50)
LogoBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
LogoBtn.BackgroundColor3 = Color3.fromRGB(35, 10, 10)
LogoBtn.Text = "👹"
LogoBtn.TextSize = 24
LogoBtn.Active = true
LogoBtn.Draggable = true
LogoBtn.Parent = ScreenGui

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0.5, 0)
LogoCorner.Parent = LogoBtn

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(255, 40, 40)
LogoStroke.Thickness = 2
LogoStroke.Parent = LogoBtn

-- Khung Main Frame (Tông Đen Đỏ)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 350)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 14)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(220, 30, 30)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Tiêu Đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "🔥 BLOX FRUITS PVP (RED HUB)"
Title.TextColor3 = Color3.fromRGB(255, 60, 60)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Khung Thanh Tab (Bên trái)
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 105, 1, -50)
TabBar.Position = UDim2.new(0, 8, 0, 42)
TabBar.BackgroundColor3 = Color3.fromRGB(22, 15, 18)
TabBar.Parent = MainFrame

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 8)
TabCorner.Parent = TabBar

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabBar
TabList.Padding = UDim.new(0, 5)

-- Container Chứa Các Tab
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -127, 1, -50)
Container.Position = UDim2.new(0, 119, 0, 42)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local Pages = {}

local function CreateTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 32)
    tabBtn.BackgroundColor3 = Color3.fromRGB(32, 20, 24)
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
    page.CanvasSize = UDim2.new(0, 0, 0, 380)
    page.ScrollBarThickness = 3
    page.Visible = false
    page.Parent = Container

    local pageList = Instance.new("UIListLayout")
    pageList.Parent = page
    pageList.Padding = UDim.new(0, 8)

    Pages[name] = {Button = tabBtn, Page = page}

    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do
            p.Page.Visible = false
            p.Button.BackgroundColor3 = Color3.fromRGB(32, 20, 24)
            p.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        page.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    return page
end

local AimPage = CreateTab("🎯 Aim & M1")
local VisualPage = CreateTab("👁️ Visuals")
local SpeedPage = CreateTab("⚡ Tốc Độ")

Pages["🎯 Aim & M1"].Page.Visible = true
Pages["🎯 Aim & M1"].Button.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
Pages["🎯 Aim & M1"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)

-- NÚT TOGGLE MÀU ĐỎ
local function AddToggle(parent, text, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 32)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(180, 25, 25) or Color3.fromRGB(35, 25, 28)
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
        btn.BackgroundColor3 = state and Color3.fromRGB(180, 25, 25) or Color3.fromRGB(35, 25, 28)
        callback(state)
    end)
end

-- THANH SLIDER KÉO MÀU ĐỎ
local function AddSlider(parent, text, minVal, maxVal, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -8, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(35, 25, 28)
    frame.Parent = parent

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 6)
    frameCorner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(defaultVal)
    label.TextColor3 = Color3.fromRGB(255, 80, 80)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -10, 0, 8)
    sliderBg.Position = UDim2.new(0, 5, 0, 26)
    sliderBg.BackgroundColor3 = Color3.fromRGB(20, 15, 18)
    sliderBg.Parent = frame

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 4)
    bgCorner.Parent = sliderBg

    local fill = Instance.new("Frame")
    local startFactor = (defaultVal - minVal) / (maxVal - minVal)
    fill.Size = UDim2.new(startFactor, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
    fill.Parent = sliderBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill

    local dragging = false
    local function UpdateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(minVal + (maxVal - minVal) * pos)
        label.Text = text .. ": " .. tostring(val)
        callback(val)
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateSlider(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ==========================================
-- 7. CÀI ĐẶT NỘI DUNG MENU
-- ==========================================
-- Tab 1: Aim & M1
AddToggle(AimPage, "Skill Auto Aim", Settings.SkillAimEnabled, function(s) Settings.SkillAimEnabled = s end)
AddToggle(AimPage, "Auto Đánh M1", Settings.AutoM1Enabled, function(s) Settings.AutoM1Enabled = s end)
AddToggle(AimPage, "Không Giới Hạn Distance", Settings.UnlimitedDistance, function(s) Settings.UnlimitedDistance = s end)
AddSlider(AimPage, "Khoảng cách Max Distance", 100, 2000, Settings.MaxDistance, function(v) Settings.MaxDistance = v end)
AddSlider(AimPage, "Bán kính FOV Radius", 50, 400, Settings.FOVRadius, function(v) Settings.FOVRadius = v end)

-- Tab 2: Visuals
AddToggle(VisualPage, "Hiện FOV Tâm Màn Hình", Settings.FOVVisible, function(s) Settings.FOVVisible = s end)
AddToggle(VisualPage, "Đường Kẻ Aim (PvP)", Settings.TracerEnabled, function(s) Settings.TracerEnabled = s end)
AddToggle(VisualPage, "ESP Players (Khung/HP)", Settings.ESPEnabled, function(s) Settings.ESPEnabled = s end)

-- Tab 3: Speed & Jump
AddToggle(SpeedPage, "Bật Chạy Nhanh", Settings.SpeedEnabled, function(s) Settings.SpeedEnabled = s end)
AddSlider(SpeedPage, "Tốc độ WalkSpeed", 16, 250, Settings.WalkSpeed, function(v) Settings.WalkSpeed = v end)
AddToggle(SpeedPage, "Bật Nhảy Cao", Settings.JumpEnabled, function(s) Settings.JumpEnabled = s end)
AddSlider(SpeedPage, "Lực nhảy JumpPower", 50, 300, Settings.JumpPower, function(v) Settings.JumpPower = v end)

LogoBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ==========================================
-- 8. VÒNG LẶP RENDERSTEPPED CẬP NHẬT
-- ==========================================
RunService.RenderStepped:Connect(function()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    FOVCircle.Position = screenCenter
    FOVCircle.Radius = Settings.FOVRadius
    FOVCircle.Visible = Settings.FOVVisible

    local target = GetClosestPlayerInFOV()

    -- Tracer Line (Chỉ hiện khi đối thủ Bật PvP VÀ Không trong Safe Zone)
    if Settings.TracerEnabled and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
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

    -- Cập nhật ESP Players
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

    -- Cập nhật WalkSpeed & JumpPower
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