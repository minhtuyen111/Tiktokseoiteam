--//========================================================
--// TUYENMOD2194 - FPS OPTIMIZER & ULTIMATE HUB (RED/BLUE 16:9)
--// FULL REALTIME OPTIMIZE + SPEED/JUMP + NO FOG + WALK ON WATER
--//========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--========================================================
-- CONFIG & STATE CACHE
--========================================================

local LOGO_THUMB = "rbxthumb://type=Asset&id=115616028926793&w=420&h=420"

local INFO = {
    YouTube = "https://youtube.com/@tuyenmod2194?si=SyAfDv5tDOdjGZKB",
    TikTok = "https://www.tiktok.com/@laptrinhpy?_r=1&_t=ZS-98TDLqRxloX",
    Discord = "https://discord.gg/w39eWVa69"
}

local Settings = {
    Shadows = false,
    Particles = false,
    Lights = false,
    Textures = false,
    PostEffects = false,
    Atmosphere = false,
    LowMaterial = false,
    RemoveWater = false,
    RemoveFog = false,
    RemoveRain = false,
    HideMap = false,
    HideNPC = false,
    HideAccessories = false,
    WalkOnWater = false
}

local PlayerStats = {
    WalkSpeed = 16,
    JumpPower = 50
}

local OriginalCache = {}
local OriginalLighting = {
    GlobalShadows = Lighting.GlobalShadows,
    EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
    EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd
}

--========================================================
-- COLOR PALETTE (RED / WHITE / BLUE)
--========================================================

local COLOR_BG = Color3.fromRGB(15, 18, 26)          
local COLOR_HEADER = Color3.fromRGB(22, 26, 38)      
local COLOR_FRAME_BLUE = Color3.fromRGB(25, 42, 69)  
local COLOR_RED_BORDER = Color3.fromRGB(235, 45, 65) 
local COLOR_TEXT_WHITE = Color3.fromRGB(255, 255, 255)
local COLOR_TEXT_SUB = Color3.fromRGB(180, 195, 215)

--========================================================
-- GUI CREATION
--========================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "TuyenMod2194_16_9"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local UIScale = Instance.new("UIScale")
UIScale.Parent = Gui

local function UpdateScale()
    local Camera = Workspace.CurrentCamera
    if not Camera then return end
    local Viewport = Camera.ViewportSize
    local ScaleX = (Viewport.X - 20) / 540
    local ScaleY = (Viewport.Y - 20) / 303
    local Scale = math.clamp(math.min(ScaleX, ScaleY), 0.55, 1)
    UIScale.Scale = Scale
end
UpdateScale()
if Workspace.CurrentCamera then
    Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
end

-- MAIN FRAME (Tỉ lệ 16:9 -> 540 x 303)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(540, 303)
Main.Position = UDim2.new(0.5, -270, 0.5, -151)
Main.BackgroundColor3 = COLOR_BG
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = COLOR_RED_BORDER
MainStroke.Thickness = 2
MainStroke.Parent = Main

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = COLOR_HEADER
Header.BorderSizePixel = 0
Header.ZIndex = 20
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 12)
HeaderFix.Position = UDim2.new(0, 0, 1, -12)
HeaderFix.BackgroundColor3 = Header.BackgroundColor3
HeaderFix.BorderSizePixel = 0
HeaderFix.ZIndex = 20
HeaderFix.Parent = Header

local HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1, 0, 0, 2)
HeaderLine.Position = UDim2.new(0, 0, 1, -2)
HeaderLine.BackgroundColor3 = COLOR_RED_BORDER
HeaderLine.BorderSizePixel = 0
HeaderLine.ZIndex = 21
HeaderLine.Parent = Header

