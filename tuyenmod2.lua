--//========================================================
--// TUYENMOD2194 - FPS OPTIMIZER
--// FULL MOBILE SCROLL VERSION
--// WATER HIDDEN + LOCAL SEA FLOOR
--// DRAGGABLE FLOATING LOGO
--//========================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
--========================================================
-- CONFIG
--========================================================
local LOGO_ID = "rbxassetid://115616028926793"
-- Mực nước biển
-- Blox Fruits thường có thể dùng khoảng 0
-- Nếu biển của map ở cao độ khác, đổi số này
local SEA_LEVEL = 0
local INFO = {
    YouTube = "https://youtube.com/@tuyenmod2194?si=SyAfDv5tDOdjGZKB",
    TikTok = "https://www.tiktok.com/@laptrinhpy?_r=1&_t=ZS-98TDLqRxloX",
    Discord = "https://discord.gg/w39eWVa69"
}
local ReductionPercent = 70
local Settings = {
    Shadows = true,
    Particles = true,
    Lights = true,
    Textures = true,
    PostEffects = true,
    Atmosphere = true,
    Terrain = true,
    LowMaterial = true,
    RemoveWater = true,
    RemoveFog = true,
    RemoveRain = true,
    SeaFloor = true
}
--========================================================
-- GUI
--========================================================
local Gui = Instance.new("ScreenGui")
Gui.Name = "TuyenMod2194FPS"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui
local UIScale = Instance.new("UIScale")
UIScale.Parent = Gui
--========================================================
-- RESPONSIVE SCALE
--========================================================
local function UpdateScale()
    local Camera = Workspace.CurrentCamera
    if not Camera then
        return
    end
    local Viewport = Camera.ViewportSize
    local BaseWidth = 360
    local BaseHeight = 440
    local ScaleX = (Viewport.X - 18) / BaseWidth
    local ScaleY = (Viewport.Y - 18) / BaseHeight
    UIScale.Scale = math.clamp(
        math.min(ScaleX, ScaleY),
        0.70,
        1
    )
end
UpdateScale()
if Workspace.CurrentCamera then
    Workspace.CurrentCamera:GetPropertyChangedSignal(
        "ViewportSize"
    ):Connect(UpdateScale)
