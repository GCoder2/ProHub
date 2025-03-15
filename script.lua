-- Murder Mystery 2 ve Arsenal Uyumlu Script by Grok
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Oyun ID'lerini kontrol et
local MM2_PLACE_ID = 142823291 -- Murder Mystery 2
local ARSENAL_PLACE_ID = 286090429 -- Arsenal
local gameId = game.PlaceId

-- Ortak Fonksiyonlar
local function CreateButton(frame, name, callback, yPos)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 260, 0, 40)
    button.Position = UDim2.new(0, 20, 0, yPos)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.BorderSizePixel = 0
    button.Font = Enum.Font.Gotham
    button.TextSize = 18
    button.Parent = frame
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 255, 127)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)
    button.MouseButton1Click:Connect(callback)
    
    return button
end

local function CreateTextBox(frame, placeholder, yPos)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 260, 0, 30)
    textBox.Position = UDim2.new(0, 20, 0, yPos)
    textBox.Text = placeholder
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    textBox.BorderSizePixel = 0
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 16
    textBox.Parent = frame
    
    return textBox
end

-- MM2 Menüsü (Değişmedi, önceki haliyle aynı)
if gameId == MM2_PLACE_ID then
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XHubMM2"
    ScreenGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "PPHub - Katil Kim"
    Title.TextColor3 = Color3.fromRGB(0, 255, 127)
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Title.BorderSizePixel = 0
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.Parent = MainFrame

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MinimizeButton.Font = Enum.Font.Gotham
    MinimizeButton.TextSize = 20
    MinimizeButton.Parent = MainFrame

    local SearchBar = Instance.new("TextBox")
    SearchBar.Size = UDim2.new(0, 200, 0, 30)
    SearchBar.Position = UDim2.new(0, 50, 0, 5)
    SearchBar.Text = "Hile Ara..."
    SearchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SearchBar.BorderSizePixel = 0
    SearchBar.Font = Enum.Font.Gotham
    SearchBar.TextSize = 16
    SearchBar.Parent = MainFrame

    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, 0, 1, -80)
    ScrollFrame.Position = UDim2.new(0, 0, 0, 80)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.ScrollBarThickness = 5
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.Parent = MainFrame

    local Buttons = {}
    local TextBoxes = {}
    local function AddButton(name, callback, yPos)
        local btn = CreateButton(ScrollFrame, name, callback, yPos)
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 50)
        table.insert(Buttons, {Button = btn, Name = name, YPos = yPos})
    end
    local function AddTextBox(placeholder, yPos)
        local tb = CreateTextBox(ScrollFrame, placeholder, yPos)
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 40)
        table.insert(TextBoxes, {TextBox = tb, YPos = yPos})
        return tb
    end

    SearchBar.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local searchText = SearchBar.Text:lower()
            local yPos = 10
            for _, btn in pairs(Buttons) do
                if searchText == "" or btn.Name:lower():find(searchText) then
                    btn.Button.Visible = true
                    btn.Button.Position = UDim2.new(0, 20, 0, yPos)
                    yPos = yPos + 50
                else
                    btn.Button.Visible = false
                end
            end
            for _, tb in pairs(TextBoxes) do
                tb.TextBox.Position = UDim2.new(0, 20, 0, yPos)
                yPos = yPos + 40
            end
            ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
        end
    end)

    local ESPEnabled = false
    local ESPTable = {}
    local CopyNameButton
    local function UpdateESP(player)
        if player == LocalPlayer or not player.Character then return end
        local character = player.Character
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
        if not humanoidRootPart then return end
        if ESPTable[player] then
            ESPTable[player].Highlight:Destroy()
            ESPTable[player].Billboard:Destroy()
            ESPTable[player] = nil
        end
        local role, roleColor
        if player.Backpack:FindFirstChild("Knife") or character:FindFirstChild("Knife") then
            role = "Murderer"
            roleColor = Color3.fromRGB(255, 0, 0)
        elseif player.Backpack:FindFirstChild("Gun") or character:FindFirstChild("Gun") then
            role = "Sheriff"
            roleColor = Color3.fromRGB(0, 0, 255)
        else
            role = "Innocent"
            roleColor = Color3.fromRGB(255, 255, 255)
        end
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP"
        highlight.Adornee = character
        highlight.FillColor = roleColor
        highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = character
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "XHubESPText"
        billboard.Adornee = humanoidRootPart
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = humanoidRootPart
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = player.Name .. "\n[" .. role .. "]"
        textLabel.TextSize = 16
        textLabel.TextColor3 = roleColor
        textLabel.TextStrokeTransparency = 0
        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        textLabel.Font = Enum.Font.GothamBold
        textLabel.Parent = billboard
        ESPTable[player] = {Highlight = highlight, Billboard = billboard, Name = player.Name}
    end

    local function ToggleESP()
        ESPEnabled = not ESPEnabled
        if ESPEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then UpdateESP(player) end
                player.CharacterAdded:Connect(function() UpdateESP(player) end)
            end
            spawn(function()
                while ESPEnabled do
                    for _, player in pairs(Players:GetPlayers()) do
                        if player.Character then UpdateESP(player) end
                    end
                    wait(5)
                end
            end)
            CopyNameButton = Instance.new("TextButton")
            CopyNameButton.Size = UDim2.new(0, 100, 0, 30)
            CopyNameButton.Position = UDim2.new(0, 350, 0, 50)
            CopyNameButton.Text = "Kopyala"
            CopyNameButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            CopyNameButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            CopyNameButton.Parent = MainFrame
            CopyNameButton.MouseButton1Click:Connect(function()
                local names = ""
                for _, esp in pairs(ESPTable) do
                    names = names .. esp.Name .. "\n"
                end
                setclipboard(names)
                StarterGui:SetCore("SendNotification", {Title = "XHub", Text = "Kullanıcı adları kopyalandı!", Duration = 3})
            end)
            warn("ESP Aktif!")
        else
            for _, esp in pairs(ESPTable) do
                esp.Highlight:Destroy()
                esp.Billboard:Destroy()
            end
            ESPTable = {}
            if CopyNameButton then CopyNameButton:Destroy() end
            warn("ESP Kapalı!")
        end
    end

    local Flying = false
    local FlySpeed = 50
    local function ToggleFly()
        Flying = not Flying
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character.HumanoidRootPart
        if Flying then
            humanoid.PlatformStand = true
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Parent = rootPart
            spawn(function()
                while Flying do
                    local cam = workspace.CurrentCamera
                    local speed = FlySpeed
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then speed = speed * 2 end
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then bv.Velocity = cam.CFrame.LookVector * speed end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then bv.Velocity = -cam.CFrame.LookVector * speed end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then bv.Velocity = -cam.CFrame.RightVector * speed end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then bv.Velocity = cam.CFrame.RightVector * speed end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then bv.Velocity = Vector3.new(0, speed, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then bv.Velocity = Vector3.new(0, -speed, 0) end
                    wait()
                end
                bv:Destroy()
                humanoid.PlatformStand = false
            end)
            warn("Uçma Aktif!")
        else
            warn("Uçma Kapalı!")
        end
    end

    local function KillAll()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.Health = 0
            end
        end
        warn("Herkes Öldürüldü!")
    end

    local KickBox
    local function KickPlayer()
        if not KickBox then return end
        local targetName = KickBox.Text
        local target = Players:FindFirstChild(targetName)
        if target and target ~= LocalPlayer then
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                target.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0, -1000, 0))
                warn(targetName .. " haritadan atıldı!")
            end
        else
            warn("Oyuncu bulunamadı!")
        end
    end

    local SpeedBox
    local function SetSpeed()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid and SpeedBox.Text ~= "" then
            local speed = tonumber(SpeedBox.Text)
            if speed then
                humanoid.WalkSpeed = speed
                warn("Hız ayarlandı: " .. speed)
            else
                warn("Geçerli bir sayı girin!")
            end
        end
    end

    local JumpBox
    local function SetJumpPower()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid and JumpBox.Text ~= "" then
            local power = tonumber(JumpBox.Text)
            if power then
                humanoid.JumpPower = power
                warn("Zıplama gücü ayarlandı: " .. power)
            else
                warn("Geçerli bir sayı girin!")
            end
        end
    end

    local function ToggleInvisible()
        local character = LocalPlayer.Character
        if not character then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = part.Transparency == 1 and 0 or 1
            end
        end
        warn("Görünmezlik " .. (character.Head.Transparency == 1 and "Aktif!" or "Kapalı!"))
    end

    local function AutoCollectCoins()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Coin_Server" and obj:IsA("BasePart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame
                wait(0.1)
            end
        end
        warn("Coinler Toplandı!")
    end

    local function GrabSheriffGun()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "GunDrop" and obj:IsA("BasePart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame
                wait(0.1)
                break
            end
        end
        warn("Şerifin silahı alındı!")
    end

    local AimbotEnabled = false
    local function ToggleAimbot()
        AimbotEnabled = not AimbotEnabled
        if AimbotEnabled then
            spawn(function()
                while AimbotEnabled do
                    local murderer
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and (player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife")) then
                            murderer = player
                            break
                        end
                    end
                    if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
                        local cam = workspace.CurrentCamera
                        cam.CFrame = CFrame.new(cam.CFrame.Position, murderer.Character.HumanoidRootPart.Position)
                    end
                    wait()
                end
            end)
            warn("Aimbot Aktif!")
        else
            warn("Aimbot Kapalı!")
        end
    end

    local TeleportGui, SourceBox, TargetBox
    local function CreateTeleportMenu()
        if TeleportGui then TeleportGui:Destroy() end
        TeleportGui = Instance.new("ScreenGui")
        TeleportGui.Name = "TeleportMenu"
        TeleportGui.Parent = game.CoreGui
        local TeleportFrame = Instance.new("Frame")
        TeleportFrame.Size = UDim2.new(0, 250, 0, 200)
        TeleportFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
        TeleportFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        TeleportFrame.BorderSizePixel = 0
        TeleportFrame.Active = true
        TeleportFrame.Draggable = true
        TeleportFrame.Parent = TeleportGui
        local TeleportTitle = Instance.new("TextLabel")
        TeleportTitle.Size = UDim2.new(1, 0, 0, 30)
        TeleportTitle.Text = "Işınlanma Menüsü"
        TeleportTitle.TextColor3 = Color3.fromRGB(0, 255, 127)
        TeleportTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TeleportTitle.BorderSizePixel = 0
        TeleportTitle.Font = Enum.Font.GothamBold
        TeleportTitle.TextSize = 18
        TeleportTitle.Parent = TeleportFrame
        SourceBox = Instance.new("TextBox")
        SourceBox.Size = UDim2.new(0, 200, 0, 30)
        SourceBox.Position = UDim2.new(0, 25, 0, 50)
        SourceBox.Text = "Işınlanacak Oyuncu"
        SourceBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        SourceBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        SourceBox.BorderSizePixel = 0
        SourceBox.Font = Enum.Font.Gotham
        SourceBox.TextSize = 16
        SourceBox.Parent = TeleportFrame
        TargetBox = Instance.new("TextBox")
        TargetBox.Size = UDim2.new(0, 200, 0, 30)
        TargetBox.Position = UDim2.new(0, 25, 0, 90)
        TargetBox.Text = "Hedef Oyuncu"
        TargetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        TargetBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TargetBox.BorderSizePixel = 0
        TargetBox.Font = Enum.Font.Gotham
        TargetBox.TextSize = 16
        TargetBox.Parent = TeleportFrame
        local TeleportButton = Instance.new("TextButton")
        TeleportButton.Size = UDim2.new(0, 200, 0, 40)
        TeleportButton.Position = UDim2.new(0, 25, 0, 130)
        TeleportButton.Text = "Işınlan!"
        TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TeleportButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TeleportButton.BorderSizePixel = 0
        TeleportButton.Font = Enum.Font.Gotham
        TeleportButton.TextSize = 18
        TeleportButton.Parent = TeleportFrame
        TeleportButton.MouseEnter:Connect(function()
            TweenService:Create(TeleportButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 255, 127)}):Play()
        end)
        TeleportButton.MouseLeave:Connect(function()
            TweenService:Create(TeleportButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        end)
        TeleportButton.MouseButton1Click:Connect(function()
            local source = Players:FindFirstChild(SourceBox.Text)
            local targetName = TargetBox.Text:lower()
            local target
            if targetName == "katil" or targetName == "murderer" then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and (player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife")) then
                        target = player
                        break
                    end
                end
            elseif targetName == "şerif" or targetName == "sheriff" then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and (player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun")) then
                        target = player
                        break
                    end
                end
            else
                target = Players:FindFirstChild(TargetBox.Text)
            end
            if source and target and source.Character and target.Character then
                local sourceRoot = source.Character:FindFirstChild("HumanoidRootPart")
                local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                if sourceRoot and targetRoot then
                    sourceRoot.CFrame = targetRoot.CFrame
                    warn(SourceBox.Text .. ", " .. (targetName == "katil" and "Katile" or targetName == "şerif" and "Şerife" or TargetBox.Text) .. "'a ışınlandı!")
                else
                    warn("Oyuncuların pozisyonu bulunamadı!")
                end
            else
                warn("Geçerli oyuncular girin!")
            end
        end)
    end

    local function PrintRolesToChat()
        local murderer, sheriff
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then
                    murderer = player.Name
                elseif player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun") then
                    sheriff = player.Name
                end
            end
        end
        if murderer then
            ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Katil: " .. murderer, "All")
        end
        if sheriff then
            ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Şerif: " .. sheriff, "All")
        end
        warn("Roller chate yazıldı!")
    end

    local NoclipEnabled = false
    local function ToggleNoclip()
        NoclipEnabled = not NoclipEnabled
        if NoclipEnabled then
            spawn(function()
                while NoclipEnabled do
                    local character = LocalPlayer.Character
                    if character then
                        for _, part in pairs(character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                    wait()
                end
                local character = LocalPlayer.Character
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end)
            warn("Noclip Aktif!")
        else
            warn("Noclip Kapalı!")
        end
    end

    local Minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = Minimized and UDim2.new(0, 300, 0, 40) or UDim2.new(0, 300, 0, 400)}):Play()
        MinimizeButton.Text = Minimized and "+" or "-"
    end)

    local yPos = 10
    AddButton("ESP Aç/Kapat", ToggleESP, yPos); yPos = yPos + 50
    AddButton("Uçma Aç/Kapat", ToggleFly, yPos); yPos = yPos + 50
    SpeedBox = AddTextBox("Hız (örn: 50)", yPos); yPos = yPos + 40
    AddButton("Hızı Ayarla", SetSpeed, yPos); yPos = yPos + 50
    JumpBox = AddTextBox("Zıplama Gücü (örn: 50)", yPos); yPos = yPos + 40
    AddButton("Zıplamayı Ayarla", SetJumpPower, yPos); yPos = yPos + 50
    AddButton("Herkesi Öldür", KillAll, yPos); yPos = yPos + 50
    AddButton("Görünmezlik", ToggleInvisible, yPos); yPos = yPos + 50
    AddButton("Coin Topla", AutoCollectCoins, yPos); yPos = yPos + 50
    AddButton("Şerifin Silahını Al", GrabSheriffGun, yPos); yPos = yPos + 50
    AddButton("Aimbot Aç/Kapat", ToggleAimbot, yPos); yPos = yPos + 50
    KickBox = AddTextBox("Oyuncu Adı Gir", yPos); yPos = yPos + 40
    AddButton("Oyuncuyu At", KickPlayer, yPos); yPos = yPos + 50
    AddButton("Işınlanma Menüsü", CreateTeleportMenu, yPos); yPos = yPos + 50
    AddButton("Rolleri Chate Yaz", PrintRolesToChat, yPos); yPos = yPos + 50
    AddButton("Noclip Aç/Kapat", ToggleNoclip, yPos); yPos = yPos + 50

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            if ESPEnabled then UpdateESP(player) end
        end)
    end)

    warn("PPHub - Murder Mystery 2 Menüsü Yüklendi!")

