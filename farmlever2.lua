-- [[ BLOX FRUITS ULTRA HUB PRO - FIX ALL ISSUES ]] --
-- Tốc độ bay 300 | Anti-Kick Noclip | Gôm Quái | Tầm Đánh Phật Tổ | Auto Stats

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
end)

--------------------------------------------------------------------------------
-- 1. CẤU HÌNH DỮ LIỆU ĐẢO & BẢNG NHIỆM VỤ
--------------------------------------------------------------------------------
local QuestData = {
    -- SEA 1
    {MinLv = 1, MaxLv = 14, Island = "Starter Island", MobName = "Bandit", MobPos = Vector3.new(1145, 17, 1634), SpawnPos = Vector3.new(1060, 16, 1547)},
    {MinLv = 15, MaxLv = 29, Island = "Jungle", MobName = "Monkey", MobPos = Vector3.new(-1496, 37, 368), SpawnPos = Vector3.new(-1600, 36, 153)},
    {MinLv = 30, MaxLv = 59, Island = "Pirate Village", MobName = "Pirate", MobPos = Vector3.new(-1210, 4, 3850), SpawnPos = Vector3.new(-1140, 4, 3828)},
    {MinLv = 60, MaxLv = 89, Island = "Desert", MobName = "Desert Bandit", MobPos = Vector3.new(900, 6, 4300), SpawnPos = Vector3.new(894, 6, 4390)},
    {MinLv = 90, MaxLv = 119, Island = "Snow Island", MobName = "Snow Bandit", MobPos = Vector3.new(1280, 106, -1400), SpawnPos = Vector3.new(1385, 87, -1298)},
    {MinLv = 120, MaxLv = 699, Island = "Marine Ford", MobName = "Chief Petty Officer", MobPos = Vector3.new(-4800, 20, 4300), SpawnPos = Vector3.new(-5030, 20, 4320)},
    
    -- SEA 2
    {MinLv = 700, MaxLv = 1499, Island = "Kingdom of Rose", MobName = "Raider", MobPos = Vector3.new(-450, 73, 3000), SpawnPos = Vector3.new(-425, 73, 2900)},
    
    -- SEA 3 (Max Lv 2800)
    {MinLv = 1500, MaxLv = 2800, Island = "Chocolate Land", MobName = "Cocoa Warrior", MobPos = Vector3.new(200, 50, -12000), SpawnPos = Vector3.new(150, 50, -12100)}
}

local Config = {
    AutoFarm = false,
    SelectedWeapon = "Melee",
    FlySpeed = 300, -- Tốc độ bay an toàn chống kick
    BringMob = true, -- Gôm quái
    BigHitbox = true, -- Bug tầm đánh Phật Tổ
    AutoStats = false,
    StatType = "Melee" -- "Melee", "Defense", "Sword", "Demon Fruit"
}

--------------------------------------------------------------------------------
-- 2. GIAO DIỆN CHUẨN 16:9 - PHONG CÁCH IOS 26
--------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Blox169HubPro"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Logo Toggle Button
local LogoBtn = Instance.new("TextButton")
LogoBtn.Size = UDim2.new(0, 50, 0, 50)
LogoBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
LogoBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
LogoBtn.Text = ""
LogoBtn.TextColor3 = Color3.fromRGB(0, 210, 255)
LogoBtn.TextSize = 28
LogoBtn.Font = Enum.Font.FredokaOne
LogoBtn.Active = true
LogoBtn.Draggable = true
LogoBtn.Parent = ScreenGui
Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(0, 15)

-- Main Frame 16:9
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 560, 0, 315)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -157)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.BackgroundTransparency = 0.15
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "BLOX FRUITS AUTOMATION 16:9 PRO"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(0.92, 0, 0.78, 0)
Scroll.Position = UDim2.new(0.04, 0, 0.16, 0)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 420)
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 210, 255)
Scroll.Parent = MainFrame

local UIList = Instance.new("UIListLayout", Scroll)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)

local function CreateToggle(text, defaultState, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -10, 0, 42)
    Container.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Container.Parent = Scroll
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0.04, 0, 0, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(240, 240, 240)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.BackgroundTransparency = 1
    Label.Parent = Container

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 90, 0, 28)
    Btn.Position = UDim2.new(0.96, -90, 0.5, -14)
    Btn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(60, 60, 75)
    Btn.Text = defaultState and "ON" or "OFF"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 11
    Btn.Parent = Container
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    local toggled = defaultState
    Btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        Btn.Text = toggled and "ON" or "OFF"
        Btn.BackgroundColor3 = toggled and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(60, 60, 75)
        callback(toggled)
    end)
end

LogoBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

--------------------------------------------------------------------------------
-- 3. HỆ THỐNG BAY TWEEN 300 STUDS & NOCLIP XUYÊN VẬT CẢN
--------------------------------------------------------------------------------
local isTweening = false

