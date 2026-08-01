-- [[ BLOX FRUITS AUTO FARM - ULTRA HUB 16:9 ]] --
-- Tự động Farm Lv1 - 2800 | Auto Quest | Auto Teleport | Chọn Vũ Khí

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Cập nhật Character khi Respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
end)

--------------------------------------------------------------------------------
-- 1. CẤU HÌNH DỮ LIỆU ĐẢO & NHIỆM VỤ (LV 1 -> 2800)
--------------------------------------------------------------------------------
local QuestData = {
    -- SEA 1
    {MinLv = 1, MaxLv = 14, Island = "Starter Island", QuestNPC = "Bandit Quest Giver", QuestName = "BanditQuest1", MobName = "Bandit", MobPos = Vector3.new(1145, 17, 1634), NPCPos = Vector3.new(1060, 16, 1547)},
    {MinLv = 15, MaxLv = 29, Island = "Jungle", QuestNPC = "Jungle Quest Giver", QuestName = "JungleQuest", MobName = "Monkey", MobPos = Vector3.new(-1496, 37, 368), NPCPos = Vector3.new(-1600, 36, 153)},
    {MinLv = 30, MaxLv = 59, Island = "Pirate Village", QuestNPC = "Pirate Quest Giver", QuestName = "PirateQuest", MobName = "Pirate", MobPos = Vector3.new(-1210, 4, 3850), NPCPos = Vector3.new(-1140, 4, 3828)},
    {MinLv = 60, MaxLv = 89, Island = "Desert", QuestNPC = "Desert Quest Giver", QuestName = "DesertQuest", MobName = "Desert Bandit", MobPos = Vector3.new(900, 6, 4300), NPCPos = Vector3.new(894, 6, 4390)},
    {MinLv = 90, MaxLv = 119, Island = "Snow Island", QuestNPC = "Snow Quest Giver", QuestName = "SnowQuest", MobName = "Snow Bandit", MobPos = Vector3.new(1280, 106, -1400), NPCPos = Vector3.new(1385, 87, -1298)},
    {MinLv = 120, MaxLv = 699, Island = "Marine Ford", QuestNPC = "Marine Quest Giver", QuestName = "MarineQuest", MobName = "Chief Petty Officer", MobPos = Vector3.new(-4800, 20, 4300), NPCPos = Vector3.new(-5030, 20, 4320)},
    
    -- SEA 2 (Mẫu mở rộng)
    {MinLv = 700, MaxLv = 1499, Island = "Cafe / Kingdom of Rose", QuestNPC = "Area 1 Quest Giver", QuestName = "Area1Quest", MobName = "Raider", MobPos = Vector3.new(-450, 73, 3000), NPCPos = Vector3.new(-425, 73, 2900)},
    
    -- SEA 3 (Mẫu mở rộng lên Lv 2800)
    {MinLv = 1500, MaxLv = 2800, Island = "Port Town / Chocolate Land", QuestNPC = "Chocolate Quest Giver", QuestName = "ChocoQuest", MobName = "Cocoa Warrior", MobPos = Vector3.new(200, 50, -12000), NPCPos = Vector3.new(150, 50, -12100)}
}

local Config = {
    AutoFarm = false,
    SelectedWeapon = "Melee", -- "Melee", "Sword", "Blox Fruit"
    DistanceAboveMob = 7 -- Khoảng cách treo trên đầu quái
}

--------------------------------------------------------------------------------
-- 2. TẠO GIAO DIỆN CHUẨN TỈ LỆ 16:9 VỚI LOGO TẮT/MỞ
--------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruits16_9Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Logo Nút Tắt/Mở Floating Button
local LogoBtn = Instance.new("TextButton")
LogoBtn.Size = UDim2.new(0, 50, 0, 50)
LogoBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
LogoBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
LogoBtn.Text = "⚡"
LogoBtn.TextColor3 = Color3.fromRGB(0, 210, 255)
LogoBtn.TextSize = 26
LogoBtn.Font = Enum.Font.FredokaOne
LogoBtn.Active = true
LogoBtn.Draggable = true
LogoBtn.Parent = ScreenGui

Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(0, 15)
local LogoStroke = Instance.new("UIStroke", LogoBtn)
LogoStroke.Color = Color3.fromRGB(0, 210, 255)
LogoStroke.Thickness = 2

-- Khung Khung Chính Tỉ Lệ 16:9
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 560, 0, 315) -- Chuẩn tỉ lệ 16:9 (560x315)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -157)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.BackgroundTransparency = 0.15
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)
local FrameStroke = Instance.new("UIStroke", MainFrame)
FrameStroke.Color = Color3.fromRGB(255, 255, 255)
FrameStroke.Transparency = 0.85

-- Tiêu Đề Menu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "BLOX FRUITS AUTO FARM - 16:9 HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- ScrollView
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(0.92, 0, 0.8, 0)
Scroll.Position = UDim2.new(0.04, 0, 0.15, 0)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 350)
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 210, 255)
Scroll.Parent = MainFrame

local UIList = Instance.new("UIListLayout", Scroll)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 10)

