--------------------------------------------------
-- TOGGLE
--------------------------------------------------
if getgenv().AUTO_SHERIFF then
	getgenv().AUTO_SHERIFF = false
	return
end

getgenv().AUTO_SHERIFF = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- buscar target criminal
--------------------------------------------------
local function getTarget()

	for _, player in pairs(Players:GetPlayers()) do
		
		if player.Team and player.Team.Name == "Criminals" then
			
			local model = workspace:FindFirstChild(player.Name)

			if model and model:IsA("Model") then

				local head = model:FindFirstChild("Head")
				local humanoid = model:FindFirstChildOfClass("Humanoid")
				local audio = model:FindFirstChildWhichIsA("AudioEmitter", true)

				if head and humanoid and humanoid.Health > 0 and audio then
					return model, head
				end

			end

		end

	end

end

--------------------------------------------------
-- disparo
--------------------------------------------------
local function shoot()

	if not getgenv().AUTO_SHERIFF then return end

	local character = LocalPlayer.Character
	if not character then return end

	-- Solo si eres sheriff
	if not LocalPlayer.Team or LocalPlayer.Team.Name ~= "Sheriffs" then
		return
	end

	-- Debe tener la Gun equipada
	local gun = character:FindFirstChild("GunSource")
	if not gun then return end

	local gunSource = character:FindFirstChild("GunSource")
	if not gunSource then return end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local target, head = getTarget()
	if not target then return end

	local startPos = hrp.Position
	local direction = (head.Position - startPos).Unit

	local hitPart = target:FindFirstChildWhichIsA("BasePart")

	local args = {
		[1] = startPos,
		[2] = direction,
		[3] = hitPart,
		[4] = head.Position
	}

	gunSource.Events.Fire:FireServer(unpack(args))

end

--------------------------------------------------
-- loop
--------------------------------------------------
task.spawn(function()
	while getgenv().AUTO_SHERIFF do
		task.wait(0.2)
		shoot()
	end
end)
