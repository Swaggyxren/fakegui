local rawCfg = _G.SwaggyConfig or {}
local cfg = {
	Name = rawCfg.Name or "DefaultHub",
	Clipboard = rawCfg.Clipboard or "https://default.com",
	AllowedUsers = rawCfg.AllowedUsers or {}
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function allowedUserInServer()
	for _, player in ipairs(Players:GetPlayers()) do
		if cfg.AllowedUsers[player.Name] then
			return true
		end
	end
	return false
end

local function launchGUI()
	if LocalPlayer:FindFirstChild(cfg.Name .. "_GUI") then return end 

	local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true 
	screenGui.Name = cfg.Name .. "_GUI"

	local mainFrame = Instance.new("Frame", screenGui)
	mainFrame.Size = UDim2.new(1, 0, 1, 0)
	mainFrame.Position = UDim2.new(0, 0, 0, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(85, 125, 80)
	mainFrame.BorderSizePixel = 0

	local nullLeft = Instance.new("TextLabel", mainFrame)
	nullLeft.Size = UDim2.new(0, 150, 0, 20)
	nullLeft.Position = UDim2.new(0, -150, 0, 10)
	nullLeft.Text = "null"
	nullLeft.TextColor3 = Color3.new(1, 1, 1)
	nullLeft.BackgroundTransparency = 1
	nullLeft.Font = Enum.Font.SourceSansBold
	nullLeft.TextSize = 16

	local nullBottom = nullLeft:Clone()
	nullBottom.Parent = mainFrame
	nullBottom.Position = UDim2.new(0.5, 0, 1, -30)
	nullBottom.AnchorPoint = Vector2.new(0.5, 1)

	local titleLabel = Instance.new("TextLabel", mainFrame)
	titleLabel.Size = UDim2.new(0.6, 0, 0, 40)
	titleLabel.Position = UDim2.new(0.2, 0, 0.2, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.Font = Enum.Font.FredokaOne
	titleLabel.TextSize = 30
	titleLabel.Text = ""

	local fullText = "Loading " .. cfg.Name .. "..."
	task.spawn(function()
		while true do
			for i = 1, #fullText do
				titleLabel.Text = string.sub(fullText, 1, i)
				wait(0.05)
			end
			wait(0.5)
			titleLabel.Text = ""
			wait(0.3)
		end
	end)

	local keyBox = Instance.new("TextBox", mainFrame)
	keyBox.Size = UDim2.new(0.6, 0, 0, 40)
	keyBox.Position = UDim2.new(0.2, 0, 0.4, 0)
	keyBox.PlaceholderText = "Enter your key here..."
	keyBox.TextColor3 = Color3.new(0, 0, 0)
	keyBox.Font = Enum.Font.Gotham
	keyBox.TextSize = 20
	keyBox.BackgroundColor3 = Color3.fromRGB(190, 230, 190)

	local getKeyBtn = Instance.new("TextButton", mainFrame)
	getKeyBtn.Size = UDim2.new(0.4, 0, 0, 35)
	getKeyBtn.Position = UDim2.new(0.3, 0, 0.55, 0)
	getKeyBtn.Text = "Get Key"
	getKeyBtn.BackgroundColor3 = Color3.fromRGB(110, 170, 100)
	getKeyBtn.TextColor3 = Color3.new(1, 1, 1)
	getKeyBtn.Font = Enum.Font.GothamBold
	getKeyBtn.TextSize = 20

	getKeyBtn.MouseButton1Click:Connect(function()
		setclipboard(cfg.Clipboard)
		getKeyBtn.Text = "Copied!"
		task.wait(1)
		getKeyBtn.Text = "Get Key"
	end)

	local verifyBtn = Instance.new("TextButton", mainFrame)
	verifyBtn.Size = UDim2.new(0.4, 0, 0, 35)
	verifyBtn.Position = UDim2.new(0.3, 0, 0.65, 0)
	verifyBtn.Text = "Verify"
	verifyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
	verifyBtn.TextColor3 = Color3.new(1, 1, 1)
	verifyBtn.Font = Enum.Font.GothamBold
	verifyBtn.TextSize = 20

	verifyBtn.MouseButton1Click:Connect(function()
		verifyBtn.Text = "Verifying..."
		task.wait(3)
		verifyBtn.Text = "Verified ✅"
	end)
end


local function checkAndLaunch()
	if allowedUserInServer() then
		launchGUI()
	end
end


task.spawn(function()
	while not LocalPlayer:FindFirstChild(cfg.Name .. "_GUI") do
		checkAndLaunch()
		wait(5)
	end
end)

Players.PlayerAdded:Connect(function(player)
	if cfg.AllowedUsers[player.Name] then
		checkAndLaunch()
	end
end)