-- Hàm tạo Nút Bật/Tắt
local function CreateToggle(text, defaultState, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -10, 0, 45)
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
    Label.TextSize = 13
    Label.BackgroundTransparency = 1
    Label.Parent = Container

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 100, 0, 30)
    Btn.Position = UDim2.new(0.96, -100, 0.5, -15)
    Btn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(60, 60, 75)
    Btn.Text = defaultState and "ON" or "OFF"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
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

-- Bật/Tắt Menu bằng Logo
LogoBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

--------------------------------------------------------------------------------
-- 3. CÁC NÚT TÍNH NĂNG ĐIỀU KHIỂN
--------------------------------------------------------------------------------

-- Nút Bật/Tắt Auto Farm
CreateToggle("Auto Farm Lv1 - 2800", false, function(state)
    Config.AutoFarm = state
end)

-- Nút Chọn Vũ Khí Farm (Melee / Sword / Fruit)
local WeaponBtnContainer = Instance.new("Frame")
WeaponBtnContainer.Size = UDim2.new(1, -10, 0, 45)
WeaponBtnContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
WeaponBtnContainer.Parent = Scroll
Instance.new("UICorner", WeaponBtnContainer).CornerRadius = UDim.new(0, 8)

local WeaponLabel = Instance.new("TextLabel")
WeaponLabel.Size = UDim2.new(0.4, 0, 1, 0)
WeaponLabel.Position = UDim2.new(0.04, 0, 0, 0)
WeaponLabel.Text = "Vũ Khí Farm:"
WeaponLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
WeaponLabel.TextXAlignment = Enum.TextXAlignment.Left
WeaponLabel.Font = Enum.Font.GothamMedium
WeaponLabel.TextSize = 13
WeaponLabel.BackgroundTransparency = 1
WeaponLabel.Parent = WeaponBtnContainer

local WeaponSelectBtn = Instance.new("TextButton")
WeaponSelectBtn.Size = UDim2.new(0, 140, 0, 30)
WeaponSelectBtn.Position = UDim2.new(0.96, -140, 0.5, -15)
WeaponSelectBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 230)
WeaponSelectBtn.Text = Config.SelectedWeapon
WeaponSelectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
WeaponSelectBtn.Font = Enum.Font.GothamBold
WeaponSelectBtn.TextSize = 12
WeaponSelectBtn.Parent = WeaponBtnContainer
Instance.new("UICorner", WeaponSelectBtn).CornerRadius = UDim.new(0, 6)

local weaponTypes = {"Melee", "Sword", "Blox Fruit"}
local currentWeaponIndex = 1

WeaponSelectBtn.MouseButton1Click:Connect(function()
    currentWeaponIndex = (currentWeaponIndex % #weaponTypes) + 1
    Config.SelectedWeapon = weaponTypes[currentWeaponIndex]
    WeaponSelectBtn.Text = Config.SelectedWeapon
end)

--------------------------------------------------------------------------------
-- 4. LOGIC HỆ THỐNG AUTO FARM & TELEPORT
--------------------------------------------------------------------------------

-- Hàm lấy thông tin đảo phù hợp với Level hiện tại
local function GetCurrentQuestData()
    local levelData = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level")
    local currentLv = levelData and levelData.Value or 1

    for _, data in ipairs(QuestData) do
        if currentLv >= data.MinLv and currentLv <= data.MaxLv then
            return data
        end
    end
    return QuestData[#QuestData]
end

-- Hàm Tự Động Trang Bị Vũ Khí Đã Chọn
local function EquipWeapon()
    if not Character then return end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return end

    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            if Config.SelectedWeapon == "Melee" and item.ToolTip == "Melee" then
                Character.Humanoid:EquipTool(item)
            elseif Config.SelectedWeapon == "Sword" and item.ToolTip == "Sword" then
                Character.Humanoid:EquipTool(item)
            elseif Config.SelectedWeapon == "Blox Fruit" and item.ToolTip == "Blox Fruit" then
                Character.Humanoid:EquipTool(item)
            end
        end
    end
end

-- Hàm Teleport An Toàn Tới Vị Trí Chỉ Định
local function TeleportTo(targetCFrame)
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CFrame = targetCFrame
    end
end

-- Vòng Lặp Chính Xử Lý Auto Farm
RunService.Stepped:Connect(function()
    if not Config.AutoFarm then return end
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end

    local qData = GetCurrentQuestData()
    EquipWeapon()

    -- Tim quái trong Workspace
    local targetMob = nil
    local enemiesFolder = workspace:FindFirstChild("Enemies") or workspace

    for _, mob in pairs(enemiesFolder:GetChildren()) do
        if mob.Name == qData.MobName and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
            targetMob = mob
            break
        end
    end

    if targetMob then
        -- Treo lơ lửng trên đầu quái để đánh an toàn
        TeleportTo(targetMob.HumanoidRootPart.CFrame * CFrame.new(0, Config.DistanceAboveMob, 0) * CFrame.Angles(math.rad(-90), 0, 0))
        
        -- Kích hoạt đòn đánh (Click/Tap)
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
    else
        -- Nếu không thấy quái, Teleport tới bãi quái chờ Spawns
        TeleportTo(CFrame.new(qData.MobPos))
    end
end)