-- ==========================================
-- SCRIPT FIX LAG & OPTIMIZE (CLIENT ONLY)
-- Đặt vào: StarterPlayer -> StarterPlayerScripts
-- ==========================================

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. GIẢM CẤU HÌNH ĐỒ HỌA LIGHTING & WATER (ẨN NƯỚC/BIỂN)
pcall(function()
    -- Tắt hiệu ứng ánh sáng
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") or effect:IsA("Atmosphere") or effect:IsA("Sky") then
            effect:Destroy()
        end
    end
    
    -- Tắt hiệu ứng sóng nước và làm trong suốt nước/biển
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 1 -- Làm ẩn biển/nước
    end
end)

-- 2. HÀM XỬ LÝ ẨN CHI TIẾT (ẨN MAP, NPC, HIỆU ỨNG, TRANG PHỤC)
local function OptimizeObject(obj)
    -- A. Ẩn hiệu ứng (Particle, Beam, Trail, Fire, Smoke, Light)
    if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Trail") or obj:IsA("Beam") then
        obj.Enabled = false
    elseif obj:IsA("Light") then
        obj.Enabled = false
        
    -- B. Ẩn trang phục & phụ kiện (Shirt, Pants, Accessory, CharacterMesh)
    elseif obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("CharacterMesh") then
        obj:Destroy()
    elseif obj:IsA("Accessory") then
        obj:Destroy() -- Xóa phụ kiện/mũ/cánh trên người
        
    -- C. Ẩn Công trình (Map) & Ẩn NPC (Giữ lại nhân vật người chơi chính)
    elseif obj:IsA("BasePart") or obj:IsA("MeshPart") then
        -- Giảm chất lượng bề mặt vật liệu
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
        
        -- Kiểm tra xem vật thể có thuộc về Player hiện tại không
        local isLocalCharacter = LocalPlayer.Character and obj:IsDescendantOf(LocalPlayer.Character)
        
        if not isLocalCharacter then
            -- Ẩn tất cả công trình, NPC và Player khác
            obj.Transparency = 1
            obj.CastShadow = false
            
            -- Xóa bớt Texture dán trên khối để nhẹ máy
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") then
                    child:Destroy()
                end
            end
        end
    end
end

-- 3. ÁP DỤNG FIX LAG CHO TOÀN BỘ WORKSPACE HIỆN TẠI
for _, obj in pairs(Workspace:GetDescendants()) do
    OptimizeObject(obj)
end

-- 4. TỰ ĐỘNG XỬ LÝ KHI GAME SPAWN THÊM VẬT THỂ MỚI (MAP/NPC/EFFECT SPAWN SAU)
Workspace.DescendantAdded:Connect(function(obj)
    task.spawn(function()
        OptimizeObject(obj)
    end)
end)

-- 5. GIỮ LẠI THÔNG BÁO (GUI)
-- Script này cố tình KHÔNG can thiệp vào PlayerGui, giúp toàn bộ UI thông báo,
-- thanh máu, Chat, Skill và Menu của game hoạt động hoàn toàn bình thường.
print("--- FIX LAG LOAD THÀNH CÔNG (ĐÃ GIỮ LẠI GUI THÔNG BÁO) ---")