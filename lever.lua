-- [[ BLOX FRUIT ULTIMATE 3D STUDIO - FULL LOGIC REFACTORED ]] --
-- Compatible with all Executors (Synapse, Delta, Hydrogen, Codex, etc.)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- ================================================================= --
-- 1. SERVICES & GLOBAL CONFIGURATION
-- ================================================================= --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local VirtualUser = game:GetService("VirtualUser")

local Player = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
local CommF = Remotes and Remotes:WaitForChild("CommF_", 10)
local CommE = Remotes and Remotes:WaitForChild("CommE", 10)

-- World Detection
local placeId = game.PlaceId
local World1, World2, World3 = false, false, false
if placeId == 2753915549 then World1 = true
elseif placeId == 4442272183 then World2 = true
elseif placeId == 7449423635 then World3 = true
end

-- Global State Flags
getgenv().Config = {
    AutoFarm = false,
    FastAttack = true,
    AutoStatMelee = false,
    AutoStatDefense = false,
    AutoStatSword = false,
    AutoStatGun = false,
    AutoStatDemonFruit = false,
    SelectWeapon = "Melee"
}

-- Anti-AFK Setup
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Disable Camera Shake & Death Effects
pcall(function()
    local Util = ReplicatedStorage:WaitForChild("Util", 5)
    if Util and Util:FindFirstChild("CameraShaker") then
        require(Util.CameraShaker):Stop()
    end
    local EffectContainer = ReplicatedStorage:FindFirstChild("Effect") and ReplicatedStorage.Effect:FindFirstChild("Container")
    if EffectContainer then
        for _, effectName in ipairs({"Death", "Respawn"}) do
            local item = EffectContainer:FindFirstChild(effectName)
            if item then
                local ok, res = pcall(require, item)
                if ok and type(res) == "function" then hookfunction(res, function() end) end
            end
        end
    end
end)

-- ================================================================= --
-- 2. CORE GAMEPLAY LOGIC & HELPER FUNCTIONS
-- ================================================================= --

-- Equip Tool Handler
local function EquipWeapon(weaponType)
    local backpack = Player:FindFirstChild("Backpack")
    local character = Player.Character
    if not backpack or not character then return end

    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            if weaponType == "Melee" and item.ToolTip == "Melee" then
                character.Humanoid:EquipTool(item)
                break
            elseif weaponType == "Sword" and item.ToolTip == "Sword" then
                character.Humanoid:EquipTool(item)
                break
            elseif weaponType == "Blox Fruit" and item.ToolTip == "Blox Fruit" then
                character.Humanoid:EquipTool(item)
                break
            end
        end
    end
end

-- Fast Attack Logic
local function DoFastAttack()
    if not getgenv().Config.FastAttack then return end
    local char = Player.Character
    if not char then return end
    
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local targets = {}
    local mainTarget = nil
    
    for _, enemy in ipairs(enemies:GetChildren()) do
        local eHrp = enemy:FindFirstChild("HumanoidRootPart")
        local eHum = enemy:FindFirstChild("Humanoid")
        if eHrp and eHum and eHum.Health > 0 and (eHrp.Position - hrp.Position).Magnitude <= 60 then
            local head = enemy:FindFirstChild("Head")
            if head then
                table.insert(targets, { enemy, head })
                mainTarget = head
            end
        end
    end
    
    if mainTarget then
        pcall(function()
            local net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
            net:WaitForChild("RE/RegisterAttack"):FireServer(0.1)
            net:WaitForChild("RE/RegisterHit"):FireServer(mainTarget, targets)
        end)
    end
end

-- Fast Attack Background Loop
task.spawn(function()
    while task.wait(0.05) do
        if getgenv().Config.AutoFarm or getgenv().Config.FastAttack then
            pcall(DoFastAttack)
        end
    end
end)

-- Noclip & Flight Physics Loop
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if getgenv().Config.AutoFarm then
                local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if not hrp:FindFirstChild("BodyClip") then
                        local noclip = Instance.new("BodyVelocity")
                        noclip.Name = "BodyClip"
                        noclip.Parent = hrp
                        noclip.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                        noclip.Velocity = Vector3.new(0, 0, 0)
                    end
                    for _, v in pairs(Player.Character:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end
            else
                local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                if hrp and hrp:FindFirstChild("BodyClip") then
                    hrp.BodyClip:Destroy()
                end
            end
        end)
    end