end
--========================================================
-- MAIN
--========================================================
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(360, 440)
Main.Position = UDim2.new(0.5, -180, 0.5, -220)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 19)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = Gui
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = Main
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(70, 70, 82)
MainStroke.Transparency = 0.2
MainStroke.Parent = Main
--========================================================
-- HEADER
--========================================================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 62)
Header.BackgroundColor3 = Color3.fromRGB(23, 23, 29)
Header.BorderSizePixel = 0
Header.ZIndex = 10
Header.Parent = Main
local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 16)
HeaderCorner.Parent = Header
local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 16)
HeaderFix.Position = UDim2.new(0, 0, 1, -16)
HeaderFix.BackgroundColor3 = Header.BackgroundColor3
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header
--========================================================
-- HEADER LOGO
--========================================================
local HeaderLogo = Instance.new("ImageLabel")
HeaderLogo.Size = UDim2.fromOffset(42, 42)
HeaderLogo.Position = UDim2.fromOffset(12, 10)
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.BorderSizePixel = 0
HeaderLogo.Image = LOGO_ID
HeaderLogo.ScaleType = Enum.ScaleType.Fit
HeaderLogo.Parent = Header
local HeaderLogoCorner = Instance.new("UICorner")
HeaderLogoCorner.CornerRadius = UDim.new(0, 10)
HeaderLogoCorner.Parent = HeaderLogo
--========================================================
-- TITLE
--========================================================
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -145, 0, 25)
Title.Position = UDim2.fromOffset(64, 7)
Title.BackgroundTransparency = 1
Title.Text = "TuyenMod2194"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header
local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -145, 0, 18)
SubTitle.Position = UDim2.fromOffset(65, 34)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "FPS Optimizer • Blox Fruits"
SubTitle.TextColor3 = Color3.fromRGB(155, 155, 165)
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header
--========================================================
-- MINIMIZE
--========================================================
local Minimize = Instance.new("ImageButton")
Minimize.Size = UDim2.fromOffset(31, 31)
Minimize.Position = UDim2.new(1, -72, 0, 15)
Minimize.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
Minimize.BorderSizePixel = 0
Minimize.Image = LOGO_ID
Minimize.ScaleType = Enum.ScaleType.Fit
Minimize.AutoButtonColor = false
Minimize.Parent = Header
local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = Minimize
--========================================================
-- CLOSE
--========================================================
local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(30, 30)
Close.Position = UDim2.new(1, -37, 0, 16)
Close.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.TextSize = 20
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false
Close.Parent = Header
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = Close
--========================================================
-- SCROLLING CONTENT
--========================================================
local Scroll = Instance.new("ScrollingFrame")
Scroll.Name = "Content"
Scroll.Size = UDim2.new(1, 0, 1, -62)
Scroll.Position = UDim2.fromOffset(0, 62)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageTransparency = 0.25
Scroll.ScrollingDirection = Enum.ScrollingDirection.Y
Scroll.ElasticBehavior = Enum.ElasticBehavior.Always
Scroll.Active = true
Scroll.ZIndex = 2
Scroll.Parent = Main
local Content = Instance.new("Frame")
Content.Name = "ContentHolder"
Content.Size = UDim2.new(1, 0, 0, 650)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.Parent = Scroll
local BottomPadding = Instance.new("UIPadding")
BottomPadding.PaddingBottom = UDim.new(0, 15)
BottomPadding.Parent = Content
--========================================================
-- TOAST
--========================================================
local Toast = Instance.new("Frame")
Toast.Size = UDim2.fromOffset(235, 48)
Toast.Position = UDim2.new(1, -245, 1, 55)
Toast.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
Toast.BorderSizePixel = 0
Toast.Visible = false
Toast.ZIndex = 100
Toast.Parent = Gui
local ToastCorner = Instance.new("UICorner")
ToastCorner.CornerRadius = UDim.new(0, 11)
ToastCorner.Parent = Toast
local ToastStroke = Instance.new("UIStroke")
ToastStroke.Color = Color3.fromRGB(75, 75, 88)
ToastStroke.Parent = Toast
local ToastText = Instance.new("TextLabel")
ToastText.Size = UDim2.new(1, -16, 1, 0)
ToastText.Position = UDim2.fromOffset(8, 0)
ToastText.BackgroundTransparency = 1
ToastText.Text = "✓ Đã copy link!"
ToastText.TextColor3 = Color3.fromRGB(100, 255, 140)
ToastText.TextSize = 11
ToastText.Font = Enum.Font.GothamBold
ToastText.TextXAlignment = Enum.TextXAlignment.Left
ToastText.Parent = Toast
local ToastToken = 0
local function ShowToast(Text)
    ToastToken += 1
    local Token = ToastToken
    ToastText.Text = "✓  " .. Text
    Toast.Visible = true
    Toast.Position = UDim2.new(
        1,
        -245,
        1,
        55
    )
    TweenService:Create(
        Toast,
        TweenInfo.new(0.22, Enum.EasingStyle.Quart),
        {
            Position = UDim2.new(
                1,
                -245,
                1,
                -65
            )
        }
    ):Play()
    task.delay(2, function()
        if Token ~= ToastToken then
            return
        end
        local Tween = TweenService:Create(
            Toast,
            TweenInfo.new(0.2),
            {
                Position = UDim2.new(
                    1,
                    -245,
                    1,
                    55
                )
            }
        )
        Tween:Play()
        Tween.Completed:Wait()
        if Token == ToastToken then
            Toast.Visible = false
        end
    end)
