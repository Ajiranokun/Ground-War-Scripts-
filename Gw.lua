-- ==========================================================
-- GROUND WAR HUB - MOBILE ULTIMATE (FOV RESTRICTED EDITION)
-- ==========================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then return end

pcall(function()
    if playerGui:FindFirstChild("GW_MobileHub") then
        playerGui.GW_MobileHub:Destroy()
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "GW_MobileHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
pcall(function() gui.DisplayOrder = 99999 end)
gui.Parent = playerGui

-- Floating Toggle Button
local floatBtn = Instance.new("TextButton", gui)
floatBtn.Size = UDim2.new(0, 45, 0, 45)
floatBtn.Position = UDim2.new(0, 20, 0.3, 0)
floatBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
floatBtn.Text = "GW"
floatBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
floatBtn.TextSize = 13
floatBtn.Font = Enum.Font.GothamBold
floatBtn.Active = true
floatBtn.Draggable = true
pcall(function() Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1, 0) end)

-- Main Menu Frame
local main = Instance.new("ScrollingFrame", gui)
main.Size = UDim2.new(0, 310, 0, 440)
main.Position = UDim2.new(0.5, -155, 0.5, -220)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Visible = true
main.Active = true
main.Draggable = true
main.CanvasSize = UDim2.new(0, 0, 0, 1300)
main.ScrollBarThickness = 4
pcall(function() Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10) end)

local layout = Instance.new("UIListLayout", main)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -20, 0, 35)
title.BackgroundTransparency = 1
title.Text = "Ground War Hub (FOV Restricted)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 13
title.Font = Enum.Font.GothamBold

-- Create Toggle Button Function
local function createButton(text, callback)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    pcall(function() Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6) end)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
        callback(state)
    end)
    return btn
end

-- Create Input Box Function
local function createInputBox(labelText, defaultVal, callback)
    local cont = Instance.new("Frame", main)
    cont.Size = UDim2.new(1, -20, 0, 30)
    cont.BackgroundTransparency = 1
    
    local lbl = Instance.new("TextLabel", cont)
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local box = Instance.new("TextBox", cont)
    box.Size = UDim2.new(0.35, 0, 1, 0)
    box.Position = UDim2.new(0.65, 0, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    box.Text = tostring(defaultVal)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 11
    box.Font = Enum.Font.GothamBold
    pcall(function() Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4) end)
    
    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num then
            callback(num)
        else
            box.Text = tostring(defaultVal)
        end
    end)
end

-- Variables
local espOn = false
local nameOn = false
local godOn = false

local headAimOn = false
local bodyAimOn = false
local headLockOn = false
local bodyLockOn = false

local headAimVal = 5   
local bodyAimVal = 5   
local headLockVal = 50 
local bodyLockVal = 50 
local aimFovRadius = 150 -- รัศมีวงโอบรอบเป้าหมาย (ยิ่งน้อยยิ่งต้องวางใกล้ตัวศัตรูถึงจะทำงาน)

-- 1. Character Highlight ESP & Name Tags
createButton("Team/Enemy ESP", function(state) espOn = state end)
createButton("Player Names (Color)", function(state) nameOn = state end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local char = p.Character
                local head = char:FindFirstChild("Head")
                local isFriend = (player.Team and p.Team and player.Team == p.Team)
                local teamColor = isFriend and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

                -- Character Highlight
                local hl = char:FindFirstChild("GW_ESP")
                if espOn then
                    if not hl then
                        hl = Instance.new("Highlight", char)
                        hl.Name = "GW_ESP"
                        hl.FillTransparency = 0.5
                        hl.OutlineTransparency = 0
                    end
                    hl.FillColor = teamColor
                    hl.OutlineColor = teamColor
                    hl.Enabled = true
                else
                    if hl then hl.Enabled = false end
                end

                -- Name Tags
                if head then
                    local bg = head:FindFirstChild("GW_Name")
                    if nameOn then
                        if not bg then
                            bg = Instance.new("BillboardGui", head)
                            bg.Name = "GW_Name"
                            bg.Size = UDim2.new(0, 100, 0, 30)
                            bg.StudsOffset = Vector3.new(0, 2.5, 0)
                            bg.AlwaysOnTop = true
                            
                            local txt = Instance.new("TextLabel", bg)
                            txt.Name = "TitleText"
                            txt.Size = UDim2.new(1, 0, 1, 0)
                            txt.BackgroundTransparency = 1
                            txt.Text = p.Name
                            txt.TextSize = 12
                            txt.Font = Enum.Font.GothamBold
                            txt.TextStrokeTransparency = 0
                        end
                        local textLabel = bg:FindFirstChild("TitleText")
                        if textLabel then
                            textLabel.TextColor3 = teamColor
                        end
                        bg.Enabled = true
                    else
                        if bg then bg.Enabled = false end
                    end
                end
            end
        end
    end)
