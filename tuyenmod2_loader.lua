--//========================================================
--// TUYEN MOD - ULTRA FIX LAG & NO FOG REWRITE 
--// FIXED CLOSE BUTTON DISPLAY (CLEAN X ICON)
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
-- CONFIG & CACHE AN TOÀN
--========================================================

local LOGO_THUMB = "rbxthumb://type=Asset&id=115616028926793&w=420&h=420"
local FONT_FALLBACK = Enum.Font.SourceSansBold

local function ApplyFont(TextObject)
    pcall(function()
        TextObject.Font = FONT_FALLBACK
    end)
end

local INFO = {
    YouTube = "https://youtube.com/@tuyenmod2194?si=SyAfDv5tDOdjGZKB",
    TikTok = "https://www.tiktok.com/@laptrinhpy?_r=1&_t=ZS-98TDLqRxloX",
    Discord = "https://discord.gg/w39eWVa69"
}

local Settings = {
    FreezeWater = false,    -- Đóng băng biển
    ClearFog = false,       -- Xóa sương mù toàn map (Engine mới)
    Particles = false,      -- Xóa 100% hiệu ứng VFX
    LowMaterial = false,    -- Làm nhẵn vật thể
    RemoveWater = false,    -- Ẩn mặt biển
    Shadows = false,        -- Tắt bóng
    Lights = false,         -- Tắt đèn
    Textures = false,       -- Tắt Decal/Texture
    HideMap = false,        -- Ẩn công trình
    HideNPC = false,        -- Ẩn quái / NPC
    HideAccessories = false -- Ẩn trang phục
}

local PlayerStats = {
    WalkSpeed = 16,
    JumpPower = 50,
    EnableSpeed = false,
    EnableJump = false
}

local OriginalCache = {}

--========================================================
-- COLOR PALETTE
--========================================================

local COLOR_BG = Color3.fromRGB(13, 16, 23)          
local COLOR_HEADER = Color3.fromRGB(20, 25, 35)      
local COLOR_CARD = Color3.fromRGB(26, 33, 46)        
local COLOR_ACCENT = Color3.fromRGB(0, 170, 255)     
local COLOR_OFF = Color3.fromRGB(42, 48, 62)         
local COLOR_TEXT_MAIN = Color3.fromRGB(240, 245, 255)
local COLOR_TEXT_SUB = Color3.fromRGB(140, 155, 180) 
local COLOR_RED_INTRO = Color3.fromRGB(255, 70, 85)  

--========================================================
-- ROOT SCREEN GUI
--========================================================

if PlayerGui:FindFirstChild("TuyenMod2194_FixLagUI") then
    PlayerGui.TuyenMod2194_FixLagUI:Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "TuyenMod2194_FixLagUI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

local UIScale = Instance.new("UIScale")
UIScale.Parent = Gui

local function UpdateScale()
    pcall(function()
        local Camera = Workspace.CurrentCamera
        if not Camera then return end
        local Viewport = Camera.ViewportSize
        local ScaleX = (Viewport.X - 20) / 580
        local ScaleY = (Viewport.Y - 20) / 330
        local Scale = math.clamp(math.min(ScaleX, ScaleY), 0.55, 1)
        UIScale.Scale = Scale
    end)
end
UpdateScale()
if Workspace.CurrentCamera then
    Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
end

--========================================================
-- DRAGGABLE ENGINE
--========================================================

local function MakeDraggable(Frame, DragHandle)
    local Handle = DragHandle or Frame
    local dragging, dragInput, dragStart, startPos

    Handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

--========================================================
-- INTRO ANIMATION
--========================================================

local IntroOverlay = Instance.new("Frame")
IntroOverlay.Size = UDim2.new(1, 0, 1, 0)
IntroOverlay.Position = UDim2.new(0, 0, 0, 0)
IntroOverlay.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
IntroOverlay.BackgroundTransparency = 0
IntroOverlay.ZIndex = 99999
IntroOverlay.Parent = Gui

local IntroText = Instance.new("TextLabel")
IntroText.Size = UDim2.new(1, 0, 0, 100)
IntroText.Position = UDim2.new(0, 0, 0.5, -50)
IntroText.BackgroundTransparency = 1
IntroText.Text = "TUYENMOD2194"
IntroText.TextColor3 = COLOR_RED_INTRO
IntroText.TextTransparency = 1
IntroText.TextSize = 46
IntroText.ZIndex = 100000
ApplyFont(IntroText)
IntroText.Parent = IntroOverlay