end
--========================================================
-- SOCIAL TITLE
--========================================================
local SocialTitle = Instance.new("TextLabel")
SocialTitle.Size = UDim2.new(1, -32, 0, 18)
SocialTitle.Position = UDim2.fromOffset(16, 12)
SocialTitle.BackgroundTransparency = 1
SocialTitle.Text = "SOCIAL / CONTACT"
SocialTitle.TextColor3 = Color3.fromRGB(170, 170, 180)
SocialTitle.TextSize = 10
SocialTitle.Font = Enum.Font.GothamBold
SocialTitle.TextXAlignment = Enum.TextXAlignment.Left
SocialTitle.Parent = Content
--========================================================
-- SOCIAL BUTTON
--========================================================
local function CreateSocialButton(Name, Icon, Y, Link)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -32, 0, 29)
    Button.Position = UDim2.fromOffset(16, Y)
    Button.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Content
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.fromOffset(35, 29)
    IconLabel.Position = UDim2.fromOffset(2, 0)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = Icon
    IconLabel.TextColor3 = Color3.new(1, 1, 1)
    IconLabel.TextSize = 14
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.Parent = Button
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, -48, 1, 0)
    NameLabel.Position = UDim2.fromOffset(42, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = Name .. "   •   Nhấn để copy link"
    NameLabel.TextColor3 = Color3.fromRGB(225, 225, 230)
    NameLabel.TextSize = 10
    NameLabel.Font = Enum.Font.GothamMedium
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = Button
    Button.MouseButton1Click:Connect(function()
        if setclipboard then
            local Success = pcall(function()
                setclipboard(Link)
            end)
            if Success then
                ShowToast(Name .. " • Đã copy link!")
            else
                ShowToast("Không thể copy link")
            end
        else
            ShowToast("Executor không hỗ trợ copy")
        end
    end)
    return Button
end
CreateSocialButton(
    "YouTube",
    "▶",
    36,
    INFO.YouTube
)
CreateSocialButton(
    "TikTok",
    "♪",
    69,
    INFO.TikTok
)
CreateSocialButton(
    "Discord",
    "◈",
    102,
    INFO.Discord
)
--========================================================
-- PERCENT
--========================================================
local PercentTitle = Instance.new("TextLabel")
PercentTitle.Size = UDim2.new(1, -32, 0, 18)
PercentTitle.Position = UDim2.fromOffset(16, 139)
PercentTitle.BackgroundTransparency = 1
PercentTitle.Text = "MỨC GIẢM ĐỒ HỌA"
PercentTitle.TextColor3 = Color3.fromRGB(170, 170, 180)
PercentTitle.TextSize = 10
PercentTitle.Font = Enum.Font.GothamBold
PercentTitle.TextXAlignment = Enum.TextXAlignment.Left
PercentTitle.Parent = Content
local PercentBox = Instance.new("TextBox")
PercentBox.Size = UDim2.fromOffset(95, 31)
PercentBox.Position = UDim2.fromOffset(16, 163)
PercentBox.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
PercentBox.BorderSizePixel = 0
PercentBox.Text = "70%"
PercentBox.TextColor3 = Color3.new(1, 1, 1)
PercentBox.TextSize = 13
PercentBox.Font = Enum.Font.GothamBold
PercentBox.ClearTextOnFocus = false
PercentBox.Parent = Content
local PercentCorner = Instance.new("UICorner")
PercentCorner.CornerRadius = UDim.new(0, 8)
PercentCorner.Parent = PercentBox
local PercentInfo = Instance.new("TextLabel")
PercentInfo.Size = UDim2.new(1, -125, 0, 31)
PercentInfo.Position = UDim2.fromOffset(121, 163)
PercentInfo.BackgroundTransparency = 1
PercentInfo.Text = "100%+ = cực thấp"
PercentInfo.TextColor3 = Color3.fromRGB(145, 145, 155)
PercentInfo.TextSize = 10
PercentInfo.Font = Enum.Font.Gotham
PercentInfo.TextXAlignment = Enum.TextXAlignment.Left
PercentInfo.Parent = Content
--========================================================
-- SETTINGS TITLE
--========================================================
local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Size = UDim2.new(1, -32, 0, 18)
SettingsTitle.Position = UDim2.fromOffset(16, 201)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "TÙY CHỌN TỐI ƯU"
SettingsTitle.TextColor3 = Color3.fromRGB(170, 170, 180)
SettingsTitle.TextSize = 10
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
SettingsTitle.Parent = Content
--========================================================
-- TOGGLE
--========================================================
local ToggleObjects = {}
local function CreateToggle(Name, Key, X, Y)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.fromOffset(162, 28)
    Button.Position = UDim2.fromOffset(X, Y)
    Button.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Content
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 7)
    Corner.Parent = Button
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -48, 1, 0)
    Label.Position = UDim2.fromOffset(8, 0)
    Label.BackgroundTransparency = 1
    Label.Text = Name
    Label.TextColor3 = Color3.fromRGB(220, 220, 225)
    Label.TextSize = 9
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button
    local State = Instance.new("TextLabel")
    State.Size = UDim2.fromOffset(39, 21)
    State.Position = UDim2.new(1, -45, 0.5, -10)
    State.BackgroundColor3 = Color3.fromRGB(55, 160, 85)
    State.BorderSizePixel = 0
    State.Text = "ON"
    State.TextColor3 = Color3.new(1, 1, 1)
    State.TextSize = 8
    State.Font = Enum.Font.GothamBold
    State.Parent = Button
    local StateCorner = Instance.new("UICorner")
    StateCorner.CornerRadius = UDim.new(0, 6)
    StateCorner.Parent = State
    local function Update()
        if Settings[Key] then
            State.Text = "ON"
            State.BackgroundColor3 =
                Color3.fromRGB(55, 160, 85)
        else
            State.Text = "OFF"
            State.BackgroundColor3 =
                Color3.fromRGB(75, 75, 82)
        end
    end
    Button.MouseButton1Click:Connect(function()
        Settings[Key] = not Settings[Key]
        Update()
        ShowToast(
            Name ..
            " : " ..
            (Settings[Key] and "ON" or "OFF")
        )
    end)
    ToggleObjects[Key] = {
        Button = Button,
        Update = Update
    }
    Update()
    return Button
