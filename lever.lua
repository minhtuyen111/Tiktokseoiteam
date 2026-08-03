-- ====================================================================
--  TUYENMOD2194 - ALL-IN-ONE ADVANCED BLOX FRUIT AUTO FARM SYSTEM
-- ====================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- Anti-AFK System
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Global Toggles
getgenv().AutoFarmLevel = false
getgenv().BringMob = true
getgenv().FastAttack = true

-- ====================================================================
--  1. FULL QUEST DATABASE (LEVEL 1 -> LEVEL 2550 MAX)
-- ====================================================================
local function GetQuestData()
    local myLevel = LocalPlayer.Data.Level.Value
    
    -- SEA 1
    if myLevel >= 1 and myLevel < 10 then
        return {QuestName = "BanditQuest1", QuestLevel = 1, MobName = "Bandit", NpcCFrame = CFrame.new(1059, 16, 1549), MobCFrame = CFrame.new(1145, 16, 1634)}
    elseif myLevel >= 10 and myLevel < 15 then
        return {QuestName = "JungleQuest", QuestLevel = 1, MobName = "Monkey", NpcCFrame = CFrame.new(-1598, 36, 153), MobCFrame = CFrame.new(-1623, 36, 142)}
    elseif myLevel >= 15 and myLevel < 30 then
        return {QuestName = "JungleQuest", QuestLevel = 2, MobName = "Gorilla", NpcCFrame = CFrame.new(-1598, 36, 153), MobCFrame = CFrame.new(-1237, 6, -486)}
    elseif myLevel >= 30 and myLevel < 40 then
        return {QuestName = "PirateQuest", QuestLevel = 1, MobName = "Pirate", NpcCFrame = CFrame.new(-1140, 4, 3828), MobCFrame = CFrame.new(-1203, 4, 3915)}
    elseif myLevel >= 40 and myLevel < 60 then
        return {QuestName = "PirateQuest", QuestLevel = 2, MobName = "Brute", NpcCFrame = CFrame.new(-1140, 4, 3828), MobCFrame = CFrame.new(-1152, 14, 4218)}
    elseif myLevel >= 60 and myLevel < 75 then
        return {QuestName = "DesertQuest", QuestLevel = 1, MobName = "Desert Bandit", NpcCFrame = CFrame.new(894, 6, 4388), MobCFrame = CFrame.new(988, 6, 4423)}
    elseif myLevel >= 75 and myLevel < 90 then
        return {QuestName = "DesertQuest", QuestLevel = 2, MobName = "Desert Officer", NpcCFrame = CFrame.new(894, 6, 4388), MobCFrame = CFrame.new(1542, 14, 4374)}
    elseif myLevel >= 90 and myLevel < 100 then
        return {QuestName = "SnowQuest", QuestLevel = 1, MobName = "Snow Bandit", NpcCFrame = CFrame.new(1385, 87, -1298), MobCFrame = CFrame.new(1288, 105, -1430)}
    elseif myLevel >= 100 and myLevel < 120 then
        return {QuestName = "SnowQuest", QuestLevel = 2, MobName = "Snowman", NpcCFrame = CFrame.new(1385, 87, -1298), MobCFrame = CFrame.new(1288, 105, -1430)}
    elseif myLevel >= 120 and myLevel < 150 then
        return {QuestName = "MarineFordQuest2", QuestLevel = 1, MobName = "Chief Petty Officer", NpcCFrame = CFrame.new(-5035, 28, 4324), MobCFrame = CFrame.new(-4859, 22, 4262)}
    elseif myLevel >= 150 and myLevel < 175 then
        return {QuestName = "SkyQuest", QuestLevel = 1, MobName = "Sky Bandit", NpcCFrame = CFrame.new(-4842, 717, -2623), MobCFrame = CFrame.new(-4972, 720, -2888)}
    elseif myLevel >= 175 and myLevel < 190 then
        return {QuestName = "SkyQuest", QuestLevel = 2, MobName = "Dark Master", NpcCFrame = CFrame.new(-4842, 717, -2623), MobCFrame = CFrame.new(-5223, 746, -2285)}
    elseif myLevel >= 190 and myLevel < 210 then
        return {QuestName = "PrisonerQuest", QuestLevel = 1, MobName = "Prisoner", NpcCFrame = CFrame.new(530, 1, 474), MobCFrame = CFrame.new(506, 1, 591)}
    elseif myLevel >= 210 and myLevel < 250 then
        return {QuestName = "PrisonerQuest", QuestLevel = 2, MobName = "Dangerous Prisoner", NpcCFrame = CFrame.new(530, 1, 474), MobCFrame = CFrame.new(506, 1, 591)}
    elseif myLevel >= 250 and myLevel < 275 then
        return {QuestName = "ColosseumQuest", QuestLevel = 1, MobName = "Toga Warrior", NpcCFrame = CFrame.new(-1580, 7, -2982), MobCFrame = CFrame.new(-1808, 50, -2742)}
    elseif myLevel >= 275 and myLevel < 300 then
        return {QuestName = "ColosseumQuest", QuestLevel = 2, MobName = "Gladiator", NpcCFrame = CFrame.new(-1580, 7, -2982), MobCFrame = CFrame.new(-1808, 50, -2742)}
    elseif myLevel >= 300 and myLevel < 325 then
        return {QuestName = "MagmaQuest", QuestLevel = 1, MobName = "Military Soldier", NpcCFrame = CFrame.new(-5313, 12, 8515), MobCFrame = CFrame.new(-5408, 11, 8447)}
    elseif myLevel >= 325 and myLevel < 375 then
        return {QuestName = "MagmaQuest", QuestLevel = 2, MobName = "Military Spy", NpcCFrame = CFrame.new(-5313, 12, 8515), MobCFrame = CFrame.new(-5815, 84, 8820)}
    elseif myLevel >= 375 and myLevel < 400 then
        return {QuestName = "FishmanQuest", QuestLevel = 1, MobName = "Fishman Warrior", NpcCFrame = CFrame.new(61122, 18, 1569), MobCFrame = CFrame.new(60871, 18, 1538)}
    elseif myLevel >= 400 and myLevel < 450 then
        return {QuestName = "FishmanQuest", QuestLevel = 2, MobName = "Fishman Commando", NpcCFrame = CFrame.new(61122, 18, 1569), MobCFrame = CFrame.new(61845, 18, 1475)}
    elseif myLevel >= 450 and myLevel < 475 then
        return {QuestName = "SkyExp1Quest", QuestLevel = 1, MobName = "God's Guard", NpcCFrame = CFrame.new(-4721, 846, -1954), MobCFrame = CFrame.new(-4721, 846, -1954)}
    elseif myLevel >= 475 and myLevel < 525 then
        return {QuestName = "SkyExp1Quest", QuestLevel = 2, MobName = "Shanda", NpcCFrame = CFrame.new(-7863, 5545, -380), MobCFrame = CFrame.new(-7685, 5562, -493)}
    elseif myLevel >= 525 and myLevel < 550 then
        return {QuestName = "SkyExp2Quest", QuestLevel = 1, MobName = "Royal Squad", NpcCFrame = CFrame.new(-7906, 5636, -1411), MobCFrame = CFrame.new(-7685, 5607, -1423)}
    elseif myLevel >= 550 and myLevel < 625 then
        return {QuestName = "SkyExp2Quest", QuestLevel = 2, MobName = "Royal Soldier", NpcCFrame = CFrame.new(-7906, 5636, -1411), MobCFrame = CFrame.new(-7837, 5651, -1770)}
    elseif myLevel >= 625 and myLevel < 650 then
        return {QuestName = "FountainQuest", QuestLevel = 1, MobName = "Galley Pirate", NpcCFrame = CFrame.new(5259, 39, 4050), MobCFrame = CFrame.new(5589, 45, 3996)}
    elseif myLevel >= 650 and myLevel < 700 then
        return {QuestName = "FountainQuest", QuestLevel = 2, MobName = "Galley Captain", NpcCFrame = CFrame.new(5259, 39, 4050), MobCFrame = CFrame.new(5642, 39, 4936)}
    
    -- SEA 2
    elseif myLevel >= 700 and myLevel < 725 then
        return {QuestName = "Area1Quest", QuestLevel = 1, MobName = "Raider", NpcCFrame = CFrame.new(-425, 73, 1837), MobCFrame = CFrame.new(-746, 90, 2398)}
    elseif myLevel >= 725 and myLevel < 775 then
        return {QuestName = "Area1Quest", QuestLevel = 2, MobName = "Mercenary", NpcCFrame = CFrame.new(-425, 73, 1837), MobCFrame = CFrame.new(-978, 90, 1723)}
    elseif myLevel >= 775 and myLevel < 800 then
        return {QuestName = "Area2Quest", QuestLevel = 1, MobName = "Swan Pirate", NpcCFrame = CFrame.new(638, 73, 918), MobCFrame = CFrame.new(878, 122, 1235)}
    elseif myLevel >= 800 and myLevel < 875 then
        return {QuestName = "Area2Quest", QuestLevel = 2, MobName = "Factory Staff", NpcCFrame = CFrame.new(638, 73, 918), MobCFrame = CFrame.new(295, 73, -56)}
    elseif myLevel >= 875 and myLevel < 900 then
        return {QuestName = "MarineQuest2", QuestLevel = 1, MobName = "Marine Lieutenant", NpcCFrame = CFrame.new(-2441, 73, -3219), MobCFrame = CFrame.new(-2825, 73, -3025)}
    elseif myLevel >= 900 and myLevel < 950 then
        return {QuestName = "MarineQuest2", QuestLevel = 2, MobName = "Marine Captain", NpcCFrame = CFrame.new(-2441, 73, -3219), MobCFrame = CFrame.new(-1869, 73, -3320)}
    elseif myLevel >= 950 and myLevel < 1000 then
        return {QuestName = "ZombieQuest", QuestLevel = 1, MobName = "Zombie", NpcCFrame = CFrame.new(-5497, 48, -795), MobCFrame = CFrame.new(-5623, 48, -716)}
    elseif myLevel >= 1000 and myLevel < 1050 then
        return {QuestName = "ZombieQuest", QuestLevel = 2, MobName = "Vampire", NpcCFrame = CFrame.new(-5497, 48, -795), MobCFrame = CFrame.new(-6023, 6, -1316)}
    elseif myLevel >= 1050 and myLevel < 1100 then
        return {QuestName = "SnowMountainQuest", QuestLevel = 1, MobName = "Snow Trooper", NpcCFrame = CFrame.new(609, 401, -5372), MobCFrame = CFrame.new(478, 401, -5352)}
    elseif myLevel >= 1100 and myLevel < 1175 then
        return {QuestName = "SnowMountainQuest", QuestLevel = 2, MobName = "Winter Warrior", NpcCFrame = CFrame.new(609, 401, -5372), MobCFrame = CFrame.new(1158, 426, -5188)}
    elseif myLevel >= 1175 and myLevel < 1250 then
        return {QuestName = "ShipQuest1", QuestLevel = 1, MobName = "Ship Deckhand", NpcCFrame = CFrame.new(1038, 125, 32911), MobCFrame = CFrame.new(1190, 126, 32871)}
    elseif myLevel >= 1250 and myLevel < 1300 then
        return {QuestName = "ShipQuest1", QuestLevel = 2, MobName = "Ship Engineer", NpcCFrame = CFrame.new(1038, 125, 32911), MobCFrame = CFrame.new(918, 126, 32871)}
    elseif myLevel >= 1300 and myLevel < 1350 then
        return {QuestName = "ShipQuest2", QuestLevel = 1, MobName = "Ship Steward", NpcCFrame = CFrame.new(968, 125, 33243), MobCFrame = CFrame.new(918, 126, 33421)}
    elseif myLevel >= 1350 and myLevel < 1425 then
        return {QuestName = "ShipQuest2", QuestLevel = 2, MobName = "Officer Marine", NpcCFrame = CFrame.new(968, 125, 33243), MobCFrame = CFrame.new(918, 126, 33421)}
    elseif myLevel >= 1425 and myLevel < 1500 then
        return {QuestName = "FrostQuest", QuestLevel = 1, MobName = "Arctic Warrior", NpcCFrame = CFrame.new(5667, 28, -6482), MobCFrame = CFrame.new(6038, 28, -6212)}

    -- SEA 3
    elseif myLevel >= 1500 and myLevel < 1575 then
        return {QuestName = "PiratePortQuest", QuestLevel = 1, MobName = "Pirate Millionaire", NpcCFrame = CFrame.new(-290, 44, 5580), MobCFrame = CFrame.new(-373, 75, 5552)}
    elseif myLevel >= 1575 and myLevel < 1625 then
        return {QuestName = "PiratePortQuest", QuestLevel = 2, MobName = "Pistol Billionaire", NpcCFrame = CFrame.new(-290, 44, 5580), MobCFrame = CFrame.new(-466, 74, 5951)}
    elseif myLevel >= 1625 and myLevel < 1700 then
        return {QuestName = "AmazonQuest", QuestLevel = 1, MobName = "Dragon Crew Warrior", NpcCFrame = CFrame.new(5832, 51, -1102), MobCFrame = CFrame.new(6342, 51, -1212)}
    elseif myLevel >= 1700 and myLevel < 1775 then
        return {QuestName = "AmazonQuest2", QuestLevel = 1, MobName = "Female Islander", NpcCFrame = CFrame.new(5447, 601, 751), MobCFrame = CFrame.new(4622, 601, 751)}
    elseif myLevel >= 1775 and myLevel < 1825 then
        return {QuestName = "MarineTreeQuest", QuestLevel = 1, MobName = "Marine Commodore", NpcCFrame = CFrame.new(2180, 29, -6737), MobCFrame = CFrame.new(2412, 73, -6812)}
    elseif myLevel >= 1825 and myLevel < 1900 then
        return {QuestName = "MarineTreeQuest", QuestLevel = 2, MobName = "Bad Rear Admiral", NpcCFrame = CFrame.new(2180, 29, -6737), MobCFrame = CFrame.new(2812, 73, -6812)}
    elseif myLevel >= 1900 and myLevel < 1975 then
        return {QuestName = "DeepForestIslandQuest", QuestLevel = 1, MobName = "Forest Pirate", NpcCFrame = CFrame.new(-13233, 331, -7626), MobCFrame = CFrame.new(-13412, 331, -7912)}
    elseif myLevel >= 1975 and myLevel < 2075 then
        return {QuestName = "DeepForestIslandQuest2", QuestLevel = 1, MobName = "Jungle Pirate", NpcCFrame = CFrame.new(-12684, 391, -9902), MobCFrame = CFrame.new(-12112, 391, -10412)}
    elseif myLevel >= 2075 and myLevel < 2150 then
        return {QuestName = "HauntedQuest1", QuestLevel = 1, MobName = "Reborn Skeleton", NpcCFrame = CFrame.new(-9515, 142, 5537), MobCFrame = CFrame.new(-8782, 142, 5612)}
    elseif myLevel >= 2150 and myLevel < 2225 then
        return {QuestName = "HauntedQuest2", QuestLevel = 1, MobName = "Demonic Soul", NpcCFrame = CFrame.new(-9515, 142, 5537), MobCFrame = CFrame.new(-9512, 142, 6112)}
    elseif myLevel >= 2225 and myLevel < 2300 then
        return {QuestName = "NutsIslandQuest", QuestLevel = 1, MobName = "Peanut Scout", NpcCFrame = CFrame.new(-2104, 38, -10194), MobCFrame = CFrame.new(-2112, 38, -10412)}
    elseif myLevel >= 2300 and myLevel < 2400 then
        return {QuestName = "IceCreamIslandQuest", QuestLevel = 1, MobName = "Ice Cream Chef", NpcCFrame = CFrame.new(-820, 66, -10965), MobCFrame = CFrame.new(-612, 66, -11112)}
    elseif myLevel >= 2400 and myLevel <= 2550 then
        return {QuestName = "TikiQuest1", QuestLevel = 1, MobName = "Sun-kissed Warrior", NpcCFrame = CFrame.new(-16550, 55, 1050), MobCFrame = CFrame.new(-16212, 55, 1212)}
    end
    
    return {QuestName = "BanditQuest1", QuestLevel = 1, MobName = "Bandit", NpcCFrame = CFrame.new(1059, 16, 1549), MobCFrame = CFrame.new(1145, 16, 1634)}
