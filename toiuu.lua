--//========================================================
--// TUYENMOD2194 - ULTIMATE MODERN HUB (ICE FREEZE EDITION)
--// INTRO ANIMATION + FIX SCROLL + ICE SEA + SPEED/JUMP 300/500
--//========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--========================================================
-- CONFIG & CACHE
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
    LowMaterial = false,
    RemoveWater = false,
    FreezeWater = false,
    HideMap = false,
    HideNPC = false,
    HideAccessories = false
}

local PlayerStats = {
    WalkSpeed = 16,
    JumpPower = 50,
    EnableSpeed = false,
    EnableJump = false
}

local OriginalCache = {}
local OriginalLighting = {
    GlobalShadows = Lighting.GlobalShadows
}

--========================================================
-- COLOR PALETTE (CYBER DARK NAVY & NEON ACCENTS)
--========================================================

local COLOR_BG = Color3.fromRGB(15, 18, 25)          
local COLOR_HEADER = Color3.fromRGB(22, 27, 38)      
local COLOR_CARD = Color3.fromRGB(28, 35, 50)        
local COLOR_ACCENT = Color3.fromRGB(0, 180, 255)     
local COLOR_OFF = Color3.fromRGB(45, 52, 68)         
local COLOR_TEXT_MAIN = Color3.fromRGB(240, 245, 255)
local COLOR_TEXT_SUB = Color3.fromRGB(130, 145, 170) 
local COLOR_RED_INTRO = Color3.fromRGB(255, 60, 80)  

--========================================================
-- ROOT SCREEN GUI
--========================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "TuyenMod2194_ProUI_v2"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local UIScale = Instance.new("UIScale")
UIScale.Parent = Gui

local function UpdateScale()
    local Camera = Workspace.CurrentCamera
    if not Camera then return end
    local Viewport = Camera.ViewportSize
    local ScaleX = (Viewport.X - 20) / 580
    local ScaleY = (Viewport.Y - 20) / 330
    local Scale = math.clamp(math.min(ScaleX, ScaleY), 0.55, 1)
    UIScale.Scale = Scale
end
UpdateScale()
if Workspace.CurrentCamera then
    Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
end

--========================================================
-- INTRO ANIMATION (ĐỎ NHẠT MỜ DẦN)
--========================================================

local IntroOverlay = Instance.new("Frame")
IntroOverlay.Size = UDim2.new(1, 0, 1, 0)
IntroOverlay.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
IntroOverlay.BackgroundTransparency = 1
IntroOverlay.ZIndex = 500
IntroOverlay.Parent = Gui

local IntroText = Instance.new("TextLabel")
IntroText.Size = UDim2.new(1, 0, 0, 80)
IntroText.Position = UDim2.new(0, 0, 0.5, -40)
IntroText.BackgroundTransparency = 1
IntroText.Text = "TUYENMOD2194"
IntroText.TextColor3 = COLOR_RED_INTRO
IntroText.TextTransparency = 1
IntroText.TextSize = 42
IntroText.Font = Enum.Font.GothamBold
IntroText.ZIndex = 501
IntroText.Parent = IntroOverlay

--========================================================
-- MAIN GUI FRAME (FIXED CORNERS & CLEAN LAYOUT)
--========================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(580, 330)
Main.Position = UDim2.new(0.5, -290, 0.5, -165)
Main.BackgroundColor3 = COLOR_BG
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = COLOR_ACCENT
MainStroke.Transparency = 0.6
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 48)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = COLOR_HEADER
Header.BorderSizePixel = 0
Header.ZIndex = 20
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

-- LOGO TRÒN
local LogoFrame = Instance.new("Frame")
LogoFrame.Size = UDim2.fromOffset(32, 32)
LogoFrame.Position = UDim2.fromOffset(12, 8)
LogoFrame.BackgroundColor3 = COLOR_CARD
LogoFrame.BorderSizePixel = 0
LogoFrame.ZIndex = 25
LogoFrame.Parent = Header

local LogoFrameCorner = Instance.new("UICorner")
LogoFrameCorner.CornerRadius = UDim.new(1, 0)
LogoFrameCorner.Parent = LogoFrame