local IntroSub = Instance.new("TextLabel")
IntroSub.Size = UDim2.new(1, 0, 0, 30)
IntroSub.Position = UDim2.new(0, 0, 0.5, 30)
IntroSub.BackgroundTransparency = 1
IntroSub.Text = "ULTRA BOOST LOADING..."
IntroSub.TextColor3 = Color3.fromRGB(200, 200, 220)
IntroSub.TextTransparency = 1
IntroSub.TextSize = 14
IntroSub.ZIndex = 100000
ApplyFont(IntroSub)
IntroSub.Parent = IntroOverlay

--========================================================
-- MAIN GUI FRAME
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
Header.BackgroundColor3 = COLOR_HEADER
Header.BorderSizePixel = 0
Header.ZIndex = 20
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

MakeDraggable(Main, Header)

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

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 220, 0, 18)
Title.Position = UDim2.fromOffset(52, 8)
Title.BackgroundTransparency = 1
Title.Text = "TUYEN MOD – ULTRA FIX LAG"
Title.TextColor3 = COLOR_TEXT_MAIN
Title.TextSize = 13
ApplyFont(Title)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 25
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 220, 0, 14)
SubTitle.Position = UDim2.fromOffset(52, 26)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Max Performance & No Fog"
SubTitle.TextColor3 = COLOR_TEXT_SUB
SubTitle.TextSize = 9
ApplyFont(SubTitle)
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.ZIndex = 25
SubTitle.Parent = Header

-- TOGGLE LOGO BUTTON
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

MakeDraggable(OpenButton)

-- NÚT THU NHỎ (-)
local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(26, 26)
Minimize.Position = UDim2.new(1, -62, 0, 11)
Minimize.BackgroundColor3 = COLOR_CARD
Minimize.BorderSizePixel = 0
Minimize.Text = "-"
Minimize.TextColor3 = COLOR_TEXT_MAIN
Minimize.TextSize = 18
Minimize.Font = Enum.Font.SourceSansBold
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

-- NÚT ĐÓNG (X) - ĐÃ FIX HIỂN THỊ CHUẨN 100%
local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(26, 26)
Close.Position = UDim2.new(1, -32, 0, 11)
Close.BackgroundColor3 = Color3.fromRGB(220, 50, 65)
Close.BorderSizePixel = 0
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 14
Close.Font = Enum.Font.SourceSansBold
Close.ZIndex = 30
Close.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = Close

Close.MouseButton1Click:Connect(function()
    Gui:Destroy()
end)

