-- ====================================================================
--  TUYENMOD2194 - FULL ORIGINAL LOGIC + MODERN ROUNDED MENU UI
-- ====================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- Anti-AFK & Kick Protection
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Anti Death/Respawn Effects (Giữ nguyên logic cũ)
pcall(function()
    local EffectContainer = ReplicatedStorage:FindFirstChild("Effect") and ReplicatedStorage.Effect:FindFirstChild("Container")
    if EffectContainer then
        if EffectContainer:FindFirstChild("Death") then pcall(require, EffectContainer.Death) end
        if EffectContainer:FindFirstChild("Respawn") then pcall(require, EffectContainer.Respawn) end
    end
end)

-- Global Toggles (Giữ nguyên logic cũ)
getgenv().AutoFarmLevel = false
getgenv().BringMob = true
getgenv().FastAttack = true

-- Check Place ID / World (Giữ nguyên logic cũ)
local placeId = game.PlaceId
getgenv().World1 = (placeId == 2753915549)
getgenv().World2 = (placeId == 4442272183)
getgenv().World3 = (placeId == 7449423635)

-- ====================================================================
--  1. GIỮ NGUYÊN 100% LOGIC DATA QUEST & FARM CŨ
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

-- Helper Functions (Giữ nguyên 100% logic Safe Tween & Combat Cũ)
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

-- Fast Attack Loop (Logic Cũ)
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

-- Main Farm Loop (Logic Cũ)
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

-- Promo Codes List (Logic Cũ)
local promoCodes = {
    "WildDares", "BossBuild", "GetPranked", "Sub2OfficialNoobie",
    "Sub2Daigrock", "Sub2NoobMaster123", "Bluxxy", "JCWK",
    "Enyu_is_Pro", "Sub2Fer999", "kittgaming", "TheGreatAce",
    "StrawHatMaine", "TantaiGaming", "Axiore", "SUB2GAMERROBOT_EXP1",
    "MagicBus", "StarcodeHEO", "Sub2CaptainMaui", "FIGHT4FRUIT", "EARN_FRUITS"
}

-- ====================================================================
--  2. SỬA MỖI MENU (GIAO DIỆN UI BO TRÒN MỚI TOÀN BỘ)
-- ====================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TuyenMod2194_ModernUI"
pcall(function()
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end)

-- Floating Toggle Logo (Bo tròn & Có viền sáng)
local ToggleLogo = Instance.new("ImageButton")
ToggleLogo.Name = "ToggleLogo"
ToggleLogo.Size = UDim2.new(0, 50, 0, 50)
ToggleLogo.Position = UDim2.new(0.02, 0, 0.15, 0)
ToggleLogo.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
ToggleLogo.Image = "rbxassetid://6031075931"
ToggleLogo.Parent = ScreenGui

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 25)
LogoCorner.Parent = ToggleLogo

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(0, 180, 255)
LogoStroke.Thickness = 2
LogoStroke.Parent = ToggleLogo

-- Main Frame (Bo tròn 16px)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

-- Toggle Show/Hide Event
local menuOpen = true
ToggleLogo.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    MainFrame.Visible = menuOpen
end)

-- Sidebar Top Header
local AdminTitle = Instance.new("TextLabel")
AdminTitle.Size = UDim2.new(1, 0, 0, 45)
AdminTitle.BackgroundTransparency = 1
AdminTitle.Text = "⚡ TUYENMOD2194 STUDIO UI ⚡"
AdminTitle.TextColor3 = Color3.fromRGB(0, 210, 255)
AdminTitle.TextSize = 13
AdminTitle.Font = Enum.Font.GothamBold
AdminTitle.Parent = MainFrame

-- Sidebar Frame Left
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(14, 15, 22)
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 14)
SidebarCorner.Parent = Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = Sidebar
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 8)

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 10)
TabPadding.PaddingLeft = UDim.new(0, 8)
TabPadding.Parent = Sidebar

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -150, 1, -55)
TabContainer.Position = UDim2.new(0, 145, 0, 50)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

-- Tab Generator Helper
local tabs = {}
local function CreateTab(name, color, order)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0, 124, 0, 35)
    TabBtn.BackgroundColor3 = color
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 11
    TabBtn.LayoutOrder = order
    TabBtn.Parent = Sidebar

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 10)
    BtnCorner.Parent = TabBtn

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = color
    Page.Visible = false
    Page.Parent = TabContainer

    local PageList = Instance.new("UIListLayout")
    PageList.Parent = Page
    PageList.Padding = UDim.new(0, 8)

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Page.Visible = false
        end
        Page.Visible = true
    end)

    tabs[name] = {Btn = TabBtn, Page = Page}
    return Page
end