local LogoFrameStroke = Instance.new("UIStroke")
LogoFrameStroke.Color = COLOR_ACCENT
LogoFrameStroke.Thickness = 1.5
LogoFrameStroke.Parent = LogoFrame

local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(1, 0, 1, 0)
Logo.BackgroundTransparency = 1
Logo.Image = LOGO_THUMB
Logo.ZIndex = 26
Logo.Parent = LogoFrame

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = Logo

-- TITLE & SUBTITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 220, 0, 18)
Title.Position = UDim2.fromOffset(52, 8)
Title.BackgroundTransparency = 1
Title.Text = "TUYENMOD2194"
Title.TextColor3 = COLOR_TEXT_MAIN
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 25
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 220, 0, 14)
SubTitle.Position = UDim2.fromOffset(52, 26)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Ultimate FPS & Game Utility Hub"
SubTitle.TextColor3 = COLOR_TEXT_SUB
SubTitle.TextSize = 9
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.ZIndex = 25
SubTitle.Parent = Header

-- NÚT THU NHỎ & ĐÓNG
local OpenButton = Instance.new("ImageButton")
OpenButton.Size = UDim2.fromOffset(45, 45)
OpenButton.Position = UDim2.new(0.03, 0, 0.15, 0)
OpenButton.BackgroundColor3 = COLOR_HEADER
OpenButton.Image = LOGO_THUMB
OpenButton.Visible = false
OpenButton.ZIndex = 200
OpenButton.Parent = Gui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = COLOR_ACCENT
OpenStroke.Thickness = 2
OpenStroke.Parent = OpenButton

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(26, 26)
Minimize.Position = UDim2.new(1, -62, 0, 11)
Minimize.BackgroundColor3 = COLOR_CARD
Minimize.BorderSizePixel = 0
Minimize.Text = "-"
Minimize.TextColor3 = COLOR_TEXT_MAIN
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
Close.Position = UDim2.new(1, -32, 0, 11)
Close.BackgroundColor3 = Color3.fromRGB(200, 40, 60)
Close.BorderSizePixel = 0
Close.Text = "✕"
Close.TextColor3 = COLOR_TEXT_MAIN
Close.TextSize = 11
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
-- TAB SIDEBAR SYSTEM
--========================================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -56)
Sidebar.Position = UDim2.new(0, 8, 0, 52)
Sidebar.BackgroundColor3 = COLOR_HEADER
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -162, 1, -56)
TabContainer.Position = UDim2.new(0, 154, 0, 52)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Main

local Tabs = {}
local TabButtons = {}

local function CreateTab(Name, Icon, YOffset)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -12, 0, 36)
    Button.Position = UDim2.fromOffset(6, YOffset)
    Button.BackgroundColor3 = COLOR_CARD
    Button.BorderSizePixel = 0
    Button.Text = "  " .. Icon .. "   " .. Name
    Button.TextColor3 = COLOR_TEXT_SUB
    Button.TextSize = 10
    Button.Font = Enum.Font.GothamBold
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = Sidebar

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = COLOR_ACCENT
    Page.Visible = false
    Page.Parent = TabContainer

    Tabs[Name] = Page
    TabButtons[Name] = Button

    Button.MouseButton1Click:Connect(function()
        for _, p in pairs(Tabs) do p.Visible = false end
        for _, b in pairs(TabButtons) do 
            b.BackgroundColor3 = COLOR_CARD 
            b.TextColor3 = COLOR_TEXT_SUB
        end
        Page.Visible = true
        Button.BackgroundColor3 = COLOR_ACCENT
        Button.TextColor3 = COLOR_TEXT_MAIN
    end)

    return Page
end

local TabFPS = CreateTab("Tối Ưu FPS", "⚡", 8)
local TabSpeed = CreateTab("Di Chuyển", "🚀", 50)
local TabInfo = CreateTab("Thông Tin", "ℹ️", 92)

Tabs["Tối Ưu FPS"].Visible = true
TabButtons["Tối Ưu FPS"].BackgroundColor3 = COLOR_ACCENT
TabButtons["Tối Ưu FPS"].TextColor3 = COLOR_TEXT_MAIN

--========================================================
-- TOAST NOTIFICATION
--========================================================