end
--========================================================
-- TOGGLE GRID
--========================================================
CreateToggle("Shadows", "Shadows", 16, 225)
CreateToggle("Particles / Effects", "Particles", 182, 225)
CreateToggle("Lights", "Lights", 16, 257)
CreateToggle("Textures / Decals", "Textures", 182, 257)
CreateToggle("Post Effects", "PostEffects", 16, 289)
CreateToggle("Atmosphere / Fog", "Atmosphere", 182, 289)
CreateToggle("Terrain / Water", "Terrain", 16, 321)
CreateToggle("Low Material", "LowMaterial", 182, 321)
CreateToggle("Xóa mặt biển", "RemoveWater", 16, 353)
CreateToggle("Xóa mưa", "RemoveRain", 182, 353)
CreateToggle("Xóa sương mù", "RemoveFog", 16, 385)
CreateToggle("Đứng trên biển", "SeaFloor", 182, 385)
--========================================================
-- STATUS
--========================================================
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -32, 0, 18)
Status.Position = UDim2.fromOffset(16, 423)
Status.BackgroundTransparency = 1
Status.Text = "● Ready"
Status.TextColor3 = Color3.fromRGB(150, 150, 160)
Status.TextSize = 9
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Content
--========================================================
-- FIX BUTTON
--========================================================
local FixButton = Instance.new("TextButton")
FixButton.Size = UDim2.new(1, -32, 0, 34)
FixButton.Position = UDim2.fromOffset(16, 447)
FixButton.BackgroundColor3 = Color3.fromRGB(45, 150, 80)
FixButton.BorderSizePixel = 0
FixButton.Text = "⚡  FIX LAG  •  70%"
FixButton.TextColor3 = Color3.new(1, 1, 1)
FixButton.TextSize = 12
FixButton.Font = Enum.Font.GothamBold
FixButton.AutoButtonColor = false
FixButton.Parent = Content
local FixCorner = Instance.new("UICorner")
FixCorner.CornerRadius = UDim.new(0, 8)
FixCorner.Parent = FixButton
--========================================================
-- PERCENT
--========================================================
local function GetPercent()
    local Text = PercentBox.Text
        :gsub("%%", "")
        :gsub("%s+", "")
    local Number = tonumber(Text)
    if not Number then
        Number = 70
    end
    Number = math.clamp(
        math.floor(Number),
        0,
        1000
    )
    ReductionPercent = Number
    PercentBox.Text =
        tostring(Number) .. "%"
    FixButton.Text =
        "⚡  FIX LAG  •  " ..
        tostring(Number) .. "%"
    return Number