-- RUN INTRO
task.spawn(function()
    TweenService:Create(IntroText, TweenInfo.new(1), {TextTransparency = 0}):Play()
    TweenService:Create(IntroSub, TweenInfo.new(1), {TextTransparency = 0}):Play()
    task.wait(2.5)
    TweenService:Create(IntroText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(IntroSub, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(IntroOverlay, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    task.wait(0.5)
    pcall(function() IntroOverlay:Destroy() end)
    Main.Visible = true
end)

--========================================================
-- TAB SIDEBAR
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
    ApplyFont(Button)
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
Toast.Size = UDim2.fromOffset(220, 36)
Toast.Position = UDim2.new(1, -230, 1, 50)
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
ApplyFont(ToastText)
ToastText.TextXAlignment = Enum.TextXAlignment.Left
ToastText.Parent = Toast

local ToastToken = 0
local function ShowToast(Text)
    ToastToken = ToastToken + 1
    local Token = ToastToken
    ToastText.Text = "●  " .. Text
    Toast.Visible = true
    TweenService:Create(Toast, TweenInfo.new(0.25, Enum.EasingStyle.Quart), { Position = UDim2.new(1, -230, 1, -45) }):Play()

    task.delay(1.8, function()
        if Token ~= ToastToken then return end
        local Tween = TweenService:Create(Toast, TweenInfo.new(0.25, Enum.EasingStyle.Quart), { Position = UDim2.new(1, -230, 1, 50) })
        Tween:Play()
        Tween.Completed:Wait()
        if Token == ToastToken then Toast.Visible = false end
    end)
end

--========================================================
-- ENGINE XÓA SƯƠNG MÙ HOÀN TOÀN
--========================================================

local function RemoveFogEngine()
    pcall(function()
        if Settings.ClearFog then
            Lighting.FogStart = 9999999
            Lighting.FogEnd = 9999999
            Lighting.GlobalShadows = false
            
            for _, child in ipairs(Lighting:GetChildren()) do
                if child:IsA("Atmosphere") or child:IsA("PostEffect") or child:IsA("BloomEffect") or child:IsA("BlurEffect") or child:IsA("DepthOfFieldEffect") then
                    child:Destroy()
                elseif child:IsA("ColorCorrectionEffect") then
                    child.Enabled = false
                end
            end

            Lighting.ClockTime = 14
            Lighting.Brightness = 2
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
        end
    end)
end

local function SaveOriginal(Obj, Prop, Val)
    if not OriginalCache[Obj] then OriginalCache[Obj] = {} end
    if OriginalCache[Obj][Prop] == nil then OriginalCache[Obj][Prop] = Val end
end

local function ProcessObject(Object)
    pcall(function()
        if not Object or not Object.Parent then return end
        
        if Settings.HideAccessories and (Object:IsA("Accessory") or Object:IsA("Clothing")) then
            if not (Player.Character and Object:IsDescendantOf(Player.Character)) then
                SaveOriginal(Object, "Parent", Object.Parent)
                Object.Parent = nil
            end
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

        if Settings.Particles then
            if Object:IsA("ParticleEmitter") or Object:IsA("Trail") or Object:IsA("Beam") or 
               Object:IsA("Sparkles") or Object:IsA("Fire") or Object:IsA("Smoke") or 
               Object:IsA("Highlight") or Object:IsA("Explosion") or Object:IsA("SelectionBox") then
                SaveOriginal(Object, "Enabled", Object.Enabled)
                Object.Enabled = false
            end
        elseif OriginalCache[Object] and OriginalCache[Object].Enabled ~= nil then
            Object.Enabled = OriginalCache[Object].Enabled
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
                SaveOriginal(Object, "Reflectance", Object.Reflectance)
                Object.Material = Enum.Material.SmoothPlastic
                Object.Reflectance = 0
            elseif OriginalCache[Object] and OriginalCache[Object].Material ~= nil then
                Object.Material = OriginalCache[Object].Material
                Object.Reflectance = OriginalCache[Object].Reflectance or 0
            end
        end
    end)
end

local function RefreshAllObjects()
    RemoveFogEngine()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        ProcessObject(obj)
    end
end

Workspace.DescendantAdded:Connect(function(obj)
    task.defer(function() ProcessObject(obj) end)
end)

Lighting.ChildAdded:Connect(function(child)
    if Settings.ClearFog then
        task.defer(function()
            if child:IsA("Atmosphere") or child:IsA("PostEffect") then
                child:Destroy()
            end
        end)
    end
end)

--========================================================
-- TAB 1: TỐI ƯU FPS
--========================================================

TabFPS.CanvasSize = UDim2.new(0, 0, 0, 360)

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
    ApplyFont(Label)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Card

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -50, 0, 16)
    DescLabel.Position = UDim2.fromOffset(10, 24)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = Desc
    DescLabel.TextColor3 = COLOR_TEXT_SUB
    DescLabel.TextSize = 8
    ApplyFont(DescLabel)
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Parent = Card

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.fromOffset(36, 20)
    Btn.Position = UDim2.new(1, -42, 0.5, -10)
    Btn.BackgroundColor3 = Settings[Key] and COLOR_ACCENT or COLOR_OFF
    Btn.BorderSizePixel = 0
    Btn.Text = Settings[Key] and "BẬT" or "TẮT"
    Btn.TextColor3 = COLOR_TEXT_MAIN
    Btn.TextSize = 8
    ApplyFont(Btn)
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
    {"🧊 Đóng Băng Biển", "Sàn băng cao chống dìm tuyệt đối", "FreezeWater"},
    {"☀️ Xóa Sương Mù All Map", "Sạch 100% sương mù, nhìn xuyên đảo", "ClearFog"},
    {"💥 Xóa 100% Hiệu Ứng", "Triệt hạ toàn bộ lửa, khói, skill VFX", "Particles"},
    {"✨ Vật Thể Nhẵn 100%", "Ép SmoothPlastic + Tắt phản chiếu", "LowMaterial"},
    {"🌊 Ẩn Hoàn Toàn Biển", "Làm nước biển tệp màu vô hình", "RemoveWater"},
    {"🌑 Tắt Bóng Hạ Cảnh", "Tắt bóng của vật thể giúp tăng FPS", "Shadows"},
    {"💡 Tắt Ánh Sáng", "Tắt các loại đèn chiếu sáng", "Lights"},
    {"🖼️ Tắt Decal/Texture", "Tắt ảnh dán bề mặt giảm VRAM", "Textures"},
    {"👕 Ẩn Trang Phục", "Ẩn đồ phụ kiện trên người chơi", "HideAccessories"},
    {"🏠 Ẩn Công Trình", "Ẩn các công trình map xung quanh", "HideMap"},
    {"👾 Ẩn Quái / NPC", "Ẩn mô hình NPC & quái vật", "HideNPC"}
}

for i, t in ipairs(TogglesList) do
    local col = (i - 1) % 2
    local row = math.floor((i - 1) / 2)
    CreateToggleCard(t[1], t[2], t[3], TabFPS, 6 + col * 203, 6 + row * 54)
end

--========================================================
-- TAB 2: DI CHUYỂN
--========================================================

TabSpeed.CanvasSize = UDim2.new(0, 0, 0, 160)

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
    ApplyFont(TitleLabel)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Frame

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -70, 0, 14)
    DescLabel.Position = UDim2.fromOffset(10, 22)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = Desc
    DescLabel.TextColor3 = COLOR_TEXT_SUB
    DescLabel.TextSize = 8
    ApplyFont(DescLabel)
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Parent = Frame

    local ValLabel = Instance.new("TextLabel")
    ValLabel.Size = UDim2.fromOffset(50, 20)
    ValLabel.Position = UDim2.new(1, -58, 0, 6)
    ValLabel.BackgroundTransparency = 1
    ValLabel.Text = tostring(Default)
    ValLabel.TextColor3 = COLOR_ACCENT
    ValLabel.TextSize = 11
    ApplyFont(ValLabel)
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