local Toast = Instance.new("Frame")
Toast.Size = UDim2.fromOffset(210, 36)
Toast.Position = UDim2.new(1, -220, 1, 50)
Toast.BackgroundColor3 = COLOR_CARD
Toast.BorderSizePixel = 0
Toast.Visible = false
Toast.ZIndex = 100
Toast.Parent = Gui

local ToastCorner = Instance.new("UICorner")
ToastCorner.CornerRadius = UDim.new(0, 8)
ToastCorner.Parent = Toast

local ToastStroke = Instance.new("UIStroke")
ToastStroke.Color = COLOR_ACCENT
ToastStroke.Parent = Toast

local ToastText = Instance.new("TextLabel")
ToastText.Size = UDim2.new(1, -12, 1, 0)
ToastText.Position = UDim2.fromOffset(10, 0)
ToastText.BackgroundTransparency = 1
ToastText.Text = "Notification"
ToastText.TextColor3 = COLOR_TEXT_MAIN
ToastText.TextSize = 9
ToastText.Font = Enum.Font.GothamMedium
ToastText.TextXAlignment = Enum.TextXAlignment.Left
ToastText.Parent = Toast

local ToastToken = 0
local function ShowToast(Text)
    ToastToken += 1
    local Token = ToastToken
    ToastText.Text = "●  " .. Text
    Toast.Visible = true
    TweenService:Create(Toast, TweenInfo.new(0.25, Enum.EasingStyle.Quart), { Position = UDim2.new(1, -220, 1, -45) }):Play()

    task.delay(1.8, function()
        if Token ~= ToastToken then return end
        local Tween = TweenService:Create(Toast, TweenInfo.new(0.25, Enum.EasingStyle.Quart), { Position = UDim2.new(1, -220, 1, 50) })
        Tween:Play()
        Tween.Completed:Wait()
        if Token == ToastToken then Toast.Visible = false end
    end)
end

--========================================================
-- OPTIMIZATION ENGINE
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
-- TAB 1: TỐI ƯU FPS
--========================================================

TabFPS.CanvasSize = UDim2.new(0, 0, 0, 240)

local function CreateToggleCard(Name, Desc, Key, Parent, X, Y)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.fromOffset(195, 48)
    Card.Position = UDim2.fromOffset(X, Y)
    Card.BackgroundColor3 = COLOR_CARD
    Card.BorderSizePixel = 0
    Card.Parent = Parent

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Card

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 0, 18)
    Label.Position = UDim2.fromOffset(10, 6)
    Label.BackgroundTransparency = 1
    Label.Text = Name
    Label.TextColor3 = COLOR_TEXT_MAIN
    Label.TextSize = 10
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Card

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -50, 0, 16)
    DescLabel.Position = UDim2.fromOffset(10, 24)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = Desc
    DescLabel.TextColor3 = COLOR_TEXT_SUB
    DescLabel.TextSize = 8
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Parent = Card

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.fromOffset(34, 20)
    Btn.Position = UDim2.new(1, -40, 0.5, -10)
    Btn.BackgroundColor3 = Settings[Key] and COLOR_ACCENT or COLOR_OFF
    Btn.BorderSizePixel = 0
    Btn.Text = Settings[Key] and "BẬT" or "TẮT"
    Btn.TextColor3 = COLOR_TEXT_MAIN
    Btn.TextSize = 8
    Btn.Font = Enum.Font.GothamBold
    Btn.Parent = Card

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        Settings[Key] = not Settings[Key]
        Btn.Text = Settings[Key] and "BẬT" or "TẮT"
        Btn.BackgroundColor3 = Settings[Key] and COLOR_ACCENT or COLOR_OFF
        ShowToast(Name .. ": " .. (Settings[Key] and "Đã Bật" or "Đã Tắt"))
        RefreshAllObjects()
    end)
end