end
--========================================================
-- RAIN DETECTOR
--========================================================
local function IsRainObject(Object)
    local Name = string.lower(
        Object.Name
    )
    return string.find(Name, "rain")
        or string.find(Name, "mua")
        or string.find(Name, "storm")
        or string.find(Name, "weather")
end
--========================================================
-- OPTIMIZE OBJECT
--========================================================
local function OptimizeObject(Object, Percent)
    pcall(function()
        -- SHADOW
        if Settings.Shadows
            and Percent >= 10
            and Object:IsA("BasePart")
        then
            Object.CastShadow = false
            Object.Reflectance = 0
        end
        -- PARTICLES
        if Settings.Particles
            and Percent >= 25
        then
            if Object:IsA("ParticleEmitter")
                or Object:IsA("Trail")
                or Object:IsA("Beam")
                or Object:IsA("Fire")
                or Object:IsA("Smoke")
                or Object:IsA("Sparkles")
            then
                Object.Enabled = false
            end
        end
        -- RAIN
        if Settings.RemoveRain
            and IsRainObject(Object)
        then
            if Object:IsA("ParticleEmitter")
                or Object:IsA("Trail")
                or Object:IsA("Beam")
                or Object:IsA("Fire")
                or Object:IsA("Smoke")
                or Object:IsA("Sparkles")
            then
                Object.Enabled = false
            end
        end
        -- LIGHTS
        if Settings.Lights
            and Percent >= 40
        then
            if Object:IsA("PointLight")
                or Object:IsA("SpotLight")
                or Object:IsA("SurfaceLight")
            then
                Object.Enabled = false
            end
        end
        -- TEXTURES
        if Settings.Textures
            and Percent >= 50
        then
            if Object:IsA("Texture")
                or Object:IsA("Decal")
            then
                Object.Transparency = 1
            end
        end
        -- LOW MATERIAL
        if Settings.LowMaterial
            and Percent >= 65
            and Object:IsA("BasePart")
        then
            Object.Material =
                Enum.Material.SmoothPlastic
            Object.Reflectance = 0
            Object.CastShadow = false
        end
        -- POST EFFECT
        if Settings.PostEffects
            and Percent >= 40
        then
            if Object:IsA("PostEffect") then
                Object.Enabled = false
            end
        end
        -- ATMOSPHERE
        if Settings.Atmosphere
            and Percent >= 40
        then
            if Object:IsA("Atmosphere") then
                Object.Density = 0
                Object.Haze = 0
                Object.Glare = 0
            end
        end
        -- 100%+
        if Percent >= 100 then
            if Settings.Textures then
                if Object:IsA("Texture")
                    or Object:IsA("Decal")
                then
                    Object.Transparency = 1
                end
            end
            if Settings.LowMaterial
                and Object:IsA("BasePart")
            then
                Object.Material =
                    Enum.Material.SmoothPlastic
                Object.CastShadow = false
                Object.Reflectance = 0
            end
        end
    end)
end
--========================================================
-- REMOVE WATER VISUAL
--========================================================
local function RemoveWaterVisual()
    if not Settings.RemoveWater then
        return
    end
    local Terrain =
        Workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        pcall(function()
            -- Ẩn mặt nước
            Terrain.WaterTransparency = 1
            -- Tắt sóng
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            -- Tắt phản chiếu
            Terrain.WaterReflectance = 0
        end)
    end
end
--========================================================
-- SEA FLOOR
--========================================================
local SeaFloor
local function CreateSeaFloor()
    if SeaFloor then
        SeaFloor:Destroy()
        SeaFloor = nil
    end
    if not Settings.SeaFloor then
        return
    end
    SeaFloor = Instance.new("Part")
    SeaFloor.Name = "TuyenMod2194_LocalSeaFloor"
    SeaFloor.Size = Vector3.new(
        4096,
        1,
        4096
    )
    SeaFloor.Position = Vector3.new(
        0,
        SEA_LEVEL - 0.5,
        0
    )
    SeaFloor.Anchored = true
    SeaFloor.CanCollide = true
    SeaFloor.CanTouch = false
    SeaFloor.CanQuery = false
    -- Hoàn toàn vô hình
    SeaFloor.Transparency = 1
    SeaFloor.CastShadow = false
    SeaFloor.Material = Enum.Material.SmoothPlastic
    SeaFloor.Parent = Workspace