CreateSliderCard("Tốc Độ Di Chuyển (WalkSpeed)", "Tự động khóa và duy trì tốc độ đi bộ", 16, 300, 16, TabSpeed, 6, function(Val)
    PlayerStats.WalkSpeed = Val
    PlayerStats.EnableSpeed = (Val > 16)
end)

CreateSliderCard("Độ Cao Nhảy (JumpPower)", "Điều chỉnh lực nhảy cao cho nhân vật", 50, 500, 50, TabSpeed, 72, function(Val)
    PlayerStats.JumpPower = Val
    PlayerStats.EnableJump = (Val > 50)
end)

--========================================================
-- ENGINE SÀN BĂNG VÀ XÓA LỖI ĐỎ MÀN HÌNH
--========================================================

local WATER_LEVEL = 0
local IceFloor = Instance.new("Part")
IceFloor.Name = "TuyenMod2194_IceFloor"
IceFloor.Size = Vector3.new(5000, 6, 5000)
IceFloor.Anchored = true
IceFloor.CanCollide = false
IceFloor.Transparency = 0.5
IceFloor.Material = Enum.Material.SmoothPlastic
IceFloor.Color = Color3.fromRGB(0, 170, 255)
IceFloor.Parent = Workspace

RunService.RenderStepped:Connect(function()
    pcall(function()
        local Char = Player.Character
        if not Char then return end
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        local Root = Char:FindFirstChild("HumanoidRootPart")

        for _, gui in ipairs(PlayerGui:GetChildren()) do
            local name = gui.Name:lower()
            if name:find("water") or name:find("damage") or name:find("red") or name:find("screen") then
                if gui:IsA("ScreenGui") then
                    gui.Enabled = false
                end
            end
        end

        if Hum then
            if PlayerStats.EnableSpeed then Hum.WalkSpeed = PlayerStats.WalkSpeed end
            if PlayerStats.EnableJump then Hum.UseJumpPower = true; Hum.JumpPower = PlayerStats.JumpPower end
        end

        if Settings.FreezeWater and Root and Hum then
            IceFloor.CanCollide = true
            IceFloor.CFrame = CFrame.new(Root.Position.X, WATER_LEVEL + 3, Root.Position.Z)

            if Root.Position.Y < (WATER_LEVEL + 5) or Hum:GetState() == Enum.HumanoidStateType.Swimming then
                Root.CFrame = CFrame.new(Root.Position.X, WATER_LEVEL + 8, Root.Position.Z)
                Root.AssemblyLinearVelocity = Vector3.new(Root.AssemblyLinearVelocity.X, 0, Root.AssemblyLinearVelocity.Z)
                Hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        else
            IceFloor.CanCollide = false
            IceFloor.CFrame = CFrame.new(0, -3000, 0)
        end
    end)
end)

--========================================================
-- TAB 3: THÔNG TIN
--========================================================

TabInfo.CanvasSize = UDim2.new(0, 0, 0, 480)

local InfoListLayout = Instance.new("UIListLayout")
InfoListLayout.SortOrder = Enum.SortOrder.LayoutOrder
InfoListLayout.Padding = UDim.new(0, 8)
InfoListLayout.Parent = TabInfo

local InfoPadding = Instance.new("UIPadding")
InfoPadding.PaddingLeft = UDim.new(0, 6)
InfoPadding.PaddingRight = UDim.new(0, 6)
InfoPadding.PaddingTop = UDim.new(0, 6)
InfoPadding.Parent = TabInfo

