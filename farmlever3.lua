-- [[ BLOX FRUITS ULTRA HUB PRO - FULL COMPLETE EDITION ]] --
-- Full Data Sea 1, Sea 2, Sea 3 (Lv 1 -> 2800)
-- Remote CommF_ Official | Auto Quest | Fast Tween Fly 300 | Mob Magnet | Big Hitbox | Auto Stats

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
end)

--------------------------------------------------------------------------------
-- 1. FULL DỮ LIỆU TẮT CẢ CÁC ĐẢO & QUEST CỦA BLOX FRUITS (LV 1 -> 2800)
--------------------------------------------------------------------------------
local LevelData = {
    -- ==================== SEA 1 (WORLD 1) ====================
    {Min = 1, Max = 14, Quest = "BanditQuest1", LevelReq = 1, Mob = "Bandit", NPCPos = Vector3.new(1059, 16, 1549), MobPos = Vector3.new(1145, 17, 1634)},
    {Min = 15, Max = 29, Quest = "JungleQuest", LevelReq = 1, Mob = "Monkey", NPCPos = Vector3.new(-1598, 36, 153), MobPos = Vector3.new(-1496, 37, 368)},
    {Min = 30, Max = 39, Quest = "JungleQuest", LevelReq = 2, Mob = "Gorilla", NPCPos = Vector3.new(-1598, 36, 153), MobPos = Vector3.new(-1240, 6, 500)},
    {Min = 40, Max = 59, Quest = "PirateQuest", LevelReq = 1, Mob = "Pirate", NPCPos = Vector3.new(-1140, 4, 3828), MobPos = Vector3.new(-1210, 4, 3850)},
    {Min = 60, Max = 89, Quest = "DesertQuest", LevelReq = 1, Mob = "Desert Bandit", NPCPos = Vector3.new(894, 6, 4390), MobPos = Vector3.new(900, 6, 4300)},
    {Min = 90, Max = 119, Quest = "SnowQuest", LevelReq = 1, Mob = "Snow Bandit", NPCPos = Vector3.new(1385, 87, -1298), MobPos = Vector3.new(1280, 106, -1400)},
    {Min = 120, Max = 149, Quest = "MarineQuest2", LevelReq = 1, Mob = "Chief Petty Officer", NPCPos = Vector3.new(-5030, 20, 4320), MobPos = Vector3.new(-4800, 20, 4300)},
    {Min = 150, Max = 189, Quest = "SkyQuest", LevelReq = 1, Mob = "Sky Bandit", NPCPos = Vector3.new(-4840, 718, -2620), MobPos = Vector3.new(-4980, 718, -2800)},
    {Min = 190, Max = 224, Quest = "PrisonerQuest", LevelReq = 1, Mob = "Prisoner", NPCPos = Vector3.new(530, 2, 470), MobPos = Vector3.new(480, 2, 580)},
    {Min = 225, Max = 299, Quest = "ColosseumQuest", LevelReq = 1, Mob = "Toga Warrior", NPCPos = Vector3.new(-1580, 7, -2980), MobPos = Vector3.new(-1700, 7, -3200)},
    {Min = 300, Max = 374, Quest = "MagmaQuest", LevelReq = 1, Mob = "Military Soldier", NPCPos = Vector3.new(-5310, 12, 8515), MobPos = Vector3.new(-5400, 12, 8700)},
    {Min = 375, Max = 449, Quest = "FishmanQuest", LevelReq = 1, Mob = "Fishman Warrior", NPCPos = Vector3.new(61120, 18, 1560), MobPos = Vector3.new(61000, 18, 1200)},
    {Min = 450, Max = 524, Quest = "SkyExp1Quest", LevelReq = 1, Mob = "God's Guard", NPCPos = Vector3.new(-4720, 845, -1950), MobPos = Vector3.new(-4700, 845, -2200)},
    {Min = 525, Max = 624, Quest = "SkyExp2Quest", LevelReq = 1, Mob = "Shandia War", NPCPos = Vector3.new(-7900, 5545, -3800), MobPos = Vector3.new(-7800, 5545, -3600)},
    {Min = 625, Max = 699, Quest = "FountainQuest", LevelReq = 1, Mob = "Corporal", NPCPos = Vector3.new(5250, 38, 4050), MobPos = Vector3.new(5100, 38, 4100)},

    -- ==================== SEA 2 (WORLD 2) ====================
    {Min = 700, Max = 774, Quest = "Area1Quest", LevelReq = 1, Mob = "Raider", NPCPos = Vector3.new(-425, 73, 2900), MobPos = Vector3.new(-450, 73, 3000)},
    {Min = 775, Max = 874, Quest = "Area2Quest", LevelReq = 1, Mob = "Mercenary", NPCPos = Vector3.new(630, 73, 920), MobPos = Vector3.new(800, 73, 1000)},
    {Min = 875, Max = 949, Quest = "GraveQuest", LevelReq = 1, Mob = "Zombie", NPCPos = Vector3.new(920, 6, -1940), MobPos = Vector3.new(1000, 6, -1800)},
    {Min = 950, Max = 999, Quest = "SnowMountainQuest", LevelReq = 1, Mob = "Snow Trooper", NPCPos = Vector3.new(610, 400, -5370), MobPos = Vector3.new(500, 400, -5500)},
    {Min = 1000, Max = 1099, Quest = "ColdQuest", LevelReq = 1, Mob = "Lab Subordinate", NPCPos = Vector3.new(-6060, 16, -4900), MobPos = Vector3.new(-5800, 16, -4800)},
    {Min = 1100, Max = 1174, Quest = "CursedQuest", LevelReq = 1, Mob = "Ship Deckhand", NPCPos = Vector3.new(910, 125, 33000), MobPos = Vector3.new(1000, 125, 32900)},
    {Min = 1175, Max = 1249, Quest = "IceSideQuest", LevelReq = 1, Mob = "Arctic Warrior", NPCPos = Vector3.new(5980, 28, -6120), MobPos = Vector3.new(6100, 28, -6000)},
    {Min = 1250, Max = 1349, Quest = "FireSideQuest", LevelReq = 1, Mob = "Magma Ninja", NPCPos = Vector3.new(-5430, 16, -5290), MobPos = Vector3.new(-5300, 16, -5500)},
    {Min = 1350, Max = 1499, Quest = "ShipQuest", LevelReq = 1, Mob = "Ship Engineer", NPCPos = Vector3.new(910, 125, 33000), MobPos = Vector3.new(1200, 125, 33000)},

    -- ==================== SEA 3 (WORLD 3) ====================
    {Min = 1500, Max = 1574, Quest = "PortTownQuest", LevelReq = 1, Mob = "Pirate Millionaire", NPCPos = Vector3.new(-290, 7, 5300), MobPos = Vector3.new(-350, 7, 5500)},
    {Min = 1575, Max = 1699, Quest = "HydraTownQuest", LevelReq = 1, Mob = "Dragon Crew Warrior", NPCPos = Vector3.new(5800, 1000, -300), MobPos = Vector3.new(6000, 1000, -400)},
    {Min = 1700, Max = 1799, Quest = "GreatTreeQuest", LevelReq = 1, Mob = "Marine Commodore", NPCPos = Vector3.new(2180, 28, -6740), MobPos = Vector3.new(2300, 28, -6900)},
    {Min = 1800, Max = 1899, Quest = "FloatingTurtleQuest", LevelReq = 1, Mob = "Fishman Captain", NPCPos = Vector3.new(-10490, 330, -8800), MobPos = Vector3.new(-10700, 330, -8900)},
    {Min = 1900, Max = 1999, Quest = "CastleQuest", LevelReq = 1, Mob = "Forest Pirate", NPCPos = Vector3.new(-5030, 315, -3150), MobPos = Vector3.new(-5200, 315, -3300)},
    {Min = 2000, Max = 2249, Quest = "HauntedQuest1", LevelReq = 1, Mob = "Reborn Skeleton", NPCPos = Vector3.new(-9515, 172, 6070), MobPos = Vector3.new(-9700, 172, 6100)},
    {Min = 2250, Max = 2449, Quest = "ChocoQuest1", LevelReq = 1, Mob = "Cocoa Warrior", NPCPos = Vector3.new(150, 50, -12100), MobPos = Vector3.new(200, 50, -12000)},
    {Min = 2450, Max = 2800, Quest = "TikiQuest1", LevelReq = 1, Mob = "Isle Outlaw", NPCPos = Vector3.new(-16300, 10, 400), MobPos = Vector3.new(-16500, 10, 600)}
}