end)

-- Auto Farm Main Loop
task.spawn(function()
    while task.wait(0.2) do
        if getgenv().Config.AutoFarm then
            pcall(function()
                EquipWeapon(getgenv().Config.SelectWeapon)
                local enemies = workspace:FindFirstChild("Enemies")
                if enemies then
                    for _, enemy in ipairs(enemies:GetChildren()) do
                        local eHum = enemy:FindFirstChild("Humanoid")
                        local eHrp = enemy:FindFirstChild("HumanoidRootPart")
                        local myHrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                        
                        if eHum and eHrp and myHrp and eHum.Health > 0 then
                            repeat
                                task.wait()
                                if not getgenv().Config.AutoFarm then break end
                                myHrp.CFrame = eHrp.CFrame * CFrame.new(0, 10, 0)
                            until not enemy:IsDescendantOf(workspace) or eHum.Health <= 0
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Upgrade Stats Loop
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if CommF then
                if getgenv().Config.AutoStatMelee then CommF:InvokeServer("AddPoint", "Melee", 1) end
                if getgenv().Config.AutoStatDefense then CommF:InvokeServer("AddPoint", "Defense", 1) end
                if getgenv().Config.AutoStatSword then CommF:InvokeServer("AddPoint", "Sword", 1) end
                if getgenv().Config.AutoStatGun then CommF:InvokeServer("AddPoint", "Gun", 1) end
                if getgenv().Config.AutoStatDemonFruit then CommF:InvokeServer("AddPoint", "Demon Fruit", 1) end
            end
        end)
    end
end)

-- ================================================================= --
-- 3. MODERN 3D GLASSMORPHISM GUI ENGINE
-- ================================================================= --
if CoreGui:FindFirstChild("Studio3D_BloxUI") then
    CoreGui.Studio3D_BloxUI:Destroy()
end

local Studio3D_BloxUI = Instance.new("ScreenGui")
Studio3D_BloxUI.Name = "Studio3D_BloxUI"
Studio3D_BloxUI.Parent = CoreGui
Studio3D_BloxUI.ResetOnSpawn = false

-- Canvas Frame
local MainFrame = Instance.new("Frame", Studio3D_BloxUI)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Background Gradient (3D Depth Effect)
local UIGradient = Instance.new("UIGradient", MainFrame)
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 28, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 12, 18))
}
UIGradient.Rotation = 45

-- Header Bar
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(25, 32, 45)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "⚡ BLOX FRUIT - ULTRA 3D STUDIO HUB"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(0, 210, 255)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Dragging Functionality
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Sidebar Navigation
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 140, 1, -45)
SideBar.Position = UDim2.new(0, 0, 0, 45)
SideBar.BackgroundColor3 = Color3.fromRGB(18, 22, 30)
SideBar.BorderSizePixel = 0

local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, -150, 1, -55)
TabContainer.Position = UDim2.new(0, 145, 0, 50)
TabContainer.BackgroundTransparency = 1

local Tabs = {}
local TabButtons = {}

local function CreateTab(name, icon)
    local TabPage = Instance.new("ScrollingFrame", TabContainer)
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.ScrollBarThickness = 4
    TabPage.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
    TabPage.Visible = false
    
    local UIList = Instance.new("UIListLayout", TabPage)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 8)
    
    Tabs[name] = TabPage

    local TabBtn = Instance.new("TextButton", SideBar)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
    TabBtn.Position = UDim2.new(0.05, 0, 0, #TabButtons * 40 + 10)
    TabBtn.BackgroundColor3 = Color3.fromRGB(28, 34, 48)
    TabBtn.Text = icon .. " " .. name
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.TextSize = 13
    TabBtn.AutoButtonColor = false
    
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
    
    TabBtn.MouseButton1Click:Connect(function()
        for tName, page in pairs(Tabs) do page.Visible = (tName == name) end
        for _, btn in pairs(TabButtons) do
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 34, 48), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 140, 230), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    
    table.insert(TabButtons, TabBtn)
    return TabPage
end