local InfoBox = Instance.new("Frame")
InfoBox.Size = UDim2.new(1, 0, 0, 310)
InfoBox.BackgroundColor3 = COLOR_CARD
InfoBox.BorderSizePixel = 0
InfoBox.LayoutOrder = 1
InfoBox.Parent = TabInfo

local InfoBoxCorner = Instance.new("UICorner")
InfoBoxCorner.CornerRadius = UDim.new(0, 8)
InfoBoxCorner.Parent = InfoBox

local InfoBoxPadding = Instance.new("UIPadding")
InfoBoxPadding.PaddingLeft = UDim.new(0, 10)
InfoBoxPadding.PaddingRight = UDim.new(0, 10)
InfoBoxPadding.PaddingTop = UDim.new(0, 10)
InfoBoxPadding.Parent = InfoBox

local InfoList = Instance.new("UIListLayout")
InfoList.SortOrder = Enum.SortOrder.LayoutOrder
InfoList.Padding = UDim.new(0, 4)
InfoList.Parent = InfoBox

local function CreateInfoLine(Text, Size, Color, Order)
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, 0, 0, Size + 6)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = Text
    Lbl.TextColor3 = Color or COLOR_TEXT_MAIN
    Lbl.TextSize = Size
    ApplyFont(Lbl)
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.TextYAlignment = Enum.TextYAlignment.Center
    Lbl.LayoutOrder = Order
    Lbl.Parent = InfoBox
    return Lbl
end

CreateInfoLine("TUYEN MOD – ULTRA FIX LAG", 11, COLOR_ACCENT, 1)
CreateInfoLine("🔥 DỊCH VỤ CÀY THUÊ BLOX FRUITS CHUYÊN NGHIỆP 🔥", 10, COLOR_RED_INTRO, 2)
CreateInfoLine("YouTube TUYENMOD2194 cung cấp dịch vụ cày thuê uy tín:", 9, COLOR_TEXT_SUB, 3)
CreateInfoLine("• GIÁ SIÊU RẺ: CÀY MAX LEVEL CHỈ 50K!", 10, Color3.fromRGB(100, 255, 150), 4)
CreateInfoLine("• Đội ngũ trực ca 24/7, xử lý đơn siêu tốc.", 9, COLOR_TEXT_MAIN, 5)
CreateInfoLine("• Server PC treo game cấu hình khủng chuyên nghiệp.", 9, COLOR_TEXT_MAIN, 6)
CreateInfoLine("• Bảo mật thông tin tài khoản an toàn 100%.", 9, COLOR_TEXT_MAIN, 7)
CreateInfoLine("👉 Liên hệ Discord, TikTok hoặc YouTube để đặt đơn!", 9, COLOR_ACCENT, 8)
CreateInfoLine("--------------------------------------------------", 9, COLOR_TEXT_SUB, 9)
CreateInfoLine("📌 TÍNH NĂNG NỔI BẬT CỦA SCRIPT:", 10, COLOR_TEXT_MAIN, 10)
CreateInfoLine("⚡ Triệt hạ 100% hiệu ứng VFX, khói, lửa giúp Max FPS.", 9, COLOR_TEXT_SUB, 11)
CreateInfoLine("☀️ Xóa sương mù all map hoàn toàn bằng Engine mới.", 9, COLOR_TEXT_SUB, 12)
CreateInfoLine("🧊 Sàn băng cao hơn mặt nước, triệt hạ hoàn toàn đỏ màn hình.", 9, COLOR_TEXT_SUB, 13)

local function CreateCopyButton(Text, Link, Order, Color)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = Color
    Btn.BorderSizePixel = 0
    Btn.Text = Text
    Btn.TextColor3 = COLOR_TEXT_MAIN
    Btn.TextSize = 10
    ApplyFont(Btn)
    Btn.LayoutOrder = Order
    Btn.Parent = TabInfo

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then
                setclipboard(Link)
                ShowToast("Đã sao chép Link thành công!")
            else
                ShowToast("Executor không hỗ trợ Sao chép!")
            end
        end)
    end)
end

CreateCopyButton("📋 SAO CHÉP LINK DISCORD CÀY THUÊ", INFO.Discord, 2, COLOR_ACCENT)
CreateCopyButton("▶️ SAO CHÉP LINK KÊNH YOUTUBE", INFO.YouTube, 3, Color3.fromRGB(220, 50, 50))
CreateCopyButton("🎵 SAO CHÉP LINK TIKTOK", INFO.TikTok, 4, Color3.fromRGB(40, 40, 40))

ShowToast("Tuyen Mod Fix Lag Loaded!")