-- LOGO & TITLE
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.fromOffset(32, 32)
Logo.Position = UDim2.fromOffset(10, 6)
Logo.BackgroundTransparency = 1
Logo.Image = LOGO_THUMB
Logo.ZIndex = 25
Logo.Parent = Header

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 8)
LogoCorner.Parent = Logo

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 0, 20)
Title.Position = UDim2.fromOffset(48, 5)
Title.BackgroundTransparency = 1
Title.Text = "TUYENMOD2194"
Title.TextColor3 = COLOR_TEXT_WHITE
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 25
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 200, 0, 14)
SubTitle.Position = UDim2.fromOffset(48, 24)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Ultimate FPS & Utility Hub"
SubTitle.TextColor3 = COLOR_TEXT_SUB
SubTitle.TextSize = 9
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.ZIndex = 25
SubTitle.Parent = Header

-- MINIMIZE & CLOSE BUTTONS
local OpenButton = Instance.new("ImageButton")
OpenButton.Size = UDim2.fromOffset(45, 45)
OpenButton.Position = UDim2.new(0.05, 0, 0.15, 0)
OpenButton.BackgroundColor3 = COLOR_HEADER
OpenButton.Image = LOGO_THUMB
OpenButton.Visible = false
OpenButton.ZIndex = 200
OpenButton.Parent = Gui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 10)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = COLOR_RED_BORDER
OpenStroke.Thickness = 2
OpenStroke.Parent = OpenButton

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(26, 26)
Minimize.Position = UDim2.new(1, -62, 0, 9)
Minimize.BackgroundColor3 = COLOR_FRAME_BLUE
Minimize.BorderSizePixel = 0
Minimize.Text = "-"
Minimize.TextColor3 = COLOR_TEXT_WHITE
Minimize.TextSize = 16
Minimize.Font = Enum.Font.GothamBold
Minimize.ZIndex = 30
Minimize.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = Minimize

Minimize.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenButton.Visible = false
end)

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(26, 26)
Close.Position = UDim2.new(1, -32, 0, 9)
Close.BackgroundColor3 = COLOR_RED_BORDER
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = COLOR_TEXT_WHITE
Close.TextSize = 16
Close.Font = Enum.Font.GothamBold
Close.ZIndex = 30
Close.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = Close

Close.MouseButton1Click:Connect(function()
    Gui:Destroy()
end)

--========================================================
-- TAB SIDEBAR SYSTEM (LEFT SIDE)
--========================================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = COLOR_HEADER
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarDivider = Instance.new("Frame")
SidebarDivider.Size = UDim2.new(0, 2, 1, 0)
SidebarDivider.Position = UDim2.new(1, -2, 0, 0)
SidebarDivider.BackgroundColor3 = COLOR_RED_BORDER
SidebarDivider.BorderSizePixel = 0
SidebarDivider.Parent = Sidebar

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -130, 1, -45)
TabContainer.Position = UDim2.new(0, 130, 0, 45)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Main

local Tabs = {}
local TabButtons = {}

local function CreateTab(Name, Icon, YOffset)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -16, 0, 36)
    Button.Position = UDim2.fromOffset(8, YOffset)
    Button.BackgroundColor3 = COLOR_FRAME_BLUE
    Button.BorderSizePixel = 0
    Button.Text = Icon .. "  " .. Name
    Button.TextColor3 = COLOR_TEXT_WHITE
    Button.TextSize = 10
    Button.Font = Enum.Font.GothamBold
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = Sidebar

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = COLOR_RED_BORDER
    BtnStroke.Transparency = 0.6
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Button

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = COLOR_RED_BORDER
    Page.Visible = false
    Page.Parent = TabContainer

    Tabs[Name] = Page
    TabButtons[Name] = Button

    Button.MouseButton1Click:Connect(function()
        for _, p in pairs(Tabs) do p.Visible = false end
        for _, b in pairs(TabButtons) do 
            b.BackgroundColor3 = COLOR_FRAME_BLUE 
            b:FindFirstChildOfClass("UIStroke").Transparency = 0.6
        end
        Page.Visible = true
        Button.BackgroundColor3 = COLOR_RED_BORDER
        Button.UIStroke.Transparency = 0
    end)

    return Page
end

local TabFPS = CreateTab("TỐI ƯU FPS", "⚡", 10)
local TabSpeed = CreateTab("TỐC ĐỘ / NHẢY", "🚀", 52)
local TabInfo = CreateTab("THÔNG TIN", "ℹ️", 94)

