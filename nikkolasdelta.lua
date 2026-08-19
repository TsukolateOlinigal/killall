-- ============================================
-- NIKKOLAS HUB - DELTA EXECUTOR (FLY CORRIGIDO)
-- ============================================

local player = game:GetService("Players").LocalPlayer
local userInput = game:GetService("UserInputService")
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.Name = "NikkolasHub"
gui.ResetOnSpawn = false

-- ============================================
-- VARIÁVEIS
-- ============================================
local loopAtivo = false
local threadLoop = nil
local tempoLoop = 0.07
local voando = false
local flyConn = nil
local bodyVelocity = nil
local alturaAtual = 10

-- ============================================
-- NOTIFICAÇÃO
-- ============================================
local function notificar(texto, cor)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 350, 0, 40)
    notif.Position = UDim2.new(0.5, -175, 0.2, 0)
    notif.Text = texto
    notif.TextColor3 = cor
    notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notif.BackgroundTransparency = 0.5
    notif.BorderSizePixel = 0
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 20
    notif.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notif
    
    game:GetService("Debris"):AddItem(notif, 2)
end

-- ============================================
-- BOLINHA
-- ============================================
local bolinha = Instance.new("ImageButton")
bolinha.Size = UDim2.new(0, 55, 0, 55)
bolinha.Position = UDim2.new(0.9, -27, 0.1, 10)
bolinha.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
bolinha.BackgroundTransparency = 0.1
bolinha.BorderSizePixel = 0
bolinha.Image = "rbxassetid://"
bolinha.Visible = false
bolinha.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = bolinha

local bolinhaText = Instance.new("TextLabel")
bolinhaText.Size = UDim2.new(1, 0, 1, 0)
bolinhaText.Position = UDim2.new(0, 0, 0, 0)
bolinhaText.Text = "🌀"
bolinhaText.TextColor3 = Color3.fromRGB(255, 255, 255)
bolinhaText.BackgroundTransparency = 1
bolinhaText.Font = Enum.Font.GothamBold
bolinhaText.TextSize = 28
bolinhaText.Parent = bolinha

-- ============================================
-- UI PRINCIPAL
-- ============================================

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 350)
frame.Position = UDim2.new(0.5, -160, 0.4, -175)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = gui

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(0.8, 0, 1, 0)
titulo.Position = UDim2.new(0, 10, 0, 0)
titulo.Text = "🔥 NIKKOLAS HUB (DELTA)"
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.BackgroundTransparency = 1
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 16
titulo.TextXAlignment = Enum.TextXAlignment.Left
titulo.Parent = titleBar

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 42)
statusLabel.Text = "✅ Pronto!"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 13
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

