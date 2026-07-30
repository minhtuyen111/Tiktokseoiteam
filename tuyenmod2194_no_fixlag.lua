loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDangNhoEm/tuyenmod2194/refs/heads/main/koby"))()

-- ==========================================
-- SERVICES
-- ==========================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")

-- PLAYER
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui", 5)

-- CHARACTER
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- EXPLOIT CHECK
local executor = (getexecutorname and getexecutorname()) or (identifyexecutor and identifyexecutor())
if executor then
    if
        string.find(executor, "Bunni") or
        string.find(executor, "FluxusZ") or
        string.find(executor, "Delta") or
        string.find(executor, "Arceus") or
        string.find(executor, "Xeno") or
        string.find(executor, "Swift") or
        string.find(executor, "Awp") or
        string.find(executor, "Volcano") or
        string.find(executor, "Argon") or
        string.find(executor, "Macsploit") or
        string.find(executor, "Potassium") or
        string.find(executor, "CodeX") or
        string.find(executor, "Velocity") or
        string.find(executor, "Romix") or
        string.find(executor, "Neutron")
    then
        print("ok")
    else
        game.Players.LocalPlayer:Kick("Please use Delta Exploit or PC use volcano or Exploit paid!")
    end
end

-- ALIASES
local ply = Players
local replicated = ReplicatedStorage
local RunSer = RunService
local vim1 = VirtualInputManager
local vim2 = VirtualUser
local TW = TweenService
local plr = Player
local Root = HumanoidRootPart

-- ==========================================
-- LOAD UI LIBRARY (tuyenmod2194)
-- ==========================================
Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/hdanhhub/UI/refs/heads/main/ui_tuyenmod2194_final.lua"))()

Window = Library:CreateWindow({
    Title = "tuyenmod2194",
    Desc = "- Blox Fruit",
    Image = "rbxassetid://123613996022560"
})

-- ==========================================
-- TẠO CÁC TABS (ĐÚNG API: AddTab nhận string)
-- ==========================================
-- ========================================================
-- HELPER: Thêm OnChanged vào object trả về từ UI elements
-- ========================================================
local function makeProxy(obj, callbackHolder)
    -- obj: object gốc từ library (toggleFunction, dropdownFunction, slider_function)
    -- callbackHolder: { extra = nil } - tham chiếu để inject OnChanged callback
    local proxy = {}
    setmetatable(proxy, {
        __index = function(_, k)
            -- OnChanged: đăng ký callback bổ sung
            if k == "OnChanged" then
                return function(_, fn)
                    callbackHolder.extra = fn
                    return proxy -- cho phép chain
                end
            end
            -- SetStage (toggle) - dot method, không cần self
            if k == "SetStage" and obj.SetStage then
                return function(_, v) pcall(obj.SetStage, v) end
            end
            -- SetValue (slider/dropdown) - thử dot rồi colon
            if k == "SetValue" then
                return function(_, v)
                    if obj.SetValue then
                        local ok = pcall(obj.SetValue, v)
                        if not ok then pcall(function() obj:SetValue(v) end) end
                    end
                end
            end
            -- GetValue
            if k == "GetValue" then
                return function(_)
                    if obj.GetValue then
                        local ok, val = pcall(obj.GetValue)
                        if ok then return val end
                        local ok2, val2 = pcall(function() return obj:GetValue() end)
                        return val2
                    end
                end
            end
            -- SetText / SetDesc (label / paragraph)
            if k == "SetText" or k == "SetDesc" then
                return function(_, t)
                    if obj.SetText then pcall(obj.SetText, obj, t)
                    elseif obj.SetDesc then pcall(obj.SetDesc, obj, t) end
                end
            end
            -- GetNewList (dropdown)
            if k == "GetNewList" then
                return function(_, list)
                    if obj.GetNewList then pcall(obj.GetNewList, obj, list) end
                end
            end
            -- ClearText (dropdown)
            if k == "ClearText" then
                return function(_, v)
                    if obj.ClearText then pcall(obj.ClearText, obj, v) end
                end
            end
            -- fallback: raw value
            local v = rawget(obj, k) or (type(obj) == "table" and obj[k])
            if type(v) == "function" then
                return function(_, ...) return pcall(v, obj, ...) end
            end
            return v
        end
    })
    return proxy
end

local function wrapTab(rawTab)
    local _currentSection = nil
    local _nextIsRight = false

    -- Đảm bảo có section để dùng (lazy init)
    local function ensureSection()
        if not _currentSection then
            _currentSection = rawTab:AddLeftGroupbox(" ")
        end
    end

    local wrapped = {}

    -- AddSection: tạo section mới xen kẽ Left/Right, không tạo mục ảo
    function wrapped:AddSection(name)
        if _nextIsRight then
            _currentSection = rawTab:AddRightGroupbox(name or " ")
            _nextIsRight = false
        else
            _currentSection = rawTab:AddLeftGroupbox(name or " ")
            _nextIsRight = true
        end
        return _currentSection
    end

    function wrapped:AddToggle(id, setting)
        ensureSection()
        local holder = { extra = nil }
        local origCb = setting.Callback or setting["Callback"]
        setting.Callback = function(v)
            if origCb then pcall(origCb, v) end
            if holder.extra then pcall(holder.extra, v) end
        end
        setting["Callback"] = setting.Callback
        -- Xóa Description để tránh button bị đẩy xuống dòng
        setting["Description"] = nil
        setting.Description = nil
        local obj = _currentSection:AddToggle(id, setting)
        return makeProxy(obj, holder)
    end

    function wrapped:AddButton(setting, cb)
        ensureSection()
        -- Xóa Description để tránh button bị đẩy xuống dòng
        if type(setting) == "table" then
            setting["Description"] = nil
            setting.Description = nil
        end
        local proxy = _currentSection:AddButton(setting, cb)
        if proxy then
            local holder = {}
            return makeProxy(proxy, holder)
        end
    end

    function wrapped:AddDropdown(id, setting)
        ensureSection()
        local holder = { extra = nil }
        local origCb = setting.Callback or setting["Callback"]
        setting.Callback = function(v)
            if origCb then pcall(origCb, v) end
            if holder.extra then pcall(holder.extra, v) end
        end
        setting["Callback"] = setting.Callback
        setting["Description"] = nil
        setting.Description = nil
        local obj = _currentSection:AddDropdown(id, setting)
        return makeProxy(obj, holder)
    end

    function wrapped:AddSlider(id, setting)
        ensureSection()
        local holder = { extra = nil }
        local origCb = setting.Callback or setting["Callback"]
        setting.Callback = function(v)
            if origCb then pcall(origCb, v) end
            if holder.extra then pcall(holder.extra, v) end
        end
        setting["Callback"] = setting.Callback
        setting["Description"] = nil
        setting.Description = nil
        local obj = _currentSection:AddSlider(setting)
        return makeProxy(obj, holder)
    end

    function wrapped:AddInput(id, setting)
        ensureSection()
        local holder = { extra = nil }
        local origCb = setting.Callback or setting["Callback"]
        setting.Callback = function(v)
            if origCb then pcall(origCb, v) end
            if holder.extra then pcall(holder.extra, v) end
        end
        setting["Callback"] = setting.Callback
        local obj = _currentSection:AddInput(id, setting)
        return makeProxy(obj, holder)
    end

    function wrapped:AddParagraph(setting)
        ensureSection()
        local title = setting.Title or setting["Title"] or ""
        local desc  = setting.Description or setting["Description"] or setting.Desc or ""
        local txt   = desc ~= "" and (title .. "\n" .. desc) or title
        local obj = _currentSection:AddLabel(txt)
        local holder = {}
        return makeProxy(obj, holder)
    end

    function wrapped:AddLabel(text)
        ensureSection()
        local obj = _currentSection:AddLabel(text)
        local holder = {}
        return makeProxy(obj, holder)
    end

    return wrapped
end

-- ==========================================
-- TẠO CÁC TABS VỚI WRAPPER
-- ==========================================
Tabs = {
    ["Info"]     = wrapTab(Window:AddTab("Thông Tin")),
    ["Main"]     = wrapTab(Window:AddTab("Cày Cấp")),
    ["Sea"]      = wrapTab(Window:AddTab("Sự Kiện")),
    ["Item"]     = wrapTab(Window:AddTab("Lấy & Nâng Cấp Vật Phẩm")),
    ["Setting"]  = wrapTab(Window:AddTab("Cài Đặt")),
    ["Status"]   = wrapTab(Window:AddTab("Webhook")),
    ["Stats"]    = wrapTab(Window:AddTab("Chỉ Số")),
    ["Player"]   = wrapTab(Window:AddTab("Người Chơi")),
    ["Teleport"] = wrapTab(Window:AddTab("Dịch Chuyển")),
    ["Visual"]   = wrapTab(Window:AddTab("Giả Mạo")),
    ["Fruit"]    = wrapTab(Window:AddTab("Trái Ác Quỷ")),
    ["Raid"]     = wrapTab(Window:AddTab("Đột Kích")),
    ["Race"]     = wrapTab(Window:AddTab("Nâng Cấp Chủng Tộc")),
    ["Shop"]     = wrapTab(Window:AddTab("Cửa Hàng")),
    ["Misc"]     = wrapTab(Window:AddTab("Khác")),
}

-- ==========================================
-- ĐỔI MÀU HỒNG CHO TOÀN BỘ UI
-- ==========================================
pcall(function()
    if Library.SetTheme then
        Library:SetTheme({
            Background         = Color3.fromRGB(255, 182, 193),
            Accent             = Color3.fromRGB(255, 20, 147),
            PrimaryText        = Color3.fromRGB(255, 255, 255),
            SecondaryText      = Color3.fromRGB(255, 220, 230),
            Divider            = Color3.fromRGB(255, 105, 180),
            Header             = Color3.fromRGB(220, 20, 90),
            Box                = Color3.fromRGB(255, 145, 175),
            Button             = Color3.fromRGB(255, 20, 147),
            Hover              = Color3.fromRGB(255, 80, 160),
            Toggle             = Color3.fromRGB(255, 20, 147),
            ToggleBackground   = Color3.fromRGB(255, 182, 193),
            Dropdown           = Color3.fromRGB(255, 145, 175),
            DropdownBackground = Color3.fromRGB(255, 182, 193),
            Scrollbar          = Color3.fromRGB(255, 20, 147),
            Outline            = Color3.fromRGB(255, 105, 180),
            Shadow             = Color3.fromRGB(180, 0, 80),
        })
    end

    if Library.Theme then
        for k, v in pairs(Library.Theme) do
            if typeof(v) == "Color3" then
                if k:lower():find("accent") or k:lower():find("primary") then
                    Library.Theme[k] = Color3.fromRGB(255, 20, 147)
                elseif k:lower():find("back") or k:lower():find("bg") then
                    Library.Theme[k] = Color3.fromRGB(255, 182, 193)
                elseif k:lower():find("text") then
                    Library.Theme[k] = Color3.fromRGB(255, 255, 255)
                else
                    Library.Theme[k] = Color3.fromRGB(255, 105, 180)
                end
            end
        end
    end

    task.spawn(function()
        task.wait(0.5)
        for _, gui in pairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                for _, desc in pairs(gui:GetDescendants()) do
                    if desc:IsA("Frame") or desc:IsA("ScrollingFrame") then
                        if desc.BackgroundTransparency < 1 then
                            desc.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
                        end
                    elseif desc:IsA("TextButton") then
                        desc.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
                        desc.TextColor3 = Color3.fromRGB(255, 255, 255)
                    elseif desc:IsA("TextLabel") then
                        desc.TextColor3 = Color3.fromRGB(255, 255, 255)
                    elseif desc:IsA("ImageLabel") or desc:IsA("ImageButton") then
                        desc.ImageColor3 = Color3.fromRGB(255, 105, 180)
                    elseif desc:IsA("UIStroke") then
                        desc.Color = Color3.fromRGB(255, 20, 147)
                    end
                end
            end
        end
    end)
end)

wait(1)

Library:Notify({
    Title = "tuyenmod2194",
    Description = "Chào mừng! UI màu hồng đã được load thành công.\nNhấn nút góc trái màn hình để mở GUI.",
    Duration = 4
})

-- ==========================================
-- TOGGLE BUTTON (NÚT MỞ/ĐÓNG MENU)
-- ==========================================

-- Anti AFK
game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait()
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- ==========================================
-- SEA FLAGS (không kiểm tra, bật hết để mọi tính năng hoạt động)
-- ==========================================
Sea1 = true
Sea2 = true
Sea3 = true
local v5 = game.PlaceId

function CheckLevel()
    local v7 = game:GetService("Players").LocalPlayer.Data.Level.Value
    if Sea1 then
        if v7 == 1 or (v7 <= 9 or SelectMonster == "Bandit") then
            Ms = "Bandit"
            NameQuest = "BanditQuest1"
            QuestLv = 1
            NameMon = "Bandit"
            CFrameQ = CFrame.new(1060.9383544922, 16.455066680908, 1547.7841796875)
            CFrameMon = CFrame.new(1038.5533447266, 41.296249389648, 1576.5098876953)
        elseif v7 == 10 or (v7 <= 14 or SelectMonster == "Monkey") then
            Ms = "Monkey"
            NameQuest = "JungleQuest"
            QuestLv = 1
            NameMon = "Monkey"
            CFrameQ = CFrame.new(- 1601.6553955078, 36.85213470459, 153.38809204102)
            CFrameMon = CFrame.new(- 1448.1446533203, 50.851993560791, 63.60718536377)
        elseif v7 == 15 or (v7 <= 29 or SelectMonster == "Gorilla") then
            Ms = "Gorilla"
            NameQuest = "JungleQuest"
            QuestLv = 2
            NameMon = "Gorilla"
            CFrameQ = CFrame.new(- 1601.6553955078, 36.85213470459, 153.38809204102)
            CFrameMon = CFrame.new(- 1142.6488037109, 40.462348937988, - 515.39227294922)
        elseif v7 == 30 or (v7 <= 39 or SelectMonster == "Pirate") then
            Ms = "Pirate"
            NameQuest = "BuggyQuest1"
            QuestLv = 1
            NameMon = "Pirate"
            CFrameQ = CFrame.new(- 1140.1761474609, 4.752049446106, 3827.4057617188)
            CFrameMon = CFrame.new(- 1201.0881347656, 40.628940582275, 3857.5966796875)
        elseif v7 == 40 or (v7 <= 59 or SelectMonster == "Brute") then
            Ms = "Brute"
            NameQuest = "BuggyQuest1"
            QuestLv = 2
            NameMon = "Brute"
            CFrameQ = CFrame.new(- 1140.1761474609, 4.752049446106, 3827.4057617188)
            CFrameMon = CFrame.new(- 1387.5324707031, 24.592035293579, 4100.9575195313)
        elseif v7 == 60 or (v7 <= 74 or SelectMonster == "Desert Bandit") then
            Ms = "Desert Bandit"
            NameQuest = "DesertQuest"
            QuestLv = 1
            NameMon = "Desert Bandit"
            CFrameQ = CFrame.new(896.51721191406, 6.4384617805481, 4390.1494140625)
            CFrameMon = CFrame.new(984.99896240234, 16.109552383423, 4417.91015625)
        elseif v7 == 75 or (v7 <= 89 or SelectMonster == "Desert Officer") then
            Ms = "Desert Officer"
            NameQuest = "DesertQuest"
            QuestLv = 2
            NameMon = "Desert Officer"
            CFrameQ = CFrame.new(896.51721191406, 6.4384617805481, 4390.1494140625)
            CFrameMon = CFrame.new(1547.1510009766, 14.452038764954, 4381.8002929688)
        elseif v7 == 90 or (v7 <= 99 or SelectMonster == "Snow Bandit") then
            Ms = "Snow Bandit"
            NameQuest = "SnowQuest"
            QuestLv = 1
            NameMon = "Snow Bandit"
            CFrameQ = CFrame.new(1386.8073730469, 87.272789001465, - 1298.3576660156)
            CFrameMon = CFrame.new(1356.3028564453, 105.76865386963, - 1328.2418212891)
        elseif v7 == 100 or (v7 <= 119 or SelectMonster == "Snowman") then
            Ms = "Snowman"
            NameQuest = "SnowQuest"
            QuestLv = 2
            NameMon = "Snowman"
            CFrameQ = CFrame.new(1386.8073730469, 87.272789001465, - 1298.3576660156)
            CFrameMon = CFrame.new(1218.7956542969, 138.01184082031, - 1488.0262451172)
        elseif v7 == 120 or (v7 <= 149 or SelectMonster == "Chief Petty Officer") then
            Ms = "Chief Petty Officer"
            NameQuest = "MarineQuest2"
            QuestLv = 1
            NameMon = "Chief Petty Officer"
            CFrameQ = CFrame.new(- 5035.49609375, 28.677835464478, 4324.1840820313)
            CFrameMon = CFrame.new(- 4931.1552734375, 65.793113708496, 4121.8393554688)
        elseif v7 == 150 or (v7 <= 174 or SelectMonster == "Sky Bandit") then
            Ms = "Sky Bandit"
            NameQuest = "SkyQuest"
            QuestLv = 1
            NameMon = "Sky Bandit"
            CFrameQ = CFrame.new(- 4842.1372070313, 717.69543457031, - 2623.0483398438)
            CFrameMon = CFrame.new(- 4955.6411132813, 365.46365356445, - 2908.1865234375)
        elseif v7 == 175 or (v7 <= 189 or SelectMonster == "Dark Master") then
            Ms = "Dark Master"
            NameQuest = "SkyQuest"
            QuestLv = 2
            NameMon = "Dark Master"
            CFrameQ = CFrame.new(- 4842.1372070313, 717.69543457031, - 2623.0483398438)
            CFrameMon = CFrame.new(- 5148.1650390625, 439.04571533203, - 2332.9611816406)
        elseif v7 == 190 or (v7 <= 209 or SelectMonster == "Prisoner") then
            Ms = "Prisoner"
            NameQuest = "PrisonerQuest"
            QuestLv = 1
            NameMon = "Prisoner"
            CFrameQ = CFrame.new(5310.60547, 0.350014925, 474.946594, 0.0175017118, 0, 0.999846935, 0, 1, 0, - 0.999846935, 0, 0.0175017118)
            CFrameMon = CFrame.new(4937.31885, 0.332031399, 649.574524, 0.694649816, 0, - 0.719348073, 0, 1, 0, 0.719348073, 0, 0.694649816)
        elseif v7 == 210 or (v7 <= 249 or SelectMonster == "Dangerous Prisoner") then
            Ms = "Dangerous Prisoner"
            NameQuest = "PrisonerQuest"
            QuestLv = 2
            NameMon = "Dangerous Prisoner"
            CFrameQ = CFrame.new(5310.60547, 0.350014925, 474.946594, 0.0175017118, 0, 0.999846935, 0, 1, 0, - 0.999846935, 0, 0.0175017118)
            CFrameMon = CFrame.new(5099.6626, 0.351562679, 1055.7583, 0.898906827, 0, - 0.438139856, 0, 1, 0, 0.438139856, 0, 0.898906827)
        elseif v7 == 250 or (v7 <= 274 or SelectMonster == "Toga Warrior") then
            Ms = "Toga Warrior"
            NameQuest = "ColosseumQuest"
            QuestLv = 1
            NameMon = "Toga Warrior"
            CFrameQ = CFrame.new(- 1577.7890625, 7.4151420593262, - 2984.4838867188)
            CFrameMon = CFrame.new(- 1872.5166015625, 49.080215454102, - 2913.810546875)
        elseif v7 == 275 or (v7 <= 299 or SelectMonster == "Gladiator") then
            Ms = "Gladiator"
            NameQuest = "ColosseumQuest"
            QuestLv = 2
            NameMon = "Gladiator"
            CFrameQ = CFrame.new(- 1577.7890625, 7.4151420593262, - 2984.4838867188)
            CFrameMon = CFrame.new(- 1521.3740234375, 81.203170776367, - 3066.3139648438)
        elseif v7 == 300 or (v7 <= 324 or SelectMonster == "Military Soldier") then
            Ms = "Military Soldier"
            NameQuest = "MagmaQuest"
            QuestLv = 1
            NameMon = "Military Soldier"
            CFrameQ = CFrame.new(- 5316.1157226563, 12.262831687927, 8517.00390625)
            CFrameMon = CFrame.new(- 5369.0004882813, 61.24352645874, 8556.4921875)
        elseif v7 == 325 or (v7 <= 374 or SelectMonster == "Military Spy") then
            Ms = "Military Spy"
            NameQuest = "MagmaQuest"
            QuestLv = 2
            NameMon = "Military Spy"
            CFrameQ = CFrame.new(- 5316.1157226563, 12.262831687927, 8517.00390625)
            CFrameMon = CFrame.new(- 5787.00293, 75.8262634, 8651.69922, 0.838590562, 0, - 0.544762194, 0, 1, 0, 0.544762194, 0, 0.838590562)
        elseif v7 == 375 or (v7 <= 399 or SelectMonster == "Fishman Warrior") then
            Ms = "Fishman Warrior"
            NameQuest = "FishmanQuest"
            QuestLv = 1
            NameMon = "Fishman Warrior"
            CFrameQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            CFrameMon = CFrame.new(60844.10546875, 98.462875366211, 1298.3985595703)
            if _G.AutoLevel and (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 3000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        elseif v7 == 400 or (v7 <= 449 or SelectMonster == "Fishman Commando") then
            Ms = "Fishman Commando"
            NameQuest = "FishmanQuest"
            QuestLv = 2
            NameMon = "Fishman Commando"
            CFrameQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            CFrameMon = CFrame.new(61738.3984375, 64.207321166992, 1433.8375244141)
            if _G.AutoLevel and (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 3000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        elseif v7 == 10 or (v7 <= 474 or SelectMonster == "God\'s Guard") then
            Ms = "God\'s Guard"
            NameQuest = "SkyExp1Quest"
            QuestLv = 1
            NameMon = "God\'s Guard"
            CFrameQ = CFrame.new(- 4721.8603515625, 845.30297851563, - 1953.8489990234)
            CFrameMon = CFrame.new(- 4628.0498046875, 866.92877197266, - 1931.2352294922)
            if _G.AutoLevel and (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 3000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 4607.82275, 872.54248, - 1667.55688))
            end
        elseif v7 == 475 or (v7 <= 524 or SelectMonster == "Shanda") then
            Ms = "Shanda"
            NameQuest = "SkyExp1Quest"
            QuestLv = 2
            NameMon = "Shanda"
            CFrameQ = CFrame.new(- 7863.1596679688, 5545.5190429688, - 378.42266845703)
            CFrameMon = CFrame.new(- 7685.1474609375, 5601.0751953125, - 441.38876342773)
            if _G.AutoLevel and (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 3000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 7894.6176757813, 5547.1416015625, - 380.29119873047))
            end
        elseif v7 == 525 or (v7 <= 549 or SelectMonster == "Royal Squad") then
            Ms = "Royal Squad"
            NameQuest = "SkyExp2Quest"
            QuestLv = 1
            NameMon = "Royal Squad"
            CFrameQ = CFrame.new(- 7903.3828125, 5635.9897460938, - 1410.923828125)
            CFrameMon = CFrame.new(- 7654.2514648438, 5637.1079101563, - 1407.7550048828)
        elseif v7 == 550 or (v7 <= 624 or SelectMonster == "Royal Soldier") then
            Ms = "Royal Soldier"
            NameQuest = "SkyExp2Quest"
            QuestLv = 2
            NameMon = "Royal Soldier"
            CFrameQ = CFrame.new(- 7903.3828125, 5635.9897460938, - 1410.923828125)
            CFrameMon = CFrame.new(- 7760.4106445313, 5679.9077148438, - 1884.8112792969)
        elseif v7 == 625 or (v7 <= 649 or SelectMonster == "Galley Pirate") then
            Ms = "Galley Pirate"
            NameQuest = "FountainQuest"
            QuestLv = 1
            NameMon = "Galley Pirate"
            CFrameQ = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875)
            CFrameMon = CFrame.new(5557.1684570313, 152.32717895508, 3998.7758789063)
        elseif v7 >= 650 or SelectMonster == "Galley Captain" then
            Ms = "Galley Captain"
            NameQuest = "FountainQuest"
            QuestLv = 2
            NameMon = "Galley Captain"
            CFrameQ = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875)
            CFrameMon = CFrame.new(5677.6772460938, 92.786109924316, 4966.6323242188)
        end
    end
    if Sea2 then
        if v7 == 700 or (v7 <= 724 or SelectMonster == "Raider") then
            Ms = "Raider"
            NameQuest = "Area1Quest"
            QuestLv = 1
            NameMon = "Raider"
            CFrameQ = CFrame.new(- 427.72567749023, 72.99634552002, 1835.9426269531)
            CFrameMon = CFrame.new(68.874565124512, 93.635643005371, 2429.6752929688)
        elseif v7 == 725 or (v7 <= 774 or SelectMonster == "Mercenary") then
            Ms = "Mercenary"
            NameQuest = "Area1Quest"
            QuestLv = 2
            NameMon = "Mercenary"
            CFrameQ = CFrame.new(- 427.72567749023, 72.99634552002, 1835.9426269531)
            CFrameMon = CFrame.new(- 864.85009765625, 122.47104644775, 1453.1505126953)
        elseif v7 == 775 or (v7 <= 799 or SelectMonster == "Swan Pirate") then
            Ms = "Swan Pirate"
            NameQuest = "Area2Quest"
            QuestLv = 1
            NameMon = "Swan Pirate"
            CFrameQ = CFrame.new(635.61151123047, 73.096351623535, 917.81298828125)
            CFrameMon = CFrame.new(1065.3669433594, 137.64012145996, 1324.3798828125)
        elseif v7 == 800 or (v7 <= 874 or SelectMonster == "Factory Staff") then
            Ms = "Factory Staff"
            NameQuest = "Area2Quest"
            QuestLv = 2
            NameMon = "Factory Staff"
            CFrameQ = CFrame.new(635.61151123047, 73.096351623535, 917.81298828125)
            CFrameMon = CFrame.new(533.22045898438, 128.46876525879, 355.62615966797)
        elseif v7 == 875 or (v7 <= 899 or SelectMonster == "Marine Lieutenan") then
            Ms = "Marine Lieutenant"
            NameQuest = "MarineQuest3"
            QuestLv = 1
            NameMon = "Marine Lieutenant"
            CFrameQ = CFrame.new(- 2440.9934082031, 73.04190826416, - 3217.7082519531)
            CFrameMon = CFrame.new(- 2489.2622070313, 84.613594055176, - 3151.8830566406)
        elseif v7 == 900 or (v7 <= 949 or SelectMonster == "Marine Captain") then
            Ms = "Marine Captain"
            NameQuest = "MarineQuest3"
            QuestLv = 2
            NameMon = "Marine Captain"
            CFrameQ = CFrame.new(- 2440.9934082031, 73.04190826416, - 3217.7082519531)
            CFrameMon = CFrame.new(- 2335.2026367188, 79.786659240723, - 3245.8674316406)
        elseif v7 == 950 or (v7 <= 974 or SelectMonster == "Zombie") then
            Ms = "Zombie"
            NameQuest = "ZombieQuest"
            QuestLv = 1
            NameMon = "Zombie"
            CFrameQ = CFrame.new(- 5494.3413085938, 48.505931854248, - 794.59094238281)
            CFrameMon = CFrame.new(- 5536.4970703125, 101.08577728271, - 835.59075927734)
        elseif v7 == 975 or (v7 <= 999 or SelectMonster == "Vampire") then
            Ms = "Vampire"
            NameQuest = "ZombieQuest"
            QuestLv = 2
            NameMon = "Vampire"
            CFrameQ = CFrame.new(- 5494.3413085938, 48.505931854248, - 794.59094238281)
            CFrameMon = CFrame.new(- 5806.1098632813, 16.722528457642, - 1164.4384765625)
        elseif v7 == 1000 or (v7 <= 1049 or SelectMonster == "Snow Trooper") then
            Ms = "Snow Trooper"
            NameQuest = "SnowMountainQuest"
            QuestLv = 1
            NameMon = "Snow Trooper"
            CFrameQ = CFrame.new(607.05963134766, 401.44781494141, - 5370.5546875)
            CFrameMon = CFrame.new(535.21051025391, 432.74209594727, - 5484.9165039063)
        elseif v7 == 1050 or (v7 <= 1099 or SelectMonster == "Winter Warrior") then
            Ms = "Winter Warrior"
            NameQuest = "SnowMountainQuest"
            QuestLv = 2
            NameMon = "Winter Warrior"
            CFrameQ = CFrame.new(607.05963134766, 401.44781494141, - 5370.5546875)
            CFrameMon = CFrame.new(1234.4449462891, 456.95419311523, - 5174.130859375)
        elseif v7 == 1100 or (v7 <= 1124 or SelectMonster == "Lab Subordinate") then
            Ms = "Lab Subordinate"
            NameQuest = "IceSideQuest"
            QuestLv = 1
            NameMon = "Lab Subordinate"
            CFrameQ = CFrame.new(- 6061.841796875, 15.926671981812, - 4902.0385742188)
            CFrameMon = CFrame.new(- 5720.5576171875, 63.309471130371, - 4784.6103515625)
        elseif v7 == 1125 or (v7 <= 1174 or SelectMonster == "Horned Warrior") then
            Ms = "Horned Warrior"
            NameQuest = "IceSideQuest"
            QuestLv = 2
            NameMon = "Horned Warrior"
            CFrameQ = CFrame.new(- 6061.841796875, 15.926671981812, - 4902.0385742188)
            CFrameMon = CFrame.new(- 6292.751953125, 91.181983947754, - 5502.6499023438)
        elseif v7 == 1175 or (v7 <= 1199 or SelectMonster == "Magma Ninja") then
            Ms = "Magma Ninja"
            NameQuest = "FireSideQuest"
            QuestLv = 1
            NameMon = "Magma Ninja"
            CFrameQ = CFrame.new(- 5429.0473632813, 15.977565765381, - 5297.9614257813)
            CFrameMon = CFrame.new(- 5461.8388671875, 130.36347961426, - 5836.4702148438)
        elseif v7 == 1200 or (v7 <= 1249 or SelectMonster == "Lava Pirate") then
            Ms = "Lava Pirate"
            NameQuest = "FireSideQuest"
            QuestLv = 2
            NameMon = "Lava Pirate"
            CFrameQ = CFrame.new(- 5429.0473632813, 15.977565765381, - 5297.9614257813)
            CFrameMon = CFrame.new(- 5251.1889648438, 55.164535522461, - 4774.4096679688)
        elseif v7 == 1250 or (v7 <= 1274 or SelectMonster == "Ship Deckhand") then
            Ms = "Ship Deckhand"
            NameQuest = "ShipQuest1"
            QuestLv = 1
            NameMon = "Ship Deckhand"
            CFrameQ = CFrame.new(1040.2927246094, 125.08293151855, 32911.0390625)
            CFrameMon = CFrame.new(921.12365722656, 125.9839553833, 33088.328125)
            if _G.AutoLevel and (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif v7 == 1275 or (v7 <= 1299 or SelectMonster == "Ship Engineer") then
            Ms = "Ship Engineer"
            NameQuest = "ShipQuest1"
            QuestLv = 2
            NameMon = "Ship Engineer"
            CFrameQ = CFrame.new(1040.2927246094, 125.08293151855, 32911.0390625)
            CFrameMon = CFrame.new(886.28179931641, 40.47790145874, 32800.83203125)
            if _G.AutoLevel and (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif v7 == 1300 or (v7 <= 1324 or SelectMonster == "Ship Steward") then
            Ms = "Ship Steward"
            NameQuest = "ShipQuest2"
            QuestLv = 1
            NameMon = "Ship Steward"
            CFrameQ = CFrame.new(971.42065429688, 125.08293151855, 33245.54296875)
            CFrameMon = CFrame.new(943.85504150391, 129.58183288574, 33444.3671875)
            if _G.AutoLevel and (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif v7 == 1325 or (v7 <= 1349 or SelectMonster == "Ship Officer") then
            Ms = "Ship Officer"
            NameQuest = "ShipQuest2"
            QuestLv = 2
            NameMon = "Ship Officer"
            CFrameQ = CFrame.new(971.42065429688, 125.08293151855, 33245.54296875)
            CFrameMon = CFrame.new(955.38458251953, 181.08335876465, 33331.890625)
            if _G.AutoLevel and (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif v7 == 1350 or (v7 <= 1374 or SelectMonster == "Arctic Warrior") then
            Ms = "Arctic Warrior"
            NameQuest = "FrostQuest"
            QuestLv = 1
            NameMon = "Arctic Warrior"
            CFrameQ = CFrame.new(5668.1372070313, 28.202531814575, - 6484.6005859375)
            CFrameMon = CFrame.new(5935.4541015625, 77.26016998291, - 6472.7568359375)
            if _G.AutoLevel and (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 6508.5581054688, 89.034996032715, - 132.83953857422))
            end
        elseif v7 == 1375 or (v7 <= 1424 or SelectMonster == "Snow Lurker") then
            Ms = "Snow Lurker"
            NameQuest = "FrostQuest"
            QuestLv = 2
            NameMon = "Snow Lurker"
            CFrameQ = CFrame.new(5668.1372070313, 28.202531814575, - 6484.6005859375)
            CFrameMon = CFrame.new(5628.482421875, 57.574996948242, - 6618.3481445313)
        elseif v7 == 1425 or (v7 <= 1449 or SelectMonster == "Sea Soldier") then
            Ms = "Sea Soldier"
            NameQuest = "ForgottenQuest"
            QuestLv = 1
            NameMon = "Sea Soldier"
            CFrameQ = CFrame.new(- 3054.5827636719, 236.87213134766, - 10147.790039063)
            CFrameMon = CFrame.new(- 3185.0153808594, 58.789089202881, - 9663.6064453125)
        elseif v7 >= 1450 or SelectMonster == "Water Fighter" then
            Ms = "Water Fighter"
            NameQuest = "ForgottenQuest"
            QuestLv = 2
            NameMon = "Water Fighter"
            CFrameQ = CFrame.new(- 3054.5827636719, 236.87213134766, - 10147.790039063)
            CFrameMon = CFrame.new(- 3262.9301757813, 298.69036865234, - 10552.529296875)
        end
    end
    if Sea3 then
        if v7 == 1500 or (v7 <= 1524 or SelectMonster == "Pirate Millionaire") then
            Ms = "Pirate Millionaire"
            NameQuest = "PiratePortQuest"
            QuestLv = 1
            NameMon = "Pirate Millionaire"
            CFrameQ = CFrame.new(- 450.1046447753906, 107.68145751953125, 5950.72607421875)
            CFrameMon = CFrame.new(- 193.99227905273438, 56.12502670288086, 5755.7880859375)
        elseif v7 == 1525 or (v7 <= 1574 or SelectMonster == "Pistol Billionaire") then
            Ms = "Pistol Billionaire"
            NameQuest = "PiratePortQuest"
            QuestLv = 2
            NameMon = "Pistol Billionaire"
            CFrameQ = CFrame.new(- 450.1046447753906, 107.68145751953125, 5950.72607421875)
            CFrameMon = CFrame.new(- 188.14462280273438, 84.49613189697266, 6337.0419921875)
        elseif v7 == 1575 or (v7 <= 1599 or SelectMonster == "Dragon Crew Warrior") then
            Ms = "Dragon Crew Warrior"
            NameQuest = "DragonCrewQuest"
            QuestLv = 1
            NameMon = "Dragon Crew Warrior"
            CFrameQ = CFrame.new(6735.11083984375, 126.99046325683594, - 711.0979614257812)
            CFrameMon = CFrame.new(6615.2333984375, 50.847679138183594, - 978.93408203125)
        elseif v7 == 1600 or (v7 <= 1624 or SelectMonster == "Dragon Crew Archer") then
            Ms = "Dragon Crew Archer"
            NameQuest = "DragonCrewQuest"
            QuestLv = 2
            NameMon = "Dragon Crew Archer"
            CFrameQ = CFrame.new(6735.11083984375, 126.99046325683594, - 711.0979614257812)
            CFrameMon = CFrame.new(6818.58935546875, 483.718994140625, 512.726806640625)
        elseif v7 == 1625 or (v7 <= 1649 or SelectMonster == "Hydra Enforcer") then
            Ms = "Hydra Enforcer"
            NameQuest = "VenomCrewQuest"
            QuestLv = 1
            NameMon = "Hydra Enforcer"
            CFrameQ = CFrame.new(5446.8793945313, 601.62945556641, 749.45672607422)
            CFrameMon = CFrame.new(4547.115234375, 1001.60205078125, 334.1954650878906)
        elseif v7 == 1650 or (v7 <= 1699 or SelectMonster == "Venomous Assailant") then
            Ms = "Venomous Assailant"
            NameQuest = "VenomCrewQuest"
            QuestLv = 2
            NameMon = "Venomous Assailant"
            CFrameQ = CFrame.new(5446.8793945313, 601.62945556641, 749.45672607422)
            CFrameMon = CFrame.new(4637.88525390625, 1077.85595703125, 882.4183959960938)
        elseif v7 == 1700 or (v7 <= 1724 or SelectMonster == "Marine Commodore") then
            Ms = "Marine Commodore"
            NameQuest = "MarineTreeIsland"
            QuestLv = 1
            NameMon = "Marine Commodore"
            CFrameQ = CFrame.new(2179.98828125, 28.731239318848, - 6740.0551757813)
            CFrameMon = CFrame.new(2198.0063476563, 128.71075439453, - 7109.5043945313)
        elseif v7 == 1725 or (v7 <= 1774 or SelectMonster == "Marine Rear Admiral") then
            Ms = "Marine Rear Admiral"
            NameQuest = "MarineTreeIsland"
            QuestLv = 2
            NameMon = "Marine Rear Admiral"
            CFrameQ = CFrame.new(2179.98828125, 28.731239318848, - 6740.0551757813)
            CFrameMon = CFrame.new(3294.3142089844, 385.41125488281, - 7048.6342773438)
        elseif v7 == 1775 or (v7 <= 1799 or SelectMonster == "Fishman Raider") then
            Ms = "Fishman Raider"
            NameQuest = "DeepForestIsland3"
            QuestLv = 1
            NameMon = "Fishman Raider"
            CFrameQ = CFrame.new(- 10582.759765625, 331.78845214844, - 8757.666015625)
            CFrameMon = CFrame.new(- 10553.268554688, 521.38439941406, - 8176.9458007813)
        elseif v7 == 1800 or (v7 <= 1824 or SelectMonster == "Fishman Captain") then
            Ms = "Fishman Captain"
            NameQuest = "DeepForestIsland3"
            QuestLv = 2
            NameMon = "Fishman Captain"
            CFrameQ = CFrame.new(- 10583.099609375, 331.78845214844, - 8759.4638671875)
            CFrameMon = CFrame.new(- 10789.401367188, 427.18637084961, - 9131.4423828125)
        elseif v7 == 1825 or (v7 <= 1849 or SelectMonster == "Forest Pirate") then
            Ms = "Forest Pirate"
            NameQuest = "DeepForestIsland"
            QuestLv = 1
            NameMon = "Forest Pirate"
            CFrameQ = CFrame.new(- 13232.662109375, 332.40396118164, - 7626.4819335938)
            CFrameMon = CFrame.new(- 13489.397460938, 400.30349731445, - 7770.251953125)
        elseif v7 == 1850 or (v7 <= 1899 or SelectMonster == "Mythological Pirate") then
            Ms = "Mythological Pirate"
            NameQuest = "DeepForestIsland"
            QuestLv = 2
            NameMon = "Mythological Pirate"
            CFrameQ = CFrame.new(- 13232.662109375, 332.40396118164, - 7626.4819335938)
            CFrameMon = CFrame.new(- 13508.616210938, 582.46228027344, - 6985.3037109375)
        elseif v7 == 1900 or (v7 <= 1924 or SelectMonster == "Jungle Pirate") then
            Ms = "Jungle Pirate"
            NameQuest = "DeepForestIsland2"
            QuestLv = 1
            NameMon = "Jungle Pirate"
            CFrameQ = CFrame.new(- 12682.096679688, 390.88653564453, - 9902.1240234375)
            CFrameMon = CFrame.new(- 12267.103515625, 459.75262451172, - 10277.200195313)
        elseif v7 == 1925 or (v7 <= 1974 or SelectMonster == "Musketeer Pirate") then
            Ms = "Musketeer Pirate"
            NameQuest = "DeepForestIsland2"
            QuestLv = 2
            NameMon = "Musketeer Pirate"
            CFrameQ = CFrame.new(- 12682.096679688, 390.88653564453, - 9902.1240234375)
            CFrameMon = CFrame.new(- 13291.5078125, 520.47338867188, - 9904.638671875)
        elseif v7 == 1975 or (v7 <= 1999 or SelectMonster == "Reborn Skeleton") then
            Ms = "Reborn Skeleton"
            NameQuest = "HauntedQuest1"
            QuestLv = 1
            NameMon = "Reborn Skeleton"
            CFrameQ = CFrame.new(- 9480.80762, 142.130661, 5566.37305, - 0.00655503059, 4.52954225e-8, - 0.999978542, 2.04920472e-8, 1, 4.51620679e-8, 0.999978542, - 2.01955679e-8, - 0.00655503059)
            CFrameMon = CFrame.new(- 8761.77148, 183.431747, 6168.33301, 0.978073597, - 0.000013950732, - 0.208259016, - 1.08073925e-6, 1, - 0.0000720630269, 0.208259016, 0.0000707080399, 0.978073597)
        elseif v7 == 2000 or (v7 <= 2024 or SelectMonster == "Living Zombie") then
            Ms = "Living Zombie"
            NameQuest = "HauntedQuest1"
            QuestLv = 2
            NameMon = "Living Zombie"
            CFrameQ = CFrame.new(- 9480.80762, 142.130661, 5566.37305, - 0.00655503059, 4.52954225e-8, - 0.999978542, 2.04920472e-8, 1, 4.51620679e-8, 0.999978542, - 2.01955679e-8, - 0.00655503059)
            CFrameMon = CFrame.new(- 10103.7529, 238.565979, 6179.75977, 0.999474227, 2.77547141e-8, 0.0324240364, - 2.58006327e-8, 1, - 6.06848474e-8, - 0.0324240364, 5.98163865e-8, 0.999474227)
        elseif v7 == 2025 or (v7 <= 2049 or SelectMonster == "Demonic Soul") then
            Ms = "Demonic Soul"
            NameQuest = "HauntedQuest2"
            QuestLv = 1
            NameMon = "Demonic Soul"
            CFrameQ = CFrame.new(- 9516.9931640625, 178.00651550293, 6078.4653320313)
            CFrameMon = CFrame.new(- 9712.03125, 204.69589233398, 6193.322265625)
        elseif v7 == 2050 or (v7 <= 2074 or SelectMonster == "Posessed Mummy") then
            Ms = "Posessed Mummy"
            NameQuest = "HauntedQuest2"
            QuestLv = 2
            NameMon = "Posessed Mummy"
            CFrameQ = CFrame.new(- 9516.9931640625, 178.00651550293, 6078.4653320313)
            CFrameMon = CFrame.new(- 9545.7763671875, 69.619895935059, 6339.5615234375)
        elseif v7 == 2075 or (v7 <= 2099 or SelectMonster == "Peanut Scout") then
            Ms = "Peanut Scout"
            NameQuest = "NutsIslandQuest"
            QuestLv = 1
            NameMon = "Peanut Scout"
            CFrameQ = CFrame.new(- 2105.53198, 37.2495995, - 10195.5088, - 0.766061664, 0, - 0.642767608, 0, 1, 0, 0.642767608, 0, - 0.766061664)
            CFrameMon = CFrame.new(- 2150.587890625, 122.49767303467, - 10358.994140625)
        elseif v7 == 2100 or (v7 <= 2124 or SelectMonster == "Peanut President") then
            Ms = "Peanut President"
            NameQuest = "NutsIslandQuest"
            QuestLv = 2
            NameMon = "Peanut President"
            CFrameQ = CFrame.new(- 2105.53198, 37.2495995, - 10195.5088, - 0.766061664, 0, - 0.642767608, 0, 1, 0, 0.642767608, 0, - 0.766061664)
            CFrameMon = CFrame.new(- 2150.587890625, 122.49767303467, - 10358.994140625)
        elseif v7 == 2125 or (v7 <= 2149 or SelectMonster == "Ice Cream Chef") then
            Ms = "Ice Cream Chef"
            NameQuest = "IceCreamIslandQuest"
            QuestLv = 1
            NameMon = "Ice Cream Chef"
            CFrameQ = CFrame.new(- 819.376709, 64.9259796, - 10967.2832, - 0.766061664, 0, 0.642767608, 0, 1, 0, - 0.642767608, 0, - 0.766061664)
            CFrameMon = CFrame.new(- 789.941528, 209.382889, - 11009.9805, - 0.0703101531, 0, - 0.997525156, 0, 1.00000012, 0, 0.997525275, 0, - 0.0703101456)
        elseif v7 == 2150 or (v7 <= 2199 or SelectMonster == "Ice Cream Commander") then
            Ms = "Ice Cream Commander"
            NameQuest = "IceCreamIslandQuest"
            QuestLv = 2
            NameMon = "Ice Cream Commander"
            CFrameQ = CFrame.new(- 819.376709, 64.9259796, - 10967.2832, - 0.766061664, 0, 0.642767608, 0, 1, 0, - 0.642767608, 0, - 0.766061664)
            CFrameMon = CFrame.new(- 789.941528, 209.382889, - 11009.9805, - 0.0703101531, 0, - 0.997525156, 0, 1.00000012, 0, 0.997525275, 0, - 0.0703101456)
        elseif v7 == 2200 or (v7 <= 2224 or SelectMonster == "Cookie Crafter") then
            Ms = "Cookie Crafter"
            NameQuest = "CakeQuest1"
            QuestLv = 1
            NameMon = "Cookie Crafter"
            CFrameQ = CFrame.new(- 2022.29858, 36.9275894, - 12030.9766, - 0.961273909, 0, - 0.275594592, 0, 1, 0, 0.275594592, 0, - 0.961273909)
            CFrameMon = CFrame.new(- 2321.71216, 36.699482, - 12216.7871, - 0.780074954, 0, 0.625686109, 0, 1, 0, - 0.625686109, 0, - 0.780074954)
        elseif v7 == 2225 or (v7 <= 2249 or SelectMonster == "Cake Guard") then
            Ms = "Cake Guard"
            NameQuest = "CakeQuest1"
            QuestLv = 2
            NameMon = "Cake Guard"
            CFrameQ = CFrame.new(- 2022.29858, 36.9275894, - 12030.9766, - 0.961273909, 0, - 0.275594592, 0, 1, 0, 0.275594592, 0, - 0.961273909)
            CFrameMon = CFrame.new(- 1418.11011, 36.6718941, - 12255.7324, 0.0677844882, 0, 0.997700036, 0, 1, 0, - 0.997700036, 0, 0.0677844882)
        elseif v7 == 2250 or (v7 <= 2274 or SelectMonster == "Baking Staff") then
            Ms = "Baking Staff"
            NameQuest = "CakeQuest2"
            QuestLv = 1
            NameMon = "Baking Staff"
            CFrameQ = CFrame.new(- 1928.31763, 37.7296638, - 12840.626, 0.951068401, 0, - 0.308980465, 0, 1, 0, 0.308980465, 0, 0.951068401)
            CFrameMon = CFrame.new(- 1980.43848, 36.6716766, - 12983.8418, - 0.254443765, 0, - 0.967087567, 0, 1, 0, 0.967087567, 0, - 0.254443765)
        elseif v7 == 2275 or (v7 <= 2299 or SelectMonster == "Head Baker") then
            Ms = "Head Baker"
            NameQuest = "CakeQuest2"
            QuestLv = 2
            NameMon = "Head Baker"
            CFrameQ = CFrame.new(- 1928.31763, 37.7296638, - 12840.626, 0.951068401, 0, - 0.308980465, 0, 1, 0, 0.308980465, 0, 0.951068401)
            CFrameMon = CFrame.new(- 2251.5791, 52.2714615, - 13033.3965, - 0.991971016, 0, - 0.126466095, 0, 1, 0, 0.126466095, 0, - 0.991971016)
        elseif v7 == 2300 or (v7 <= 2324 or SelectMonster == "Cocoa Warrior") then
            Ms = "Cocoa Warrior"
            NameQuest = "ChocQuest1"
            QuestLv = 1
            NameMon = "Cocoa Warrior"
            CFrameQ = CFrame.new(231.75, 23.9003029, - 12200.292, - 1, 0, 0, 0, 1, 0, 0, 0, - 1)
            CFrameMon = CFrame.new(167.978516, 26.2254658, - 12238.874, - 0.939700961, 0, 0.341998369, 0, 1, 0, - 0.341998369, 0, - 0.939700961)
        elseif v7 == 2325 or (v7 <= 2349 or SelectMonster == "Chocolate Bar Battler") then
            Ms = "Chocolate Bar Battler"
            NameQuest = "ChocQuest1"
            QuestLv = 2
            NameMon = "Chocolate Bar Battler"
            CFrameQ = CFrame.new(231.75, 23.9003029, - 12200.292, - 1, 0, 0, 0, 1, 0, 0, 0, - 1)
            CFrameMon = CFrame.new(701.312073, 25.5824986, - 12708.2148, - 0.342042685, 0, - 0.939684391, 0, 1, 0, 0.939684391, 0, - 0.342042685)
        elseif v7 == 2350 or (v7 <= 2374 or SelectMonster == "Sweet Thief") then
            Ms = "Sweet Thief"
            NameQuest = "ChocQuest2"
            QuestLv = 1
            NameMon = "Sweet Thief"
            CFrameQ = CFrame.new(151.198242, 23.8907146, - 12774.6172, 0.422592998, 0, 0.906319618, 0, 1, 0, - 0.906319618, 0, 0.422592998)
            CFrameMon = CFrame.new(- 140.258301, 25.5824986, - 12652.3115, 0.173624337, 0, - 0.984811902, 0, 1, 0, 0.984811902, 0, 0.173624337)
        elseif v7 == 2375 or (v7 <= 2400 or SelectMonster == "Candy Rebel") then
            Ms = "Candy Rebel"
            NameQuest = "ChocQuest2"
            QuestLv = 2
            NameMon = "Candy Rebel"
            CFrameQ = CFrame.new(151.198242, 23.8907146, - 12774.6172, 0.422592998, 0, 0.906319618, 0, 1, 0, - 0.906319618, 0, 0.422592998)
            CFrameMon = CFrame.new(47.9231453, 25.5824986, - 13029.2402, - 0.819156051, 0, - 0.573571265, 0, 1, 0, 0.573571265, 0, - 0.819156051)
        elseif v7 == 2400 or (v7 <= 2424 or SelectMonster == "Candy Pirate") then
            Ms = "Candy Pirate"
            NameQuest = "CandyQuest1"
            QuestLv = 1
            NameMon = "Candy Pirate"
            CFrameQ = CFrame.new(- 1149.328, 13.5759039, - 14445.6143, - 0.156446099, 0, - 0.987686574, 0, 1, 0, 0.987686574, 0, - 0.156446099)
            CFrameMon = CFrame.new(- 1437.56348, 17.1481285, - 14385.6934, 0.173624337, 0, - 0.984811902, 0, 1, 0, 0.984811902, 0, 0.173624337)
        elseif v7 == 2425 or (v7 <= 2449 or SelectMonster == "Snow Demon") then
            Ms = "Snow Demon"
            NameQuest = "CandyQuest1"
            QuestLv = 2
            NameMon = "Snow Demon"
            CFrameQ = CFrame.new(- 1149.328, 13.5759039, - 14445.6143, - 0.156446099, 0, - 0.987686574, 0, 1, 0, 0.987686574, 0, - 0.156446099)
            CFrameMon = CFrame.new(- 916.222656, 17.1481285, - 14638.8125, 0.866007268, 0, 0.500031412, 0, 1, 0, - 0.500031412, 0, 0.866007268)
        elseif v7 == 2450 or (v7 <= 2474 or SelectMonster == "Isle Outlaw") then
            Ms = "Isle Outlaw"
            NameQuest = "TikiQuest1"
            QuestLv = 1
            NameMon = "Isle Outlaw"
            CFrameQ = CFrame.new(- 16549.890625, 55.68635559082031, - 179.91360473632812)
            CFrameMon = CFrame.new(- 16162.8193359375, 11.6863374710083, - 96.45481872558594)
        elseif v7 == 2475 or (v7 <= 2499 or SelectMonster == "Island Boy") then
            Ms = "Island Boy"
            NameQuest = "TikiQuest1"
            QuestLv = 2
            NameMon = "Island Boy"
            CFrameQ = CFrame.new(- 16549.890625, 55.68635559082031, - 179.91360473632812)
            CFrameMon = CFrame.new(- 16357.3125, 20.632822036743164, 1005.64892578125)
        elseif v7 == 2500 or (v7 <= 2524 or SelectMonster == "Sun-kissed Warrior") then
            Ms = "Sun-kissed Warrior"
            NameQuest = "TikiQuest2"
            QuestLv = 1
            NameMon = "Sun-kissed Warrior"
            CFrameQ = CFrame.new(- 16541.021484375, 54.77081298828125, 1051.461181640625)
            CFrameMon = CFrame.new(- 16357.3125, 20.632822036743164, 1005.64892578125)
        elseif v7 == 2525 or (v7 <= 2549 or SelectMonster == "Isle Champion") then
            Ms = "Isle Champion"
            NameQuest = "TikiQuest2"
            QuestLv = 2
            NameMon = "Isle Champion"
            CFrameQ = CFrame.new(- 16541.021484375, 54.77081298828125, 1051.461181640625)
            CFrameMon = CFrame.new(- 16848.94140625, 21.68633460998535, 1041.4490966796875)
        elseif v7 == 2550 or (v7 <= 2574 or SelectMonster == "Serpent Hunter") then
            Ms = "Serpent Hunter"
            NameQuest = "TikiQuest3"
            QuestLv = 1
            NameMon = "Serpent Hunter"
            CFrameQ = CFrame.new(- 16665.19140625, 104.59640502929688, 1579.6943359375)
            CFrameMon = CFrame.new(- 16621.4140625, 121.40631103515625, 1290.6881103515625)
        elseif v7 >= 2575 or SelectMonster == "Skull Slayer" then
            Ms = "Skull Slayer"
            NameQuest = "TikiQuest3"
            QuestLv = 2
            NameMon = "Skull Slayer"
            CFrameQ = CFrame.new(- 16665.19140625, 104.59640502929688, 1579.6943359375)
            CFrameMon = CFrame.new(- 16811.5703125, 84.625244140625, 1542.235107421875)
        end
    end
end
if Sea1 then
    tableMon = {
        "Bandit",
        "Monkey",
        "Gorilla",
        "Pirate",
        "Brute",
        "Desert Bandit",
        "Desert Officer",
        "Snow Bandit",
        "Snowman",
        "Chief Petty Officer",
        "Sky Bandit",
        "Dark Master",
        "Prisoner",
        "Dangerous Prisoner",
        "Toga Warrior",
        "Gladiator",
        "Military Soldier",
        "Military Spy",
        "Fishman Warrior",
        "Fishman Commando",
        "God\'s Guard",
        "Shanda",
        "Royal Squad",
        "Royal Soldier",
        "Galley Pirate",
        "Galley Captain"
    }
elseif Sea2 then
    tableMon = {
        "Raider",
        "Mercenary",
        "Swan Pirate",
        "Factory Staff",
        "Marine Lieutenant",
        "Marine Captain",
        "Zombie",
        "Vampire",
        "Snow Trooper",
        "Winter Warrior",
        "Lab Subordinate",
        "Horned Warrior",
        "Magma Ninja",
        "Lava Pirate",
        "Ship Deckhand",
        "Ship Engineer",
        "Ship Steward",
        "Ship Officer",
        "Arctic Warrior",
        "Snow Lurker",
        "Sea Soldier",
        "Water Fighter"
    }
elseif Sea3 then
    tableMon = {
        "Pirate Millionaire",
        "Dragon Crew Warrior",
        "Dragon Crew Archer",
        "Hydra Enforcer",
        "Venomous Assailant",
        "Marine Commodore",
        "Marine Rear Admiral",
        "Fishman Raider",
        "Fishman Captain",
        "Forest Pirate",
        "Mythological Pirate",
        "Jungle Pirate",
        "Musketeer Pirate",
        "Reborn Skeleton",
        "Living Zombie",
        "Demonic Soul",
        "Posessed Mummy",
        "Peanut Scout",
        "Peanut President",
        "Ice Cream Chef",
        "Ice Cream Commander",
        "Cookie Crafter",
        "Cake Guard",
        "Baking Staff",
        "Head Baker",
        "Cocoa Warrior",
        "Chocolate Bar Battler",
        "Sweet Thief",
        "Candy Rebel",
        "Candy Pirate",
        "Snow Demon",
        "Isle Outlaw",
        "Island Boy",
        "Sun-kissed Warrior",
        "Isle Champion",
        "Serpent Hunter",
        "Skull Slayer"
    }
end
if Sea1 then
    AreaList = {
        "Jungle",
        "Buggy",
        "Desert",
        "Snow",
        "Marine",
        "Sky",
        "Prison",
        "Colosseum",
        "Magma",
        "Fishman",
        "Sky Island",
        "Fountain"
    }
elseif Sea2 then
    AreaList = {
        "Area 1",
        "Area 2",
        "Zombie",
        "Marine",
        "Snow Mountain",
        "Ice fire",
        "Ship",
        "Frost",
        "Forgotten"
    }
elseif Sea3 then
    AreaList = {
        "Pirate Port",
        "Amazon",
        "Marine Tree",
        "Deep Forest",
        "Haunted Castle",
        "Nut Island",
        "Ice Cream Island",
        "Cake Island",
        "Choco Island",
        "Candy Island",
        "Tiki Outpost"
    }
end
function CheckBossQuest()
    if Sea1 then
        if SelectBoss ~= "The Gorilla King" then
            if SelectBoss ~= "Bobby" then
                if SelectBoss ~= "The Saw" then
                    if SelectBoss ~= "Yeti" then
                        if SelectBoss ~= "Mob Leader" then
                            if SelectBoss ~= "Vice Admiral" then
                                if SelectBoss ~= "Saber Expert" then
                                    if SelectBoss ~= "Warden" then
                                        if SelectBoss ~= "Chief Warden" then
                                            if SelectBoss ~= "Swan" then
                                                if SelectBoss ~= "Magma Admiral" then
                                                    if SelectBoss ~= "Fishman Lord" then
                                                        if SelectBoss ~= "Wysper" then
                                                            if SelectBoss ~= "Thunder God" then
                                                                if SelectBoss ~= "Cyborg" then
                                                                    if SelectBoss ~= "Ice Admiral" then
                                                                        if SelectBoss == "Greybeard" then
                                                                            BossMon = "Greybeard"
                                                                            NameBoss = "Greybeard"
                                                                            CFrameBoss = CFrame.new(- 5081.3452148438, 85.221641540527, 4257.3588867188)
                                                                        end
                                                                    else
                                                                        BossMon = "Ice Admiral"
                                                                        NameBoss = "Ice Admiral"
                                                                        CFrameBoss = CFrame.new(1266.08948, 26.1757946, - 1399.57678, - 0.573599219, 0, - 0.81913656, 0, 1, 0, 0.81913656, 0, - 0.573599219)
                                                                    end
                                                                else
                                                                    BossMon = "Cyborg"
                                                                    NameBoss = "Cyborg"
                                                                    NameQuestBoss = "FountainQuest"
                                                                    QuestLvBoss = 3
                                                                    RewardBoss = "Reward:\n$20,000\n7,500,000 Exp."
                                                                    CFrameQBoss = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875)
                                                                    CFrameBoss = CFrame.new(6094.0249023438, 73.770050048828, 3825.7348632813)
                                                                end
                                                            else
                                                                BossMon = "Thunder God"
                                                                NameBoss = "Thunder God"
                                                                NameQuestBoss = "SkyExp2Quest"
                                                                QuestLvBoss = 3
                                                                RewardBoss = "Reward:\n$20,000\n5,800,000 Exp."
                                                                CFrameQBoss = CFrame.new(- 7903.3828125, 5635.9897460938, - 1410.923828125)
                                                                CFrameBoss = CFrame.new(- 7994.984375, 5761.025390625, - 2088.6479492188)
                                                            end
                                                        else
                                                            BossMon = "Wysper"
                                                            NameBoss = "Wysper"
                                                            NameQuestBoss = "SkyExp1Quest"
                                                            QuestLvBoss = 3
                                                            RewardBoss = "Reward:\n$15,000\n4,800,000 Exp."
                                                            CFrameQBoss = CFrame.new(- 7861.947265625, 5545.517578125, - 379.85974121094)
                                                            CFrameBoss = CFrame.new(- 7866.1333007813, 5576.4311523438, - 546.74816894531)
                                                        end
                                                    else
                                                        BossMon = "Fishman Lord"
                                                        NameBoss = "Fishman Lord"
                                                        NameQuestBoss = "FishmanQuest"
                                                        QuestLvBoss = 3
                                                        RewardBoss = "Reward:\n$15,000\n4,000,000 Exp."
                                                        CFrameQBoss = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
                                                        CFrameBoss = CFrame.new(61260.15234375, 30.950881958008, 1193.4329833984)
                                                    end
                                                else
                                                    BossMon = "Magma Admiral"
                                                    NameBoss = "Magma Admiral"
                                                    NameQuestBoss = "MagmaQuest"
                                                    QuestLvBoss = 3
                                                    RewardBoss = "Reward:\n$15,000\n2,800,000 Exp."
                                                    CFrameQBoss = CFrame.new(- 5314.6220703125, 12.262420654297, 8517.279296875)
                                                    CFrameBoss = CFrame.new(- 5765.8969726563, 82.92064666748, 8718.3046875)
                                                end
                                            else
                                                BossMon = "Swan"
                                                NameBoss = "Swan"
                                                NameQuestBoss = "ImpelQuest"
                                                QuestLvBoss = 3
                                                RewardBoss = "Reward:\n$15,000\n1,600,000 Exp."
                                                CFrameBoss = CFrame.new(5325.09619, 7.03906584, 719.570679, - 0.309060812, 0, 0.951042235, 0, 1, 0, - 0.951042235, 0, - 0.309060812)
                                                CFrameQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, - 0.731384635, 0, 0.681965172, 0, 1, 0, - 0.681965172, 0, - 0.731384635)
                                            end
                                        else
                                            BossMon = "Chief Warden"
                                            NameBoss = "Chief Warden"
                                            NameQuestBoss = "ImpelQuest"
                                            QuestLvBoss = 2
                                            RewardBoss = "Reward:\n$10,000\n1,000,000 Exp."
                                            CFrameBoss = CFrame.new(5206.92578, 0.997753382, 814.976746, 0.342041343, - 0.00062915677, 0.939684749, 0.00191645394, 0.999998152, - 0.0000280422337, - 0.939682961, 0.00181045406, 0.342041939)
                                            CFrameQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, - 0.731384635, 0, 0.681965172, 0, 1, 0, - 0.681965172, 0, - 0.731384635)
                                        end
                                    else
                                        BossMon = "Warden"
                                        NameBoss = "Warden"
                                        NameQuestBoss = "ImpelQuest"
                                        QuestLvBoss = 1
                                        RewardBoss = "Reward:\n$6,000\n850,000 Exp."
                                        CFrameBoss = CFrame.new(5278.04932, 2.15167475, 944.101929, 0.220546961, - 4.49946401e-6, 0.975376427, - 0.0000195412576, 1, 9.03162072e-6, - 0.975376427, - 0.0000210519756, 0.220546961)
                                        CFrameQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, - 0.731384635, 0, 0.681965172, 0, 1, 0, - 0.681965172, 0, - 0.731384635)
                                    end
                                else
                                    NameBoss = "Saber Expert"
                                    BossMon = "Saber Expert"
                                    CFrameBoss = CFrame.new(- 1458.89502, 29.8870335, - 50.633564)
                                end
                            else
                                BossMon = "Vice Admiral"
                                NameBoss = "Vice Admiral"
                                NameQuestBoss = "MarineQuest2"
                                QuestLvBoss = 2
                                RewardBoss = "Reward:\n$10,000\n180,000 Exp."
                                CFrameQBoss = CFrame.new(- 5036.2465820313, 28.677835464478, 4324.56640625)
                                CFrameBoss = CFrame.new(- 5006.5454101563, 88.032081604004, 4353.162109375)
                            end
                        else
                            BossMon = "Mob Leader"
                            NameBoss = "Mob Leader"
                            CFrameBoss = CFrame.new(- 2844.7307128906, 7.4180502891541, 5356.6723632813)
                        end
                    else
                        BossMon = "Yeti"
                        NameBoss = "Yeti"
                        NameQuestBoss = "SnowQuest"
                        QuestLvBoss = 3
                        RewardBoss = "Reward:\n$10,000\n180,000 Exp."
                        CFrameQBoss = CFrame.new(1386.8073730469, 87.272789001465, - 1298.3576660156)
                        CFrameBoss = CFrame.new(1218.7956542969, 138.01184082031, - 1488.0262451172)
                    end
                else
                    BossMon = "The Saw"
                    NameBoss = "The Saw"
                    CFrameBoss = CFrame.new(- 784.89715576172, 72.427383422852, 1603.5822753906)
                end
            else
                BossMon = "Bobby"
                NameBoss = "Bobby"
                NameQuestBoss = "BuggyQuest1"
                QuestLvBoss = 3
                RewardBoss = "Reward:\n$8,000\n35,000 Exp."
                CFrameQBoss = CFrame.new(- 1140.1761474609, 4.752049446106, 3827.4057617188)
                CFrameBoss = CFrame.new(- 1087.3760986328, 46.949409484863, 4040.1462402344)
            end
        else
            BossMon = "The Gorilla King"
            NameBoss = "The Gorrila King"
            NameQuestBoss = "JungleQuest"
            QuestLvBoss = 3
            RewardBoss = "Reward:\n$2,000\n7,000 Exp."
            CFrameQBoss = CFrame.new(- 1601.6553955078, 36.85213470459, 153.38809204102)
            CFrameBoss = CFrame.new(- 1088.75977, 8.13463783, - 488.559906, - 0.707134247, 0, 0.707079291, 0, 1, 0, - 0.707079291, 0, - 0.707134247)
        end
    end
    if Sea2 then
        if SelectBoss ~= "Diamond" then
            if SelectBoss ~= "Jeremy" then
                if SelectBoss ~= "Fajita" then
                    if SelectBoss ~= "Don Swan" then
                        if SelectBoss ~= "Smoke Admiral" then
                            if SelectBoss ~= "Awakened Ice Admiral" then
                                if SelectBoss ~= "Tide Keeper" then
                                    if SelectBoss ~= "Darkbeard" then
                                        if SelectBoss ~= "Cursed Captain" then
                                            if SelectBoss == "Order" then
                                                BossMon = "Order"
                                                NameBoss = "Order"
                                                CFrameBoss = CFrame.new(- 6217.2021484375, 28.047645568848, - 5053.1357421875)
                                            end
                                        else
                                            BossMon = "Cursed Captain"
                                            NameBoss = "Cursed Captain"
                                            CFrameBoss = CFrame.new(916.928589, 181.092773, 33422)
                                        end
                                    else
                                        BossMon = "Darkbeard"
                                        NameBoss = "Darkbeard"
                                        CFrameMon = CFrame.new(3677.08203125, 62.751937866211, - 3144.8332519531)
                                    end
                                else
                                    BossMon = "Tide Keeper"
                                    NameBoss = "Tide Keeper"
                                    NameQuestBoss = "ForgottenQuest"
                                    QuestLvBoss = 3
                                    RewardBoss = "Reward:\n$12,500\n38,000,000 Exp."
                                    CFrameQBoss = CFrame.new(- 3053.9814453125, 237.18954467773, - 10145.0390625)
                                    CFrameBoss = CFrame.new(- 3795.6423339844, 105.88877105713, - 11421.307617188)
                                end
                            else
                                BossMon = "Awakened Ice Admiral"
                                NameBoss = "Awakened Ice Admiral"
                                NameQuestBoss = "FrostQuest"
                                QuestLvBoss = 3
                                RewardBoss = "Reward:\n$20,000\n36,000,000 Exp."
                                CFrameQBoss = CFrame.new(5668.9780273438, 28.519989013672, - 6483.3520507813)
                                CFrameBoss = CFrame.new(6403.5439453125, 340.29766845703, - 6894.5595703125)
                            end
                        else
                            BossMon = "Smoke Admiral"
                            NameBoss = "Smoke Admiral"
                            NameQuestBoss = "IceSideQuest"
                            QuestLvBoss = 3
                            RewardBoss = "Reward:\n$20,000\n25,000,000 Exp."
                            CFrameQBoss = CFrame.new(- 5429.0473632813, 15.977565765381, - 5297.9614257813)
                            CFrameBoss = CFrame.new(- 5275.1987304688, 20.757257461548, - 5260.6669921875)
                        end
                    else
                        BossMon = "Don Swan"
                        NameBoss = "Don Swan"
                        CFrameBoss = CFrame.new(2286.2004394531, 15.177839279175, 863.8388671875)
                    end
                else
                    BossMon = "Fajita"
                    NameBoss = "Fajita"
                    NameQuestBoss = "MarineQuest3"
                    QuestLvBoss = 3
                    RewardBoss = "Reward:\n$25,000\n15,000,000 Exp."
                    CFrameQBoss = CFrame.new(- 2441.986328125, 73.359344482422, - 3217.5324707031)
                    CFrameBoss = CFrame.new(- 2172.7399902344, 103.32216644287, - 4015.025390625)
                end
            else
                BossMon = "Jeremy"
                NameBoss = "Jeremy"
                NameQuestBoss = "Area2Quest"
                QuestLvBoss = 3
                RewardBoss = "Reward:\n$25,000\n11,500,000 Exp."
                CFrameQBoss = CFrame.new(636.79943847656, 73.413787841797, 918.00415039063)
                CFrameBoss = CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109)
            end
        else
            BossMon = "Diamond"
            NameBoss = "Diamond"
            NameQuestBoss = "Area1Quest"
            QuestLvBoss = 3
            RewardBoss = "Reward:\n$25,000\n9,000,000 Exp."
            CFrameQBoss = CFrame.new(- 427.5666809082, 73.313781738281, 1835.4208984375)
            CFrameBoss = CFrame.new(- 1576.7166748047, 198.59265136719, 13.724286079407)
        end
    end
    if Sea3 then
        if SelectBoss ~= "Stone" then
            if SelectBoss ~= "Hydra Leader" then
                if SelectBoss ~= "Kilo Admiral" then
                    if SelectBoss ~= "Captain Elephant" then
                        if SelectBoss ~= "Beautiful Pirate" then
                            if SelectBoss ~= "Cake Queen" then
                                if SelectBoss ~= "Longma" then
                                    if SelectBoss ~= "Soul Reaper" then
                                        if SelectBoss == "rip_indra True Form" then
                                            BossMon = "rip_indra True Form"
                                            NameBoss = "rip_indra True Form"
                                            CFrameBoss = CFrame.new(- 5415.3920898438, 505.74133300781, - 2814.0166015625)
                                        end
                                    else
                                        BossMon = "Soul Reaper"
                                        NameBoss = "Soul Reaper"
                                        CFrameBoss = CFrame.new(- 9524.7890625, 315.80429077148, 6655.7192382813)
                                    end
                                else
                                    BossMon = "Longma"
                                    NameBoss = "Longma"
                                    CFrameBoss = CFrame.new(- 10238.875976563, 389.7912902832, - 9549.7939453125)
                                end
                            else
                                BossMon = "Cake Queen"
                                NameBoss = "Cake Queen"
                                NameQuestBoss = "IceCreamIslandQuest"
                                QuestLvBoss = 3
                                RewardBoss = "Reward:\n$30,000\n112,500,000 Exp."
                                CFrameQBoss = CFrame.new(- 819.376709, 64.9259796, - 10967.2832, - 0.766061664, 0, 0.642767608, 0, 1, 0, - 0.642767608, 0, - 0.766061664)
                                CFrameBoss = CFrame.new(- 678.648804, 381.353943, - 11114.2012, - 0.908641815, 0.00149294338, 0.41757378, 0.00837114919, 0.999857843, 0.0146408929, - 0.417492568, 0.0167988986, - 0.90852499)
                            end
                        else
                            BossMon = "Beautiful Pirate"
                            NameBoss = "Beautiful Pirate"
                            NameQuestBoss = "DeepForestIsland2"
                            QuestLvBoss = 3
                            RewardBoss = "Reward:\n$50,000\n70,000,000 Exp."
                            CFrameQBoss = CFrame.new(- 12682.096679688, 390.88653564453, - 9902.1240234375)
                            CFrameBoss = CFrame.new(5283.609375, 22.56223487854, - 110.78285217285)
                        end
                    else
                        BossMon = "Captain Elephant"
                        NameBoss = "Captain Elephant"
                        NameQuestBoss = "DeepForestIsland"
                        QuestLvBoss = 3
                        RewardBoss = "Reward:\n$40,000\n67,000,000 Exp."
                        CFrameQBoss = CFrame.new(- 13232.682617188, 332.40396118164, - 7626.01171875)
                        CFrameBoss = CFrame.new(- 13376.7578125, 433.28689575195, - 8071.392578125)
                    end
                else
                    BossMon = "Kilo Admiral"
                    NameBoss = "Kilo Admiral"
                    NameQuestBoss = "MarineTreeIsland"
                    QuestLvBoss = 3
                    RewardBoss = "Reward:\n$35,000\n56,000,000 Exp."
                    CFrameQBoss = CFrame.new(2179.3010253906, 28.731239318848, - 6739.9741210938)
                    CFrameBoss = CFrame.new(2764.2233886719, 432.46154785156, - 7144.4580078125)
                end
            else
                BossMon = "Hydra Leader"
                NameBoss = "Hydra Leader"
                NameQuestBoss = "VenomCrewQuest"
                QuestLvBoss = 3
                RewardBoss = "Reward:\n$30,000\n52,000,000 Exp."
                CFrameQBoss = CFrame.new(5445.9541015625, 601.62945556641, 751.43792724609)
                CFrameBoss = CFrame.new(5543.86328125, 668.97399902344, 199.0341796875)
            end
        else
            BossMon = "Stone"
            NameBoss = "Stone"
            NameQuestBoss = "PiratePortQuest"
            QuestLvBoss = 3
            RewardBoss = "Reward:\n$25,000\n40,000,000 Exp."
            CFrameQBoss = CFrame.new(- 289.76705932617, 43.819011688232, 5579.9384765625)
            CFrameBoss = CFrame.new(- 1027.6512451172, 92.404174804688, 6578.8530273438)
        end
    end
end
function MaterialMon()
    if SelectMaterial ~= "Radioactive Material" then
        if SelectMaterial ~= "Mystic Droplet" then
            if SelectMaterial ~= "Magma Ore" then
                if SelectMaterial ~= "Angel Wings" then
                    if SelectMaterial ~= "Leather" then
                        if SelectMaterial ~= "Scrap Metal" then
                            if SelectMaterial ~= "Fish Tail" then
                                if SelectMaterial ~= "Demonic Wisp" then
                                    if SelectMaterial ~= "Vampire Fang" then
                                        if SelectMaterial ~= "Conjured Cocoa" then
                                            if SelectMaterial ~= "Dragon Scale" then
                                                if SelectMaterial ~= "Gunpowder" then
                                                    if SelectMaterial == "Mini Tusk" then
                                                        MMon = "Mythological Pirate"
                                                        MPos = CFrame.new()
                                                        SP = "Default"
                                                    end
                                                else
                                                    MMon = "Pistol Billionaire"
                                                    MPos = CFrame.new(- 469, 74, 5904)
                                                    SP = "Default"
                                                end
                                            else
                                                MMon = "Dragon Crew Archer"
                                                MPos = CFrame.new(6827.91455078125, 609.4127197265625, 252.3538055419922)
                                                SP = "Default"
                                            end
                                        else
                                            MMon = "Chocolate Bar Battler"
                                            MPos = CFrame.new(620.6344604492188, 78.93644714355469, - 12581.369140625)
                                            SP = "Default"
                                        end
                                    else
                                        MMon = "Vampire"
                                        MPos = CFrame.new(- 6033, 7, - 1317)
                                        SP = "Default"
                                    end
                                else
                                    MMon = "Demonic Soul"
                                    MPos = CFrame.new(- 9507, 172, 6158)
                                    SP = "Default"
                                end
                            elseif Sea3 then
                                MMon = "Fishman Raider"
                                MPos = CFrame.new(- 10993, 332, - 8940)
                                SP = "Default"
                            elseif Sea1 then
                                MMon = "Fishman Warrior"
                                MPos = CFrame.new(61123, 19, 1569)
                                SP = "Default"
                                if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(61163.8515625, 5.342342376708984, 1819.7841796875)).Magnitude >= 17000 then
                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 5.342342376708984, 1819.7841796875))
                                end
                            end
                        elseif Sea1 then
                            MMon = "Brute"
                            MPos = CFrame.new(- 1145, 15, 4350)
                            SP = "Default"
                        elseif Sea2 then
                            MMon = "Swan Pirate"
                            MPos = CFrame.new(878, 122, 1235)
                            SP = "Default"
                        elseif Sea3 then
                            MMon = "Jungle Pirate"
                            MPos = CFrame.new(- 12107, 332, - 10549)
                            SP = "Default"
                        end
                    elseif Sea1 then
                        MMon = "Brute"
                        MPos = CFrame.new(- 1145, 15, 4350)
                        SP = "Default"
                    elseif Sea2 then
                        MMon = "Marine Captain"
                        MPos = CFrame.new(- 2010.5059814453125, 73.00115966796875, - 3326.620849609375)
                        SP = "Default"
                    elseif Sea3 then
                        MMon = "Jungle Pirate"
                        MPos = CFrame.new(- 11975.78515625, 331.7734069824219, - 10620.0302734375)
                        SP = "Default"
                    end
                else
                    MMon = "God\'s Guard"
                    MPos = CFrame.new(- 4698, 845, - 1912)
                    SP = "Default"
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(- 7859.09814, 5544.19043, - 381.476196)).Magnitude >= 5000 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 7859.09814, 5544.19043, - 381.476196))
                    end
                end
            elseif Sea1 then
                MMon = "Military Spy"
                MPos = CFrame.new(- 5815, 84, 8820)
                SP = "Default"
            elseif Sea2 then
                MMon = "Magma Ninja"
                MPos = CFrame.new(- 5428, 78, - 5959)
                SP = "Default"
            end
        else
            MMon = "Water Fighter"
            MPos = CFrame.new(- 3385, 239, - 10542)
            SP = "Default"
        end
    else
        MMon = "Factory Staff"
        MPos = CFrame.new(295, 73, - 56)
        SP = "Default"
    end
end
function UpdateIslandESP()
    local v8, v9, v10 = pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren())
    while true do
        local vu11
        v10, vu11 = v8(v9, v10)
        if v10 == nil then
            break
        end
        pcall(function()
			-- upvalues: (ref) vu11
            if IslandESP then
                if vu11.Name ~= "Sea" then
                    if vu11:FindFirstChild("NameEsp") then
                        vu11.NameEsp.TextLabel.Text = vu11.Name .. "   \n" .. round((game:GetService("Players").LocalPlayer.Character.Head.Position - vu11.Position).Magnitude / 3) .. " Distance"
                    else
                        local v12 = Instance.new("BillboardGui", vu11)
                        v12.Name = "NameEsp"
                        v12.ExtentsOffset = Vector3.new(0, 1, 0)
                        v12.Size = UDim2.new(1, 200, 1, 30)
                        v12.Adornee = vu11
                        v12.AlwaysOnTop = true
                        local v13 = Instance.new("TextLabel", v12)
                        v13.Font = "GothamBold"
                        v13.FontSize = "Size14"
                        v13.TextWrapped = true
                        v13.Size = UDim2.new(1, 0, 1, 0)
                        v13.TextYAlignment = "Top"
                        v13.BackgroundTransparency = 1
                        v13.TextStrokeTransparency = 0.5
                        v13.TextColor3 = Color3.fromRGB(8, 0, 0)
                    end
                end
            elseif vu11:FindFirstChild("NameEsp") then
                vu11:FindFirstChild("NameEsp"):Destroy()
            end
        end)
    end
end
function isnil(p14)
    return p14 == nil
end
local function vu16(p15)
    return math.floor(tonumber(p15) + 0.5)
end
Number = math.random(1, 1000000)
function UpdatePlayerChams()
	-- upvalues: (ref) vu16
    local v17, v18, v19 = pairs(game:GetService("Players"):GetChildren())
    while true do
        local vu20
        v19, vu20 = v17(v18, v19)
        if v19 == nil then
            break
        end
        pcall(function()
			-- upvalues: (ref) vu20, (ref) vu16
            if not isnil(vu20.Character) then
                if ESPPlayer then
                    if isnil(vu20.Character.Head) or vu20.Character.Head:FindFirstChild("NameEsp" .. Number) then
                        vu20.Character.Head["NameEsp" .. Number].TextLabel.Text = vu20.Name .. " | " .. vu16((game:GetService("Players").LocalPlayer.Character.Head.Position - vu20.Character.Head.Position).Magnitude / 3) .. " Distance\nHealth : " .. vu16(vu20.Character.Humanoid.Health * 100 / vu20.Character.Humanoid.MaxHealth) .. "%"
                    else
                        local v21 = Instance.new("BillboardGui", vu20.Character.Head)
                        v21.Name = "NameEsp" .. Number
                        v21.ExtentsOffset = Vector3.new(0, 1, 0)
                        v21.Size = UDim2.new(1, 200, 1, 30)
                        v21.Adornee = vu20.Character.Head
                        v21.AlwaysOnTop = true
                        local v22 = Instance.new("TextLabel", v21)
                        v22.Font = Enum.Font.GothamSemibold
                        v22.FontSize = "Size10"
                        v22.TextWrapped = true
                        v22.Text = vu20.Name .. " \n" .. vu16((game:GetService("Players").LocalPlayer.Character.Head.Position - vu20.Character.Head.Position).Magnitude / 3) .. " Distance"
                        v22.Size = UDim2.new(1, 0, 1, 0)
                        v22.TextYAlignment = "Top"
                        v22.BackgroundTransparency = 1
                        v22.TextStrokeTransparency = 0.5
                        if vu20.Team ~= game.Players.LocalPlayer.Team then
                            v22.TextColor3 = Color3.new(255, 0, 0)
                        else
                            v22.TextColor3 = Color3.new(0, 0, 254)
                        end
                    end
                elseif vu20.Character.Head:FindFirstChild("NameEsp" .. Number) then
                    vu20.Character.Head:FindFirstChild("NameEsp" .. Number):Destroy()
                end
            end
        end)
    end
end
function UpdateChestChams()
	-- upvalues: (ref) vu16
    local v23, v24, v25 = pairs(game.Workspace:GetChildren())
    while true do
        local vu26
        v25, vu26 = v23(v24, v25)
        if v25 == nil then
            break
        end
        pcall(function()
			-- upvalues: (ref) vu26, (ref) vu16
            if string.find(vu26.Name, "Chest") then
                if ChestESP then
                    if string.find(vu26.Name, "Chest") then
                        if vu26:FindFirstChild("NameEsp" .. Number) then
                            vu26["NameEsp" .. Number].TextLabel.Text = vu26.Name .. "   \n" .. vu16((game:GetService("Players").LocalPlayer.Character.Head.Position - vu26.Position).Magnitude / 3) .. " Distance"
                        else
                            local v27 = Instance.new("BillboardGui", vu26)
                            v27.Name = "NameEsp" .. Number
                            v27.ExtentsOffset = Vector3.new(0, 1, 0)
                            v27.Size = UDim2.new(1, 200, 1, 30)
                            v27.Adornee = vu26
                            v27.AlwaysOnTop = true
                            local v28 = Instance.new("TextLabel", v27)
                            v28.Font = Enum.Font.GothamSemibold
                            v28.FontSize = "Size14"
                            v28.TextWrapped = true
                            v28.Size = UDim2.new(1, 0, 1, 0)
                            v28.TextYAlignment = "Top"
                            v28.BackgroundTransparency = 1
                            v28.TextStrokeTransparency = 0.5
                            if vu26.Name == "Chest1" then
                                v28.TextColor3 = Color3.fromRGB(109, 109, 109)
                                v28.Text = "Chest 1" .. " \n" .. vu16((game:GetService("Players").LocalPlayer.Character.Head.Position - vu26.Position).Magnitude / 3) .. " Distance"
                            end
                            if vu26.Name == "Chest2" then
                                v28.TextColor3 = Color3.fromRGB(173, 158, 21)
                                v28.Text = "Chest 2" .. " \n" .. vu16((game:GetService("Players").LocalPlayer.Character.Head.Position - vu26.Position).Magnitude / 3) .. " Distance"
                            end
                            if vu26.Name == "Chest3" then
                                v28.TextColor3 = Color3.fromRGB(85, 255, 255)
                                v28.Text = "Chest 3" .. " \n" .. vu16((game:GetService("Players").LocalPlayer.Character.Head.Position - vu26.Position).Magnitude / 3) .. " Distance"
                            end
                        end
                    end
                elseif vu26:FindFirstChild("NameEsp" .. Number) then
                    vu26:FindFirstChild("NameEsp" .. Number):Destroy()
                end
            end
        end)
    end
end
function UpdateDevilChams()
	-- upvalues: (ref) vu16
    local v29, v30, v31 = pairs(game.Workspace:GetChildren())
    while true do
        local vu32
        v31, vu32 = v29(v30, v31)
        if v31 == nil then
            break
        end
        pcall(function()
			-- upvalues: (ref) vu32, (ref) vu16
            if DevilFruitESP then
                if string.find(vu32.Name, "Fruit") then
                    if vu32.Handle:FindFirstChild("NameEsp" .. Number) then
                        vu32.Handle["NameEsp" .. Number].TextLabel.Text = vu32.Name .. "   \n" .. vu16((game:GetService("Players").LocalPlayer.Character.Head.Position - vu32.Handle.Position).Magnitude / 3) .. " Distance"
                    else
                        local v33 = Instance.new("BillboardGui", vu32.Handle)
                        v33.Name = "NameEsp" .. Number
                        v33.ExtentsOffset = Vector3.new(0, 1, 0)
                        v33.Size = UDim2.new(1, 200, 1, 30)
                        v33.Adornee = vu32.Handle
                        v33.AlwaysOnTop = true
                        local v34 = Instance.new("TextLabel", v33)
                        v34.Font = Enum.Font.GothamSemibold
                        v34.FontSize = "Size14"
                        v34.TextWrapped = true
                        v34.Size = UDim2.new(1, 0, 1, 0)
                        v34.TextYAlignment = "Top"
                        v34.BackgroundTransparency = 1
                        v34.TextStrokeTransparency = 0.5
                        v34.TextColor3 = Color3.fromRGB(255, 255, 255)
                        v34.Text = vu32.Name .. " \n" .. vu16((game:GetService("Players").LocalPlayer.Character.Head.Position - vu32.Handle.Position).Magnitude / 3) .. " Distance"
                    end
                end
            elseif vu32.Handle:FindFirstChild("NameEsp" .. Number) then
                vu32.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
            end
        end)
    end
end
function UpdateFlowerChams()
	-- upvalues: (ref) vu16
    local v35, v36, v37 = pairs(game.Workspace:GetChildren())
    while true do
        local vu38
        v37, vu38 = v35(v36, v37)
        if v37 == nil then
            break
        end
        pcall(function()
			-- upvalues: (ref) vu38, (ref) vu16
            if vu38.Name == "Flower2" or vu38.Name == "Flower1" then
                if FlowerESP then
                    if vu38:FindFirstChild("NameEsp" .. Number) then
                        vu38["NameEsp" .. Number].TextLabel.Text = vu38.Name .. "   \n" .. vu16((game:GetService("Players").LocalPlayer.Character.Head.Position - vu38.Position).Magnitude / 3) .. " Distance"
                    else
                        local v39 = Instance.new("BillboardGui", vu38)
                        v39.Name = "NameEsp" .. Number
                        v39.ExtentsOffset = Vector3.new(0, 1, 0)
                        v39.Size = UDim2.new(1, 200, 1, 30)
                        v39.Adornee = vu38
                        v39.AlwaysOnTop = true
                        local v40 = Instance.new("TextLabel", v39)
                        v40.Font = Enum.Font.GothamSemibold
                        v40.FontSize = "Size14"
                        v40.TextWrapped = true
                        v40.Size = UDim2.new(1, 0, 1, 0)
                        v40.TextYAlignment = "Top"
                        v40.BackgroundTransparency = 1
                        v40.TextStrokeTransparency = 0.5
                        v40.TextColor3 = Color3.fromRGB(255, 0, 0)
                        if vu38.Name == "Flower1" then
                            v40.Text = "Blue Flower" .. " \n" .. vu16((game:GetService("Players").LocalPlayer.Character.Head.Position - vu38.Position).Magnitude / 3) .. " Distance"
                            v40.TextColor3 = Color3.fromRGB(0, 0, 255)
                        end
                        if vu38.Name == "Flower2" then
                            v40.Text = "Red Flower" .. " \n" .. vu16((game:GetService("Players").LocalPlayer.Character.Head.Position - vu38.Position).Magnitude / 3) .. " Distance"
                            v40.TextColor3 = Color3.fromRGB(255, 0, 0)
                        end
                    end
                elseif vu38:FindFirstChild("NameEsp" .. Number) then
                    vu38:FindFirstChild("NameEsp" .. Number):Destroy()
                end
            end
        end)
    end
end
function UpdateRealFruitChams()
	-- upvalues: (ref) vu16
    local v41, v42, v43 = pairs(game.Workspace.AppleSpawner:GetChildren())
    while true do
        local v44
        v43, v44 = v41(v42, v43)
        if v43 == nil then
            break
        end
        if v44:IsA("Tool") then
            if RealFruitESP then
                if v44.Handle:FindFirstChild("NameEsp" .. Number) then
                    v44.Handle["NameEsp" .. Number].TextLabel.Text = v44.Name .. " " .. vu16((game:GetService("Players").LocalPlayer.Character.Head.Position - v44.Handle.Position).Magnitude / 3) .. " Distance"
                else
                    local v45 = Instance.new("BillboardGui", v44.Handle)
                    v45.Name = "NameEsp" .. Number
                    v45.ExtentsOffset = Vector3.new(0, 1, 0)
                    v45.Size = UDim2.new(1, 200, 1, 30)
                    v45.Adornee = v44.Handle
                    v45.AlwaysOnTop = true
                    local v46 = Instance.new("TextLabel", v45)
                    v46.Font = Enum.Font.GothamSemibold
                    v46.FontSize = "Size14"
                    v46.TextWrapped = true
                    v46.Size = UDim2.new(1, 0, 1, 0)
                    v46.TextYAlignment = "Top"
                    v46.BackgroundTransparency = 1
                    v46.TextStrokeTransparency = 0.5
                    v46.TextColor3 = Color3.fromRGB(255, 0, 0)
                    v46.Text = v44.Name .. " \n" .. vu16((game:GetService("Players").LocalPlayer.Character.Head.Position - v44.Handle.Position).Magnitude / 3) .. " Distance"
                end
            elseif v44.Handle:FindFirstChild("NameEsp" .. Number) then
                v44.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
            end
        end
    end
    local v47, v48, v49 = pairs(game.Workspace.PineappleSpawner:GetChildren())
    while true do
        local v50
        v49, v50 = v47(v48, v49)
        if v49 == nil then
            break
        end
        if v50:IsA("Tool") then
            if RealFruitESP then
                if v50.Handle:FindFirstChild("NameEsp" .. Number) then
                    v50.Handle["NameEsp" .. Number].TextLabel.Text = v50.Name .. " " .. vu16((game:GetService("Players").LocalPlayer.Character.Head.Position - v50.Handle.Position).Magnitude / 3) .. " Distance"
                else
                    local v51 = Instance.new("BillboardGui", v50.Handle)
                    v51.Name = "NameEsp" .. Number
                    v51.ExtentsOffset = Vector3.new(0, 1, 0)
                    v51.Size = UDim2.new(1, 200, 1, 30)
                    v51.Adornee = v50.Handle
                    v51.AlwaysOnTop = true
                    local v52 = Instance.new("TextLabel", v51)
                    v52.Font = Enum.Font.GothamSemibold
                    v52.FontSize = "Size14"
                    v52.TextWrapped = true
                    v52.Size = UDim2.new(1, 0, 1, 0)
                    v52.TextYAlignment = "Top"
                    v52.BackgroundTransparency = 1
                    v52.TextStrokeTransparency = 0.5
                    v52.TextColor3 = Color3.fromRGB(255, 174, 0)
                    v52.Text = v50.Name .. " \n" .. vu16((game:GetService("Players").LocalPlayer.Character.Head.Position - v50.Handle.Position).Magnitude / 3) .. " Distance"
                end
            elseif v50.Handle:FindFirstChild("NameEsp" .. Number) then
                v50.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
            end
        end
    end
    local v53, v54, v55 = pairs(game.Workspace.BananaSpawner:GetChildren())
    while true do
        local v56
        v55, v56 = v53(v54, v55)
        if v55 == nil then
            break
        end
        if v56:IsA("Tool") then
            if RealFruitESP then
                if v56.Handle:FindFirstChild("NameEsp" .. Number) then
                    v56.Handle["NameEsp" .. Number].TextLabel.Text = v56.Name .. " " .. vu16((game:GetService("Players").LocalPlayer.Character.Head.Position - v56.Handle.Position).Magnitude / 3) .. " Distance"
                else
                    local v57 = Instance.new("BillboardGui", v56.Handle)
                    v57.Name = "NameEsp" .. Number
                    v57.ExtentsOffset = Vector3.new(0, 1, 0)
                    v57.Size = UDim2.new(1, 200, 1, 30)
                    v57.Adornee = v56.Handle
                    v57.AlwaysOnTop = true
                    local v58 = Instance.new("TextLabel", v57)
                    v58.Font = Enum.Font.GothamSemibold
                    v58.FontSize = "Size14"
                    v58.TextWrapped = true
                    v58.Size = UDim2.new(1, 0, 1, 0)
                    v58.TextYAlignment = "Top"
                    v58.BackgroundTransparency = 1
                    v58.TextStrokeTransparency = 0.5
                    v58.TextColor3 = Color3.fromRGB(251, 255, 0)
                    v58.Text = v56.Name .. " \n" .. vu16((game:GetService("Players").LocalPlayer.Character.Head.Position - v56.Handle.Position).Magnitude / 3) .. " Distance"
                end
            elseif v56.Handle:FindFirstChild("NameEsp" .. Number) then
                v56.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
            end
        end
    end
end
function UpdateIslandESP()
	-- upvalues: (ref) vu16
    local v59, v60, v61 = pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren())
    while true do
        local vu62
        v61, vu62 = v59(v60, v61)
        if v61 == nil then
            break
        end
        pcall(function()
			-- upvalues: (ref) vu62, (ref) vu16
            if IslandESP then
                if vu62.Name ~= "Sea" then
                    if vu62:FindFirstChild("NameEsp") then
                        vu62.NameEsp.TextLabel.Text = vu62.Name .. "   \n" .. vu16((game:GetService("Players").LocalPlayer.Character.Head.Position - vu62.Position).Magnitude / 3) .. " Distance"
                    else
                        local v63 = Instance.new("BillboardGui", vu62)
                        v63.Name = "NameEsp"
                        v63.ExtentsOffset = Vector3.new(0, 1, 0)
                        v63.Size = UDim2.new(1, 200, 1, 30)
                        v63.Adornee = vu62
                        v63.AlwaysOnTop = true
                        local v64 = Instance.new("TextLabel", v63)
                        v64.Font = "GothamBold"
                        v64.FontSize = "Size14"
                        v64.TextWrapped = true
                        v64.Size = UDim2.new(1, 0, 1, 0)
                        v64.TextYAlignment = "Top"
                        v64.BackgroundTransparency = 1
                        v64.TextStrokeTransparency = 0.5
                        v64.TextColor3 = Color3.fromRGB(7, 236, 240)
                    end
                end
            elseif vu62:FindFirstChild("NameEsp") then
                vu62:FindFirstChild("NameEsp"):Destroy()
            end
        end)
    end
end
function isnil(p65)
    return p65 == nil
end
local function vu67(p66)
    return math.floor(tonumber(p66) + 0.5)
end
Number = math.random(1, 1000000)
function UpdatePlayerChams()
	-- upvalues: (ref) vu67
    local v68, v69, v70 = pairs(game:GetService("Players"):GetChildren())
    while true do
        local vu71
        v70, vu71 = v68(v69, v70)
        if v70 == nil then
            break
        end
        pcall(function()
			-- upvalues: (ref) vu71, (ref) vu67
            if not isnil(vu71.Character) then
                if ESPPlayer then
                    if isnil(vu71.Character.Head) or vu71.Character.Head:FindFirstChild("NameEsp" .. Number) then
                        vu71.Character.Head["NameEsp" .. Number].TextLabel.Text = vu71.Name .. " | " .. vu67((game:GetService("Players").LocalPlayer.Character.Head.Position - vu71.Character.Head.Position).Magnitude / 3) .. " Distance\nHealth : " .. vu67(vu71.Character.Humanoid.Health * 100 / vu71.Character.Humanoid.MaxHealth) .. "%"
                    else
                        local v72 = Instance.new("BillboardGui", vu71.Character.Head)
                        v72.Name = "NameEsp" .. Number
                        v72.ExtentsOffset = Vector3.new(0, 1, 0)
                        v72.Size = UDim2.new(1, 200, 1, 30)
                        v72.Adornee = vu71.Character.Head
                        v72.AlwaysOnTop = true
                        local v73 = Instance.new("TextLabel", v72)
                        v73.Font = Enum.Font.GothamSemibold
                        v73.FontSize = "Size14"
                        v73.TextWrapped = true
                        v73.Text = vu71.Name .. " \n" .. vu67((game:GetService("Players").LocalPlayer.Character.Head.Position - vu71.Character.Head.Position).Magnitude / 3) .. " Distance"
                        v73.Size = UDim2.new(1, 0, 1, 0)
                        v73.TextYAlignment = "Top"
                        v73.BackgroundTransparency = 1
                        v73.TextStrokeTransparency = 0.5
                        if vu71.Team ~= game.Players.LocalPlayer.Team then
                            v73.TextColor3 = Color3.new(255, 0, 0)
                        else
                            v73.TextColor3 = Color3.new(0, 255, 0)
                        end
                    end
                elseif vu71.Character.Head:FindFirstChild("NameEsp" .. Number) then
                    vu71.Character.Head:FindFirstChild("NameEsp" .. Number):Destroy()
                end
            end
        end)
    end
end
function UpdateChestChams()
	-- upvalues: (ref) vu67
    local v74, v75, v76 = pairs(game.Workspace:GetChildren())
    while true do
        local vu77
        v76, vu77 = v74(v75, v76)
        if v76 == nil then
            break
        end
        pcall(function()
			-- upvalues: (ref) vu77, (ref) vu67
            if string.find(vu77.Name, "Chest") then
                if ChestESP then
                    if string.find(vu77.Name, "Chest") then
                        if vu77:FindFirstChild("NameEsp" .. Number) then
                            vu77["NameEsp" .. Number].TextLabel.Text = vu77.Name .. "   \n" .. vu67((game:GetService("Players").LocalPlayer.Character.Head.Position - vu77.Position).Magnitude / 3) .. " Distance"
                        else
                            local v78 = Instance.new("BillboardGui", vu77)
                            v78.Name = "NameEsp" .. Number
                            v78.ExtentsOffset = Vector3.new(0, 1, 0)
                            v78.Size = UDim2.new(1, 200, 1, 30)
                            v78.Adornee = vu77
                            v78.AlwaysOnTop = true
                            local v79 = Instance.new("TextLabel", v78)
                            v79.Font = Enum.Font.GothamSemibold
                            v79.FontSize = "Size14"
                            v79.TextWrapped = true
                            v79.Size = UDim2.new(1, 0, 1, 0)
                            v79.TextYAlignment = "Top"
                            v79.BackgroundTransparency = 1
                            v79.TextStrokeTransparency = 0.5
                            if vu77.Name == "Chest1" then
                                v79.TextColor3 = Color3.fromRGB(109, 109, 109)
                                v79.Text = "Chest 1" .. " \n" .. vu67((game:GetService("Players").LocalPlayer.Character.Head.Position - vu77.Position).Magnitude / 3) .. " Distance"
                            end
                            if vu77.Name == "Chest2" then
                                v79.TextColor3 = Color3.fromRGB(173, 158, 21)
                                v79.Text = "Chest 2" .. " \n" .. vu67((game:GetService("Players").LocalPlayer.Character.Head.Position - vu77.Position).Magnitude / 3) .. " Distance"
                            end
                            if vu77.Name == "Chest3" then
                                v79.TextColor3 = Color3.fromRGB(85, 255, 255)
                                v79.Text = "Chest 3" .. " \n" .. vu67((game:GetService("Players").LocalPlayer.Character.Head.Position - vu77.Position).Magnitude / 3) .. " Distance"
                            end
                        end
                    end
                elseif vu77:FindFirstChild("NameEsp" .. Number) then
                    vu77:FindFirstChild("NameEsp" .. Number):Destroy()
                end
            end
        end)
    end
end
function UpdateDevilChams()
	-- upvalues: (ref) vu67
    local v80, v81, v82 = pairs(game.Workspace:GetChildren())
    while true do
        local vu83
        v82, vu83 = v80(v81, v82)
        if v82 == nil then
            break
        end
        pcall(function()
			-- upvalues: (ref) vu83, (ref) vu67
            if DevilFruitESP then
                if string.find(vu83.Name, "Fruit") then
                    if vu83.Handle:FindFirstChild("NameEsp" .. Number) then
                        vu83.Handle["NameEsp" .. Number].TextLabel.Text = vu83.Name .. "   \n" .. vu67((game:GetService("Players").LocalPlayer.Character.Head.Position - vu83.Handle.Position).Magnitude / 3) .. " Distance"
                    else
                        local v84 = Instance.new("BillboardGui", vu83.Handle)
                        v84.Name = "NameEsp" .. Number
                        v84.ExtentsOffset = Vector3.new(0, 1, 0)
                        v84.Size = UDim2.new(1, 200, 1, 30)
                        v84.Adornee = vu83.Handle
                        v84.AlwaysOnTop = true
                        local v85 = Instance.new("TextLabel", v84)
                        v85.Font = Enum.Font.GothamSemibold
                        v85.FontSize = "Size14"
                        v85.TextWrapped = true
                        v85.Size = UDim2.new(1, 0, 1, 0)
                        v85.TextYAlignment = "Top"
                        v85.BackgroundTransparency = 1
                        v85.TextStrokeTransparency = 0.5
                        v85.TextColor3 = Color3.fromRGB(255, 255, 255)
                        v85.Text = vu83.Name .. " \n" .. vu67((game:GetService("Players").LocalPlayer.Character.Head.Position - vu83.Handle.Position).Magnitude / 3) .. " Distance"
                    end
                end
            elseif vu83.Handle:FindFirstChild("NameEsp" .. Number) then
                vu83.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
            end
        end)
    end
end
function UpdateFlowerChams()
	-- upvalues: (ref) vu67
    local v86, v87, v88 = pairs(game.Workspace:GetChildren())
    while true do
        local vu89
        v88, vu89 = v86(v87, v88)
        if v88 == nil then
            break
        end
        pcall(function()
			-- upvalues: (ref) vu89, (ref) vu67
            if vu89.Name == "Flower2" or vu89.Name == "Flower1" then
                if FlowerESP then
                    if vu89:FindFirstChild("NameEsp" .. Number) then
                        vu89["NameEsp" .. Number].TextLabel.Text = vu89.Name .. "   \n" .. vu67((game:GetService("Players").LocalPlayer.Character.Head.Position - vu89.Position).Magnitude / 3) .. " Distance"
                    else
                        local v90 = Instance.new("BillboardGui", vu89)
                        v90.Name = "NameEsp" .. Number
                        v90.ExtentsOffset = Vector3.new(0, 1, 0)
                        v90.Size = UDim2.new(1, 200, 1, 30)
                        v90.Adornee = vu89
                        v90.AlwaysOnTop = true
                        local v91 = Instance.new("TextLabel", v90)
                        v91.Font = Enum.Font.GothamSemibold
                        v91.FontSize = "Size14"
                        v91.TextWrapped = true
                        v91.Size = UDim2.new(1, 0, 1, 0)
                        v91.TextYAlignment = "Top"
                        v91.BackgroundTransparency = 1
                        v91.TextStrokeTransparency = 0.5
                        v91.TextColor3 = Color3.fromRGB(255, 0, 0)
                        if vu89.Name == "Flower1" then
                            v91.Text = "Blue Flower" .. " \n" .. vu67((game:GetService("Players").LocalPlayer.Character.Head.Position - vu89.Position).Magnitude / 3) .. " Distance"
                            v91.TextColor3 = Color3.fromRGB(0, 0, 255)
                        end
                        if vu89.Name == "Flower2" then
                            v91.Text = "Red Flower" .. " \n" .. vu67((game:GetService("Players").LocalPlayer.Character.Head.Position - vu89.Position).Magnitude / 3) .. " Distance"
                            v91.TextColor3 = Color3.fromRGB(255, 0, 0)
                        end
                    end
                elseif vu89:FindFirstChild("NameEsp" .. Number) then
                    vu89:FindFirstChild("NameEsp" .. Number):Destroy()
                end
            end
        end)
    end
end
function UpdateRealFruitChams()
	-- upvalues: (ref) vu67
    local v92, v93, v94 = pairs(game.Workspace.AppleSpawner:GetChildren())
    while true do
        local v95
        v94, v95 = v92(v93, v94)
        if v94 == nil then
            break
        end
        if v95:IsA("Tool") then
            if RealFruitESP then
                if v95.Handle:FindFirstChild("NameEsp" .. Number) then
                    v95.Handle["NameEsp" .. Number].TextLabel.Text = v95.Name .. " " .. vu67((game:GetService("Players").LocalPlayer.Character.Head.Position - v95.Handle.Position).Magnitude / 3) .. " Distance"
                else
                    local v96 = Instance.new("BillboardGui", v95.Handle)
                    v96.Name = "NameEsp" .. Number
                    v96.ExtentsOffset = Vector3.new(0, 1, 0)
                    v96.Size = UDim2.new(1, 200, 1, 30)
                    v96.Adornee = v95.Handle
                    v96.AlwaysOnTop = true
                    local v97 = Instance.new("TextLabel", v96)
                    v97.Font = Enum.Font.GothamSemibold
                    v97.FontSize = "Size14"
                    v97.TextWrapped = true
                    v97.Size = UDim2.new(1, 0, 1, 0)
                    v97.TextYAlignment = "Top"
                    v97.BackgroundTransparency = 1
                    v97.TextStrokeTransparency = 0.5
                    v97.TextColor3 = Color3.fromRGB(255, 0, 0)
                    v97.Text = v95.Name .. " \n" .. vu67((game:GetService("Players").LocalPlayer.Character.Head.Position - v95.Handle.Position).Magnitude / 3) .. " Distance"
                end
            elseif v95.Handle:FindFirstChild("NameEsp" .. Number) then
                v95.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
            end
        end
    end
    local v98, v99, v100 = pairs(game.Workspace.PineappleSpawner:GetChildren())
    while true do
        local v101
        v100, v101 = v98(v99, v100)
        if v100 == nil then
            break
        end
        if v101:IsA("Tool") then
            if RealFruitESP then
                if v101.Handle:FindFirstChild("NameEsp" .. Number) then
                    v101.Handle["NameEsp" .. Number].TextLabel.Text = v101.Name .. " " .. vu67((game:GetService("Players").LocalPlayer.Character.Head.Position - v101.Handle.Position).Magnitude / 3) .. " Distance"
                else
                    local v102 = Instance.new("BillboardGui", v101.Handle)
                    v102.Name = "NameEsp" .. Number
                    v102.ExtentsOffset = Vector3.new(0, 1, 0)
                    v102.Size = UDim2.new(1, 200, 1, 30)
                    v102.Adornee = v101.Handle
                    v102.AlwaysOnTop = true
                    local v103 = Instance.new("TextLabel", v102)
                    v103.Font = Enum.Font.GothamSemibold
                    v103.FontSize = "Size14"
                    v103.TextWrapped = true
                    v103.Size = UDim2.new(1, 0, 1, 0)
                    v103.TextYAlignment = "Top"
                    v103.BackgroundTransparency = 1
                    v103.TextStrokeTransparency = 0.5
                    v103.TextColor3 = Color3.fromRGB(255, 174, 0)
                    v103.Text = v101.Name .. " \n" .. vu67((game:GetService("Players").LocalPlayer.Character.Head.Position - v101.Handle.Position).Magnitude / 3) .. " Distance"
                end
            elseif v101.Handle:FindFirstChild("NameEsp" .. Number) then
                v101.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
            end
        end
    end
    local v104, v105, v106 = pairs(game.Workspace.BananaSpawner:GetChildren())
    while true do
        local v107
        v106, v107 = v104(v105, v106)
        if v106 == nil then
            break
        end
        if v107:IsA("Tool") then
            if RealFruitESP then
                if v107.Handle:FindFirstChild("NameEsp" .. Number) then
                    v107.Handle["NameEsp" .. Number].TextLabel.Text = v107.Name .. " " .. vu67((game:GetService("Players").LocalPlayer.Character.Head.Position - v107.Handle.Position).Magnitude / 3) .. " Distance"
                else
                    local v108 = Instance.new("BillboardGui", v107.Handle)
                    v108.Name = "NameEsp" .. Number
                    v108.ExtentsOffset = Vector3.new(0, 1, 0)
                    v108.Size = UDim2.new(1, 200, 1, 30)
                    v108.Adornee = v107.Handle
                    v108.AlwaysOnTop = true
                    local v109 = Instance.new("TextLabel", v108)
                    v109.Font = Enum.Font.GothamSemibold
                    v109.FontSize = "Size14"
                    v109.TextWrapped = true
                    v109.Size = UDim2.new(1, 0, 1, 0)
                    v109.TextYAlignment = "Top"
                    v109.BackgroundTransparency = 1
                    v109.TextStrokeTransparency = 0.5
                    v109.TextColor3 = Color3.fromRGB(251, 255, 0)
                    v109.Text = v107.Name .. " \n" .. vu67((game:GetService("Players").LocalPlayer.Character.Head.Position - v107.Handle.Position).Magnitude / 3) .. " Distance"
                end
            elseif v107.Handle:FindFirstChild("NameEsp" .. Number) then
                v107.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
            end
        end
    end
end
spawn(function()
    while wait() do
        pcall(function()
            if MobESP then
                local v110, v111, v112 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                while true do
                    local v113
                    v112, v113 = v110(v111, v112)
                    if v112 == nil then
                        break
                    end
                    if v113:FindFirstChild("HumanoidRootPart") then
                        if not v113:FindFirstChild("MobEap") then
                            local v114 = Instance.new("BillboardGui")
                            local v115 = Instance.new("TextLabel")
                            v114.Parent = v113
                            v114.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                            v114.Active = true
                            v114.Name = "MobEap"
                            v114.AlwaysOnTop = true
                            v114.LightInfluence = 1
                            v114.Size = UDim2.new(0, 200, 0, 50)
                            v114.StudsOffset = Vector3.new(0, 2.5, 0)
                            v115.Parent = v114
                            v115.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            v115.BackgroundTransparency = 1
                            v115.Size = UDim2.new(0, 200, 0, 50)
                            v115.Font = Enum.Font.GothamBold
                            v115.TextColor3 = Color3.fromRGB(7, 236, 240)
                            v115.Text.Size = 35
                        end
                        local v116 = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v113.HumanoidRootPart.Position).Magnitude)
                        v113.MobEap.TextLabel.Text = v113.Name .. "-" .. v116 .. " Distance"
                    end
                end
            else
                local v117, v118, v119 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                while true do
                    local v120
                    v119, v120 = v117(v118, v119)
                    if v119 == nil then
                        break
                    end
                    if v120:FindFirstChild("MobEap") then
                        v120.MobEap:Destroy()
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while wait() do
        pcall(function()
            if SeaESP then
                local v121, v122, v123 = pairs(game:GetService("Workspace").SeaBeasts:GetChildren())
                while true do
                    local v124
                    v123, v124 = v121(v122, v123)
                    if v123 == nil then
                        break
                    end
                    if v124:FindFirstChild("HumanoidRootPart") then
                        if not v124:FindFirstChild("Seaesps") then
                            local v125 = Instance.new("BillboardGui")
                            local v126 = Instance.new("TextLabel")
                            v125.Parent = v124
                            v125.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                            v125.Active = true
                            v125.Name = "Seaesps"
                            v125.AlwaysOnTop = true
                            v125.LightInfluence = 1
                            v125.Size = UDim2.new(0, 200, 0, 50)
                            v125.StudsOffset = Vector3.new(0, 2.5, 0)
                            v126.Parent = v125
                            v126.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            v126.BackgroundTransparency = 1
                            v126.Size = UDim2.new(0, 200, 0, 50)
                            v126.Font = Enum.Font.GothamBold
                            v126.TextColor3 = Color3.fromRGB(7, 236, 240)
                            v126.Text.Size = 35
                        end
                        local v127 = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v124.HumanoidRootPart.Position).Magnitude)
                        v124.Seaesps.TextLabel.Text = v124.Name .. "-" .. v127 .. " Distance"
                    end
                end
            else
                local v128, v129, v130 = pairs(game:GetService("Workspace").SeaBeasts:GetChildren())
                while true do
                    local v131
                    v130, v131 = v128(v129, v130)
                    if v130 == nil then
                        break
                    end
                    if v131:FindFirstChild("Seaesps") then
                        v131.Seaesps:Destroy()
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while wait() do
        pcall(function()
            if NpcESP then
                local v132, v133, v134 = pairs(game:GetService("Workspace").NPCs:GetChildren())
                while true do
                    local v135
                    v134, v135 = v132(v133, v134)
                    if v134 == nil then
                        break
                    end
                    if v135:FindFirstChild("HumanoidRootPart") then
                        if not v135:FindFirstChild("NpcEspes") then
                            local v136 = Instance.new("BillboardGui")
                            local v137 = Instance.new("TextLabel")
                            v136.Parent = v135
                            v136.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                            v136.Active = true
                            v136.Name = "NpcEspes"
                            v136.AlwaysOnTop = true
                            v136.LightInfluence = 1
                            v136.Size = UDim2.new(0, 200, 0, 50)
                            v136.StudsOffset = Vector3.new(0, 2.5, 0)
                            v137.Parent = v136
                            v137.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            v137.BackgroundTransparency = 1
                            v137.Size = UDim2.new(0, 200, 0, 50)
                            v137.Font = Enum.Font.GothamBold
                            v137.TextColor3 = Color3.fromRGB(7, 236, 240)
                            v137.Text.Size = 35
                        end
                        local v138 = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v135.HumanoidRootPart.Position).Magnitude)
                        v135.NpcEspes.TextLabel.Text = v135.Name .. "-" .. v138 .. " Distance"
                    end
                end
            else
                local v139, v140, v141 = pairs(game:GetService("Workspace").NPCs:GetChildren())
                while true do
                    local v142
                    v141, v142 = v139(v140, v141)
                    if v141 == nil then
                        break
                    end
                    if v142:FindFirstChild("NpcEspes") then
                        v142.NpcEspes:Destroy()
                    end
                end
            end
        end)
    end
end)
function isnil(p143)
    return p143 == nil
end
local function vu145(p144)
    return math.floor(tonumber(p144) + 0.5)
end
Number = math.random(1, 1000000)
function UpdateIslandMirageESP()
	-- upvalues: (ref) vu145
    local v146, v147, v148 = pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren())
    while true do
        local vu149
        v148, vu149 = v146(v147, v148)
        if v148 == nil then
            break
        end
        pcall(function()
			-- upvalues: (ref) vu149, (ref) vu145
            if MirageIslandESP then
                if vu149.Name == "Mirage Island" then
                    if vu149:FindFirstChild("NameEsp") then
                        vu149.NameEsp.TextLabel.Text = vu149.Name .. "   \n" .. vu145((game:GetService("Players").LocalPlayer.Character.Head.Position - vu149.Position).Magnitude / 3) .. " M"
                    else
                        local v150 = Instance.new("BillboardGui", vu149)
                        v150.Name = "NameEsp"
                        v150.ExtentsOffset = Vector3.new(0, 1, 0)
                        v150.Size = UDim2.new(1, 200, 1, 30)
                        v150.Adornee = vu149
                        v150.AlwaysOnTop = true
                        local v151 = Instance.new("TextLabel", v150)
                        v151.Font = "Code"
                        v151.FontSize = "Size14"
                        v151.TextWrapped = true
                        v151.Size = UDim2.new(1, 0, 1, 0)
                        v151.TextYAlignment = "Top"
                        v151.BackgroundTransparency = 1
                        v151.TextStrokeTransparency = 0.5
                        v151.TextColor3 = Color3.fromRGB(80, 245, 245)
                    end
                end
            elseif vu149:FindFirstChild("NameEsp") then
                vu149:FindFirstChild("NameEsp"):Destroy()
            end
        end)
    end
end
function UpdateAuraESP()
	-- upvalues: (ref) vu145
    local v152, v153, v154 = pairs(game:GetService("Workspace").NPCs:GetChildren())
    while true do
        local vu155
        v154, vu155 = v152(v153, v154)
        if v154 == nil then
            break
        end
        pcall(function()
			-- upvalues: (ref) vu155, (ref) vu145
            if AuraESP then
                if vu155.Name == "Master of Enhancement" then
                    if vu155:FindFirstChild("NameEsp") then
                        vu155.NameEsp.TextLabel.Text = vu155.Name .. "   \n" .. vu145((game:GetService("Players").LocalPlayer.Character.Head.Position - vu155.Position).Magnitude / 3) .. " M"
                    else
                        local v156 = Instance.new("BillboardGui", vu155)
                        v156.Name = "NameEsp"
                        v156.ExtentsOffset = Vector3.new(0, 1, 0)
                        v156.Size = UDim2.new(1, 200, 1, 30)
                        v156.Adornee = vu155
                        v156.AlwaysOnTop = true
                        local v157 = Instance.new("TextLabel", v156)
                        v157.Font = "Code"
                        v157.FontSize = "Size14"
                        v157.TextWrapped = true
                        v157.Size = UDim2.new(1, 0, 1, 0)
                        v157.TextYAlignment = "Top"
                        v157.BackgroundTransparency = 1
                        v157.TextStrokeTransparency = 0.5
                        v157.TextColor3 = Color3.fromRGB(80, 245, 245)
                    end
                end
            elseif vu155:FindFirstChild("NameEsp") then
                vu155:FindFirstChild("NameEsp"):Destroy()
            end
        end)
    end
end
function UpdateLSDESP()
	-- upvalues: (ref) vu145
    local v158, v159, v160 = pairs(game:GetService("Workspace").NPCs:GetChildren())
    while true do
        local vu161
        v160, vu161 = v158(v159, v160)
        if v160 == nil then
            break
        end
        pcall(function()
			-- upvalues: (ref) vu161, (ref) vu145
            if LADESP then
                if vu161.Name == "Legendary Sword Dealer" then
                    if vu161:FindFirstChild("NameEsp") then
                        vu161.NameEsp.TextLabel.Text = vu161.Name .. "   \n" .. vu145((game:GetService("Players").LocalPlayer.Character.Head.Position - vu161.Position).Magnitude / 3) .. " M"
                    else
                        local v162 = Instance.new("BillboardGui", vu161)
                        v162.Name = "NameEsp"
                        v162.ExtentsOffset = Vector3.new(0, 1, 0)
                        v162.Size = UDim2.new(1, 200, 1, 30)
                        v162.Adornee = vu161
                        v162.AlwaysOnTop = true
                        local v163 = Instance.new("TextLabel", v162)
                        v163.Font = "Code"
                        v163.FontSize = "Size14"
                        v163.TextWrapped = true
                        v163.Size = UDim2.new(1, 0, 1, 0)
                        v163.TextYAlignment = "Top"
                        v163.BackgroundTransparency = 1
                        v163.TextStrokeTransparency = 0.5
                        v163.TextColor3 = Color3.fromRGB(80, 245, 245)
                    end
                end
            elseif vu161:FindFirstChild("NameEsp") then
                vu161:FindFirstChild("NameEsp"):Destroy()
            end
        end)
    end
end
function UpdateGeaESP()
	-- upvalues: (ref) vu145
    local v164, v165, v166 = pairs(game:GetService("Workspace").Map.MysticIsland:GetChildren())
    while true do
        local vu167
        v166, vu167 = v164(v165, v166)
        if v166 == nil then
            break
        end
        pcall(function()
			-- upvalues: (ref) vu167, (ref) vu145
            if GearESP then
                if vu167.Name == "MeshPart" then
                    if vu167:FindFirstChild("NameEsp") then
                        vu167.NameEsp.TextLabel.Text = vu167.Name .. "   \n" .. vu145((game:GetService("Players").LocalPlayer.Character.Head.Position - vu167.Position).Magnitude / 3) .. " M"
                    else
                        local v168 = Instance.new("BillboardGui", vu167)
                        v168.Name = "NameEsp"
                        v168.ExtentsOffset = Vector3.new(0, 1, 0)
                        v168.Size = UDim2.new(1, 200, 1, 30)
                        v168.Adornee = vu167
                        v168.AlwaysOnTop = true
                        local v169 = Instance.new("TextLabel", v168)
                        v169.Font = "Code"
                        v169.FontSize = "Size14"
                        v169.TextWrapped = true
                        v169.Size = UDim2.new(1, 0, 1, 0)
                        v169.TextYAlignment = "Top"
                        v169.BackgroundTransparency = 1
                        v169.TextStrokeTransparency = 0.5
                        v169.TextColor3 = Color3.fromRGB(80, 245, 245)
                    end
                end
            elseif vu167:FindFirstChild("NameEsp") then
                vu167:FindFirstChild("NameEsp"):Destroy()
            end
        end)
    end
end
function Tween2(p170)
    local v171 = (p170.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local v172 = 350
    local v173 = TweenInfo.new(v171 / v172, Enum.EasingStyle.Linear)
    local v174 = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, v173, {
        ["CFrame"] = p170
    })
    v174:Play()
    if _G.StopTween2 then
        v174:Cancel()
    end
    _G.Clip2 = true
    wait(v171 / v172)
    _G.Clip2 = false
end
function BKP(p175)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p175
    task.wait()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p175
end
TweenSpeed = 600
-- Tốc độ tối đa server Blox Fruits chấp nhận (studs/giây)
-- Nếu vượt quá, server giật player về vị trí cũ
local SERVER_MAX_SPEED = 120  -- studs/giây, an toàn cho server
local STEP_SIZE = 60          -- studs mỗi bước (120 studs/s × 0.5s wait)
local STEP_WAIT = 0.5         -- giây chờ giữa mỗi bước

-- SafeMove: di chuyển từng bước nhỏ để server không reject
-- Mỗi bước ~60 studs, chờ 0.5s để server sync trước khi bước tiếp
local function SafeMove(targetCF, checkStop)
    local player = game.Players.LocalPlayer
    if not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local targetPos = targetCF.Position
    while true do
        if checkStop and checkStop() then break end
        local curPos = hrp.Position
        local remaining = (targetPos - curPos).Magnitude
        if remaining < 8 then break end

        -- Tính điểm đến của bước này
        local dir = (targetPos - curPos).Unit
        local stepDist = math.min(remaining, STEP_SIZE)
        local nextPos = curPos + dir * stepDist

        -- Giữ nguyên rotation của CFrame đích, chỉ thay position
        local nextCF
        if remaining <= STEP_SIZE then
            nextCF = targetCF  -- bước cuối giữ đúng CFrame
        else
            nextCF = CFrame.new(nextPos)
        end

        -- Set CFrame (server sync qua physics)
        pcall(function()
            hrp.CFrame = nextCF
        end)
        -- Chờ để server nhận và xác nhận vị trí mới
        task.wait(STEP_WAIT)
    end
end

-- Tween không blocking: dùng SafeMove trong coroutine riêng
-- Khi đích thay đổi, hủy coroutine cũ
local _tweenThread = nil

function Tween(p176)
    if not p176 then return end
    -- Hủy coroutine tween cũ nếu có
    if _tweenThread then
        pcall(function() task.cancel(_tweenThread) end)
        _tweenThread = nil
    end
    _tweenThread = task.spawn(function()
        SafeMove(p176, function()
            return _tweenThread == nil
        end)
        _tweenThread = nil
    end)
end

-- TweenBlock: blocking SafeMove, chờ đến nơi rồi mới return
function TweenBlock(targetCF)
    if not targetCF then return end
    -- Hủy tween đang chạy
    if _tweenThread then
        pcall(function() task.cancel(_tweenThread) end)
        _tweenThread = nil
    end
    _G.Clip2 = true
    pcall(function()
        SafeMove(targetCF, function()
            return _G.StopTween
        end)
    end)
    _G.Clip2 = false
end
function EquipTool(p181)
    if game.Players.LocalPlayer.Backpack:FindFirstChild(p181) then
        local v182 = game.Players.LocalPlayer.Backpack:FindFirstChild(p181)
        wait()
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(v182)
    end
end
spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoEvoRace or (_G.CastleRaid or (_G.CollectAzure or (_G.TweenToKitsune or (_G.GhostShip or (_G.Ship or (_G.Auto_Holy_Torch or (_G.TeleportPly or (_G.Auto_Sea3 or (_G.Auto_Sea2 or (_G.Tweenfruit or (_G.AutoFishCrew or (_G.Auto_Saber or (_G.AutoShark or (_G.Auto_Warden or (_G.Auto_RainbowHaki or (AutoFarmRace or (_G.AutoQuestRace or (Auto_Law or (AutoTushita or (_G.AutoHolyTorch or (_G.AutoTerrorshark or (_G.farmpiranya or (_G.Auto_MusketeerHat or (_G.Auto_ObservationV2 or (_G.AutoNear or (_G.Auto_PoleV1 or (_G.Auto_Buddy or (_G.Ectoplasm or (AutoEvoRace or (AutoBartilo or (_G.Auto_Canvander or (_G.AutoLevel or (_G.Auto_DualKatana or (Auto_Quest_Yama_3 or (Auto_Quest_Yama_2 or (Auto_Quest_Yama_1 or (Auto_Quest_Tushita_1 or (Auto_Quest_Tushita_2 or (Auto_Quest_Tushita_3 or (_G.Clip2 or (_G.Auto_Regoku or (_G.AutoBone or (_G.AutoBoneNoQuest or (_G.AutoBoss or (AutoFarmMasDevilFruit or (AutoFarmMasGun or (AutoHallowSycthe or (AutoTushita or (_G.Cake or (_G.Auto_SkullGuitar or (_G.AutoFarmSwan or (_G.AutoEliteor or (AutoNextIsland or (Musketeer or (_G.AutoMaterial or (AutoFarmRaceQuest or (_G.Factory or (_G.Auto_Saw or (_G.AutoFrozenDimension or (_G.AutoKillTrial or (_G.AutoUpgrade or _G.TweenToFrozenDimension))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) then
                if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    local v183 = Instance.new("BodyVelocity")
                    v183.Name = "BodyClip"
                    v183.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
                    v183.MaxForce = Vector3.new(100000, 100000, 100000)
                    v183.Velocity = Vector3.new(0, 0, 0)
                end
            else
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
            end
        end)
    end
end)
spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if _G.AutoEvoRace or (_G.Auto_RainbowHaki or (_G.Auto_SkullGuitar or (_G.CastleRaid or (_G.CollectAzure or (_G.TweenToKitsune or (_G.Auto_Sea3 or (_G.Auto_Sea2 or (_G.GhostShip or (_G.Ship or (_G.Auto_Holy_Torch or (_G.TeleportPly or (_G.Tweenfruit or (_G.Auto_Saber or (_G.Auto_PoleV1 or (_G.Auto_MusketeerHat or (_G.AutoFishCrew or (_G.AutoShark or (AutoFarmRace or (_G.AutoQuestRace or (_G.Auto_Warden or (Auto_Law or (_G.Auto_DualKatana or (Auto_Quest_Tushita_1 or (Auto_Quest_Tushita_2 or (Auto_Quest_Tushita_3 or (AutoTushita or (_G.AutoHolyTorch or (_G.Auto_Buddy or (_G.AutoTerrorshark or (_G.farmpiranya or (Auto_Quest_Yama_3 or (_G.Auto_ObservationV2 or (Auto_Quest_Yama_2 or (Auto_Quest_Yama_1 or (_G.AutoNear or (_G.Ectoplasm or (AutoEvoRace or (_G.AutoKillTrial or (AutoBartilo or (AutoFarmMasGun or (_G.Auto_Regoku or (_G.AutoLevel or (_G.Clip2 or (_G.AutoBone or (_G.Auto_Canvander or (_G.AutoBoneNoQuest or (_G.AutoBoss or (_G.Auto_Saw or (AutoFarmMasDevilFruit or (AutoHallowSycthe or (AutoTushita or (_G.Cake or (_G.AutoFarmSwan or (_G.AutoEliteor or (AutoNextIsland or (Musketeer or (_G.AutoMaterial or (_G.Factory or (_G.AutoFrozenDimension or (AutoFarmRaceQuest or (_G.AutoUpgrade or _G.TweenToFrozenDimension))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) then
                local v184, v185, v186 = pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants())
                while true do
                    local v187
                    v186, v187 = v184(v185, v186)
                    if v186 == nil then
                        break
                    end
                    if v187:IsA("BasePart") then
                        v187.CanCollide = false
                    end
                end
            end
        end)
    end)
end)
task.spawn(function()
    if game.Players.LocalPlayer.Character:FindFirstChild("Stun") then
        game.Players.LocalPlayer.Character.Stun.Changed:connect(function()
            pcall(function()
                if game.Players.LocalPlayer.Character:FindFirstChild("Stun") then
                    game.Players.LocalPlayer.Character.Stun.Value = 0
                end
            end)
        end)
    end
end)
function CheckMaterial(p188)
    local v189, v190, v191 = pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory"))
    while true do
        local v192
        v191, v192 = v189(v190, v191)
        if v191 == nil then
            break
        end
        if type(v192) == "table" and (v192.Type == "Material" and v192.Name == p188) then
            return v192.Count
        end
    end
    return 0
end
function GetWeaponInventory(p193)
    local v194, v195, v196 = pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory"))
    while true do
        local v197
        v196, v197 = v194(v195, v196)
        if v196 == nil then
            break
        end
        if type(v197) == "table" and (v197.Type == "Sword" and v197.Name == p193) then
            return true
        end
    end
    return false
end
local vu198 = game.Players.LocalPlayer
function AttackNoCoolDown()
	-- upvalues: (ref) vu198
    local vu199 = vu198.Character
    if not vu199 then
        return
    end
    local v200, v201, v202 = ipairs(vu199:GetChildren())
    local v203 = nil
    while true do
        local vu204
        v202, vu204 = v200(v201, v202)
        if v202 == nil then
            vu204 = v203
            break
        end
        if vu204:IsA("Tool") then
            break
        end
    end
    if vu204 then
        local function vu207(p205)
            local v206 = p205 and p205:FindFirstChild("Humanoid")
            if v206 then
                v206 = p205.Humanoid.Health > 0
            end
            return v206
        end
        local function v217(p208)
			-- upvalues: (ref) vu199, (ref) vu207
            local v209 = game:GetService("Workspace").Enemies:GetChildren()
            local v210 = vu199:GetPivot().Position
            local v211, v212, v213 = ipairs(v209)
            local v214 = {}
            while true do
                local v215
                v213, v215 = v211(v212, v213)
                if v213 == nil then
                    break
                end
                local v216 = v215:FindFirstChild("HumanoidRootPart")
                if v216 and (vu207(v215) and (v216.Position - v210).Magnitude <= p208) then
                    table.insert(v214, v215)
                end
            end
            return v214
        end
        if vu204:FindFirstChild("LeftClickRemote") then
            local v218 = v217(60)
            local v219, v220, v221 = ipairs(v218)
            local vu222 = 1
            while true do
                local v223
                v221, v223 = v219(v220, v221)
                if v221 == nil then
                    break
                end
                local vu224 = (v223.HumanoidRootPart.Position - vu199:GetPivot().Position).Unit
                pcall(function()
					-- upvalues: (ref) vu204, (ref) vu224, (ref) vu222
                    vu204.LeftClickRemote:FireServer(vu224, vu222)
                end)
                local v225 = vu222 + 1
                vu222 = v225 > 1000000000 and 1 or v225
            end
        else
            local v226 = game:GetService("Workspace").Enemies:GetChildren()
            local v227 = vu199:GetPivot().Position
            local v228, v229, v230 = ipairs(v226)
            local v231 = vu207
            local vu232 = {}
            local vu233 = nil
            while true do
                local v234, v235 = v228(v229, v230)
                if v234 == nil then
                    break
                end
                v230 = v234
                if not v235:GetAttribute("IsBoat") and v231(v235) then
                    local v236 = v235:FindFirstChild("Head")
                    if v236 and (v227 - v236.Position).Magnitude <= 60 then
                        table.insert(vu232, {
                            v235,
                            v236
                        })
                        vu233 = v236
                    end
                end
            end
            if not vu233 then
                return
            end
            pcall(function()
				-- upvalues: (ref) vu232, (ref) vu233
                local v237 = game:GetService("ReplicatedStorage")
                local v238 = v237:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack")
                local v239 = v237:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterHit")
                if # vu232 <= 0 then
                    task.wait(1e-9)
                else
                    v238:FireServer(1e-9)
                    v239:FireServer(vu233, vu232)
                end
            end)
        end
    end
end
Type = 1
spawn(function()
    while wait() do
        if Type == 1 then
            Pos = CFrame.new(0, 30, 0)
        end
    end
end)
spawn(function()
    while wait() do
        Type = 1
    end
end)
function AutoHaki()
    if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
    end
end
function to(p240)
    repeat
        wait(_G.Fast_Delay)
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(15)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p240
        task.wait()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p240
    until (p240.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 2000
end
function to(pu241)
    pcall(function()
		-- upvalues: (ref) pu241
        if (pu241.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 2000 and (not Auto_Raid and game.Players.LocalPlayer.Character.Humanoid.Health > 0) then
            if NameMon ~= "FishmanQuest" then
                if Mon ~= "God\'s Guard" then
                    if NameMon ~= "SkyExp1Quest" then
                        if NameMon ~= "ShipQuest1" then
                            if NameMon ~= "ShipQuest2" then
                                if NameMon ~= "FrostQuest" then
                                    repeat
                                        wait(_G.Fast_Delay)
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pu241
                                        wait(0.05)
                                        game.Players.LocalPlayer.Character.Head:Destroy()
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pu241
                                    until (pu241.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 2500 and game.Players.LocalPlayer.Character.Humanoid.Health > 0
                                    wait()
                                else
                                    Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                                    wait()
                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 6508.5581054688, 89.034996032715, - 132.83953857422))
                                end
                            else
                                Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                                wait()
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                            end
                        else
                            Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                            wait()
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                        end
                    else
                        Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                        wait()
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 7894.6176757813, 5547.1416015625, - 380.29119873047))
                    end
                else
                    Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                    wait()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 4607.82275, 872.54248, - 1667.55688))
                end
            else
                Tween(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                wait()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        end
    end)
end
task.defer(function()
    if game:GetService("ReplicatedStorage"):FindFirstChild("Effect") and (game:GetService("ReplicatedStorage").Effect:FindFirstChild("Container") and game:GetService("ReplicatedStorage").Effect.Container:FindFirstChild("Death")) then
        local v250 = require(game:GetService("ReplicatedStorage").Effect.Container.Death)
        local v251 = require(game:GetService("ReplicatedStorage").Util.CameraShaker)
        if v251 then
            v251:Stop()
        end
        if hookfunction then
            hookfunction(v250, function(...)
                return ...
            end)
        end
    end
end)
Tabs.Info:AddSection("Thông Tin")
Tabs.Info:AddButton({
    ["Title"] = "tuyenmod2194",
    ["Description"] = "Discord",
    ["Callback"] = function()
        setclipboard(tostring("https://dsc.gg/nopermc"))
    end
})
Tabs.Info:AddButton({
    ["Title"] = "tuyenmod2194",
    ["Description"] = "Youtube",
    ["Callback"] = function()
        setclipboard(tostring("https://youtube.com/@nopermc"))
    end
})
Tabs.Info:AddButton({
    ["Title"] = "tuyenmod2194",
    ["Description"] = "Tiktok",
    ["Callback"] = function()
        setclipboard(tostring("www.tiktok.com/@uytins1vn._"))
    end
})
Tabs.Info:AddParagraph({
    ["Title"] = "Phát triển Monster",
    ["Description"] = "Kỹ Năng: Del có"
})
local v252 = nil
if identifyexecutor then
    v252 = identifyexecutor()
elseif getexecutorname then
    v252 = getexecutorname()
end
if v252 then
    Tabs.Info:AddParagraph({
        ["Title"] = "Client Đang Dùng",
        ["Description"] = v252
    })
end
Tabs.Info:AddParagraph({
    ["Title"] = "Cấp Nhắt",
    ["Description"] = "Tôi sẽ Cấp nhắt nhiều tính năng hơn trong tương lai"
})
Tabs.Info:AddParagraph({
    ["Title"] = "Các Client Android và Ios Hợ Trỡ",
    ["Description"] = "Tất Cả Client Android và Ios "
})
Tabs.Info:AddParagraph({
    ["Title"] = "Các Client Pc Hợ Trỡ",
    ["Description"] = "Tất Cả Client Pc"
})
_G.FastAttackStrix_Mode = "Super Fast Attack"
spawn(function()
    while wait() do
        if _G.FastAttackStrix_Mode then
            pcall(function()
                if _G.FastAttackStrix_Mode == "Super Fast Attack" then
                    _G.Fast_Delay = 1e-9
                end
            end)
        end
    end
end)
Tabs.Main:AddSection("Cày Cấp")
local v253 = Tabs.Main:AddDropdown("DropdownSelectWeapon", {
    ["Title"] = "Vũ Khí",
    ["Values"] = {
        "Melee",
        "Sword",
        "Blox Fruit"
    },
    ["Multi"] = false,
    ["Default"] = 1
})
v253:SetValue("Melee")
ChooseWeapon = "Melee" -- khởi tạo ngay, không chờ callback
v253:OnChanged(function(p254)
    ChooseWeapon = p254
end)
task.spawn(function()
    while wait() do
        pcall(function()
            -- Tìm trong Backpack VÀ Character (tool đang cầm nằm trong Character)
            local sources = {game.Players.LocalPlayer.Backpack}
            if game.Players.LocalPlayer.Character then
                table.insert(sources, game.Players.LocalPlayer.Character)
            end
            for _, src in pairs(sources) do
                for _, t in pairs(src:GetChildren()) do
                    if t:IsA("Tool") then
                        if ChooseWeapon == "Blox Fruit" and t.ToolTip == "Blox Fruit" then
                            SelectWeapon = t.Name
                        elseif ChooseWeapon == "Sword" and t.ToolTip == "Sword" then
                            SelectWeapon = t.Name
                        elseif ChooseWeapon == "Melee" and t.ToolTip == "Melee" then
                            SelectWeapon = t.Name
                        end
                    end
                end
            end
        end)
    end
end)
Tabs.Main:AddToggle("ToggleLevel", {
    ["Title"] = "Cày Cấp",
    ["Default"] = false
}):OnChanged(function(p267)
    _G.AutoLevel = p267
    if p267 == true then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "✅ Auto Farm Level";
            Text = "Đã bật! Bot sẽ tự động farm level";
            Duration = 3;
        })
    else
        wait()
        Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
        wait()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "❌ Auto Farm Level";
            Text = "Đã tắt!";
            Duration = 2;
        })
    end
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while task.wait() do
        if _G.AutoLevel then
            pcall(function()
                CheckLevel()

                if not Ms or not NameMon or not NameQuest or not QuestLv or not CFrameQ or not CFrameMon then
                    return
                end

                local questVisible = false
                local QuestTitle = ""
                pcall(function()
                    questVisible = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                    if questVisible then
                        QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                    end
                end)

                -- Nếu đang có quest KHÁC thì bỏ quest
                if questVisible and QuestTitle ~= "" and not string.find(QuestTitle, NameMon) then
                    bringmob = false
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    return
                end

                -- Chưa có quest → bay tới NPC nhận quest bằng Tween2 (giống di chuyển đảo)
                if not questVisible then
                    bringmob = false
                    Tween2(CFrameQ)
                    repeat task.wait(0.1) until (CFrameQ.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 20 or not _G.AutoLevel
                    wait(0.2)
                    if (CFrameQ.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 20 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
                        wait(0.3)
                    end
                    return
                end

                -- Đã có quest đúng → farm (dùng BKP để đứng cạnh quái, giống island travel)
                if questVisible and string.find(QuestTitle, NameMon) then
                    if game:GetService("Workspace").Enemies:FindFirstChild(Ms) then
                        for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and v.Name == Ms then
                                -- Bật hiệu ứng tia lửa + tiếng spam liên tục
                                if not _fxEnabled then _fxEnabled = true; StartFXLoop() end
                                repeat
                                    task.wait(_G.Fast_Delay)
                                    AttackNoCoolDown()
                                    bringmob = true
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    -- Dùng BKP teleport trực tiếp cạnh quái (giống các tính năng khác)
                                    local _mobCF = v.HumanoidRootPart.CFrame * Pos
                                    if (_mobCF.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then
                                        BKP(_mobCF)
                                    end
                                    v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    v.HumanoidRootPart.Transparency = 1
                                    v.Humanoid.JumpPower = 0
                                    v.Humanoid.WalkSpeed = 0
                                    v.HumanoidRootPart.CanCollide = false
                                    pcall(function() v.Head.CanCollide = false end)
                                    FarmPos = v.HumanoidRootPart.CFrame
                                    MonFarm = v.Name
                                    local qv = false
                                    pcall(function() qv = game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible end)
                                until not _G.AutoLevel or not v.Parent or v.Humanoid.Health <= 0 or not qv
                                bringmob = false
                                if not _G.OneHitKill and not _G.AutoBone and not _G.AutoBoneNoQuest and not _G.AutoNear then StopFXLoop() end
                            end
                        end
                    else
                        bringmob = false
                        -- Bay đến vị trí quái spawn bằng Tween2 (giống di chuyển đảo)
                        Tween2(CFrameMon)
                    end
                end
            end)
        end
    end
end)
Tabs.Main:AddSection("Chiến Đấu")
Tabs.Main:AddToggle("ToggleOneHit", {
    ["Title"] = "Đánh Nhanh",
    ["Default"] = false
}):OnChanged(function(v)
    _G.OneHitKill = v
    getgenv().AutoClick = v
end)
-- AutoClick: dùng Button1Down/Up vào giữa viewport game - KHÔNG click vào UI
getgenv().AutoClick = false
getgenv().ClicksPerSecond = 20
local _vu = game:GetService("VirtualUser")
task.spawn(function()
    while task.wait(1 / getgenv().ClicksPerSecond) do
        if getgenv().AutoClick then
            pcall(function()
                local cam = workspace.CurrentCamera
                local vp = cam.ViewportSize
                local center = Vector2.new(vp.X / 2, vp.Y / 2)
                _vu:Button1Down(center, cam.CFrame)
                task.wait(0.02)
                _vu:Button1Up(center, cam.CFrame)
            end)
        end
    end
end)
-- ============================================================
-- HỆ THỐNG HIỆU ỨNG ĐÁNH: Tia lửa đóm đóm CỰC NHIỀU phủ toàn thân quái
-- ============================================================
local _fxThread = nil      -- coroutine vòng lặp hiệu ứng
local _fxEnabled = false   -- bật/tắt hiệu ứng

-- Danh sách sound IDs tiếng đánh (ngắn, mạnh, đa dạng)
local _hitSounds = {
    "rbxassetid://5221806718",
    "rbxassetid://5221806728",
    "rbxassetid://5221806736",
    "rbxassetid://341336274",
    "rbxassetid://5221806751",
}

-- Tạo 1 emitter node tại vị trí offset, emit đóm và tự xóa
local function _spawnNode(basePos, offsetX, offsetY, offsetZ, count)
    pcall(function()
        local fx = Instance.new("Part")
        fx.Anchored = true
        fx.CanCollide = false
        fx.CastShadow = false
        fx.Size = Vector3.new(0.1, 0.1, 0.1)
        fx.Transparency = 1
        fx.Position = basePos + Vector3.new(offsetX, offsetY, offsetZ)
        fx.Parent = workspace

        -- Sparkles lấp lánh trắng
        local sp = Instance.new("Sparkles")
        sp.SparkleColor = Color3.fromRGB(255, 255, 255)
        sp.Enabled = true
        sp.Parent = fx

        -- Particle đóm lửa chính
        local pe = Instance.new("ParticleEmitter")
        pe.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 240, 120)),
            ColorSequenceKeypoint.new(0.55,Color3.fromRGB(255, 140, 0)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(220, 30, 0)),
        })
        pe.LightEmission  = 1
        pe.LightInfluence = 0
        pe.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0,   0.55),
            NumberSequenceKeypoint.new(0.4, 0.35),
            NumberSequenceKeypoint.new(1,   0),
        })
        pe.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0,   0),
            NumberSequenceKeypoint.new(0.6, 0.3),
            NumberSequenceKeypoint.new(1,   1),
        })
        pe.Speed        = NumberRange.new(6, 18)
        pe.SpreadAngle  = Vector2.new(180, 180)
        pe.Rate         = 0
        pe.Lifetime     = NumberRange.new(0.25, 0.65)
        pe.RotSpeed     = NumberRange.new(-400, 400)
        pe.Rotation     = NumberRange.new(0, 360)
        pe.Parent = fx
        pe:Emit(count)

        game:GetService("Debris"):AddItem(fx, 0.7)
    end)
end

-- Spawn đóm CỰC NHIỀU: lưới điểm bao phủ toàn bộ bounding box quái + lan ra ngoài
local function SpawnSparkFX(mob)
    pcall(function()
        if not mob or not mob.Parent then return end
        -- Tính bounding box tất cả BasePart của quái
        local parts = {}
        for _, p in pairs(mob:GetDescendants()) do
            if p:IsA("BasePart") then table.insert(parts, p) end
        end
        if #parts == 0 then
            -- fallback: dùng HumanoidRootPart
            local hrp = mob:FindFirstChild("HumanoidRootPart")
            if hrp then table.insert(parts, hrp) end
        end

        local minX, minY, minZ =  math.huge,  math.huge,  math.huge
        local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge
        for _, p in pairs(parts) do
            local pos = p.Position
            local hs  = p.Size * 0.5
            minX = math.min(minX, pos.X - hs.X)
            minY = math.min(minY, pos.Y - hs.Y)
            minZ = math.min(minZ, pos.Z - hs.Z)
            maxX = math.max(maxX, pos.X + hs.X)
            maxY = math.max(maxY, pos.Y + hs.Y)
            maxZ = math.max(maxZ, pos.Z + hs.Z)
        end

        -- Lan ra 2 studs bên ngoài bounding box
        local pad = 2
        minX = minX - pad; minY = minY - pad; minZ = minZ - pad
        maxX = maxX + pad; maxY = maxY + pad; maxZ = maxZ + pad

        local cx = (minX + maxX) * 0.5
        local cy = (minY + maxY) * 0.5
        local cz = (minZ + maxZ) * 0.5
        local base = Vector3.new(cx, cy, cz)

        local rx = (maxX - minX) * 0.5
        local ry = (maxY - minY) * 0.5
        local rz = (maxZ - minZ) * 0.5

        -- Grid 4x5x4 = 80 node, mỗi node emit 8-14 đóm → ~640-1120 đóm/lần gọi
        local stepsX, stepsY, stepsZ = 4, 5, 4
        for ix = 0, stepsX - 1 do
            for iy = 0, stepsY - 1 do
                for iz = 0, stepsZ - 1 do
                    local ox = -rx + (2 * rx / (stepsX - 1)) * ix
                    local oy = -ry + (2 * ry / (stepsY - 1)) * iy
                    local oz = -rz + (2 * rz / (stepsZ - 1)) * iz
                    -- jitter nhỏ để trông tự nhiên
                    ox = ox + (math.random() - 0.5) * 0.8
                    oy = oy + (math.random() - 0.5) * 0.8
                    oz = oz + (math.random() - 0.5) * 0.8
                    _spawnNode(base, ox, oy, oz, math.random(8, 14))
                end
            end
        end
    end)
end

-- Phát tiếng đánh ngẫu nhiên tại vị trí
local function PlayHitSound(pos)
    pcall(function()
        local sid = _hitSounds[math.random(1, #_hitSounds)]
        local snd = Instance.new("Sound")
        snd.SoundId = sid
        snd.Volume = 0.9
        snd.RollOffMaxDistance = 60
        local p = Instance.new("Part")
        p.Anchored = true; p.CanCollide = false
        p.Transparency = 1; p.Size = Vector3.new(0.1,0.1,0.1)
        p.Position = pos; p.Parent = workspace
        snd.Parent = p
        snd:Play()
        game:GetService("Debris"):AddItem(p, 1.5)
    end)
end

-- Giữ tên cũ để code bên dưới dùng được
local function ApplyHitEffect(mob)
    SpawnSparkFX(mob)
end

-- Vòng lặp hiệu ứng chính: spam đóm + tiếng mỗi 0.06s (~17 lần/giây)
local function StartFXLoop()
    if _fxThread then pcall(function() task.cancel(_fxThread) end) end
    _fxThread = task.spawn(function()
        while _fxEnabled do
            pcall(function()
                if MonFarm and MonFarm ~= "" then
                    for _, mob in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if mob.Name == MonFarm
                            and mob:FindFirstChild("HumanoidRootPart")
                            and mob:FindFirstChild("Humanoid")
                            and mob.Humanoid.Health > 0 then
                            local pos = mob.HumanoidRootPart.Position
                            SpawnSparkFX(mob)
                            PlayHitSound(pos)
                            break
                        end
                    end
                end
            end)
            task.wait(0.06)
        end
        _fxThread = nil
    end)
end

local function StopFXLoop()
    _fxEnabled = false
    if _fxThread then
        pcall(function() task.cancel(_fxThread) end)
        _fxThread = nil
    end
end

-- ============================================================
-- ĐÁNH NHANH: HP quái còn 25%, tự động kích hoạt hiệu ứng
-- ============================================================
local _oneHitConns = {}

spawn(function()
    while wait(0.1) do
        if _G.OneHitKill then
            -- Bật FX loop khi đánh nhanh đang on
            if not _fxEnabled then
                _fxEnabled = true
                StartFXLoop()
            end
            pcall(function()
                local localPlayer = game:GetService("Players").LocalPlayer
                for _, mob in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    local hum = mob:FindFirstChild("Humanoid")
                    if hum and not _oneHitConns[mob] then
                        -- Clamp HP về 25%
                        pcall(function()
                            sethiddenproperty(localPlayer, "SimulationRadius", math.huge)
                            if hum.Health > hum.MaxHealth * 0.25 then
                                hum.Health = hum.MaxHealth * 0.25
                            end
                        end)
                        -- Hook: khi server restore HP → clamp lại 25%
                        local prevHp = hum.Health
                        _oneHitConns[mob] = hum.HealthChanged:Connect(function(newHp)
                            if not _G.OneHitKill then return end
                            pcall(function()
                                sethiddenproperty(localPlayer, "SimulationRadius", math.huge)
                                if newHp > hum.MaxHealth * 0.25 then
                                    hum.Health = hum.MaxHealth * 0.25
                                end
                                prevHp = newHp
                            end)
                        end)
                    end
                end
                -- Dọn connection mob đã despawn
                for mob, conn in pairs(_oneHitConns) do
                    if not mob.Parent then
                        pcall(function() conn:Disconnect() end)
                        _oneHitConns[mob] = nil
                    end
                end
            end)
        else
            -- Tắt FX loop khi OneHitKill off
            if _fxEnabled and not (_G.AutoBone or _G.AutoBoneNoQuest or _G.AutoLevel or _G.AutoNear) then
                StopFXLoop()
            end
            for mob, conn in pairs(_oneHitConns) do
                pcall(function() conn:Disconnect() end)
            end
            _oneHitConns = {}
        end
    end
end)
Tabs.Main:AddToggle("ToggleMobAura", {
    ["Title"] = "Đánh Quái Gần",
    ["Default"] = false
}):OnChanged(function(p276)
    _G.AutoNear = p276
    if p276 == false then
        wait()
        Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
        wait()
    end
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        if _G.AutoNear then
            pcall(function()
                local v277, v278, v279 = pairs(game.Workspace.Enemies:GetChildren())
                while true do
                    local v280
                    v279, v280 = v277(v278, v279)
                    if v279 == nil then
                        break
                    end
                    if v280:FindFirstChild("Humanoid") and (v280:FindFirstChild("HumanoidRootPart") and (v280.Humanoid.Health > 0 and (v280.Name and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v280:FindFirstChild("HumanoidRootPart").Position).Magnitude <= 5000))) then
                        repeat
                            wait(_G.Fast_Delay)
                            v280.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            v280.HumanoidRootPart.Transparency = 1
                            v280.Humanoid.JumpPower = 0
                            v280.Humanoid.WalkSpeed = 0
                            v280.HumanoidRootPart.CanCollide = false
                            local mobCF7 = v280.HumanoidRootPart.CFrame * Pos
                            local dist7 = (mobCF7.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            if dist7 > 5 then BKP(mobCF7) end
                            bringmob = true
                            AutoHaki()
                            EquipTool(SelectWeapon)
                            AttackNoCoolDown()
                            FarmPos = v280.HumanoidRootPart.CFrame
                            MonFarm = v280.Name
                        until not _G.AutoNear or (not v280.Parent or v280.Humanoid.Health <= 0) or not game.Workspace.Enemies:FindFirstChild(v280.Name)
                        bringmob = false
                    end
                end
            end)
        end
    end
end)
Tabs.Main:AddToggle("ToggleCastleRaid", {
    ["Title"] = "Đánh Hải Tặc",
    ["Default"] = false
}):OnChanged(function(p281)
    _G.CastleRaid = p281
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        if _G.CastleRaid then
            pcall(function()
                local v282 = CFrame.new(- 5496.17432, 313.768921, - 2841.53027, 0.924894512, 7.37058015e-9, 0.380223751, 3.5881019e-8, 1, - 1.06665446e-7, - 0.380223751, 1.12297109e-7, 0.924894512)
                if (CFrame.new(- 5539.3115234375, 313.800537109375, - 2972.372314453125).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 500 then
                    Tween2(v282)
                else
                    local v283, v284, v285 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                    while true do
                        local v286
                        v285, v286 = v283(v284, v285)
                        if v285 == nil then
                            break
                        end
                        if _G.CastleRaid and (v286:FindFirstChild("HumanoidRootPart") and (v286:FindFirstChild("Humanoid") and (v286.Humanoid.Health > 0 and (v286.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 2000))) then
                            repeat
                                wait(_G.Fast_Delay)
                                AttackNoCoolDown()
                                AutoHaki()
                                EquipTool(SelectWeapon)
                                v286.HumanoidRootPart.CanCollide = false
                                v286.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                local _mc1 = v286.HumanoidRootPart.CFrame * Pos
                                if (v286.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc1) end
                            until v286.Humanoid.Health <= 0 or not (v286.Parent and _G.CastleRaid)
                        end
                    end
                end
            end)
        end
    end
end)
Tabs.Main:AddToggle("ToggleHakiFortress", {
    ["Title"] = "Bắt Haki Màu Pháo Đài",
    ["Default"] = false
}):OnChanged(function(p287)
    _G.EnableHakiFortress = p287
end)
-- [SetValue skipped - Library không cần]
local function vu291(p288, p289)
    local v290 = {
        {
            ["StorageName"] = p288,
            ["Type"] = "AuraSkin",
            ["Context"] = "Equip"
        }
    }
    game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/FruitCustomizerRF"):InvokeServer(unpack(v290))
    Tween2(p289)
end
local function vu295(p292, p293)
    local v294 = game.Players.LocalPlayer.Character
    if v294 and v294:FindFirstChild("HumanoidRootPart") then
        return (v294.HumanoidRootPart.Position - p292).Magnitude < p293
    else
        return false
    end
end
spawn(function()
	-- upvalues: (ref) vu291, (ref) vu295
    while true do
        if _G.EnableHakiFortress then
            vu291("Snow White", Vector3.new(- 4971.71826171875, 335.9582214355469, - 3720.0595703125))
            while not vu295(Vector3.new(- 4971.71826171875, 335.9582214355469, - 3720.0595703125), 1) do
                wait(0.1)
            end
            wait(0.5)
            vu291("Pure Red", Vector3.new(- 5414.92041015625, 314.2582092285156, - 2212.20166015625))
            while not vu295(Vector3.new(- 5414.92041015625, 314.2582092285156, - 2212.20166015625), 1) do
                wait(0.1)
            end
            wait(0.5)
            vu291("Winter Sky", Vector3.new(- 5420.26318359375, 1089.3582763671875, - 2666.8193359375))
            while not vu295(Vector3.new(- 5420.26318359375, 1089.3582763671875, - 2666.8193359375), 1) do
                wait(0.1)
            end
            wait(0.5)
            _G.EnableHakiFortress = false
        end
        wait(0.5)
    end
end)
Tabs.Main:AddToggle("ToggleCollectChest", {
    ["Title"] = "Làm Rương",
    ["Default"] = false
}):OnChanged(function(p296)
    _G.AutoCollectChest = p296
end)
spawn(function()
    while wait() do
        if _G.AutoCollectChest then
            local v297 = game:GetService("Players").LocalPlayer
            local v298 = (v297.Character or v297.CharacterAdded:Wait()):GetPivot().Position
            local v299 = game:GetService("CollectionService"):GetTagged("_ChestTagged")
            local v300 = math.huge
            local v301 = nil
            for v302 = 1, # v299 do
                local v303 = v299[v302]
                local v304 = (v303:GetPivot().Position - v298).Magnitude
                if not v303:GetAttribute("IsDisabled") then
                    if v304 < v300 then
                        v301 = v303
                        v300 = v304
                    end
                end
            end
            if v301 then
                local v305 = v301:GetPivot().Position
                local v306 = CFrame.new(v305)
                Tween2(v306)
            end
        end
    end
end)
Tabs.Main:AddToggle("ToggleCollectBerry", {
    ["Title"] = "Bay Đến Khu Vực Có Berry+Hop",
    ["Default"] = false
}):OnChanged(function(p307)
    _G.AutoCollectBerry = p307
end)
spawn(function()
	-- upvalues: (ref) vu1
    while wait() do
        if _G.AutoCollectBerry then
            local v308 = game:GetService("Players").LocalPlayer
            local v309 = (v308.Character or v308.CharacterAdded:Wait()):GetPivot().Position
            local v310 = game:GetService("CollectionService"):GetTagged("BerryBush")
            local v311 = math.huge
            local v312 = nil
            local v313 = nil
            for v314 = 1, # v310 do
                local v315 = v310[v314]
                local v316, v317, v318 = pairs(v315:GetAttributes())
                while true do
                    local v319
                    v318, v319 = v316(v317, v318)
                    if v318 == nil then
                        break
                    end
                    local v320 = (v315.Parent:GetPivot().Position - v309).Magnitude
                    if v320 < v311 then
                        v313 = v319
                        v312 = v315
                        v311 = v320
                    end
                end
            end
            if v312 then
                local v321 = v312.Parent:GetPivot().Position
                local v322 = CFrame.new(v321)
                Tween2(v322)
                Library:Notify({
                    ["Title"] = "Strix",
                    ["Description"] = "Tìm Thấy Berry: " .. tostring(v313),
                    ["Duration"] = 10
                })
            else
                Hop()
            end
        end
    end
end)
Tabs.Main:AddSection("Thông Thạo")
local v323 = Tabs.Main:AddDropdown("DropdownMastery", {
    ["Title"] = "Chọn Loại",
    ["Values"] = {
        "Level",
        "Level No Quest",
        "Near Mob",
        "Bone",
        "Cake",
        "Ecto"
    },
    ["Multi"] = false,
    ["Default"] = 1
})
v323:SetValue(TypeMastery)
v323:OnChanged(function(p324)
    TypeMastery = p324
end)
Tabs.Main:AddToggle("ToggleMasteryFruit", {
    ["Title"] = "Cày Trái",
    ["Default"] = false
}):OnChanged(function(p325)
    AutoFarmMasDevilFruit = p325
end)
-- [SetValue skipped - Library không cần]
Tabs.Main:AddToggle("ToggleMasteryGun", {
    ["Title"] = "Cày Súng",
    ["Default"] = false
}):OnChanged(function(p326)
    AutoFarmMasGun = p326
end)
local v328 = Tabs.Main:AddSlider("SliderHealt", {
    ["Title"] = "Máu Quái",
    ["Default"] = 20,
    ["Min"] = 0,
    ["Max"] = 100,
    ["Rounding"] = 1,
    ["Callback"] = function(p327)
        KillPercent = p327
    end
})
v328:OnChanged(function(p329)
    KillPercent = p329
end)
v328:SetValue(20)
spawn(function()
    while task.wait() do
        if _G.UseSkill then
            pcall(function()
				-- block 48
                if not _G.UseSkill then
					-- ::l3::
                    return
                end
                local v330, v331, v332 = pairs(game:GetService("Workspace").Enemies:GetChildren())
				-- ::l4::
                local v333
                v332, v333 = v330(v331, v332)
                if v332 == nil then
					-- goto l3
                end
                if v333.Name ~= MonFarm or (not v333:FindFirstChild("Humanoid") or (not v333:FindFirstChild("HumanoidRootPart") or v333.Humanoid.Health > v333.Humanoid.MaxHealth * KillPercent / 100)) then
					-- goto l4
                end
				-- ::l13::
                game:GetService("RunService").Heartbeat:wait()
                EquipTool(game.Players.LocalPlayer.Data.DevilFruit.Value)
                local _mc2 = v333.HumanoidRootPart.CFrame * Pos
                if (v333.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc2) end
                PositionSkillMasteryDevilFruit = v333.HumanoidRootPart.Position
                if game:GetService("Players").LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value) then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value).MousePos.Value = PositionSkillMasteryDevilFruit
                    local v334 = game:GetService("Players").LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value).Level.Value
                    if SkillZ and 1 <= v334 then
                        game:service("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                        wait()
                        game:service("VirtualInputManager"):SendKeyEvent(false, "Z", false, game)
                    end
                    if SkillX and 1 <= v334 then
                        game:service("VirtualInputManager"):SendKeyEvent(true, "X", false, game)
                        wait()
                        game:service("VirtualInputManager"):SendKeyEvent(false, "X", false, game)
                    end
                    if SkillC and 1 <= v334 then
                        game:service("VirtualInputManager"):SendKeyEvent(true, "C", false, game)
                        wait()
                        game:service("VirtualInputManager"):SendKeyEvent(false, "C", false, game)
                    end
                    if SkillV and 1 <= v334 then
                        game:service("VirtualInputManager"):SendKeyEvent(true, "V", false, game)
                        wait()
                        game:service("VirtualInputManager"):SendKeyEvent(false, "V", false, game)
                    end
                    if SkillF and 1 <= v334 then
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "F", false, game)
                        wait()
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, "F", false, game)
                    end
                end
                if AutoFarmMasDevilFruit and (_G.UseSkill and v333.Humanoid.Health ~= 0) then
					-- goto l13
                else
					-- goto l3
                end
				-- ::l3::
				-- ::l2::
				-- goto l4
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if AutoFarmMasDevilFruit and TypeMastery == "Near Mob" then
            pcall(function()
                local v335, v336, v337 = pairs(game.Workspace.Enemies:GetChildren())
                while true do
                    local v338
                    v337, v338 = v335(v336, v337)
                    if v337 == nil then
                        return
                    end
                    if v338.Name and (v338:FindFirstChild("Humanoid") and (v338:FindFirstChild("HumanoidRootPart") and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v338:FindFirstChild("HumanoidRootPart").Position).Magnitude <= 5000)) then
                        repeat
                            if true then
                                wait(_G.Fast_Delay)
                                if v338.Humanoid.Health > v338.Humanoid.MaxHealth * KillPercent / 100 then
                                    _G.UseSkill = false
                                    AutoHaki()
                                    bringmob = true
                                    EquipTool(SelectWeapon)
                                    local _mc3 = v338.HumanoidRootPart.CFrame * Pos
                                    if (v338.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc3) end
                                    v338.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    v338.HumanoidRootPart.Transparency = 1
                                    v338.Humanoid.JumpPower = 0
                                    v338.Humanoid.WalkSpeed = 0
                                    v338.HumanoidRootPart.CanCollide = false
                                    FarmPos = v338.HumanoidRootPart.CFrame
                                    MonFarm = v338.Name
                                    AttackNoCoolDown()
                                else
                                    _G.UseSkill = true
                                end
                            end
                        until not AutoFarmMasDevilFruit or (not MasteryType == "Near Mob" or (not v338.Parent or (v338.Humanoid.Health == 0 or not TypeMastery == "Near Mob")))
                        bringmob = false
                        _G.UseSkill = false
                    end
                end
            end)
        end
    end
end)
spawn(function()
	-- ::l0::
    repeat
        if not wait() then
            return
        end
    until AutoFarmMasDevilFruit and TypeMastery == "Ecto"
    pcall(function()
        local v339 = CFrame.new(904.4072265625, 181.05767822266, 33341.38671875)
        Tween2(v339)
    end)
    if (Vector3.new(904.4072265625, 181.05767822266, 33341.38671875) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
    end
    local v340, v341, v342 = pairs(game:GetService("Workspace").Enemies:GetChildren())
	-- ::l11::
	-- ::l7::
	-- ::l19::
    if true then
        wait(_G.Fast_Delay)
        if v343.Humanoid.Health > v343.Humanoid.MaxHealth * KillPercent / 100 then
            _G.UseSkill = false
            AutoHaki()
            bringmob = true
            EquipTool(SelectWeapon)
            local _mc4 = v343.HumanoidRootPart.CFrame * Pos
            if (v343.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc4) end
            v343.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
            v343.HumanoidRootPart.Transparency = 1
            v343.Humanoid.JumpPower = 0
            v343.Humanoid.WalkSpeed = 0
            v343.HumanoidRootPart.CanCollide = false
            FarmPos = v343.HumanoidRootPart.CFrame
            MonFarm = v343.Name
            AttackNoCoolDown()
        else
            _G.UseSkill = true
        end
    end
    if AutoFarmMasDevilFruit and (not MasteryType ~= "Ecto" and (v343.Parent and (v343.Humanoid.Health ~= 0 and not TypeMastery ~= "Ecto"))) then
		-- goto l19
    else
		-- goto l31
    end
	-- ::l31::
    bringmob = false
    _G.UseSkill = false
	-- ::l11::
    local v343
    v342, v343 = v340(v341, v342)
    if v342 ~= nil then
		-- goto l12
    end
    local v344, v345, v346 = pairs(game:GetService("ReplicatedStorage"):GetChildren())
    while true do
        local v347
        v346, v347 = v344(v345, v346)
        if v346 == nil then
            break
        end
        if v347.Name ~= "Ship Steward" then
            if v347.Name ~= "Ship Engineer" then
                if v347.Name ~= "Ship Deckhand" then
                    if v347.Name == "Ship Officer" then
                        local _mc5 = v347.HumanoidRootPart.CFrame * Pos
                        if (v347.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc5) end
                    end
                else
                    local _mc6 = v347.HumanoidRootPart.CFrame * Pos
                    if (v347.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc6) end
                end
            else
                local _mc7 = v347.HumanoidRootPart.CFrame * Pos
                if (v347.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc7) end
            end
        else
            local _mc8 = v347.HumanoidRootPart.CFrame * Pos
            if (v347.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc8) end
        end
    end
	-- goto l0
	-- ::l12::
    if v343:FindFirstChild("Humanoid") and (v343:FindFirstChild("HumanoidRootPart") and (v343.Name == "Ship Steward" or (v343.Name == "Ship Engineer" or (v343.Name == "Ship Deckhand" or v343.Name == "Ship Officer")))) then
		-- goto l11
    else
		-- goto l16
    end
	-- ::l16::
	-- ::l2::
	-- goto l11
end)
spawn(function()
	-- ::l0::
    repeat
        if not wait() then
            return
        end
    until AutoFarmMasDevilFruit and TypeMastery == "Cake"
    pcall(function()
        local v348 = CFrame.new(- 9508.5673828125, 142.1398468017578, 5737.3603515625)
        Tween2(v348)
    end)
    local v349, v350, v351 = pairs(game.Workspace.Enemies:GetChildren())
	-- ::l8::
	-- ::l7::
	-- ::l16::
    if true then
        wait(_G.Fast_Delay)
        if v352.Humanoid.Health > v352.Humanoid.MaxHealth * KillPercent / 100 then
            _G.UseSkill = false
            AutoHaki()
            bringmob = true
            EquipTool(SelectWeapon)
            local _mc9 = v352.HumanoidRootPart.CFrame * Pos
            if (v352.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc9) end
            v352.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
            v352.HumanoidRootPart.Transparency = 1
            v352.Humanoid.JumpPower = 0
            v352.Humanoid.WalkSpeed = 0
            v352.HumanoidRootPart.CanCollide = false
            FarmPos = v352.HumanoidRootPart.CFrame
            MonFarm = v352.Name
            AttackNoCoolDown()
        else
            _G.UseSkill = true
        end
    end
    if AutoFarmMasDevilFruit and (not MasteryType ~= "Cake" and (v352.Parent and (v352.Humanoid.Health ~= 0 and not TypeMastery ~= "Cake"))) then
		-- goto l16
    else
		-- goto l28
    end
	-- ::l28::
    bringmob = false
    _G.UseSkill = false
	-- ::l8::
    local v352
    v351, v352 = v349(v350, v351)
    if v351 ~= nil then
		-- goto l9
    end
    local v353, v354, v355 = pairs(game:GetService("ReplicatedStorage"):GetChildren())
    while true do
        local v356
        v355, v356 = v353(v354, v355)
        if v355 == nil then
            break
        end
        if v356.Name ~= "Cookie Crafter" then
            if v356.Name ~= "Cake Guard" then
                if v356.Name ~= "Baking Staff" then
                    if v356.Name == "Head Baker" then
                        local _mc10 = v356.HumanoidRootPart.CFrame * Pos
                        if (v356.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc10) end
                    end
                else
                    local _mc11 = v356.HumanoidRootPart.CFrame * Pos
                    if (v356.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc11) end
                end
            else
                local _mc12 = v356.HumanoidRootPart.CFrame * Pos
                if (v356.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc12) end
            end
        else
            local _mc13 = v356.HumanoidRootPart.CFrame * Pos
            if (v356.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc13) end
        end
    end
	-- goto l0
	-- ::l9::
    if v352:FindFirstChild("Humanoid") and (v352:FindFirstChild("HumanoidRootPart") and (v352.Name == "Cookie Crafter" or (v352.Name == "Cake Guard" or (v352.Name == "Baking Staff" or v352.Name == "Head Baker")))) then
		-- goto l8
    else
		-- goto l13
    end
	-- ::l13::
	-- ::l2::
	-- goto l8
end)
spawn(function()
	-- ::l0::
    repeat
        if not wait() then
            return
        end
    until AutoFarmMasDevilFruit and TypeMastery == "Level No Quest"
    pcall(function()
        CheckLevel()
        Tween2(CFrameQ)
    end)
    local v357, v358, v359 = pairs(game.Workspace.Enemies:GetChildren())
	-- ::l8::
	-- ::l7::
	-- ::l15::
    if true then
        wait(_G.Fast_Delay)
        if v360.Humanoid.Health > v360.Humanoid.MaxHealth * KillPercent / 100 then
            _G.UseSkill = false
            AutoHaki()
            bringmob = true
            EquipTool(SelectWeapon)
            local _mc14 = v360.HumanoidRootPart.CFrame * Pos
            if (v360.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc14) end
            v360.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
            v360.HumanoidRootPart.Transparency = 1
            v360.Humanoid.JumpPower = 0
            v360.Humanoid.WalkSpeed = 0
            v360.HumanoidRootPart.CanCollide = false
            FarmPos = v360.HumanoidRootPart.CFrame
            MonFarm = v360.Name
            AttackNoCoolDown()
        else
            _G.UseSkill = true
        end
    end
    if AutoFarmMasDevilFruit and (not MasteryType ~= "Level No Quest" and (v360.Parent and (v360.Humanoid.Health ~= 0 and not TypeMastery ~= "Level No Quest"))) then
		-- goto l15
    else
		-- goto l22
    end
	-- ::l22::
    bringmob = false
    _G.UseSkill = false
	-- ::l8::
    local v360
    v359, v360 = v357(v358, v359)
    if v359 == nil then
		-- goto l0
    end
    if v360:FindFirstChild("Humanoid") and (v360:FindFirstChild("HumanoidRootPart") and v360.Name == Ms) then
		-- goto l8
    else
		-- goto l13
    end
	-- ::l13::
	-- ::l2::
	-- goto l8
end)
spawn(function()
	-- ::l0::
    repeat
        repeat
            if not wait() then
                return
            end
        until AutoFarmMasDevilFruit and TypeMastery == "Level"
        pcall(function()
            CheckLevel()
            if not string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                Tween2(CFrameQ)
            end
            if (CFrameQ.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
            end
        end)
    until (string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true) and game:GetService("Workspace").Enemies:FindFirstChild(Ms)
    local v361, v362, v363 = pairs(game:GetService("Workspace").Enemies:GetChildren())
	-- goto l14
	-- ::l7::
	-- goto l21
	-- ::l13::
	-- goto l14
	-- ::l21::
    if true then
        wait(_G.Fast_Delay)
        if v364.Humanoid.Health > v364.Humanoid.MaxHealth * KillPercent / 100 then
            _G.UseSkill = false
            AutoHaki()
            bringmob = true
            EquipTool(SelectWeapon)
            local _mc15 = v364.HumanoidRootPart.CFrame * Pos
            if (v364.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc15) end
            v364.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
            v364.HumanoidRootPart.Transparency = 1
            v364.Humanoid.JumpPower = 0
            v364.Humanoid.WalkSpeed = 0
            v364.HumanoidRootPart.CanCollide = false
            FarmPos = v364.HumanoidRootPart.CFrame
            MonFarm = v364.Name
            AttackNoCoolDown()
        else
            _G.UseSkill = true
        end
    end
    if AutoFarmMasDevilFruit and (not MasteryType ~= "Level" and (v364.Parent and (v364.Humanoid.Health ~= 0 and not TypeMastery ~= "Level"))) then
		-- goto l21
    end
    bringmob = false
    _G.UseSkill = false
	-- ::l14::
    local v364
    v363, v364 = v361(v362, v363)
    if v363 == nil then
		-- goto l0
    end
    if v364:FindFirstChild("Humanoid") and (v364:FindFirstChild("HumanoidRootPart") and v364.Name == Ms) then
		-- goto l28
    else
		-- goto l13
    end
	-- ::l28::
	-- goto l7
end)
spawn(function()
	-- ::l0::
    repeat
        if not wait() then
            return
        end
    until AutoFarmMasDevilFruit and TypeMastery == "Bone"
    pcall(function()
        local v365 = CFrame.new(- 9508.5673828125, 142.1398468017578, 5737.3603515625)
        Tween2(v365)
    end)
    local v366, v367, v368 = pairs(game.Workspace.Enemies:GetChildren())
	-- ::l8::
	-- ::l7::
	-- ::l16::
    if true then
        wait(_G.Fast_Delay)
        if v369.Humanoid.Health > v369.Humanoid.MaxHealth * KillPercent / 100 then
            _G.UseSkill = false
            AutoHaki()
            bringmob = true
            EquipTool(SelectWeapon)
            local _mc16 = v369.HumanoidRootPart.CFrame * Pos
            if (v369.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc16) end
            v369.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
            v369.HumanoidRootPart.Transparency = 1
            v369.Humanoid.JumpPower = 0
            v369.Humanoid.WalkSpeed = 0
            v369.HumanoidRootPart.CanCollide = false
            FarmPos = v369.HumanoidRootPart.CFrame
            MonFarm = v369.Name
            AttackNoCoolDown()
        else
            _G.UseSkill = true
        end
    end
    if AutoFarmMasDevilFruit and (not MasteryType ~= "Bone" and (v369.Parent and (v369.Humanoid.Health ~= 0 and not TypeMastery ~= "Bone"))) then
		-- goto l16
    else
		-- goto l28
    end
	-- ::l28::
    bringmob = false
    _G.UseSkill = false
	-- ::l8::
    local v369
    v368, v369 = v366(v367, v368)
    if v368 ~= nil then
		-- goto l9
    end
    local v370, v371, v372 = pairs(game:GetService("ReplicatedStorage"):GetChildren())
    while true do
        local v373
        v372, v373 = v370(v371, v372)
        if v372 == nil then
            break
        end
        if v373.Name ~= "Reborn Skeleton" then
            if v373.Name ~= "Living Zombie" then
                if v373.Name ~= "Demonic Soul" then
                    if v373.Name == "Posessed Mummy" then
                        local _mc17 = v373.HumanoidRootPart.CFrame * Pos
                        if (v373.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc17) end
                    end
                else
                    local _mc18 = v373.HumanoidRootPart.CFrame * Pos
                    if (v373.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc18) end
                end
            else
                local _mc19 = v373.HumanoidRootPart.CFrame * Pos
                if (v373.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc19) end
            end
        else
            local _mc20 = v373.HumanoidRootPart.CFrame * Pos
            if (v373.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc20) end
        end
    end
	-- goto l0
	-- ::l9::
    if v369:FindFirstChild("Humanoid") and (v369:FindFirstChild("HumanoidRootPart") and (v369.Name == "Reborn Skeleton" or (v369.Name == "Living Zombie" or (v369.Name == "Demonic Soul" or v369.Name == "Posessed Mummy")))) then
		-- goto l8
    else
		-- goto l13
    end
	-- ::l13::
	-- ::l2::
	-- goto l8
end)
spawn(function()
    while task.wait() do
        if _G.UseSkillGun then
            pcall(function()
				-- block 36
                if not _G.UseSkillGun then
					-- ::l3::
                    return
                end
                local v374, v375, v376 = pairs(game:GetService("Workspace").Enemies:GetChildren())
				-- ::l4::
                local v377
                v376, v377 = v374(v375, v376)
                if v376 == nil then
					-- goto l3
                end
                if v377.Name ~= MonFarm or (not v377:FindFirstChild("Humanoid") or (not v377:FindFirstChild("HumanoidRootPart") or v377.Humanoid.Health > v377.Humanoid.MaxHealth * KillPercent / 100)) then
					-- goto l4
                else
					-- goto l13
                end
				-- ::l13::
                game:GetService("RunService").Heartbeat:wait()
                EquipToolGun()
                local _mc21 = v377.HumanoidRootPart.CFrame * Pos
                if (v377.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc21) end
                PositionSkillMasteryGun = v377.HumanoidRootPart.Position
                if SkillZ then
                    game:service("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                    wait()
                    game:service("VirtualInputManager"):SendKeyEvent(false, "Z", false, game)
                end
                if SkillX then
                    game:service("VirtualInputManager"):SendKeyEvent(true, "X", false, game)
                    wait()
                    game:service("VirtualInputManager"):SendKeyEvent(false, "X", false, game)
                end
                if SkillC then
                    game:service("VirtualInputManager"):SendKeyEvent(true, "C", false, game)
                    wait()
                    game:service("VirtualInputManager"):SendKeyEvent(false, "C", false, game)
                end
                if SkillV then
                    game:service("VirtualInputManager"):SendKeyEvent(true, "V", false, game)
                    wait()
                    game:service("VirtualInputManager"):SendKeyEvent(false, "V", false, game)
                end
                if SkillF then
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "F", false, game)
                    wait()
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, "F", false, game)
                end
                if AutoFarmMasGun and (_G.UseSkillGun and v377.Humanoid.Health ~= 0) then
					-- goto l13
                else
					-- goto l4
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if AutoFarmMasGun and TypeMastery == "Near Mob" then
            pcall(function()
                local v378, v379, v380 = pairs(game.Workspace.Enemies:GetChildren())
                while true do
                    local v381
                    v380, v381 = v378(v379, v380)
                    if v380 == nil then
                        return
                    end
                    if v381.Name and (v381:FindFirstChild("Humanoid") and (v381:FindFirstChild("HumanoidRootPart") and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v381:FindFirstChild("HumanoidRootPart").Position).Magnitude <= 5000)) then
                        repeat
                            if true then
                                wait(_G.Fast_Delay)
                                if v381.Humanoid.Health > v381.Humanoid.MaxHealth * KillPercent / 100 then
                                    _G.UseSkillGun = false
                                    AutoHaki()
                                    bringmob = true
                                    EquipTool(SelectWeapon)
                                    local _mc22 = v381.HumanoidRootPart.CFrame * Pos
                                    if (v381.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc22) end
                                    v381.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    v381.HumanoidRootPart.Transparency = 1
                                    v381.Humanoid.JumpPower = 0
                                    v381.Humanoid.WalkSpeed = 0
                                    v381.HumanoidRootPart.CanCollide = false
                                    FarmPos = v381.HumanoidRootPart.CFrame
                                    MonFarm = v381.Name
                                    AttackNoCoolDown()
                                else
                                    _G.UseSkillGun = true
                                end
                            end
                        until not AutoFarmMasGun or (not MasteryType == "Near Mob" or (not v381.Parent or (v381.Humanoid.Health == 0 or not TypeMastery == "Near Mob")))
                        bringmob = false
                        _G.UseSkillGun = false
                    end
                end
            end)
        end
    end
end)
spawn(function()
	-- ::l0::
    repeat
        if not wait() then
            return
        end
    until AutoFarmMasGun and TypeMastery == "Ecto"
    pcall(function()
        local v382 = CFrame.new(904.4072265625, 181.05767822266, 33341.38671875)
        Tween2(v382)
    end)
    if (Vector3.new(904.4072265625, 181.05767822266, 33341.38671875) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
    end
    local v383, v384, v385 = pairs(game:GetService("Workspace").Enemies:GetChildren())
	-- ::l11::
	-- ::l7::
	-- ::l19::
    if true then
        wait(_G.Fast_Delay)
        if v386.Humanoid.Health > v386.Humanoid.MaxHealth * KillPercent / 100 then
            _G.UseSkillGun = false
            AutoHaki()
            bringmob = true
            EquipTool(SelectWeapon)
            local _mc23 = v386.HumanoidRootPart.CFrame * Pos
            if (v386.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc23) end
            v386.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
            v386.HumanoidRootPart.Transparency = 1
            v386.Humanoid.JumpPower = 0
            v386.Humanoid.WalkSpeed = 0
            v386.HumanoidRootPart.CanCollide = false
            FarmPos = v386.HumanoidRootPart.CFrame
            MonFarm = v386.Name
            AttackNoCoolDown()
        else
            _G.UseSkillGun = true
        end
    end
    if AutoFarmMasGun and (not MasteryType ~= "Ecto" and (v386.Parent and (v386.Humanoid.Health ~= 0 and not TypeMastery ~= "Ecto"))) then
		-- goto l19
    else
		-- goto l31
    end
	-- ::l31::
    bringmob = false
    _G.UseSkillGun = false
	-- ::l11::
    local v386
    v385, v386 = v383(v384, v385)
    if v385 ~= nil then
		-- goto l12
    end
    local v387, v388, v389 = pairs(game:GetService("ReplicatedStorage"):GetChildren())
    while true do
        local v390
        v389, v390 = v387(v388, v389)
        if v389 == nil then
            break
        end
        if v390.Name ~= "Ship Steward" then
            if v390.Name ~= "Ship Engineer" then
                if v390.Name ~= "Ship Deckhand" then
                    if v390.Name == "Ship Officer" then
                        local _mc24 = v390.HumanoidRootPart.CFrame * Pos
                        if (v390.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc24) end
                    end
                else
                    local _mc25 = v390.HumanoidRootPart.CFrame * Pos
                    if (v390.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc25) end
                end
            else
                local _mc26 = v390.HumanoidRootPart.CFrame * Pos
                if (v390.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc26) end
            end
        else
            local _mc27 = v390.HumanoidRootPart.CFrame * Pos
            if (v390.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc27) end
        end
    end
	-- goto l0
	-- ::l12::
    if v386:FindFirstChild("Humanoid") and (v386:FindFirstChild("HumanoidRootPart") and (v386.Name == "Ship Steward" or (v386.Name == "Ship Engineer" or (v386.Name == "Ship Deckhand" or v386.Name == "Ship Officer")))) then
		-- goto l11
    else
		-- goto l16
    end
	-- ::l16::
	-- ::l2::
	-- goto l11
end)
spawn(function()
	-- ::l0::
    repeat
        if not wait() then
            return
        end
    until AutoFarmMasGun and TypeMastery == "Cake"
    pcall(function()
        local v391 = CFrame.new(- 1579.9111328125, 329.7358703613281, - 12310.365234375)
        Tween2(v391)
    end)
    local v392, v393, v394 = pairs(game.Workspace.Enemies:GetChildren())
	-- ::l8::
	-- ::l7::
	-- ::l16::
    if true then
        wait(_G.Fast_Delay)
        if v395.Humanoid.Health > v395.Humanoid.MaxHealth * KillPercent / 100 then
            _G.UseSkillGun = false
            AutoHaki()
            bringmob = true
            EquipTool(SelectWeapon)
            local _mc28 = v395.HumanoidRootPart.CFrame * Pos
            if (v395.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc28) end
            v395.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
            v395.HumanoidRootPart.Transparency = 1
            v395.Humanoid.JumpPower = 0
            v395.Humanoid.WalkSpeed = 0
            v395.HumanoidRootPart.CanCollide = false
            FarmPos = v395.HumanoidRootPart.CFrame
            MonFarm = v395.Name
            AttackNoCoolDown()
        else
            _G.UseSkillGun = true
        end
    end
    if AutoFarmMasGun and (not MasteryType ~= "Cake" and (v395.Parent and (v395.Humanoid.Health ~= 0 and not TypeMastery ~= "Cake"))) then
		-- goto l16
    else
		-- goto l28
    end
	-- ::l28::
    bringmob = false
    _G.UseSkillGun = false
	-- ::l8::
    local v395
    v394, v395 = v392(v393, v394)
    if v394 ~= nil then
		-- goto l9
    end
    local v396, v397, v398 = pairs(game:GetService("ReplicatedStorage"):GetChildren())
    while true do
        local v399
        v398, v399 = v396(v397, v398)
        if v398 == nil then
            break
        end
        if v399.Name ~= "Cookie Crafter" then
            if v399.Name ~= "Cake Guard" then
                if v399.Name ~= "Baking Staff" then
                    if v399.Name == "Head Baker" then
                        local _mc29 = v399.HumanoidRootPart.CFrame * Pos
                        if (v399.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc29) end
                    end
                else
                    local _mc30 = v399.HumanoidRootPart.CFrame * Pos
                    if (v399.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc30) end
                end
            else
                local _mc31 = v399.HumanoidRootPart.CFrame * Pos
                if (v399.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc31) end
            end
        else
            local _mc32 = v399.HumanoidRootPart.CFrame * Pos
            if (v399.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc32) end
        end
    end
	-- goto l0
	-- ::l9::
    if v395:FindFirstChild("Humanoid") and (v395:FindFirstChild("HumanoidRootPart") and (v395.Name == "Cookie Crafter" or (v395.Name == "Cake Guard" or (v395.Name == "Baking Staff" or v395.Name == "Head Baker")))) then
		-- goto l8
    else
		-- goto l13
    end
	-- ::l13::
	-- ::l2::
	-- goto l8
end)
spawn(function()
	-- ::l0::
    repeat
        repeat
            if not wait() then
                return
            end
        until AutoFarmMasGun and TypeMastery == "Level"
        pcall(function()
            CheckLevel()
            if not string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                Tween2(CFrameQ)
            end
            if (CFrameQ.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
            end
        end)
    until (string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true) and game:GetService("Workspace").Enemies:FindFirstChild(Ms)
    local v400, v401, v402 = pairs(game:GetService("Workspace").Enemies:GetChildren())
	-- goto l14
	-- ::l7::
	-- goto l21
	-- ::l13::
	-- goto l14
	-- ::l21::
    if true then
        wait(_G.Fast_Delay)
        if v403.Humanoid.Health > v403.Humanoid.MaxHealth * KillPercent / 100 then
            _G.UseSkillGun = false
            AutoHaki()
            bringmob = true
            EquipTool(SelectWeapon)
            local _mc33 = v403.HumanoidRootPart.CFrame * Pos
            if (v403.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc33) end
            v403.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
            v403.HumanoidRootPart.Transparency = 1
            v403.Humanoid.JumpPower = 0
            v403.Humanoid.WalkSpeed = 0
            v403.HumanoidRootPart.CanCollide = false
            FarmPos = v403.HumanoidRootPart.CFrame
            MonFarm = v403.Name
            AttackNoCoolDown()
        else
            _G.UseSkillGun = true
        end
    end
    if AutoFarmMasGun and (not MasteryType ~= "Level" and (v403.Parent and (v403.Humanoid.Health ~= 0 and not TypeMastery ~= "Level"))) then
		-- goto l21
    end
    bringmob = false
    _G.UseSkillGun = false
	-- ::l14::
    local v403
    v402, v403 = v400(v401, v402)
    if v402 == nil then
		-- goto l0
    end
    if v403:FindFirstChild("Humanoid") and (v403:FindFirstChild("HumanoidRootPart") and v403.Name == Ms) then
		-- goto l28
    else
		-- goto l13
    end
	-- ::l28::
	-- goto l7
end)
spawn(function()
	-- ::l0::
    repeat
        if not wait() then
            return
        end
    until AutoFarmMasGun and TypeMastery == "Level No Quest"
    pcall(function()
        CheckLevel()
        Tween2(CFrameQ)
    end)
    local v404, v405, v406 = pairs(game.Workspace.Enemies:GetChildren())
	-- ::l8::
	-- ::l7::
	-- ::l15::
    if true then
        wait(_G.Fast_Delay)
        if v407.Humanoid.Health > v407.Humanoid.MaxHealth * KillPercent / 100 then
            _G.UseSkillGun = false
            AutoHaki()
            bringmob = true
            EquipTool(SelectWeapon)
            local _mc34 = v407.HumanoidRootPart.CFrame * Pos
            if (v407.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc34) end
            v407.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
            v407.HumanoidRootPart.Transparency = 1
            v407.Humanoid.JumpPower = 0
            v407.Humanoid.WalkSpeed = 0
            v407.HumanoidRootPart.CanCollide = false
            FarmPos = v407.HumanoidRootPart.CFrame
            MonFarm = v407.Name
            AttackNoCoolDown()
        else
            _G.UseSkillGun = true
        end
    end
    if AutoFarmMasGun and (not MasteryType ~= "Level No Quest" and (v407.Parent and (v407.Humanoid.Health ~= 0 and not TypeMastery ~= "Level No Quest"))) then
		-- goto l15
    else
		-- goto l22
    end
	-- ::l22::
    bringmob = false
    _G.UseSkillGun = false
	-- ::l8::
    local v407
    v406, v407 = v404(v405, v406)
    if v406 == nil then
		-- goto l0
    end
    if v407:FindFirstChild("Humanoid") and (v407:FindFirstChild("HumanoidRootPart") and v407.Name == Ms) then
		-- goto l8
    else
		-- goto l13
    end
	-- ::l13::
	-- ::l2::
	-- goto l8
end)
spawn(function()
	-- ::l0::
    repeat
        if not wait() then
            return
        end
    until AutoFarmMasGun and TypeMastery == "Bone"
    pcall(function()
        local v408 = CFrame.new(- 9508.5673828125, 142.1398468017578, 5737.3603515625)
        Tween2(v408)
    end)
    local v409, v410, v411 = pairs(game.Workspace.Enemies:GetChildren())
	-- ::l8::
	-- ::l7::
	-- ::l16::
    if true then
        wait(_G.Fast_Delay)
        if v412.Humanoid.Health > v412.Humanoid.MaxHealth * KillPercent / 100 then
            _G.UseSkillGun = false
            AutoHaki()
            bringmob = true
            EquipTool(SelectWeapon)
            local _mc35 = v412.HumanoidRootPart.CFrame * Pos
            if (v412.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc35) end
            v412.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
            v412.HumanoidRootPart.Transparency = 1
            v412.Humanoid.JumpPower = 0
            v412.Humanoid.WalkSpeed = 0
            v412.HumanoidRootPart.CanCollide = false
            FarmPos = v412.HumanoidRootPart.CFrame
            MonFarm = v412.Name
            AttackNoCoolDown()
        else
            _G.UseSkillGun = true
        end
    end
    if AutoFarmMasGun and (not MasteryType ~= "Bone" and (v412.Parent and (v412.Humanoid.Health ~= 0 and not TypeMastery ~= "Bone"))) then
		-- goto l16
    else
		-- goto l28
    end
	-- ::l28::
    bringmob = false
    _G.UseSkillGun = false
	-- ::l8::
    local v412
    v411, v412 = v409(v410, v411)
    if v411 ~= nil then
		-- goto l9
    end
    local v413, v414, v415 = pairs(game:GetService("ReplicatedStorage"):GetChildren())
    while true do
        local v416
        v415, v416 = v413(v414, v415)
        if v415 == nil then
            break
        end
        if v416.Name ~= "Reborn Skeleton" then
            if v416.Name ~= "Living Zombie" then
                if v416.Name ~= "Demonic Soul" then
                    if v416.Name == "Posessed Mummy" then
                        local _mc36 = v416.HumanoidRootPart.CFrame * Pos
                        if (v416.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc36) end
                    end
                else
                    local _mc37 = v416.HumanoidRootPart.CFrame * Pos
                    if (v416.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc37) end
                end
            else
                local _mc38 = v416.HumanoidRootPart.CFrame * Pos
                if (v416.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc38) end
            end
        else
            local _mc39 = v416.HumanoidRootPart.CFrame * Pos
            if (v416.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc39) end
        end
    end
	-- goto l0
	-- ::l9::
    if v412:FindFirstChild("Humanoid") and (v412:FindFirstChild("HumanoidRootPart") and (v412.Name == "Reborn Skeleton" or (v412.Name == "Living Zombie" or (v412.Name == "Demonic Soul" or v412.Name == "Posessed Mummy")))) then
		-- goto l8
    else
		-- goto l13
    end
	-- ::l13::
	-- ::l2::
	-- goto l8
end)
function EquipToolGun()
    pcall(function()
        local v417, v418, v419 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())
        while true do
            local v420
            v419, v420 = v417(v418, v419)
            if v419 == nil then
                break
            end
            if v420.ToolTip == "Gun" and v420:IsA("Tool") then
                local v421 = game.Players.LocalPlayer.Backpack:FindFirstChild(v420.Name)
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(v421)
            end
        end
    end)
end
spawn(function()
    local v422 = getrawmetatable(game)
    local vu423 = v422.__namecall
    setreadonly(v422, false)
    v422.__namecall = newcclosure(function(...)
		-- upvalues: (ref) vu423
        local v424 = getnamecallmethod()
        local v425 = {
            ...
        }
        if tostring(v424) == "FireServer" and (tostring(v425[1]) == "RemoteEvent" and (tostring(v425[2]) ~= "true" and tostring(v425[2]) ~= "false")) then
            if _G.UseSkillGun then
                if type(v425[2]) ~= "vector" then
                    v425[2] = CFrame.new(PositionSkillMasteryGun)
                else
                    v425[2] = PositionSkillMasteryGun
                end
                return vu423(unpack(v425))
            end
            if _G.UseSkill then
                if type(v425[2]) ~= "vector" then
                    v425[2] = CFrame.new(PositionSkillMasteryDevilFruit)
                else
                    v425[2] = PositionSkillMasteryDevilFruit
                end
                return vu423(unpack(v425))
            end
        end
        return vu423(...)
    end)
end)
if Sea3 then
    Tabs.Main:AddSection("Xương")
    local vu426 = Tabs.Main:AddParagraph({
        ["Title"] = "Trạng Thái Xương",
    })
    spawn(function()
		-- upvalues: (ref) vu426
        pcall(function()
			-- upvalues: (ref) vu426
            while wait() do
                local v427 = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Check")
                vu426:SetDesc("Mày Có: " .. tostring(v427) .. " Xương")
            end
        end)
    end)
    Tabs.Main:AddToggle("ToggleBone", {
        ["Title"] = "Cày Xương",
        ["Default"] = false
    }):OnChanged(function(p428)
        _G.AutoBone = p428
        if p428 == false then
            wait()
            Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
            wait()
        end
    end)
    -- [SetValue skipped - Library không cần]
    local vu429 = CFrame.new(-9515.75, 174.8521728515625, 6079.40625)
    spawn(function()
        while wait(0.05) do
            if _G.AutoBone then
                pcall(function()
                    -- Tìm quái xương và đánh
                    local found = false
                    for _, v434 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v434:FindFirstChild("HumanoidRootPart") and v434:FindFirstChild("Humanoid")
                            and v434.Humanoid.Health > 0
                            and (v434.Name == "Reborn Skeleton" or v434.Name == "Living Zombie"
                                or v434.Name == "Demonic Soul" or v434.Name == "Posessed Mummy") then
                            found = true
                            -- Bay mượt đến quái trước (Tween2 không giật)
                            local _bCF0 = v434.HumanoidRootPart.CFrame * Pos
                            local _dist0 = (_bCF0.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            if _dist0 > 30 then
                                Tween2(_bCF0)
                                repeat task.wait(0.05) until
                                    ((v434.HumanoidRootPart.CFrame * Pos).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 30
                                    or not _G.AutoBone or not v434.Parent or v434.Humanoid.Health <= 0
                            end
                            -- Bật hiệu ứng tia lửa + tiếng spam liên tục
                            if not _fxEnabled then _fxEnabled = true; StartFXLoop() end
                            repeat
                                wait(_G.Fast_Delay)
                                AttackNoCoolDown()
                                AutoHaki()
                                bringmob = true
                                EquipTool(SelectWeapon)
                                -- Khi đã gần: BKP snap sát quái
                                local _bCF = v434.HumanoidRootPart.CFrame * Pos
                                if (_bCF.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then
                                    BKP(_bCF)
                                end
                                pcall(function()
                                    v434.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    v434.HumanoidRootPart.Transparency = 1
                                    v434.Humanoid.JumpPower = 0
                                    v434.Humanoid.WalkSpeed = 0
                                    v434.HumanoidRootPart.CanCollide = false
                                    v434.Head.CanCollide = false
                                    v434.Humanoid:ChangeState(11)
                                    v434.Humanoid:ChangeState(14)
                                end)
                                FarmPos = v434.HumanoidRootPart.CFrame
                                MonFarm = v434.Name
                            until not _G.AutoBone or not v434.Parent or v434.Humanoid.Health <= 0
                            bringmob = false
                            break
                        end
                    end
                    if not found then
                        if not _G.OneHitKill and not _G.AutoBoneNoQuest then StopFXLoop() end
                        -- Tween2 mượt về điểm spawn, không giật
                        Tween2(vu429)
                    end
                end)
            else
                if not _G.OneHitKill and not _G.AutoBoneNoQuest and not _G.AutoLevel and not _G.AutoNear then
                    StopFXLoop()
                end
            end
        end
    end)
    local vu435 = CFrame.new(-9515.75, 174.8521728515625, 6079.40625)
    spawn(function()
        while wait(0.05) do
            if _G.AutoBoneNoQuest then
                pcall(function()
                    -- Hủy quest nếu đang có
                    pcall(function()
                        if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                        end
                    end)

                    -- Tìm mob xương gần nhất
                    local nearestMob = nil
                    local nearestDist = math.huge
                    for _, v439 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v439:FindFirstChild("HumanoidRootPart") and v439:FindFirstChild("Humanoid")
                            and v439.Humanoid.Health > 0
                            and (v439.Name == "Reborn Skeleton" or v439.Name == "Living Zombie"
                                or v439.Name == "Demonic Soul" or v439.Name == "Posessed Mummy") then
                            local d = (v439.HumanoidRootPart.Position - vu435.Position).Magnitude
                            if d < nearestDist then
                                nearestDist = d
                                nearestMob = v439
                            end
                        end
                    end

                    if nearestMob then
                        local v439 = nearestMob
                        -- Bay mượt đến quái trước nếu xa (Tween2 không giật)
                        local _bnDist0 = (v439.HumanoidRootPart.CFrame * Pos).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                        if _bnDist0.Magnitude > 30 then
                            Tween2(v439.HumanoidRootPart.CFrame * Pos)
                            repeat task.wait(0.05) until
                                not v439 or not v439.Parent
                                or ((v439.HumanoidRootPart.CFrame * Pos).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 30
                                or not _G.AutoBoneNoQuest
                        end
                        -- Bật hiệu ứng tia lửa + tiếng spam liên tục
                        if not _fxEnabled then _fxEnabled = true; StartFXLoop() end
                        repeat
                            wait(_G.Fast_Delay)
                            if not v439 or not v439.Parent or not v439:FindFirstChild("Humanoid") or not v439:FindFirstChild("HumanoidRootPart") then break end
                            AttackNoCoolDown()
                            AutoHaki()
                            bringmob = true
                            EquipTool(SelectWeapon)
                            -- BKP snap sát quái khi đã gần
                            local _bnCF = v439.HumanoidRootPart.CFrame * Pos
                            if (_bnCF.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then
                                BKP(_bnCF)
                            end
                            pcall(function()
                                v439.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v439.HumanoidRootPart.Transparency = 1
                                v439.Humanoid.JumpPower = 0
                                v439.Humanoid.WalkSpeed = 0
                                v439.HumanoidRootPart.CanCollide = false
                                v439.Head.CanCollide = false
                                v439.Humanoid:ChangeState(11)
                                v439.Humanoid:ChangeState(14)
                            end)
                            FarmPos = v439.HumanoidRootPart.CFrame
                            MonFarm = v439.Name
                        until not _G.AutoBoneNoQuest or v439.Humanoid.Health <= 0 or not v439.Parent
                        bringmob = false
                    else
                        if not _G.OneHitKill and not _G.AutoBone then StopFXLoop() end
                        -- Không có mob → Tween2 về điểm spawn chờ
                        Tween2(vu435)
                    end
                end)
            else
                if not _G.OneHitKill and not _G.AutoBone and not _G.AutoLevel and not _G.AutoNear then
                    StopFXLoop()
                end
            end
        end
    end)
    Tabs.Main:AddButton({
        ["Title"] = "Cầu Nguyện",
        ["Callback"] = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                "gravestoneEvent",
                1
            }))
        end
    })
    Tabs.Main:AddButton({
        ["Title"] = "Thử Vận May",
        ["Callback"] = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                "gravestoneEvent",
                2
            }))
        end
    })
    Tabs.Main:AddToggle("ToggleRandomBone", {
        ["Title"] = "Random Xương",
        ["Default"] = false
    }):OnChanged(function(p440)
        _G.AutoRandomBone = p440
    end)
    -- [SetValue skipped - Library không cần]
    spawn(function()
        while wait() do
            if _G.AutoRandomBone then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "Bones",
                    "Buy",
                    1,
                    1
                }))
            end
        end
    end)
end
if Sea3 then
    Tabs.Main:AddSection("Tư Lệnh Bánh")
    local vu441 = Tabs.Main:AddParagraph({
        ["Title"] = "Trạng Thái Nó Ra",
    })
    spawn(function()
		-- upvalues: (ref) vu441
        while wait() do
            pcall(function()
				-- upvalues: (ref) vu441
                if string.len(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")) ~= 88 then
                    if string.len(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")) ~= 87 then
                        if string.len(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")) ~= 86 then
                            vu441:SetDesc("Tư Lệnh Bánh : \226\156\133\239\184\143")
                        else
                            vu441:SetDesc("C\195\178n: " .. string.sub(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"), 39, 39) .. " ")
                        end
                    else
                        vu441:SetDesc("C\195\178n: " .. string.sub(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"), 39, 40) .. "")
                    end
                else
                    vu441:SetDesc("C\195\178n: " .. string.sub(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"), 39, 41) .. "")
                end
            end)
        end
    end)
    Tabs.Main:AddToggle("ToggleCake", {
        ["Title"] = "Cày Tư Lệnh Bánh",
        ["Default"] = false
    }):OnChanged(function(p442)
        _G.Cake = p442
        if p442 == false then
            wait()
            Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
            wait()
        end
    end)
    -- [SetValue skipped - Library không cần]
    spawn(function()
        while wait() do
            if _G.Cake then
                pcall(function()
                    if game.ReplicatedStorage:FindFirstChild("Cake Prince") or (game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince") or (game.ReplicatedStorage:FindFirstChild("Dough King") or game:GetService("Workspace").Enemies:FindFirstChild("Dough King"))) then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince") or game:GetService("Workspace").Enemies:FindFirstChild("Dough King") then
                            local v443, v444, v445 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                            while true do
                                local v446
                                v445, v446 = v443(v444, v445)
                                if v445 == nil then
                                    break
                                end
                                if v446.Name == "Cake Prince" or v446.Name == "Dough King" then
                                    repeat
                                        wait(_G.Fast_Delay)
                                        AutoHaki()
                                        EquipTool(SelectWeapon)
                                        v446.HumanoidRootPart.CanCollide = false
                                        v446.Humanoid.WalkSpeed = 0
                                        v446.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                        local _mc40 = v446.HumanoidRootPart.CFrame * Pos
                                        if (v446.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc40) end
                                        AttackNoCoolDown()
                                    until _G.Cake == false or (not v446.Parent or v446.Humanoid.Health <= 0)
                                end
                            end
                        else
                            Tween2(CFrame.new(- 2009.2802734375, 4532.97216796875, - 14937.3076171875))
                        end
                    elseif game.Workspace.Enemies:FindFirstChild("Baking Staff") or (game.Workspace.Enemies:FindFirstChild("Head Baker") or (game.Workspace.Enemies:FindFirstChild("Cake Guard") or game.Workspace.Enemies:FindFirstChild("Cookie Crafter"))) then
                        local v447, v448, v449 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                        while true do
                            local v450
                            v449, v450 = v447(v448, v449)
                            if v449 == nil then
                                break
                            end
                            if (v450.Name == "Baking Staff" or (v450.Name == "Head Baker" or (v450.Name == "Cake Guard" or v450.Name == "Cookie Crafter"))) and v450.Humanoid.Health > 0 then
                                repeat
                                    wait(_G.Fast_Delay)
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    bringmob = true
                                    v450.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    POSCAKE = v450.HumanoidRootPart.CFrame
                                    local _mc41 = v450.HumanoidRootPart.CFrame * Pos
                                    if (v450.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc41) end
                                    AttackNoCoolDown()
                                until _G.Cake == false or (game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince") or (game:GetService("ReplicatedStorage"):FindFirstChild("Dough King") or (not v450.Parent or v450.Humanoid.Health <= 0)))
                            end
                        end
                    else
                        bringmob = false
                        Tween2(CFrame.new(- 1579.9111328125, 329.7358703613281, - 12310.365234375))
                    end
                end)
            end
        end
    end)
    spawn(function()
        game:GetService("RunService").Heartbeat:Connect(function()
            pcall(function()
                local v451, v452, v453 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                while true do
                    local v454
                    v453, v454 = v451(v452, v453)
                    if v453 == nil then
                        break
                    end
                    if _G.Cake and (bringmob and (v454.Name == "Cookie Crafter" or (v454.Name == "Cake Guard" or (v454.Name == "Baking Staff" or v454.Name == "Head Baker")))) and (v454.HumanoidRootPart.Position - POSCAKE.Position).magnitude <= 350 then
                        v454.HumanoidRootPart.CFrame = POSCAKE
                        v454.HumanoidRootPart.CanCollide = false
                        v454.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                        if v454.Humanoid:FindFirstChild("Animator") then
                            v454.Humanoid.Animator:Destroy()
                        end
                        sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                    end
                end
            end)
        end)
    end)
    spawn(function()
        while wait() do
            if _G.Cake then
                pcall(function()
                    if game.ReplicatedStorage:FindFirstChild("Cake Prince") or (game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince") or (game.ReplicatedStorage:FindFirstChild("Dough King") or game:GetService("Workspace").Enemies:FindFirstChild("Dough King"))) then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince") or game:GetService("Workspace").Enemies:FindFirstChild("Dough King") then
                            local v455, v456, v457 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                            while true do
                                local v458
                                v457, v458 = v455(v456, v457)
                                if v457 == nil then
                                    break
                                end
                                if v458.Name == "Cake Prince" or v458.Name == "Dough King" then
                                    repeat
                                        wait(_G.Fast_Delay)
                                        AutoHaki()
                                        EquipTool(SelectWeapon)
                                        v458.HumanoidRootPart.CanCollide = false
                                        v458.Humanoid.WalkSpeed = 0
                                        v458.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                        local _mc42 = v458.HumanoidRootPart.CFrame * Pos
                                        if (v458.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc42) end
                                        AttackNoCoolDown()
                                    until _G.Cake == false or (not v458.Parent or v458.Humanoid.Health <= 0)
                                end
                            end
                        else
                            Tween2(CFrame.new(- 2009.2802734375, 4532.97216796875, - 14937.3076171875))
                        end
                    elseif game.Workspace.Enemies:FindFirstChild("Baking Staff") or (game.Workspace.Enemies:FindFirstChild("Head Baker") or (game.Workspace.Enemies:FindFirstChild("Cake Guard") or game.Workspace.Enemies:FindFirstChild("Cookie Crafter"))) then
                        local v459, v460, v461 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                        while true do
                            local v462
                            v461, v462 = v459(v460, v461)
                            if v461 == nil then
                                break
                            end
                            if (v462.Name == "Baking Staff" or (v462.Name == "Head Baker" or (v462.Name == "Cake Guard" or v462.Name == "Cookie Crafter"))) and v462.Humanoid.Health > 0 then
                                repeat
                                    wait(_G.Fast_Delay)
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    bringmob = true
                                    v462.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    POSCAKE = v462.HumanoidRootPart.CFrame
                                    local _mc43 = v462.HumanoidRootPart.CFrame * Pos
                                    if (v462.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc43) end
                                    AttackNoCoolDown()
                                until _G.Cake == false or (game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince") or (game:GetService("ReplicatedStorage"):FindFirstChild("Dough King") or (not v462.Parent or v462.Humanoid.Health <= 0)))
                            end
                        end
                    else
                        bringmob = false
                        Tween2(CFrame.new(- 1579.9111328125, 329.7358703613281, - 12310.365234375))
                    end
                end)
            end
        end
    end)
    Tabs.Main:AddToggle("ToggleSpawnCake", {
        ["Title"] = "Triệu Hồi Tư Lệnh Bánh",
        ["Default"] = true
    }):OnChanged(function(p463)
        _G.SpawnCakePrince = p463
    end)
    -- [SetValue skipped - Library không cần]
end
spawn(function()
    while wait() do
        if _G.SpawnCakePrince then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                "CakePrinceSpawner",
                true
            }))
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                "CakePrinceSpawner"
            }))
        end
    end
end)
if Sea2 then
    Tabs.Main:AddSection("Ectoplasm Farm")
    Tabs.Main:AddToggle("ToggleVatChatKiDi", {
        ["Title"] = "Auto Farm Ectoplasm",
        ["Default"] = false
    }):OnChanged(function(p464)
        _G.Ectoplasm = p464
    end)
    -- [SetValue skipped - Library không cần]
    spawn(function()
        while wait() do
            pcall(function()
                if _G.Ectoplasm then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Ship Deckhand") or (game:GetService("Workspace").Enemies:FindFirstChild("Ship Engineer") or (game:GetService("Workspace").Enemies:FindFirstChild("Ship Steward") or game:GetService("Workspace").Enemies:FindFirstChild("Ship Officer"))) then
                        local v465, v466, v467 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                        while true do
                            local v468
                            v467, v468 = v465(v466, v467)
                            if v467 == nil then
                                break
                            end
                            if (v468.Name == "Ship Steward" or (v468.Name == "Ship Engineer" or (v468.Name == "Ship Deckhand" or v468.Name == "Ship Officer" and v468:FindFirstChild("Humanoid")))) and v468.Humanoid.Health > 0 then
                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCoolDown()
                                    AutoHaki()
                                    bringmob = true
                                    EquipTool(SelectWeapon)
                                    local _mc44 = v468.HumanoidRootPart.CFrame * Pos
                                    if (v468.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc44) end
                                    v468.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    v468.HumanoidRootPart.Transparency = 1
                                    v468.Humanoid.JumpPower = 0
                                    v468.Humanoid.WalkSpeed = 0
                                    v468.HumanoidRootPart.CanCollide = false
                                    FarmPos = v468.HumanoidRootPart.CFrame
                                    MonFarm = v468.Name
                                until _G.Ectoplasm == false or (not v468.Parent or v468.Humanoid.Health == 0) or not game:GetService("Workspace").Enemies:FindFirstChild(v468.Name)
                                bringmob = false
                            end
                        end
                    else
                        if (Vector3.new(904.4072265625, 181.05767822266, 33341.38671875) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                        end
                        Tween2(CFrame.new(904.4072265625, 181.05767822266, 33341.38671875))
                    end
                end
            end)
        end
    end)
end
Tabs.Main:AddSection("Trùm")
if Sea1 then
    tableBoss = {
        "The Gorilla King",
        "Bobby",
        "Yeti",
        "Mob Leader",
        "Vice Admiral",
        "Warden",
        "Chief Warden",
        "Swan",
        "Magma Admiral",
        "Fishman Lord",
        "Wysper",
        "Thunder God",
        "Cyborg",
        "Saber Expert"
    }
elseif Sea2 then
    tableBoss = {
        "Diamond",
        "Jeremy",
        "Fajita",
        "Don Swan",
        "Smoke Admiral",
        "Cursed Captain",
        "Darkbeard",
        "Order",
        "Awakened Ice Admiral",
        "Tide Keeper"
    }
elseif Sea3 then
    tableBoss = {
        "Stone",
        "Hydra Leader",
        "Kilo Admiral",
        "Captain Elephant",
        "Beautiful Pirate",
        "rip_indra True Form",
        "Longma",
        "Soul Reaper",
        "Cake Queen"
    }
end
local v469 = Tabs.Main:AddDropdown("DropdownBoss", {
    ["Title"] = "Chọn Trùm",
    ["Values"] = tableBoss,
    ["Multi"] = false,
    ["Default"] = 1
})
v469:SetValue(_G.SelectBoss)
v469:OnChanged(function(p470)
    _G.SelectBoss = p470
end)
Tabs.Main:AddToggle("ToggleAutoFarmBoss", {
    ["Title"] = "Đánh Trùm",
    ["Default"] = false
}):OnChanged(function(p471)
    _G.AutoBoss = p471
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        if _G.AutoBoss then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild(_G.SelectBoss) then
                    local v472, v473, v474 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                    while true do
                        local v475
                        v474, v475 = v472(v473, v474)
                        if v474 == nil then
                            break
                        end
                        if v475.Name == _G.SelectBoss and (v475:FindFirstChild("Humanoid") and (v475:FindFirstChild("HumanoidRootPart") and v475.Humanoid.Health > 0)) then
                            repeat
                                wait(_G.Fast_Delay)
                                AttackNoCoolDown()
                                AutoHaki()
                                EquipTool(SelectWeapon)
                                v475.HumanoidRootPart.CanCollide = false
                                v475.Humanoid.WalkSpeed = 0
                                v475.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                local _mc45 = v475.HumanoidRootPart.CFrame * Pos
                                if (v475.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc45) end
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            until not _G.AutoBoss or (not v475.Parent or v475.Humanoid.Health <= 0)
                        end
                    end
                elseif game:GetService("ReplicatedStorage"):FindFirstChild(_G.SelectBoss) then
                    local _mc_boss = game:GetService("ReplicatedStorage"):FindFirstChild(_G.SelectBoss)
                    if _mc_boss and (_mc_boss.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then
                        BKP(_mc_boss.HumanoidRootPart.CFrame * Pos)
                    end
                end
            end)
        end
    end
end)
Tabs.Main:AddSection("Nguyên Liậu")
if Sea1 then
    MaterialList = {
        "Scrap Metal",
        "Leather",
        "Angel Wings",
        "Magma Ore",
        "Fish Tail"
    }
elseif Sea2 then
    MaterialList = {
        "Scrap Metal",
        "Leather",
        "Radioactive Material",
        "Mystic Droplet",
        "Magma Ore",
        "Vampire Fang"
    }
elseif Sea3 then
    MaterialList = {
        "Scrap Metal",
        "Leather",
        "Demonic Wisp",
        "Conjured Cocoa",
        "Dragon Scale",
        "Gunpowder",
        "Fish Tail",
        "Mini Tusk",
        "Hydra Enforcer",
        "Venomous Assailant"
    }
end
local v476 = Tabs.Main:AddDropdown("DropdownMaterial", {
    ["Title"] = "Chọn Nguyên Liệu",
    ["Values"] = MaterialList,
    ["Multi"] = false,
    ["Default"] = 1
})
v476:SetValue(SelectMaterial)
v476:OnChanged(function(p477)
    SelectMaterial = p477
end)
Tabs.Main:AddToggle("ToggleMaterial", {
    ["Title"] = "Cày Nguyên Liệu",
    ["Default"] = false
}):OnChanged(function(p478)
    _G.AutoMaterial = p478
    if p478 == false then
        wait()
        Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
        wait()
    end
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while task.wait() do
        if _G.AutoMaterial then
            pcall(function()
                MaterialMon(SelectMaterial)
                Tween2(MPos)
                if game:GetService("Workspace").Enemies:FindFirstChild(MMon) then
                    local v479, v480, v481 = pairs(game.Workspace.Enemies:GetChildren())
                    while true do
                        local v482
                        v481, v482 = v479(v480, v481)
                        if v481 == nil then
                            break
                        end
                        if v482:FindFirstChild("Humanoid") and (v482:FindFirstChild("HumanoidRootPart") and (v482.Humanoid.Health > 0 and v482.Name == MMon)) then
                            repeat
                                wait(_G.Fast_Delay)
                                AttackNoCoolDown()
                                AutoHaki()
                                bringmob = true
                                EquipTool(SelectWeapon)
                                local _mc46 = v482.HumanoidRootPart.CFrame * Pos
                                if (v482.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc46) end
                                v482.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v482.HumanoidRootPart.Transparency = 1
                                v482.Humanoid.JumpPower = 0
                                v482.Humanoid.WalkSpeed = 0
                                v482.HumanoidRootPart.CanCollide = false
                                FarmPos = v482.HumanoidRootPart.CFrame
                                MonFarm = v482.Name
                            until not _G.AutoMaterial or (not v482.Parent or v482.Humanoid.Health <= 0)
                            bringmob = false
                        end
                    end
                else
                    local v483, v484, v485 = pairs(game:GetService("Workspace")._WorldOrigin.EnemySpawns:GetChildren())
                    while true do
                        local v486
                        v485, v486 = v483(v484, v485)
                        if v485 == nil then
                            break
                        end
                        if string.find(v486.Name, Mon) and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v486.Position).Magnitude >= 10 then
                            local _mc47 = v486.HumanoidRootPart.CFrame * Pos
                            if (v486.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc47) end
                        end
                    end
                end
            end)
        end
    end
end)
if Sea3 then
    Tabs.Sea:AddSection("Đảo Cáo")
    local vu487 = Tabs.Sea:AddParagraph({
        ["Title"] = "Trạng Thái Đảo Cáo",
    })
    function UpdateKitsune()
		-- upvalues: (ref) vu487
        if game.Workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island") then
            vu487:SetDesc("Đảo Cáo : \226\156\133\239\184\143")
        else
            vu487:SetDesc("Đảo Cáo : \226\157\140\239\184\143")
        end
    end
    spawn(function()
        pcall(function()
            while wait() do
                UpdateKitsune()
            end
        end)
    end)
    Tabs.Sea:AddToggle("ToggleTPKitsune", {
        ["Title"] = "Bay V\195\180 Đảo Cáo",
        ["Default"] = false
    }):OnChanged(function(p488)
        _G.TweenToKitsune = p488
    end)
    -- [SetValue skipped - Library không cần]
    spawn(function()
        local v489 = nil
        while not v489 do
            v489 = game:GetService("Workspace").Map:FindFirstChild("KitsuneIsland")
            wait(1)
        end
        while wait() do
            if _G.TweenToKitsune then
                local v490 = v489:FindFirstChild("ShrineActive")
                if v490 then
                    local v491, v492, v493 = pairs(v490:GetDescendants())
                    while true do
                        local v494
                        v493, v494 = v491(v492, v493)
                        if v493 == nil then
                            break
                        end
                        if v494:IsA("BasePart") and v494.Name:find("NeonShrinePart") then
                            Tween2(v494.CFrame)
                        end
                    end
                end
            end
        end
    end)
    Tabs.Sea:AddToggle("ToggleCollectAzure", {
        ["Title"] = "Nh\225\186\183t Linh Hỗn",
        ["Default"] = false
    }):OnChanged(function(p495)
        _G.CollectAzure = p495
    end)
    -- [SetValue skipped - Library không cần]
    spawn(function()
        while wait() do
            if _G.CollectAzure then
                pcall(function()
                    if game:GetService("Workspace"):FindFirstChild("AttachedAzureEmber") then
                        Tween2(game:GetService("Workspace"):WaitForChild("EmberTemplate"):FindFirstChild("Part").CFrame)
                    end
                end)
            end
        end
    end)
    Tabs.Sea:AddButton({
        ["Title"] = "\239\191\189\225\187\149i Linh Hỗn",
        ["Callback"] = function()
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/KitsuneStatuePray"):InvokeServer()
        end
    })
    Tabs.Sea:AddSection("Biển")
    local vu496 = game:GetService("Players")
    local vu497 = game:GetService("RunService")
    local vu498 = game:GetService("VirtualInputManager")
    local vu499 = game:GetService("Workspace")
    local v500 = vu496.LocalPlayer
    local vu501 = v500.Character or v500.CharacterAdded:Wait()
    local vu502 = 350
    local vu503 = 3000
    local vu504 = Vector3.new(- 16665.191, 104.596, 1579.694)
    local vu505 = {
        80,
        - 50,
        - 80,
        50
    }
    local vu506 = 1
    local function vu513()
		-- upvalues: (ref) vu499, (ref) vu501
        local v507, v508, v509 = pairs(vu499.Boats:GetChildren())
        while true do
            local v510
            v509, v510 = v507(v508, v509)
            if v509 == nil then
                break
            end
            local v511 = v510:FindFirstChild("VehicleSeat")
            if v511 then
                local v512 = vu501
                if v511.Occupant == v512:FindFirstChild("Humanoid") then
                    return v510
                end
            end
        end
        return nil
    end
    vu497.RenderStepped:Connect(function()
		-- upvalues: (ref) vu501, (ref) vu504, (ref) vu503, (ref) vu513, (ref) vu505, (ref) vu506
        if vu501 and vu501.PrimaryPart then
            local v514 = (vu501.PrimaryPart.Position - vu504).Magnitude
            if vu503 <= math.floor(v514 / 10) then
                local v515 = vu513()
                if v515 and v515.PrimaryPart then
                    local v516 = vu505[vu506]
                    v515:SetPrimaryPartCFrame(v515.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(v516), 0))
                    vu506 = vu506 + 1
                    if vu506 > # vu505 then
                        vu506 = 1
                    end
                    vu503 = vu503 + 1000
                end
            end
        end
    end)
    local vu517 = {}
    local vu518 = false
    local vu519 = false
    local v520 = {
        ["Prehistoric"] = {
            "ShipwreckIsland",
            "SandIsland",
            "TreeIsland",
            "TinyIsland",
            "MysticIsland",
            "KitsuneIsland",
            "FrozenDimension"
        },
        ["Mirage"] = {
            "ShipwreckIsland",
            "SandIsland",
            "TreeIsland",
            "TinyIsland",
            "PrehistoricIsland",
            "KitsuneIsland",
            "FrozenDimension"
        },
        ["Frozen"] = {
            "ShipwreckIsland",
            "SandIsland",
            "TreeIsland",
            "TinyIsland",
            "MysticIsland",
            "KitsuneIsland",
            "PrehistoricIsland"
        }
    }
    local function v555(p521, pu522, pu523, pu524, pu525)
		-- upvalues: (ref) vu3, (ref) vu4, (ref) vu497, (ref) vu519, (ref) vu501, (ref) vu518, (ref) vu517, (ref) vu499, (ref) vu502, (ref) vu498, (ref) vu1
        local v526 = Tabs.Sea:AddToggle(pu522, {
            ["Title"] = p521,
            ["Default"] = false
        })
        -- toggle default is false
        v526:OnChanged(function(p527)
			-- upvalues: (ref) pu522
            _G[pu522] = p527
        end)
        vu497.RenderStepped:Connect(function()
			-- upvalues: (ref) pu522, (ref) vu519, (ref) vu501, (ref) vu518, (ref) vu517, (ref) vu499, (ref) vu502, (ref) vu498, (ref) pu523, (ref) pu524, (ref) vu1, (ref) pu525
            if _G[pu522] then
                local v528 = vu501:FindFirstChild("Humanoid")
                if v528 then
                    local function v533()
						-- upvalues: (ref) vu518, (ref) vu517
                        if vu518 then
                            return
                        end
                        vu518 = true
                        local v529, v530, v531 = pairs(vu517)
                        while true do
                            local v532
                            v531, v532 = v529(v530, v531)
                            if v531 == nil then
                                break
                            end
                            if v532 and (v532.Parent and (v532.Name == "VehicleSeat" and not v532.Occupant)) then
                                Tween2(v532.CFrame)
                                break
                            end
                        end
                        vu518 = false
                    end
                    local v534, v535, v536 = pairs(vu499.Boats:GetChildren())
                    local v537 = false
                    local v538 = nil
                    while true do
                        local v539
                        v536, v539 = v534(v535, v536)
                        if v536 == nil then
                            break
                        end
                        local v540 = v539:FindFirstChild("VehicleSeat")
                        if v540 then
                            if v540.Occupant ~= v528 then
                                if v540.Occupant == nil then
                                    v533()
                                end
                            else
                                vu517[v539.Name] = v540
                                v538 = v540
                                v537 = true
                            end
                        end
                    end
                    if v537 then
                        v538.MaxSpeed = vu502
                        v538.CFrame = CFrame.new(v538.Position) * v538.CFrame.Rotation
                        vu498:SendKeyEvent(true, "W", false, game)
                        local v541, v542, v543 = pairs(vu499.Boats:GetDescendants())
                        while true do
                            local v544
                            v543, v544 = v541(v542, v543)
                            if v543 == nil then
                                break
                            end
                            if v544:IsA("BasePart") then
                                v544.CanCollide = false
                            end
                        end
                        local v545 = vu501
                        local v546, v547, v548 = pairs(v545:GetDescendants())
                        while true do
                            local v549
                            v548, v549 = v546(v547, v548)
                            if v548 == nil then
                                break
                            end
                            if v549:IsA("BasePart") then
                                v549.CanCollide = false
                            end
                        end
                        local v550, v551, v552 = ipairs(pu523)
                        while true do
                            local v553
                            v552, v553 = v550(v551, v552)
                            if v552 == nil then
                                break
                            end
                            local v554 = vu499.Map:FindFirstChild(v553)
                            if v554 and v554:IsA("Model") then
                                v554:Destroy()
                            end
                        end
                        if vu499.Map:FindFirstChild(pu524) then
                            vu498:SendKeyEvent(false, "W", false, game)
                            _G[pu522] = false
                            if not vu519 then
                                Library:Notify({
                                    ["Title"] = "Strix",
                                    ["Description"] = pu525,
                                    ["Duration"] = 10
                                })
                                vu519 = true
                            end
                        end
                    end
                else
                    return
                end
            else
                vu519 = false
                return
            end
        end)
    end
    v555("Tìm Đảo Dung Nham", "AutoFindPrehistoric", v520.Prehistoric, "PrehistoricIsland", "Đảo Dung Nham Tìm Thấy")
    v555("Tìm Đảo Bí \225\186\168n", "AutoFindMirage", v520.Mirage, "MysticIsland", "Đảo Bí \225\186\168n Tìm Thấy")
    v555("Tìm Đảo Leviathan", "AutoFindFrozen", v520.Frozen, "FrozenDimension", "Đảo Leviathan Tìm Thấy")
    Tabs.Sea:AddToggle("AutoComeTiki", {
        ["Title"] = "Lái Thuyền Về Đảo Tiki",
        ["Default"] = false
    }):OnChanged(function(p556)
        _G.AutoComeTiki = p556
    end)
    vu497.RenderStepped:Connect(function()
		-- upvalues: (ref) vu496, (ref) vu499, (ref) vu502, (ref) vu497, (ref) vu498
        if not _G.AutoComeTiki then
            return
        end
        local v557 = vu496.LocalPlayer.Character
        if not (v557 and v557:FindFirstChild("Humanoid")) then
            return
        end
        local v558 = v557.Humanoid
        local v559, v560, v561 = pairs(vu499.Boats:GetChildren())
        local v562 = nil
        while true do
            local v563
            v561, v563 = v559(v560, v561)
            if v561 == nil then
                v564 = v562
                break
            end
            local v564 = v563:FindFirstChild("VehicleSeat")
            if v564 and v564.Occupant == v558 then
                break
            end
        end
        if v564 then
            v564.MaxSpeed = vu502
            local v565 = CFrame.new(- 16217.7568359375, 9.126761436462402, 446.06536865234375)
            local v566 = v564.Position
            local v567 = v565.Position
            local v568 = (v567 - v566).unit * v564.MaxSpeed * vu497.RenderStepped:Wait()
            v564.CFrame = v564.CFrame + v568
            CFrame.new(v566, v567)
            v564.CFrame = CFrame.new(v564.Position, v567)
            if (v564.Position - v567).magnitude < 120 then
                _G.AutoComeTiki = false
                vu498:SendKeyEvent(false, "W", false, game)
            end
        end
    end)
    Tabs.Sea:AddToggle("AutoComeHydra", {
        ["Title"] = "Lái Thuyền Về Đảo Hydra",
        ["Default"] = false
    }):OnChanged(function(p569)
        _G.AutoComeHydra = p569
    end)
    vu497.RenderStepped:Connect(function()
		-- upvalues: (ref) vu496, (ref) vu499, (ref) vu502, (ref) vu497, (ref) vu498
        if not _G.AutoComeHydra then
            return
        end
        local v570 = vu496.LocalPlayer.Character
        if not (v570 and v570:FindFirstChild("Humanoid")) then
            return
        end
        local v571 = v570.Humanoid
        local v572, v573, v574 = pairs(vu499.Boats:GetChildren())
        local v575 = nil
        while true do
            local v576
            v574, v576 = v572(v573, v574)
            if v574 == nil then
                v577 = v575
                break
            end
            local v577 = v576:FindFirstChild("VehicleSeat")
            if v577 and v577.Occupant == v571 then
                break
            end
        end
        if v577 then
            v577.MaxSpeed = vu502
            local v578 = CFrame.new(5193.9375, - 0.04690289497375488, 1631.578369140625)
            local v579 = v577.Position
            local v580 = v578.Position
            local v581 = (v580 - v579).unit * v577.MaxSpeed * vu497.RenderStepped:Wait()
            v577.CFrame = v577.CFrame + v581
            CFrame.new(v579, v580)
            v577.CFrame = CFrame.new(v577.Position, v580)
            if (v577.Position - v580).magnitude < 120 then
                _G.AutoComeHydra = false
                vu498:SendKeyEvent(false, "W", false, game)
            end
        end
    end)
    Tabs.Sea:AddButton({
        ["Title"] = "Bay Đến Khu Vực Săn",
        ["Callback"] = function()
            Tween2(CFrame.new(- 16917.154296875, 7.757596015930176, 511.8203125))
        end
    })
    local vu582 = {}
    local v583 = Tabs.Sea:AddDropdown("DropdownBoat", {
        ["Title"] = "Chọn Thuyền",
        ["Values"] = {
            "Beast Hunter",
            "Sleigh",
            "Miracle",
            "The Sentinel",
            "Guardian",
            "Lantern",
            "Dinghy",
            "PirateSloop",
            "PirateBrigade",
            "PirateGrandBrigade",
            "MarineGrandBrigade",
            "MarineBrigade",
            "MarineSloop"
        },
        ["Multi"] = false,
        ["Default"] = 1
    })
    v583:SetValue(selectedBoat)
    v583:OnChanged(function(p584)
        selectedBoat = p584
    end)
    local function vu591(pu585)
		-- upvalues: (ref) vu499, (ref) vu582
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
            "BuyBoat",
            pu585
        }))
        task.delay(2, function()
			-- upvalues: (ref) vu499, (ref) pu585, (ref) vu582
            local v586, v587, v588 = pairs(vu499.Boats:GetChildren())
            while true do
                local v589
                v588, v589 = v586(v587, v588)
                if v588 == nil then
                    break
                end
                if v589:IsA("Model") and v589.Name == pu585 then
                    local v590 = v589:FindFirstChild("VehicleSeat")
                    if v590 and not v590.Occupant then
                        vu582[pu585] = v590
                    end
                end
            end
        end)
    end
    local function vu596()
		-- upvalues: (ref) vu582
        local v592, v593, v594 = pairs(vu582)
        while true do
            local v595
            v594, v595 = v592(v593, v594)
            if v594 == nil then
                break
            end
            if v595 and (v595.Parent and (v595.Name == "VehicleSeat" and not v595.Occupant)) then
                Tween2(v595.CFrame)
            end
        end
    end
    game:GetService("RunService").RenderStepped:Connect(function()
		-- upvalues: (ref) vu582
        local v597, v598, v599 = pairs(vu582)
        while true do
            local v600
            v599, v600 = v597(v598, v599)
            if v599 == nil then
                break
            end
            if v600 and (v600.Parent and (v600.Name == "VehicleSeat" and not v600.Occupant)) then
                vu582[v599] = v600
            end
        end
    end)
    Tabs.Sea:AddButton({
        ["Title"] = "Mua Thuyền",
        ["Callback"] = function()
			-- upvalues: (ref) vu591
            vu591(selectedBoat)
        end
    })
    Tabs.Sea:AddButton({
        ["Title"] = "Bay Đến Thuyền",
        ["Description"] = "Duy Nhất Thuyền Bạn Mua \225\187\158 Chợ Chồn",
        ["Callback"] = function()
			-- upvalues: (ref) vu596
            vu596()
        end
    })
    Tabs.Sea:AddToggle("ToggleTerrorshark", {
        ["Title"] = "Đánh Cá Mập",
        ["Default"] = false
    }):OnChanged(function(p601)
        _G.AutoTerrorshark = p601
    end)
    -- [SetValue skipped - Library không cần]
    _G.IsFlying = false
    spawn(function()
        while wait() do
            if _G.AutoTerrorshark then
                pcall(function()
                    local v602 = game.Players.LocalPlayer.Character
                    if v602 and v602:FindFirstChild("Humanoid") then
                        if v602.Humanoid.Health < 6000 and not _G.IsFlying then
                            _G.IsFlying = true
                            Tween2(CFrame.new(v602.HumanoidRootPart.Position.X, 360, v602.HumanoidRootPart.Position.Z))
                        end
                        if _G.IsFlying and v602.Humanoid.Health >= 8000 then
                            _G.IsFlying = false
                        end
                        if not _G.IsFlying and v602.Humanoid.Health >= 8000 then
                            if game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") then
                                local v603, v604, v605 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                                while true do
                                    local v606
                                    v605, v606 = v603(v604, v605)
                                    if v605 == nil then
                                        break
                                    end
                                    if v606.Name == "Terrorshark" and (v606:FindFirstChild("Humanoid") and (v606:FindFirstChild("HumanoidRootPart") and v606.Humanoid.Health > 0)) then
                                        while true do
                                            wait(_G.Fast_Delay)
                                            if v602.Humanoid.Health < 6000 then
                                                _G.IsFlying = true
                                                Tween2(CFrame.new(v602.HumanoidRootPart.Position.X, 360, v602.HumanoidRootPart.Position.Z))
                                                break
                                            end
                                            AttackNoCoolDown()
                                            AutoHaki()
                                            EquipTool(SelectWeapon)
                                            v606.HumanoidRootPart.CanCollide = false
                                            v606.Humanoid.WalkSpeed = 0
                                            v606.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                            local _mc48 = v606.HumanoidRootPart.CFrame * Pos
                                            if (v606.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc48) end
                                            if not _G.AutoTerrorshark or (not v606.Parent or (v606.Humanoid.Health <= 0 or _G.IsFlying)) then
                                                break
                                            end
                                        end
                                    end
                                end
                            elseif game:GetService("ReplicatedStorage"):FindFirstChild("Terrorshark") then
                                local _mc_rs = game:GetService("ReplicatedStorage"):FindFirstChild("Terrorshark") and game:GetService("ReplicatedStorage"):FindFirstChild("Terrorshark").HumanoidRootPart.CFrame * Pos or nil
                                if _mc_rs and (_mc_rs.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc_rs) end
                            end
                        end
                    end
                end)
            end
        end
    end)
    Tabs.Sea:AddToggle("TogglePiranha", {
        ["Title"] = "Đánh Piranha",
        ["Default"] = false
    }):OnChanged(function(p607)
        _G.farmpiranya = p607
    end)
    -- [SetValue skipped - Library không cần]
    spawn(function()
        while wait() do
            if _G.farmpiranya then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Piranha") then
                        local v608, v609, v610 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                        while true do
                            local v611
                            v610, v611 = v608(v609, v610)
                            if v610 == nil then
                                break
                            end
                            if v611.Name == "Piranha" and (v611:FindFirstChild("Humanoid") and (v611:FindFirstChild("HumanoidRootPart") and v611.Humanoid.Health > 0)) then
                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCoolDown()
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    v611.HumanoidRootPart.CanCollide = false
                                    v611.Humanoid.WalkSpeed = 0
                                    v611.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    local _mc49 = v611.HumanoidRootPart.CFrame * Pos
                                    if (v611.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc49) end
                                until not _G.farmpiranya or (not v611.Parent or v611.Humanoid.Health <= 0)
                            end
                        end
                    elseif game:GetService("ReplicatedStorage"):FindFirstChild("Piranha") then
                        local _mc_rs = game:GetService("ReplicatedStorage"):FindFirstChild("Piranha") and game:GetService("ReplicatedStorage"):FindFirstChild("Piranha").HumanoidRootPart.CFrame * Pos or nil
                        if _mc_rs and (_mc_rs.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc_rs) end
                    end
                end)
            end
        end
    end)
    Tabs.Sea:AddToggle("ToggleShark", {
        ["Title"] = "Đánh Cá Con",
        ["Default"] = false
    }):OnChanged(function(p612)
        _G.AutoShark = p612
    end)
    -- [SetValue skipped - Library không cần]
    spawn(function()
        while wait() do
            if _G.AutoShark then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Shark") then
                        local v613, v614, v615 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                        while true do
                            local v616
                            v615, v616 = v613(v614, v615)
                            if v615 == nil then
                                break
                            end
                            if v616.Name == "Shark" and (v616:FindFirstChild("Humanoid") and (v616:FindFirstChild("HumanoidRootPart") and v616.Humanoid.Health > 0)) then
                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCoolDown()
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    v616.HumanoidRootPart.CanCollide = false
                                    v616.Humanoid.WalkSpeed = 0
                                    v616.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    local _mc50 = v616.HumanoidRootPart.CFrame * Pos
                                    if (v616.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc50) end
                                    game.Players.LocalPlayer.Character.Humanoid.Sit = false
                                until not _G.AutoShark or (not v616.Parent or v616.Humanoid.Health <= 0)
                            end
                        end
                    else
                        Tween2(game:GetService("Workspace").Boats.PirateGrandBrigade.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Terrorshark") then
                            local _mc_rs = game:GetService("ReplicatedStorage"):FindFirstChild("Terrorshark") and game:GetService("ReplicatedStorage"):FindFirstChild("Terrorshark").HumanoidRootPart.CFrame * Pos or nil
                            if _mc_rs and (_mc_rs.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc_rs) end
                        end
                    end
                end)
            end
        end
    end)
    Tabs.Sea:AddToggle("ToggleFishCrew", {
        ["Title"] = "Đánh Tàu Cá",
        ["Default"] = false
    }):OnChanged(function(p617)
        _G.AutoFishCrew = p617
    end)
    -- [SetValue skipped - Library không cần]
    spawn(function()
        while wait() do
            if _G.AutoFishCrew then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") then
                        local v618, v619, v620 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                        while true do
                            local v621
                            v620, v621 = v618(v619, v620)
                            if v620 == nil then
                                break
                            end
                            if v621.Name == "Fish Crew Member" and (v621:FindFirstChild("Humanoid") and (v621:FindFirstChild("HumanoidRootPart") and v621.Humanoid.Health > 0)) then
                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCoolDown()
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    v621.HumanoidRootPart.CanCollide = false
                                    v621.Humanoid.WalkSpeed = 0
                                    v621.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    local _mc51 = v621.HumanoidRootPart.CFrame * Pos
                                    if (v621.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc51) end
                                    game.Players.LocalPlayer.Character.Humanoid.Sit = false
                                until not _G.AutoFishCrew or (not v621.Parent or v621.Humanoid.Health <= 0)
                            end
                        end
                    else
                        Tween2(game:GetService("Workspace").Boats.PirateGrandBrigade.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Fish Crew Member") then
                            local _mc_rs = game:GetService("ReplicatedStorage"):FindFirstChild("Fish Crew Member") and game:GetService("ReplicatedStorage"):FindFirstChild("Fish Crew Member").HumanoidRootPart.CFrame * Pos or nil
                            if _mc_rs and (_mc_rs.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc_rs) end
                        end
                    end
                end)
            end
        end
    end)
    Tabs.Sea:AddToggle("ToggleShip", {
        ["Title"] = "Đánh Tàu",
        ["Default"] = false
    }):OnChanged(function(p622)
        _G.Ship = p622
    end)
    -- [SetValue skipped - Library không cần]
    function CheckPirateBoat()
        local v623 = next
        local v624, v625 = game:GetService("Workspace").Enemies:GetChildren()
        local v626 = {
            "PirateGrandBrigade",
            "PirateBrigade"
        }
        while true do
            local v627
            v625, v627 = v623(v624, v625)
            if v625 == nil then
                break
            end
            if table.find(v626, v627.Name) and (v627:FindFirstChild("Health") and v627.Health.Value > 0) then
                return v627
            end
        end
    end
    spawn(function()
        while wait() do
            if _G.Ship then
                pcall(function()
                    if CheckPirateBoat() then
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, 32, false, game)
                        wait(0.5)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, 32, false, game)
                        local v628 = CheckPirateBoat()
                        repeat
                            wait()
                            Tween2(v628.Engine.CFrame * CFrame.new(0, -20, 0))
                            AimBotSkillPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, - 5, 0)
                            Skillaimbot = true
                            AutoSkill = false
                        until not v628 or (not v628.Parent or (v628.Health.Value <= 0 or not CheckPirateBoat()))
                        Skillaimbot = true
                        AutoSkill = false
                    end
                end)
            end
        end
    end)
    Tabs.Sea:AddToggle("ToggleGhostShip", {
        ["Title"] = "Đánh Tàu Ma",
        ["Default"] = false
    }):OnChanged(function(p629)
        _G.GhostShip = p629
    end)
    -- [SetValue skipped - Library không cần]
    function CheckPirateBoat()
        local v630 = next
        local v631, v632 = game:GetService("Workspace").Enemies:GetChildren()
        local v633 = {
            "FishBoat"
        }
        while true do
            local v634
            v632, v634 = v630(v631, v632)
            if v632 == nil then
                break
            end
            if table.find(v633, v634.Name) and (v634:FindFirstChild("Health") and v634.Health.Value > 0) then
                return v634
            end
        end
    end
    spawn(function()
        while wait() do
            pcall(function()
                if _G.bjirFishBoat and CheckPirateBoat() then
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 32, false, game)
                    wait()
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 32, false, game)
                    local v635 = CheckPirateBoat()
                    repeat
                        wait()
                        Tween2(v635.Engine.CFrame * CFrame.new(0, -20, 0))
                        AutoSkill = true
                        Skillaimbot = true
                        AimBotSkillPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, - 5, 0)
                    until v635.Parent or (v635.Health.Value <= 0 or not CheckPirateBoat())
                    AutoSkill = false
                    Skillaimbot = false
                end
            end)
        end
    end)
    spawn(function()
        while wait() do
            if _G.bjirFishBoat then
                pcall(function()
                    if CheckPirateBoat() then
                        AutoHaki()
                        game:GetService("VirtualUser"):CaptureController()
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                        local v636, v637, v638 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())
                        while true do
                            local v639
                            v638, v639 = v636(v637, v638)
                            if v638 == nil then
                                break
                            end
                            if v639:IsA("Tool") and v639.ToolTip == "Melee" then
                                game.Players.LocalPlayer.Character.Humanoid:EquipTool(v639)
                            end
                        end
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, "C", false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        local v640, v641, v642 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())
                        while true do
                            local v643
                            v642, v643 = v640(v641, v642)
                            if v642 == nil then
                                break
                            end
                            if v643:IsA("Tool") and v643.ToolTip == "Blox Fruit" then
                                game.Players.LocalPlayer.Character.Humanoid:EquipTool(v643)
                            end
                        end
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "V", false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, "V", false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait()
                        local v644, v645, v646 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())
                        while true do
                            local v647
                            v646, v647 = v644(v645, v646)
                            if v646 == nil then
                                break
                            end
                            if v647:IsA("Tool") and v647.ToolTip == "Sword" then
                                game.Players.LocalPlayer.Character.Humanoid:EquipTool(v647)
                            end
                        end
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait()
                        local v648, v649, v650 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())
                        while true do
                            local v651
                            v650, v651 = v648(v649, v650)
                            if v650 == nil then
                                break
                            end
                            if v651:IsA("Tool") and v651.ToolTip == "Gun" then
                                game.Players.LocalPlayer.Character.Humanoid:EquipTool(v651)
                            end
                        end
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        wait(0.2)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                    end
                end)
            end
        end
    end)
    Tabs.Main:AddSection("Elite")
    local vu652 = Tabs.Main:AddParagraph({
        ["Title"] = "Trạng Thái Elite",
    })
    spawn(function()
		-- upvalues: (ref) vu652
        while wait() do
            pcall(function()
				-- upvalues: (ref) vu652
                if game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") or (game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") or (game:GetService("ReplicatedStorage"):FindFirstChild("Urban") or (game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or (game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or game:GetService("Workspace").Enemies:FindFirstChild("Urban"))))) then
                    vu652:SetDesc("Elite Boss: \226\156\133\239\184\143 | Killed:  " .. game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
                else
                    vu652:SetDesc("Elite Boss: \226\157\140\239\184\143 | Killed: " .. game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
                end
            end)
        end
    end)
    Tabs.Main:AddToggle("ToggleElite", {
        ["Title"] = "Đánh Elite",
        ["Default"] = false
    }):OnChanged(function(p653)
        _G.AutoElite = p653
    end)
    -- [SetValue skipped - Library không cần]
    spawn(function()
        while task.wait() do
            if _G.AutoElite then
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible ~= true then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
                    elseif string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Diablo") or (string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Deandre") or string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Urban")) then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or (game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or game:GetService("Workspace").Enemies:FindFirstChild("Urban")) then
                            local v654, v655, v656 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                            while true do
                                local v657
                                v656, v657 = v654(v655, v656)
                                if v656 == nil then
                                    break
                                end
                                if v657:FindFirstChild("Humanoid") and (v657:FindFirstChild("HumanoidRootPart") and (v657.Humanoid.Health > 0 and (v657.Name == "Diablo" or (v657.Name == "Deandre" or v657.Name == "Urban")))) then
                                    repeat
                                        wait(_G.Fast_Delay)
                                        AttackNoCoolDown()
                                        EquipTool(SelectWeapon)
                                        AutoHaki()
                                        Tween2(v657.HumanoidRootPart.CFrame * Pos)
                                        v657.Humanoid.WalkSpeed = 0
                                        v657.HumanoidRootPart.CanCollide = false
                                        v657.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    until _G.AutoElite == false or (v657.Humanoid.Health <= 0 or not v657.Parent)
                                end
                            end
                        elseif game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") then
                            Tween2(game:GetService("ReplicatedStorage"):FindFirstChild("Diablo").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                        elseif game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") then
                            Tween2(game:GetService("ReplicatedStorage"):FindFirstChild("Deandre").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                        elseif game:GetService("ReplicatedStorage"):FindFirstChild("Urban") then
                            Tween2(game:GetService("ReplicatedStorage"):FindFirstChild("Urban").HumanoidRootPart.CFrame * CFrame.new(2, 20, 2))
                        end
                    end
                end)
            end
        end
    end)
end
if Sea3 then
    Tabs.Sea:AddSection("Đảo Bí Ẩn")
    local vu658 = Tabs.Sea:AddParagraph({
        ["Title"] = "Trạng Thái",
    })
    task.spawn(function()
        while task.wait() do
            pcall(function()
                local v659 = game:GetService("Lighting").Sky.MoonTextureId
                if v659 == "http://www.roblox.com/asset/?id=9709149431" then
                    FullMoonStatus = "100%"
                elseif v659 == "http://www.roblox.com/asset/?id=9709149052" then
                    FullMoonStatus = "75%"
                elseif v659 == "http://www.roblox.com/asset/?id=9709143733" then
                    FullMoonStatus = "50%"
                elseif v659 == "http://www.roblox.com/asset/?id=9709150401" then
                    FullMoonStatus = "25%"
                elseif v659 == "http://www.roblox.com/asset/?id=9709149680" then
                    FullMoonStatus = "15%"
                else
                    FullMoonStatus = "0%"
                end
            end)
        end
    end)
    task.spawn(function()
        while task.wait() do
            pcall(function()
                if game.Workspace.Map:FindFirstChild("MysticIsland") then
                    MirageStatus = "\239\191\189\239\191\189\239\184\143"
                else
                    MirageStatus = "\239\191\189\239\191\189\239\184\143"
                end
            end)
        end
    end)
    spawn(function()
		-- upvalues: (ref) vu658
        pcall(function()
			-- upvalues: (ref) vu658
            while wait() do
                vu658:SetDesc("Đảo Bí Ẩn: " .. MirageStatus .. " | Trăng Tr\195\178n: " .. FullMoonStatus)
            end
        end)
    end)
    Tabs.Sea:AddButton({
        ["Title"] = "Bay Đến Chợ Cao",
        ["Callback"] = function()
            TweenToHighestPoint()
        end
    })
    function TweenToHighestPoint()
        local v660 = getHighestPoint()
        if v660 then
            Tween2(v660.CFrame * CFrame.new(0, 211.88, 0))
        end
    end
    function getHighestPoint()
        if not game.Workspace.Map:FindFirstChild("MysticIsland") then
            return nil
        end
        local v661, v662, v663 = pairs(game:GetService("Workspace").Map.MysticIsland:GetDescendants())
        while true do
            local v664
            v663, v664 = v661(v662, v663)
            if v663 == nil then
                break
            end
            if v664:IsA("MeshPart") and v664.MeshId == "rbxassetid://6745037796" then
                return v664
            end
        end
    end
end
Tabs.Sea:AddToggle("ToggleTpAdvanced", {
    ["Title"] = "Bay Đến Advanced Fruit Dealer",
    ["Default"] = false
}):OnChanged(function(p665)
    _G.AutoTpAdvanced = p665
end)
spawn(function()
    while wait() do
        if _G.AutoTpAdvanced then
            local v666 = game.ReplicatedStorage.NPCs:FindFirstChild("Advanced Fruit Dealer")
            if v666 and v666:IsA("Model") then
                local v667 = v666.PrimaryPart
                if v667 then
                    v667 = v666.PrimaryPart.Position
                end
                if v667 then
                    Tween2(CFrame.new(v667))
                end
            end
        end
    end
end)
Tabs.Sea:AddToggle("ToggleTweenGear", {
    ["Title"] = "Bay Đến Bánh Răng",
    ["Default"] = false
}):OnChanged(function(p668)
    _G.TweenToGear = p668
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    pcall(function()
        while wait() do
            if _G.TweenToGear and game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
                local v669, v670, v671 = pairs(game:GetService("Workspace").Map.MysticIsland:GetChildren())
                while true do
                    local v672
                    v671, v672 = v669(v670, v671)
                    if v671 == nil then
                        break
                    end
                    if v672:IsA("MeshPart") and v672.Material == Enum.Material.Neon then
                        Tween2(v672.CFrame)
                    end
                end
            end
        end
    end)
end)
Tabs.Sea:AddToggle("Togglelockmoon", {
    ["Title"] = "Nhìn Trăng Và Dùng Tộc",
    ["Default"] = false
}):OnChanged(function(p673)
    _G.AutoLockMoon = p673
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoLockMoon then
                local v674 = game.Lighting:GetMoonDirection()
                local v675 = game.Workspace.CurrentCamera.CFrame.p + v674 * 100
                game.Workspace.CurrentCamera.CFrame = CFrame.lookAt(game.Workspace.CurrentCamera.CFrame.p, v675)
            end
        end)
    end
end)
spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoLockMoon then
                game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
            end
        end)
    end
end)
Tabs.Item:AddSection("Kiếm")
Tabs.Item:AddToggle("ToggleAutoSaber", {
    ["Title"] = "Saber",
    ["Default"] = false
}):OnChanged(function(p676)
    _G.Auto_Saber = p676
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while task.wait() do
        if _G.Auto_Saber and game.Players.LocalPlayer.Data.Level.Value >= 200 then
            pcall(function()
                if game:GetService("Workspace").Map.Jungle.Final.Part.Transparency ~= 0 then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Saber Expert") or game:GetService("ReplicatedStorage"):FindFirstChild("Saber Expert") then
                        local v677, v678, v679 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                        while true do
                            local v680
                            v679, v680 = v677(v678, v679)
                            if v679 == nil then
                                break
                            end
                            if v680:FindFirstChild("Humanoid") and (v680:FindFirstChild("HumanoidRootPart") and (v680.Humanoid.Health > 0 and v680.Name == "Saber Expert")) then
                                repeat
                                    task.wait(_G.Fast_Delay)
                                    EquipTool(SelectWeapon)
                                    local _mc52 = v680.HumanoidRootPart.CFrame * Pos
                                    if (v680.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc52) end
                                    v680.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    v680.HumanoidRootPart.Transparency = 1
                                    v680.Humanoid.JumpPower = 0
                                    v680.Humanoid.WalkSpeed = 0
                                    v680.HumanoidRootPart.CanCollide = false
                                    bringmob = true
                                    FarmPos = v680.HumanoidRootPart.CFrame
                                    MonFarm = v680.Name
                                    AttackNoCoolDown()
                                until v680.Humanoid.Health <= 0 or not _G.Auto_Saber
                                bringmob = true
                                if v680.Humanoid.Health <= 0 then
                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "PlaceRelic")
                                end
                            end
                        end
                    end
                elseif game:GetService("Workspace").Map.Jungle.QuestPlates.Door.Transparency ~= 0 then
                    if game:GetService("Workspace").Map.Desert.Burn.Part.Transparency ~= 0 then
                        if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan") == 0 then
                            if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") ~= nil then
                                if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") ~= 0 then
                                    if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == 1 then
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
                                        wait(0.5)
                                        EquipTool("Relic")
                                        wait(0.5)
                                        Tween2(CFrame.new(- 1404.91504, 29.9773273, 3.80598116, 0.876514494, 5.66906877e-9, 0.481375456, 2.53851997e-8, 1, - 5.79995607e-8, - 0.481375456, 6.30572643e-8, 0.876514494))
                                    end
                                elseif game:GetService("Workspace").Enemies:FindFirstChild("Mob Leader") or game:GetService("ReplicatedStorage"):FindFirstChild("Mob Leader") then
                                    Tween2(CFrame.new(- 2967.59521, - 4.91089821, 5328.70703, 0.342208564, - 0.0227849055, 0.939347804, 0.0251603816, 0.999569714, 0.0150796166, - 0.939287126, 0.0184739735, 0.342634559))
                                    local v681, v682, v683 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                                    while true do
                                        local v684
                                        v683, v684 = v681(v682, v683)
                                        if v683 == nil then
                                            break
                                        end
                                        if v684.Name == "Mob Leader" then
                                            if game:GetService("Workspace").Enemies:FindFirstChild("Mob Leader [Lv. 120] [Boss]") and (v684:FindFirstChild("Humanoid") and (v684:FindFirstChild("HumanoidRootPart") and v684.Humanoid.Health > 0)) then
                                                repeat
                                                    task.wait(_G.Fast_Delay)
                                                    AutoHaki()
                                                    EquipTool(SelectWeapon)
                                                    v684.HumanoidRootPart.CanCollide = false
                                                    v684.Humanoid.WalkSpeed = 0
                                                    v684.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                                    local _mc53 = v684.HumanoidRootPart.CFrame * Pos
                                                    if (v684.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc53) end
                                                    AttackNoCoolDown()
                                                until v684.Humanoid.Health <= 0 or not _G.Auto_Saber
                                            end
                                            if game:GetService("ReplicatedStorage"):FindFirstChild("Mob Leader") then
                                                local _mc_rs = game:GetService("ReplicatedStorage"):FindFirstChild("Mob Leader") and game:GetService("ReplicatedStorage"):FindFirstChild("Mob Leader").HumanoidRootPart.CFrame * Pos or nil
                                                if _mc_rs and (_mc_rs.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc_rs) end
                                            end
                                        end
                                    end
                                end
                            else
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
                            end
                        else
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "GetCup")
                            wait(0.5)
                            EquipTool("Cup")
                            wait(0.5)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "FillCup", game:GetService("Players").LocalPlayer.Character.Cup)
                            wait(0)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan")
                        end
                    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Torch") or game.Players.LocalPlayer.Character:FindFirstChild("Torch") then
                        EquipTool("Torch")
                        Tween2(CFrame.new(1114.61475, 5.04679728, 4350.22803, - 0.648466587, - 1.28799094e-9, 0.761243105, - 5.70652914e-10, 1, 1.20584542e-9, - 0.761243105, 3.47544882e-10, - 0.648466587))
                    else
                        Tween2(CFrame.new(- 1610.00757, 11.5049858, 164.001587, 0.984807551, - 0.167722285, - 0.0449818149, 0.17364943, 0.951244235, 0.254912198, 0.0000342372805, - 0.258850515, 0.965917408))
                    end
                elseif (CFrame.new(- 1612.55884, 36.9774132, 148.719543, 0.37091279, 3.0717151e-9, - 0.928667724, 3.97099491e-8, 1, 1.91679348e-8, 0.928667724, - 4.39869794e-8, 0.37091279).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 100 then
                    Tween2(CFrame.new(- 1612.55884, 36.9774132, 148.719543, 0.37091279, 3.0717151e-9, - 0.928667724, 3.97099491e-8, 1, 1.91679348e-8, 0.928667724, - 4.39869794e-8, 0.37091279))
                else
                    Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
                    wait(1)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate1.Button.CFrame
                    wait(1)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate2.Button.CFrame
                    wait(1)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate3.Button.CFrame
                    wait(1)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate4.Button.CFrame
                    wait(1)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate5.Button.CFrame
                    wait(1)
                end
            end)
        end
    end
end)
Tabs.Item:AddToggle("ToggleAutoPoleV1", {
    ["Title"] = "Pole V1",
    ["Default"] = false
}):OnChanged(function(p685)
    _G.Auto_PoleV1 = p685
end)
-- [SetValue removed]
local vu686 = CFrame.new(- 7748.0185546875, 5606.80615234375, - 2305.898681640625)
spawn(function()
	-- upvalues: (ref) vu686
    while wait() do
        if _G.Auto_PoleV1 then
            pcall(function()
				-- upvalues: (ref) vu686
                if game:GetService("Workspace").Enemies:FindFirstChild("Thunder God") then
                    local v687, v688, v689 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                    while true do
                        local v690
                        v689, v690 = v687(v688, v689)
                        if v689 == nil then
                            break
                        end
                        if v690.Name == "Thunder God" and (v690:FindFirstChild("Humanoid") and (v690:FindFirstChild("HumanoidRootPart") and v690.Humanoid.Health > 0)) then
                            repeat
                                task.wait(_G.Fast_Delay)
                                AutoHaki()
                                EquipTool(SelectWeapon)
                                v690.HumanoidRootPart.CanCollide = false
                                v690.Humanoid.WalkSpeed = 0
                                v690.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                local _mc54 = v690.HumanoidRootPart.CFrame * Pos
                                if (v690.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc54) end
                                AttackNoCoolDown()
                            until not _G.Auto_PoleV1 or (not v690.Parent or v690.Humanoid.Health <= 0)
                        end
                    end
                elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - vu686.Position).Magnitude < 1500 then
                    Tween2(vu686)
                end
                Tween2(CFrame.new(- 7748.0185546875, 5606.80615234375, - 2305.898681640625))
                if game:GetService("ReplicatedStorage"):FindFirstChild("Thunder God") then
                    local _mc_rs = game:GetService("ReplicatedStorage"):FindFirstChild("Thunder God") and game:GetService("ReplicatedStorage"):FindFirstChild("Thunder God").HumanoidRootPart.CFrame * Pos or nil
                    if _mc_rs and (_mc_rs.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc_rs) end
                end
            end)
        end
    end
end)
Tabs.Item:AddToggle("ToggleAutoSaw", {
    ["Title"] = "Cưa Cá Mắp",
    ["Default"] = false
}):OnChanged(function(p691)
    _G.Auto_Saw = p691
end)
-- [SetValue skipped - Library không cần]
local vu692 = CFrame.new(- 690.33081054688, 15.09425163269, 1582.2380371094)
spawn(function()
	-- upvalues: (ref) vu692
    while wait() do
        if _G.Auto_Saw then
            pcall(function()
				-- upvalues: (ref) vu692
                if game:GetService("Workspace").Enemies:FindFirstChild("The Saw") then
                    local v693, v694, v695 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                    while true do
                        local v696
                        v695, v696 = v693(v694, v695)
                        if v695 == nil then
                            break
                        end
                        if v696.Name == "The Saw" and (v696:FindFirstChild("Humanoid") and (v696:FindFirstChild("HumanoidRootPart") and v696.Humanoid.Health > 0)) then
                            repeat
                                task.wait(_G.Fast_Delay)
                                AutoHaki()
                                EquipTool(SelectWeapon)
                                v696.HumanoidRootPart.CanCollide = false
                                v696.Humanoid.WalkSpeed = 0
                                v696.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                local _mc55 = v696.HumanoidRootPart.CFrame * Pos
                                if (v696.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc55) end
                                AttackNoCoolDown()
                            until not _G.Auto_Saw or (not v696.Parent or v696.Humanoid.Health <= 0)
                        end
                    end
                elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - vu692.Position).Magnitude < 1500 then
                    Tween2(vu692)
                end
                Tween2(CFrame.new(- 690.33081054688, 15.09425163269, 1582.2380371094))
                if game:GetService("ReplicatedStorage"):FindFirstChild("The Saw") then
                    local _mc_rs = game:GetService("ReplicatedStorage"):FindFirstChild("The Saw") and game:GetService("ReplicatedStorage"):FindFirstChild("The Saw").HumanoidRootPart.CFrame * Pos or nil
                    if _mc_rs and (_mc_rs.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc_rs) end
                end
            end)
        end
    end
end)
Tabs.Item:AddToggle("ToggleAutoWarden", {
    ["Title"] = "Kiếm Quản Ng\225\187\165c",
    ["Default"] = false
}):OnChanged(function(p697)
    _G.Auto_Warden = p697
end)
-- [SetValue skipped - Library không cần]
local vu698 = CFrame.new(5186.14697265625, 24.86684226989746, 832.1885375976562)
spawn(function()
	-- upvalues: (ref) vu698
    while wait() do
        if _G.Auto_Warden then
            pcall(function()
				-- upvalues: (ref) vu698
                if game:GetService("Workspace").Enemies:FindFirstChild("Chief Warden") then
                    local v699, v700, v701 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                    while true do
                        local v702
                        v701, v702 = v699(v700, v701)
                        if v701 == nil then
                            break
                        end
                        if v702.Name == "Chief Warden" and (v702:FindFirstChild("Humanoid") and (v702:FindFirstChild("HumanoidRootPart") and v702.Humanoid.Health > 0)) then
                            repeat
                                task.wait(_G.Fast_Delay)
                                AutoHaki()
                                EquipTool(SelectWeapon)
                                v702.HumanoidRootPart.CanCollide = false
                                v702.Humanoid.WalkSpeed = 0
                                v702.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                local _mc56 = v702.HumanoidRootPart.CFrame * Pos
                                if (v702.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc56) end
                                AttackNoCoolDown()
                            until not _G.Auto_Warden or (not v702.Parent or v702.Humanoid.Health <= 0)
                        end
                    end
                elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - vu698.Position).Magnitude < 1500 then
                    Tween2(vu698)
                end
                Tween2(CFrame.new(5186.14697265625, 24.86684226989746, 832.1885375976562))
                if game:GetService("ReplicatedStorage"):FindFirstChild("Chief Warden") then
                    local _mc_rs = game:GetService("ReplicatedStorage"):FindFirstChild("Chief Warden") and game:GetService("ReplicatedStorage"):FindFirstChild("Chief Warden").HumanoidRootPart.CFrame * Pos or nil
                    if _mc_rs and (_mc_rs.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc_rs) end
                end
            end)
        end
    end
end)
if Sea3 then
    Tabs.Item:AddToggle("ToggleHallow", {
        ["Title"] = "Lưởi Hái",
        ["Default"] = false
    }):OnChanged(function(p703)
        AutoHallowSycthe = p703
    end)
    -- [SetValue skipped - Library không cần]
    spawn(function()
        while wait() do
            if AutoHallowSycthe then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Soul Reaper") then
                        local v704, v705, v706 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                        while true do
                            local v707
                            v706, v707 = v704(v705, v706)
                            if v706 == nil then
                                break
                            end
                            if string.find(v707.Name, "Soul Reaper") then
                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCoolDown()
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    v707.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    local _mc57 = v707.HumanoidRootPart.CFrame * Pos
                                    if (v707.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc57) end
                                    v707.HumanoidRootPart.Transparency = 1
                                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                                until v707.Humanoid.Health <= 0 or AutoHallowSycthe == false
                            end
                        end
                    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hallow Essence") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Hallow Essence") then
                        repeat
                            Tween2(CFrame.new(- 8932.322265625, 146.83154296875, 6062.55078125))
                            wait()
                        until (CFrame.new(- 8932.322265625, 146.83154296875, 6062.55078125).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 8
                        wait()
                        EquipTool("Hallow Essence")
                    elseif game:GetService("ReplicatedStorage"):FindFirstChild("Soul Reaper") then
                        local _mc_rs = game:GetService("ReplicatedStorage"):FindFirstChild("Soul Reaper") and game:GetService("ReplicatedStorage"):FindFirstChild("Soul Reaper").HumanoidRootPart.CFrame * Pos or nil
                        if _mc_rs and (_mc_rs.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc_rs) end
                    end
                end)
            end
        end
    end)
    spawn(function()
        while wait() do
            if AutoHallowSycthe then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "Bones",
                    "Buy",
                    1,
                    1
                }))
            end
        end
    end)
    Tabs.Item:AddToggle("ToggleYama", {
        ["Title"] = "Yama",
        ["Default"] = false
    }):OnChanged(function(p708)
        _G.AutoYama = p708
    end)
    -- [SetValue skipped - Library không cần]
    spawn(function()
        while wait() do
            if _G.AutoYama and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter", "Progress") >= 30 then
                wait()
                fireclickdetector(game:GetService("Workspace").Map.Waterfall.SealedKatana.Handle.ClickDetector)
                if not game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Yama") and _G.AutoYama then
                    break
                end
            end
        end
    end)
    Tabs.Item:AddToggle("ToggleTushita", {
        ["Title"] = "Tushita",
        ["Default"] = false
    }):OnChanged(function(p709)
        AutoTushita = p709
    end)
    -- [SetValue skipped - Library không cần]
    spawn(function()
		-- ::l0::
        while true do
            repeat
                if not wait() then
                    return
                end
            until AutoTushita
            if game:GetService("Workspace").Enemies:FindFirstChild("Longma") then
                break
            end
            Tween2(CFrame.new(- 10238.875976563, 389.7912902832, - 9549.7939453125))
        end
        local v710, v711, v712 = pairs(game:GetService("Workspace").Enemies:GetChildren())
		-- ::l9::
        local v713
        v712, v713 = v710(v711, v712)
        if v712 ~= nil then
			-- goto l10
        end
		-- goto l0
		-- ::l10::
        if v713.Name == ("Longma" or v713.Name == "Longma") and (v713.Humanoid.Health > 0 and (v713:IsA("Model") and (v713:FindFirstChild("Humanoid") and v713:FindFirstChild("HumanoidRootPart")))) then
			-- goto l5
        else
			-- goto l9
        end
		-- ::l5::
		-- ::l26::
        wait(_G.Fast_Delay)
        AttackNoCoolDown()
        AutoHaki()
        if not game.Players.LocalPlayer.Character:FindFirstChild(SelectWeapon) then
            wait()
            EquipTool(SelectWeapon)
        end
        FarmPos = v713.HumanoidRootPart.CFrame
        v713.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
        v713.Humanoid.JumpPower = 0
        v713.Humanoid.WalkSpeed = 0
        v713.HumanoidRootPart.CanCollide = false
        v713.Humanoid:ChangeState(11)
        local _mc58 = v713.HumanoidRootPart.CFrame * Pos
        if (v713.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc58) end
        if AutoTushita and (v713.Parent and v713.Humanoid.Health > 0) then
			-- goto l26
        else
			-- goto l9
        end
    end)
    Tabs.Item:AddToggle("ToggleHoly", {
        ["Title"] = "\239\191\189ổt Đuổc",
        ["Default"] = false
    }):OnChanged(function(p714)
        _G.Auto_Holy_Torch = p714
    end)
    -- [SetValue skipped - Library không cần]
    spawn(function()
        while wait() do
            if _G.Auto_Holy_Torch then
                pcall(function()
                    wait()
                    repeat
                        Tween2(CFrame.new(- 10752, 417, - 9366))
                        wait()
                    until not _G.Auto_Holy_Torch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(- 10752, 417, - 9366)).Magnitude <= 10
                    wait()
                    repeat
                        Tween2(CFrame.new(- 11672, 334, - 9474))
                        wait()
                    until not _G.Auto_Holy_Torch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(- 11672, 334, - 9474)).Magnitude <= 10
                    wait()
                    repeat
                        Tween2(CFrame.new(- 12132, 521, - 10655))
                        wait()
                    until not _G.Auto_Holy_Torch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(- 12132, 521, - 10655)).Magnitude <= 10
                    wait()
                    repeat
                        Tween2(CFrame.new(- 13336, 486, - 6985))
                        wait()
                    until not _G.Auto_Holy_Torch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(- 13336, 486, - 6985)).Magnitude <= 10
                    wait()
                    repeat
                        Tween2(CFrame.new(- 13489, 332, - 7925))
                        wait()
                    until not _G.Auto_Holy_Torch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(- 13489, 332, - 7925)).Magnitude <= 10
                end)
            end
        end
    end)
end
Tabs.Item:AddToggle("ToggleAutoCanvander", {
    ["Title"] = "Canvander",
    ["Default"] = false
}):OnChanged(function(p715)
    _G.Auto_Canvander = p715
end)
-- [SetValue skipped - Library không cần]
local vu716 = CFrame.new(5311.07421875, 426.0243835449219, 165.12762451171875)
spawn(function()
	-- upvalues: (ref) vu716
    while wait() do
        if _G.Auto_Canvander then
            pcall(function()
				-- upvalues: (ref) vu716
                if game:GetService("Workspace").Enemies:FindFirstChild("Beautiful Pirate") then
                    local v717, v718, v719 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                    while true do
                        local v720
                        v719, v720 = v717(v718, v719)
                        if v719 == nil then
                            break
                        end
                        if v720.Name == "Beautiful Pirate" and (v720:FindFirstChild("Humanoid") and (v720:FindFirstChild("HumanoidRootPart") and v720.Humanoid.Health > 0)) then
                            repeat
                                task.wait(_G.Fast_Delay)
                                AutoHaki()
                                EquipTool(SelectWeapon)
                                v720.HumanoidRootPart.CanCollide = false
                                v720.Humanoid.WalkSpeed = 0
                                v720.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                local _mc59 = v720.HumanoidRootPart.CFrame * Pos
                                if (v720.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc59) end
                                AttackNoCoolDown()
                            until not _G.Auto_Canvander or (not v720.Parent or v720.Humanoid.Health <= 0)
                        end
                    end
                elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - vu716.Position).Magnitude < 1500 then
                    Tween2(vu716)
                end
                Tween2(CFrame.new(5311.07421875, 426.0243835449219, 165.12762451171875))
                if game:GetService("ReplicatedStorage"):FindFirstChild("Beautiful Pirate") then
                    local _mc_rs = game:GetService("ReplicatedStorage"):FindFirstChild("Beautiful Pirate") and game:GetService("ReplicatedStorage"):FindFirstChild("Beautiful Pirate").HumanoidRootPart.CFrame * Pos or nil
                    if _mc_rs and (_mc_rs.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc_rs) end
                end
            end)
        end
    end
end)
Tabs.Item:AddToggle("ToggleAutoMusketeerHat", {
    ["Title"] = "M\197\169 Lính Ngữ Lâm",
    ["Default"] = false
}):OnChanged(function(p721)
    _G.Auto_MusketeerHat = p721
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    pcall(function()
        while wait(0.1) do
            if _G.Auto_MusketeerHat then
                if game:GetService("Players").LocalPlayer.Data.Level.Value < 1800 or game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress").KilledBandits ~= false then
                    if game:GetService("Players").LocalPlayer.Data.Level.Value < 1800 or game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress").KilledBoss ~= false then
                        if game:GetService("Players").LocalPlayer.Data.Level.Value >= 1800 and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen") == 2 then
                            Tween2(CFrame.new(- 12512.138671875, 340.39279174805, - 9872.8203125))
                        end
                    elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible and (string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") and game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true) then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Captain Elephant") then
                            local v722, v723, v724 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                            while true do
                                local vu725
                                v724, vu725 = v722(v723, v724)
                                if v724 == nil then
                                    break
                                end
                                if vu725.Name == "Captain Elephant" then
                                    OldCFrameElephant = vu725.HumanoidRootPart.CFrame
                                    repeat
                                        task.wait(_G.Fast_Delay)
                                        pcall(function()
											-- upvalues: (ref) vu725
                                            EquipTool(SelectWeapon)
                                            AutoHaki()
                                            vu725.HumanoidRootPart.CanCollide = false
                                            vu725.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                            local _mc60 = vu725.HumanoidRootPart.CFrame * Pos
                                            if (vu725.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc60) end
                                            vu725.HumanoidRootPart.CanCollide = false
                                            vu725.HumanoidRootPart.CFrame = OldCFrameElephant
                                            AttackNoCoolDown()
                                        end)
                                    until _G.Auto_MusketeerHat == false or (vu725.Humanoid.Health <= 0 or not vu725.Parent) or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                end
                            end
                        else
                            Tween2(CFrame.new(- 13374.889648438, 421.27752685547, - 8225.208984375))
                        end
                    else
                        Tween2(CFrame.new(- 12443.8671875, 332.40396118164, - 7675.4892578125))
                        if (CFrame.new(- 12443.8671875, 332.40396118164, - 7675.4892578125).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 4 then
                            wait(1.5)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen")
                        end
                    end
                elseif string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Forest Pirate") and (string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true) then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Forest Pirate") then
                        local v726, v727, v728 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                        while true do
                            local vu729
                            v728, vu729 = v726(v727, v728)
                            if v728 == nil then
                                break
                            end
                            if vu729.Name == "Forest Pirate" then
                                repeat
                                    task.wait(_G.Fast_Delay)
                                    pcall(function()
										-- upvalues: (ref) vu729
                                        EquipTool(SelectWeapon)
                                        AutoHaki()
                                        vu729.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                        local _mc61 = vu729.HumanoidRootPart.CFrame * Pos
                                        if (vu729.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc61) end
                                        vu729.HumanoidRootPart.CanCollide = false
                                        AttackNoCoolDown()
                                        PosMon = vu729.HumanoidRootPart.CFrame
                                        MonFarm = vu729.Name
                                        bringmob = true
                                    end)
                                until _G.Auto_MusketeerHat == false or (not vu729.Parent or vu729.Humanoid.Health <= 0) or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                bringmob = false
                            end
                        end
                    else
                        bringmob = false
                        Tween2(CFrame.new(- 13206.452148438, 425.89199829102, - 7964.5537109375))
                    end
                else
                    Tween2(CFrame.new(- 12443.8671875, 332.40396118164, - 7675.4892578125))
                    if (Vector3.new(- 12443.8671875, 332.40396118164, - 7675.4892578125) - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 30 then
                        wait(1.5)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", "CitizenQuest", 1)
                    end
                end
            end
        end
    end)
end)
Tabs.Item:AddToggle("ToggleAutoObservationV2", {
    ["Title"] = "Haki Quan Sát V2",
    ["Default"] = false
}):OnChanged(function(p730)
    _G.Auto_ObservationV2 = p730
end)
-- [SetValue removed]
spawn(function()
    while wait() do
        pcall(function()
            if _G.Auto_ObservationV2 then
                if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen") ~= 3 then
                    _G.Auto_MusketeerHat = true
                else
                    _G.Auto_MusketeerHat = false
                    if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Banana") and (game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Apple") and game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Pineapple")) then
                        repeat
                            Tween2(CFrame.new(- 12444.78515625, 332.40396118164, - 7673.1806640625))
                            wait()
                        until not _G.Auto_ObservationV2 or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(- 12444.78515625, 332.40396118164, - 7673.1806640625)).Magnitude <= 10
                        wait(0.5)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen")
                    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Fruit Bowl") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Fruit Bowl") then
                        repeat
                            Tween2(CFrame.new(- 10920.125, 624.20275878906, - 10266.995117188))
                            wait()
                        until not _G.Auto_ObservationV2 or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(- 10920.125, 624.20275878906, - 10266.995117188)).Magnitude <= 10
                        wait(0.5)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk2", "Start")
                        wait(1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk2", "Buy")
                    else
                        local v731, v732, v733 = pairs(game:GetService("Workspace"):GetDescendants())
                        while true do
                            local v734
                            v733, v734 = v731(v732, v733)
                            if v733 == nil then
                                break
                            end
                            if v734.Name == "Apple" or (v734.Name == "Banana" or v734.Name == "Pineapple") then
                                v734.Handle.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 10)
                                wait()
                                firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, v734.Handle, 0)
                                wait()
                            end
                        end
                    end
                end
            end
        end)
    end
end)
Tabs.Item:AddToggle("ToggleAutoRainbowHaki", {
    ["Title"] = "Haki 7 Màu",
    ["Default"] = false
}):OnChanged(function(p735)
    _G.Auto_RainbowHaki = p735
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    pcall(function()
        while wait(0.1) do
            if _G.Auto_RainbowHaki then
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible and string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Stone") then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Stone") then
                            local v736, v737, v738 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                            while true do
                                local v739
                                v738, v739 = v736(v737, v738)
                                if v738 == nil then
                                    break
                                end
                                if v739.Name == "Stone" then
                                    OldCFrameRainbow = v739.HumanoidRootPart.CFrame
                                    repeat
                                        task.wait(_G.Fast_Delay)
                                        EquipTool(SelectWeapon)
                                        local _mc62 = v739.HumanoidRootPart.CFrame * Pos
                                        if (v739.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc62) end
                                        v739.HumanoidRootPart.CanCollide = false
                                        v739.HumanoidRootPart.CFrame = OldCFrameRainbow
                                        v739.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                        AttackNoCoolDown()
                                    until not _G.Auto_RainbowHaki or (v739.Humanoid.Health <= 0 or not v739.Parent) or not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                                end
                            end
                        else
                            Tween2(CFrame.new(- 1086.11621, 38.8425903, 6768.71436))
                        end
                    elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible and string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Hydra Leader") then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Hydra Leader") then
                            local v740, v741, v742 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                            while true do
                                local v743
                                v742, v743 = v740(v741, v742)
                                if v742 == nil then
                                    break
                                end
                                if v743.Name == "Hydra Leader" then
                                    OldCFrameRainbow = v743.HumanoidRootPart.CFrame
                                    repeat
                                        task.wait(_G.Fast_Delay)
                                        EquipTool(SelectWeapon)
                                        local _mc63 = v743.HumanoidRootPart.CFrame * Pos
                                        if (v743.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc63) end
                                        v743.HumanoidRootPart.CanCollide = false
                                        v743.HumanoidRootPart.CFrame = OldCFrameRainbow
                                        v743.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                        AttackNoCoolDown()
                                    until not _G.Auto_RainbowHaki or (v743.Humanoid.Health <= 0 or not v743.Parent) or not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                                end
                            end
                        else
                            Tween2(CFrame.new(5713.98877, 601.922974, 202.751251))
                        end
                    elseif string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Kilo Admiral") then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Kilo Admiral") then
                            local v744, v745, v746 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                            while true do
                                local v747
                                v746, v747 = v744(v745, v746)
                                if v746 == nil then
                                    break
                                end
                                if v747.Name == "Kilo Admiral" then
                                    OldCFrameRainbow = v747.HumanoidRootPart.CFrame
                                    repeat
                                        task.wait(_G.Fast_Delay)
                                        EquipTool(SelectWeapon)
                                        local _mc64 = v747.HumanoidRootPart.CFrame * Pos
                                        if (v747.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc64) end
                                        v747.HumanoidRootPart.CanCollide = false
                                        v747.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                        v747.HumanoidRootPart.CFrame = OldCFrameRainbow
                                        AttackNoCoolDown()
                                    until not _G.Auto_RainbowHaki or (v747.Humanoid.Health <= 0 or not v747.Parent) or not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                                end
                            end
                        else
                            Tween2(CFrame.new(2877.61743, 423.558685, - 7207.31006))
                        end
                    elseif string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Captain Elephant") then
                            local v748, v749, v750 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                            while true do
                                local v751
                                v750, v751 = v748(v749, v750)
                                if v750 == nil then
                                    break
                                end
                                if v751.Name == "Captain Elephant" then
                                    OldCFrameRainbow = v751.HumanoidRootPart.CFrame
                                    repeat
                                        task.wait(_G.Fast_Delay)
                                        EquipTool(SelectWeapon)
                                        local _mc65 = v751.HumanoidRootPart.CFrame * Pos
                                        if (v751.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc65) end
                                        v751.HumanoidRootPart.CanCollide = false
                                        v751.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                        v751.HumanoidRootPart.CFrame = OldCFrameRainbow
                                        AttackNoCoolDown()
                                    until not _G.Auto_RainbowHaki or (v751.Humanoid.Health <= 0 or not v751.Parent) or not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                                end
                            end
                        else
                            Tween2(CFrame.new(- 13485.0283, 331.709259, - 8012.4873))
                        end
                    elseif string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Beautiful Pirate") then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Beautiful Pirate") then
                            local v752, v753, v754 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                            while true do
                                local v755
                                v754, v755 = v752(v753, v754)
                                if v754 == nil then
                                    break
                                end
                                if v755.Name == "Beautiful Pirate" then
                                    OldCFrameRainbow = v755.HumanoidRootPart.CFrame
                                    repeat
                                        task.wait(_G.Fast_Delay)
                                        EquipTool(SelectWeapon)
                                        local _mc66 = v755.HumanoidRootPart.CFrame * Pos
                                        if (v755.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc66) end
                                        v755.HumanoidRootPart.CanCollide = false
                                        v755.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                        v755.HumanoidRootPart.CFrame = OldCFrameRainbow
                                        AttackNoCoolDown()
                                    until not _G.Auto_RainbowHaki or (v755.Humanoid.Health <= 0 or not v755.Parent) or not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                                end
                            end
                        else
                            Tween2(CFrame.new(5312.3598632813, 20.141201019287, - 10.158538818359))
                        end
                    else
                        Tween2(CFrame.new(- 11892.0703125, 930.57672119141, - 8760.1591796875))
                        if (Vector3.new(- 11892.0703125, 930.57672119141, - 8760.1591796875) - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 30 then
                            wait(1.5)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("HornedMan", "Bet")
                        end
                    end
                else
                    Tween2(CFrame.new(- 11892.0703125, 930.57672119141, - 8760.1591796875))
                    if (Vector3.new(- 11892.0703125, 930.57672119141, - 8760.1591796875) - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 30 then
                        wait(1.5)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("HornedMan", "Bet")
                    end
                end
            end
        end
    end)
end)
Tabs.Item:AddToggle("ToggleAutoSkullGuitar", {
    ["Title"] = "Skull Guitar",
    ["Default"] = false
}):OnChanged(function(p756)
    _G.Auto_SkullGuitar = p756
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        pcall(function()
            if _G.Auto_SkullGuitar and GetWeaponInventory("Skull Guitar") == false then
                if (CFrame.new(- 9681.458984375, 6.139880657196045, 6341.3720703125).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5000 then
                    Tween2(CFrame.new(- 9681.458984375, 6.139880657196045, 6341.3720703125))
                elseif game:GetService("Workspace").NPCs:FindFirstChild("Skeleton Machine") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("soulGuitarBuy", true)
                elseif game:GetService("Workspace").Map["Haunted Castle"].Candle1.Transparency ~= 0 then
                    if string.find(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("gravestoneEvent", 2), "Error") then
                        Tween2(CFrame.new(- 8653.2060546875, 140.98487854003906, 6160.033203125))
                    elseif string.find(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("gravestoneEvent", 2), "Nothing") then
                        -- Tween("Wait Full Moon") -- wait for full moon (no movement needed)
                    else
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)
                    end
                elseif game:GetService("Workspace").Map["Haunted Castle"].Placard1.Left.Part.Transparency ~= 0 then
                    if game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment1:FindFirstChild("ClickDetector") then
                        if game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part1:FindFirstChild("ClickDetector") then
                            Quest4 = true
                            repeat
                                wait()
                                Tween2(CFrame.new(- 9553.5986328125, 65.62338256835938, 6041.58837890625))
                            until (CFrame.new(- 9553.5986328125, 65.62338256835938, 6041.58837890625).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.Auto_SkullGuitar
                            wait(1)
                            Tween2(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part3.CFrame)
                            wait(1)
                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part3.ClickDetector)
                            wait(1)
                            Tween2(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.CFrame)
                            wait(1)
                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
                            wait(1)
                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
                            wait(1)
                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
                            wait(1)
                            Tween2(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.CFrame)
                            wait(1)
                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.ClickDetector)
                            wait(1)
                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.ClickDetector)
                            wait(1)
                            Tween2(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part8.CFrame)
                            wait(1)
                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part8.ClickDetector)
                            wait(1)
                            Tween2(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.CFrame)
                            wait(1)
                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
                            wait(1)
                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
                            wait(1)
                            fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
                        else
                            Quest3 = true
                        end
                    else
                        if game:GetService("Workspace").NPCs:FindFirstChild("Ghost") then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                                "GuitarPuzzleProgress",
                                "Ghost"
                            }))
                        end
                        if game.Workspace.Enemies:FindFirstChild("Living Zombie") then
                            local v757, v758, v759 = pairs(game.Workspace.Enemies:GetChildren())
                            while true do
                                local v760
                                v759, v760 = v757(v758, v759)
                                if v759 == nil then
                                    break
                                end
                                if v760:FindFirstChild("HumanoidRootPart") and (v760:FindFirstChild("Humanoid") and (v760.Humanoid.Health > 0 and v760.Name == "Living Zombie")) then
                                    EquipTool(SelectWeapon)
                                    v760.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    v760.HumanoidRootPart.Transparency = 1
                                    v760.Humanoid.JumpPower = 0
                                    v760.Humanoid.WalkSpeed = 0
                                    v760.HumanoidRootPart.CanCollide = false
                                    v760.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                                    Tween2(CFrame.new(- 10160.787109375, 138.6616973876953, 5955.03076171875))
                                    game:GetService("VirtualUser"):CaptureController()
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                end
                            end
                        else
                            Tween2(CFrame.new(- 10160.787109375, 138.6616973876953, 5955.03076171875))
                        end
                    end
                else
                    Quest2 = true
                    repeat
                        wait()
                        Tween2(CFrame.new(- 8762.69140625, 176.84783935546875, 6171.3076171875))
                    until (CFrame.new(- 8762.69140625, 176.84783935546875, 6171.3076171875).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.Auto_SkullGuitar
                    wait(1)
                    fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard7.Left.ClickDetector)
                    wait(1)
                    fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard6.Left.ClickDetector)
                    wait(1)
                    fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard5.Left.ClickDetector)
                    wait(1)
                    fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard4.Right.ClickDetector)
                    wait(1)
                    fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard3.Left.ClickDetector)
                    wait(1)
                    fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard2.Right.ClickDetector)
                    wait(1)
                    fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard1.Right.ClickDetector)
                    wait(1)
                end
            end
        end)
    end
end)
Tabs.Item:AddToggle("ToggleAutoBuddy", {
    ["Title"] = "Kiếm Buddy",
    ["Default"] = false
}):OnChanged(function(p761)
    _G.Auto_Buddy = p761
end)
-- [SetValue skipped - Library không cần]
local vu762 = CFrame.new(- 731.2034301757812, 381.5658874511719, - 11198.4951171875)
spawn(function()
	-- upvalues: (ref) vu762
    while wait() do
        if _G.Auto_Buddy then
            pcall(function()
				-- upvalues: (ref) vu762
                if game:GetService("Workspace").Enemies:FindFirstChild("Cake Queen") then
                    local v763, v764, v765 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                    while true do
                        local v766
                        v765, v766 = v763(v764, v765)
                        if v765 == nil then
                            break
                        end
                        if v766.Name == "Cake Queen" and (v766:FindFirstChild("Humanoid") and (v766:FindFirstChild("HumanoidRootPart") and v766.Humanoid.Health > 0)) then
                            repeat
                                task.wait(_G.Fast_Delay)
                                AutoHaki()
                                EquipTool(SelectWeapon)
                                v766.HumanoidRootPart.CanCollide = false
                                v766.Humanoid.WalkSpeed = 0
                                v766.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                local _mc67 = v766.HumanoidRootPart.CFrame * Pos
                                if (v766.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc67) end
                                AttackNoCoolDown()
                            until not _G.Auto_Buddy or (not v766.Parent or v766.Humanoid.Health <= 0)
                        end
                    end
                elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - vu762.Position).Magnitude < 1500 then
                    Tween2(vu762)
                end
                Tween2(CFrame.new(- 731.2034301757812, 381.5658874511719, - 11198.4951171875))
                if game:GetService("ReplicatedStorage"):FindFirstChild("Cake Queen") then
                    local _mc_rs = game:GetService("ReplicatedStorage"):FindFirstChild("Cake Queen") and game:GetService("ReplicatedStorage"):FindFirstChild("Cake Queen").HumanoidRootPart.CFrame * Pos or nil
                    if _mc_rs and (_mc_rs.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc_rs) end
                end
            end)
        end
    end
end)
Tabs.Item:AddToggle("ToggleAutoDualKatana", {
    ["Title"] = "Song Kiếm",
    ["Default"] = false
}):OnChanged(function(p767)
    _G.Auto_DualKatana = p767
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        pcall(function()
            if _G.Auto_DualKatana then
                if game.Players.LocalPlayer.Character:FindFirstChild("Tushita") or (game.Players.LocalPlayer.Backpack:FindFirstChild("Tushita") or (game.Players.LocalPlayer.Character:FindFirstChild("Yama") or game.Players.LocalPlayer.Backpack:FindFirstChild("Yama"))) then
                    if game.Players.LocalPlayer.Character:FindFirstChild("Tushita") or game.Players.LocalPlayer.Backpack:FindFirstChild("Tushita") then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild("Tushita") then
                            EquipTool("Tushita")
                        end
                    elseif (game.Players.LocalPlayer.Character:FindFirstChild("Yama") or game.Players.LocalPlayer.Backpack:FindFirstChild("Yama")) and game.Players.LocalPlayer.Backpack:FindFirstChild("Yama") then
                        EquipTool("Yama")
                    end
                else
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", "Tushita")
                end
            end
        end)
    end
end)
spawn(function()
    while wait() do
        pcall(function()
            if _G.Auto_DualKatana then
                if GetMaterial("Alucard Fragment") ~= 0 then
                    if GetMaterial("Alucard Fragment") ~= 1 then
                        if GetMaterial("Alucard Fragment") ~= 2 then
                            if GetMaterial("Alucard Fragment") ~= 3 then
                                if GetMaterial("Alucard Fragment") ~= 4 then
                                    if GetMaterial("Alucard Fragment") ~= 5 then
                                        if GetMaterial("Alucard Fragment") == 6 then
                                            if game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton Boss [Lv. 2025] [Boss]") or game:GetService("Workspace").ReplicatedStorage:FindFirstChild("Cursed Skeleton Boss [Lv. 2025] [Boss]") then
                                                Auto_Quest_Yama_1 = false
                                                Auto_Quest_Yama_2 = false
                                                Auto_Quest_Yama_3 = false
                                                Auto_Quest_Tushita_1 = false
                                                Auto_Quest_Tushita_2 = false
                                                Auto_Quest_Tushita_3 = false
                                                if game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton Boss [Lv. 2025] [Boss]") or game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton [Lv. 2200]") then
                                                    local v768, v769, v770 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                                                    while true do
                                                        local v771
                                                        v770, v771 = v768(v769, v770)
                                                        if v770 == nil then
                                                            break
                                                        end
                                                        if (v771.Name == "Cursed Skeleton Boss" or v771.Name == "Cursed Skeleton") and v771.Humanoid.Health > 0 then
                                                            EquipTool(Sword)
                                                            local _mc771 = v771.HumanoidRootPart.CFrame * pos
if (_mc771.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc771) end
                                                            v771.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                                            v771.HumanoidRootPart.Transparency = 1
                                                            v771.Humanoid.JumpPower = 0
                                                            v771.Humanoid.WalkSpeed = 0
                                                            v771.HumanoidRootPart.CanCollide = false
                                                            bringmob = true
                                                            FarmPos = v771.HumanoidRootPart.CFrame
                                                            MonFarm = v771.Name
                                                            AttackNoCoolDown()
                                                        end
                                                    end
                                                end
                                            elseif (CFrame.new(- 12361.7060546875, 603.3547973632812, - 6550.5341796875).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 100 then
                                                Tween2(CFrame.new(- 12361.7060546875, 603.3547973632812, - 6550.5341796875))
                                            else
                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Good")
                                                wait(1)
                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Evil")
                                                wait(1)
                                                Tween2(CFrame.new(- 12361.7060546875, 603.3547973632812, - 6550.5341796875))
                                                wait(1.5)
                                                game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                                                wait(1.5)
                                                Tween2(CFrame.new(- 12253.5419921875, 598.8999633789062, - 6546.8388671875))
                                            end
                                        end
                                    else
                                        Auto_Quest_Yama_1 = false
                                        Auto_Quest_Yama_2 = false
                                        Auto_Quest_Yama_3 = false
                                        Auto_Quest_Tushita_1 = false
                                        Auto_Quest_Tushita_2 = false
                                        Auto_Quest_Tushita_3 = true
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Good")
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Good")
                                    end
                                else
                                    Auto_Quest_Yama_1 = false
                                    Auto_Quest_Yama_2 = false
                                    Auto_Quest_Yama_3 = false
                                    Auto_Quest_Tushita_1 = false
                                    Auto_Quest_Tushita_2 = true
                                    Auto_Quest_Tushita_3 = false
                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Good")
                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Good")
                                end
                            else
                                Auto_Quest_Yama_1 = false
                                Auto_Quest_Yama_2 = false
                                Auto_Quest_Yama_3 = false
                                Auto_Quest_Tushita_1 = true
                                Auto_Quest_Tushita_2 = false
                                Auto_Quest_Tushita_3 = false
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Good")
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Good")
                            end
                        else
                            Auto_Quest_Yama_1 = false
                            Auto_Quest_Yama_2 = false
                            Auto_Quest_Yama_3 = true
                            Auto_Quest_Tushita_1 = false
                            Auto_Quest_Tushita_2 = false
                            Auto_Quest_Tushita_3 = false
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Evil")
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Evil")
                        end
                    else
                        Auto_Quest_Yama_1 = false
                        Auto_Quest_Yama_2 = true
                        Auto_Quest_Yama_3 = false
                        Auto_Quest_Tushita_1 = false
                        Auto_Quest_Tushita_2 = false
                        Auto_Quest_Tushita_3 = false
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Evil")
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Evil")
                    end
                else
                    Auto_Quest_Yama_1 = true
                    Auto_Quest_Yama_2 = false
                    Auto_Quest_Yama_3 = false
                    Auto_Quest_Tushita_1 = false
                    Auto_Quest_Tushita_2 = false
                    Auto_Quest_Tushita_3 = false
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Evil")
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Evil")
                end
            end
        end)
    end
end)
spawn(function()
    while wait() do
        if Auto_Quest_Yama_1 then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("Mythological Pirate") then
                    local v772, v773, v774 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                    while true do
                        local v775
                        v774, v775 = v772(v773, v774)
                        if v774 == nil then
                            break
                        end
                        if v775.Name == "Mythological Pirate" then
                            repeat
                                wait()
                                Tween2(v775.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2))
                            until _G.Auto_DualKatana == false or Auto_Quest_Yama_1 == false
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Evil")
                        end
                    end
                else
                    Tween2(CFrame.new(- 13451.46484375, 543.712890625, - 6961.0029296875))
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        pcall(function()
            if Auto_Quest_Yama_2 then
                local v776, v777, v778 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                while true do
                    local v779
                    v778, v779 = v776(v777, v778)
                    if v778 == nil then
                        break
                    end
                    if v779:FindFirstChild("HazeESP") then
                        v779.HazeESP.Size = UDim2.new(50, 50, 50, 50)
                        v779.HazeESP.MaxDistance = "inf"
                    end
                end
                local v780, v781, v782 = pairs(game:GetService("ReplicatedStorage"):GetChildren())
                while true do
                    local v783
                    v782, v783 = v780(v781, v782)
                    if v782 == nil then
                        break
                    end
                    if v783:FindFirstChild("HazeESP") then
                        v783.HazeESP.Size = UDim2.new(50, 50, 50, 50)
                        v783.HazeESP.MaxDistance = "inf"
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while wait() do
        pcall(function()
            local v784, v785, v786 = pairs(game:GetService("Workspace").Enemies:GetChildren())
            while true do
                local v787
                v786, v787 = v784(v785, v786)
                if v786 == nil then
                    break
                end
                if Auto_Quest_Yama_2 and (v787:FindFirstChild("HazeESP") and (v787.HumanoidRootPart.Position - FarmPossEsp.Position).magnitude <= 300) then
                    v787.HumanoidRootPart.CFrame = FarmPossEsp
                    v787.HumanoidRootPart.CanCollide = false
                    v787.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                    if not v787.HumanoidRootPart:FindFirstChild("BodyVelocity") then
                        local v788 = Instance.new("BodyVelocity", v787.HumanoidRootPart)
                        v788.MaxForce = Vector3.new(1, 1, 1) * math.huge
                        v788.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while wait() do
        if Auto_Quest_Yama_2 then
            pcall(function()
                local v789, v790, v791 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                while true do
                    while true do
                        local v792
                        v791, v792 = v789(v790, v791)
                        if v791 == nil then
                            return
                        end
                        if v792:FindFirstChild("HazeESP") then
                            break
                        end
                        local v793, v794, v795 = pairs(game:GetService("ReplicatedStorage"):GetChildren())
                        while true do
                            local v796
                            v795, v796 = v793(v794, v795)
                            if v795 == nil then
                                break
                            end
                            if v796:FindFirstChild("HazeESP") then
                                if (v796.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 2000 then
                                    local _mc68 = v796.HumanoidRootPart.CFrame * Pos
                                    if (v796.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc68) end
                                else
                                    local _mc796 = v796.HumanoidRootPart.CFrame * Pos
if (_mc796.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc796) end
                                end
                            end
                        end
                    end
                    if true then
                        wait()
                        if (v792.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 2000 then
                            EquipTool(Sword)
                            local _mc69 = v792.HumanoidRootPart.CFrame * Pos
                            if (v792.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc69) end
                            v792.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            v792.HumanoidRootPart.Transparency = 1
                            v792.Humanoid.JumpPower = 0
                            v792.Humanoid.WalkSpeed = 0
                            v792.HumanoidRootPart.CanCollide = false
                            FarmPos = v792.HumanoidRootPart.CFrame
                            MonFarm = v792.Name
                            AttackNoCoolDown()
                            if v792.Humanoid.Health <= 0 and v792.Humanoid:FindFirstChild("Animator") then
                                v792.Humanoid.Animator:Destroy()
                            end
                        else
                            local _mc70 = v792.HumanoidRootPart.CFrame * Pos
                            if (v792.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc70) end
                        end
                    end
                    if _G.Auto_DualKatana ~= false and (Auto_Quest_Yama_2 ~= false and (v792.Parent and (v792.Humanoid.Health > 0 and v792:FindFirstChild("HazeESP")))) then
                        break
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Auto_Quest_Yama_3 then
            pcall(function()
				-- block 65
                if game.Players.LocalPlayer.Backpack:FindFirstChild("Hallow Essence") then
                    Tween2(game:GetService("Workspace").Map["Haunted Castle"].Summoner.Detection.CFrame)
					-- goto l4
                end
                if not game:GetService("Workspace").Map:FindFirstChild("HellDimension") then
					-- ::l7::
                    if game:GetService("Workspace").Enemies:FindFirstChild("Soul Reaper") or game.ReplicatedStorage:FindFirstChild("Soul Reaper [Lv. 2100] [Raid Boss]") then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Soul Reaper") then
                            local v797, v798, v799 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                            while true do
                                local v800
                                v799, v800 = v797(v798, v799)
                                if v799 == nil then
                                    break
                                end
                                if v800.Name == "Soul Reaper" and v800.Humanoid.Health > 0 then
                                    repeat
                                        wait()
                                        local _mc71 = v800.HumanoidRootPart.CFrame * Pos
                                        if (v800.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc71) end
                                    until _G.Auto_DualKatana == false or Auto_Quest_Yama_3 == false or game:GetService("Workspace").Map:FindFirstChild("HellDimension")
                                end
                            end
                        else
                            Tween2(CFrame.new(- 9570.033203125, 315.9346923828125, 6726.89306640625))
                        end
                    else
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
                    end
					-- ::l4::
                    return
                end
                wait()
                if not (game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton [Lv. 2200]") or (game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton [Lv. 2200] [Boss]") or game:GetService("Workspace").Enemies:FindFirstChild("Hell\'s Messenger [Lv. 2200] [Boss]"))) then
                    wait(5)
                    Tween2(game:GetService("Workspace").Map.HellDimension.Torch1.CFrame)
                    wait(1.5)
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                    wait(1.5)
                    Tweem(game:GetService("Workspace").Map.HellDimension.Torch2.CFrame)
                    wait(1.5)
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                    wait(1.5)
                    Tween2(game:GetService("Workspace").Map.HellDimension.Torch3.CFrame)
                    wait(1.5)
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                    wait(1.5)
                    Tween2(game:GetService("Workspace").Map.HellDimension.Exit.CFrame)
					-- ::l37::
                    if _G.Auto_DualKatana ~= false and (Auto_Quest_Yama_3 ~= false and GetMaterial("Alucard Fragment") ~= 3) then
						-- goto l7
                    end
					-- goto l4
                end
                local v801, v802, v803 = pairs(game:GetService("Workspace").Enemies:GetChildren())
				-- goto l15
				-- ::l7::
				-- ::l15::
                local v804
                v803, v804 = v801(v802, v803)
                if v803 == nil then
					-- goto l37
                end
                if v804.Name ~= "Cursed Skeleton" and (v804.Name ~= "Cursed Skeleton" and v804.Name ~= "Hell\'s Messenger") or v804.Humanoid.Health <= 0 then
					-- goto l15
                end
				-- ::l24::
                wait()
                EquipTool(Sword)
                local _mc72 = v804.HumanoidRootPart.CFrame * Pos
                if (v804.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc72) end
                v804.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                v804.HumanoidRootPart.Transparency = 1
                v804.Humanoid.JumpPower = 0
                v804.Humanoid.WalkSpeed = 0
                v804.HumanoidRootPart.CanCollide = false
                FarmPos = v804.HumanoidRootPart.CFrame
                MonFarm = v804.Name
                AttackNoCoolDown()
                if v804.Humanoid.Health <= 0 and v804.Humanoid:FindFirstChild("Animator") then
                    v804.Humanoid.Animator:Destroy()
                end
                if v804.Humanoid.Health <= 0 or (not v804.Parent or Auto_Quest_Yama_3 == false) then
					-- goto l7
                else
					-- goto l24
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Auto_Quest_Tushita_1 then
            Tween2(CFrame.new(- 9546.990234375, 21.139892578125, 4686.1142578125))
            wait(5)
            Tween2(CFrame.new(- 6120.0576171875, 16.455780029296875, - 2250.697265625))
            wait(5)
            Tween2(CFrame.new(- 9533.2392578125, 7.254445552825928, - 8372.69921875))
        end
    end
end)
spawn(function()
    while wait() do
        if Auto_Quest_Tushita_2 then
            pcall(function()
				-- block 30
                if (CFrame.new(- 5539.3115234375, 313.800537109375, - 2972.372314453125).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 500 then
                    Tween2(CFrame.new(- 5545.1240234375, 313.800537109375, - 2976.616455078125))
					-- ::l28::
                    return
                end
                local v805, v806, v807 = pairs(game:GetService("Workspace").Enemies:GetChildren())
				-- goto l4
				-- ::l2::
				-- goto l15
				-- ::l15::
                wait()
                EquipTool(Sword)
                local _mc73 = v808.HumanoidRootPart.CFrame * Pos
                if (v808.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc73) end
                v808.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                v808.HumanoidRootPart.Transparency = 1
                v808.Humanoid.JumpPower = 0
                v808.Humanoid.WalkSpeed = 0
                v808.HumanoidRootPart.CanCollide = false
                FarmPos = v808.HumanoidRootPart.CFrame
                MonFarm = v808.Name
                AttackNoCoolDown()
                if v808.Humanoid.Health <= 0 and v808.Humanoid:FindFirstChild("Animator") then
                    v808.Humanoid.Animator:Destroy()
                end
                if v808.Humanoid.Health > 0 and (v808.Parent and Auto_Quest_Tushita_2 ~= false) then
					-- goto l15
                end
				-- ::l4::
                local v808
                v807, v808 = v805(v806, v807)
                if v807 == nil then
					-- goto l28
                end
                if Auto_Quest_Tushita_2 and (v808:FindFirstChild("HumanoidRootPart") and (v808:FindFirstChild("Humanoid") and (v808.Humanoid.Health > 0 and (v808.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 2000))) then
					-- goto l2
                else
					-- goto l4
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if Auto_Quest_Tushita_3 then
            pcall(function()
				-- block 66
                if not (game:GetService("Workspace").Enemies:FindFirstChild("Cake Queen") or game.ReplicatedStorage:FindFirstChild("Cake Queen [Lv. 2175] [Boss]")) then
					-- goto l5
                end
                if not game:GetService("Workspace").Enemies:FindFirstChild("Cake Queen") then
                    Tween2(CFrame.new(- 709.3132934570312, 381.6005859375, - 11011.396484375))
					-- goto l27
                end
                local v809, v810, v811 = pairs(game:GetService("Workspace").Enemies:GetChildren())
				-- ::l9::
                local v812
                v811, v812 = v809(v810, v811)
                if v811 == nil then
					-- goto l27
                end
                if v812.Name ~= "Cake Queen" or v812.Humanoid.Health <= 0 then
					-- goto l9
                end
                while true do
                    wait()
                    EquipTool(Sword)
                    local _mc74 = v812.HumanoidRootPart.CFrame * Pos
                    if (v812.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc74) end
                    v812.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                    v812.HumanoidRootPart.Transparency = 1
                    v812.Humanoid.JumpPower = 0
                    v812.Humanoid.WalkSpeed = 0
                    v812.HumanoidRootPart.CanCollide = false
                    FarmPos = v812.HumanoidRootPart.CFrame
                    MonFarm = v812.Name
                    AttackNoCoolDown()
                    if v812.Humanoid.Health <= 0 and v812.Humanoid:FindFirstChild("Animator") then
                        v812.Humanoid.Animator:Destroy()
                    end
                    if _G.Auto_DualKatana == false or Auto_Quest_Tushita_3 == false or game:GetService("Workspace").Map:FindFirstChild("HeavenlyDimension") then
						-- goto l9
                    end
                end
				-- ::l9::
				-- ::l14::
				-- ::l37::
                local v813, v814 = v815(v816, v813)
                if v813 == nil then
					-- goto l59
                end
                if v814.Name ~= "Cursed Skeleton" and (v814.Name ~= "Cursed Skeleton" and v814.Name ~= "Heaven\'s Guardian") or v814.Humanoid.Health <= 0 then
					-- goto l37
                end
				-- ::l46::
                wait()
                EquipTool(Sword)
                local _mc75 = v814.HumanoidRootPart.CFrame * Pos
                if (v814.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc75) end
                v814.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                v814.HumanoidRootPart.Transparency = 1
                v814.Humanoid.JumpPower = 0
                v814.Humanoid.WalkSpeed = 0
                v814.HumanoidRootPart.CanCollide = false
                FarmPos = v814.HumanoidRootPart.CFrame
                MonFarm = v814.Name
                AttackNoCoolDown()
                if v814.Humanoid.Health <= 0 and v814.Humanoid:FindFirstChild("Animator") then
                    v814.Humanoid.Animator:Destroy()
                end
                if v814.Humanoid.Health <= 0 or (not v814.Parent or Auto_Quest_Tushita_3 == false) then
					-- goto l9
                else
					-- goto l46
                end
				-- ::l59::
                if not _G.Auto_DualKatana or (not Auto_Quest_Tushita_3 or GetMaterial("Alucard Fragment") == 6) then
					-- goto l27
                end
				-- ::l29::
                if true then
					-- goto l41
                else
					-- goto l59
                end
				-- ::l41::
                wait()
                if not (game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton [Lv. 2200]") or (game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton [Lv. 2200] [Boss]") or game:GetService("Workspace").Enemies:FindFirstChild("Heaven\'s Guardian [Lv. 2200] [Boss]"))) then
                    wait(5)
                    Tween2(game:GetService("Workspace").Map.HeavenlyDimension.Torch1.CFrame)
                    wait(1.5)
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                    wait(1.5)
                    Tween2(game:GetService("Workspace").Map.HeavenlyDimension.Torch2.CFrame)
                    wait(1.5)
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                    wait(1.5)
                    Tween2(game:GetService("Workspace").Map.HeavenlyDimension.Torch3.CFrame)
                    wait(1.5)
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                    wait(1.5)
                    Tween2(game:GetService("Workspace").Map.HeavenlyDimension.Exit.CFrame)
					-- goto l59
                end
                local v815, v816
                v815, v816, v813 = pairs(game:GetService("Workspace").Enemies:GetChildren())
				-- goto l37
				-- ::l5::
                if not game:GetService("Workspace").Map:FindFirstChild("HeavenlyDimension") then
					-- ::l27::
                    return
                end
				-- goto l29
            end)
        end
    end
end)
if Sea2 then
    Tabs.Item:AddToggle("ToggleFactory", {
        ["Title"] = "Đánh Nhà Máy",
        ["Default"] = false
    }):OnChanged(function(p817)
        _G.Factory = p817
    end)
    -- [SetValue skipped - Library không cần]
    spawn(function()
		-- ::l0::
        while true do
            repeat
                if not wait() then
                    return
                end
            until _G.Factory
            if game.Workspace.Enemies:FindFirstChild("Core") then
                break
            end
            if game.ReplicatedStorage:FindFirstChild("Core") then
                Tween2(CFrame.new(448.46756, 199.356781, - 441.389252))
                wait()
                if _G.Factory and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(448.46756, 199.356781, - 441.389252)).Magnitude > 10 then
                    break
                end
            end
        end
        local v818, v819, v820 = pairs(game.Workspace.Enemies:GetChildren())
		-- goto l9
		-- ::l7::
		-- goto l14
		-- ::l10::
        if v821.Name == "Core" and v821.Humanoid.Health > 0 then
			-- goto l19
        end
		-- ::l9::
        local v821
        v820, v821 = v818(v819, v820)
        if v820 ~= nil then
			-- goto l10
        end
		-- goto l0
		-- ::l14::
        wait(_G.Fast_Delay)
        AttackNoCoolDown()
        repeat
            Tween2(CFrame.new(448.46756, 199.356781, - 441.389252))
            wait()
        until not _G.Factory or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(448.46756, 199.356781, - 441.389252)).Magnitude <= 10
        EquipTool(SelectWeapon)
        AutoHaki()
        local _mc76 = v821.HumanoidRootPart.CFrame * Pos
        if (v821.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc76) end
        v821.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
        v821.HumanoidRootPart.Transparency = 1
        v821.Humanoid.JumpPower = 0
        v821.Humanoid.WalkSpeed = 0
        v821.HumanoidRootPart.CanCollide = false
        FarmPos = v821.HumanoidRootPart.CFrame
        MonFarm = v821.Name
        if v821.Parent and (v821.Humanoid.Health > 0 and _G.Factory ~= false) then
			-- goto l14
        end
		-- goto l9
		-- ::l19::
		-- goto l7
    end)
end
Tabs.Item:AddToggle("ToggleAutoFarmSwan", {
    ["Title"] = "Đánh Swan",
    ["Default"] = false
}):OnChanged(function(p822)
    _G.Auto_FarmSwan = p822
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoFarmSwan then
                if game:GetService("Workspace").Enemies:FindFirstChild("Don Swan") then
                    local v823, v824, v825 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                    while true do
                        local vu826
                        v825, vu826 = v823(v824, v825)
                        if v825 == nil then
                            break
                        end
                        if vu826.Name == "Don Swan" and (vu826.Humanoid.Health > 0 and (vu826:IsA("Model") and (vu826:FindFirstChild("Humanoid") and vu826:FindFirstChild("HumanoidRootPart")))) then
                            repeat
                                task.wait()
                                pcall(function()
									-- upvalues: (ref) vu826
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    vu826.HumanoidRootPart.CanCollide = false
                                    vu826.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                    local _mc77 = vu826.HumanoidRootPart.CFrame * Pos
                                    if (vu826.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc77) end
                                    AttackNoCoolDown()
                                end)
                            until _G.AutoFarmSwan == false or vu826.Humanoid.Health <= 0
                        end
                    end
                else
                    repeat
                        task.wait()
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(2284.912109375, 15.537666320801, 905.48291015625))
                    until (CFrame.new(2284.912109375, 15.537666320801, 905.48291015625).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 4 or _G.AutoFarmSwan == false
                end
            end
        end
    end)
end)
Tabs.Item:AddToggle("ToggleAutoRengoku", {
    ["Title"] = "Rengoku",
    ["Default"] = false
}):OnChanged(function(p827)
    _G.Auto_Regoku = p827
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    pcall(function()
        while wait() do
            if _G.Auto_Regoku then
                if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hidden Key") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Hidden Key") then
                    EquipTool("Hidden Key")
                    Tween2(CFrame.new(6571.1201171875, 299.23028564453, - 6967.841796875))
                elseif game:GetService("Workspace").Enemies:FindFirstChild("Snow Lurker") or game:GetService("Workspace").Enemies:FindFirstChild("Arctic Warrior") then
                    local v828, v829, v830 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                    while true do
                        local v831
                        v830, v831 = v828(v829, v830)
                        if v830 == nil then
                            break
                        end
                        if (v831.Name == "Snow Lurker" or v831.Name == "Arctic Warrior") and v831.Humanoid.Health > 0 then
                            repeat
                                task.wait(_G.Fast_Delay)
                                EquipTool(SelectWeapon)
                                AutoHaki()
                                v831.HumanoidRootPart.CanCollide = false
                                v831.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                FarmPos = v831.HumanoidRootPart.CFrame
                                MonFarm = v831.Name
                                local _mc78 = v831.HumanoidRootPart.CFrame * Pos
                                if (v831.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc78) end
                                AttackNoCoolDown()
                                bringmob = true
                            until game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hidden Key") or (_G.Auto_Regoku == false or (not v831.Parent or v831.Humanoid.Health <= 0))
                            bringmob = false
                        end
                    end
                else
                    bringmob = false
                    Tween2(CFrame.new(5439.716796875, 84.420944213867, - 6715.1635742188))
                end
            end
        end
    end)
end)
if Sea2 or Sea3 then
    Tabs.Item:AddToggle("ToggleHakiColor", {
        ["Title"] = "Mua Màu Haki",
        ["Default"] = false
    }):OnChanged(function(p832)
        _G.Auto_Buy_Enchancement = p832
    end)
    -- [SetValue skipped - Library không cần]
    spawn(function()
        while wait() do
            if _G.Auto_Buy_Enchancement then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "ColorsDealer",
                    "2"
                }))
            end
        end
    end)
end
if Sea2 then
    Tabs.Main:AddToggle("ToggleSwordLengend", {
        ["Title"] = "Mua Kiếm Huyền Thoại",
        ["Default"] = false
    }):OnChanged(function(p833)
        _G.BuyLengendSword = p833
    end)
    -- [SetValue skipped - Library không cần]
    spawn(function()
        while wait() do
            pcall(function()
                if _G.BuyLengendSword or Triple_A then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                        "LegendarySwordDealer",
                        "2"
                    }))
                else
                    wait()
                end
            end)
        end
    end)
end
if Sea2 then
    Tabs.Main:AddToggle("ToggleEvoRace", {
        ["Title"] = "Nâng Tộc V2",
        ["Default"] = false
    }):OnChanged(function(p834)
        _G.AutoEvoRace = p834
    end)
    -- [SetValue skipped - Library không cần]
    spawn(function()
        pcall(function()
            while wait(0.1) do
                if _G.AutoEvoRace and not game:GetService("Players").LocalPlayer.Data.Race:FindFirstChild("Evolved") then
                    if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist", "1") ~= 0 then
                        if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist", "1") ~= 1 then
                            if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist", "1") == 2 then
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist", "3")
                            end
                        else
                            pcall(function()
                                if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Flower 1") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Flower 1") then
                                    if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Flower 2") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Flower 2") then
                                        if not (game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Flower 3") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Flower 3")) then
                                            if game:GetService("Workspace").Enemies:FindFirstChild("Zombie") then
                                                local v835, v836, v837 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                                                while true do
                                                    local v838
                                                    v837, v838 = v835(v836, v837)
                                                    if v837 == nil then
                                                        break
                                                    end
                                                    if v838.Name == "Zombie" then
                                                        repeat
                                                            task.wait(_G.Fast_Delay)
                                                            AutoHaki()
                                                            EquipTool(SelectWeapon)
                                                            local _mc79 = v838.HumanoidRootPart.CFrame * Pos
                                                            if (v838.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc79) end
                                                            v838.HumanoidRootPart.CanCollide = false
                                                            v838.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                                            AttackNoCoolDown()
                                                            FarmPos = v838.HumanoidRootPart.CFrame
                                                            MonFarm = v838.Name
                                                            bringmob = true
                                                        until game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Flower 3") or (not v838.Parent or (v838.Humanoid.Health <= 0 or _G.AutoEvoRace == false))
                                                        bringmob = false
                                                    end
                                                end
                                            else
                                                Tween2(CFrame.new(- 5685.9233398438, 48.480125427246, - 853.23724365234))
                                            end
                                        end
                                    else
                                        Tween2(game:GetService("Workspace").Flower2.CFrame)
                                    end
                                else
                                    Tween2(game:GetService("Workspace").Flower1.CFrame)
                                end
                            end)
                        end
                    else
                        Tween2(CFrame.new(- 2779.83521, 72.9661407, - 3574.02002, - 0.730484903, 6.39014104e-8, - 0.68292886, 3.59963224e-8, 1, 5.50667032e-8, 0.68292886, 1.56424669e-8, - 0.730484903))
                        if (Vector3.new(- 2779.83521, 72.9661407, - 3574.02002) - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 4 then
                            wait(1.3)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist", "2")
                        end
                    end
                end
            end
        end)
    end)
end
Tabs.Setting:AddSection("Cài Đặt")
Tabs.Setting:AddToggle("ToggleAutoT", {
    ["Title"] = "Bật Tộc V3",
    ["Default"] = false
}):OnChanged(function(p839)
    _G.AutoT = p839
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoT then
                game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
            end
        end)
    end
end)
Tabs.Setting:AddToggle("ToggleAutoY", {
    ["Title"] = "Bật Tộc V4",
    ["Default"] = false
}):OnChanged(function(p840)
    _G.AutoY = p840
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoY then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "Y", false, game)
                wait()
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "Y", false, game)
            end
        end)
    end
end)
Tabs.Setting:AddToggle("ToggleAutoKen", {
    ["Title"] = "Bật Haki Quan Sât",
    ["Default"] = false
}):OnChanged(function(p841)
    _G.AutoKen = p841
    if p841 then
        game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken", true)
    else
        game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken", false)
    end
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoKen then
                game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken", true)
            end
        end)
    end
end)
Tabs.Setting:AddToggle("ToggleSaveSpawn", {
    ["Title"] = "Lưu Điểm Hồi Sinh",
    ["Default"] = false
}):OnChanged(function(p842)
    _G.SaveSpawn = p842
    if p842 then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
            "SetSpawnPoint"
        }))
    end
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        pcall(function()
            if _G.SaveSpawn then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "SetSpawnPoint"
                }))
            end
        end)
    end
end)
Tabs.Setting:AddButton({
    ["Title"] = "Fps Boost",
    ["Callback"] = function()
        local v843 = game
        local v844 = v843.Workspace
        local v845 = v843.Lighting
        local v846 = v844.Terrain
        v846.WaterWaveSize = 0
        v846.WaterWaveSpeed = 0
        v846.WaterReflectance = 0
        v846.WaterTransparency = 0
        v845.GlobalShadows = false
        v845.FogEnd = 9000000000
        v845.Brightness = 0
        settings().Rendering.QualityLevel = "Level01"
        local v847, v848, v849 = pairs(v843:GetDescendants())
        local v850 = false
        while true do
            local v851
            v849, v851 = v847(v848, v849)
            if v849 == nil then
                break
            end
            if v851:IsA("Part") or (v851:IsA("Union") or (v851:IsA("CornerWedgePart") or v851:IsA("TrussPart"))) then
                v851.Material = "Plastic"
                v851.Reflectance = 0
            elseif v851:IsA("Decal") or v851:IsA("Texture") and v850 then
                v851.Transparency = 1
            elseif v851:IsA("ParticleEmitter") or v851:IsA("Trail") then
                v851.Lifetime = NumberRange.new(0)
            elseif v851:IsA("Explosion") then
                v851.BlastPressure = 1
                v851.BlastRadius = 1
            elseif v851:IsA("Fire") or (v851:IsA("SpotLight") or (v851:IsA("Smoke") or v851:IsA("Sparkles"))) then
                v851.Enabled = false
            elseif v851:IsA("MeshPart") then
                v851.Material = "Plastic"
                v851.Reflectance = 0
                v851.TextureID = 1.0385902758728956e16
            end
        end
        local v852, v853, v854 = pairs(v845:GetChildren())
        while true do
            local v855
            v854, v855 = v852(v853, v854)
            if v854 == nil then
                break
            end
            if v855:IsA("BlurEffect") or (v855:IsA("SunRaysEffect") or (v855:IsA("ColorCorrectionEffect") or (v855:IsA("BloomEffect") or v855:IsA("DepthOfFieldEffect")))) then
                v855.Enabled = false
            end
        end
    end
})
Tabs.Setting:AddToggle("ToggleBringMob", {
    ["Title"] = "Gom Quái",
    ["Default"] = true
}):OnChanged(function(p856)
    _G.BringMob = p856
end)
_G.BringMob = true
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        pcall(function()
            local v857, v858, v859 = pairs(game:GetService("Workspace").Enemies:GetChildren())
            while true do
                local v860
                v859, v860 = v857(v858, v859)
                if v859 == nil then
                    break
                end
                if _G.BringMob and (bringmob and (v860.Name == MonFarm and (v860:FindFirstChild("Humanoid") and v860.Humanoid.Health > 0))) then
                    if v860.Name ~= "Factory Staff" then
                        if v860.Name == MonFarm and (v860.HumanoidRootPart.Position - FarmPos.Position).Magnitude <= 1000000000 then
                            v860.HumanoidRootPart.CFrame = FarmPos
                            v860.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            v860.HumanoidRootPart.Transparency = 1
                            v860.Humanoid.JumpPower = 0
                            v860.Humanoid.WalkSpeed = 0
                            if v860.Humanoid:FindFirstChild("Animator") then
                                v860.Humanoid.Animator:Destroy()
                            end
                            v860.HumanoidRootPart.CanCollide = false
                            v860.Head.CanCollide = false
                            v860.Humanoid:ChangeState(11)
                            v860.Humanoid:ChangeState(14)
                            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                        end
                    elseif (v860.HumanoidRootPart.Position - FarmPos.Position).Magnitude <= 1000000000 then
                        v860.Head.CanCollide = false
                        v860.HumanoidRootPart.CanCollide = false
                        v860.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                        v860.HumanoidRootPart.CFrame = FarmPos
                        if v860.Humanoid:FindFirstChild("Animator") then
                            v860.Humanoid.Animator:Destroy()
                        end
                        sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                    end
                end
            end
        end)
    end
end)
Tabs.Setting:AddToggle("ToggleRemoveNotify", {
    ["Title"] = "Xóa Thông Báo",
    ["Default"] = false
}):OnChanged(function(p861)
    RemoveNotify = p861
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        if RemoveNotify then
            game.Players.LocalPlayer.PlayerGui.Notifications.Enabled = false
        else
            game.Players.LocalPlayer.PlayerGui.Notifications.Enabled = true
        end
    end
end)
Tabs.Setting:AddToggle("ToggleWhite", {
    ["Title"] = "Màn Hình Trằng",
    ["Default"] = false
}):OnChanged(function(p862)
    _G.WhiteScreen = p862
    if _G.WhiteScreen ~= true then
        if _G.WhiteScreen == false then
            game:GetService("RunService"):Set3dRenderingEnabled(true)
        end
    else
        game:GetService("RunService"):Set3dRenderingEnabled(false)
    end
end)
-- [SetValue skipped - Library không cần]
Tabs.Setting:AddSection("Kỹ Năng Thông Thạo")
Tabs.Setting:AddToggle("ToggleZ", {
    ["Title"] = "Kỹ Năng Z",
    ["Default"] = true
}):OnChanged(function(p863)
    SkillZ = p863
end)
-- [SetValue skipped - Library không cần]
Tabs.Setting:AddToggle("ToggleX", {
    ["Title"] = "Kỹ Năng X",
    ["Default"] = true
}):OnChanged(function(p864)
    SkillX = p864
end)
-- [SetValue skipped - Library không cần]
Tabs.Setting:AddToggle("ToggleC", {
    ["Title"] = "Kỹ Năng C",
    ["Default"] = true
}):OnChanged(function(p865)
    SkillC = p865
end)
-- [SetValue skipped - Library không cần]
Tabs.Setting:AddToggle("ToggleV", {
    ["Title"] = "Kỹ Năng V",
    ["Default"] = true
}):OnChanged(function(p866)
    SkillV = p866
end)
-- [SetValue skipped - Library không cần]
Tabs.Setting:AddToggle("ToggleF", {
    ["Title"] = "Kỹ Năng F",
    ["Default"] = false
}):OnChanged(function(p867)
    SkillF = p867
end)
-- [SetValue skipped - Library không cần]
Tabs.Status:AddSection("Webhook")
Tabs.Status:AddParagraph({
    ["Title"] = "Thông Tin",
    ["Description"] = "\239\191\189\239\191\189\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\n" .. "Tên : " .. game.Players.LocalPlayer.DisplayName .. " (@" .. game.Players.LocalPlayer.Name .. ")\n" .. "Cấp : " .. game:GetService("Players").LocalPlayer.Data.Level.Value .. "\n" .. "Tiền : " .. game:GetService("Players").LocalPlayer.Data.Beli.Value .. "\n" .. "\239\191\189iểm F : " .. game:GetService("Players").LocalPlayer.Data.Fragments.Value .. "\n" .. "Tiền Truy Nã : " .. game:GetService("Players").LocalPlayer.leaderstats["Bounty/Honor"].Value .. "\n" .. "Máu: " .. game.Players.LocalPlayer.Character.Humanoid.Health .. "/" .. game.Players.LocalPlayer.Character.Humanoid.MaxHealth .. "\n" .. "Năng Lưỡng : " .. game.Players.LocalPlayer.Character.Energy.Value .. "/" .. game.Players.LocalPlayer.Character.Energy.MaxValue .. "\n" .. "Tộc : " .. game:GetService("Players").LocalPlayer.Data.Race.Value .. "\n" .. "Trái : " .. game:GetService("Players").LocalPlayer.Data.DevilFruit.Value .. "\n\239\191\189\239\191\189\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129\226\148\129"
})
local vu868 = Tabs.Status:AddParagraph({
    ["Title"] = "Thời Gian",
})
local function vu878()
	-- upvalues: (ref) vu868
    local v869 = os.date("*t")
    local v870 = v869.hour % 24
    local v871 = v870 < 12 and "AM" or "PM"
    local v872 = string.format("%02i:%02i:%02i %s", (v870 - 1) % 12 + 1, v869.min, v869.sec, v871)
    local v873 = string.format("%02d/%02d/%04d", v869.day, v869.month, v869.year)
    local vu874 = game:GetService("LocalizationService")
    local vu875 = game:GetService("Players").LocalPlayer
    local _ = vu875.Name
    local v876, v877 = pcall(function()
		-- upvalues: (ref) vu874, (ref) vu875
        return vu874:GetCountryRegionForPlayerAsync(vu875)
    end)
    vu868:SetDesc(v873 .. "-" .. v872 .. " [ " .. (not v876 and "Unknown" or v877) .. " ]")
end
spawn(function()
	-- upvalues: (ref) vu878
    while true do
        vu878()
        game:GetService("RunService").RenderStepped:Wait()
    end
end)
local vu879 = Tabs.Status:AddParagraph({
    ["Title"] = "Thời Gian Máy Ch\225\187\167",
})
local function vu884()
	-- upvalues: (ref) vu879
    local v880 = math.floor(workspace.DistributedGameTime + 0.5)
    local v881 = math.floor(v880 / 3600) % 24
    local v882 = math.floor(v880 / 60) % 60
    local v883 = v880 % 60
    vu879:SetDesc(string.format("%02d Tiđếng-%02d Phút-%02d Giây", v881, v882, v883))
end
spawn(function()
	-- upvalues: (ref) vu884
    while task.wait() do
        pcall(vu884)
    end
end)
local vu885 = Tabs.Status:AddParagraph({
    ["Title"] = "Đảo Leviathan",
})
spawn(function()
	-- upvalues: (ref) vu885
    pcall(function()
		-- upvalues: (ref) vu885
        while wait() do
            if game:GetService("Workspace").Map:FindFirstChild("FrozenDimension") then
                vu885:SetDesc("\239\191\189\239\191\189")
            else
                vu885:SetDesc("\239\191\189\239\191\189")
            end
        end
    end)
end)
Tabs.Status:AddInput("Input", {
    ["Title"] = "Job ID",
    ["Default"] = "",
    ["Placeholder"] = "Dán Job ID Vào Đây",
    ["Numeric"] = false,
    ["Finished"] = false,
    ["Callback"] = function(p886)
        _G.Job = p886
    end
})
Tabs.Status:AddButton({
    ["Title"] = "Bằt Đầu Tham Gia Job ID",
    ["Callback"] = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.placeId, _G.Job, game.Players.LocalPlayer)
    end
})
Tabs.Status:AddButton({
    ["Title"] = "Sao Chép Job ID",
    ["Callback"] = function()
        setclipboard(tostring(game.JobId))
    end
})
Tabs.Status:AddToggle("MyToggle", {
    ["Title"] = "Spam Tham Gia Job ID",
    ["Default"] = false
}):OnChanged(function(p887)
    _G.Join = p887
end)
spawn(function()
    while wait() do
        if _G.Join then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.placeId, _G.Job, game.Players.LocalPlayer)
        end
    end
end)
Tabs.Stats:AddSection("Chỉ Số")
Tabs.Stats:AddToggle("ToggleMelee", {
    ["Title"] = "Nâng Đấm",
    ["Default"] = false
}):OnChanged(function(p888)
    _G.Auto_Stats_Melee = p888
end)
-- [SetValue skipped - Library không cần]
Tabs.Stats:AddToggle("ToggleDe", {
    ["Title"] = "Nâng Máu",
    ["Default"] = false
}):OnChanged(function(p889)
    _G.Auto_Stats_Defense = p889
end)
-- [SetValue skipped - Library không cần]
Tabs.Stats:AddToggle("ToggleSword", {
    ["Title"] = "Nâng Kiếm",
    ["Default"] = false
}):OnChanged(function(p890)
    _G.Auto_Stats_Sword = p890
end)
-- [SetValue skipped - Library không cần]
Tabs.Stats:AddToggle("ToggleGun", {
    ["Title"] = "Nâng Súng",
    ["Default"] = false
}):OnChanged(function(p891)
    _G.Auto_Stats_Gun = p891
end)
-- [SetValue skipped - Library không cần]
Tabs.Stats:AddToggle("ToggleFruit", {
    ["Title"] = "Nâng Trái",
    ["Default"] = false
}):OnChanged(function(p892)
    _G.Auto_Stats_Devil_Fruit = p892
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        if _G.Auto_Stats_Devil_Fruit then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                "AddPoint",
                "Demon Fruit",
                3
            }))
        end
    end
end)
spawn(function()
    while wait() do
        if _G.Auto_Stats_Gun then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                "AddPoint",
                "Gun",
                3
            }))
        end
    end
end)
spawn(function()
    while wait() do
        if _G.Auto_Stats_Sword then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                "AddPoint",
                "Sword",
                3
            }))
        end
    end
end)
spawn(function()
    while wait() do
        if _G.Auto_Stats_Defense then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                "AddPoint",
                "Defense",
                3
            }))
        end
    end
end)
spawn(function()
    while wait() do
        if _G.Auto_Stats_Melee then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                "AddPoint",
                "Melee",
                3
            }))
        end
    end
end)
local v893, v894, v895 = pairs(game:GetService("Players"):GetChildren())
local vu896 = vu145
local vu897 = {}
while true do
    local v898
    v895, v898 = v893(v894, v895)
    if v895 == nil then
        break
    end
    table.insert(vu897, v898.Name)
end
Tabs.Player:AddSection("Người Chơi")
local v899 = Tabs.Player:AddDropdown("SelectedPly", {
    ["Title"] = "Chọn Người Chơi",
    ["Values"] = vu897,
    ["Multi"] = false,
    ["Default"] = 1
})
v899:SetValue(_G.SelectPly)
v899:OnChanged(function(p900)
    _G.SelectPly = p900
end)
Tabs.Player:AddButton({
    ["Title"] = "Tải Lại Người Chơi",
    ["Callback"] = function()
		-- upvalues: (ref) vu897
        table.clear(vu897)
        local v901, v902, v903 = pairs(game:GetService("Players"):GetChildren())
        while true do
            local v904
            v903, v904 = v901(v902, v903)
            if v903 == nil then
                break
            end
            table.insert(vu897, v904.Name)
        end
    end
})
Tabs.Player:AddToggle("ToggleTeleport", {
    ["Title"] = "Bay Đến Người Chơi",
    ["Default"] = false
}):OnChanged(function(p905)
    _G.TeleportPly = p905
    if p905 == false then
        wait()
        AutoHaki()
        Tween2(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
        wait()
    end
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        if _G.TeleportPly then
            pcall(function()
                if game.Players:FindFirstChild(_G.SelectPly) then
                    Tween2(game.Players[_G.SelectPly].Character.HumanoidRootPart.CFrame)
                end
            end)
        end
    end
end)
Tabs.Player:AddToggle("ToggleWalkonWater", {
    ["Title"] = "Đi Trên Nư\225\187\155c",
    ["Default"] = true
}):OnChanged(function(p906)
    _G.WalkonWater = p906
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while task.wait() do
        pcall(function()
            if _G.WalkonWater then
                game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 112, 1000)
            else
                game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 80, 1000)
            end
        end)
    end
end)
Tabs.Player:AddToggle("ToggleSpeedRun", {
    ["Title"] = "Chạy Nhanh",
    ["Default"] = true
}):OnChanged(function(p907)
    InfAbility = p907
    if p907 == false then
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility"):Destroy()
    end
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        if InfAbility then
            InfAb()
        end
    end
end)
function InfAb()
    if InfAbility then
        if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") then
            local v908 = Instance.new("ParticleEmitter")
            v908.Acceleration = Vector3.new(0, 0, 0)
            v908.Archivable = true
            v908.Drag = 20
            v908.EmissionDirection = Enum.NormalId.Top
            v908.Enabled = true
            v908.Lifetime = NumberRange.new(0, 0)
            v908.LightInfluence = 0
            v908.LockedToPart = true
            v908.Name = "Agility"
            v908.Rate = 500
            local v909 = {
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 4)
            }
            v908.Size = NumberSequence.new(v909)
            v908.RotSpeed = NumberRange.new(9999, 99999)
            v908.Rotation = NumberRange.new(0, 0)
            v908.Speed = NumberRange.new(30, 30)
            v908.SpreadAngle = Vector2.new(0, 0, 0, 0)
            v908.Texture = ""
            v908.VelocityInheritance = 0
            v908.ZOffset = 2
            v908.Transparency = NumberSequence.new(0)
            v908.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0))
            v908.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        end
    elseif game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") then
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility"):Destroy()
    end
end
Tabs.Player:AddToggle("ToggleNoClip", {
    ["Title"] = "Đi Xuyên Tường",
    ["Default"] = true
}):OnChanged(function(p910)
    _G.LOf = p910
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if _G.LOf then
                local v911, v912, v913 = pairs(game.Players.LocalPlayer.Character:GetDescendants())
                while true do
                    local v914
                    v913, v914 = v911(v912, v913)
                    if v913 == nil then
                        break
                    end
                    if v914:IsA("BasePart") then
                        v914.CanCollide = false
                    end
                end
            end
        end)
    end)
end)
Tabs.Player:AddToggle("ToggleEnablePvp", {
    ["Title"] = "Bật PVP",
    ["Default"] = false
}):OnChanged(function(p915)
    _G.EnabledPvP = p915
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    pcall(function()
        while wait() do
            if _G.EnabledPvP and game:GetService("Players").LocalPlayer.PlayerGui.Main.PvpDisabled.Visible == true then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
            end
        end
    end)
end)
local vu916 = Tabs.Teleport:AddSection("Thế Giới")
Tabs.Teleport:AddToggle("ToggleAutoSea2", {
    ["Title"] = "Nhiệm V\225\187\165 Qua Biển 2",
    ["Default"] = false
}):OnChanged(function(p917)
    _G.Auto_Sea2 = p917
end)
-- [SetValue removed]
spawn(function()
    while wait() do
        if _G.Auto_Sea2 then
            pcall(function()
                if game:GetService("Players").LocalPlayer.Data.Level.Value >= 700 and World1 then
                    if game:GetService("Workspace").Map.Ice.Door.CanCollide == false and game:GetService("Workspace").Map.Ice.Door.Transparency == 1 then
                        local v918 = CFrame.new(4849.29883, 5.65138149, 719.611877)
                        repeat
                            Tween2(v918)
                            wait()
                        until (v918.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or _G.Auto_Sea2 == false
                        wait(1.1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
                        wait(0.5)
                        EquipTool("Key")
                        repeat
                            Tween2(CFrame.new(1347.7124, 37.3751602, - 1325.6488))
                            wait()
                        until (Vector3.new(1347.7124, 37.3751602, - 1325.6488) - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or _G.Auto_Sea2 == false
                        wait(0.5)
						-- goto l3
                    end
                    if game:GetService("Workspace").Map.Ice.Door.CanCollide ~= false or game:GetService("Workspace").Map.Ice.Door.Transparency ~= 1 then
						-- goto l3
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Ice Admiral") then
                        local v919, v920, v921 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                        while true do
                            local v922
                            v921, v922 = v919(v920, v921)
                            if v921 == nil then
                                break
                            end
                            if v922.Name == "Ice Admiral" then
                                if not v922.Humanoid.Health > 0 then
									-- ::l34::
                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
                                elseif v922:FindFirstChild("Humanoid") and (v922:FindFirstChild("HumanoidRootPart") and v922.Humanoid.Health > 0) then
                                    OldCFrameSecond = v922.HumanoidRootPart.CFrame
                                    task.wait(_G.Fast_Delay)
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    v922.HumanoidRootPart.CanCollide = false
                                    v922.Humanoid.WalkSpeed = 0
                                    v922.Head.CanCollide = false
                                    v922.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                    v922.HumanoidRootPart.CFrame = OldCFrameSecond
                                    local _mc80 = v922.HumanoidRootPart.CFrame * Pos
                                    if (v922.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc80) end
                                    AttackNoCoolDown()
                                    sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                    if _G.Auto_Sea2 and (v922.Parent and v922.Humanoid.Health > 0) then
										-- goto l34
                                    end
                                end
                            end
                        end
                    elseif game:GetService("ReplicatedStorage"):FindFirstChild("Ice Admiral") then
                        local _mc_rs = game:GetService("ReplicatedStorage"):FindFirstChild("Ice Admiral") and game:GetService("ReplicatedStorage"):FindFirstChild("Ice Admiral").HumanoidRootPart.CFrame * Pos or nil
                        if _mc_rs and (_mc_rs.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc_rs) end
                    end
                end
				-- ::l3::
            end)
        end
    end
end)
Tabs.Teleport:AddToggle("ToggleAutoSea3", {
    ["Title"] = "Nhiệm V\225\187\165 Qua Biển 3",
    ["Default"] = false
}):OnChanged(function(p923)
    _G.Auto_Sea3 = p923
end)
-- [SetValue removed]
spawn(function()
    while wait() do
        if _G.AutoSea3 then
            pcall(function()
                if game:GetService("Players").LocalPlayer.Data.Level.Value >= 1500 and World2 then
                    _G.AutoLevel = false
                    if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ZQuestProgress", "General") == 0 then
                        Tween2(CFrame.new(- 1926.3221435547, 12.819851875305, 1738.3092041016))
                        if (CFrame.new(- 1926.3221435547, 12.819851875305, 1738.3092041016).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                            wait(1.5)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin")
                        end
                        wait(1.8)
                        if game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") then
                            local v924, v925, v926 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                            while true do
                                local v927
                                v926, v927 = v924(v925, v926)
                                if v926 == nil then
                                    break
                                end
                                if v927.Name == "rip_indra" then
                                    OldCFrameThird = v927.HumanoidRootPart.CFrame
                                    repeat
                                        task.wait(_G.Fast_Delay)
                                        AutoHaki()
                                        EquipTool(SelectWeapon)
                                        local _mc81 = v927.HumanoidRootPart.CFrame * Pos
                                        if (v927.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc81) end
                                        v927.HumanoidRootPart.CFrame = OldCFrameThird
                                        v927.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                        v927.HumanoidRootPart.CanCollide = false
                                        v927.Humanoid.WalkSpeed = 0
                                        AttackNoCoolDown()
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
                                    until _G.AutoSea3 == false or (v927.Humanoid.Health <= 0 or not v927.Parent)
                                end
                            end
                        elseif not game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") and (CFrame.new(- 26880.93359375, 22.848554611206, 473.18951416016).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 1000 then
                            Tween2(CFrame.new(- 26880.93359375, 22.848554611206, 473.18951416016))
                        end
                    end
                end
            end)
        end
    end
end)
Tabs.Teleport:AddButton({
    ["Title"] = "Biển 1",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain")
    end
})
Tabs.Teleport:AddButton({
    ["Title"] = "Biển 2",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
    end
})
Tabs.Teleport:AddButton({
    ["Title"] = "Biển 3",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
    end
})
Tabs.Teleport:AddSection("Đảo")
if Sea1 then
    IslandList = {
        "WindMill",
        "Marine",
        "Middle Town",
        "Jungle",
        "Pirate Village",
        "Desert",
        "Snow Island",
        "MarineFord",
        "Colosseum",
        "Sky Island 1",
        "Sky Island 2",
        "Sky Island 3",
        "Prison",
        "Magma Village",
        "Under Water Island",
        "Fountain City",
        "Shank Room",
        "Mob Island"
    }
elseif Sea2 then
    IslandList = {
        "The Cafe",
        "Frist Spot",
        "Dark Area",
        "Flamingo Mansion",
        "Flamingo Room",
        "Green Zone",
        "Factory",
        "Colossuim",
        "Zombie Island",
        "Two Snow Mountain",
        "Punk Hazard",
        "Cursed Ship",
        "Ice Castle",
        "Forgotten Island",
        "Ussop Island",
        "Mini Sky Island"
    }
elseif Sea3 then
    IslandList = {
        "Mansion",
        "Port Town",
        "Great Tree",
        "Castle On The Sea",
        "MiniSky",
        "Hydra Island",
        "Floating Turtle",
        "Haunted Castle",
        "Ice Cream Island",
        "Peanut Island",
        "Cake Island",
        "Cocoa Island",
        "Candy Island",
        "Tiki Outpost"
    }
end
local v928 = Tabs.Teleport:AddDropdown("DropdownIsland", {
    ["Title"] = "Chọn Đảo",
    ["Values"] = IslandList,
    ["Multi"] = false,
    ["Default"] = 1
})
v928:SetValue(_G.SelectIsland)
v928:OnChanged(function(p929)
    _G.SelectIsland = p929
end)
Tabs.Teleport:AddButton({
    ["Title"] = "Bay Đến Đảo",
    ["Callback"] = function()
        if _G.SelectIsland ~= "WindMill" then
            if _G.SelectIsland ~= "Marine" then
                if _G.SelectIsland ~= "Middle Town" then
                    if _G.SelectIsland ~= "Jungle" then
                        if _G.SelectIsland ~= "Pirate Village" then
                            if _G.SelectIsland ~= "Desert" then
                                if _G.SelectIsland ~= "Snow Island" then
                                    if _G.SelectIsland ~= "MarineFord" then
                                        if _G.SelectIsland ~= "Colosseum" then
                                            if _G.SelectIsland ~= "Sky Island 1" then
                                                if _G.SelectIsland ~= "Sky Island 2" then
                                                    if _G.SelectIsland ~= "Sky Island 3" then
                                                        if _G.SelectIsland ~= "Prison" then
                                                            if _G.SelectIsland ~= "Magma Village" then
                                                                if _G.SelectIsland ~= "Under Water Island" then
                                                                    if _G.SelectIsland ~= "Fountain City" then
                                                                        if _G.SelectIsland ~= "Shank Room" then
                                                                            if _G.SelectIsland ~= "Mob Island" then
                                                                                if _G.SelectIsland ~= "The Cafe" then
                                                                                    if _G.SelectIsland ~= "Frist Spot" then
                                                                                        if _G.SelectIsland ~= "Dark Area" then
                                                                                            if _G.SelectIsland ~= "Flamingo Mansion" then
                                                                                                if _G.SelectIsland ~= "Flamingo Room" then
                                                                                                    if _G.SelectIsland ~= "Green Zone" then
                                                                                                        if _G.SelectIsland ~= "Factory" then
                                                                                                            if _G.SelectIsland ~= "Colossuim" then
                                                                                                                if _G.SelectIsland ~= "Zombie Island" then
                                                                                                                    if _G.SelectIsland ~= "Two Snow Mountain" then
                                                                                                                        if _G.SelectIsland ~= "Punk Hazard" then
                                                                                                                            if _G.SelectIsland ~= "Cursed Ship" then
                                                                                                                                if _G.SelectIsland ~= "Ice Castle" then
                                                                                                                                    if _G.SelectIsland ~= "Forgotten Island" then
                                                                                                                                        if _G.SelectIsland ~= "Ussop Island" then
                                                                                                                                            if _G.SelectIsland ~= "Mini Sky Island" then
                                                                                                                                                if _G.SelectIsland ~= "Great Tree" then
                                                                                                                                                    if _G.SelectIsland ~= "Castle On The Sea" then
                                                                                                                                                        if _G.SelectIsland ~= "MiniSky" then
                                                                                                                                                            if _G.SelectIsland ~= "Port Town" then
                                                                                                                                                                if _G.SelectIsland ~= "Hydra Island" then
                                                                                                                                                                    if _G.SelectIsland ~= "Floating Turtle" then
                                                                                                                                                                        if _G.SelectIsland ~= "Mansion" then
                                                                                                                                                                            if _G.SelectIsland ~= "Castle On The Sea" then
                                                                                                                                                                                if _G.SelectIsland ~= "Haunted Castle" then
                                                                                                                                                                                    if _G.SelectIsland ~= "Ice Cream Island" then
                                                                                                                                                                                        if _G.SelectIsland ~= "Peanut Island" then
                                                                                                                                                                                            if _G.SelectIsland ~= "Cake Island" then
                                                                                                                                                                                                if _G.SelectIsland ~= "Cocoa Island" then
                                                                                                                                                                                                    if _G.SelectIsland ~= "Candy Island" then
                                                                                                                                                                                                        if _G.SelectIsland == "Tiki Outpost" then
                                                                                                                                                                                                            Tween2(CFrame.new(- 16542.447265625, 55.68632888793945, 1044.41650390625))
                                                                                                                                                                                                        end
                                                                                                                                                                                                    else
                                                                                                                                                                                                        Tween2(CFrame.new(- 1014.4241943359375, 149.11068725585938, - 14555.962890625))
                                                                                                                                                                                                    end
                                                                                                                                                                                                else
                                                                                                                                                                                                    Tween2(CFrame.new(87.94276428222656, 73.55451202392578, - 12319.46484375))
                                                                                                                                                                                                end
                                                                                                                                                                                            else
                                                                                                                                                                                                Tween2(CFrame.new(- 1884.7747802734375, 19.327526092529297, - 11666.8974609375))
                                                                                                                                                                                            end
                                                                                                                                                                                        else
                                                                                                                                                                                            Tween2(CFrame.new(- 2062.7475585938, 50.473892211914, - 10232.568359375))
                                                                                                                                                                                        end
                                                                                                                                                                                    else
                                                                                                                                                                                        Tween2(CFrame.new(- 902.56817626953, 79.93204498291, - 10988.84765625))
                                                                                                                                                                                    end
                                                                                                                                                                                else
                                                                                                                                                                                    Tween2(CFrame.new(- 9515.3720703125, 164.00624084473, 5786.0610351562))
                                                                                                                                                                                end
                                                                                                                                                                            else
                                                                                                                                                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 5075.50927734375, 314.5155029296875, - 3150.0224609375))
                                                                                                                                                                            end
                                                                                                                                                                        else
                                                                                                                                                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 12468.5380859375, 375.0094299316406, - 7554.62548828125))
                                                                                                                                                                        end
                                                                                                                                                                    else
                                                                                                                                                                        Tween2(CFrame.new(- 13274.528320313, 531.82073974609, - 7579.22265625))
                                                                                                                                                                    end
                                                                                                                                                                else
                                                                                                                                                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5661.5322265625, 1013.0907592773438, - 334.9649963378906))
                                                                                                                                                                end
                                                                                                                                                            else
                                                                                                                                                                Tween2(CFrame.new(- 290.7376708984375, 6.729952812194824, 5343.5537109375))
                                                                                                                                                            end
                                                                                                                                                        else
                                                                                                                                                            Tween2(CFrame.new(- 260.65557861328, 49325.8046875, - 35253.5703125))
                                                                                                                                                        end
                                                                                                                                                    else
                                                                                                                                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 5075.50927734375, 314.5155029296875, - 3150.0224609375))
                                                                                                                                                    end
                                                                                                                                                else
                                                                                                                                                    Tween2(CFrame.new(2681.2736816406, 1682.8092041016, - 7190.9853515625))
                                                                                                                                                end
                                                                                                                                            else
                                                                                                                                                Tween2(CFrame.new(- 288.74060058594, 49326.31640625, - 35248.59375))
                                                                                                                                            end
                                                                                                                                        else
                                                                                                                                            Tween2(CFrame.new(4816.8618164063, 8.4599885940552, 2863.8195800781))
                                                                                                                                        end
                                                                                                                                    else
                                                                                                                                        Tween2(CFrame.new(- 3032.7641601563, 317.89672851563, - 10075.373046875))
                                                                                                                                    end
                                                                                                                                else
                                                                                                                                    Tween2(CFrame.new(6148.4116210938, 294.38687133789, - 6741.1166992188))
                                                                                                                                end
                                                                                                                            else
                                                                                                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.40197753906, 125.05712890625, 32885.875))
                                                                                                                            end
                                                                                                                        else
                                                                                                                            Tween2(CFrame.new(- 6127.654296875, 15.951762199402, - 5040.2861328125))
                                                                                                                        end
                                                                                                                    else
                                                                                                                        Tween2(CFrame.new(753.14288330078, 408.23559570313, - 5274.6147460938))
                                                                                                                    end
                                                                                                                else
                                                                                                                    Tween2(CFrame.new(- 5622.033203125, 492.19604492188, - 781.78552246094))
                                                                                                                end
                                                                                                            else
                                                                                                                Tween2(CFrame.new(- 1503.6224365234, 219.7956237793, 1369.3101806641))
                                                                                                            end
                                                                                                        else
                                                                                                            Tween2(CFrame.new(424.12698364258, 211.16171264648, - 427.54049682617))
                                                                                                        end
                                                                                                    else
                                                                                                        Tween2(CFrame.new(- 2448.5300292969, 73.016105651855, - 3210.6306152344))
                                                                                                    end
                                                                                                else
                                                                                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(2284.912109375, 15.152034759521484, 905.48291015625))
                                                                                                end
                                                                                            else
                                                                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 281.93707275390625, 306.130615234375, 609.280029296875))
                                                                                            end
                                                                                        else
                                                                                            Tween2(CFrame.new(3780.0302734375, 22.652164459229, - 3498.5859375))
                                                                                        end
                                                                                    else
                                                                                        Tween2(CFrame.new(- 11.311455726624, 29.276733398438, 2771.5224609375))
                                                                                    end
                                                                                else
                                                                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 281.93707275390625, 306.130615234375, 609.280029296875))
                                                                                    wait()
                                                                                    Tween2(CFrame.new(- 380.47927856445, 77.220390319824, 255.82550048828))
                                                                                end
                                                                            else
                                                                                Tween2(CFrame.new(- 2850.20068, 7.39224768, 5354.99268))
                                                                            end
                                                                        else
                                                                            Tween2(CFrame.new(- 1442.16553, 29.8788261, - 28.3547478))
                                                                        end
                                                                    else
                                                                        Tween2(CFrame.new(5127.1284179688, 59.501365661621, 4105.4458007813))
                                                                    end
                                                                else
                                                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
                                                                end
                                                            else
                                                                Tween2(CFrame.new(- 5247.7163085938, 12.883934020996, 8504.96875))
                                                            end
                                                        else
                                                            Tween2(CFrame.new(4875.330078125, 5.6519818305969, 734.85021972656))
                                                        end
                                                    else
                                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 7894.6176757813, 5547.1416015625, - 380.29119873047))
                                                    end
                                                else
                                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 4607.82275, 872.54248, - 1667.55688))
                                                end
                                            else
                                                Tween2(CFrame.new(- 4869.1025390625, 733.46051025391, - 2667.0180664063))
                                            end
                                        else
                                            Tween2(CFrame.new(- 1427.6203613281, 7.2881078720093, - 2792.7722167969))
                                        end
                                    else
                                        Tween2(CFrame.new(- 4914.8212890625, 50.963626861572, 4281.0278320313))
                                    end
                                else
                                    Tween2(CFrame.new(1347.8067626953, 104.66806030273, - 1319.7370605469))
                                end
                            else
                                Tween2(CFrame.new(944.15789794922, 20.919729232788, 4373.3002929688))
                            end
                        else
                            Tween2(CFrame.new(- 1181.3093261719, 4.7514905929565, 3803.5456542969))
                        end
                    else
                        Tween2(CFrame.new(- 1612.7957763672, 36.852081298828, 149.12843322754))
                    end
                else
                    Tween2(CFrame.new(- 690.33081054688, 15.09425163269, 1582.2380371094))
                end
            else
                Tween2(CFrame.new(- 2566.4296875, 6.8556680679321, 2045.2561035156))
            end
        else
            Tween2(CFrame.new(979.79895019531, 16.516613006592, 1429.0466308594))
        end
    end
})
Tabs.Visual:AddSection("Giả Mạo")
Tabs.Visual:AddButton({
    ["Title"] = "Giả",
    ["Callback"] = function()
        local v930 = game:GetService("Players").LocalPlayer
        local v931 = require(game:GetService("ReplicatedStorage").Notification)
        local v932 = v930:WaitForChild("Data")
        local v933 = require(game.ReplicatedStorage:WaitForChild("EXPFunction"))
        local v934 = require(game:GetService("ReplicatedStorage").Effect.Container.LevelUp)
        local v935 = require(game:GetService("ReplicatedStorage").Util.Sound)
        local v936 = game:GetService("ReplicatedStorage").Util.Sound.Storage.Other:FindFirstChild("LevelUp_Proxy") or game:GetService("ReplicatedStorage").Util.Sound.Storage.Other:FindFirstChild("LevelUp")
        function v129(p937)
            repeat
                local v938
                p937, v938 = string.gsub(p937, "^(-?%d+)(%d%d%d)", "%1,%2")
            until v938 == 0
            return p937
        end
        v931.new("<Color=Yellow>QUEST COMPLETED!<Color=/>"):Display()
        v931.new("Earned<Color=Yellow>9,999,999,999,999 Exp.<Color=/>(+None)"):Display()
        v931.new("Earned<Color=Green>$9,999,999,999,999<Color=/>"):Display()
        v930.Data.Exp.Value = 999999999999
        v930.Data.Beli.Value = v930.Data.Beli.Value + 999999999999
        delay = 0
        count = 0
        while v930.Data.Exp.Value - v933(v932.Level.Value) > 0 do
            v930.Data.Exp.Value = v930.Data.Exp.Value - v933(v932.Level.Value)
            v930.Data.Level.Value = v930.Data.Level.Value + 1
            v930.Data.Points.Value = v930.Data.Points.Value + 3
            v934({
                v930
            })
            v935:Play(v936.Value)
            v931.new("<Color=Green>LEVEL UP!<Color=/>(" .. v930.Data.Level.Value .. ")"):Display()
            count = count + 1
            if count >= 5 then
                delay = tick()
                count = 0
                wait()
            end
        end
    end
})
Tabs.Visual:AddInput("Input_Level", {
    ["Title"] = "Cấp",
    ["Default"] = "",
    ["Placeholder"] = "Nhắp",
    ["Numeric"] = false,
    ["Finished"] = false,
    ["Callback"] = function(p939)
        game:GetService("Players").LocalPlayer.Data.Level.Value = tonumber(p939)
    end
})
Tabs.Visual:AddInput("Input_EXP", {
    ["Title"] = "Kinh Nghiậm",
    ["Default"] = "",
    ["Placeholder"] = "Nhắp",
    ["Numeric"] = false,
    ["Finished"] = false,
    ["Callback"] = function(p940)
        game:GetService("Players").LocalPlayer.Data.Exp.Value = tonumber(p940)
    end
})
Tabs.Visual:AddInput("Input_Beli", {
    ["Title"] = "Tiền",
    ["Default"] = "",
    ["Placeholder"] = "Nhắp",
    ["Numeric"] = false,
    ["Finished"] = false,
    ["Callback"] = function(p941)
        game:GetService("Players").LocalPlayer.Data.Beli.Value = tonumber(p941)
    end
})
Tabs.Visual:AddInput("Input_Fragments", {
    ["Title"] = "\239\191\189iểm F",
    ["Default"] = "",
    ["Placeholder"] = "Nhắp",
    ["Numeric"] = false,
    ["Finished"] = false,
    ["Callback"] = function(p942)
        game:GetService("Players").LocalPlayer.Data.Fragments.Value = tonumber(p942)
    end
})
local v943 = game.ReplicatedStorage:FindFirstChild("Remotes").CommF_:InvokeServer("GetFruits")
Table_DevilFruitSniper = {}
ShopDevilSell = {}
local v944 = next
local v945 = nil
while true do
    local v946
    v945, v946 = v944(v943, v945)
    if v945 == nil then
        break
    end
    table.insert(Table_DevilFruitSniper, v946.Name)
    if v946.OnSale then
        table.insert(ShopDevilSell, v946.Name)
    end
end
_G.SelectFruit = nil
_G.PermanentFruit = nil
_G.AutoBuyFruitSniper = false
_G.AutoSwitchPermanentFruit = false
Tabs.Fruit:AddSection("Trái Ác Quỷ")
local v947 = Tabs.Fruit:AddDropdown("DropdownFruit", {
    ["Title"] = "Chọn Trái",
    ["Values"] = Table_DevilFruitSniper,
    ["Multi"] = false,
    ["Default"] = 1
})
v947:SetValue(_G.SelectFruit)
v947:OnChanged(function(p948)
    _G.SelectFruit = p948
end)
Tabs.Fruit:AddToggle("ToggleFruit", {
    ["Title"] = "Mua Trái Chọn",
    ["Default"] = false
}):OnChanged(function(p949)
    if p949 then
        _G.AutoBuyFruitSniper = true
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PurchaseRawFruit", _G.SelectFruit, false)
        end)
        _G.AutoBuyFruitSniper = false
    end
end)
-- [SetValue skipped - Library không cần]
local v950 = Tabs.Fruit:AddDropdown("DropdownPermanentFruit", {
    ["Title"] = "Chọn Trái V\196\169nh Viễn",
    ["Values"] = Table_DevilFruitSniper,
    ["Multi"] = false,
    ["Default"] = 1
})
v950:SetValue(_G.PermanentFruit)
v950:OnChanged(function(p951)
    _G.PermanentFruit = p951
end)
Tabs.Fruit:AddToggle("TogglePermanentFruit", {
    ["Title"] = "\239\191\189\225\187\149i Trái V\196\169nh Viễn",
    ["Default"] = false
}):OnChanged(function(p952)
    if p952 then
        _G.AutoSwitchPermanentFruit = true
        pcall(function()
            local v953 = {
                "SwitchFruit",
                _G.PermanentFruit
            }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v953))
        end)
        _G.AutoSwitchPermanentFruit = false
    end
end)
-- [SetValue skipped - Library không cần]
Tabs.Fruit:AddToggle("ToggleStore", {
    ["Title"] = "Lưu Trái",
    ["Default"] = false
}):OnChanged(function(p954)
    _G.AutoStoreFruit = p954
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while task.wait() do
        if _G.AutoStoreFruit then
            pcall(function()
                if _G.AutoStoreFruit then
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bomb Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Bomb Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Bomb-Bomb", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Bomb Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Spike Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spike Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Spike-Spike", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spike Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Chop Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Chop Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Chop-Chop", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Chop Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Spring Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spring Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Spring-Spring", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spring Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Rocket Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Kilo Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Rocket-Rocket", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Kilo Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Smoke Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Smoke Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Smoke-Smoke", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Smoke Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Spin Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spin Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Spin-Spin", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spin Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Flame Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Flame Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Flame-Flame", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Flame Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Falcon Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Falcon Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Falcon", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("alcon Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Ice Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Ice Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Ice-Ice", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Ice Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Sand Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Sand Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Sand-Sand", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Sand Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dark Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dark Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Dark-Dark", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dark Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Ghost Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Revive Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Ghost-Ghost", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Revive Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Diamond Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Diamond Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Diamond-Diamond", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Diamond Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Light Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Light Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Light-Light", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Light Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Love Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Love Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Love-Love", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Love Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Rubber Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Rubber Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Rubber-Rubber", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Rubber Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Barrier Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Barrier Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Barrier-Barrier", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Barrier Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Magma Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Magma Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Magma-Magma", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Magma Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Portal Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Portal Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Door-Door", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Portal Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Quake Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Quake Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Quake-Quake", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Quake Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Buddha Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Buddha Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buddha", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Buddha Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Spider Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spider Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Spider-Spider", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spider Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bird: Phoenix Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Phoenix Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Phoenix", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Phoenix Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Rumble Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Rumble Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Rumble-Rumble", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Rumble Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Pain Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Pain Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Pain-Pain", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Pain Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Gravity Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Gravity Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Gravity-Gravity", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Gravity Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dough Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dough Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Dough-Dough", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dough Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Shadow Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Shadow Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Shadow-Shadow", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Shadow Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Venom Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Venom Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Venom-Venom", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Venom Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Control Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Control Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Control-Control", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Control Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Spirit Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spirit Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Soul-Soul", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spirit Fruit"))
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dragon Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Dragon-Dragon", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dragon Fruit"))
                        if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Leopard Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Leopard Fruit") then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", "Leopard-Leopard", game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Leopard Fruit"))
                        end
                    end
                end
            end)
        end
        wait()
    end
end)
Tabs.Fruit:AddToggle("ToggleRandomFruit", {
    ["Title"] = "Random Trái",
    ["Default"] = false
}):OnChanged(function(p955)
    _G.Random_Auto = p955
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    pcall(function()
        while wait() do
            if _G.Random_Auto then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy")
            end
        end
    end)
end)
Tabs.Fruit:AddToggle("ToggleCollectTP", {
    ["Title"] = "Bay Đến Trái",
    ["Default"] = false
}):OnChanged(function(p956)
    _G.CollectFruitTP = p956
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        if _G.CollectFruitTP then
            local v957, v958, v959 = pairs(game.Workspace:GetChildren())
            while true do
                local v960
                v959, v960 = v957(v958, v959)
                if v959 == nil then
                    break
                end
                if string.find(v960.Name, "Fruit") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v960.Handle.CFrame
                end
            end
        end
    end
end)
Tabs.Fruit:AddToggle("ToggleCollect", {
    ["Title"] = "D\225\187\139ch Chuyển Đến Trái",
    ["Default"] = false
}):OnChanged(function(p961)
    _G.Tweenfruit = p961
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        if _G.Tweenfruit then
            local v962, v963, v964 = pairs(game.Workspace:GetChildren())
            while true do
                local v965
                v964, v965 = v962(v963, v964)
                if v964 == nil then
                    break
                end
                if string.find(v965.Name, "Fruit") then
                    Tween2(v965.Handle.CFrame)
                end
            end
        end
    end
end)
Tabs.Fruit:AddSection("Định Vị")
Tabs.Fruit:AddToggle("ToggleEspPlayer", {
    ["Title"] = "Người Chơi",
    ["Default"] = false
}):OnChanged(function(p966)
    ESPPlayer = p966
    UpdatePlayerChams()
end)
-- [SetValue skipped - Library không cần]
Tabs.Fruit:AddToggle("ToggleEspFruit", {
    ["Title"] = "Trái",
    ["Default"] = false
}):OnChanged(function(p967)
    DevilFruitESP = p967
    while DevilFruitESP do
        wait()
        UpdateDevilChams()
    end
end)
-- [SetValue skipped - Library không cần]
Tabs.Fruit:AddToggle("ToggleEspIsland", {
    ["Title"] = "Đảo",
    ["Default"] = false
}):OnChanged(function(p968)
    IslandESP = p968
    while IslandESP do
        wait()
        UpdateIslandESP()
    end
end)
-- [SetValue skipped - Library không cần]
Tabs.Fruit:AddToggle("ToggleEspFlower", {
    ["Title"] = "Hoa",
    ["Default"] = false
}):OnChanged(function(p969)
    FlowerESP = p969
    UpdateFlowerChams()
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        if FlowerESP then
            UpdateFlowerChams()
        end
        if DevilFruitESP then
            UpdateDevilChams()
        end
        if ChestESP then
            UpdateChestChams()
        end
        if ESPPlayer then
            UpdatePlayerChams()
        end
        if RealFruitESP then
            UpdateRealFruitChams()
        end
    end
end)
Tabs.Fruit:AddToggle("ToggleEspRealFruit", {
    ["Title"] = "Trái Dủa Kh\225\187\155m Táo",
    ["Default"] = false
}):OnChanged(function(p970)
    RealFruitEsp = p970
    while RealFruitEsp do
        wait()
        UpdateRealFruitEsp()
    end
end)
-- [SetValue skipped - Library không cần]
function UpdateRealFruitEsp()
	-- upvalues: (ref) vu896
    local v971, v972, v973 = pairs(game.Workspace.AppleSpawner:GetChildren())
    while true do
        local v974
        v973, v974 = v971(v972, v973)
        if v973 == nil then
            break
        end
        if v974:IsA("Tool") then
            if RealFruitEsp then
                if v974.Handle:FindFirstChild("NameEsp" .. Number) then
                    v974.Handle["NameEsp" .. Number].TextLabel.Text = v974.Name .. " " .. vu896((game:GetService("Players").LocalPlayer.Character.Head.Position - v974.Handle.Position).Magnitude / 3) .. " Distance"
                else
                    local v975 = Instance.new("BillboardGui", v974.Handle)
                    v975.Name = "NameEsp" .. Number
                    v975.ExtentsOffset = Vector3.new(0, 1, 0)
                    v975.Size = UDim2.new(1, 200, 1, 30)
                    v975.Adornee = v974.Handle
                    v975.AlwaysOnTop = true
                    local v976 = Instance.new("TextLabel", v975)
                    v976.Font = Enum.Font.GothamSemibold
                    v976.FontSize = "Size14"
                    v976.TextWrapped = true
                    v976.Size = UDim2.new(1, 0, 1, 0)
                    v976.TextYAlignment = "Top"
                    v976.BackgroundTransparency = 1
                    v976.TextStrokeTransparency = 0.5
                    v976.TextColor3 = Color3.fromRGB(255, 0, 0)
                    v976.Text = v974.Name .. " \n" .. vu896((game:GetService("Players").LocalPlayer.Character.Head.Position - v974.Handle.Position).Magnitude / 3) .. " Distance"
                end
            elseif v974.Handle:FindFirstChild("NameEsp" .. Number) then
                v974.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
            end
        end
    end
    local v977, v978, v979 = pairs(game.Workspace.PineappleSpawner:GetChildren())
    while true do
        local v980
        v979, v980 = v977(v978, v979)
        if v979 == nil then
            break
        end
        if v980:IsA("Tool") then
            if RealFruitEsp then
                if v980.Handle:FindFirstChild("NameEsp" .. Number) then
                    v980.Handle["NameEsp" .. Number].TextLabel.Text = v980.Name .. " " .. vu896((game:GetService("Players").LocalPlayer.Character.Head.Position - v980.Handle.Position).Magnitude / 3) .. " Distance"
                else
                    local v981 = Instance.new("BillboardGui", v980.Handle)
                    v981.Name = "NameEsp" .. Number
                    v981.ExtentsOffset = Vector3.new(0, 1, 0)
                    v981.Size = UDim2.new(1, 200, 1, 30)
                    v981.Adornee = v980.Handle
                    v981.AlwaysOnTop = true
                    local v982 = Instance.new("TextLabel", v981)
                    v982.Font = Enum.Font.GothamSemibold
                    v982.FontSize = "Size14"
                    v982.TextWrapped = true
                    v982.Size = UDim2.new(1, 0, 1, 0)
                    v982.TextYAlignment = "Top"
                    v982.BackgroundTransparency = 1
                    v982.TextStrokeTransparency = 0.5
                    v982.TextColor3 = Color3.fromRGB(255, 174, 0)
                    v982.Text = v980.Name .. " \n" .. vu896((game:GetService("Players").LocalPlayer.Character.Head.Position - v980.Handle.Position).Magnitude / 3) .. " Distance"
                end
            elseif v980.Handle:FindFirstChild("NameEsp" .. Number) then
                v980.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
            end
        end
    end
    local v983, v984, v985 = pairs(game.Workspace.BananaSpawner:GetChildren())
    while true do
        local v986
        v985, v986 = v983(v984, v985)
        if v985 == nil then
            break
        end
        if v986:IsA("Tool") then
            if RealFruitEsp then
                if v986.Handle:FindFirstChild("NameEsp" .. Number) then
                    v986.Handle["NameEsp" .. Number].TextLabel.Text = v986.Name .. " " .. vu896((game:GetService("Players").LocalPlayer.Character.Head.Position - v986.Handle.Position).Magnitude / 3) .. " Distance"
                else
                    local v987 = Instance.new("BillboardGui", v986.Handle)
                    v987.Name = "NameEsp" .. Number
                    v987.ExtentsOffset = Vector3.new(0, 1, 0)
                    v987.Size = UDim2.new(1, 200, 1, 30)
                    v987.Adornee = v986.Handle
                    v987.AlwaysOnTop = true
                    local v988 = Instance.new("TextLabel", v987)
                    v988.Font = Enum.Font.GothamSemibold
                    v988.FontSize = "Size14"
                    v988.TextWrapped = true
                    v988.Size = UDim2.new(1, 0, 1, 0)
                    v988.TextYAlignment = "Top"
                    v988.BackgroundTransparency = 1
                    v988.TextStrokeTransparency = 0.5
                    v988.TextColor3 = Color3.fromRGB(251, 255, 0)
                    v988.Text = v986.Name .. " \n" .. vu896((game:GetService("Players").LocalPlayer.Character.Head.Position - v986.Handle.Position).Magnitude / 3) .. " Distance"
                end
            elseif v986.Handle:FindFirstChild("NameEsp" .. Number) then
                v986.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
            end
        end
    end
end
Tabs.Fruit:AddToggle("ToggleIslandMirageEsp", {
    ["Title"] = "Đảo Bí \225\186\168n",
    ["Default"] = false
}):OnChanged(function(p989)
    IslandMirageEsp = p989
    while IslandMirageEsp do
        wait()
        UpdateIslandMirageEsp()
    end
end)
-- [SetValue skipped - Library không cần]
function isnil(p990)
    return p990 == nil
end
local function vu992(p991)
    return math.floor(tonumber(p991) + 0.5)
end
Number = math.random(1, 1000000)
function UpdateIslandMirageEsp()
	-- upvalues: (ref) vu992
    local v993, v994, v995 = pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren())
    while true do
        local vu996
        v995, vu996 = v993(v994, v995)
        if v995 == nil then
            break
        end
        pcall(function()
			-- upvalues: (ref) vu996, (ref) vu992
            if MirageIslandESP then
                if vu996.Name == "Mirage Island" then
                    if vu996:FindFirstChild("NameEsp") then
                        vu996.NameEsp.TextLabel.Text = vu996.Name .. "   \n" .. vu992((game:GetService("Players").LocalPlayer.Character.Head.Position - vu996.Position).Magnitude / 3) .. " M"
                    else
                        local v997 = Instance.new("BillboardGui", vu996)
                        v997.Name = "NameEsp"
                        v997.ExtentsOffset = Vector3.new(0, 1, 0)
                        v997.Size = UDim2.new(1, 200, 1, 30)
                        v997.Adornee = vu996
                        v997.AlwaysOnTop = true
                        local v998 = Instance.new("TextLabel", v997)
                        v998.Font = Enum.Font.Code
                        v998.FontSize = Enum.FontSize.Size14
                        v998.TextWrapped = true
                        v998.Size = UDim2.new(1, 0, 1, 0)
                        v998.TextYAlignment = Enum.TextYAlignment.Top
                        v998.BackgroundTransparency = 1
                        v998.TextStrokeTransparency = 0.5
                        v998.TextColor3 = Color3.fromRGB(80, 245, 245)
                    end
                end
            elseif vu996:FindFirstChild("NameEsp") then
                vu996:FindFirstChild("NameEsp"):Destroy()
            end
        end)
    end
end
Tabs.Raid:AddSection("Đột Kích")
local v999 = Tabs.Raid:AddDropdown("DropdownRaid", {
    ["Title"] = "Chọn Chip",
    ["Values"] = {
        "Flame",
        "Ice",
        "Quake",
        "Light",
        "Dark",
        "Spider",
        "Rumble",
        "Magma",
        "Buddha",
        "Sand",
        "Phoenix",
        "Dough"
    },
    ["Multi"] = false,
    ["Default"] = 1
})
v999:SetValue(SelectChip)
v999:OnChanged(function(p1000)
    SelectChip = p1000
end)
Tabs.Raid:AddToggle("ToggleBuy", {
    ["Title"] = "Mua Chip",
    ["Default"] = false
}):OnChanged(function(p1001)
    _G.Auto_Buy_Chips_Dungeon = p1001
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        if _G.Auto_Buy_Chips_Dungeon then
            pcall(function()
                local v1002 = {
                    "RaidsNpc",
                    "Select",
                    SelectChip
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(v1002))
            end)
        end
    end
end)
Tabs.Raid:AddToggle("ToggleStart", {
    ["Title"] = "Bắt Đầu Raid",
    ["Default"] = false
}):OnChanged(function(p1003)
    _G.Auto_StartRaid = p1003
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        pcall(function()
            if _G.Auto_StartRaid and (game:GetService("Players").LocalPlayer.PlayerGui.Main.Timer.Visible == false and (not game:GetService("Workspace")._WorldOrigin.Locations:FindFirstChild("Island 1") and (game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Special Microchip") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Special Microchip")))) then
                if Sea2 then
                    Tween2(CFrame.new(- 6438.73535, 250.645355, - 4501.50684))
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                        "SetSpawnPoint"
                    }))
                    fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
                elseif Sea3 then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 5075.50927734375, 314.5155029296875, - 3150.0224609375))
                    Tween2(CFrame.new(- 5017.40869, 314.844055, - 2823.0127, - 0.925743818, 4.48217499e-8, - 0.378151238, 4.55503146e-9, 1, 1.07377559e-7, 0.378151238, 9.7681621e-8, - 0.925743818))
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                        "SetSpawnPoint"
                    }))
                    fireclickdetector(game:GetService("Workspace").Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector)
                end
            end
        end)
    end
end)
Tabs.Raid:AddToggle("ToggleNextIsland", {
    ["Title"] = "Đánh Quái Raid+Bay Đến Đảo",
    ["Default"] = false
}):OnChanged(function(p1004)
    AutoNextIsland = p1004
    if not p1004 then
        _G.AutoNear = false
    end
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    local vu1005 = {}
    while task.wait() do
        if AutoNextIsland then
            pcall(function()
				-- upvalues: (ref) vu1005
                local v1006 = game.Players.LocalPlayer.Character
                if v1006 and v1006:FindFirstChild("HumanoidRootPart") then
                    local v1007 = game:GetService("Workspace")._WorldOrigin.Locations
                    local v1008 = v1006.HumanoidRootPart.Position
                    if (v1008 - Vector3.new(- 6438.73535, 250.645355, - 4501.50684)).Magnitude < 1 or (v1008 - Vector3.new(- 5017.40869, 314.844055, - 2823.0127)).Magnitude < 1 then
                        vu1005 = {}
                    end
                    if v1007:FindFirstChild("Island 1") then
                        _G.AutoNear = true
                    end
                    if v1007:FindFirstChild("Island 2") and not vu1005["Island 2"] then
                        Tween2(v1007:FindFirstChild("Island 2").CFrame)
                        vu1005["Island 2"] = true
                        AutoNextIsland = false
                        wait()
                        AutoNextIsland = true
                    elseif v1007:FindFirstChild("Island 3") and not vu1005["Island 3"] then
                        Tween2(v1007:FindFirstChild("Island 3").CFrame)
                        vu1005["Island 3"] = true
                        AutoNextIsland = false
                        wait()
                        AutoNextIsland = true
                    elseif v1007:FindFirstChild("Island 4") and not vu1005["Island 4"] then
                        Tween2(v1007:FindFirstChild("Island 4").CFrame)
                        vu1005["Island 4"] = true
                        AutoNextIsland = false
                        wait()
                        AutoNextIsland = true
                    elseif v1007:FindFirstChild("Island 5") and not vu1005["Island 5"] then
                        Tween2(v1007:FindFirstChild("Island 5").CFrame)
                        vu1005["Island 5"] = true
                        AutoNextIsland = false
                        wait()
                        AutoNextIsland = true
                    end
                end
            end)
        end
    end
end)
Tabs.Raid:AddToggle("ToggleAwake", {
    ["Title"] = "Thức Tỉnh",
    ["Default"] = false
}):OnChanged(function(p1009)
    AutoAwakenAbilities = p1009
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while task.wait() do
        if AutoAwakenAbilities then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Awakener", "Awaken")
            end)
        end
    end
end)
Tabs.Raid:AddToggle("ToggleGetFruit", {
    ["Title"] = "Lấy Trái Dư\225\187\155i 1 Triệu",
    ["Default"] = false
}):OnChanged(function(p1010)
    _G.Autofruit = p1010
end)
spawn(function()
    while wait() do
        pcall(function()
            if _G.Autofruit then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "LoadFruit",
                    "Rocket-Rocket"
                }))
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "LoadFruit",
                    "Spin-Spin"
                }))
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "LoadFruit",
                    "Chop-Chop"
                }))
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "LoadFruit",
                    "Spring-Spring"
                }))
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "LoadFruit",
                    "Bomb-Bomb"
                }))
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "LoadFruit",
                    "Smoke-Smoke"
                }))
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "LoadFruit",
                    "Spike-Spike"
                }))
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "LoadFruit",
                    "Flame-Flame"
                }))
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "LoadFruit",
                    "Falcon-Falcon"
                }))
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "LoadFruit",
                    "Ice-Ice"
                }))
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "LoadFruit",
                    "Sand-Sand"
                }))
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "LoadFruit",
                    "Dark-Dark"
                }))
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "LoadFruit",
                    "Ghost-Ghost"
                }))
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "LoadFruit",
                    "Diamond-Diamond"
                }))
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "LoadFruit",
                    "Light-Light"
                }))
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "LoadFruit",
                    "Rubber-Rubber"
                }))
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
                    "LoadFruit",
                    "Barrier-Barrier"
                }))
            end
        end)
    end
end)
if Sea2 then
    Tabs.Raid:AddButton({
        ["Title"] = "Bay Đến Chợ Tắp Kích",
        ["Callback"] = function()
            Tween2(CFrame.new(- 6438.73535, 250.645355, - 4501.50684))
        end
    })
elseif Sea3 then
    Tabs.Raid:AddButton({
        ["Title"] = "Bay Đến Chợ Tắp Kích",
        ["Callback"] = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 5075.50927734375, 314.5155029296875, - 3150.0224609375))
            Tween2(CFrame.new(- 5017.40869, 314.844055, - 2823.0127, - 0.925743818, 4.48217499e-8, - 0.378151238, 4.55503146e-9, 1, 1.07377559e-7, 0.378151238, 9.7681621e-8, - 0.925743818))
        end
    })
end
Tabs.Raid:AddSection("Tắp Kích Law")
Tabs.Raid:AddToggle("ToggleLaw", {
    ["Title"] = "Mua Chip Và Đánh Law",
    ["Default"] = false
}):OnChanged(function(p1011)
    Auto_Law = p1011
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    pcall(function()
        while wait() do
            if Auto_Law and not (game:GetService("Players").LocalPlayer.Character:FindFirstChild("Microchip") or (game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Microchip") or (game:GetService("Workspace").Enemies:FindFirstChild("Order") or game:GetService("ReplicatedStorage"):FindFirstChild("Order")))) then
                wait()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Microchip", "1")
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Microchip", "2")
            end
        end
    end)
end)
spawn(function()
    pcall(function()
        while wait() do
            if Auto_Law then
                if not game:GetService("Workspace").Enemies:FindFirstChild("Order") and (not game:GetService("ReplicatedStorage"):FindFirstChild("Order") and (game:GetService("Players").LocalPlayer.Character:FindFirstChild("Microchip") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Microchip"))) then
                    fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
                end
                if game:GetService("ReplicatedStorage"):FindFirstChild("Order") or game:GetService("Workspace").Enemies:FindFirstChild("Order") then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Order") then
                        local v1012, v1013, v1014 = pairs(game:GetService("Workspace").Enemies:GetChildren())
                        while true do
                            local v1015
                            v1014, v1015 = v1012(v1013, v1014)
                            if v1014 == nil then
                                break
                            end
                            if v1015.Name == "Order" then
                                repeat
                                    wait(_G.Fast_Delay)
                                    AttackNoCoolDown()
                                    AutoHaki()
                                    EquipTool(SelectWeapon)
                                    local _mc82 = v1015.HumanoidRootPart.CFrame * Pos
                                    if (v1015.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc82) end
                                    v1015.HumanoidRootPart.CanCollide = false
                                    v1015.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                until not v1015.Parent or (v1015.Humanoid.Health <= 0 or Auto_Law == false)
                            end
                        end
                    elseif game:GetService("ReplicatedStorage"):FindFirstChild("Order") then
                        Tween2(CFrame.new(- 6217.2021484375, 28.047645568848, - 5053.1357421875))
                    end
                end
            end
        end
    end)
end)
Tabs.Race:AddSection("Nâng Cấp Chủng Tộc")
Tabs.Race:AddButton({
    ["Title"] = "Đền Thời Gian",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(28286.35546875, 14895.3017578125, 102.62469482421875))
    end
})
Tabs.Race:AddButton({
    ["Title"] = "Cần Gạt",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(28286.35546875, 14895.3017578125, 102.62469482421875))
        Tween2(CFrame.new(28575.181640625, 14936.6279296875, 72.31636810302734))
    end
})
Tabs.Race:AddButton({
    ["Title"] = "Chợ Mua Gear",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(28286.35546875, 14895.3017578125, 102.62469482421875))
        Tween2(CFrame.new(28981.552734375, 14888.4267578125, - 120.245849609375))
    end
})
Tabs.Race:AddSection("Tộc")
Tabs.Race:AddButton({
    ["Title"] = "Cửa Tộc",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(28286.35546875, 14895.3017578125, 102.62469482421875))
        if game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Human" then
            if game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Skypiea" then
                if game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Fishman" then
                    if game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Cyborg" then
                        if game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Ghoul" then
                            if game:GetService("Players").LocalPlayer.Data.Race.Value == "Mink" then
                                Tween2(CFrame.new(29012.341796875, 14890.9755859375, - 380.1492614746094))
                            end
                        else
                            Tween2(CFrame.new(28674.244140625, 14890.6767578125, 445.4310607910156))
                        end
                    else
                        Tween2(CFrame.new(28502.681640625, 14895.9755859375, - 423.7279357910156))
                    end
                else
                    Tween2(CFrame.new(28231.17578125, 14890.9755859375, - 211.64173889160156))
                end
            else
                Tween2(CFrame.new(28960.158203125, 14919.6240234375, 235.03948974609375))
            end
        else
            Tween2(CFrame.new(29221.822265625, 14890.9755859375, - 205.99114990234375))
        end
    end
})
Tabs.Race:AddToggle("ToggleHumanandghoul", {
    ["Title"] = "Hoàn Thành \225\186\162i [Human/Ghoul]",
    ["Default"] = false
}):OnChanged(function(p1016)
    KillAura = p1016
end)
-- [SetValue skipped - Library không cần]
Tabs.Race:AddToggle("ToggleAutotrial", {
    ["Title"] = "Hoàn Thành \225\186\162i",
    ["Default"] = false
}):OnChanged(function(p1017)
    _G.AutoQuestRace = p1017
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoQuestRace then
                if game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Human" then
                    if game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Skypiea" then
                        if game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Fishman" then
                            if game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Cyborg" then
                                if game:GetService("Players").LocalPlayer.Data.Race.Value ~= "Ghoul" then
                                    if game:GetService("Players").LocalPlayer.Data.Race.Value == "Mink" then
                                        local v1018, v1019, v1020 = pairs(game:GetService("Workspace"):GetDescendants())
                                        while true do
                                            local v1021
                                            v1020, v1021 = v1018(v1019, v1020)
                                            if v1020 == nil then
                                                break
                                            end
                                            if v1021.Name == "StartPoint" then
                                                Tween2(v1021.CFrame * CFrame.new(0, 10, 0))
                                            end
                                        end
                                    end
                                else
                                    local v1022, v1023, v1024 = pairs(game.Workspace.Enemies:GetDescendants())
                                    while true do
                                        local vu1025
                                        v1024, vu1025 = v1022(v1023, v1024)
                                        if v1024 == nil then
                                            break
                                        end
                                        if vu1025:FindFirstChild("Humanoid") and (vu1025:FindFirstChild("HumanoidRootPart") and vu1025.Humanoid.Health > 0) then
                                            pcall(function()
												-- upvalues: (ref) vu1025
                                                repeat
                                                    wait()
                                                    vu1025.Humanoid.Health = 0
                                                    vu1025.HumanoidRootPart.CanCollide = false
                                                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                                                until not _G.AutoQuestRace or (not vu1025.Parent or vu1025.Humanoid.Health <= 0)
                                            end)
                                        end
                                    end
                                end
                            else
                                Tween2(CFrame.new(28654, 14898.7832, - 30, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                            end
                        else
                            local v1026, v1027, v1028 = pairs(game:GetService("Workspace").SeaBeasts.SeaBeast1:GetDescendants())
                            while true do
                                local v1029
                                v1028, v1029 = v1026(v1027, v1028)
                                if v1028 == nil then
                                    break
                                end
                                if v1029.Name == "HumanoidRootPart" then
                                    local _mc_v1029 = v1029.CFrame * Pos
                                    if (v1029.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then BKP(_mc_v1029) end
                                    local v1030, v1031, v1032 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())
                                    while true do
                                        local v1033
                                        v1032, v1033 = v1030(v1031, v1032)
                                        if v1032 == nil then
                                            break
                                        end
                                        if v1033:IsA("Tool") and v1033.ToolTip == "Melee" then
                                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v1033)
                                        end
                                    end
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait(0.2)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait(0.2)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    local v1034, v1035, v1036 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())
                                    while true do
                                        local v1037
                                        v1036, v1037 = v1034(v1035, v1036)
                                        if v1036 == nil then
                                            break
                                        end
                                        if v1037:IsA("Tool") and v1037.ToolTip == "Blox Fruit" then
                                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v1037)
                                        end
                                    end
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait(0.2)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait(0.2)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait()
                                    local v1038, v1039, v1040 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())
                                    while true do
                                        local v1041
                                        v1040, v1041 = v1038(v1039, v1040)
                                        if v1040 == nil then
                                            break
                                        end
                                        if v1041:IsA("Tool") and v1041.ToolTip == "Sword" then
                                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v1041)
                                        end
                                    end
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait(0.2)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait(0.2)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait()
                                    local v1042, v1043, v1044 = pairs(game.Players.LocalPlayer.Backpack:GetChildren())
                                    while true do
                                        local v1045
                                        v1044, v1045 = v1042(v1043, v1044)
                                        if v1044 == nil then
                                            break
                                        end
                                        if v1045:IsA("Tool") and v1045.ToolTip == "Gun" then
                                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v1045)
                                        end
                                    end
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait(0.2)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    wait(0.2)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                                end
                            end
                        end
                    else
                        local v1046, v1047, v1048 = pairs(game:GetService("Workspace").Map.SkyTrial.Model:GetDescendants())
                        while true do
                            local v1049
                            v1048, v1049 = v1046(v1047, v1048)
                            if v1048 == nil then
                                break
                            end
                            if v1049.Name == "snowisland_Cylinder.081" then
                                BKP(v1049.CFrame * CFrame.new(0, 0, 0))
                            end
                        end
                    end
                else
                    local v1050, v1051, v1052 = pairs(game.Workspace.Enemies:GetDescendants())
                    while true do
                        local vu1053
                        v1052, vu1053 = v1050(v1051, v1052)
                        if v1052 == nil then
                            break
                        end
                        if vu1053:FindFirstChild("Humanoid") and (vu1053:FindFirstChild("HumanoidRootPart") and vu1053.Humanoid.Health > 0) then
                            pcall(function()
								-- upvalues: (ref) vu1053
                                repeat
                                    wait()
                                    vu1053.Humanoid.Health = 0
                                    vu1053.HumanoidRootPart.CanCollide = false
                                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                                until not _G.AutoQuestRace or (not vu1053.Parent or vu1053.Humanoid.Health <= 0)
                            end)
                        end
                    end
                end
            end
        end
    end)
end)
Tabs.Race:AddToggle("ToggleKillTrial", {
    ["Title"] = "Đánh Người Chơi Trong Trial",
    ["Default"] = false
}):OnChanged(function(p1054)
    _G.AutoKillTrial = p1054
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoKillTrial then
                local v1055, v1056, v1057 = pairs(game:GetService("Players"):GetChildren())
                while true do
                    local v1058
                    v1057, v1058 = v1055(v1056, v1057)
                    if v1057 == nil then
                        break
                    end
                    if v1058.Name and (v1058.Name ~= game.Players.LocalPlayer.Name and ((v1058.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 and v1058.Character.Humanoid.Health > 0)) then
                        repeat
                            wait(_G.Fast_Delay)
                            EquipTool(SelectWeapon)
                            AutoHaki()
                            Tween2(v1058.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
                            v1058.Character.HumanoidRootPart.CanCollide = false
                            v1058.Character.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            AttackNoCoolDown()
                        until not _G.AutoKillTrial or (not v1058.Parent or v1058.Character.Humanoid.Health <= 0)
                    end
                end
            end
        end)
    end
end)
Tabs.Race:AddSection("Huấn Luyận")
local v1059 = Tabs.Race:AddToggle("ToggleFarmRace", {
    ["Title"] = "Cày Luyện Tộc",
    ["Default"] = false
})
local vu1060 = false
v1059:OnChanged(function(p1061)
	-- upvalues: (ref) vu1060
    vu1060 = p1061
end)
-- [SetValue skipped - Library không cần]
spawn(function()
	-- upvalues: (ref) vu1060
    while wait() do
        if vu1060 then
            pcall(function()
                if game.Players.LocalPlayer.Character:FindFirstChild("RaceTransformed") then
                    if game.Players.LocalPlayer.Character.RaceTransformed.Value ~= true then
                        if game.Players.LocalPlayer.Character.RaceTransformed.Value == false then
                            _G.AutoBoneNoQuest = true
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, "Y", false, game)
                            wait()
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, "Y", false, game)
                        end
                    else
                        _G.AutoBoneNoQuest = false
                        Tween2(CFrame.new(- 9698.4736328125, 445.09442138671875, 6545.8525390625))
                    end
                end
            end)
        else
            _G.AutoBoneNoQuest = false
        end
    end
end)
Tabs.Race:AddToggle("ToggleUpgrade", {
    ["Title"] = "Mua Gear",
    ["Default"] = false
}):OnChanged(function(p1062)
    _G.AutoUpgrade = p1062
    if _G.AutoUpgrade then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("UpgradeRace", "Buy")
    end
end)
-- [SetValue skipped - Library không cần]
Tabs.Shop:AddSection("Khả Năng")
Tabs.Shop:AddButton({
    ["Title"] = "Geppo",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Geppo")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Buso",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Buso")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Soru",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Soru")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Ken",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk", "Buy")
    end
})
Tabs.Shop:AddSection("Kiếm")
Tabs.Shop:AddButton({
    ["Title"] = "Cutlass",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Cutlass")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Katana",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Katana")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Iron Mace",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Iron Mace")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Duel Katana",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Duel Katana")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Triple Katana",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Triple Katana")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Pipe",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Pipe")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Dual-Headed Blade",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Dual-Headed Blade")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Bisento",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Bisento")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Soul Cane",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Soul Cane")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Pole V2",
    ["Callback"] = function()
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ThunderGodTalk")
    end
})
Tabs.Shop:AddSection("Súng")
Tabs.Shop:AddButton({
    ["Title"] = "Musket",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Musket")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Slingshot",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Slingshot")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Flintlock",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Flintlock")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Refined Slingshot",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Refined Slingshot")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Dual Flintlock",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Dual Flintlock")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Cannon",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Cannon")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Kabucha",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Slingshot", "2")
    end
})
Tabs.Shop:AddSection("Phụ Kiện")
Tabs.Shop:AddButton({
    ["Title"] = "Black Cape",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Black Cape")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Swordsman Hat",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Swordsman Hat")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Tomoe Ring",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Tomoe Ring")
    end
})
Tabs.Shop:AddSection("Võ")
Tabs.Shop:AddButton({
    ["Title"] = "Black Leg",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBlackLeg")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Electro",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectro")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Fishman Karate",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFishmanKarate")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Dragon Claw",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "1")
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Superhuman",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Death Step",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Sharkman Karate",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Electric Claw",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Dragon Talon",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Godhuman",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Sanguine Art",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySanguineArt")
    end
})
Tabs.Shop:AddSection("Khác")
Tabs.Shop:AddButton({
    ["Title"] = "\239\191\189\225\187\149i Chỉ Sổ",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "1")
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "2")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "\239\191\189\225\187\149i Tộc",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "1")
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "2")
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "\239\191\189\225\187\149i Tộc Ghoul",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
            "Ectoplasm",
            "Change",
            4
        }))
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "\239\191\189\225\187\149i Tộc Cyborg",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
            "CyborgTrainer",
            "Buy"
        }))
    end
})
Tabs.Shop:AddButton({
    ["Title"] = "Đ\225\187\149i Tộc Draco",
    ["Description"] = "Chỉ \225\187\158 Biển 3",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5661.5322265625, 1013.0907592773438, - 334.9649963378906))
        Tween2(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938))
        local v1063 = Vector3.new(5814.42724609375, 1208.3267822265625, 884.5785522460938)
        local v1064 = game.Players.LocalPlayer
        local v1065 = v1064.Character
        if not v1065 then
            v1065 = v1064.CharacterAdded:Wait()
        end
        repeat
            wait()
        until (v1065.HumanoidRootPart.Position - v1063).Magnitude < 1
        local v1066 = {
            {
                ["NPC"] = "Dragon Wizard",
                ["Command"] = "DragonRace"
            }
        }
        game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(v1066))
    end
})
Tabs.Misc:AddSection("Khác")
Tabs.Misc:AddButton({
    ["Title"] = "Tham Gia Máy Ch\225\187\167 Lại",
    ["Callback"] = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
    end
})
Tabs.Misc:AddButton({
    ["Title"] = "Đ\225\187\149i Máy Ch\225\187\167",
    ["Callback"] = function()
        Hop()
    end
})
function Hop()
	-- upvalues: (ref) vu916
    local vu1067 = game.PlaceId
    local vu1068 = {}
    local vu1069 = ""
    local vu1070 = os.date("!*t").hour
    function TPReturner()
		-- upvalues: (ref) vu1069, (ref) vu1067, (ref) vu1068, (ref) vu1070
        local v1071
        if vu1069 ~= "" then
            v1071 = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. vu1067 .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. vu1069))
        else
            v1071 = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. vu1067 .. "/servers/Public?sortOrder=Asc&limit=100"))
        end
        if v1071.nextPageCursor and (v1071.nextPageCursor ~= "null" and v1071.nextPageCursor ~= nil) then
            vu1069 = v1071.nextPageCursor
        end
        local v1072, v1073, v1074 = pairs(v1071.data)
        local v1075 = 0
        while true do
            local v1076
            v1074, v1076 = v1072(v1073, v1074)
            if v1074 == nil then
                break
            end
            local v1077 = true
            local vu1078 = tostring(v1076.id)
            if tonumber(v1076.maxPlayers) > tonumber(v1076.playing) then
                local v1079, v1080, v1081 = pairs(vu1068)
                while true do
                    local v1082
                    v1081, v1082 = v1079(v1080, v1081)
                    if v1081 == nil then
                        break
                    end
                    if v1075 == 0 then
                        if tonumber(vu1070) ~= tonumber(v1082) then
                            pcall(function()
								-- upvalues: (ref) vu1068, (ref) vu1070
                                vu1068 = {}
                                table.insert(vu1068, vu1070)
                            end)
                        end
                    elseif vu1078 == tostring(v1082) then
                        v1077 = false
                    end
                    v1075 = v1075 + 1
                end
                if v1077 == true then
                    table.insert(vu1068, vu1078)
                    wait()
                    pcall(function()
						-- upvalues: (ref) vu1067, (ref) vu1078
                        wait()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(vu1067, vu1078, game.Players.LocalPlayer)
                    end)
                    wait()
                end
            end
        end
    end
    vu916 = function()
		-- upvalues: (ref) vu1069
        while wait() do
            pcall(function()
				-- upvalues: (ref) vu1069
                TPReturner()
                if vu1069 ~= "" then
                    TPReturner()
                end
            end)
        end
    end
    vu916()
end
Tabs.Misc:AddSection("Đội")
Tabs.Misc:AddButton({
    ["Title"] = "Hải Tặc",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
    end
})
Tabs.Misc:AddButton({
    ["Title"] = "Hải Quân",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Marines")
    end
})
Tabs.Misc:AddSection("Kinh Nghiậm")
local vu1083 = {
    "KITT_RESET",
    "Sub2UncleKizaru",
    "SUB2GAMERROBOT_RESET1",
    "Sub2Fer999",
    "Enyu_is_Pro",
    "JCWK",
    "StarcodeHEO",
    "MagicBus",
    "KittGaming",
    "Sub2CaptainMaui",
    "Sub2OfficalNoobie",
    "TheGreatAce",
    "Sub2NoobMaster123",
    "Sub2Daigrock",
    "Axiore",
    "StrawHatMaine",
    "TantaiGaming",
    "Bluxxy",
    "SUB2GAMERROBOT_EXP1",
    "Chandler",
    "NOMOREHACK",
    "BANEXPLOIT",
    "WildDares",
    "BossBuild",
    "GetPranked",
    "EARN_FRUITS",
    "FIGHT4FRUIT",
    "NOEXPLOITER",
    "NOOB2ADMIN",
    "CODESLIDE",
    "ADMINHACKED",
    "ADMINDARES",
    "fruitconcepts",
    "krazydares",
    "TRIPLEABUSE",
    "SEATROLLING",
    "24NOADMIN",
    "REWARDFUN",
    "NEWTROLL",
    "fudd10_v2",
    "Fudd10",
    "Bignews",
    "SECRET_ADMIN"
}
Tabs.Misc:AddButton({
    ["Title"] = "Nhắp Hết",
    ["Callback"] = function()
		-- upvalues: (ref) vu1083
        local v1084, v1085, v1086 = ipairs(vu1083)
        while true do
            local v1087
            v1086, v1087 = v1084(v1085, v1086)
            if v1086 == nil then
                break
            end
            RedeemCode(v1087)
        end
    end
})
function RedeemCode(p1088)
    game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(p1088)
end
Tabs.Misc:AddSection("Danh Hiậu")
Tabs.Misc:AddButton({
    ["Title"] = "Danh Hiệu",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
            "getTitles"
        }))
        game.Players.localPlayer.PlayerGui.Main.Titles.Visible = true
    end
})
Tabs.Misc:AddSection("Thủc Tỉnh")
Tabs.Misc:AddButton({
    ["Title"] = "Thức Tỉnh",
    ["Callback"] = function()
        game:GetService("Players").LocalPlayer.PlayerGui.Main.AwakeningToggler.Visible = true
    end
})
Tabs.Misc:AddSection("Khác")
Tabs.Misc:AddToggle("ToggleRejoin", {
    ["Title"] = "Tham Gia Máy Ch\225\187\167 Lại",
    ["Default"] = true
}):OnChanged(function(p1089)
    _G.AutoRejoin = p1089
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        if _G.AutoRejoin then
            getgenv().rejoin = game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(p1090)
                if p1090.Name == "ErrorPrompt" and p1090:FindFirstChild("MessageArea") and p1090.MessageArea:FindFirstChild("ErrorFrame") then
                    game:GetService("TeleportService"):Teleport(game.PlaceId)
                end
            end)
        end
    end
end)
Tabs.Misc:AddSection("Sương")
local function vu1092()
    local v1091 = game:GetService("Lighting")
    if v1091:FindFirstChild("BaseAtmosphere") then
        v1091.BaseAtmosphere:Destroy()
    end
    if v1091:FindFirstChild("SeaTerrorCC") then
        v1091.SeaTerrorCC:Destroy()
    end
    if v1091:FindFirstChild("LightingLayers") then
        if v1091.LightingLayers:FindFirstChild("Atmosphere") then
            v1091.LightingLayers.Atmosphere:Destroy()
        end
        wait()
        if v1091.LightingLayers:FindFirstChild("DarkFog") then
            v1091.LightingLayers.DarkFog:Destroy()
        end
    end
    v1091.FogEnd = 100000
end
Tabs.Misc:AddButton({
    ["Title"] = "Xóa Sương Mù",
    ["Callback"] = function()
		-- upvalues: (ref) vu1092
        vu1092()
    end
})
Tabs.Misc:AddToggle("ToggleAntiBand", {
    ["Title"] = "Chống Band",
    ["Default"] = true
}):OnChanged(function(p1093)
    _G.AntiBand = p1093
end)
local vu1094 = {
    17884881,
    120173604,
    912348
}
spawn(function()
	-- upvalues: (ref) vu1094
    while wait() do
        if _G.AntiBand then
            local v1095, v1096, v1097 = pairs(game:GetService("Players"):GetPlayers())
            while true do
                local v1098
                v1097, v1098 = v1095(v1096, v1097)
                if v1097 == nil then
                    break
                end
                if table.find(vu1094, v1098.UserId) then
                    Hop()
                end
            end
        end
    end
end)
Tabs.Sea:AddSection("Leviathan")
Tabs.Sea:AddButton({
    ["Title"] = "Mua Chip Leviathan",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("InfoLeviathan", "2")
    end
})
local v1099 = Tabs.Sea:AddToggle("ToggleTPFrozenDimension", {
    ["Title"] = "Bay Đến Đảo Leviathan",
    ["Default"] = false
})
v1099:OnChanged(function(p1100)
    _G.TweenToFrozenDimension = p1100
end)
v1099:SetValue(false)
spawn(function()
    local v1101 = nil
    while not v1101 do
        v1101 = game:GetService("Workspace").Map:FindFirstChild("FrozenDimension")
        wait()
    end
    while wait() do
        if _G.TweenToFrozenDimension and v1101 then
            Tween2(v1101.CFrame)
        end
    end
end)
if Sea3 then
    local vu1102 = Tabs.Sea:AddParagraph({
        ["Title"] = "Trạng Thái Chip Leviathan",
    })
    spawn(function()
		-- upvalues: (ref) vu1102
        pcall(function()
			-- upvalues: (ref) vu1102
            while wait() do
                local v1103 = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("InfoLeviathan", "1")
                if v1103 == 5 then
                    vu1102:SetDesc("Leviathan Is Out There")
                elseif v1103 == 0 then
                    vu1102:SetDesc("I Don\'t Know")
                else
                    vu1102:SetDesc("Mua: " .. tostring(v1103))
                end
            end
        end)
    end)
end
Tabs.Sea:AddSection("Draco")
Tabs.Sea:AddToggle("ToggleBlazeEmber", {
    ["Title"] = "Làm Lứa Đố",
    ["Default"] = false
}):OnChanged(function(p1104)
    _G.AutoBlazeEmber = p1104
end)
spawn(function()
    while wait() do
        if _G.AutoBlazeEmber then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/DragonDojoEmber"):FireServer()
            end)
        end
    end
end)
Tabs.Sea:AddToggle("ToggleBlazeEmberFarm", {
    ["Title"] = "Đánh Hydra Enforcer + Venomous Assailant",
    ["Default"] = false
}):OnChanged(function(p1105)
    _G.AutoBlazeEmberFarm = p1105
end)
spawn(function()
    while task.wait() do
        if _G.AutoBlazeEmberFarm then
            pcall(function()
                local v1106 = game:GetService("Workspace").Enemies
                if v1106:FindFirstChild("Hydra Enforcer") or v1106:FindFirstChild("Venomous Assailant") then
                    local v1107, v1108, v1109 = pairs(v1106:GetChildren())
                    while true do
                        local v1110
                        v1109, v1110 = v1107(v1108, v1109)
                        if v1109 == nil then
                            break
                        end
                        if (v1110.Name == "Hydra Enforcer" or v1110.Name == "Venomous Assailant") and (v1110:FindFirstChild("Humanoid") and (v1110:FindFirstChild("HumanoidRootPart") and v1110.Humanoid.Health > 0)) then
                            repeat
                                wait(_G.Fast_Delay)
                                AttackNoCoolDown()
                                AutoHaki()
                                bringmob = true
                                EquipTool(SelectWeapon)
                                Tween2(v1110.HumanoidRootPart.CFrame * Pos)
                                v1110.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v1110.HumanoidRootPart.Transparency = 1
                                v1110.Humanoid.JumpPower = 0
                                v1110.Humanoid.WalkSpeed = 0
                                v1110.HumanoidRootPart.CanCollide = false
                                FarmPos = v1110.HumanoidRootPart.CFrame
                                MonFarm = v1110.Name
                            until not _G.AutoBlazeEmberFarm or v1110.Humanoid.Health <= 0
                        end
                    end
                else
                    Tween2(CFrame.new(4612.078125, 1002.283447265625, 498.2188720703125))
                end
            end)
        end
    end
end)
Tabs.Sea:AddToggle("ToggleReceiveQuest", {
    ["Title"] = "Nhắn Nhiậm V\225\187\165 Lứa Đố",
    ["Description"] = "Bắt Lên 1 Lần Là Nhắn 1 Nhắn Nửa Thì Tằt Bắt Lại",
    ["Default"] = false
}):OnChanged(function(p1111)
    _G.AutoReceiveQuest = p1111
    if _G.AutoReceiveQuest then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5661.5322265625, 1013.0907592773438, - 334.9649963378906))
        Tween2(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938))
        spawn(function()
            pcall(function()
                while wait() do
                    game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/DragonHunter"):InvokeServer(unpack({
                        {
                            ["Context"] = "RequestQuest"
                        }
                    }))
                    game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/DragonHunter"):InvokeServer(unpack({
                        {
                            ["Context"] = "Check"
                        }
                    }))
                end
            end)
        end)
    end
end)
local vu1112 = Tabs.Sea:AddParagraph({
    ["Title"] = "Trạng Thái Nhiệm V\225\187\165 Lứa Đố",
})
spawn(function()
	-- upvalues: (ref) vu1112
    pcall(function()
		-- upvalues: (ref) vu1112
        while wait() do
            local v1113 = game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/DragonHunter"):InvokeServer(unpack({
                {
                    ["Context"] = "Check"
                }
            }))
            if typeof(v1113) == "table" then
                local v1114, v1115, v1116 = pairs(v1113)
                while true do
                    local v1117
                    v1116, v1117 = v1114(v1115, v1116)
                    if v1116 == nil then
                        break
                    end
                    if v1117 == "Defeat 3 Venomous Assailants on Hydra Island." then
                        vu1112:SetDesc("Defeat 3 Venomous Assailants on Hydra Island.")
                    elseif v1117 == "Defeat 3 Hydra Enforcers on Hydra Island." then
                        vu1112:SetDesc("Defeat 3 Hydra Enforcers on Hydra Island.")
                    elseif v1117 == "Destroy 10 trees on Hydra Island." then
                        vu1112:SetDesc("Destroy 10 trees on Hydra Island.")
                    end
                end
            end
        end
    end)
end)
Tabs.Sea:AddToggle("ToggleHydraTree", {
    ["Title"] = "Phá Cây \225\187\158 Đảo Hydra",
    ["Default"] = false
}):OnChanged(function(p1118)
    _G.AutoHydraTree = p1118
end)
local function vu1121(p1119)
    local v1120 = game:GetService("VirtualInputManager")
    v1120:SendKeyEvent(true, p1119, false, game)
    v1120:SendKeyEvent(false, p1119, false, game)
end
local function vu1133(p1122)
	-- upvalues: (ref) vu1121
    local v1123 = game.Players.LocalPlayer
    local v1124 = v1123.Backpack
    local v1125, v1126, v1127 = pairs(v1124:GetChildren())
    while true do
        local v1128
        v1127, v1128 = v1125(v1126, v1127)
        if v1127 == nil then
            break
        end
        if v1128:IsA("Tool") and v1128.ToolTip == p1122 then
            v1128.Parent = v1123.Character
            local v1129, v1130, v1131 = ipairs({
                "Z",
                "X",
                "C",
                "V",
                "F"
            })
            while true do
                local vu1132
                v1131, vu1132 = v1129(v1130, v1131)
                if v1131 == nil then
                    break
                end
                wait()
                pcall(function()
					-- upvalues: (ref) vu1121, (ref) vu1132
                    vu1121(vu1132)
                end)
            end
            v1128.Parent = v1124
            break
        end
    end
end
local vu1134 = {
    CFrame.new(5288.61962890625, 1005.4000244140625, 392.43011474609375),
    CFrame.new(5343.39453125, 1004.1998901367188, 361.0687561035156),
    CFrame.new(5235.78564453125, 1004.1998901367188, 431.4530944824219),
    CFrame.new(5321.30615234375, 1004.1998901367188, 440.8951416015625),
    CFrame.new(5258.96484375, 1004.1998901367188, 345.5052490234375)
}
spawn(function()
	-- upvalues: (ref) vu1134, (ref) vu1133
    while wait() do
        if _G.AutoHydraTree then
            AutoHaki()
            local v1135, v1136, v1137 = ipairs(vu1134)
            while true do
                local v1138
                v1137, v1138 = v1135(v1136, v1137)
                if v1137 == nil or not _G.AutoHydraTree then
                    break
                end
                Tween2(v1138)
                wait()
                local v1139 = game.Players.LocalPlayer.Character
                if v1139 and (v1139:FindFirstChild("HumanoidRootPart") and (v1139.HumanoidRootPart.Position - v1138.Position).Magnitude <= 1) then
                    vu1133("Melee")
                    vu1133("Sword")
                    vu1133("Gun")
                end
            end
        end
    end
end)
Tabs.Sea:AddButton({
    ["Title"] = "Bay Đến Khu Vữc Dragon Dojo",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5661.5322265625, 1013.0907592773438, - 334.9649963378906))
        Tween2(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938))
    end
})
Tabs.Sea:AddButton({
    ["Title"] = "Chế Tạo Volcanic Magnet",
    ["Description"] = "Cần 15 Lứa Đố+10 Sằt",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
            "CraftItem",
            "Craft",
            "Volcanic Magnet"
        }))
    end
})
Tabs.Sea:AddButton({
    ["Title"] = "Chế Tạo Dino Hood",
    ["Description"] = "Cần 25 Xương Kh\225\187\167ng Long + 10 Sừng Tê Giác",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
            "CraftItem",
            "Craft",
            "DinoHood"
        }))
    end
})
Tabs.Sea:AddButton({
    ["Title"] = "Chế Tạo T-Rex Skull",
    ["Description"] = "Cần 8 Xương Kh\225\187\167ng Long + 5 Vảy Rỗng",
    ["Callback"] = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
            "CraftItem",
            "Craft",
            "TRexSkull"
        }))
    end
})
Tabs.Sea:AddToggle("ToggleCollectFireFlowers", {
    ["Title"] = "Làm Hoa Đố",
    ["Default"] = false
}):OnChanged(function(p1140)
    _G.AutoCollectFireFlowers = p1140
end)
spawn(function()
    while wait() do
        local v1141 = _G.AutoCollectFireFlowers and workspace:FindFirstChild("FireFlowers")
        if v1141 then
            local v1142, v1143, v1144 = pairs(v1141:GetChildren())
            while true do
                local v1145
                v1144, v1145 = v1142(v1143, v1144)
                if v1144 == nil then
                    break
                end
                if v1145:IsA("Model") and v1145.PrimaryPart then
                    local v1146 = v1145.PrimaryPart.Position
                    if (v1146 - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1 then
                        Tween2(CFrame.new(v1146))
                    else
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                        wait(1.5)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, "E", false, game)
                    end
                end
            end
        end
    end
end)
Tabs.Sea:AddToggle("ToggleWhiteBelt", {
    ["Title"] = "Cày Đai Trằng",
    ["Default"] = false
}):OnChanged(function(p1147)
    _G.AutoLevel = p1147
    if p1147 then
        game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack({
            {
                ["NPC"] = "Dojo Trainer",
                ["Command"] = "RequestQuest"
            }
        }))
        spawn(function()
            while _G.AutoLevel do
                game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack({
                    {
                        ["NPC"] = "Dojo Trainer",
                        ["Command"] = "ClaimQuest"
                    }
                }))
                wait()
            end
        end)
    end
end)
Tabs.Sea:AddParagraph({
    ["Title"] = "Hoàn Thành \225\186\162i Draco V4 (S\225\187\155m Ra)",
})
Tabs.Sea:AddToggle("ToggleTrialTeleport", {
    ["Title"] = "Bay Đến Cứa Trial Tộc Draco",
    ["Default"] = false
}):OnChanged(function(p1148)
    _G.AutoTrialTeleport = p1148
end)
spawn(function()
    while wait() do
        if _G.AutoTrialTeleport then
            local v1149 = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport")
            if v1149 and v1149:IsA("Part") then
                Tween2(CFrame.new(v1149.Position))
                if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v1149.Position).Magnitude <= 1 then
                    _G.AutoTrialTeleport = false
                end
            end
        end
    end
end)
Tabs.Sea:AddSection("Đảo Dung Nham")
local vu1150 = Tabs.Sea:AddParagraph({
    ["Title"] = "Trạng Thái Đảo Dung Nham",
})
spawn(function()
	-- upvalues: (ref) vu1150
    pcall(function()
		-- upvalues: (ref) vu1150
        while wait() do
            if game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland") then
                vu1150:SetDesc("Đảo Dung Nham: \226\156\133\239\184\143")
            else
                vu1150:SetDesc("Đảo Dung Nham: \226\157\140\239\184\143")
            end
        end
    end)
end)
Tabs.Sea:AddToggle("ToggleTPVolcano", {
    ["Title"] = "Bay Đến Đảo Dung Nham",
    ["Default"] = false
}):OnChanged(function(p1151)
    _G.TweenToPrehistoric = p1151
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    local v1152 = nil
    while not v1152 do
        v1152 = game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland")
        wait()
    end
    while wait() do
        local v1153 = _G.TweenToPrehistoric and game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland")
        if v1153 then
            local v1154 = v1153:FindFirstChild("Core")
            if v1154 then
                v1154 = v1153.Core:FindFirstChild("PrehistoricRelic")
            end
            if v1154 then
                v1154 = v1154:FindFirstChild("Skull")
            end
            if v1154 then
                Tween2(CFrame.new(v1154.Position))
                _G.TweenToPrehistoric = false
            end
        end
    end
end)
Tabs.Sea:AddToggle("ToggleDefendVolcano", {
    ["Title"] = "Ph\195\178ng Th\225\187\167",
    ["Default"] = false
}):OnChanged(function(p1155)
    _G.AutoDefendVolcano = p1155
end)
Tabs.Sea:AddToggle("ToggleMelee", {
    ["Title"] = "Dùng Melee",
    ["Default"] = false
}):OnChanged(function(p1156)
    _G.UseMelee = p1156
end)
Tabs.Sea:AddToggle("ToggleSword", {
    ["Title"] = "Dùng Sword",
    ["Default"] = false
}):OnChanged(function(p1157)
    _G.UseSword = p1157
end)
Tabs.Sea:AddToggle("ToggleGun", {
    ["Title"] = "Dùng Gun",
    ["Default"] = false
}):OnChanged(function(p1158)
    _G.UseGun = p1158
end)
local function vu1160(p1159)
    game:GetService("VirtualInputManager"):SendKeyEvent(true, p1159, false, game)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, p1159, false, game)
end
local function vu1176()
    local v1161 = game.Workspace.Map.PrehistoricIsland.Core:FindFirstChild("InteriorLava")
    if v1161 and v1161:IsA("Model") then
        v1161:Destroy()
    end
    local v1162 = game.Workspace.Map:FindFirstChild("PrehistoricIsland")
    if v1162 then
        local v1163, v1164, v1165 = pairs(v1162:GetDescendants())
        while true do
            local v1166
            v1165, v1166 = v1163(v1164, v1165)
            if v1165 == nil then
                break
            end
            if v1166:IsA("Part") and v1166.Name:lower():find("lava") then
                v1166:Destroy()
            end
        end
    end
    local v1167 = game.Workspace.Map:FindFirstChild("PrehistoricIsland")
    if v1167 then
        local v1168, v1169, v1170 = pairs(v1167:GetDescendants())
        while true do
            local v1171
            v1170, v1171 = v1168(v1169, v1170)
            if v1170 == nil then
                break
            end
            if v1171:IsA("Model") then
                local v1172, v1173, v1174 = pairs(v1171:GetDescendants())
                while true do
                    local v1175
                    v1174, v1175 = v1172(v1173, v1174)
                    if v1174 == nil then
                        break
                    end
                    if v1175:IsA("MeshPart") and v1175.Name:lower():find("lava") then
                        v1175:Destroy()
                    end
                end
            end
        end
    end
end
local function vu1184()
    local v1177 = game.Workspace.Map.PrehistoricIsland.Core.VolcanoRocks
    local v1178, v1179, v1180 = pairs(v1177:GetChildren())
    while true do
        local v1181
        v1180, v1181 = v1178(v1179, v1180)
        if v1180 == nil then
            break
        end
        if v1181:IsA("Model") then
            local v1182 = v1181:FindFirstChild("volcanorock")
            if v1182 and v1182:IsA("MeshPart") then
                local v1183 = v1182.Color
                if v1183 == Color3.fromRGB(185, 53, 56) or v1183 == Color3.fromRGB(185, 53, 57) then
                    return v1182
                end
            end
        end
    end
    return nil
end
local function vu1196(p1185)
	-- upvalues: (ref) vu1160
    local v1186 = game.Players.LocalPlayer
    local v1187 = v1186.Backpack
    local v1188, v1189, v1190 = pairs(v1187:GetChildren())
    while true do
        local v1191
        v1190, v1191 = v1188(v1189, v1190)
        if v1190 == nil then
            break
        end
        if v1191:IsA("Tool") and v1191.ToolTip == p1185 then
            v1191.Parent = v1186.Character
            local v1192, v1193, v1194 = ipairs({
                "Z",
                "X",
                "C",
                "V",
                "F"
            })
            while true do
                local vu1195
                v1194, vu1195 = v1192(v1193, v1194)
                if v1194 == nil then
                    break
                end
                wait()
                pcall(function()
					-- upvalues: (ref) vu1160, (ref) vu1195
                    vu1160(vu1195)
                end)
            end
            v1191.Parent = v1187
            break
        end
    end
end
spawn(function()
	-- upvalues: (ref) vu1176, (ref) vu1184, (ref) vu1196
    while wait() do
        if _G.AutoDefendVolcano then
            AutoHaki()
            pcall(vu1176)
            local v1197 = vu1184()
            if v1197 then
                local v1198 = CFrame.new(v1197.Position + Vector3.new(0, 0, 0))
                Tween2(v1198)
                local v1199 = v1197.Color
                if v1199 == Color3.fromRGB(185, 53, 56) or v1199 == Color3.fromRGB(185, 53, 57) then
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v1197.Position - Vector3.new(0, 0, 0)).Magnitude <= 1 then
                        if _G.UseMelee then
                            vu1196("Melee")
                        end
                        if _G.UseSword then
                            vu1196("Sword")
                        end
                        if _G.UseGun then
                            vu1196("Gun")
                        end
                    end
                    _G.TweenToPrehistoric = false
                else
                    vu1184()
                end
            else
                _G.TweenToPrehistoric = true
            end
        end
    end
end)
Tabs.Sea:AddToggle("ToggleKillAura", {
    ["Title"] = "Đánh Golems Aura",
    ["Default"] = false
}):OnChanged(function(p1200)
    KillAura = p1200
end)
-- [SetValue skipped - Library không cần]
spawn(function()
    while wait() do
        if KillAura then
            pcall(function()
                local v1201, v1202, v1203 = pairs(game.Workspace.Enemies:GetDescendants())
                while true do
                    local v1204
                    v1203, v1204 = v1201(v1202, v1203)
                    if v1203 == nil then
                        break
                    end
                    if v1204:FindFirstChild("Humanoid") and (v1204:FindFirstChild("HumanoidRootPart") and v1204.Humanoid.Health > 0) then
                        repeat
                            task.wait()
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            v1204.Humanoid.Health = 0
                            v1204.HumanoidRootPart.CanCollide = false
                        until not KillAura or (not v1204.Parent or v1204.Humanoid.Health <= 0)
                    end
                end
            end)
        end
    end
end)
Tabs.Sea:AddToggle("ToggleCollectBone", {
    ["Title"] = "Làm Xương",
    ["Default"] = false
}):OnChanged(function(p1205)
    _G.AutoCollectBone = p1205
end)
spawn(function()
    while wait() do
        if _G.AutoCollectBone then
            local v1206, v1207, v1208 = pairs(workspace:GetDescendants())
            while true do
                local v1209
                v1208, v1209 = v1206(v1207, v1208)
                if v1208 == nil then
                    break
                end
                if v1209:IsA("BasePart") and v1209.Name == "DinoBone" then
                    Tween2(CFrame.new(v1209.Position))
                end
            end
        end
    end
end)
Tabs.Sea:AddToggle("ToggleCollectEgg", {
    ["Title"] = "Làm Trứng",
    ["Default"] = false
}):OnChanged(function(p1210)
    _G.AutoCollectEgg = p1210
end)
spawn(function()
    while wait() do
        if _G.AutoCollectEgg then
            local v1211 = workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:GetChildren()
            if # v1211 > 0 then
                local v1212 = v1211[math.random(1, # v1211)]
                if v1212:IsA("Model") and v1212.PrimaryPart then
                    Tween2(v1212.PrimaryPart.CFrame)
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v1212.PrimaryPart.Position).Magnitude <= 1 then
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                        wait(1.5)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, "E", false, game)
                    end
                end
            end
        end
    end
end)
-- ===============================================================
-- ==================== CHỨC NĂNG BỔ SUNG ====================

-- ========== FARM SUMMER TOKEN ==========
Tabs.Main:AddSection("Farm Summer Token")
Tabs.Main:AddToggle("ToggleFarmSummer", {
    ["Title"] = "Auto Farm Summer Token",
    ["Default"] = false
}):OnChanged(function(v) _G.FarmSummer = v end)
local function getSummerPos()
    local id = game.PlaceId
    if id == 2753915549 then return CFrame.new(924.405, 6.366, 4476.727)
    elseif id == 4442272183 then return CFrame.new(-5246.478, 66.381, -6015.48)
    elseif id == 7449423635 then return CFrame.new(-10334.821, 390.837, -8572.301)
    end; return nil
end
spawn(function()
    while task.wait() do
        if _G.FarmSummer then pcall(function()
            local cf = getSummerPos()
            if not cf then return end
            Tween(cf * CFrame.new(0, 50, 0))
            for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
                local hum = mob:FindFirstChild("Humanoid")
                local hrp = mob:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 and hum.DisplayName and hum.DisplayName:find("%[Electrified%]") then
                    repeat
                        task.wait()
                        AutoHaki(); EquipTool(SelectWeapon)
                        hrp.CanCollide = false; hum.WalkSpeed = 0
                        pcall(function() mob.Head.CanCollide = false end)
                        Tween(hrp.CFrame * Pos)
                        AttackNoCoolDown()
                        FarmPos = hrp.CFrame; MonFarm = mob.Name; bringmob = true
                    until not _G.FarmSummer or not mob.Parent or hum.Health <= 0
                    bringmob = false
                end
            end
        end) end
    end
end)

-- ========== FARM BOSS SỰ KIỆN ==========
Tabs.Main:AddSection("Farm Boss Sự Kiện")
local _bossPainList = {}
if Sea1 then _bossPainList = {"The Gorilla King","Bobby","Yeti","Mob Leader","Vice Admiral","Warden","Chief Warden","Swan","Magma Admiral","Fishman Lord","Wysper","Thunder God","Cyborg","Saber Expert"}
elseif Sea2 then _bossPainList = {"Diamond","Jeremy","Fajita","Don Swan","Smoke Admiral","Cursed Captain","Darkbeard","Order","Awakened Ice Admiral","Tide Keeper"}
elseif Sea3 then _bossPainList = {"Stone","Island Empress","Hydra Leader","Kilo Admiral","Captain Elephant","Beautiful Pirate","rip_indra True Form","Longma","Soul Reaper","Cake Queen","Tyrant of the Skies"}
end
if #_bossPainList > 0 then
    Tabs.Main:AddDropdown("DropSelectBossPain", {
        ["Title"] = "Chọn Boss",
        ["Values"] = _bossPainList,
        ["Default"] = _bossPainList[1]
    }):OnChanged(function(v) _G.SelectBoss = v end)
    Tabs.Main:AddToggle("ToggleBossPain", {
        ["Title"] = "Farm Boss Đã Chọn",
        ["Default"] = false
    }):OnChanged(function(v) _G.BossPain = v end)
    task.spawn(function()
        while task.wait() do
            if _G.BossPain and _G.SelectBoss then pcall(function()
                if not game.Workspace.Enemies:FindFirstChild(_G.SelectBoss) then
                    local rs = game:GetService("ReplicatedStorage")
                    if rs:FindFirstChild(_G.SelectBoss) then
                        Tween(rs:FindFirstChild(_G.SelectBoss).HumanoidRootPart.CFrame * CFrame.new(5, 10, 2))
                    end
                else
                    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                        if v.Name == _G.SelectBoss and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat
                                task.wait(); AutoHaki(); EquipTool(SelectWeapon)
                                v.HumanoidRootPart.CanCollide = false; v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.Size = Vector3.new(80,80,80)
                                Tween(v.HumanoidRootPart.CFrame * Pos); AttackNoCoolDown()
                                sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                FarmPos = v.HumanoidRootPart.CFrame; MonFarm = v.Name; bringmob = true
                            until not _G.BossPain or not v.Parent or v.Humanoid.Health <= 0
                            bringmob = false
                        end
                    end
                end
            end) end
        end
    end)
end

-- ========== AUTO RAID PIRATE ==========
Tabs.Main:AddSection("Farm Hải Tặc Phóng Pháo")
Tabs.Main:AddToggle("ToggleRaidPirate", {
    ["Title"] = "Farm Pirate Raid",
    ["Default"] = false
}):OnChanged(function(v) _G.AutoRaidPirate = v end)
spawn(function()
    while wait() do
        if _G.AutoRaidPirate then pcall(function()
            local raidPos = CFrame.new(-5496.17432, 313.768921, -2841.53027)
            local center = Vector3.new(-5539.31, 313.80, -2972.37)
            if (center - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 500 then
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if _G.AutoRaidPirate and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 2000 then
                        repeat
                            wait(); AutoHaki(); EquipTool(SelectWeapon); bringmob = true
                            v.HumanoidRootPart.CanCollide = false; v.HumanoidRootPart.Size = Vector3.new(60,60,60)
                            Tween(v.HumanoidRootPart.CFrame * Pos); AttackNoCoolDown()
                            FarmPos = v.HumanoidRootPart.CFrame; MonFarm = v.Name
                        until v.Humanoid.Health <= 0 or not v.Parent or not _G.AutoRaidPirate
                        bringmob = false
                    end
                end
            else Tween(raidPos) end
        end) end
    end
end)

-- ========== TYRANT OF THE SKIES (Sea3) ==========
if Sea3 then
    Tabs.Main:AddSection("Tyrant of the Skies")
    Tabs.Main:AddToggle("ToggleFarmDaiBan", {
        ["Title"] = "Auto Farm Tyrant",
        ["Default"] = false
    }):OnChanged(function(v) _G.FarmDaiBan = v end)
    Tabs.Main:AddToggle("ToggleFarm8Binhs", {
        ["Title"] = "Summon Tyrant (Triệu Hồi Boss)",
        ["Default"] = false
    }):OnChanged(function(v) _G.Farm8Binhs = v end)
    local _tyrantSpawn = CFrame.new(-16194.00, 155.21, 1420.71)
    local _tyrantPats = {
        CFrame.new(-16250.24,158.17,1313.02), CFrame.new(-16297.06,159.32,1317.22),
        CFrame.new(-16335.10,159.33,1324.89), CFrame.new(-16288.61,158.17,1470.37),
        CFrame.new(-16258.00,156.76,1461.40), CFrame.new(-16245.41,158.44,1463.37),
        CFrame.new(-16212.47,158.17,1466.34)
    }
    task.spawn(function()
        while task.wait() do
            if _G.FarmDaiBan then pcall(function()
                if not game.Workspace.Enemies:FindFirstChild("Tyrant of the Skies") then
                    local hasMob = false
                    for _, name in pairs({"Isle Outlaw","Island Boy","Isle Champion","Serpent Hunter","Skull Slayer"}) do
                        if game.Workspace.Enemies:FindFirstChild(name) then hasMob=true; break end
                    end
                    if hasMob then
                        for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                            if (v.Name=="Isle Outlaw" or v.Name=="Island Boy" or v.Name=="Isle Champion" or v.Name=="Serpent Hunter" or v.Name=="Skull Slayer") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                repeat
                                    task.wait(); AutoHaki(); EquipTool(SelectWeapon)
                                    v.HumanoidRootPart.CanCollide = false; v.Humanoid.WalkSpeed = 0
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    FarmPos = v.HumanoidRootPart.CFrame; MonFarm = v.Name; bringmob = true
                                    pcall(function() v.Head.CanCollide = false end)
                                    Tween(v.HumanoidRootPart.CFrame * Pos); AttackNoCoolDown()
                                until not _G.FarmDaiBan or not v.Parent or v.Humanoid.Health <= 0 or game.Workspace.Enemies:FindFirstChild("Tyrant of the Skies")
                                bringmob = false
                            end
                        end
                    else Tween(_tyrantSpawn) end
                else
                    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                        if v.Name=="Tyrant of the Skies" and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat
                                task.wait(); AutoHaki(); EquipTool(SelectWeapon)
                                v.HumanoidRootPart.CanCollide = false; v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                Tween(v.HumanoidRootPart.CFrame * CFrame.new(0,40,0)); AttackNoCoolDown()
                            until not _G.FarmDaiBan or not v.Parent or v.Humanoid.Health <= 0
                            wait(1)
                        end
                    end
                end
            end) end
        end
    end)
    task.spawn(function()
        while task.wait(1) do
            if _G.Farm8Binhs then
                for _, cf in ipairs(_tyrantPats) do
                    if not _G.Farm8Binhs then break end
                    TweenBlock(cf * CFrame.new(0,5,0)); task.wait(0.5)
                    pcall(function()
                        local pl = game.Players.LocalPlayer
                        for _, tool in pairs(pl.Backpack:GetChildren()) do
                            if tool:IsA("Tool") then
                                pl.Character.Humanoid:EquipTool(tool); task.wait(0.1)
                                for _, k in pairs({"Z","X","C"}) do
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true,k,false,game)
                                    task.wait(0.05)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false,k,false,game)
                                end
                            end
                        end
                    end); task.wait(2)
                end
            end
        end
    end)
end

-- ========== AUTO CÂU CÁ ==========
Tabs.Main:AddSection("Auto Câu Cá")
Tabs.Main:AddToggle("ToggleAutoFishing", {
    ["Title"] = "Auto Câu Cá",
    ["Default"] = false
}):OnChanged(function(v) _G.AutoFishing = v end)
Tabs.Main:AddDropdown("DropFishingBait", {
    ["Title"] = "Chọn Mồi Câu",
    ["Values"] = {"Basic Bait","Kelp Bait","Good Bait","Abyssal Bait","Frozen Bait","Epic Bait","Carnivore Bait"},
    ["Default"] = "Basic Bait"
}):OnChanged(function(v)
    _G.SelectedBait = v
    pcall(function() game.ReplicatedStorage:WaitForChild("FishReplicated"):WaitForChild("FishingRequest"):InvokeServer("SelectBait",v) end)
end)
Tabs.Main:AddDropdown("DropFishingRod", {
    ["Title"] = "Chọn Cần Câu",
    ["Values"] = {"Fishing Rod","Gold Rod","Shark Rod","Shell Rod","Treasure Rod"},
    ["Default"] = "Fishing Rod"
}):OnChanged(function(v) _G.SelectedRod = v end)
task.spawn(function()
    local fishRep = pcall(function() return game.ReplicatedStorage:WaitForChild("FishReplicated",10) end)
    if not fishRep then return end
    local ok, rep = pcall(function() return game.ReplicatedStorage:WaitForChild("FishReplicated",10) end)
    if not ok then return end
    local fishReq = rep:WaitForChild("FishingRequest")
    while task.wait() do
        if _G.AutoFishing then pcall(function()
            local pl = game.Players.LocalPlayer
            local char = pl.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local tool = char and char:FindFirstChildOfClass("Tool")
            if _G.SelectedRod and (not tool or tool.Name ~= _G.SelectedRod) then
                local rod = pl.Backpack:FindFirstChild(_G.SelectedRod)
                if rod then char.Humanoid:EquipTool(rod); tool = rod end
            end
            if hrp and tool then
                local srvState = pcall(function() return tool:GetAttribute("ServerState") end)
                if srvState == "Biting" then
                    fishReq:InvokeServer("Catching",true); task.wait(0.1); fishReq:InvokeServer("Catch",1)
                else
                    fishReq:InvokeServer("StartCasting"); task.wait()
                    fishReq:InvokeServer("CastLineAtLocation", (hrp.CFrame*CFrame.new(0,0,-30)).Position, 100, true)
                end
            end
        end) end
    end
end)

-- ========== HALLOW SCYTHE (Sea3) ==========
if Sea3 then
    Tabs.Main:AddSection("Hallow Scythe")
    Tabs.Main:AddToggle("ToggleHallow", {
        ["Title"] = "Lấy Hallow Scythe",
        ["Default"] = false
    }):OnChanged(function(v) _G.Hallow = v end)
    spawn(function()
        while wait() do
            if _G.Hallow then pcall(function()
                if not game.Workspace.Enemies:FindFirstChild("Soul Reaper") then
                    if game.Players.LocalPlayer.Backpack:FindFirstChild("Hallow Essence") or game.Players.LocalPlayer.Character:FindFirstChild("Hallow Essence") then
                        repeat TweenBlock(CFrame.new(-8932.32,146.83,6062.55)); wait()
                        until (CFrame.new(-8932.32,146.83,6062.55).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 8
                        EquipTool("Hallow Essence")
                    elseif game:GetService("ReplicatedStorage"):FindFirstChild("Soul Reaper") then
                        Tween(game:GetService("ReplicatedStorage"):FindFirstChild("Soul Reaper").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                    end
                else
                    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                        if string.find(v.Name,"Soul Reaper") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            repeat
                                task.wait(); EquipTool(SelectWeapon); AutoHaki()
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                Tween(v.HumanoidRootPart.CFrame * Pos); AttackNoCoolDown()
                                v.HumanoidRootPart.Transparency = 1
                            until v.Humanoid.Health <= 0 or not _G.Hallow
                        end
                    end
                end
            end) end
        end
    end)
end

-- ========== NÂNG ĐIỂM KỸ NĂNG ==========
Tabs.Setting:AddSection("Nâng Điểm Kỹ Năng")
local _spMelee, _spDef, _spSword, _spGun, _spFruit = false,false,false,false,false
Tabs.Setting:AddToggle("ToggleSPMelee", {["Title"] = "Melee", ["Default"] = false}):OnChanged(function(v) _spMelee = v end)
Tabs.Setting:AddToggle("ToggleSPDef", {["Title"] = "Defense", ["Default"] = false}):OnChanged(function(v) _spDef = v end)
Tabs.Setting:AddToggle("ToggleSPSword", {["Title"] = "Sword", ["Default"] = false}):OnChanged(function(v) _spSword = v end)
Tabs.Setting:AddToggle("ToggleSPGun", {["Title"] = "Gun", ["Default"] = false}):OnChanged(function(v) _spGun = v end)
Tabs.Setting:AddToggle("ToggleSPFruit", {["Title"] = "Trái Ác Quỷ", ["Default"] = false}):OnChanged(function(v) _spFruit = v end)
spawn(function()
    while wait() do pcall(function()
        if game.Players.LocalPlayer.Data.Points.Value >= 1 then
            local function ap(s) game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint",s,1) end
            if _spMelee then ap("Melee") end; if _spDef then ap("Defense") end
            if _spSword then ap("Sword") end; if _spGun then ap("Gun") end
            if _spFruit then ap("Demon Fruit") end
        end
    end) end
end)

-- ========== KỸ NĂNG ĐẶC BIỆT ==========
Tabs.Setting:AddSection("Kỹ Năng Đặc Biệt")
local InfiniteSoru, InfiniteGeppo, DodgeNoCD = false, false, false
Tabs.Setting:AddToggle("ToggleInfSoru", {["Title"] = "Infinite Soru", ["Default"] = false}):OnChanged(function(v) InfiniteSoru = v end)
spawn(function()
    while task.wait(1) do
        if InfiniteSoru then pcall(function()
            for _, v in next, getgc() do
                if getfenv(v).script == game.Players.LocalPlayer.Character:WaitForChild("Soru") then
                    for idx, val in pairs(debug.getupvalues(v)) do
                        if type(val)=="table" and val.LastUse then
                            repeat task.wait(0.1); setupvalue(v,idx,{LastAfter=0,LastUse=0})
                            until not InfiniteSoru or game.Players.LocalPlayer.Character.Humanoid.Health <= 0
                        end
                    end
                end
            end
        end) end
    end
end)
Tabs.Setting:AddToggle("ToggleInfGeppo", {["Title"] = "Infinite Geppo", ["Default"] = false}):OnChanged(function(v) InfiniteGeppo = v end)
spawn(function()
    while task.wait(1) do
        if InfiniteGeppo then pcall(function()
            for _, v in next, getgc() do
                if getfenv(v).script == game.Players.LocalPlayer.Character:WaitForChild("Geppo") then
                    for idx, val in next, getupvalues(v) do
                        if tostring(val)=="0" then
                            repeat wait(0.1); setupvalue(v,idx,0)
                            until not InfiniteGeppo or game.Players.LocalPlayer.Character.Humanoid.Health <= 0
                        end
                    end
                end
            end
        end) end
    end
end)
Tabs.Setting:AddToggle("ToggleDodgeNoCD", {["Title"] = "Dodge No Cooldown", ["Default"] = false}):OnChanged(function(v) DodgeNoCD = v end)
spawn(function()
    while wait() do
        if DodgeNoCD then pcall(function()
            for _, v in next, getgc() do
                if typeof(v)=="function" and getfenv(v).script == game.Players.LocalPlayer.Character:WaitForChild("Dodge") then
                    for idx, val in next, getupvalues(v) do
                        if tostring(val)=="0.4" then setupvalue(v,idx,0) end
                    end
                end
            end
        end) end
    end
end)

-- ========== FPS BOOST ==========
Tabs.Misc:AddSection("FPS & Hiệu Suất")
Tabs.Misc:AddButton({
    ["Title"] = "FPS Boost",
    ["Callback"] = function()
        pcall(function()
            settings().Rendering.QualityLevel = "Level01"
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Lifetime = NumberRange.new(0)
                elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") then v.Enabled = false
                elseif v:IsA("Explosion") then v.BlastPressure=1; v.BlastRadius=1
                end
            end
        end)
    end
})

-- ========== AUTO CODES ==========
Tabs.Misc:AddSection("Auto Code")
local _codeList = {"NOMOREHACK","BANEXPLOIT","WildDares","BossBuild","GetPranked","EARN_FRUITS","FIGHT4FRUIT","NOEXPLOITER","NOOB2ADMIN","CODESLIDE","ADMINHACKED","ADMINDARES","fruitconcepts","krazydares","TRIPLEABUSE","SEATROLLING","24NOADMIN","REWARDFUN","Chandler","NEWTROLL","KITT_RESET","Sub2CaptainMaui","kittgaming","Sub2Fer999","Enyu_is_Pro","Magicbus","JCWK","Starcodeheo","Bluxxy","fudd10_v2","SUB2GAMERROBOT_EXP1","Sub2NoobMaster123","Sub2UncleKizaru","Sub2Daigrock","Axiore","TantaiGaming","StrawHatMaine","Sub2OfficialNoobie","Fudd10","Bignews","TheGreatAce","SECRET_ADMIN","SUB2GAMERROBOT_RESET1","SUB2OFFICIALNOOBIE","AXIORE","BIGNEWS","BLUXXY","CHANDLER","ENYU_IS_PRO","FUDD10","FUDD10_V2","KITTGAMING","MAGICBUS","STARCODEHEO","STRAWHATMAINE","SUB2CAPTAINMAUI","SUB2DAIGROCK","SUB2FER999","SUB2NOOBMASTER123","SUB2UNCLEKIZARU","TANTAIGAMING","THEGREATACE"}
Tabs.Misc:AddButton({
    ["Title"] = "Nhập Tất Cả Code",
    ["Callback"] = function()
        for _, code in ipairs(_codeList) do
            pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Redeem"):InvokeServer(code) end)
            task.wait(0.1)
        end
    end
})

-- ===============================================================
print('✅ tuyenmod2194 - Tất cả tính năng đã được load!')