Tabs["TỐI ƯU FPS"].Visible = true
TabButtons["TỐI ƯU FPS"].BackgroundColor3 = COLOR_RED_BORDER
TabButtons["TỐI ƯU FPS"].UIStroke.Transparency = 0

--========================================================
-- TOAST NOTIFICATION
--========================================================

local Toast = Instance.new("Frame")
Toast.Size = UDim2.fromOffset(200, 35)
Toast.Position = UDim2.new(1, -210, 1, 40)
Toast.BackgroundColor3 = COLOR_FRAME_BLUE
Toast.BorderSizePixel = 0
Toast.Visible = false
Toast.ZIndex = 100
Toast.Parent = Gui

local ToastCorner = Instance.new("UICorner")
ToastCorner.CornerRadius = UDim.new(0, 8)
ToastCorner.Parent = Toast

local ToastStroke = Instance.new("UIStroke")
ToastStroke.Color = COLOR_RED_BORDER
ToastStroke.Parent = Toast

local ToastText = Instance.new("TextLabel")
ToastText.Size = UDim2.new(1, -10, 1, 0)
ToastText.Position = UDim2.fromOffset(10, 0)
ToastText.BackgroundTransparency = 1
ToastText.Text = "Notification"
ToastText.TextColor3 = COLOR_TEXT_WHITE
ToastText.TextSize = 10
ToastText.Font = Enum.Font.GothamBold
ToastText.TextXAlignment = Enum.TextXAlignment.Left
ToastText.Parent = Toast

local ToastToken = 0
local function ShowToast(Text)
    ToastToken += 1
    local Token = ToastToken
    ToastText.Text = "●  " .. Text
    Toast.Visible = true
    TweenService:Create(Toast, TweenInfo.new(0.2), { Position = UDim2.new(1, -210, 1, -45) }):Play()

    task.delay(1.8, function()
        if Token ~= ToastToken then return end
        local Tween = TweenService:Create(Toast, TweenInfo.new(0.2), { Position = UDim2.new(1, -210, 1, 40) })
        Tween:Play()
        Tween.Completed:Wait()
        if Token == ToastToken then Toast.Visible = false end
    end)
end

--========================================================
-- REALTIME OPTIMIZATION ENGINE
--========================================================

local function SaveOriginal(Obj, Prop, Val)
    if not OriginalCache[Obj] then OriginalCache[Obj] = {} end
    if OriginalCache[Obj][Prop] == nil then OriginalCache[Obj][Prop] = Val end
end