end
--========================================================
-- REMOVE FOG
--========================================================
local function RemoveFog()
    if not Settings.RemoveFog then
        return
    end
    pcall(function()
        Lighting.FogStart = 0
        Lighting.FogEnd = 1000000
    end)
    for _, Object in ipairs(
        Lighting:GetChildren()
    ) do
        pcall(function()
            if Object:IsA("Atmosphere") then
                Object.Density = 0
                Object.Haze = 0
                Object.Glare = 0
            end
        end)
    end
end
--========================================================
-- LIGHTING
--========================================================
local function ApplyLighting(Percent)
    if Settings.Shadows
        and Percent >= 10
    then
        pcall(function()
            Lighting.GlobalShadows = false
        end)
    end
    if Percent >= 25 then
        pcall(function()
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
        end)
    end
    if Settings.RemoveFog then
        RemoveFog()
    end
    if Settings.PostEffects
        and Percent >= 40
    then
        for _, Effect in ipairs(
            Lighting:GetChildren()
        ) do
            pcall(function()
                if Effect:IsA("PostEffect") then
                    Effect.Enabled = false
                end
            end)
        end
    end
    if Percent >= 75 then
        pcall(function()
            settings().Rendering.QualityLevel =
                Enum.QualityLevel.Level01
        end)
    end
    if Settings.RemoveWater then
        RemoveWaterVisual()
    end
end
--========================================================
-- FIX LAG
--========================================================
local IsFixing = false
local function FixLag()
    if IsFixing then
        return
    end
    IsFixing = true
    local Percent = GetPercent()
    Status.Text =
        "● Đang tối ưu " ..
        tostring(Percent) .. "%..."
    Status.TextColor3 =
        Color3.fromRGB(255, 210, 80)
    FixButton.Text =
        "⏳  ĐANG FIX..."
    task.wait()
    -- LIGHTING
    ApplyLighting(Percent)
    -- WATER
    RemoveWaterVisual()
    -- SEA FLOOR
    if Settings.SeaFloor then
        CreateSeaFloor()
    elseif SeaFloor then
        SeaFloor:Destroy()
        SeaFloor = nil
    end
    -- WORKSPACE
    local Objects =
        Workspace:GetDescendants()
    for Index, Object in ipairs(Objects) do
        OptimizeObject(
            Object,
            Percent
        )
        if Index % 250 == 0 then
            task.wait()
        end
    end
    Status.Text =
        "● Đã áp dụng " ..
        tostring(Percent) .. "%"
    Status.TextColor3 =
        Color3.fromRGB(80, 255, 120)
    FixButton.Text =
        "✓  FIX LAG  •  " ..
        tostring(Percent) .. "%"
    ShowToast(
        "Đã tối ưu " ..
        tostring(Percent) .. "%"
    )
    IsFixing = false
end
--========================================================
-- INPUT
--========================================================
PercentBox.FocusLost:Connect(function()
    GetPercent()
end)
FixButton.MouseButton1Click:Connect(function()
    task.spawn(FixLag)
end)
--========================================================
-- TOGGLE SEA FLOOR LIVE
--========================================================
local OldSeaUpdate =
    ToggleObjects.SeaFloor
