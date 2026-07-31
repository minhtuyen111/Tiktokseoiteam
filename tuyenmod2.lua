--//========================================================
--// TUYENMOD2194 - FPS OPTIMIZER
--// FULL MOBILE SCROLL VERSION
--// Logo FIXED - Direct Roblox Asset ID
--// Water / Fog / Rain Removal
--//========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ContentProvider = game:GetService("ContentProvider")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--========================================================
-- CONFIG
--========================================================

-- LOGO DÙNG DIRECT ASSET ID
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
    LowMaterial = true,

    RemoveWater = true,
    RemoveFog = true,
    RemoveRain = true
}

--========================================================
-- GUI
--========================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "TuyenMod2194FPS"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.IgnoreGuiInset = false
Gui.Parent = PlayerGui

--========================================================
-- SCALE
--========================================================

local UIScale = Instance.new("UIScale")
UIScale.Parent = Gui

local function UpdateScale()

    local Camera = Workspace.CurrentCamera

    if not Camera then
        return
    end

    local Viewport = Camera.ViewportSize

    local BaseWidth = 360
    local BaseHeight = 430

    local ScaleX = (Viewport.X - 18) / BaseWidth
    local ScaleY = (Viewport.Y - 18) / BaseHeight

    local Scale = math.min(ScaleX, ScaleY)

    Scale = math.clamp(Scale, 0.70, 1)

    UIScale.Scale = Scale
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

Main.Size = UDim2.fromOffset(
    360,
    430
)

Main.Position = UDim2.new(
    0.5,
    -180,
    0.5,
    -215
)

Main.BackgroundColor3 =
    Color3.fromRGB(15, 15, 19)

Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(70, 70, 82)
MainStroke.Transparency = 0.2
MainStroke.Thickness = 1
MainStroke.Parent = Main

--========================================================
-- HEADER
--========================================================

local Header = Instance.new("Frame")

Header.Size =
    UDim2.new(1, 0, 0, 62)

Header.BackgroundColor3 =
    Color3.fromRGB(23, 23, 29)

Header.BorderSizePixel = 0
Header.ZIndex = 20
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 16)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")

HeaderFix.Size =
    UDim2.new(1, 0, 0, 17)

HeaderFix.Position =
    UDim2.new(0, 0, 1, -17)

HeaderFix.BackgroundColor3 =
    Header.BackgroundColor3

HeaderFix.BorderSizePixel = 0
HeaderFix.ZIndex = 20
HeaderFix.Parent = Header

--========================================================
-- LOGO
--========================================================

local function CreateLogo(Parent, Size, Position)

    local Logo = Instance.new("ImageLabel")

    Logo.Name = "TuyenModLogo"

    Logo.Size = Size
    Logo.Position = Position

    Logo.BackgroundTransparency = 1
    Logo.BorderSizePixel = 0

    -- FIX:
    -- Dùng trực tiếp rbxassetid thay vì rbxthumb
    Logo.Image = LOGO_ID

    Logo.ImageTransparency = 0

    Logo.ScaleType =
        Enum.ScaleType.Fit

    Logo.Visible = true

    Logo.ZIndex = 25

    Logo.Parent = Parent

    local Corner = Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0, 10)

    Corner.Parent = Logo

    -- PRELOAD IMAGE
    task.spawn(function()

        pcall(function()

            ContentProvider:PreloadAsync({
                Logo
            })

        end)

    end)

    return Logo
end

local HeaderLogo = CreateLogo(
    Header,
    UDim2.fromOffset(42, 42),
    UDim2.fromOffset(12, 10)
)

--========================================================
-- TITLE
--========================================================

local Title = Instance.new("TextLabel")

Title.Size =
    UDim2.new(1, -145, 0, 25)

Title.Position =
    UDim2.fromOffset(64, 7)

Title.BackgroundTransparency = 1

Title.Text =
    "TuyenMod2194"

Title.TextColor3 =
    Color3.fromRGB(255, 255, 255)

Title.TextSize = 18

Title.Font =
    Enum.Font.GothamBold

Title.TextXAlignment =
    Enum.TextXAlignment.Left

Title.ZIndex = 25
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")