local function ProcessObject(Object)
    if not Object or not Object.Parent then return end
    
    if Player.Character and Object:IsDescendantOf(Player.Character) then
        if Settings.HideAccessories and (Object:IsA("Accessory") or Object:IsA("Clothing")) then
            SaveOriginal(Object, "Parent", Object.Parent)
            Object.Parent = nil
        end
        return
    end

    if Settings.HideAccessories and (Object:IsA("Accessory") or Object:IsA("Clothing")) then
        SaveOriginal(Object, "Parent", Object.Parent)
        Object.Parent = nil
    elseif not Settings.HideAccessories and OriginalCache[Object] and OriginalCache[Object].Parent then
        Object.Parent = OriginalCache[Object].Parent
    end

    if Object:IsA("BasePart") or Object:IsA("MeshPart") then
        local Model = Object:FindFirstAncestorOfClass("Model")
        if Model and Model:FindFirstChildOfClass("Humanoid") and Model ~= Player.Character then
            if Settings.HideNPC then
                SaveOriginal(Object, "LocalTransparencyModifier", Object.LocalTransparencyModifier)
                Object.LocalTransparencyModifier = 1
            elseif OriginalCache[Object] and OriginalCache[Object].LocalTransparencyModifier then
                Object.LocalTransparencyModifier = OriginalCache[Object].LocalTransparencyModifier
            end
        end
    end

    if Settings.HideMap and (Object:IsA("BasePart") or Object:IsA("MeshPart")) then
        local Model = Object:FindFirstAncestorOfClass("Model")
        if not (Model and Model:FindFirstChildOfClass("Humanoid")) then
            SaveOriginal(Object, "LocalTransparencyModifier", Object.LocalTransparencyModifier)
            Object.LocalTransparencyModifier = 1
        end
    elseif not Settings.HideMap and (Object:IsA("BasePart") or Object:IsA("MeshPart")) and OriginalCache[Object] and OriginalCache[Object].LocalTransparencyModifier then
        Object.LocalTransparencyModifier = OriginalCache[Object].LocalTransparencyModifier
    end

    if Object:IsA("BasePart") then
        if Settings.Shadows then
            SaveOriginal(Object, "CastShadow", Object.CastShadow)
            Object.CastShadow = false
        elseif OriginalCache[Object] and OriginalCache[Object].CastShadow ~= nil then
            Object.CastShadow = OriginalCache[Object].CastShadow
        end
    end

    if Object:IsA("ParticleEmitter") or Object:IsA("Trail") or Object:IsA("Beam") or Object:IsA("Sparkles") or Object:IsA("Fire") or Object:IsA("Smoke") then
        if Settings.Particles then
            SaveOriginal(Object, "Enabled", Object.Enabled)
            Object.Enabled = false
        elseif OriginalCache[Object] and OriginalCache[Object].Enabled ~= nil then
            Object.Enabled = OriginalCache[Object].Enabled
        end
    end

    if Object:IsA("Light") then
        if Settings.Lights then
            SaveOriginal(Object, "Enabled", Object.Enabled)
            Object.Enabled = false
        elseif OriginalCache[Object] and OriginalCache[Object].Enabled ~= nil then
            Object.Enabled = OriginalCache[Object].Enabled
        end
    end

    if Object:IsA("Texture") or Object:IsA("Decal") then
        if Settings.Textures then
            SaveOriginal(Object, "Transparency", Object.Transparency)
            Object.Transparency = 1
        elseif OriginalCache[Object] and OriginalCache[Object].Transparency ~= nil then
            Object.Transparency = OriginalCache[Object].Transparency
        end
    end

    if Object:IsA("BasePart") then
        if Settings.LowMaterial then
            SaveOriginal(Object, "Material", Object.Material)
            Object.Material = Enum.Material.SmoothPlastic
        elseif OriginalCache[Object] and OriginalCache[Object].Material ~= nil then
            Object.Material = OriginalCache[Object].Material
        end
    end
end

local function ApplyGlobalLighting()
    if Settings.Shadows then
        Lighting.GlobalShadows = false
    else
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
    end

    if Settings.RemoveFog then
        Lighting.FogStart = 0
        Lighting.FogEnd = 1e6
    else
        Lighting.FogStart = OriginalLighting.FogStart
        Lighting.FogEnd = OriginalLighting.FogEnd
    end

    local Terrain = Workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        if Settings.RemoveWater then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterTransparency = 1
        else
            Terrain.WaterWaveSize = 0.15
            Terrain.WaterWaveSpeed = 10
            Terrain.WaterTransparency = 0.5
        end
    end
end

local function RefreshAllObjects()
    ApplyGlobalLighting()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        ProcessObject(obj)
    end
end

Workspace.DescendantAdded:Connect(function(obj)
    task.defer(function() ProcessObject(obj) end)
end)

--========================================================
-- TAB 1: TỐI ƯU FPS (UI & TOGGLES)
--========================================================

TabFPS.CanvasSize = UDim2.new(0, 0, 0, 240)

