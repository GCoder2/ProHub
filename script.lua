-- GUI Oluşturma
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Tabs = Instance.new("Folder")
local GeneralTab = Instance.new("TextButton")
local TrollTab = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")

-- Ana GUI Ayarları
ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
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

CloseButton.Parent = MainFrame
CloseButton.Size = UDim2.new(0, 50, 0, 30)
CloseButton.Position = UDim2.new(1, -50, 0, 0)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

-- Fonksiyonlar
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Genel Özellikler
function EnableNoclip()
    game:GetService("RunService").Stepped:Connect(function()
        for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end)
end

function EnableESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local highlight = Instance.new("Highlight")
            highlight.Parent = player.Character
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
end

function EnableInfiniteJump()
    game:GetService("UserInputService").JumpRequest:Connect(function()
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end)
end

-- Troll Özellikleri
function TeleportPlayer(target, destination)
    if target and destination then
        target.Character.HumanoidRootPart.CFrame = destination.Character.HumanoidRootPart.CFrame
    end
end

function LaunchPlayer(target)
    if target and target.Character then
        target.Character.HumanoidRootPart.Velocity = Vector3.new(0, 100, 0)
    end
end

-- Kullanıcı Arayüzü
local GeneralFrame = Instance.new("Frame")
GeneralFrame.Parent = MainFrame
GeneralFrame.Size = UDim2.new(1, 0, 1, -30)
GeneralFrame.Position = UDim2.new(0, 0, 0, 30)
GeneralFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local NoclipButton = Instance.new("TextButton")
NoclipButton.Parent = GeneralFrame
NoclipButton.Size = UDim2.new(0, 100, 0, 30)
NoclipButton.Position = UDim2.new(0, 10, 0, 10)
NoclipButton.Text = "Noclip"
NoclipButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
NoclipButton.MouseButton1Click:Connect(EnableNoclip)

local ESPButton = Instance.new("TextButton")
ESPButton.Parent = GeneralFrame
ESPButton.Size = UDim2.new(0, 100, 0, 30)
ESPButton.Position = UDim2.new(0, 10, 0, 50)
ESPButton.Text = "ESP"
ESPButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ESPButton.MouseButton1Click:Connect(EnableESP)

local JumpButton = Instance.new("TextButton")
JumpButton.Parent = GeneralFrame
JumpButton.Size = UDim2.new(0, 100, 0, 30)
JumpButton.Position = UDim2.new(0, 10, 0, 90)
JumpButton.Text = "Sınırsız Zıplama"
JumpButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
JumpButton.MouseButton1Click:Connect(EnableInfiniteJump)

-- Troll Tab GUI
local TrollFrame = Instance.new("Frame")
TrollFrame.Parent = MainFrame
TrollFrame.Size = UDim2.new(1, 0, 1, -30)
TrollFrame.Position = UDim2.new(0, 0, 0, 30)
TrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TrollFrame.Visible = false

local LaunchButton = Instance.new("TextButton")
LaunchButton.Parent = TrollFrame
LaunchButton.Size = UDim2.new(0, 100, 0, 30)
LaunchButton.Position = UDim2.new(0, 10, 0, 10)
LaunchButton.Text = "Uçurma"
LaunchButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
LaunchButton.MouseButton1Click:Connect(function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            LaunchPlayer(player)
        end
    end
end)

GeneralTab.MouseButton1Click:Connect(function()
    GeneralFrame.Visible = true
    TrollFrame.Visible = false
end)

TrollTab.MouseButton1Click:Connect(function()
    GeneralFrame.Visible = false
    TrollFrame.Visible = true
end)