end

-- ====================================================================
--  2. SAFE TWEEN & COMBAT SYSTEM
-- ====================================================================
local function SafeTo(targetCFrame)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local distance = (character.HumanoidRootPart.Position - targetCFrame.Position).Magnitude
        local speed = 300 
        local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(character.HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
    end
end

-- Fast Attack Thread
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().AutoFarmLevel and getgenv().FastAttack then
            pcall(function()
                local VirtualInputManager = game:GetService("VirtualInputManager")
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end)
        end
    end
end)

-- Main Auto Farm Loop
task.spawn(function()
    while task.wait(0.2) do
        if getgenv().AutoFarmLevel then
            pcall(function()
                local questInfo = GetQuestData()
                local hasQuest = LocalPlayer.PlayerGui.Main.Quest.Visible

                if not hasQuest then
                    SafeTo(questInfo.NpcCFrame)
                    if (LocalPlayer.Character.HumanoidRootPart.Position - questInfo.NpcCFrame.Position).Magnitude < 15 then
                        CommF:InvokeServer("StartQuest", questInfo.QuestName, questInfo.QuestLevel)
                    end
                else
                    local targetMob = nil
                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob.Name == questInfo.MobName and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            targetMob = mob
                            break
                        end
                    end

                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                        SafeTo(targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                        
                        if getgenv().BringMob then
                            for _, otherMob in pairs(workspace.Enemies:GetChildren()) do
                                if otherMob.Name == questInfo.MobName and otherMob:FindFirstChild("HumanoidRootPart") then
                                    if (otherMob.HumanoidRootPart.Position - targetMob.HumanoidRootPart.Position).Magnitude < 250 then
                                        otherMob.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame
                                        otherMob.Humanoid.CanCollide = false
                                    end
                                end
                            end
                        end
                    else
                        SafeTo(questInfo.MobCFrame)
                    end
                end
            end)
        end
    end
end)

-- ====================================================================
--  3. MODERN ROUNDED UI DESIGN
-- ====================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TuyenMod2194_MasterUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Floating Logo Toggle
local ToggleLogo = Instance.new("ImageButton")
ToggleLogo.Size = UDim2.new(0, 45, 0, 45)
ToggleLogo.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleLogo.BackgroundColor3 = Color3.fromRGB(25, 28, 40)
ToggleLogo.Image = "rbxassetid://6031075931"
ToggleLogo.Parent = ScreenGui

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 22)
LogoCorner.Parent = ToggleLogo