-- UI Component Builders
local function AddToggle(parent, text, defaultState, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(0.96, 0, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 32, 45)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = text
    Label.Font = Enum.Font.GothamSemibold
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    
    local ToggleBtn = Instance.new("TextButton", Frame)
    ToggleBtn.Size = UDim2.new(0, 45, 0, 22)
    ToggleBtn.Position = UDim2.new(1, -55, 0.5, -11)
    ToggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 65, 75)
    ToggleBtn.Text = defaultState and "ON" or "OFF"
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextSize = 10
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 11)
    
    local state = defaultState
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        ToggleBtn.Text = state and "ON" or "OFF"
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 65, 75)}):Play()
        pcall(callback, state)
    end)
end

local function AddButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(0.96, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 38, 55)
    Btn.Text = text
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    Btn.TextSize = 12
    Btn.AutoButtonColor = false
    
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color = Color3.fromRGB(50, 60, 80)
    Stroke.Thickness = 1

    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 210)}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 38, 55)}):Play()
    end)
    Btn.MouseButton1Click:Connect(function() pcall(callback) end)
end

local function AddInfoCard(parent, title, defaultText)
    local Card = Instance.new("Frame", parent)
    Card.Size = UDim2.new(0.96, 0, 0, 45)
    Card.BackgroundColor3 = Color3.fromRGB(22, 28, 40)
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)
    
    local HeaderLbl = Instance.new("TextLabel", Card)
    HeaderLbl.Size = UDim2.new(1, -10, 0, 20)
    HeaderLbl.Position = UDim2.new(0, 10, 0, 3)
    HeaderLbl.Text = title
    HeaderLbl.Font = Enum.Font.GothamBold
    HeaderLbl.TextColor3 = Color3.fromRGB(0, 190, 255)
    HeaderLbl.TextSize = 11
    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLbl.BackgroundTransparency = 1
    
    local ContentLbl = Instance.new("TextLabel", Card)
    ContentLbl.Size = UDim2.new(1, -10, 0, 20)
    ContentLbl.Position = UDim2.new(0, 10, 0, 20)
    ContentLbl.Text = defaultText
    ContentLbl.Font = Enum.Font.Gotham
    ContentLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    ContentLbl.TextSize = 11
    ContentLbl.TextXAlignment = Enum.TextXAlignment.Left
    ContentLbl.BackgroundTransparency = 1
    
    return function(newText) ContentLbl.Text = newText end
end

-- ================================================================= --
-- 4. BUILD TABS & CONNECT ALL LOGIC
-- ================================================================= --
local MainTab = CreateTab("Main Farm", "⚔️")
local StatsTab = CreateTab("Stats", "📊")
local ShopTab = CreateTab("Shop & Teleport", "🛒")
local ServerTab = CreateTab("Status Tracker", "🌐")

-- Default Tab Selection
TabButtons[1].BackgroundColor3 = Color3.fromRGB(0, 140, 230)
TabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)
Tabs["Main Farm"].Visible = true

-- --- MAIN FARM TAB ---
AddToggle(MainTab, "Auto Farm Level", getgenv().Config.AutoFarm, function(val)
    getgenv().Config.AutoFarm = val
end)

AddToggle(MainTab, "Fast Attack (No Cooldown)", getgenv().Config.FastAttack, function(val)
    getgenv().Config.FastAttack = val
end)

-- --- STATS TAB ---
AddToggle(StatsTab, "Auto Melee (+1)", getgenv().Config.AutoStatMelee, function(v) getgenv().Config.AutoStatMelee = v end)
AddToggle(StatsTab, "Auto Defense (+1)", getgenv().Config.AutoStatDefense, function(v) getgenv().Config.AutoStatDefense = v end)
AddToggle(StatsTab, "Auto Sword (+1)", getgenv().Config.AutoStatSword, function(v) getgenv().Config.AutoStatSword = v end)
AddToggle(StatsTab, "Auto Gun (+1)", getgenv().Config.AutoStatGun, function(v) getgenv().Config.AutoStatGun = v end)
AddToggle(StatsTab, "Auto Blox Fruit (+1)", getgenv().Config.AutoStatDemonFruit, function(v) getgenv().Config.AutoStatDemonFruit = v end)