local TogglesList = {
    {"Tắt Bóng Hạ Cảnh", "Tắt bóng của vật thể giúp tăng FPS", "Shadows"},
    {"Tắt Hiệu Ứng", "Ẩn lửa, khói, hạt hiệu ứng skill", "Particles"},
    {"Tắt Ánh Sáng", "Tắt các loại đèn chiếu sáng", "Lights"},
    {"Tắt Decal/Texture", "Tắt ảnh dán bề mặt giảm VRAM", "Textures"},
    {"Vật Thể Nhẵn", "Chuyển chất liệu sang SmoothPlastic", "LowMaterial"},
    {"Xóa Mặt Biển", "Làm trong suốt nước biển bớt lag", "RemoveWater"},
    {"Ẩn Trang Phục", "Ẩn đồ phụ kiện trên người chơi", "HideAccessories"},
    {"Ẩn Công Trình", "Ẩn các công trình map xung quanh", "HideMap"},
    {"Ẩn Quái / NPC", "Ẩn mô hình NPC & quái vật", "HideNPC"}
}

for i, t in ipairs(TogglesList) do
    local col = (i - 1) % 2
    local row = math.floor((i - 1) / 2)
    CreateToggleCard(t[1], t[2], t[3], TabFPS, 6 + col * 203, 6 + row * 54)
end

--========================================================
-- TAB 2: DI CHUYỂN & BĂNG HÓA MẶT BIỂN
--========================================================

TabSpeed.CanvasSize = UDim2.new(0, 0, 0, 230)

local function CreateSliderCard(Name, Desc, Min, Max, Default, Parent, Y, Callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -12, 0, 60)
    Frame.Position = UDim2.fromOffset(6, Y)
    Frame.BackgroundColor3 = COLOR_CARD
    Frame.BorderSizePixel = 0
    Frame.Parent = Parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -70, 0, 18)
    TitleLabel.Position = UDim2.fromOffset(10, 6)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Name
    TitleLabel.TextColor3 = COLOR_TEXT_MAIN
    TitleLabel.TextSize = 10
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Frame

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -70, 0, 14)
    DescLabel.Position = UDim2.fromOffset(10, 22)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = Desc
    DescLabel.TextColor3 = COLOR_TEXT_SUB
    DescLabel.TextSize = 8
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Parent = Frame

    local ValLabel = Instance.new("TextLabel")
    ValLabel.Size = UDim2.fromOffset(50, 20)
    ValLabel.Position = UDim2.new(1, -58, 0, 6)
    ValLabel.BackgroundTransparency = 1
    ValLabel.Text = tostring(Default)
    ValLabel.TextColor3 = COLOR_ACCENT
    ValLabel.TextSize = 11
    ValLabel.Font = Enum.Font.GothamBold
    ValLabel.Parent = Frame

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, 6)
    SliderBar.Position = UDim2.fromOffset(10, 42)
    SliderBar.BackgroundColor3 = COLOR_BG
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = Frame

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 4)
    BarCorner.Parent = SliderBar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
    Fill.BackgroundColor3 = COLOR_ACCENT
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

-- Slider Chạy Nhanh tối đa 300
CreateSliderCard("Tốc Độ Di Chuyển (WalkSpeed)", "Điều chỉnh tốc độ nhân vật (Mặc định: 16, Tối đa: 300)", 16, 300, 16, TabSpeed, 6, function(Val)
    PlayerStats.WalkSpeed = Val
    PlayerStats.EnableSpeed = (Val > 16)
end)

-- Slider Nhảy Cao tối đa 500
CreateSliderCard("Độ Cao Nhảy (JumpPower)", "Điều chỉnh lực nhảy nhân vật (Mặc định: 50, Tối đa: 500)", 50, 500, 50, TabSpeed, 72, function(Val)
    PlayerStats.JumpPower = Val
    PlayerStats.EnableJump = (Val > 50)
end)

-- Chức năng Băng Hóa Mặt Biển (Freeze Water Platform)
local IceCard = Instance.new("Frame")
IceCard.Size = UDim2.new(1, -12, 0, 48)
IceCard.Position = UDim2.fromOffset(6, 138)
IceCard.BackgroundColor3 = COLOR_CARD
IceCard.BorderSizePixel = 0
IceCard.Parent = TabSpeed

local IceCardCorner = Instance.new("UICorner")
IceCardCorner.CornerRadius = UDim.new(0, 8)
IceCardCorner.Parent = IceCard

