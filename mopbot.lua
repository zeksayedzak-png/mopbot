-- =====================================================
-- 🧠 GUI EXECUTOR + LOADSTRING HOOK
-- =====================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- =====================================================
-- متغير لتخزين الكود النظيف
-- =====================================================
local cleanCode = ""

-- =====================================================
-- Hook على loadstring (بيخزن الكود النظيف)
-- =====================================================
local oldLoadstring = loadstring

loadstring = function(code, chunkname)
    if code and #code > 10 then
        cleanCode = code
        print("📜 Clean code captured!")
    end
    return oldLoadstring(code, chunkname)
end

-- =====================================================
-- واجهة المستخدم
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ExecutorHook"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 320)
MainFrame.Position = UDim2.new(0.5, -190, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

-- شريط العنوان (للسحب)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 8, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🧠 Executor + Hook"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 3)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TitleBar

-- حقل الرابط
local UrlInput = Instance.new("TextBox")
UrlInput.Size = UDim2.new(0.9, 0, 0, 35)
UrlInput.Position = UDim2.new(0.05, 0, 0.13, 0)
UrlInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
UrlInput.TextColor3 = Color3.fromRGB(255, 255, 255)
UrlInput.Font = Enum.Font.Gotham
UrlInput.TextSize = 12
UrlInput.PlaceholderText = "Paste script URL here..."
UrlInput.Text = ""
UrlInput.Parent = MainFrame
Instance.new("UICorner", UrlInput).CornerRadius = UDim.new(0, 8)

-- زر التنفيذ
local ExecBtn = Instance.new("TextButton")
ExecBtn.Size = UDim2.new(0.8, 0, 0, 35)
ExecBtn.Position = UDim2.new(0.1, 0, 0.28, 0)
ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
ExecBtn.Text = "⚡ Execute & Capture"
ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecBtn.Font = Enum.Font.GothamBold
ExecBtn.TextSize = 13
ExecBtn.Parent = MainFrame
Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 8)

-- مساحة عرض الكود النظيف
local CodeBox = Instance.new("ScrollingFrame")
CodeBox.Size = UDim2.new(0.9, 0, 0, 120)
CodeBox.Position = UDim2.new(0.05, 0, 0.42, 0)
CodeBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
CodeBox.ScrollBarThickness = 4
CodeBox.Parent = MainFrame
Instance.new("UICorner", CodeBox).CornerRadius = UDim.new(0, 8)

local CodeLabel = Instance.new("TextLabel")
CodeLabel.Size = UDim2.new(1, -10, 0, 100)
CodeLabel.Position = UDim2.new(0, 5, 0, 5)
CodeLabel.BackgroundTransparency = 1
CodeLabel.Text = "📄 Clean code will appear here..."
CodeLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
CodeLabel.Font = Enum.Font.Gotham
CodeLabel.TextSize = 10
CodeLabel.TextWrapped = true
CodeLabel.TextXAlignment = Enum.TextXAlignment.Left
CodeLabel.TextYAlignment = Enum.TextYAlignment.Top
CodeLabel.Parent = CodeBox

-- زر النسخ
local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.35, 0, 0, 30)
CopyBtn.Position = UDim2.new(0.1, 0, 0.85, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CopyBtn.Text = "📋 Copy Code"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 13
CopyBtn.Parent = MainFrame
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 8)

-- زر مسح
local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0.35, 0, 0, 30)
ClearBtn.Position = UDim2.new(0.55, 0, 0.85, 0)
ClearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ClearBtn.Text = "🗑️ Clear"
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.TextSize = 13
ClearBtn.Parent = MainFrame
Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 8)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 18)
StatusLabel.Position = UDim2.new(0.05, 0, 0.92, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🔹 Ready"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 10
StatusLabel.Parent = MainFrame

-- =====================================================
-- السحب
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
-- الأزرار
-- =====================================================
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

ExecBtn.MouseButton1Click:Connect(function()
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
        StatusLabel.Text = "✅ Executing..."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

        local func, err = loadstring(content)
        if func then
            task.spawn(function()
                pcall(func)
                -- عرض الكود النظيف
                if cleanCode ~= "" then
                    CodeLabel.Text = cleanCode
                    CodeBox.CanvasSize = UDim2.new(0, 0, 0, #cleanCode / 2 + 50)
                    StatusLabel.Text = "✅ Code captured!"
                    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                else
                    StatusLabel.Text = "⚠️ No code captured!"
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
                end
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
        StatusLabel.Text = "📋 Code copied!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    else
        StatusLabel.Text = "❌ No code to copy!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

ClearBtn.MouseButton1Click:Connect(function()
    cleanCode = ""
    CodeLabel.Text = "📄 Clean code will appear here..."
    StatusLabel.Text = "🗑️ Cleared!"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
end)

print("🧠 GUI Executor + Hook is ready!")