-- Noclip xuyên tường khi bay
RunService.Stepped:Connect(function()
    if isTweening and Character then
        for _, part in pairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

local function TweenFlyTo(targetPos, callback)
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local HRP = Character.HumanoidRootPart
    local distance = (HRP.Position - targetPos).Magnitude
    
    -- Nếu gần bãi thì chuyển trực tiếp, xa thì bay Tween
    if distance < 50 then
        HRP.CFrame = CFrame.new(targetPos)
        if callback then callback() end
        return
    end

    isTweening = true
    local timeToFly = distance / Config.FlySpeed
    local tweenInfo = TweenInfo.new(timeToFly, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(HRP, tweenInfo, {CFrame = CFrame.new(targetPos)})
    
    tween:Play()
    tween.Completed:Connect(function()
        isTweening = false
        if callback then callback() end
    end)
end

--------------------------------------------------------------------------------
-- 4. SMART ISLAND & MAX LEVEL CHECK
--------------------------------------------------------------------------------
local function GetSmartQuestData()
    local levelData = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level")
    local currentLv = levelData and levelData.Value or 1

    -- Tự tìm đảo cao nhất trong Sea hiện tại nếu Max Level
    local highestDataInSea = QuestData[1]
    for _, data in ipairs(QuestData) do
        if currentLv >= data.MinLv then
            highestDataInSea = data
        end
    end
    return highestDataInSea
end

--------------------------------------------------------------------------------
-- 5. AUTO SET SPAWN POINT (LƯU ĐIỂM HỒI SINH)
--------------------------------------------------------------------------------
local lastSpawnSaved = ""

local function AutoSaveSpawn(qData)
    if lastSpawnSaved ~= qData.Island then
        TweenFlyTo(qData.SpawnPos, function()
            -- Giả lập gọi Event lưu điểm hồi sinh của Game
            local setSpawnEvent = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if setSpawnEvent then
                setSpawnEvent:InvokeServer("SetSpawnPoint")
            end
            lastSpawnSaved = qData.Island
        end)
    end
end

--------------------------------------------------------------------------------
-- 6. MOB MAGNET & BUG HITBOX PHẬT TỔ (REACH)
--------------------------------------------------------------------------------

-- Bug tầm đánh siêu rộng (Tầm đánh Phật Tổ)
RunService.RenderStepped:Connect(function()
    if Config.BigHitbox and Character then
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            tool.Handle.Size = Vector3.new(50, 50, 50) -- Tầm đánh Trái Phật
            tool.Handle.Transparency = 0.8
            tool.Handle.CanCollide = false
        end
    end
end)

-- Gôm 3-4 con quái lại một chỗ
local function MagnetEnemies(qData, mainMob)
    if not Config.BringMob then return end
    local enemies = workspace:FindFirstChild("Enemies") or workspace
    local count = 0
    
    for _, mob in pairs(enemies:GetChildren()) do
        if mob.Name == qData.MobName and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            if (mob.HumanoidRootPart.Position - mainMob.HumanoidRootPart.Position).Magnitude < 300 then
                mob.HumanoidRootPart.CFrame = mainMob.HumanoidRootPart.CFrame
                mob.HumanoidRootPart.CanCollide = false
                count = count + 1
                if count >= 4 then break end -- Tối đa gôm 4 con
            end
        end
    end
end

--------------------------------------------------------------------------------
-- 7. AUTO STATS & VÒNG LẶP AUTO FARM CHÍNH
--------------------------------------------------------------------------------

-- Auto Nâng Chỉ Số
task.spawn(function()
    while task.wait(1) do
        if Config.AutoStats then
            local statEvent = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if statEvent then
                statEvent:InvokeServer("AddPoint", Config.StatType, 3)
            end
        end
    end
end)

-- Nút điều khiển Menu
CreateToggle("Auto Farm (Max Level Check)", false, function(s) Config.AutoFarm = s end)
CreateToggle("Auto Gôm Quái (Mob Magnet)", true, function(s) Config.BringMob = s end)
CreateToggle("Bug Tầm Đánh Phật Tổ", true, function(s) Config.BigHitbox = s end)
CreateToggle("Auto Nâng Điểm Stats", false, function(s) Config.AutoStats = s end)

-- Vòng lặp Farm chính
RunService.Stepped:Connect(function()
    if not Config.AutoFarm or isTweening then return end
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end

    local qData = GetSmartQuestData()
    
    -- Step 1: Auto Lưu Spawn
    AutoSaveSpawn(qData)

    -- Step 2: Tìm quái
    local targetMob = nil
    local enemies = workspace:FindFirstChild("Enemies") or workspace
    for _, mob in pairs(enemies:GetChildren()) do
        if mob.Name == qData.MobName and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
            targetMob = mob
            break
        end
    end

    -- Step 3: Tấn công hoặc Di chuyển
    if targetMob then
        -- Gôm quái
        MagnetEnemies(qData, targetMob)

        -- Giữ vị trí phía trên đầu quái 7 Studs
        Character.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0) * CFrame.Angles(math.rad(-90), 0, 0)
        
        -- Auto Click đánh
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
    else
        -- Bay tới khu vực quái nếu chưa có quái xuất hiện
        TweenFlyTo(qData.MobPos)
    end
end)