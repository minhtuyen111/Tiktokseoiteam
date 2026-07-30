--// TUYENMOD2194 - FPS OPTIMIZER
--// Client-side graphics optimizer
--// Percentage-based graphics reduction
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
--==================================================
-- INFO
--==================================================
local INFO = {
    YouTube = "@tuyenmod2194",
    TikTok = "@laptrinhpy",
    Discord = "https://discord.gg/w39eWVa69"
}
local ReductionPercent = 70
--==================================================
-- GUI
--==================================================
local Gui = Instance.new("ScreenGui")
Gui.Name = "TuyenMod2194FPS"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(390, 390)
Main.Position = UDim2.new(0.5, -195, 0.5, -195)
Main.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
Main.BorderSizePixel = 0
Main.Parent = Gui
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = Main
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(65, 65, 75)
Stroke.Transparency = 0.2
Parent = Main
Stroke.Parent = Main
--==================================================
-- HEADER
--==================================================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 72)
Header.BackgroundColor3 = Color3.fromRGB(23, 23, 29)
Header.BorderSizePixel = 0
Header.Parent = Main
local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 16)
HeaderCorner.Parent = Header
local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 18)
HeaderFix.Position = UDim2.new(0, 0, 1, -18)
HeaderFix.BackgroundColor3 = Header.BackgroundColor3
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 0, 30)
Title.Position = UDim2.fromOffset(18, 8)
Title.BackgroundTransparency = 1
Title.Text = "TuyenMod2194"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header
local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -70, 0, 20)
SubTitle.Position = UDim2.fromOffset(19, 40)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "FPS Optimizer • Blox Fruits"
SubTitle.TextColor3 = Color3.fromRGB(155, 155, 165)
SubTitle.TextSize = 12
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header
local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(32, 32)
Close.Position = UDim2.new(1, -45, 0, 20)
Close.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
Close.Text = "×"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.TextSize = 22
Close.Font = Enum.Font.GothamBold
Close.Parent = Header
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 9)
CloseCorner.Parent = Close
--==================================================
-- SOCIAL
--==================================================
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
local function CreateButton(Text, Position, Callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -36, 0, 30)
    Button.Position = Position
    Button.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 = Color3.fromRGB(225, 225, 230)
    Button.TextSize = 12
    Button.Font = Enum.Font.GothamMedium
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = Main
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    Button.MouseEnter:Connect(function()
        TweenService:Create(
            Button,
            TweenInfo.new(0.12),
            {BackgroundColor3 = Color3.fromRGB(40, 40, 48)}
        ):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(
            Button,
            TweenInfo.new(0.12),
            {BackgroundColor3 = Color3.fromRGB(28, 28, 35)}
        ):Play()
    end)
    Button.MouseButton1Click:Connect(Callback)
    return Button
end
CreateButton(
    "  ▶  YouTube     " .. INFO.YouTube,
    UDim2.fromOffset(18, 105),
    function()
        if setclipboard then
            setclipboard(INFO.YouTube)
        end
    end
)
CreateButton(
    "  ♪  TikTok       " .. INFO.TikTok,
    UDim2.fromOffset(18, 139),
    function()
        if setclipboard then
            setclipboard(INFO.TikTok)
        end
    end
)
local DiscordButton = CreateButton(
    "  ◈  Discord      Nhấn để copy link",
    UDim2.fromOffset(18, 173),
    function()
        if setclipboard then
            setclipboard(INFO.Discord)
            DiscordButton.Text = "  ✓  Discord      Đã copy link!"
            task.delay(2, function()
                if DiscordButton.Parent then
                    DiscordButton.Text =
                        "  ◈  Discord      Nhấn để copy link"
                end
            end)
        end
    end
)
--==================================================
-- % REDUCTION
--==================================================
local PercentTitle = Instance.new("TextLabel")
PercentTitle.Size = UDim2.new(1, -36, 0, 22)
PercentTitle.Position = UDim2.fromOffset(18, 211)
PercentTitle.BackgroundTransparency = 1
PercentTitle.Text = "MỨC GIẢM ĐỒ HỌA"
PercentTitle.TextColor3 = Color3.fromRGB(170, 170, 180)
PercentTitle.TextSize = 11
PercentTitle.Font = Enum.Font.GothamBold
PercentTitle.TextXAlignment = Enum.TextXAlignment.Left
PercentTitle.Parent = Main
local PercentBox = Instance.new("TextBox")
PercentBox.Size = UDim2.fromOffset(100, 34)
PercentBox.Position = UDim2.fromOffset(18, 238)
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
PercentInfo.Size = UDim2.new(1, -135, 0, 34)
PercentInfo.Position = UDim2.fromOffset(130, 238)
PercentInfo.BackgroundTransparency = 1
PercentInfo.Text = "0% = ít giảm   •   100% = cực thấp"
PercentInfo.TextColor3 = Color3.fromRGB(145, 145, 155)
PercentInfo.TextSize = 11
PercentInfo.Font = Enum.Font.Gotham
PercentInfo.TextXAlignment = Enum.TextXAlignment.Left
PercentInfo.Parent = Main
--==================================================
-- STATUS
--==================================================
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -36, 0, 20)
Status.Position = UDim2.fromOffset(18, 278)
Status.BackgroundTransparency = 1
Status.Text = "● Ready"
Status.TextColor3 = Color3.fromRGB(150, 150, 160)
Status.TextSize = 11
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main
--==================================================
-- FIX BUTTON
--==================================================
local FixButton = Instance.new("TextButton")
FixButton.Size = UDim2.new(1, -36, 0, 42)
FixButton.Position = UDim2.fromOffset(18, 302)
FixButton.BackgroundColor3 = Color3.fromRGB(45, 150, 80)
FixButton.BorderSizePixel = 0
FixButton.Text = "⚡  FIX LAG  •  " .. ReductionPercent .. "%"
FixButton.TextColor3 = Color3.new(1, 1, 1)
FixButton.TextSize = 14
FixButton.Font = Enum.Font.GothamBold
FixButton.Parent = Main
local FixCorner = Instance.new("UICorner")
FixCorner.CornerRadius = UDim.new(0, 9)
FixCorner.Parent = FixButton
--==================================================
-- NOTE
--==================================================
local Note = Instance.new("TextLabel")
Note.Size = UDim2.new(1, -36, 0, 30)
Note.Position = UDim2.fromOffset(18, 350)
Note.BackgroundTransparency = 1
Note.Text = "🥸  Vào nhóm sẽ có cơ hội tẩm quất giun biển mỗi đêm🥸"
Note.TextColor3 = Color3.fromRGB(170, 170, 180)
Note.TextSize = 10
Note.Font = Enum.Font.Gotham
Note.TextWrapped = true
Note.TextXAlignment = Enum.TextXAlignment.Left
Note.Parent = Main
--==================================================
-- OPTIMIZER
--==================================================
local function GetPercent()
    local Text = PercentBox.Text:gsub("%%", "")
    local Number = tonumber(Text)
    if not Number then
        Number = 70
    end
    Number = math.clamp(Number, 0, 100)
    PercentBox.Text = tostring(Number) .. "%"
    ReductionPercent = Number
    FixButton.Text =
        "⚡  FIX LAG  •  " .. Number .. "%"
    return Number
