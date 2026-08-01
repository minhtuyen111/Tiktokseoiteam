local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local WATER_LEVEL = 0 -- Đổi thành độ cao mặt nước của map
local PLATFORM_SIZE = Vector3.new(8, 1, 8)

local platforms = {}

local function createPlatform(player)
	local part = Instance.new("Part")
	part.Name = "WaterPlatform"
	part.Anchored = true
	part.CanCollide = true
	part.Transparency = 1
	part.Size = PLATFORM_SIZE
	part.Parent = workspace
	platforms[player] = part
end

Players.PlayerAdded:Connect(function(player)
	createPlatform(player)

	player.CharacterRemoving:Connect(function()
		if platforms[player] then
			platforms[player].Position = Vector3.new(0, -500, 0)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	if platforms[player] then
		platforms[player]:Destroy()
		platforms[player] = nil
	end
end)

RunService.Heartbeat:Connect(function()
	for player, platform in pairs(platforms) do
		local character = player.Character
		if character then
			local hrp = character:FindFirstChild("HumanoidRootPart")
			if hrp then
				if hrp.Position.Y <= WATER_LEVEL + 3 then
					platform.Position = Vector3.new(
						hrp.Position.X,
						WATER_LEVEL - 0.5,
						hrp.Position.Z
					)
				else
					platform.Position = Vector3.new(0, -500, 0)
				end
			end
		end
	end
end)