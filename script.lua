-- GUI Oluşturma
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Tabs = Instance.new("Folder")
local GeneralTab = Instance.new("TextButton")
local TrollTab = Instance.new("TextButton")
local ScriptsTab = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")

-- Ana GUI Ayarları
ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Draggable = true
MainFrame.Active = true

-- Tab Butonları
GeneralTab.Parent = MainFrame
GeneralTab.Size = UDim2.new(0, 100, 0, 30)
GeneralTab.Position = UDim2.new(0, 0, 0, 0)
GeneralTab.Text = "Genel"
GeneralTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

TrollTab.Parent = MainFrame
TrollTab.Size = UDim2.new(0, 100, 0, 30)
TrollTab.Position = UDim2.new(0, 100, 0, 0)
TrollTab.Text = "Troll"
TrollTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

ScriptsTab.Parent = MainFrame
ScriptsTab.Size = UDim2.new(0, 100, 0, 30)
ScriptsTab.Position = UDim2.new(0, 200, 0, 0)
ScriptsTab.Text = "Hazır Scriptler"
ScriptsTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

CloseButton.Parent = MainFrame
CloseButton.Size = UDim2.new(0, 50, 0, 30)
CloseButton.Position = UDim2.new(1, -50, 0, 0)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

-- Fonksiyonlar
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

function ExecuteInfiniteYield()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end

function EnableFlight()
    loadstring(game:HttpGet("https://pastebin.com/raw/6mH0Xgby"))()
end

function SetSpeed(speed)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
end

-- GUI İçeriği
local GeneralFrame = Instance.new("Frame")
GeneralFrame.Parent = MainFrame
GeneralFrame.Size = UDim2.new(1, 0, 1, -30)
GeneralFrame.Position = UDim2.new(0, 0, 0, 30)
GeneralFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local FlightButton = Instance.new("TextButton")
FlightButton.Parent = GeneralFrame
FlightButton.Size = UDim2.new(0, 100, 0, 30)
FlightButton.Position = UDim2.new(0, 10, 0, 10)
FlightButton.Text = "Uçma Scripti"
FlightButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
FlightButton.MouseButton1Click:Connect(EnableFlight)

local SpeedGuiButton = Instance.new("TextButton")
SpeedGuiButton.Parent = GeneralFrame
SpeedGuiButton.Size = UDim2.new(0, 100, 0, 30)
SpeedGuiButton.Position = UDim2.new(0, 10, 0, 50)
SpeedGuiButton.Text = "Hız Ayarla"
SpeedGuiButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
SpeedGuiButton.MouseButton1Click:Connect(function()
    local SpeedGui = Instance.new("Frame")
    SpeedGui.Parent = ScreenGui
    SpeedGui.Size = UDim2.new(0, 200, 0, 100)
    SpeedGui.Position = UDim2.new(0.5, -100, 0.5, -50)
    SpeedGui.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    local SpeedBox = Instance.new("TextBox")
    SpeedBox.Parent = SpeedGui
    SpeedBox.Size = UDim2.new(0, 180, 0, 30)
    SpeedBox.Position = UDim2.new(0, 10, 0, 10)
    SpeedBox.PlaceholderText = "Hız Değerini Gir"
    
    local ConfirmButton = Instance.new("TextButton")
    ConfirmButton.Parent = SpeedGui
    ConfirmButton.Size = UDim2.new(0, 180, 0, 30)
    ConfirmButton.Position = UDim2.new(0, 10, 0, 50)
    ConfirmButton.Text = "Onayla"
    ConfirmButton.MouseButton1Click:Connect(function()
        SetSpeed(tonumber(SpeedBox.Text))
        SpeedGui:Destroy()
    end)
end)

local TrollFrame = Instance.new("Frame")
TrollFrame.Parent = MainFrame
TrollFrame.Size = UDim2.new(1, 0, 1, -30)
TrollFrame.Position = UDim2.new(0, 0, 0, 30)
TrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TrollFrame.Visible = false

local LaunchGuiButton = Instance.new("TextButton")
LaunchGuiButton.Parent = TrollFrame
LaunchGuiButton.Size = UDim2.new(0, 100, 0, 30)
LaunchGuiButton.Position = UDim2.new(0, 10, 0, 10)
LaunchGuiButton.Text = "Uçurma GUI"
LaunchGuiButton.MouseButton1Click:Connect(function()
    -- Uçurma GUI'si oluşturulabilir
end)

GeneralTab.MouseButton1Click:Connect(function()
    GeneralFrame.Visible = true
    TrollFrame.Visible = false
end)

TrollTab.MouseButton1Click:Connect(function()
    GeneralFrame.Visible = false
    TrollFrame.Visible = true
end)

ScriptsTab.MouseButton1Click:Connect(function()
    ExecuteInfiniteYield()
end)