-- ============================================
-- FUNÇÃO FLY (ADAPTADA PARA DELTA)
-- ============================================
local function ativarFly()
    local character = player.Character
    if not character then
        notificar("❌ Personagem não encontrado!", Color3.fromRGB(255, 0, 0))
        return
    end

    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then
        notificar("❌ Erro ao ativar fly!", Color3.fromRGB(255, 0, 0))
        return
    end

    if voando then
        voando = false
        if flyConn then
            flyConn:Disconnect()
            flyConn = nil
        end
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        humanoid.PlatformStand = false
        statusLabel.Text = "✈️ Fly: OFF"
        notificar("✈️ Fly DESATIVADO", Color3.fromRGB(255, 255, 255))
        return
    end

    voando = true
    humanoid.PlatformStand = true
    statusLabel.Text = "✈️ Fly: ON"
    notificar("✈️ Fly ATIVADO (DELTA)", Color3.fromRGB(0, 255, 255))
    
    alturaAtual = rootPart.Position.Y

    -- BodyVelocity (mais compatível com Delta)
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart

    flyConn = game:GetService("RunService").Heartbeat:Connect(function()
        if not voando or not character or not rootPart or not bodyVelocity then
            return
        end

        local moveDirection = Vector3.new(0, 0, 0)
        local speed = 50

        if userInput:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + Vector3.new(0, 0, -speed) end
        if userInput:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection + Vector3.new(0, 0, speed) end
        if userInput:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection + Vector3.new(-speed, 0, 0) end
        if userInput:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + Vector3.new(speed, 0, 0) end
        if userInput:IsKeyDown(Enum.KeyCode.Space) then 
            alturaAtual = alturaAtual + 2
        end
        if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then 
            alturaAtual = alturaAtual - 2
        end

        if moveDirection ~= Vector3.new(0, 0, 0) then
            local camera = workspace.CurrentCamera
            if camera then
                local camCF = camera.CFrame
                local forward = camCF.LookVector
                local right = camCF.RightVector
                local up = camCF.UpVector

                local moveCF = CFrame.new(Vector3.new(0, 0, 0), 
                    forward * moveDirection.Z + right * moveDirection.X + up * moveDirection.Y)

                bodyVelocity.Velocity = moveCF.Position * 0.5
            end
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

-- ============================================
-- FUNÇÃO KILL ALL
-- ============================================
local function iniciarLoop()
    if loopAtivo then
        statusLabel.Text = "⚠️ Loop já rodando!"
        notificar("⚠️ Loop já rodando!", Color3.fromRGB(255, 255, 0))
        return
    end

    loopAtivo = true
    statusLabel.Text = "🌀 Kill All: ON"
    notificar("🌀 Kill All ATIVADO!", Color3.fromRGB(0, 255, 0))

    threadLoop = coroutine.create(function()
        local index = 1

        while loopAtivo do
            local playersList = {}
            for _, p in pairs(game:GetService("Players"):GetPlayers()) do
                if p ~= player then
                    local char = p.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        table.insert(playersList, p)
                    end
                end
            end

            if #playersList == 0 then
                statusLabel.Text = "⏳ Aguardando players..."
                wait(0.5)
                continue
            end

            if index > #playersList then
                index = 1
            end

            local alvo = playersList[index]
            local character = player.Character

            if character and character:FindFirstChild("HumanoidRootPart") and alvo then
                local charAlvo = alvo.Character
                if charAlvo and charAlvo:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = charAlvo.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    statusLabel.Text = "🎯 " .. alvo.Name .. " (" .. index .. "/" .. #playersList .. ")"
                end
            end

            index = index + 1
            wait(tempoLoop)
        end
    end)

    coroutine.resume(threadLoop)
end

local function pararLoop()
    if loopAtivo then
        loopAtivo = false
        threadLoop = nil
        statusLabel.Text = "⏹️ Kill All: OFF"
        notificar("⏹️ Kill All DESATIVADO!", Color3.fromRGB(255, 0, 0))
    end
end

-- ============================================
-- FUNÇÃO BYPASS TESTE
-- ============================================
local function testarBypass()
    local character = player.Character
    if not character then
        notificar("❌ Personagem não encontrado!", Color3.fromRGB(255, 0, 0))
        return
    end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        notificar("❌ RootPart não encontrado!", Color3.fromRGB(255, 0, 0))
        return
    end

    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        notificar("❌ Personagem morto!", Color3.fromRGB(255, 0, 0))
        return
    end

    local playersList = {}
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player then
            local char = p.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                table.insert(playersList, p)
            end
        end
    end

    if #playersList == 0 then
        notificar("❌ Nenhum player disponível!", Color3.fromRGB(255, 0, 0))
        return
    end

    local alvo = playersList[math.random(1, #playersList)]
    local charAlvo = alvo.Character
    if charAlvo and charAlvo:FindFirstChild("HumanoidRootPart") then
        rootPart.CFrame = charAlvo.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        notificar("🧪 BYPASS: Teleportado para " .. alvo.Name, Color3.fromRGB(0, 255, 255))
        statusLabel.Text = "🧪 Teste: " .. alvo.Name
    end
end

-- ============================================
-- FUNÇÃO VOID BYPASS
-- ============================================
local function verificarVoid()
    local character = player.Character
    if not character then return end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end

    if rootPart.Position.Y < -30 and humanoid.Health <= 0 then
        print("💀 MORREU NO VOID! Teleportando...")
        
        local playersList = {}
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p ~= player then
                local char = p.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    table.insert(playersList, p)
                end
            end
        end

        if #playersList > 0 then
            local alvo = playersList[math.random(1, #playersList)]
            local charAlvo = alvo.Character
            if charAlvo and charAlvo:FindFirstChild("HumanoidRootPart") then
                humanoid.Health = 100
                rootPart.CFrame = charAlvo.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                notificar("✅ BYPASS SUCEDIDO! Teleportado para: " .. alvo.Name, Color3.fromRGB(0, 255, 0))
            end
        else
            humanoid.Health = 100
            rootPart.CFrame = CFrame.new(0, 50, 0)
            notificar("❌ BYPASS NÃO SUCEDIDO! Spawn point.", Color3.fromRGB(255, 0, 0))
        end
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    verificarVoid()
end)

-- ============================================
-- BOTÕES
-- ============================================

local function criarBotao(texto, posY, cor, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 36)
    btn.Position = UDim2.new(0.075, 0, 0, posY)
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = cor
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local btnKill = criarBotao("🌀 KILL ALL", 75, Color3.fromRGB(200, 50, 50), function()
    if loopAtivo then
        pararLoop()
        btnKill.Text = "🌀 KILL ALL"
        btnKill.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    else
        iniciarLoop()
        btnKill.Text = "⏹️ PARAR"
        btnKill.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
    end
end)

local btnFly = criarBotao("✈️ FLY (DELTA)", 120, Color3.fromRGB(0, 150, 255), function()
    ativarFly()
    btnFly.Text = voando and "✈️ FLY: ON" or "✈️ FLY (DELTA)"
    btnFly.BackgroundColor3 = voando and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(0, 150, 255)
end)

criarBotao("🧪 TESTE BYPASS", 165, Color3.fromRGB(255, 150, 0), function()
    testarBypass()
end)

criarBotao("🔴 FECHAR UI", 210, Color3.fromRGB(200, 50, 50), function()
    frame.Visible = false
    bolinha.Visible = true
end)

bolinha.MouseButton1Click:Connect(function()
    frame.Visible = true
    bolinha.Visible = false
end)

-- ============================================
-- ARRASTE
-- ============================================

local draggingUI = false
local dragStartUI = nil
local startPosUI = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or
        input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingUI = true
        dragStartUI = input.Position
        startPosUI = frame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if not draggingUI then return end
    local delta = input.Position - dragStartUI
    frame.Position = UDim2.new(
        startPosUI.X.Scale, startPosUI.X.Offset + delta.X,
        startPosUI.Y.Scale, startPosUI.Y.Offset + delta.Y
    )
end)

titleBar.InputEnded:Connect(function()
    draggingUI = false
end)

local draggingBolinha = false
local dragStartBolinha = nil
local startPosBolinha = nil

bolinha.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or
        input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingBolinha = true
        dragStartBolinha = input.Position
        startPosBolinha = bolinha.Position
    end
end)

bolinha.InputChanged:Connect(function(input)
    if not draggingBolinha then return end
    local delta = input.Position - dragStartBolinha
    bolinha.Position = UDim2.new(
        startPosBolinha.X.Scale, startPosBolinha.X.Offset + delta.X,
        startPosBolinha.Y.Scale, startPosBolinha.Y.Offset + delta.Y
    )
end)

bolinha.InputEnded:Connect(function()
    draggingBolinha = false
end)

-- ============================================
-- ATALHOS
-- ============================================
userInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.L then
        if loopAtivo then
            pararLoop()
            btnKill.Text = "🌀 KILL ALL"
            btnKill.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        else
            iniciarLoop()
            btnKill.Text = "⏹️ PARAR"
            btnKill.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
        end
    elseif input.KeyCode == Enum.KeyCode.F then
        ativarFly()
        btnFly.Text = voando and "✈️ FLY: ON" or "✈️ FLY (DELTA)"
        btnFly.BackgroundColor3 = voando and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(0, 150, 255)
    end
end)

print("✅ NIKKOLAS HUB CARREGADO (DELTA)!")
print("📌 L = Kill All | F = Fly")