local IceLabel = Instance.new("TextLabel")
IceLabel.Size = UDim2.new(1, -50, 0, 18)
IceLabel.Position = UDim2.fromOffset(10, 6)
IceLabel.BackgroundTransparency = 1
IceLabel.Text = "Băng Hóa Mặt Biển (Đóng Băng)"
IceLabel.TextColor3 = COLOR_TEXT_MAIN
IceLabel.TextSize = 10
IceLabel.Font = Enum.Font.GothamBold
IceLabel.TextXAlignment = Enum.TextXAlignment.Left
IceLabel.Parent = IceCard

local IceDesc = Instance.new("TextLabel")
IceDesc.Size = UDim2.new(1, -50, 0, 16)
IceDesc.Position = UDim2.fromOffset(10, 24)
IceDesc.BackgroundTransparency = 1
IceDesc.Text = "Tạo tấm băng tuyết dưới chân giúp đi trên nước dễ dàng"
IceDesc.TextColor3 = COLOR_TEXT_SUB
IceDesc.TextSize = 8
IceDesc.Font = Enum.Font.Gotham
IceDesc.TextXAlignment = Enum.TextXAlignment.Left
IceDesc.Parent = IceCard

local IceBtn = Instance.new("TextButton")
IceBtn.Size = UDim2.fromOffset(34, 20)
IceBtn.Position = UDim2.new(1, -40, 0.5, -10)
IceBtn.BackgroundColor3 = COLOR_OFF
IceBtn.BorderSizePixel = 0
IceBtn.Text = "TẮT"
IceBtn.TextColor3 = COLOR_TEXT_MAIN
IceBtn.TextSize = 8
IceBtn.Font = Enum.Font.GothamBold
IceBtn.Parent = IceCard

local IceBtnCorner = Instance.new("UICorner")
IceBtnCorner.CornerRadius = UDim.new(0, 6)
IceBtnCorner.Parent = IceBtn

-- Khởi tạo Sàn Băng Tuyết
local IcePlatform = Instance.new("Part")
IcePlatform.Name = "TuyenMod_IcePlatform"
IcePlatform.Size = Vector3.new(30, 1, 30)
IcePlatform.Anchored = true
IcePlatform.Material = Enum.Material.Ice
IcePlatform.Color = Color3.fromRGB(180, 225, 255)
IcePlatform.Transparency = 0.3
IcePlatform.CanCollide = false
IcePlatform.Parent = Workspace

IceBtn.MouseButton1Click:Connect(function()
    Settings.FreezeWater = not Settings.FreezeWater
    IceBtn.Text = Settings.FreezeWater and "BẬT" or "TẮT"
    IceBtn.BackgroundColor3 = Settings.FreezeWater and COLOR_ACCENT or COLOR_OFF
    ShowToast("Băng Hóa Biển: " .. (Settings.FreezeWater and "Đã Bật" or "Đã Tắt"))
end)

-- LOOP GÁN TỐC ĐỘ / NHẢY & ĐÓNG BĂNG BIỂN
RunService.Stepped:Connect(function()
    if Player.Character then
        local Hum = Player.Character:FindFirstChildOfClass("Humanoid")
        local Root = Player.Character:FindFirstChild("HumanoidRootPart")

        if Hum then
            if PlayerStats.EnableSpeed then
                Hum.WalkSpeed = PlayerStats.WalkSpeed
            end
            if PlayerStats.EnableJump then
                Hum.UseJumpPower = true
                Hum.JumpPower = PlayerStats.JumpPower
            end
        end

        -- Xử lý sàn băng
        if Settings.FreezeWater and Root then
            local RayParam = RaycastParams.new()
            RayParam.FilterType = Enum.RaycastFilterType.Exclude
            RayParam.FilterDescendantsInstances = {Player.Character, IcePlatform}

            local RayCast = Workspace:Raycast(Root.Position, Vector3.new(0, -30, 0), RayParam)
            if RayCast and RayCast.Instance and RayCast.Instance:IsA("Terrain") and RayCast.Material == Enum.Material.Water then
                IcePlatform.CFrame = CFrame.new(Root.Position.X, RayCast.Position.Y + 0.2, Root.Position.Z)
                IcePlatform.CanCollide = true
            else
                IcePlatform.CanCollide = false
            end
        else
            IcePlatform.CanCollide = false
        end
    end
end)