SubTitle.Size =
    UDim2.new(1, -145, 0, 18)

SubTitle.Position =
    UDim2.fromOffset(65, 34)

SubTitle.BackgroundTransparency = 1

SubTitle.Text =
    "FPS Optimizer • Blox Fruits"

SubTitle.TextColor3 =
    Color3.fromRGB(155, 155, 165)

SubTitle.TextSize = 10

SubTitle.Font =
    Enum.Font.Gotham

SubTitle.TextXAlignment =
    Enum.TextXAlignment.Left

SubTitle.ZIndex = 25
SubTitle.Parent = Header

--========================================================
-- MINIMIZE
--========================================================

local Minimize = Instance.new("ImageButton")

Minimize.Size =
    UDim2.fromOffset(31, 31)

Minimize.Position =
    UDim2.new(1, -72, 0, 15)

Minimize.BackgroundColor3 =
    Color3.fromRGB(40, 40, 48)

Minimize.BorderSizePixel = 0

-- FIX LOGO
Minimize.Image = LOGO_ID

Minimize.ImageTransparency = 0

Minimize.ScaleType =
    Enum.ScaleType.Fit

Minimize.AutoButtonColor = false
Minimize.ZIndex = 30
Minimize.Parent = Header

local MinCorner = Instance.new("UICorner")

MinCorner.CornerRadius =
    UDim.new(0, 8)

MinCorner.Parent = Minimize

--========================================================
-- CLOSE
--========================================================

local Close = Instance.new("TextButton")

Close.Size =
    UDim2.fromOffset(30, 30)

Close.Position =
    UDim2.new(1, -37, 0, 16)

Close.BackgroundColor3 =
    Color3.fromRGB(40, 40, 48)

Close.BorderSizePixel = 0

Close.Text = "×"

Close.TextColor3 =
    Color3.new(1, 1, 1)

Close.TextSize = 20

Close.Font =
    Enum.Font.GothamBold

Close.AutoButtonColor = false
Close.ZIndex = 30
Close.Parent = Header

local CloseCorner = Instance.new("UICorner")

CloseCorner.CornerRadius =
    UDim.new(0, 8)

CloseCorner.Parent = Close

--========================================================
-- SCROLL FRAME
--========================================================

local Scroll = Instance.new("ScrollingFrame")

Scroll.Name = "Content"

Scroll.Size =
    UDim2.new(1, 0, 1, -62)

Scroll.Position =
    UDim2.new(0, 0, 0, 62)

Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0

Scroll.CanvasSize =
    UDim2.new(0, 0, 0, 690)

Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageTransparency = 0.15

Scroll.ScrollingDirection =
    Enum.ScrollingDirection.Y

Scroll.ElasticBehavior =
    Enum.ElasticBehavior.Always

Scroll.Active = true
Scroll.Selectable = true
Scroll.ZIndex = 5
Scroll.Parent = Main

--========================================================
-- CONTENT
--========================================================

local Content = Instance.new("Frame")

Content.Size =
    UDim2.new(1, 0, 0, 690)

Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.Parent = Scroll

--========================================================
-- TOAST
--========================================================

local Toast = Instance.new("Frame")

Toast.Size =
    UDim2.fromOffset(235, 48)

Toast.Position =
    UDim2.new(1, -245, 1, 55)

Toast.BackgroundColor3 =
    Color3.fromRGB(24, 24, 30)

Toast.BorderSizePixel = 0
Toast.Visible = false
Toast.ZIndex = 100
Toast.Parent = Gui

local ToastCorner = Instance.new("UICorner")

ToastCorner.CornerRadius =
    UDim.new(0, 11)

ToastCorner.Parent = Toast

local ToastStroke = Instance.new("UIStroke")

ToastStroke.Color =
    Color3.fromRGB(75, 75, 88)

ToastStroke.Parent = Toast

local ToastText = Instance.new("TextLabel")

ToastText.Size =
    UDim2.new(1, -16, 1, 0)

ToastText.Position =
    UDim2.fromOffset(8, 0)

ToastText.BackgroundTransparency = 1

ToastText.Text =
    "✓ Đã copy link!"

