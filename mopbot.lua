--[[
    MOB MANAGER V6 - (SMART MOVEMENT SYSTEM)
    ✅ نظام التحريك بدل النقل (To prevent Anti-Teleport)
    ✅ البحث عن Humanoid لإصدار أمر المشي
    ✅ الحفاظ على نظام التحديد الشامل
]]--

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local targetCFrame = nil
local savedMobNames = {} 
local selectionMode = false
local tempSelectedMob = nil 

-- دالة إيجاد الموب بالكامل
local function findFullMob(part)
    local current = part
    while current and current ~= workspace do
        if current:IsA("Model") and current:FindFirstChildOfClass("Humanoid") then
            return current
        end
        current = current.Parent
    end
    return part:FindFirstAncestorOfClass("Model") or part
end

local function getFullPath(obj)
    local path = obj.Name
    local parent = obj.Parent
    while parent and parent ~= game do
        path = parent.Name .. "." .. path
        parent = parent.Parent
    end
    return path
end

local selectionBox = Instance.new("SelectionBox")
selectionBox.Color3 = Color3.fromRGB(255, 170, 0)
selectionBox.LineThickness = 0.4
selectionBox.Parent = workspace

-- ==================== الواجهة ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobManagerV6"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 220)
mainFrame.Position = UDim2.new(0.5, -175, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.Active = true
mainFrame.Draggable = true 
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Text = "⚡ Mob Walker V6"
title.Size = UDim2.new(1, 0, 0, 35)
title.TextColor3 = Color3.fromRGB(255, 200, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local infoLabel = Instance.new("TextLabel")
infoLabel.Text = "حدد الموب وموقع التجمع"
infoLabel.Size = UDim2.new(0.9, 0, 0, 45)
infoLabel.Position = UDim2.new(0.05, 0, 0.18, 0)
infoLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.TextSize = 11
infoLabel.TextWrapped = true
infoLabel.Font = Enum.Font.Code
infoLabel.Parent = mainFrame
Instance.new("UICorner", infoLabel)

-- ==================== الأزرار ====================
local function createBtn(text, pos, size, color)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = mainFrame
    Instance.new("UICorner", btn)
    return btn
end

local posBtn = createBtn("📍 تحديد نقطة التجمع", UDim2.new(0.05, 0, 0.42, 0), UDim2.new(0.43, 0, 0, 35), Color3.fromRGB(60, 60, 60))
local selectBtn = createBtn("🔍 وضع التحديد: OFF", UDim2.new(0.52, 0, 0.42, 0), UDim2.new(0.43, 0, 0, 35), Color3.fromRGB(150, 0, 0))

local confirmBtn = createBtn("✅ تأكيد الموب", UDim2.new(0.05, 0, 0.61, 0), UDim2.new(0.9, 0, 0, 35), Color3.fromRGB(0, 100, 200))
confirmBtn.Visible = false

local moveBtn = createBtn("🏃 استدعاء الموبات (مشي)", UDim2.new(0.05, 0, 0.8, 0), UDim2.new(0.43, 0, 0, 35), Color3.fromRGB(0, 120, 60))
local clearBtn = createBtn("🗑️ مسح", UDim2.new(0.52, 0, 0.8, 0), UDim2.new(0.43, 0, 0, 35), Color3.fromRGB(100, 0, 0))

-- ==================== المنطق البرمجي ====================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if selectionMode and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
        local unitRay = camera:ScreenPointToRay(input.Position.X, input.Position.Y)
        local raycastResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000)
        
        if raycastResult and raycastResult.Instance then
            local fullMob = findFullMob(raycastResult.Instance)
            if fullMob then
                tempSelectedMob = fullMob
                selectionBox.Adornee = fullMob
                infoLabel.Text = "المختار: " .. fullMob.Name
                confirmBtn.Visible = true
            end
        end
    end
end)

confirmBtn.MouseButton1Click:Connect(function()
    if tempSelectedMob then
        if not table.find(savedMobNames, tempSelectedMob.Name) then
            table.insert(savedMobNames, tempSelectedMob.Name)
            infoLabel.Text = "✅ تمت إضافة: " .. tempSelectedMob.Name
        end
        confirmBtn.Visible = false
        selectionBox.Adornee = nil
        tempSelectedMob = nil
    end
end)

posBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        targetCFrame = player.Character.HumanoidRootPart.CFrame
        posBtn.Text = "✅ تم تحديد النقطة"
        task.wait(1)
        posBtn.Text = "📍 تحديث النقطة"
    end
end)

selectBtn.MouseButton1Click:Connect(function()
    selectionMode = not selectionMode
    selectBtn.Text = selectionMode and "🔍 وضع التحديد: ON" or "🔍 وضع التحديد: OFF"
    selectBtn.BackgroundColor3 = selectionMode and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- دالة التحريك (MoveTo) بدلاً من النقل (Teleport)
moveBtn.MouseButton1Click:Connect(function()
    if not targetCFrame or #savedMobNames == 0 then
        infoLabel.Text = "❌ حدد الموقع والموبات أولاً"
        return
    end

    local count = 0
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Model") and table.find(savedMobNames, item.Name) then
            local hum = item:FindFirstChildOfClass("Humanoid")
            if hum then
                -- إعطاء أمر المشي للنقطة المحددة مع عشوائية بسيطة لكي لا يتكدسوا فوق بعض
                local offset = Vector3.new(math.random(-3,3), 0, math.random(-3,3))
                hum:MoveTo(targetCFrame.Position + offset)
                count = count + 1
            end
        end
    end
    infoLabel.Text = "🏃 جاري تحريك " .. count .. " موب..."
end)

clearBtn.MouseButton1Click:Connect(function()
    savedMobNames = {}
    infoLabel.Text = "🗑️ القائمة فارغة"
end)

local close = createBtn("X", UDim2.new(1, -25, 0, 5), UDim2.new(0, 20, 0, 20), Color3.fromRGB(200, 0, 0))
close.MouseButton1Click:Connect(function() screenGui:Destroy() end)
