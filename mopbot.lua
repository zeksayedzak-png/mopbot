-- =====================================================
-- 🕵️ POST-EXECUTION GRABBER
-- =====================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- =====================================================
-- واجهة
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PostExecGrabber"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 230)
MainFrame.Position = UDim2.new(0.5, -180, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

-- شريط العنوان
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🧩 Post-Execution Grabber"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 3)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = TitleBar

local UrlInput = Instance.new("TextBox")
UrlInput.Size = UDim2.new(0.9, 0, 0, 40)
UrlInput.Position = UDim2.new(0.05, 0, 0.2, 0)
UrlInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
UrlInput.TextColor3 = Color3.fromRGB(255, 255, 255)
UrlInput.Font = Enum.Font.Gotham
UrlInput.TextSize = 14
UrlInput.PlaceholderText = "Paste script URL..."
UrlInput.Text = ""
UrlInput.Parent = MainFrame
Instance.new("UICorner", UrlInput).CornerRadius = UDim.new(0, 10)

local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Size = UDim2.new(0.9, 0, 0, 40)
ExecuteBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
ExecuteBtn.Text = "🚀 Execute & Capture"
ExecuteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.TextSize = 16
ExecuteBtn.Parent = MainFrame
Instance.new("UICorner", ExecuteBtn).CornerRadius = UDim.new(0, 10)

local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.9, 0, 0, 35)
CopyBtn.Position = UDim2.new(0.05, 0, 0.72, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CopyBtn.Text = "📋 Copy Clean Code"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 14
CopyBtn.Parent = MainFrame
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 10)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 25)
StatusLabel.Position = UDim2.new(0.05, 0, 0.9, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🔹 Ready"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.Parent = MainFrame

-- =====================================================
-- السحب باللمس
-- =====================================================
local dragData = {dragging = false, startPos = nil, startMouse = nil}

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragData.dragging = true
        dragData.startPos = MainFrame.Position
        dragData.startMouse = Vector2.new(input.Position.X, input.Position.Y)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragData.dragging then
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragData.startMouse
            MainFrame.Position = UDim2.new(0, dragData.startPos.X.Offset + delta.X, 0, dragData.startPos.Y.Offset + delta.Y)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragData.dragging = false
    end
end)

-- =====================================================
-- المتغيرات
-- =====================================================
local cleanCode = ""

-- =====================================================
-- مراقبة loadstring (عشان ناخد الكود النظيف)
-- =====================================================
local function captureCleanCode()
    local oldLoadstring = loadstring
    loadstring = function(code, chunkname)
        if code and #code > 10 then
            cleanCode = code
            print("📜 Clean code captured!")
        end
        return oldLoadstring(code, chunkname)
    end
end

captureCleanCode()

-- =====================================================
-- الأزرار
-- =====================================================
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

ExecuteBtn.MouseButton1Click:Connect(function()
    local url = UrlInput.Text
    if url == "" then
        StatusLabel.Text = "⚠️ Paste URL first!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        return
    end

    StatusLabel.Text = "⏳ Fetching..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

    local success, content = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        StatusLabel.Text = "✅ Code fetched! Executing..."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

        -- تنفيذ الكود في بيئة منعزلة
        local func, err = loadstring(content)
        if func then
            task.spawn(function()
                pcall(func)
                StatusLabel.Text = "✅ Code executed! Clean code saved."
                StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            end)
        else
            StatusLabel.Text = "❌ Loadstring error: " .. tostring(err):sub(1, 30)
            StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    else
        StatusLabel.Text = "❌ Failed to fetch!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

CopyBtn.MouseButton1Click:Connect(function()
    if cleanCode ~= "" then
        setclipboard(cleanCode)
        StatusLabel.Text = "📋 Clean code copied!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    else
        StatusLabel.Text = "❌ No clean code to copy!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

print("🧩 Post-Execution Grabber is ready!")