ToastText.TextColor3 =
    Color3.fromRGB(100, 255, 140)

ToastText.TextSize = 11

ToastText.Font =
    Enum.Font.GothamBold

ToastText.TextXAlignment =
    Enum.TextXAlignment.Left

ToastText.ZIndex = 101
ToastText.Parent = Toast

local ToastToken = 0

local function ShowToast(Text)

    ToastToken += 1

    local Token = ToastToken

    ToastText.Text =
        "✓  " .. Text

    Toast.Visible = true

    Toast.Position =
        UDim2.new(
            1,
            -245,
            1,
            55
        )

    TweenService:Create(
        Toast,
        TweenInfo.new(
            0.22,
            Enum.EasingStyle.Quart
        ),
        {
            Position =
                UDim2.new(
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

        local Tween =
            TweenService:Create(
                Toast,
                TweenInfo.new(0.2),
                {
                    Position =
                        UDim2.new(
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
-- SECTION TITLE
--========================================================

local function CreateSectionTitle(Text, Y)

    local Label = Instance.new("TextLabel")

    Label.Size =
        UDim2.new(1, -32, 0, 18)

    Label.Position =
        UDim2.fromOffset(16, Y)

    Label.BackgroundTransparency = 1
    Label.Text = Text

    Label.TextColor3 =
        Color3.fromRGB(170, 170, 180)

    Label.TextSize = 10

    Label.Font =
        Enum.Font.GothamBold

    Label.TextXAlignment =
        Enum.TextXAlignment.Left

    Label.Parent = Content

    return Label
end

--========================================================
-- SOCIAL BUTTON
--========================================================

local function CreateSocialButton(
    Name,
    Icon,
    Position,
    Link
)

    local Button = Instance.new("TextButton")

    Button.Size =
        UDim2.new(1, -32, 0, 30)

    Button.Position =
        Position

    Button.BackgroundColor3 =
        Color3.fromRGB(28, 28, 35)

    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Content

    local Corner = Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0, 8)

    Corner.Parent = Button

    local IconLabel = Instance.new("TextLabel")

    IconLabel.Size =
        UDim2.fromOffset(35, 30)

    IconLabel.Position =
        UDim2.fromOffset(2, 0)

    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = Icon

    IconLabel.TextColor3 =
        Color3.new(1, 1, 1)

    IconLabel.TextSize = 14
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.Parent = Button

    local NameLabel = Instance.new("TextLabel")

    NameLabel.Size =
        UDim2.new(1, -48, 1, 0)

    NameLabel.Position =
        UDim2.fromOffset(42, 0)

    NameLabel.BackgroundTransparency = 1

    NameLabel.Text =
        Name .. "   •   Nhấn để copy link"

    NameLabel.TextColor3 =
        Color3.fromRGB(225, 225, 230)

    NameLabel.TextSize = 10
    NameLabel.Font = Enum.Font.GothamMedium
    NameLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    NameLabel.Parent = Button

    Button.MouseEnter:Connect(function()

        TweenService:Create(
            Button,
            TweenInfo.new(0.12),
            {
                BackgroundColor3 =
                    Color3.fromRGB(43, 43, 52)
            }
        ):Play()

    end)

    Button.MouseLeave:Connect(function()

        TweenService:Create(
            Button,
            TweenInfo.new(0.12),
            {
                BackgroundColor3 =
                    Color3.fromRGB(28, 28, 35)
            }
        ):Play()

    end)

    Button.MouseButton1Click:Connect(function()

        if setclipboard then

            local Success =
                pcall(function()
                    setclipboard(Link)
                end)

            if Success then

                ShowToast(
                    Name .. " • Đã copy link!"
                )

            else

                ShowToast(
                    "Không thể copy link"
                )

            end

        else

            ShowToast(
                "Executor không hỗ trợ copy"
            )

        end

    end)

    return Button
end

--========================================================
-- SOCIAL
--========================================================

CreateSectionTitle(
    "SOCIAL / CONTACT",
    12
)

CreateSocialButton(
    "YouTube",
    "▶",
    UDim2.fromOffset(16, 34),
    INFO.YouTube
)

CreateSocialButton(
    "TikTok",
    "♪",
    UDim2.fromOffset(16, 68),
    INFO.TikTok
)

CreateSocialButton(
    "Discord",
    "◈",
    UDim2.fromOffset(16, 102),
    INFO.Discord
)

--========================================================
-- PERCENT
--========================================================

CreateSectionTitle(
    "MỨC GIẢM ĐỒ HỌA",
    142
)

local PercentBox = Instance.new("TextBox")

PercentBox.Size =
    UDim2.fromOffset(95, 31)

PercentBox.Position =
    UDim2.fromOffset(16, 166)

PercentBox.BackgroundColor3 =
    Color3.fromRGB(28, 28, 35)

PercentBox.BorderSizePixel = 0

PercentBox.Text =
    tostring(ReductionPercent) .. "%"

PercentBox.TextColor3 =
    Color3.new(1, 1, 1)

PercentBox.TextSize = 13
PercentBox.Font = Enum.Font.GothamBold
PercentBox.ClearTextOnFocus = false
PercentBox.Parent = Content

local PercentCorner = Instance.new("UICorner")

PercentCorner.CornerRadius =
    UDim.new(0, 8)

PercentCorner.Parent = PercentBox

local PercentInfo = Instance.new("TextLabel")

PercentInfo.Size =
    UDim2.new(1, -125, 0, 31)

PercentInfo.Position =
    UDim2.fromOffset(121, 166)

PercentInfo.BackgroundTransparency = 1

PercentInfo.Text =
    "100%+ = cực thấp"

PercentInfo.TextColor3 =
    Color3.fromRGB(145, 145, 155)

PercentInfo.TextSize = 10
PercentInfo.Font = Enum.Font.Gotham
PercentInfo.TextXAlignment =
    Enum.TextXAlignment.Left

PercentInfo.Parent = Content

--========================================================
-- SETTINGS
--========================================================

CreateSectionTitle(
    "TÙY CHỌN TỐI ƯU",
    204
)

local ToggleObjects = {}

local function CreateToggle(
    Name,
    Key,
    Position
)

    local Button = Instance.new("TextButton")

    Button.Size =
        UDim2.fromOffset(162, 29)

    Button.Position =
        Position

    Button.BackgroundColor3 =
        Color3.fromRGB(28, 28, 35)

    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Content

    local Corner = Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0, 7)

    Corner.Parent = Button

    local Label = Instance.new("TextLabel")

    Label.Size =
        UDim2.new(1, -48, 1, 0)

    Label.Position =
        UDim2.fromOffset(8, 0)

    Label.BackgroundTransparency = 1
    Label.Text = Name

    Label.TextColor3 =
        Color3.fromRGB(220, 220, 225)

    Label.TextSize = 9
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment =
        Enum.TextXAlignment.Left

    Label.Parent = Button

    local State = Instance.new("TextLabel")

    State.Size =
        UDim2.fromOffset(39, 21)

    State.Position =
        UDim2.new(
            1,
            -45,
            0.5,
            -10
        )

    State.BackgroundColor3 =
        Color3.fromRGB(55, 160, 85)

    State.BorderSizePixel = 0
    State.Text = "ON"

    State.TextColor3 =
        Color3.new(1, 1, 1)

    State.TextSize = 8
    State.Font = Enum.Font.GothamBold
    State.Parent = Button

    local StateCorner = Instance.new("UICorner")

    StateCorner.CornerRadius =
        UDim.new(0, 6)

    StateCorner.Parent = State

    local function Update()

        if Settings[Key] then

            State.Text = "ON"

            State.BackgroundColor3 =
                Color3.fromRGB(
                    55,
                    160,
                    85
                )

        else

            State.Text = "OFF"

            State.BackgroundColor3 =
                Color3.fromRGB(
                    75,
                    75,
                    82
                )

        end

    end

    Button.MouseButton1Click:Connect(function()

        Settings[Key] =
            not Settings[Key]

        Update()

        ShowToast(
            Name ..
            " : " ..
            (
                Settings[Key]
                and "ON"
                or "OFF"
            )
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
    UDim2.fromOffset(16, 228)
)

CreateToggle(
    "Particles / Effects",
    "Particles",
    UDim2.fromOffset(182, 228)
)

CreateToggle(
    "Lights",
    "Lights",
    UDim2.fromOffset(16, 261)
)

CreateToggle(
    "Textures / Decals",
    "Textures",
    UDim2.fromOffset(182, 261)
)

CreateToggle(
    "Post Effects",
    "PostEffects",
    UDim2.fromOffset(16, 294)
)

CreateToggle(
    "Atmosphere / Fog",
    "Atmosphere",
    UDim2.fromOffset(182, 294)
)

CreateToggle(
    "Terrain",
    "Terrain",
    UDim2.fromOffset(16, 327)
)

CreateToggle(
    "Low Material",
    "LowMaterial",
    UDim2.fromOffset(182, 327)
)

CreateToggle(
    "Xóa mặt biển",
    "RemoveWater",
    UDim2.fromOffset(16, 360)
)

CreateToggle(
    "Xóa mưa",
    "RemoveRain",
    UDim2.fromOffset(182, 360)
)

CreateToggle(
    "Xóa sương mù",
    "RemoveFog",
    UDim2.fromOffset(16, 393)
)

--========================================================
-- STATUS
--========================================================

local Status = Instance.new("TextLabel")

Status.Size =
    UDim2.new(1, -32, 0, 20)

Status.Position =
    UDim2.fromOffset(16, 434)

Status.BackgroundTransparency = 1

Status.Text =
    "● Ready"

Status.TextColor3 =
    Color3.fromRGB(150, 150, 160)

Status.TextSize = 9
Status.Font = Enum.Font.Gotham
Status.TextXAlignment =
    Enum.TextXAlignment.Left

Status.Parent = Content

--========================================================
-- FIX BUTTON
--========================================================

local FixButton = Instance.new("TextButton")

FixButton.Size =
    UDim2.new(1, -32, 0, 36)

FixButton.Position =
    UDim2.fromOffset(16, 459)

FixButton.BackgroundColor3 =
    Color3.fromRGB(45, 150, 80)

FixButton.BorderSizePixel = 0

FixButton.Text =
    "⚡  FIX LAG  •  " ..
    ReductionPercent .. "%"

FixButton.TextColor3 =
    Color3.new(1, 1, 1)

FixButton.TextSize = 12
FixButton.Font = Enum.Font.GothamBold
FixButton.AutoButtonColor = false
FixButton.Parent = Content

local FixCorner = Instance.new("UICorner")

FixCorner.CornerRadius =
    UDim.new(0, 8)

FixCorner.Parent = FixButton

--========================================================
-- NOTE
--========================================================

local Note = Instance.new("TextLabel")

Note.Size =
    UDim2.new(1, -32, 0, 55)

Note.Position =
    UDim2.fromOffset(16, 507)

Note.BackgroundTransparency = 1

Note.Text =
    "⚡ FPS Optimizer\n" ..
    "Các tùy chọn được áp dụng phía client."

Note.TextColor3 =
    Color3.fromRGB(145, 145, 155)

Note.TextSize = 9
Note.Font = Enum.Font.Gotham
Note.TextWrapped = true

Note.TextXAlignment =
    Enum.TextXAlignment.Left

Note.TextYAlignment =
    Enum.TextYAlignment.Top

Note.Parent = Content

--========================================================
-- PERCENT
--========================================================

local function GetPercent()

    local Text =
        PercentBox.Text
        :gsub("%%", "")
        :gsub("%s+", "")

    local Number =
        tonumber(Text)

    if not Number then
        Number = 70
    end

    Number =
        math.clamp(
            math.floor(Number),
            0,
            1000
        )

    ReductionPercent = Number

    PercentBox.Text =
        tostring(Number) .. "%"

    FixButton.Text =
        "⚡  FIX LAG  •  " ..
        tostring(Number) ..
        "%"

    return Number
end

--========================================================
-- RAIN CHECK
--========================================================

local function IsRainObject(Object)

    local Name =
        string.lower(
            Object.Name
        )

    return
        string.find(Name, "rain")
        or string.find(Name, "mưa")
        or string.find(Name, "mua")
        or string.find(Name, "storm")
        or string.find(Name, "weather")
        or string.find(Name, "thunder")
end

--========================================================
-- OPTIMIZE OBJECT
--========================================================

local function OptimizeObject(
    Object,
    Percent
)

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
                or Object:IsA("Smoke")
                or Object:IsA("Fire")
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
            and Percent >= 70
        then

            if Object:IsA("PostEffect") then
                Object.Enabled = false
            end

        end

        -- ATMOSPHERE
        if Settings.Atmosphere
            and Percent >= 60
        then

            if Object:IsA("Atmosphere") then

                Object.Density = 0
                Object.Haze = 0
                Object.Glare = 0

            end

        end

        -- 90%+
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

        -- 100%+
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
-- WATER
--========================================================

local function RemoveWaterVisual()

    if not Settings.RemoveWater then
        return
    end

    local Terrain =
        Workspace:FindFirstChildOfClass(
            "Terrain"
        )

    if Terrain then

        pcall(function()

            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1

        end)

    end

end

--========================================================
-- LIGHTING
--========================================================

local function ApplyLighting(
    Percent
)

    if Percent <= 0 then
        return
    end

    -- SHADOW
    if Settings.Shadows
        and Percent >= 10
    then

        pcall(function()

            Lighting.GlobalShadows = false

        end)

    end

    -- ENVIRONMENT
    if Percent >= 25 then

        pcall(function()

            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0

        end)

    end

    -- FOG
    if Settings.RemoveFog then

        pcall(function()

            Lighting.FogStart = 0
            Lighting.FogEnd = 1000000

        end)

    end

    -- ATMOSPHERE
    if Settings.Atmosphere
        or Settings.RemoveFog
    then

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

    -- POST EFFECTS
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

    -- LOW QUALITY
    if Percent >= 75 then

        pcall(function()

            settings().Rendering.QualityLevel =
                Enum.QualityLevel.Level01

        end)

    end

    -- WATER
    if Settings.RemoveWater
        and Percent >= 50
    then

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

    local Percent =
        GetPercent()

    Status.Text =
        "● Đang tối ưu " ..
        tostring(Percent) ..
        "%..."

    Status.TextColor3 =
        Color3.fromRGB(
            255,
            210,
            80
        )

    FixButton.Text =
        "⏳  ĐANG FIX..."

    task.wait()

    -- LIGHTING
    ApplyLighting(
        Percent
    )

    -- WATER
    RemoveWaterVisual()

    -- WORKSPACE
    local Objects =
        Workspace:GetDescendants()

    for Index, Object in ipairs(
        Objects
    ) do

        OptimizeObject(
            Object,
            Percent
        )

        if Index % 250 == 0 then
            task.wait()
        end

    end

    Status.Text =
        "● Đã áp dụng mức " ..
        tostring(Percent) ..
        "%"

    Status.TextColor3 =
        Color3.fromRGB(
            80,
            255,
            120
        )

    FixButton.Text =
        "✓  FIX LAG  •  " ..
        tostring(Percent) ..
        "%"

    ShowToast(
        "Đã tối ưu " ..
        tostring(Percent) ..
        "%"
    )

    IsFixing = false

end

--========================================================
-- INPUT
--========================================================

PercentBox.FocusLost:Connect(
    function()

        GetPercent()

    end
)

FixButton.MouseButton1Click:Connect(
    function()

        task.spawn(
            FixLag
        )

    end
)

--========================================================
-- NEW OBJECT
--========================================================

Workspace.DescendantAdded:Connect(
    function(Object)

        task.defer(
            function()

                if Object
                    and Object.Parent
                then

                    OptimizeObject(
                        Object,
                        ReductionPercent
                    )

                end

            end
        )

    end
)

--========================================================
-- DRAG MAIN
--========================================================

local function MakeDraggable(
    Object,
    Handle
)

    local Dragging = false
    local DragStart
    local StartPosition

    Handle.InputBegan:Connect(
        function(Input)

            if Input.UserInputType ==
                Enum.UserInputType.MouseButton1
                or Input.UserInputType ==
                Enum.UserInputType.Touch
            then

                Dragging = true

                DragStart =
                    Input.Position

                StartPosition =
                    Object.Position

            end

        end
    )

    UserInputService.InputChanged:Connect(
        function(Input)

            if not Dragging then
                return
            end

            if Input.UserInputType ==
                Enum.UserInputType.MouseMovement
                or Input.UserInputType ==
                Enum.UserInputType.Touch
            then

                local Delta =
                    Input.Position -
                    DragStart

                Object.Position =
                    UDim2.new(
                        StartPosition.X.Scale,
                        StartPosition.X.Offset +
                            Delta.X,

                        StartPosition.Y.Scale,
                        StartPosition.Y.Offset +
                            Delta.Y
                    )

            end

        end
    )

    UserInputService.InputEnded:Connect(
        function(Input)

            if Input.UserInputType ==
                Enum.UserInputType.MouseButton1
                or Input.UserInputType ==
                Enum.UserInputType.Touch
            then

                Dragging = false

            end

        end
    )

end

MakeDraggable(
    Main,
    Header
)

--========================================================
-- FLOATING LOGO
--========================================================

local FloatingButton =
    Instance.new("ImageButton")

FloatingButton.Name =
    "TuyenMod2194Floating"

FloatingButton.Size =
    UDim2.fromOffset(
        54,
        54
    )

FloatingButton.Position =
    UDim2.new(
        0,
        15,
        0.5,
        -27
    )

FloatingButton.BackgroundColor3 =
    Color3.fromRGB(
        22,
        22,
        28
    )

FloatingButton.BorderSizePixel = 0

-- FIX LOGO
FloatingButton.Image = LOGO_ID

FloatingButton.ImageTransparency = 0

FloatingButton.ScaleType =
    Enum.ScaleType.Fit

FloatingButton.Visible = false
FloatingButton.AutoButtonColor = false
FloatingButton.ZIndex = 50
FloatingButton.Parent = Gui

local FloatingCorner =
    Instance.new("UICorner")

FloatingCorner.CornerRadius =
    UDim.new(1, 0)

FloatingCorner.Parent =
    FloatingButton

local FloatingStroke =
    Instance.new("UIStroke")

FloatingStroke.Color =
    Color3.fromRGB(
        80,
        80,
        95
    )

FloatingStroke.Thickness = 2
FloatingStroke.Parent =
    FloatingButton

--========================================================
-- FLOATING LOGO DRAG
--========================================================

local FloatDragging = false
local FloatStart
local FloatStartPosition
local FloatMoved = false

FloatingButton.InputBegan:Connect(
    function(Input)

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

        end

    end
)

UserInputService.InputChanged:Connect(
    function(Input)

        if not FloatDragging then
            return
        end

        if Input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or Input.UserInputType ==
            Enum.UserInputType.Touch
        then

            local Delta =
                Input.Position -
                FloatStart

            if math.abs(Delta.X) > 5
                or math.abs(Delta.Y) > 5
            then

                FloatMoved = true

            end

            FloatingButton.Position =
                UDim2.new(
                    FloatStartPosition.X.Scale,
                    FloatStartPosition.X.Offset +
                        Delta.X,

                    FloatStartPosition.Y.Scale,
                    FloatStartPosition.Y.Offset +
                        Delta.Y
                )

        end

    end
)

UserInputService.InputEnded:Connect(
    function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or Input.UserInputType ==
            Enum.UserInputType.Touch
        then

            FloatDragging = false

        end

    end
)

--========================================================
-- MINIMIZE
--========================================================

Minimize.MouseButton1Click:Connect(
    function()

        Main.Visible = false
        FloatingButton.Visible = true

    end
)

--========================================================
-- OPEN
--========================================================

FloatingButton.MouseButton1Click:Connect(
    function()

        if FloatMoved then

            FloatMoved = false

            return

        end

        FloatingButton.Visible = false
        Main.Visible = true

    end
)

--========================================================
-- CLOSE
--========================================================

Close.MouseButton1Click:Connect(
    function()

        Gui:Destroy()

    end
)

--========================================================
-- START
--========================================================

GetPercent()

Status.Text =
    "● Ready"

print(
    "TuyenMod2194 FPS Optimizer Loaded"
)