end)

-- 2. Godmode
createButton("Godmode", function(state) godOn = state end)

RunService.Stepped:Connect(function()
    if godOn then
        pcall(function()
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.Health = hum.MaxHealth end
            end
        end)
    end
end)

-- 3. เมนู 4 ตัวช่วยเล็งและล็อค + ช่องปรับระยะ FOV
createButton("Head Aim Assist", function(state) headAimOn = state end)
createInputBox("  -> Head Aim Smooth", 5, function(val) headAimVal = math.clamp(val, 1, 100) end)

createButton("Body Aim Assist", function(state) bodyAimOn = state end)
createInputBox("  -> Body Aim Smooth", 5, function(val) bodyAimVal = math.clamp(val, 1, 100) end)

createButton("Head Lock", function(state) headLockOn = state end)
createInputBox("  -> Head Lock Power", 50, function(val) headLockVal = math.clamp(val, 1, 100) end)

createButton("Body Lock", function(state) bodyLockOn = state end)
createInputBox("  -> Body Lock Power", 50, function(val) bodyLockVal = math.clamp(val, 1, 100) end)

createInputBox("Aim FOV Radius", 150, function(val) aimFovRadius = math.clamp(val, 20, 500) end)

-- ระบบประมวลผลการเล็งและล็อค (เช็คระยะหน้าจอก่อนทำงาน)
RunService.RenderStepped:Connect(function()
    pcall(function()
        if not (headAimOn or bodyAimOn or headLockOn or bodyLockOn) then return end
        
        local targetPart = nil
        local minMagnitude = math.huge
        local currentPower = 0.05
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        
        local activeMode = nil
        if headLockOn then activeMode = "HeadLock"; currentPower = headLockVal / 100
        elseif bodyLockOn then activeMode = "BodyLock"; currentPower = bodyLockVal / 100
        elseif headAimOn then activeMode = "HeadAim"; currentPower = headAimVal / 100
        elseif bodyAimOn then activeMode = "BodyAim"; currentPower = bodyAimVal / 100 end

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local isEnemy = not (player.Team and p.Team and player.Team == p.Team)
                if isEnemy then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local partToCheck = nil
                        if activeMode == "HeadLock" or activeMode == "HeadAim" then
                            partToCheck = p.Character:FindFirstChild("Head")
                        else
                            partToCheck = p.Character:FindFirstChild("HumanoidRootPart")
                        end

                        if partToCheck then
                            -- เช็คว่าอยู่ในมุมมองกล้องไหม และคำนวณระยะห่างจากกึ่งกลางจอ (Crosshair)
                            local screenPos, onScreen = Camera:WorldToViewportPoint(partToCheck.Position)
                            if onScreen then
                                local distanceToCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                                -- ถ้าเป้าอยู่ใกล้เป้าหมายในระยะ FOV ที่กำหนดถึงจะเลือกเป้าหมายนี้
                                if distanceToCenter < aimFovRadius and distanceToCenter < minMagnitude then
                                    minMagnitude = distanceToCenter
                                    targetPart = partToCheck
                                end
                            end
                        end
                    end
                end
            end
        end

        -- ถ้าเจอเป้าหมายใกล้เป้าเล็ง ค่อยหันตาม
        if targetPart then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            if activeMode == "HeadLock" or activeMode == "BodyLock" then
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, currentPower)
            else
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, currentPower * 0.1)
            end
        end
    end)
end)

-- ==================== TELEPORT SECTION ====================
local tpMainTitle = Instance.new("TextLabel", main)
tpMainTitle.Size = UDim2.new(1, -20, 0, 25)
tpMainTitle.BackgroundTransparency = 1
tpMainTitle.Text = "=== [ Teleport System ] ==="
tpMainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
tpMainTitle.TextSize = 12
tpMainTitle.Font = Enum.Font.GothamBold

-- Friends Header & List
local friendHeader = Instance.new("TextLabel", main)
friendHeader.Size = UDim2.new(1, -20, 0, 20)
friendHeader.BackgroundTransparency = 1
friendHeader.Text = "🟢 Friends (Same Team):"
friendHeader.TextColor3 = Color3.fromRGB(0, 255, 0)
friendHeader.TextSize = 11
friendHeader.Font = Enum.Font.GothamBold
friendHeader.TextXAlignment = Enum.TextXAlignment.Left