local Config = {
    AutoFarm = false,
    FlySpeed = 300,
    BringMob = true,
    BigHitbox = true,
    AutoStats = false,
    StatType = "Melee", -- "Melee", "Defense", "Sword", "Demon Fruit"
    SelectedWeapon = "Melee"
}

--------------------------------------------------------------------------------
-- 2. HÀM CHECK CẤP ĐỘ VÀ KIỂM TRA SEA BẢO VỆ
--------------------------------------------------------------------------------
local function GetMyLevel()
    local data = LocalPlayer:FindFirstChild("Data")
    if data and data:FindFirstChild("Level") then
        return data.Level.Value
    end
    return 1
end

local function GetSmartQuestInfo()
    local myLv = GetMyLevel()
    local currentSelected = LevelData[1]

    for _, info in ipairs(LevelData) do
        if myLv >= info.Min then
            currentSelected = info
        end
    end
    return currentSelected
end

local function HasQuest()
    local questUI = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
    return questUI and questUI.Visible
end

--------------------------------------------------------------------------------
-- 3. HỆ THỐNG BAY FAST TWEEN (300 STUDS) + ANTI-KICK NOCLIP
--------------------------------------------------------------------------------
local isFlying = false

RunService.Stepped:Connect(function()
    if isFlying and Character then
        for _, part in pairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

local function FastFly(targetPos, onComplete)
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local HRP = Character.HumanoidRootPart
    local dist = (HRP.Position - targetPos).Magnitude

    if dist < 25 then
        HRP.CFrame = CFrame.new(targetPos)
        if onComplete then onComplete() end
        return
    end

    isFlying = true
    local tweenInfo = TweenInfo.new(dist / Config.FlySpeed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(HRP, tweenInfo, {CFrame = CFrame.new(targetPos)})
    
    tween:Play()
    tween.Completed:Connect(function()
        isFlying = false
        if onComplete then onComplete() end
    end)
end

--------------------------------------------------------------------------------
-- 4. TỰ ĐỘNG LƯU SPAWN & NHẬN QUEST CHUẨN REMOTE COMMF_
--------------------------------------------------------------------------------
local function TakeQuest(questData)
    pcall(function()
        CommF:InvokeServer("StartQuest", questData.Quest, questData.LevelReq)
        CommF:InvokeServer("SetSpawnPoint")
    end)
end

--------------------------------------------------------------------------------
-- 5. GIAO DIỆN CHUẨN 16:9 & PHONG CÁCH IOS 26
--------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Blox169FullHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Nút Logo Nổi Mobile
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

-- Frame 16:9
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
Title.Text = "BLOX FRUITS FULL AUTOMATION (LV 1 - 2800)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(0.92, 0, 0.8, 0)
Scroll.Position = UDim2.new(0.04, 0, 0.15, 0)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 360)
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
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
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

LogoBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

--------------------------------------------------------------------------------
-- 6. TẠO CÁC NÚT ĐIỀU KHIỂN & CHỌN STATS
--------------------------------------------------------------------------------
CreateToggle("Auto Farm + Auto Level 1 - 2800", false, function(s) Config.AutoFarm = s end)
CreateToggle("Auto Gôm Quái 3-4 Con (Mob Magnet)", true, function(s) Config.BringMob = s end)
CreateToggle("Bug Tầm Đánh Siêu Rộng (Phật Tổ)", true, function(s) Config.BigHitbox = s end)
CreateToggle("Auto Nâng Điểm Chỉ Số (Stats)", false, function(s) Config.AutoStats = s end)

--------------------------------------------------------------------------------
-- 7. VÒNG LẶP NÂNG STATS & BUG HITBOX TRÁI PHẬT
--------------------------------------------------------------------------------

-- Auto Stats
task.spawn(function()
    while task.wait(1) do
        if Config.AutoStats then
            pcall(function()
                CommF:InvokeServer("AddPoint", Config.StatType, 3)
            end)
        end
    end
end)

-- Bug Hitbox Phật Tổ
RunService.RenderStepped:Connect(function()
    if Config.BigHitbox and Character then
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            tool.Handle.Size = Vector3.new(50, 50, 50)
            tool.Handle.Transparency = 0.8
            tool.Handle.CanCollide = false
        end
    end
end)

--------------------------------------------------------------------------------
-- 8. VÒNG LẶP CHIẾN ĐẤU CHÍNH (MAIN AUTOMATION)
--------------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if Config.AutoFarm and not isFlying and Character and Character:FindFirstChild("HumanoidRootPart") then
            local qData = GetSmartQuestInfo()

            -- Buớc 1: Chưa nhận nhiệm vụ -> Bay tới NPC lấy Quest & Lưu Spawn
            if not HasQuest() then
                FastFly(qData.NPCPos, function()
                    TakeQuest(qData)
                    task.wait(0.5)
                end)
            else
                -- Bước 2: Đã có Quest -> Bay tới đánh quái
                local targetMob = nil
                local enemies = workspace:FindFirstChild("Enemies") or workspace

                for _, mob in pairs(enemies:GetChildren()) do
                    if mob.Name == qData.Mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                        targetMob = mob
                        break
                    end
                end

                if targetMob then
                    -- Gôm quái xung quanh
                    if Config.BringMob then
                        local count = 0
                        for _, mob in pairs(enemies:GetChildren()) do
                            if mob.Name == qData.Mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                                if (mob.HumanoidRootPart.Position - targetMob.HumanoidRootPart.Position).Magnitude < 300 then
                                    mob.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame
                                    mob.HumanoidRootPart.CanCollide = false
                                    count = count + 1
                                    if count >= 4 then break end
                                end
                            end
                        end
                    end

                    -- Neo nhân vật phía trên đầu quái
                    Character.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    
                    -- Trang bị vũ khí và tự đánh
                    local tool = Character:FindFirstChildOfClass("Tool")
                    if not tool then
                        local backpack = LocalPlayer:FindFirstChild("Backpack")
                        if backpack and #backpack:GetChildren() > 0 then
                            Character.Humanoid:EquipTool(backpack:GetChildren()[1])
                        end
                    else
                        tool:Activate()
                    end
                else
                    -- Nếu quái chưa Spawn -> Bay đến đứng chờ ở bãi
                    FastFly(qData.MobPos)
                end
            end
        end
    end
end)