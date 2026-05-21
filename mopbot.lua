--[[
    MOB MANAGER V5 - (FULL BODY DETECTION)
    ✅ اختيار الموب بالكامل حتى لو لمست أصغر قطعة فيه
    ✅ نظام تأكيد الاختيار (Confirm System)
    ✅ منع التداخل مع الواجهة (Anti-UI Bleed)
    ✅ عرض المسار والاسم بالكامل
]]--

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local targetCFrame = nil
local savedMobNames = {} 
local selectionMode = false
local tempSelectedMob = nil 

-- دالة ذكية لإيجاد الموب بالكامل من لمسة واحدة
local function findFullMob(part)
    local current = part
    -- نصعد من الجزء الملموس إلى الأعلى للبحث عن موديل فيه Humanoid
    while current and current ~= workspace do
        if current:IsA("Model") and current:FindFirstChildOfClass("Humanoid") then
            return current -- وجدنا الموب بالكامل!
        end
        current = current.Parent
    end
    -- إذا لم نجد Humanoid، ربما الموب عبارة عن موديل بسيط بدون محرك حركة
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
selectionBox.Color3 = Color3.fromRGB(0, 255, 255)
selectionBox.LineThickness = 0.3 -- خط أسمك ليكون واضحاً
selectionBox.Parent = workspace

-- ==================== بناء الواجهة ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobManagerV5"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 220)
mainFrame.Position = UDim2.new(0.5, -175, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true 
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Text = "🛡️ Full Mob Manager V5"
title.Size = UDim2.new(1, 0, 0, 30)
title.TextColor3 = Color3.fromRGB(0, 255, 150)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local infoLabel = Instance.new("TextLabel")
infoLabel.Text = "اضغط 'وضع التحديد' ثم اختر موب"
infoLabel.Size = UDim2.new(0.9, 0, 0, 45)
infoLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
infoLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
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
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local posBtn = createBtn("📍 حفظ الموقع", UDim2.new(0.05, 0, 0.4, 0), UDim2.new(0.43, 0, 0, 35), Color3.fromRGB(50, 50, 50))
local selectBtn = createBtn("🔍 وضع التحديد: OFF", UDim2.new(0.52, 0, 0.4, 0), UDim2.new(0.43, 0, 0, 35), Color3.fromRGB(180, 40, 40))

local confirmBtn = createBtn("✅ تأكيد اختيار الموب", UDim2.new(0.05, 0, 0.6, 0), UDim2.new(0.9, 0, 0, 35), Color3.fromRGB(0, 120, 255))
confirmBtn.Visible = false

local teleportBtn = createBtn("🚀 نقل الكل", UDim2.new(0.05, 0, 0.8, 0), UDim2.new(0.43, 0, 0, 35), Color3.fromRGB(0, 150, 80))
local clearBtn = createBtn("🗑️ مسح القائمة", UDim2.new(0.52, 0, 0.8, 0), UDim2.new(0.43, 0, 0, 35), Color3.fromRGB(120, 0, 0))

-- ==================== المنطق البرمجي المطور ====================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- تجاهل اللمس إذا كان فوق الواجهة
    
    if selectionMode and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
        local unitRay = camera:ScreenPointToRay(input.Position.X, input.Position.Y)
        local raycastResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1500)
        
        if raycastResult and raycastResult.Instance then
            -- استخدام الدالة الجديدة لإيجاد الموب بالكامل
            local fullMob = findFullMob(raycastResult.Instance)
            
            if fullMob then
                tempSelectedMob = fullMob
                selectionBox.Adornee = fullMob -- سيحيط الصندوق بالموب بالكامل الآن
                infoLabel.Text = "الموب المختار: " .. fullMob.Name .. "\nالمسار: " .. getFullPath(fullMob)
                confirmBtn.Visible = true
                confirmBtn.Text = "✅ تأكيد حفظ: " .. fullMob.Name
            end
        end
    end
end)

confirmBtn.MouseButton1Click:Connect(function()
    if tempSelectedMob then
        if not table.find(savedMobNames, tempSelectedMob.Name) then
            table.insert(savedMobNames, tempSelectedMob.Name)
            infoLabel.Text = "✅ تم حفظ نوع [ " .. tempSelectedMob.Name .. " ]"
        else
            infoLabel.Text = "⚠️ هذا النوع موجود بالفعل في القائمة"
        end
        confirmBtn.Visible = false
        selectionBox.Adornee = nil
        tempSelectedMob = nil
    end
end)

posBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        targetCFrame = player.Character.HumanoidRootPart.CFrame
        posBtn.Text = "✅ موقعك محفوظ"
        task.wait(1)
        posBtn.Text = "📍 تحديث الموقع"
    end
end)

selectBtn.MouseButton1Click:Connect(function()
    selectionMode = not selectionMode
    selectBtn.Text = selectionMode and "🔍 وضع التحديد: ON" or "🔍 وضع التحديد: OFF"
    selectBtn.BackgroundColor3 = selectionMode and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
    if not selectionMode then 
        confirmBtn.Visible = false 
        selectionBox.Adornee = nil
    end
end)

teleportBtn.MouseButton1Click:Connect(function()
    if not targetCFrame or #savedMobNames == 0 then
        infoLabel.Text = "❌ خطأ: حدد موقعاً وموباً أولاً!"
        return
    end

    local count = 0
    -- البحث عن كل الموديلات التي تطابق الأسماء المحفوظة
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Model") and table.find(savedMobNames, item.Name) then
            -- النقل باستخدام PivotTo يضمن نقل الموب بجميع أجزائه
            item:PivotTo(targetCFrame + Vector3.new(math.random(-5,5), 2, math.random(-5,5)))
            count = count + 1
        end
    end
    infoLabel.Text = "🚀 تم نقل " .. count .. " موب بنجاح!"
end)

clearBtn.MouseButton1Click:Connect(function()
    savedMobNames = {}
    tempSelectedMob = nil
    selectionBox.Adornee = nil
    confirmBtn.Visible = false
    infoLabel.Text = "🗑️ القائمة فارغة الآن"
end)

local close = createBtn("X", UDim2.new(1, -25, 0, 5), UDim2.new(0, 20, 0, 20), Color3.fromRGB(255, 50, 50))
close.MouseButton1Click:Connect(function() screenGui:Destroy() end)