-- Main Frame UI
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 260)
MainFrame.Position = UDim2.new(0.5, -200, 0.4, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

-- Toggle UI Event
local menuOpen = true
ToggleLogo.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    MainFrame.Visible = menuOpen
end)

-- Title Header
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "⚡ TUYENMOD2194 - ADVANCED AUTO FARM ⚡"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Auto Farm Level Toggle Button
local FarmBtn = Instance.new("TextButton")
FarmBtn.Size = UDim2.new(0.85, 0, 0, 45)
FarmBtn.Position = UDim2.new(0.075, 0, 0.28, 0)
FarmBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 55)
FarmBtn.Text = "Auto Farm Level: OFF"
FarmBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
FarmBtn.Font = Enum.Font.GothamSemibold
FarmBtn.TextSize = 14
FarmBtn.Parent = MainFrame

local BtnCorner1 = Instance.new("UICorner")
BtnCorner1.CornerRadius = UDim.new(0, 10)
BtnCorner1.Parent = FarmBtn

FarmBtn.MouseButton1Click:Connect(function()
    getgenv().AutoFarmLevel = not getgenv().AutoFarmLevel
    if getgenv().AutoFarmLevel then
        FarmBtn.Text = "Auto Farm Level: ON"
        FarmBtn.TextColor3 = Color3.fromRGB(80, 255, 140)
        FarmBtn.BackgroundColor3 = Color3.fromRGB(25, 60, 40)
    else
        FarmBtn.Text = "Auto Farm Level: OFF"
        FarmBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        FarmBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 55)
    end