local function CreateToggle(Name, Key, Parent, X, Y)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.fromOffset(185, 32)
    Frame.Position = UDim2.fromOffset(X, Y)
    Frame.BackgroundColor3 = COLOR_FRAME_BLUE
    Frame.BorderSizePixel = 0
    Frame.Parent = Parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -45, 1, 0)
    Label.Position = UDim2.fromOffset(8, 0)
    Label.BackgroundTransparency = 1
    Label.Text = Name
    Label.TextColor3 = COLOR_TEXT_WHITE
    Label.TextSize = 9
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.fromOffset(32, 18)
    Btn.Position = UDim2.new(1, -38, 0.5, -9)
    Btn.BackgroundColor3 = Settings[Key] and COLOR_RED_BORDER or Color3.fromRGB(50, 60, 80)
    Btn.BorderSizePixel = 0
    Btn.Text = Settings[Key] and "ON" or "OFF"
    Btn.TextColor3 = COLOR_TEXT_WHITE
    Btn.TextSize = 8
    Btn.Font = Enum.Font.GothamBold
    Btn.Parent = Frame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        Settings[Key] = not Settings[Key]
        Btn.Text = Settings[Key] and "ON" or "OFF"
        Btn.BackgroundColor3 = Settings[Key] and COLOR_RED_BORDER or Color3.fromRGB(50, 60, 80)
        ShowToast(Name .. ": " .. (Settings[Key] and "BẬT" or "TẮT"))
        RefreshAllObjects()
    end)
end

-- Thêm No Fog (Xóa Sương Mù) vào danh sách toggle tối ưu
local TogglesList = {
    {"Tắt Bóng (Shadows)", "Shadows"},
    {"Tắt Hiệu Ứng (Particles)", "Particles"},
    {"Tắt Ánh Sáng (Lights)", "Lights"},
    {"Tắt Textures/Decals", "Textures"},
    {"Vật Thể Nhẵn (LowMat)", "LowMaterial"},
    {"Xóa Mặt Biển", "RemoveWater"},
    {"Xóa Sương Mù (No Fog)", "RemoveFog"},
    {"Ẩn Trang Phục", "HideAccessories"},
    {"Ẩn Công Trình (Map)", "HideMap"},
    {"Ẩn NPC / Quái", "HideNPC"}
}

for i, t in ipairs(TogglesList) do
    local col = (i - 1) % 2
    local row = math.floor((i - 1) / 2)
    CreateToggle(t[1], t[2], TabFPS, 10 + col * 193, 10 + row * 38)
end

--========================================================
-- TAB 2: TỐC ĐỘ / NHẢY & WALK ON WATER
--========================================================

TabSpeed.CanvasSize = UDim2.new(0, 0, 0, 240)

