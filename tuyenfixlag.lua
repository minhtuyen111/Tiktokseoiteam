--//========================================================
--// TUYENMOD2194 - FPS OPTIMIZER
--// FULL VERSION
--// Percentage Graphics Reduction + Toggle Settings
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
    LowMaterial = true
}
--========================================================
-- GUI
--========================================================
local Gui = Instance.new("ScreenGui")
Gui.Name = "TuyenMod2194FPS"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui
--========================================================
-- MAIN
--========================================================
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(410, 520)
Main.Position = UDim2.new(0.5, -205, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 19)
Main.BorderSizePixel = 0
Main.Parent = Gui
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 17)
MainCorner.Parent = Main
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(70, 70, 82)
MainStroke.Transparency = 0.2
MainStroke.Parent = Main
--========================================================
-- HEADER
--========================================================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 70)
Header.BackgroundColor3 = Color3.fromRGB(23, 23, 29)
Header.BorderSizePixel = 0
Header.Parent = Main
local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 17)
HeaderCorner.Parent = Header
local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 20)
HeaderFix.Position = UDim2.new(0, 0, 1, -20)
HeaderFix.BackgroundColor3 = Header.BackgroundColor3
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header
--========================================================
-- HEADER LOGO
--========================================================
local HeaderLogo = Instance.new("ImageLabel")
HeaderLogo.Size = UDim2.fromOffset(44, 44)
HeaderLogo.Position = UDim2.fromOffset(13, 13)
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.Image = LOGO_ID
HeaderLogo.ScaleType = Enum.ScaleType.Fit
HeaderLogo.Parent = Header
local HeaderLogoCorner = Instance.new("UICorner")
HeaderLogoCorner.CornerRadius = UDim.new(0, 11)
HeaderLogoCorner.Parent = HeaderLogo
--========================================================
-- TITLE
--========================================================
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -160, 0, 27)
Title.Position = UDim2.fromOffset(67, 8)
Title.BackgroundTransparency = 1
Title.Text = "TuyenMod2194"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header
local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -160, 0, 20)
SubTitle.Position = UDim2.fromOffset(68, 38)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "FPS Optimizer • Blox Fruits"
SubTitle.TextColor3 = Color3.fromRGB(155, 155, 165)
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header
--========================================================
-- MINIMIZE
--========================================================
local Minimize = Instance.new("ImageButton")
Minimize.Size = UDim2.fromOffset(35, 35)
Minimize.Position = UDim2.new(1, -84, 0, 18)
Minimize.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
Minimize.BorderSizePixel = 0
Minimize.Image = LOGO_ID
Minimize.ScaleType = Enum.ScaleType.Fit
Minimize.Parent = Header
local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 9)
MinCorner.Parent = Minimize
--========================================================
-- CLOSE
--========================================================
local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(32, 32)
Close.Position = UDim2.new(1, -43, 0, 19)
Close.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.TextSize = 21
Close.Font = Enum.Font.GothamBold
Close.Parent = Header
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 9)
CloseCorner.Parent = Close
--========================================================
-- TOAST
--========================================================
local Toast = Instance.new("Frame")
Toast.Size = UDim2.fromOffset(245, 55)
Toast.Position = UDim2.new(1, -260, 1, 70)
Toast.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
Toast.BorderSizePixel = 0
Toast.Visible = false
Toast.ZIndex = 100
Toast.Parent = Gui
local ToastCorner = Instance.new("UICorner")
ToastCorner.CornerRadius = UDim.new(0, 12)
ToastCorner.Parent = Toast
local ToastStroke = Instance.new("UIStroke")
ToastStroke.Color = Color3.fromRGB(75, 75, 88)
ToastStroke.Parent = Toast
local ToastText = Instance.new("TextLabel")
ToastText.Size = UDim2.new(1, -20, 1, 0)
ToastText.Position = UDim2.fromOffset(10, 0)
ToastText.BackgroundTransparency = 1
ToastText.Text = "✓  Đã copy link!"
ToastText.TextColor3 = Color3.fromRGB(100, 255, 140)
ToastText.TextSize = 12
ToastText.Font = Enum.Font.GothamBold
ToastText.TextXAlignment = Enum.TextXAlignment.Left
ToastText.Parent = Toast
local ToastToken = 0
local function ShowToast(Text)
    ToastToken += 1
    local Token = ToastToken
    ToastText.Text = "✓  " .. Text
    Toast.Visible = true
    Toast.Position = UDim2.new(1, -260, 1, 70)
    TweenService:Create(
        Toast,
        TweenInfo.new(0.25, Enum.EasingStyle.Quart),
        {
            Position = UDim2.new(1, -260, 1, -75)
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
                Position = UDim2.new(1, -260, 1, 70)
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
SocialTitle.Size = UDim2.new(1, -36, 0, 20)
SocialTitle.Position = UDim2.fromOffset(18, 82)
SocialTitle.BackgroundTransparency = 1
SocialTitle.Text = "SOCIAL / CONTACT"
SocialTitle.TextColor3 = Color3.fromRGB(170, 170, 180)
SocialTitle.TextSize = 11
SocialTitle.Font = Enum.Font.GothamBold
SocialTitle.TextXAlignment = Enum.TextXAlignment.Left
SocialTitle.Parent = Main
--========================================================
-- SOCIAL BUTTON
--========================================================
local function CreateSocialButton(Name, Icon, Position, Link)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -36, 0, 31)
    Button.Position = Position
    Button.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Main
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 9)
    Corner.Parent = Button
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.fromOffset(40, 31)
    IconLabel.Position = UDim2.fromOffset(3, 0)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = Icon
    IconLabel.TextColor3 = Color3.new(1, 1, 1)
    IconLabel.TextSize = 15
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.Parent = Button
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, -55, 1, 0)
    NameLabel.Position = UDim2.fromOffset(45, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = Name
    NameLabel.TextColor3 = Color3.fromRGB(225, 225, 230)
    NameLabel.TextSize = 12
    NameLabel.Font = Enum.Font.GothamMedium
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = Button
    Button.MouseEnter:Connect(function()
        TweenService:Create(
            Button,
            TweenInfo.new(0.12),
            {
                BackgroundColor3 = Color3.fromRGB(43, 43, 52)
            }
        ):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(
            Button,
            TweenInfo.new(0.12),
            {
                BackgroundColor3 = Color3.fromRGB(28, 28, 35)
            }
        ):Play()
    end)
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
    UDim2.fromOffset(18, 105),
    INFO.YouTube
)
CreateSocialButton(
    "TikTok",
    "♪",
    UDim2.fromOffset(18, 140),
    INFO.TikTok
)
CreateSocialButton(
    "Discord",
    "◈",
    UDim2.fromOffset(18, 175),
    INFO.Discord
)
--========================================================
-- PERCENT TITLE
--========================================================
local PercentTitle = Instance.new("TextLabel")
PercentTitle.Size = UDim2.new(1, -36, 0, 20)
PercentTitle.Position = UDim2.fromOffset(18, 213)
PercentTitle.BackgroundTransparency = 1
PercentTitle.Text = "MỨC GIẢM ĐỒ HỌA"
PercentTitle.TextColor3 = Color3.fromRGB(170, 170, 180)
PercentTitle.TextSize = 11
PercentTitle.Font = Enum.Font.GothamBold
PercentTitle.TextXAlignment = Enum.TextXAlignment.Left
PercentTitle.Parent = Main
--========================================================
-- PERCENT BOX
--========================================================
local PercentBox = Instance.new("TextBox")
PercentBox.Size = UDim2.fromOffset(105, 34)
PercentBox.Position = UDim2.fromOffset(18, 239)
PercentBox.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
PercentBox.BorderSizePixel = 0
PercentBox.Text = tostring(ReductionPercent) .. "%"
PercentBox.TextColor3 = Color3.new(1, 1, 1)
PercentBox.TextSize = 15
PercentBox.Font = Enum.Font.GothamBold
PercentBox.ClearTextOnFocus = false
PercentBox.Parent = Main
local PercentCorner = Instance.new("UICorner")
PercentCorner.CornerRadius = UDim.new(0, 8)
PercentCorner.Parent = PercentBox
local PercentInfo = Instance.new("TextLabel")
PercentInfo.Size = UDim2.new(1, -140, 0, 34)
PercentInfo.Position = UDim2.fromOffset(135, 239)
PercentInfo.BackgroundTransparency = 1
PercentInfo.Text = "70% = mạnh  •  100%+ = cực thấp"
PercentInfo.TextColor3 = Color3.fromRGB(145, 145, 155)
PercentInfo.TextSize = 10
PercentInfo.Font = Enum.Font.Gotham
PercentInfo.TextXAlignment = Enum.TextXAlignment.Left
PercentInfo.Parent = Main
--========================================================
-- SETTINGS TITLE
--========================================================
local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Size = UDim2.new(1, -36, 0, 20)
SettingsTitle.Position = UDim2.fromOffset(18, 283)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "TÙY CHỌN TỐI ƯU"
SettingsTitle.TextColor3 = Color3.fromRGB(170, 170, 180)
SettingsTitle.TextSize = 11
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
SettingsTitle.Parent = Main
--========================================================
-- TOGGLE FUNCTION
--========================================================
local ToggleObjects = {}
local function CreateToggle(Name, Key, Position)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.fromOffset(182, 31)
    Button.Position = Position
    Button.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Main
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -55, 1, 0)
    Label.Position = UDim2.fromOffset(10, 0)
    Label.BackgroundTransparency = 1
    Label.Text = Name
    Label.TextColor3 = Color3.fromRGB(220, 220, 225)
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button
    local State = Instance.new("TextLabel")
    State.Size = UDim2.fromOffset(45, 23)
    State.Position = UDim2.new(1, -52, 0.5, -11)
    State.BackgroundColor3 = Color3.fromRGB(55, 160, 85)
    State.BorderSizePixel = 0
    State.Text = "ON"
    State.TextColor3 = Color3.new(1, 1, 1)
    State.TextSize = 9
    State.Font = Enum.Font.GothamBold
    State.Parent = Button
    local StateCorner = Instance.new("UICorner")
    StateCorner.CornerRadius = UDim.new(0, 7)
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
            Name .. " : " ..
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
CreateToggle(
    "Shadows",
    "Shadows",
    UDim2.fromOffset(18, 308)
)
CreateToggle(
    "Particles / Effects",
    "Particles",
    UDim2.fromOffset(210, 308)
)
CreateToggle(
    "Lights",
    "Lights",
    UDim2.fromOffset(18, 344)
)
CreateToggle(
    "Textures / Decals",
    "Textures",
    UDim2.fromOffset(210, 344)
)
CreateToggle(
    "Post Effects",
    "PostEffects",
    UDim2.fromOffset(18, 380)
)
CreateToggle(
    "Atmosphere",
    "Atmosphere",
    UDim2.fromOffset(210, 380)
)
CreateToggle(
    "Terrain / Water",
    "Terrain",
    UDim2.fromOffset(18, 416)
)
CreateToggle(
    "Low Material",
    "LowMaterial",
    UDim2.fromOffset(210, 416)
)
--========================================================
-- STATUS
--========================================================
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -36, 0, 20)
Status.Position = UDim2.fromOffset(18, 451)
Status.BackgroundTransparency = 1
Status.Text = "● Ready"
Status.TextColor3 = Color3.fromRGB(150, 150, 160)
Status.TextSize = 10
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main
--========================================================
-- FIX BUTTON
--========================================================
local FixButton = Instance.new("TextButton")
FixButton.Size = UDim2.new(1, -36, 0, 38)
FixButton.Position = UDim2.fromOffset(18, 474)
FixButton.BackgroundColor3 = Color3.fromRGB(45, 150, 80)
FixButton.BorderSizePixel = 0
FixButton.Text = "⚡  FIX LAG  •  " .. ReductionPercent .. "%"
FixButton.TextColor3 = Color3.new(1, 1, 1)
FixButton.TextSize = 13
FixButton.Font = Enum.Font.GothamBold
FixButton.Parent = Main
local FixCorner = Instance.new("UICorner")
FixCorner.CornerRadius = UDim.new(0, 9)
FixCorner.Parent = FixButton
--========================================================
-- NOTE
--========================================================
local Note = Instance.new("TextLabel")
Note.Size = UDim2.new(1, -36, 0, 35)
Note.Position = UDim2.fromOffset(18, 515)
Note.BackgroundTransparency = 1
Note.Text = "🥸  Vào nhóm sẽ có cơ hội tẩm quất giun biển mỗi đêm 🥸"
Note.TextColor3 = Color3.fromRGB(165, 165, 175)
Note.TextSize = 9
Note.Font = Enum.Font.Gotham
Note.TextWrapped = true
Note.TextXAlignment = Enum.TextXAlignment.Left
Note.Parent = Main
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
    -- Cho nhập tới 1000%.
    -- Từ 100% trở lên sẽ dùng mức cực thấp.
    Number = math.clamp(math.floor(Number), 0, 1000)
    ReductionPercent = Number
    PercentBox.Text =
        tostring(Number) .. "%"
    FixButton.Text =
        "⚡  FIX LAG  •  " ..
        tostring(Number) .. "%"
    return Number