end)

-- Bring Mob Toggle Button
local BringBtn = Instance.new("TextButton")
BringBtn.Size = UDim2.new(0.85, 0, 0, 45)
BringBtn.Position = UDim2.new(0.075, 0, 0.55, 0)
BringBtn.BackgroundColor3 = Color3.fromRGB(25, 60, 40)
BringBtn.Text = "Gom Quái (Bring Mob): ON"
BringBtn.TextColor3 = Color3.fromRGB(80, 255, 140)
BringBtn.Font = Enum.Font.GothamSemibold
BringBtn.TextSize = 14
BringBtn.Parent = MainFrame

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 10)
BtnCorner2.Parent = BringBtn

BringBtn.MouseButton1Click:Connect(function()
    getgenv().BringMob = not getgenv().BringMob
    if getgenv().BringMob then
        BringBtn.Text = "Gom Quái (Bring Mob): ON"
        BringBtn.TextColor3 = Color3.fromRGB(80, 255, 140)
        BringBtn.BackgroundColor3 = Color3.fromRGB(25, 60, 40)
    else
        BringBtn.Text = "Gom Quái (Bring Mob): OFF"
        BringBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        BringBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 55)
    end
end)

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "TUYENMOD2194",
        Text = "Đã tải xong toàn bộ 100% Code!",
        Duration = 4
    })
end)