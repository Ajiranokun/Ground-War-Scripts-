-- สร้าง ScreenGui หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KruyPrabGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- สร้างกรอบข้อความตรงกลางจอ
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 150)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- ทำมุมโค้งให้กรอบ
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- เพิ่มขอบเรืองแสง (UIStroke)
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 0, 0)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- สร้างข้อความ "ควยปราบ"
local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, 0, 0.6, 0)
TextLabel.Position = UDim2.new(0, 0, 0.1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "ควยปราบ"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 36
TextLabel.Font = Enum.Font.GothamBold
TextLabel.Parent = MainFrame

-- สร้างปุ่มปิด (Close Button)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 100, 0, 35)
CloseButton.Position = UDim2.new(0.5, -50, 0.7, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "ปิด"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

-- มุมโค้งของปุ่ม
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = CloseButton

-- ฟังก์ชันกดปุ่มเพื่อลบ GUI ทิ้ง
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