end
--========================================================
-- OPTIMIZE OBJECT
--========================================================
local function OptimizeObject(Object, Percent)
    pcall(function()
        --================================================
        -- SHADOW
        --================================================
        if Settings.Shadows
            and Percent >= 10
            and Object:IsA("BasePart")
        then
            Object.CastShadow = false
            Object.Reflectance = 0
        end
        --================================================
        -- PARTICLES / EFFECTS
        --================================================
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
        --================================================
        -- LIGHTS
        --================================================
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
        --================================================
        -- TEXTURES
        --================================================
        if Settings.Textures
            and Percent >= 50
        then
            if Object:IsA("Texture")
                or Object:IsA("Decal")
            then
                Object.Transparency = 1
            end
        end
        --================================================
        -- LOW MATERIAL
        --================================================
        if Settings.LowMaterial
            and Percent >= 65
            and Object:IsA("BasePart")
        then
            Object.Material =
                Enum.Material.SmoothPlastic
            Object.Reflectance = 0
            Object.CastShadow = false
        end
        --================================================
        -- POST EFFECT
        --================================================
        if Settings.PostEffects
            and Percent >= 70
        then
            if Object:IsA("PostEffect") then
                Object.Enabled = false
            end
        end
        --================================================
        -- ATMOSPHERE
        --================================================
        if Settings.Atmosphere
            and Percent >= 80
        then
            if Object:IsA("Atmosphere") then
                Object.Density = 0
                Object.Haze = 0
                Object.Glare = 0
            end
        end
        --================================================
        -- 90%+
        --================================================
        if Percent >= 90 then
            if Settings.Particles then
                if Object:IsA("ParticleEmitter") then
                    Object.Enabled = false
                    Object.Rate = 0
                end
                if Object:IsA("Trail")
                    or Object:IsA("Beam")
                    or Object:IsA("Fire")
                    or Object:IsA("Smoke")
                    or Object:IsA("Sparkles")
                then
                    Object.Enabled = false
                end
            end
            if Settings.Lights then
                if Object:IsA("PointLight")
                    or Object:IsA("SpotLight")
                    or Object:IsA("SurfaceLight")
                then
                    Object.Enabled = false
                end
            end
        end
        --================================================
        -- 100%+
        --================================================
        if Percent >= 100 then
            if Settings.Textures then
                if Object:IsA("Texture")
                    or Object:IsA("Decal")
                then
                    Object.Transparency = 1
                end
                if Object:IsA("SpecialMesh") then
                    Object.TextureId = ""
                end
            end
            if Settings.PostEffects
                and Object:IsA("PostEffect")
            then
                Object.Enabled = false
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
-- LIGHTING
--========================================================
local function ApplyLighting(Percent)
    if Percent <= 0 then
        return
    end
    --====================================================
    -- SHADOW
    --====================================================
    if Settings.Shadows
        and Percent >= 10
    then
        pcall(function()
            Lighting.GlobalShadows = false
        end)
    end
    --====================================================
    -- ENVIRONMENT
    --====================================================
    if Percent >= 25 then
        pcall(function()
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
        end)
    end
    --====================================================
    -- POST EFFECT
    --====================================================
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
    --====================================================
    -- ATMOSPHERE
    --====================================================
    if Settings.Atmosphere
        and Percent >= 60
    then
        for _, Effect in ipairs(
            Lighting:GetChildren()
        ) do
            pcall(function()
                if Effect:IsA("Atmosphere") then
                    Effect.Density = 0
                    Effect.Haze = 0
                    Effect.Glare = 0
                end
            end)
        end
    end
    --====================================================
    -- LOW QUALITY
    --====================================================
    if Percent >= 75 then
        pcall(function()
            settings().Rendering.QualityLevel =
                Enum.QualityLevel.Level01
        end)
    end
    --====================================================
    -- TERRAIN
    --====================================================
    if Settings.Terrain
        and Percent >= 80
    then
        local Terrain =
            Workspace:FindFirstChildOfClass("Terrain")
        if Terrain then
            pcall(function()
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
                Terrain.WaterTransparency = 1
            end)
        end
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
    --====================================================
    -- LIGHTING
    --====================================================
    ApplyLighting(Percent)
    --====================================================
    -- WORKSPACE
    --====================================================
    local Objects =
        Workspace:GetDescendants()
    for Index, Object in ipairs(Objects) do
        OptimizeObject(
            Object,
            Percent
        )
        -- Không khóa game trong một frame
        if Index % 300 == 0 then
            task.wait()
        end
    end
    --====================================================
    -- FINAL
    --====================================================
    Status.Text =
        "● Đã áp dụng mức " ..
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
-- PERCENT INPUT
--========================================================
PercentBox.FocusLost:Connect(function()
    GetPercent()
end)
--========================================================
-- FIX BUTTON
--========================================================
FixButton.MouseButton1Click:Connect(function()
    task.spawn(FixLag)
end)
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
        end
    end)