-- Create Colorful Tabs
local FarmPage = CreateTab("🌾 Auto Farm", Color3.fromRGB(60, 180, 110), 1)
local ShopPage = CreateTab("🛒 Shop Item", Color3.fromRGB(230, 80, 80), 2)
local StatusPage = CreateTab("🌐 Status", Color3.fromRGB(80, 170, 230), 3)

FarmPage.Visible = true -- Tab mặc định

-- UI Element Helpers
local function AddButton(parentPage, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -12, 0, 36)
    Btn.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 11
    Btn.Parent = parentPage

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Btn

    Btn.MouseButton1Click:Connect(function() pcall(callback) end)
    return Btn
end

local function AddLabel(parentPage, text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -12, 0, 30)
    Label.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(0, 255, 170)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 11
    Label.Parent = parentPage

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Label

    return Label
end

-- Populate Farm Tab
local AutoFarmBtn = AddButton(FarmPage, "Auto Farm Level: OFF", function() end)
AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 35)
AutoFarmBtn.TextColor3 = Color3.fromRGB(255, 80, 80)

AutoFarmBtn.MouseButton1Click:Connect(function()
    getgenv().AutoFarmLevel = not getgenv().AutoFarmLevel
    if getgenv().AutoFarmLevel then
        AutoFarmBtn.Text = "Auto Farm Level: ON"
        AutoFarmBtn.TextColor3 = Color3.fromRGB(80, 255, 140)
        AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(25, 60, 40)
    else
        AutoFarmBtn.Text = "Auto Farm Level: OFF"
        AutoFarmBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 35)
    end
end)

local BringBtn = AddButton(FarmPage, "Gom Quái (Bring Mob): ON", function() end)
BringBtn.BackgroundColor3 = Color3.fromRGB(25, 60, 40)
BringBtn.TextColor3 = Color3.fromRGB(80, 255, 140)

BringBtn.MouseButton1Click:Connect(function()
    getgenv().BringMob = not getgenv().BringMob
    if getgenv().BringMob then
        BringBtn.Text = "Gom Quái (Bring Mob): ON"
        BringBtn.TextColor3 = Color3.fromRGB(80, 255, 140)
        BringBtn.BackgroundColor3 = Color3.fromRGB(25, 60, 40)
    else
        BringBtn.Text = "Gom Quái (Bring Mob): OFF"
        BringBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        BringBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 35)
    end
end)

-- Populate Shop Tab (Logic Cũ)
AddButton(ShopPage, "🎁 Nhập Tất Cả Code", function()
    for _, code in ipairs(promoCodes) do
        task.spawn(function()
            CommF:InvokeServer("Redeem", code)
        end)
        task.wait(0.1)
    end
end)

AddButton(ShopPage, "🌊 Safe Teleport Sea 1", function() CommF:InvokeServer("TravelMain") end)
AddButton(ShopPage, "🌊 Safe Teleport Sea 2", function() CommF:InvokeServer("TravelDressrosa") end)
AddButton(ShopPage, "🌊 Safe Teleport Sea 3", function() CommF:InvokeServer("TravelZou") end)

AddButton(ShopPage, "🥋 Buy Superhuman", function() CommF:InvokeServer("BuySuperhuman") end)
AddButton(ShopPage, "🥋 Buy Death Step", function() CommF:InvokeServer("BuyDeathStep") end)
AddButton(ShopPage, "🥋 Buy Sharkman Karate", function() CommF:InvokeServer("BuySharkmanKarate") end)
AddButton(ShopPage, "🥋 Buy Electric Claw", function() CommF:InvokeServer("BuyElectricClaw") end)
AddButton(ShopPage, "🥋 Buy Dragon Talon", function() CommF:InvokeServer("BuyDragonTalon") end)
AddButton(ShopPage, "🥋 Buy Godhuman", function() CommF:InvokeServer("BuyGodhuman") end)

-- Populate Status Tab (Logic Cũ)
local TimeLabel = AddLabel(StatusPage, "Time: Loading...")
local MirageLabel = AddLabel(StatusPage, "Mirage Island: Checking...")
local KitsuneLabel = AddLabel(StatusPage, "Kitsune Island: Checking...")

task.spawn(function()
    while task.wait(1) do
        local dt = os.date("*t")
        TimeLabel.Text = string.format(" Time: %02d:%02d:%02d | Date: %02d/%02d/%04d", dt.hour, dt.min, dt.sec, dt.day, dt.month, dt.year)
        
        local mirage = workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island")
        MirageLabel.Text = " Mirage Island: " .. (mirage and "✅ Spawned" or "❌ Not Found")
        
        local kitsune = workspace.Map:FindFirstChild("KitsuneIsland")
        KitsuneLabel.Text = " Kitsune Island: " .. (kitsune and "✅ Spawned" or "❌ Not Found")
    end
end)

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "TUYENMOD2194 STUDIO",
        Text = "Đã cập nhật Menu Bo Tròn thành công!",
        Duration = 5
    })
end)