end
local function OptimizeObject(Object, Percent)
    pcall(function()
        -- 20% trở lên: giảm bóng
        if Percent >= 20 and Object:IsA("BasePart") then
            Object.CastShadow = false
        end
        -- 40% trở lên: giảm particle/effect
        if Percent >= 40 then
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
        -- 60% trở lên: tắt ánh sáng phụ
        if Percent >= 60 then
            if Object:IsA("PointLight")
                or Object:IsA("SpotLight")
                or Object:IsA("SurfaceLight")
            then
                Object.Enabled = false
            end
        end
        -- 80% trở lên: giảm texture/decal
        if Percent >= 80 then
            if Object:IsA("Texture")
                or Object:IsA("Decal")
            then
                Object.Transparency = 1
            end
        end
    end)
end
local function ApplyGraphics(Percent)
    -- 0-25%
    if Percent < 25 then
        return
    end
    -- 25%+
    pcall(function()
        Lighting.GlobalShadows = false
    end)
    -- 40%+
    if Percent >= 40 then
        pcall(function()
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
        end)
    end
    -- 60%+
    if Percent >= 60 then
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
    -- 80%+
    if Percent >= 80 then
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
    -- 100% = đồ họa cực thấp
    if Percent >= 100 then
        pcall(function()
            settings().Rendering.QualityLevel =
                Enum.QualityLevel.Level01
        end)
        local Terrain =
            Workspace:FindFirstChildOfClass("Terrain")
        if Terrain then
            pcall(function()
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
            end)
        end
    end
end
local function FixLag()
    local Percent = GetPercent()
    Status.Text =
        "● Đang giảm đồ họa xuống " .. Percent .. "%..."
    FixButton.Text = "⏳  ĐANG FIX..."
    task.wait()
    ApplyGraphics(Percent)
    for _, Object in ipairs(
        Workspace:GetDescendants()
    ) do
        OptimizeObject(Object, Percent)
    end
    Status.Text =
        "● Đã áp dụng mức " .. Percent .. "%"
    Status.TextColor3 =
        Color3.fromRGB(80, 255, 120)
    FixButton.Text =
        "✓  FIX LAG  •  " .. Percent .. "%"
end
--==================================================
-- BUTTON
--==================================================
PercentBox.FocusLost:Connect(function()
    GetPercent()
end)
FixButton.MouseButton1Click:Connect(function()
    task.spawn(FixLag)
end)
--==================================================
-- OBJECT MỚI
--==================================================
Workspace.DescendantAdded:Connect(function(Object)
    task.defer(function()
        local Percent = ReductionPercent
        OptimizeObject(Object, Percent)
    end)
end)
--==================================================
-- DRAG MENU
--==================================================
local Dragging = false
local DragStart
local StartPosition
Header.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch
    then
        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position
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
--==================================================
-- CLOSE
--==================================================
Close.MouseButton1Click:Connect(function()
    Gui:Destroy()
end)