-- --- SHOP & TELEPORT TAB ---
local codes = {
    "WildDares", "BossBuild", "GetPranked", "Sub2OfficialNoobie", "Sub2Daigrock",
    "Sub2NoobMaster123", "Bluxxy", "JCWK", "Enyu_is_Pro", "Sub2Fer999",
    "kittgaming", "TheGreatAce", "StrawHatMaine", "TantaiGaming", "Axiore",
    "SUB2GAMERROBOT_EXP1", "MagicBus", "StarcodeHEO", "Sub2CaptainMaui", "FIGHT4FRUIT"
}

AddButton(ShopTab, "🎁 Redeem All Working Codes", function()
    for _, code in ipairs(codes) do
        task.spawn(function()
            if CommF then CommF:InvokeServer("Redeem", code) end
        end)
        task.wait(0.15)
    end
end)

AddButton(ShopTab, "⛵ Teleport to Sea 1 (Old World)", function() if CommF then CommF:InvokeServer("TravelMain") end end)
AddButton(ShopTab, "⚔️ Teleport to Sea 2 (New World)", function() if CommF then CommF:InvokeServer("TravelDressrosa") end end)
AddButton(ShopTab, "👑 Teleport to Sea 3 (Third Sea)", function() if CommF then CommF:InvokeServer("TravelZou") end end)

local melees = {
    {"Black Leg", "BuyBlackLeg"}, {"Fishman Karate", "BuyFishmanKarate"},
    {"Electro", "BuyElectro"}, {"Superhuman", "BuySuperhuman"},
    {"Death Step", "BuyDeathStep"}, {"Sharkman Karate", "BuySharkmanKarate"},
    {"Electric Claw", "BuyElectricClaw"}, {"Dragon Talon", "BuyDragonTalon"},
    {"Godhuman", "BuyGodhuman"}, {"Sanguine Art", "BuySanguineArt"}
}

for _, melee in ipairs(melees) do
    AddButton(ShopTab, "🥊 Buy " .. melee[1], function() if CommF then CommF:InvokeServer(melee[2]) end end)
end

-- --- SERVER TRACKER TAB ---
local UpdateTimeCard = AddInfoCard(ServerTab, "System Time & Region", "Loading...")
local UpdateUptimeCard = AddInfoCard(ServerTab, "Server Uptime", "Loading...")
local UpdateMirageCard = AddInfoCard(ServerTab, "Mirage Island Status", "Status: Checking...")
local UpdateKitsuneCard = AddInfoCard(ServerTab, "Kitsune Island Status", "Status: Checking...")
local UpdateIndraCard = AddInfoCard(ServerTab, "Rip_Indra Boss Status", "Status: Checking...")

task.spawn(function()
    local countryCode = "Unknown"
    pcall(function() countryCode = LocalizationService:GetCountryRegionForPlayerAsync(Player) end)
    
    while task.wait(1) do
        -- Live Date / Time Tracker
        local date = os.date("*t")
        local ampm = date.hour < 12 and "AM" or "PM"
        local timeStr = string.format("%02d:%02d:%02d %s | %02d/%02d/%04d [%s]", 
            ((date.hour - 1) % 12) + 1, date.min, date.sec, ampm, date.day, date.month, date.year, countryCode)
        UpdateTimeCard(timeStr)
        
        -- Server Uptime Tracker
        local totalSec = math.floor(workspace.DistributedGameTime)
        local h = math.floor(totalSec / 3600)
        local m = math.floor((totalSec % 3600) / 60)
        local s = totalSec % 60
        UpdateUptimeCard(string.format("%d Hours %d Minutes %d Seconds", h, m, s))
        
        -- Event/Boss Radar Tracker
        local mirage = workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island")
        UpdateMirageCard(mirage and "Status: ✅ Spawned" or "Status: ❌ Not Found")
        
        local kitsune = workspace.Map:FindFirstChild("KitsuneIsland")
        UpdateKitsuneCard(kitsune and "Status: ✅ Spawned" or "Status: ❌ Not Found")
        
        local indra = ReplicatedStorage:FindFirstChild("rip_indra True Form") or 
                      (workspace:FindFirstChild("Enemies") and workspace.Enemies:FindFirstChild("rip_indra"))
        UpdateIndraCard(indra and "Status: ✅ Active/Spawned" or "Status: ❌ Not Found")
    end
end)

print("🚀 [Studio3D UI] All Logic Refactored & Execution Successful!")