--========================================================
-- NEW OBJECT
--========================================================
Workspace.DescendantAdded:Connect(function(Object)
    task.defer(function()
        if Object
            and Object.Parent
        then
            OptimizeObject(
                Object,
                ReductionPercent
            )
            if Settings.RemoveRain
                and IsRainObject(Object)
            then
                pcall(function()
                    if Object:IsA("ParticleEmitter")
                        or Object:IsA("Trail")
                        or Object:IsA("Beam")
                        or Object:IsA("Fire")
                        or Object:IsA("Smoke")
                        or Object:IsA("Sparkles")
                    then
                        Object.Enabled = false
                    end
                end)
            end
        end
    end)
end)
--========================================================
-- DRAG MAIN
--========================================================
local function MakeDraggable(Object, Handle)
    local Dragging = false
    local DragStart
    local StartPosition
    Handle.InputBegan:Connect(function(Input)
        if Input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or Input.UserInputType ==
            Enum.UserInputType.Touch
        then
            Dragging = true
            DragStart = Input.Position
            StartPosition = Object.Position
            local Connection
            Connection =
                Input.Changed:Connect(function()
                    if Input.UserInputState ==
                        Enum.UserInputState.End
                    then
                        Dragging = false
                        if Connection then
                            Connection:Disconnect()
                        end
                    end
                end)
        end
    end)
    UserInputService.InputChanged:Connect(function(Input)
        if not Dragging then
            return
        end
        if Input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or Input.UserInputType ==
            Enum.UserInputType.Touch
        then
            local Delta =
                Input.Position - DragStart
            Object.Position = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
        end
    end)
end
MakeDraggable(Main, Header)
--========================================================
-- FLOATING LOGO
--========================================================
local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name =
    "TuyenMod2194Floating"
FloatingButton.Size =
    UDim2.fromOffset(54, 54)
FloatingButton.Position =
    UDim2.new(
        0,
        15,
        0.5,
        -27
    )
FloatingButton.BackgroundColor3 =
    Color3.fromRGB(22, 22, 28)
FloatingButton.BorderSizePixel = 0
FloatingButton.Image = LOGO_ID
FloatingButton.ScaleType = Enum.ScaleType.Fit
FloatingButton.AutoButtonColor = false
FloatingButton.Visible = false
FloatingButton.ZIndex = 50
FloatingButton.Parent = Gui
local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius =
    UDim.new(1, 0)
FloatingCorner.Parent = FloatingButton
local FloatingStroke = Instance.new("UIStroke")
FloatingStroke.Color =
    Color3.fromRGB(80, 80, 95)
FloatingStroke.Thickness = 2
FloatingStroke.Parent = FloatingButton
--========================================================
-- FLOATING DRAG
--========================================================
local FloatDragging = false
local FloatStart
local FloatStartPosition
local FloatMoved = false
FloatingButton.InputBegan:Connect(function(Input)
    if Input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or Input.UserInputType ==
        Enum.UserInputType.Touch
    then
        FloatDragging = true
        FloatMoved = false
        FloatStart =
            Input.Position
        FloatStartPosition =
            FloatingButton.Position
        local Connection
        Connection =
            Input.Changed:Connect(function()
                if Input.UserInputState ==
                    Enum.UserInputState.End
                then
                    FloatDragging = false
                    if Connection then
                        Connection:Disconnect()
                    end
                end
            end)
    end
end)
UserInputService.InputChanged:Connect(function(Input)
    if not FloatDragging then
        return
    end
    if Input.UserInputType ==
        Enum.UserInputType.MouseMovement
        or Input.UserInputType ==
        Enum.UserInputType.Touch
    then
        local Delta =
            Input.Position - FloatStart
        if math.abs(Delta.X) > 5
            or math.abs(Delta.Y) > 5
        then
            FloatMoved = true
        end
        FloatingButton.Position =
            UDim2.new(
                FloatStartPosition.X.Scale,
                FloatStartPosition.X.Offset + Delta.X,
                FloatStartPosition.Y.Scale,
                FloatStartPosition.Y.Offset + Delta.Y
            )
    end
end)
--========================================================
-- MINIMIZE
--========================================================
Minimize.MouseButton1Click:Connect(function()
    Main.Visible = false
    FloatingButton.Visible = true
end)
--========================================================
-- OPEN
--========================================================
FloatingButton.MouseButton1Click:Connect(function()
    if FloatMoved then
        return
    end
    FloatingButton.Visible = false
    Main.Visible = true
end)
--========================================================
-- CLOSE
--========================================================
Close.MouseButton1Click:Connect(function()
    if SeaFloor then
        SeaFloor:Destroy()
        SeaFloor = nil
    end
    Gui:Destroy()
end)
--========================================================
-- START
--========================================================
GetPercent()
Status.Text = "● Ready"
print(
    "TuyenMod2194 FPS Optimizer Loaded"
)