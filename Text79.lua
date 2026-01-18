--// ESP BOX TOGGLE - INVISIBLE / VISIBLE SI TIENE TOOL
--// RAW / LOCAL

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local espBoxes = _G.ESP_BOXES or {}
_G.ESP_BOXES = espBoxes

-- ================= TOGGLE =================

if _G.ESPBoxActivo == nil then
	_G.ESPBoxActivo = false
end

_G.ESPBoxActivo = not _G.ESPBoxActivo

-- ================= UTILIDADES =================

local function getMainPart(character)
	return character:FindFirstChild("HumanoidRootPart")
		or character:FindFirstChild("UpperTorso")
		or character:FindFirstChild("Torso")
		or character:FindFirstChildWhichIsA("BasePart")
end

local function hasAnyTool(player)
	if player.Character then
		for _, item in pairs(player.Character:GetChildren()) do
			if item:IsA("Tool") then
				return true
			end
		end
	end
	if player:FindFirstChild("Backpack") then
		for _, item in pairs(player.Backpack:GetChildren()) do
			if item:IsA("Tool") then
				return true
			end
		end
	end
	return false
end

-- ================= BOX =================

local function createBox(player)
	if player == LocalPlayer then return end
	if espBoxes[player] then return end
	if not player.Character then return end

	local mainPart = getMainPart(player.Character)
	if not mainPart then return end

	local box = Instance.new("BoxHandleAdornment")
	box.Name = "ESPBox"
	box.Adornee = mainPart
	box.AlwaysOnTop = true
	box.ZIndex = 10
	box.Size = Vector3.new(4, 6, 1)
	box.Color3 = Color3.fromRGB(0, 150, 255)
	box.Transparency = 1
	box.Parent = workspace

	espBoxes[player] = box
end

-- ================= JUGADORES =================

local function setupPlayer(player)
	if player == LocalPlayer then return end

	player.CharacterAdded:Connect(function()
		task.wait(1)
		createBox(player)
	end)

	if player.Character then
		createBox(player)
	end
end

for _, p in pairs(Players:GetPlayers()) do
	setupPlayer(p)
end

Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(function(player)
	if espBoxes[player] then
		espBoxes[player]:Destroy()
		espBoxes[player] = nil
	end
end)

-- ================= LOOP =================

if not _G.ESPBoxLoop then
	_G.ESPBoxLoop = RunService.Stepped:Connect(function()
		for player, box in pairs(espBoxes) do
			if box and box.Parent then
				if _G.ESPBoxActivo and hasAnyTool(player) then
					box.Transparency = 0.4 -- VISIBLE
				else
					box.Transparency = 1 -- INVISIBLE
				end
			end
		end
	end)
end

-- ================= ESTADO =================

if _G.ESPBoxActivo then
	print("ESP BOX ACTIVADO ✅")
else
	print("ESP BOX DESACTIVADO ❌ (invisible)")
end