end)
--========================================================
-- DRAG MENU
--========================================================
local Dragging = false
local DragStart
local StartPosition
Header.InputBegan:Connect(function(Input)
    if Input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or Input.UserInputType ==
        Enum.UserInputType.Touch
    then
        Dragging = true
        DragStart =
            Input.Position
        StartPosition =
            Main.Position
        Input.Changed:Connect(function()
            if Input.UserInputState ==
                Enum.UserInputState.End
            then
                Dragging = false
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
        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)
--========================================================
-- FLOATING LOGO
--========================================================
local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name =
    "TuyenMod2194Floating"
FloatingButton.Size =
    UDim2.fromOffset(58, 58)
FloatingButton.Position =
    UDim2.new(0, 20, 0.5, -29)
FloatingButton.BackgroundColor3 =
    Color3.fromRGB(22, 22, 28)
FloatingButton.BorderSizePixel = 0
FloatingButton.Image = LOGO_ID
FloatingButton.ScaleType =
    Enum.ScaleType.Fit
FloatingButton.Visible = false
FloatingButton.Parent = Gui
local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius =
    UDim.new(1, 0)
FloatingCorner.Parent =
    FloatingButton
local FloatingStroke = Instance.new("UIStroke")
FloatingStroke.Color =
    Color3.fromRGB(80, 80, 95)
FloatingStroke.Thickness = 2
FloatingStroke.Parent =
    FloatingButton
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
    FloatingButton.Visible = false
    Main.Visible = true
end)
--========================================================
-- CLOSE
--========================================================
Close.MouseButton1Click:Connect(function()
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