-- Arsenal Menüsü (Düzeltmelerle)
elseif gameId == ARSENAL_PLACE_ID then
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PPHub - Arsenal [Beta]"
    ScreenGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "XHub - Arsenal Script"
    Title.TextColor3 = Color3.fromRGB(0, 255, 127)
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Title.BorderSizePixel = 0
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.Parent = MainFrame

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MinimizeButton.Font = Enum.Font.Gotham
    MinimizeButton.TextSize = 20
    MinimizeButton.Parent = MainFrame

    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, 0, 1, -50)
    ScrollFrame.Position = UDim2.new(0, 0, 0, 50)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.ScrollBarThickness = 5
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.Parent = MainFrame

    local ESPEnabled = false
    local ESPTable = {}
    local function UpdateESP(player)
        if player == LocalPlayer or not player.Character then return end
        local character = player.Character
        local humanoidRootPart = character:WaitForChild("Head", 5) -- Arsenal'da Head'e odaklanıyoruz
        if not humanoidRootPart then return end
        if ESPTable[player] then
            ESPTable[player].Highlight:Destroy()
            ESPTable[player] = nil
        end
        local highlight = Instance.new("Highlight")
        highlight.Name = "XHubESP"
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 0) -- Sarı çerçeve
        highlight.FillTransparency = 0.7 -- Daha şeffaf bir doldurma
        highlight.OutlineTransparency = 0 -- Çerçeve tamamen görünür
        highlight.Parent = character
        ESPTable[player] = {Highlight = highlight}
    end

    local function ToggleESP()
        ESPEnabled = not ESPEnabled
        if ESPEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then UpdateESP(player) end
                player.CharacterAdded:Connect(function() UpdateESP(player) end)
            end
            spawn(function()
                while ESPEnabled do
                    for _, player in pairs(Players:GetPlayers()) do
                        if player.Character then UpdateESP(player) end
                    end
                    wait(1)
                end
            end)
            warn("ESP Aktif!")
        else
            for _, esp in pairs(ESPTable) do
                esp.Highlight:Destroy()
            end
            ESPTable = {}
            warn("ESP Kapalı!")
        end
    end

    local Flying = false
    local FlySpeed = 50
    local function ToggleFly()
        Flying = not Flying
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character.HumanoidRootPart
        if Flying then
            humanoid.PlatformStand = true
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Parent = rootPart
            spawn(function()
                while Flying do
                    local cam = workspace.CurrentCamera
                    local speed = FlySpeed
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then speed = speed * 2 end
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then bv.Velocity = cam.CFrame.LookVector * speed end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then bv.Velocity = -cam.CFrame.LookVector * speed end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then bv.Velocity = -cam.CFrame.RightVector * speed end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then bv.Velocity = cam.CFrame.RightVector * speed end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then bv.Velocity = Vector3.new(0, speed, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then bv.Velocity = Vector3.new(0, -speed, 0) end
                    wait()
                end
                bv:Destroy()
                humanoid.PlatformStand = false
            end)
            warn("Uçma Aktif!")
        else
            warn("Uçma Kapalı!")
        end
    end

    local AimbotEnabled = false
    local AimbotActive = false
    local function ToggleAimbot()
        AimbotEnabled = not AimbotEnabled
        if AimbotEnabled then
            warn("Aimbot Aktif! Sağ tıkla hedefe odaklan.")
            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton2 and AimbotEnabled then
                    AimbotActive = true
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton2 then
                    AimbotActive = false
                end
            end)
            spawn(function()
                while AimbotEnabled do
                    if AimbotActive then
                        local closestEnemy
                        local closestDistance = math.huge
                        local cam = workspace.CurrentCamera
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                                local head = player.Character.Head
                                local screenPos, onScreen = cam:WorldToViewportPoint(head.Position)
                                if onScreen then
                                    local distance = (cam.CFrame.Position - head.Position).Magnitude
                                    if distance < closestDistance then
                                        closestDistance = distance
                                        closestEnemy = player
                                    end
                                end
                            end
                        end
                        if closestEnemy and closestEnemy.Character and closestEnemy.Character:FindFirstChild("Head") then
                            cam.CFrame = CFrame.new(cam.CFrame.Position, closestEnemy.Character.Head.Position)
                        end
                    end
                    wait()
                end
            end)
        else
            AimbotActive = false
            warn("Aimbot Kapalı!")
        end
    end

    local NoclipEnabled = false
    local function ToggleNoclip()
        NoclipEnabled = not NoclipEnabled
        if NoclipEnabled then
            spawn(function()
                while NoclipEnabled do
                    local character = LocalPlayer.Character
                    if character then
                        for _, part in pairs(character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                    wait()
                end
                local character = LocalPlayer.Character
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end)
            warn("Noclip Aktif!")
        else
            warn("Noclip Kapalı!")
        end
    end

    local SpeedBox
    local function SetSpeed()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid and SpeedBox.Text ~= "" then
            local speed = tonumber(SpeedBox.Text)
            if speed then
                humanoid.WalkSpeed = speed
                warn("Hız ayarlandı: " .. speed)
            else
                warn("Geçerli bir sayı girin!")
            end
        end
    end

    local function ToggleNoRecoil()
        local weapon = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if weapon then
            for _, v in pairs(weapon:GetDescendants()) do
                if v:IsA("NumberValue") and v.Name == "Recoil" then
                    v.Value = 0
                end
            end
            warn("No Recoil Aktif!")
        else
            warn("Silah bulunamadı!")
        end
    end

    local Minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = Minimized and UDim2.new(0, 300, 0, 40) or UDim2.new(0, 300, 0, 400)}):Play()
        MinimizeButton.Text = Minimized and "+" or "-"
    end)

    local yPos = 10
    CreateButton(ScrollFrame, "ESP Aç/Kapat", ToggleESP, yPos); yPos = yPos + 50
    CreateButton(ScrollFrame, "Uçma Aç/Kapat", ToggleFly, yPos); yPos = yPos + 50
    CreateButton(ScrollFrame, "Aimbot Aç/Kapat", ToggleAimbot, yPos); yPos = yPos + 50
    SpeedBox = CreateTextBox(ScrollFrame, "Hız (örn: 50)", yPos); yPos = yPos + 40
    CreateButton(ScrollFrame, "Hızı Ayarla", SetSpeed, yPos); yPos = yPos + 50
    CreateButton(ScrollFrame, "Noclip Aç/Kapat", ToggleNoclip, yPos); yPos = yPos + 50
    CreateButton(ScrollFrame, "No Recoil", ToggleNoRecoil, yPos); yPos = yPos + 50
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            if ESPEnabled then UpdateESP(player) end
        end)
    end)

    warn("XHub - Arsenal Menüsü Yüklendi!")
else
    warn("Bu script yalnızca Murder Mystery 2 veya Arsenal'da çalışır!")
end