local function CreateSlider(Name, Min, Max, Default, Parent, Y, Callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -20, 0, 50)
    Frame.Position = UDim2.fromOffset(10, Y)
    Frame.BackgroundColor3 = COLOR_FRAME_BLUE
    Frame.BorderSizePixel = 0
    Frame.Parent = Parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -60, 0, 20)
    TitleLabel.Position = UDim2.fromOffset(10, 4)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Name
    TitleLabel.TextColor3 = COLOR_TEXT_WHITE
    TitleLabel.TextSize = 10
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Frame

    local ValLabel = Instance.new("TextLabel")
    ValLabel.Size = UDim2.fromOffset(50, 20)
    ValLabel.Position = UDim2.new(1, -55, 0, 4)
    ValLabel.BackgroundTransparency = 1
    ValLabel.Text = tostring(Default)
    ValLabel.TextColor3 = COLOR_RED_BORDER
    ValLabel.TextSize = 11
    ValLabel.Font = Enum.Font.GothamBold
    ValLabel.Parent = Frame

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, 8)
    SliderBar.Position = UDim2.fromOffset(10, 30)
    SliderBar.BackgroundColor3 = Color3.fromRGB(15, 22, 35)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = Frame

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 4)
    BarCorner.Parent = SliderBar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
    Fill.BackgroundColor3 = COLOR_RED_BORDER
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 4)
    FillCorner.Parent = Fill

    local Dragging = false
    local function UpdateInput(input)
        local Pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(Pos, 0, 1, 0)
        local Value = math.floor(Min + Pos * (Max - Min))
        ValLabel.Text = tostring(Value)
        Callback(Value)
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            UpdateInput(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
end

CreateSlider("Tốc Độ Chạy (WalkSpeed)", 16, 300, 16, TabSpeed, 10, function(Val)
    PlayerStats.WalkSpeed = Val
end)

CreateSlider("Nhảy Cao (JumpPower)", 50, 500, 50, TabSpeed, 70, function(Val)
    PlayerStats.JumpPower = Val
end)

CreateToggle("Không Thể Rớt Biển (Walk On Water)", "WalkOnWater", TabSpeed, 10, 130)

local WaterPlatform = Instance.new("Part")
WaterPlatform.Name = "WaterPlatform_TuyenMod"
WaterPlatform.Size = Vector3.new(20, 1, 20)
WaterPlatform.Anchored = true
WaterPlatform.Transparency = 1
WaterPlatform.CanCollide = false
WaterPlatform.Parent = Workspace

RunService.RenderStepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        local Hum = Player.Character:FindFirstChildOfClass("Humanoid")
        local Root = Player.Character:FindFirstChild("HumanoidRootPart")

        Hum.WalkSpeed = PlayerStats.WalkSpeed
        Hum.UseJumpPower = true
        Hum.JumpPower = PlayerStats.JumpPower

        if Settings.WalkOnWater and Root then
            local RayParam = RaycastParams.new()
            RayParam.FilterType = Enum.RaycastFilterType.Exclude
            RayParam.FilterDescendantsInstances = {Player.Character, WaterPlatform}

            local RayCast = Workspace:Raycast(Root.Position, Vector3.new(0, -50, 0), RayParam)
            if RayCast and RayCast.Instance and RayCast.Instance:IsA("Terrain") and RayCast.Material == Enum.Material.Water then
                WaterPlatform.CFrame = CFrame.new(Root.Position.X, RayCast.Position.Y - 0.5, Root.Position.Z)
                WaterPlatform.CanCollide = true
            else
                WaterPlatform.CanCollide = false
            end
        else
            WaterPlatform.CanCollide = false
        end
    end
end)

--========================================================
-- TAB 3: THÔNG TIN (SOCIAL LINKS)
--========================================================

TabInfo.CanvasSize = UDim2.new(0, 0, 0, 200)

local function CreateSocialBtn(Name, Icon, Link, Y)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -20, 0, 36)
    Btn.Position = UDim2.fromOffset(10, Y)
    Btn.BackgroundColor3 = COLOR_FRAME_BLUE
    Btn.BorderSizePixel = 0
    Btn.Text = ""
    Btn.Parent = TabInfo

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = COLOR_RED_BORDER
    Stroke.Transparency = 0.5
    Stroke.Parent = Btn

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Position = UDim2.fromOffset(10, 0)
    Label.BackgroundTransparency = 1
    Label.Text = Icon .. "  " .. Name .. "  •  Nhấn để Copy Link"
    Label.TextColor3 = COLOR_TEXT_WHITE
    Label.TextSize = 10
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        if setclipboard then
            pcall(function() setclipboard(Link) end)
            ShowToast("Đã copy link " .. Name .. "!")
        else
            ShowToast("Executor không hỗ trợ copy!")
        end
    end)
end

CreateSocialBtn("YouTube Channel", "▶", INFO.YouTube, 10)
CreateSocialBtn("TikTok Official", "♪", INFO.TikTok, 55)
CreateSocialBtn("Discord Server", "◈", INFO.Discord, 100)

--========================================================
-- DRAGGABLE SYSTEM
--========================================================

local function MakeDraggable(Object, Handle)
    local Dragging = false
    local DragStart, StartPos

    Handle.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = Input.Position
            StartPos = Object.Position

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = Input.Position - DragStart
            Object.Position = UDim2.new(
                StartPos.X.Scale,
                StartPos.X.Offset + Delta.X,
                StartPos.Y.Scale,
                StartPos.Y.Offset + Delta.Y
            )
        end
    end)
end

MakeDraggable(Main, Header)
MakeDraggable(OpenButton, OpenButton)

print("--- TUYENMOD2194 RED/BLUE HUB LOADED SUCCESSFULLY ---")