--========================================================
-- TAB 3: THÔNG TIN SOCIALS
--========================================================

TabInfo.CanvasSize = UDim2.new(0, 0, 0, 190)

local function CreateSocialCard(Name, Desc, Icon, Link, Y)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -12, 0, 50)
    Card.Position = UDim2.fromOffset(6, Y)
    Card.BackgroundColor3 = COLOR_CARD
    Card.BorderSizePixel = 0
    Card.Parent = TabInfo

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Card

    local IconLbl = Instance.new("TextLabel")
    IconLbl.Size = UDim2.fromOffset(30, 50)
    IconLbl.Position = UDim2.fromOffset(10, 0)
    IconLbl.BackgroundTransparency = 1
    IconLbl.Text = Icon
    IconLbl.TextColor3 = COLOR_ACCENT
    IconLbl.TextSize = 16
    IconLbl.Font = Enum.Font.GothamBold
    IconLbl.Parent = Card

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -120, 0, 18)
    Label.Position = UDim2.fromOffset(42, 8)
    Label.BackgroundTransparency = 1
    Label.Text = Name
    Label.TextColor3 = COLOR_TEXT_MAIN
    Label.TextSize = 10
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Card

    local SubLbl = Instance.new("TextLabel")
    SubLbl.Size = UDim2.new(1, -120, 0, 14)
    SubLbl.Position = UDim2.fromOffset(42, 26)
    SubLbl.BackgroundTransparency = 1
    SubLbl.Text = Desc
    SubLbl.TextColor3 = COLOR_TEXT_SUB
    SubLbl.TextSize = 8
    SubLbl.Font = Enum.Font.Gotham
    SubLbl.TextXAlignment = Enum.TextXAlignment.Left
    SubLbl.Parent = Card

    local CopyBtn = Instance.new("TextButton")
    CopyBtn.Size = UDim2.fromOffset(65, 26)
    CopyBtn.Position = UDim2.new(1, -75, 0.5, -13)
    CopyBtn.BackgroundColor3 = COLOR_ACCENT
    CopyBtn.BorderSizePixel = 0
    CopyBtn.Text = "Sao Chép"
    CopyBtn.TextColor3 = COLOR_TEXT_MAIN
    CopyBtn.TextSize = 8
    CopyBtn.Font = Enum.Font.GothamBold
    CopyBtn.Parent = Card

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = CopyBtn

    CopyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            pcall(function() setclipboard(Link) end)
            ShowToast("Đã sao chép link " .. Name .. "!")
        else
            ShowToast("Executor không hỗ trợ sao chép!")
        end
    end)
end

CreateSocialCard("Kênh YouTube", "Đăng ký ủng hộ kênh chính thức", "▶", INFO.YouTube, 6)
CreateSocialCard("Kênh TikTok", "Xem các video ngắn mới nhất", "♪", INFO.TikTok, 62)
CreateSocialCard("Máy Chủ Discord", "Tham gia cộng đồng để nhận hỗ trợ", "◈", INFO.Discord, 118)

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

--========================================================
-- EXECUTE INTRO ANIMATION & DISPLAY MENU
--========================================================

task.spawn(function()
    -- Phase 1: Mờ nền và hiện chữ đỏ nhạt ở giữa
    TweenService:Create(IntroOverlay, TweenInfo.new(0.4), { BackgroundTransparency = 0.5 }):Play()
    TweenService:Create(IntroText, TweenInfo.new(0.6), { TextTransparency = 0.1 }):Play()
    task.wait(1.0)

    -- Phase 2: Chữ to ra và ẩn dần
    TweenService:Create(IntroText, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { 
        TextTransparency = 1,
        TextSize = 58
    }):Play()
    TweenService:Create(IntroOverlay, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
    task.wait(0.4)

    IntroOverlay:Destroy()

    -- Phase 3: Hiện Menu chính với hiệu ứng phóng to
    Main.Size = UDim2.fromOffset(500, 280)
    Main.Position = UDim2.new(0.5, -250, 0.5, -140)
    Main.Visible = true

    TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(580, 330),
        Position = UDim2.new(0.5, -290, 0.5, -165)
    }):Play()
end)

print("--- TUYENMOD2194 ANIMATED HUB SUCCESSFUL ---")