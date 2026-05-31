--[[
    Smart Mob Scanner & Teleport - Black Edition
    تطوير: Assistant AI & المدير
    الوصف: سكريبت ذكي للتعرف على الموبات وعرضها في قائمة مع النقل السريع.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- متغيرات التحكم
local selectedMobName = ""
local selectedMobPath = ""
local isSelecting = false

-- إنشاء الواجهة
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SmartMobGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- دالة السحب (Draggable) للجوال
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- الإطار الرئيسي
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 300)
mainFrame.Position = UDim2.new(0.5, -110, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
makeDraggable(mainFrame)

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- زر الإغلاق (التصغير)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.Parent = mainFrame

-- الزر الصغير (M)
local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, 50, 0, 50)
miniBtn.Position = UDim2.new(0.5, -25, 0.05, 0)
miniBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
miniBtn.Text = "M"
miniBtn.TextColor3 = Color3.new(1, 1, 1)
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 25
miniBtn.Visible = false
miniBtn.Parent = screenGui
makeDraggable(miniBtn)

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(1, 0)
miniCorner.Parent = miniBtn

local miniStroke = Instance.new("UIStroke")
miniStroke.Thickness = 3
miniStroke.Parent = miniBtn

-- تأثير قوس قزح
spawn(function()
    local h = 0
    while wait() do
        miniStroke.Color = Color3.fromHSV(h, 1, 1)
        h = h + 0.01
        if h > 1 then h = 0 end
    end
end)

-- محتويات الواجهة
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "SMART SCANNER"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local scanStatus = Instance.new("TextLabel")
scanStatus.Size = UDim2.new(0.9, 0, 0, 25)
scanStatus.Position = UDim2.new(0.05, 0, 0.15, 0)
scanStatus.Text = "Status: Idle"
scanStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
scanStatus.BackgroundTransparency = 1
scanStatus.Font = Enum.Font.Gotham
scanStatus.Parent = mainFrame

local selectModeBtn = Instance.new("TextButton")
selectModeBtn.Size = UDim2.new(0.9, 0, 0, 35)
selectModeBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
selectModeBtn.Text = "START SELECTION"
selectModeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
selectModeBtn.TextColor3 = Color3.new(1, 1, 1)
selectModeBtn.Font = Enum.Font.GothamBold
selectModeBtn.Parent = mainFrame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(0.9, 0, 0, 130)
scrollingFrame.Position = UDim2.new(0.05, 0, 0.45, 0)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 4
scrollingFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = scrollingFrame
uiListLayout.Padding = UDim.new(0, 5)

-- منطق الاختيار
selectModeBtn.MouseButton1Click:Connect(function()
    isSelecting = not isSelecting
    selectModeBtn.Text = isSelecting and "TAP A MOB..." or "START SELECTION"
    selectModeBtn.BackgroundColor3 = isSelecting and Color3.fromRGB(200, 150, 0) or Color3.fromRGB(0, 120, 215)
end)

local function createMobEntry(mob)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.7, 0, 1, 0)
    nameLabel.Text = " " .. mob.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextScaled = true
    nameLabel.Parent = frame
    
    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(0.25, 0, 0.8, 0)
    tpBtn.Position = UDim2.new(0.7, 0, 0.1, 0)
    tpBtn.Text = "TP"
    tpBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    tpBtn.TextColor3 = Color3.new(1, 1, 1)
    tpBtn.Parent = frame
    
    tpBtn.MouseButton1Click:Connect(function()
        if mob:FindFirstChild("HumanoidRootPart") then
            player.Character:PivotTo(mob.HumanoidRootPart.CFrame)
        end
    end)
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = tpBtn
    
    local c2 = Instance.new("UICorner")
    c2.CornerRadius = UDim.new(0, 4)
    c2.Parent = frame
    
    frame.Parent = scrollingFrame
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
end

-- رصد اللمس
UserInputService.InputBegan:Connect(function(input, processed)
    if processed or not isSelecting then return end
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        local unitRay = workspace.CurrentCamera:ScreenPointToRay(input.Position.X, input.Position.Y)
        local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000)
        
        if result and result.Instance then
            local model = result.Instance:FindFirstAncestorOfClass("Model")
            if model and model:FindFirstChild("Humanoid") then
                -- تأكيد الموب
                selectedMobName = model.Name
                selectedMobPath = model:GetFullName()
                scanStatus.Text = "Selected: " .. selectedMobName
                scanStatus.TextColor3 = Color3.new(0, 1, 0)
                
                -- تحديث القائمة
                for _, child in pairs(scrollingFrame:GetChildren()) do
                    if child:IsA("Frame") then child:Destroy() end
                end
                
                -- البحث عن كل الموبات من نفس النوع
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name == selectedMobName and obj:FindFirstChild("Humanoid") then
                        createMobEntry(obj)
                    end
                end
                
                isSelecting = false
                selectModeBtn.Text = "START SELECTION"
                selectModeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
            end
        end
    end
end)

-- أزرار التصغير
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniBtn.Visible = true
end)

miniBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    miniBtn.Visible = false
end)

-- لمسة جمالية لكل الأزرار
for _, v in pairs(mainFrame:GetChildren()) do
    if v:IsA("TextButton") then
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = v
    end
end