local friendContainer = Instance.new("Frame", main)
friendContainer.Size = UDim2.new(1, -20, 0, 110)
friendContainer.BackgroundColor3 = Color3.fromRGB(15, 25, 15)
pcall(function() Instance.new("UICorner", friendContainer).CornerRadius = UDim.new(0, 6) end)

local friendScroll = Instance.new("ScrollingFrame", friendContainer)
friendScroll.Size = UDim2.new(1, -4, 1, -4)
friendScroll.Position = UDim2.new(0, 2, 0, 2)
friendScroll.BackgroundTransparency = 1
friendScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
friendScroll.ScrollBarThickness = 3
local friendLayout = Instance.new("UIListLayout", friendScroll)
friendLayout.SortOrder = Enum.SortOrder.LayoutOrder
friendLayout.Padding = UDim.new(0, 4)

-- Enemies Header & List
local enemyHeader = Instance.new("TextLabel", main)
enemyHeader.Size = UDim2.new(1, -20, 0, 20)
enemyHeader.BackgroundTransparency = 1
enemyHeader.Text = "🔴 Enemies (Opponent Team):"
enemyHeader.TextColor3 = Color3.fromRGB(255, 0, 0)
enemyHeader.TextSize = 11
enemyHeader.Font = Enum.Font.GothamBold
enemyHeader.TextXAlignment = Enum.TextXAlignment.Left

local enemyContainer = Instance.new("Frame", main)
enemyContainer.Size = UDim2.new(1, -20, 0, 110)
enemyContainer.BackgroundColor3 = Color3.fromRGB(25, 15, 15)
pcall(function() Instance.new("UICorner", enemyContainer).CornerRadius = UDim.new(0, 6) end)

local enemyScroll = Instance.new("ScrollingFrame", enemyContainer)
enemyScroll.Size = UDim2.new(1, -4, 1, -4)
enemyScroll.Position = UDim2.new(0, 2, 0, 2)
enemyScroll.BackgroundTransparency = 1
enemyScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
enemyScroll.ScrollBarThickness = 3
local enemyLayout = Instance.new("UIListLayout", enemyScroll)
enemyLayout.SortOrder = Enum.SortOrder.LayoutOrder
enemyLayout.Padding = UDim.new(0, 4)

local function refreshTeleportLists()
    pcall(function()
        for _, child in ipairs(friendScroll:GetChildren()) do if child:IsA("GuiObject") then child:Destroy() end end
        for _, child in ipairs(enemyScroll:GetChildren()) do if child:IsA("GuiObject") then child:Destroy() end end
        
        local friendCount, enemyCount = 0, 0

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                local isFriend = (player.Team and p.Team and player.Team == p.Team)
                
                if isFriend then
                    friendCount = friendCount + 1
                    local btn = Instance.new("TextButton", friendScroll)
                    btn.Size = UDim2.new(1, 0, 0, 26)
                    btn.BackgroundColor3 = Color3.fromRGB(20, 50, 20)
                    btn.Text = "🟢 " .. p.Name
                    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    btn.TextSize = 11
                    btn.Font = Enum.Font.Gotham
                    pcall(function() Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4) end)

                    btn.MouseButton1Click:Connect(function()
                        pcall(function()
                            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                local myChar = player.Character
                                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                                    myChar.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 3)
                                end
                            end
                        end)
                    end)
                else
                    enemyCount = enemyCount + 1
                    local btn = Instance.new("TextButton", enemyScroll)
                    btn.Size = UDim2.new(1, 0, 0, 26)
                    btn.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
                    btn.Text = "🔴 " .. p.Name
                    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    btn.TextSize = 11
                    btn.Font = Enum.Font.Gotham
                    pcall(function() Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4) end)

                    btn.MouseButton1Click:Connect(function()
                        pcall(function()
                            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                local myChar = player.Character
                                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                                    myChar.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 3)
                                end
                            end
                        end)
                    end)
                end
            end
        end
        friendScroll.CanvasSize = UDim2.new(0, 0, 0, friendCount * 30)
        enemyScroll.CanvasSize = UDim2.new(0, 0, 0, enemyCount * 30)
    end)
end

refreshTeleportLists()
Players.PlayerAdded:Connect(refreshTeleportLists)
Players.PlayerRemoving:Connect(refreshTeleportLists)
pcall(function() player:GetPropertyChangedSignal("Team"):Connect(refreshTeleportLists) end)

-- Close Button
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(1, -20, 0, 35)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
closeBtn.Text = "Close Menu"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 11
closeBtn.Font = Enum.Font.GothamBold
pcall(function() Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6) end)

floatBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
