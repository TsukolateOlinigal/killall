-- ============================================
-- NIKKOLAS HUB (FLY = FLYGUI V3)
-- ============================================

local player = game:GetService("Players").LocalPlayer
local userInput = game:GetService("UserInputService")
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.Name = "NikkolasHub"
gui.ResetOnSpawn = false

-- ============================================
-- VARIÁVEIS DO KILL ALL
-- ============================================
local loopAtivo = false
local threadLoop = nil
local tempoLoop = 0.07
local mortoNoVoid = false
local esperandoRespawn = false

-- ============================================
-- NOTIFICAÇÃO
-- ============================================
local function notificar(texto, cor)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 400, 0, 40)
    notif.Position = UDim2.new(0.5, -200, 0.2, 0)
    notif.Text = texto
    notif.TextColor3 = cor
    notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notif.BackgroundTransparency = 0.5
    notif.BorderSizePixel = 0
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 22
    notif.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notif

    game:GetService("Debris"):AddItem(notif, 3)
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
frame.Size = UDim2.new(0, 320, 0, 370)
frame.Position = UDim2.new(0.5, -160, 0.4, -185)
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
titulo.Text = "🔥 NIKKOLAS HUB"
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
-- FUNÇÃO TESTE BYPASS
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
        notificar("🧪 TESTE BYPASS: Teleportado para " .. alvo.Name, Color3.fromRGB(0, 255, 255))
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
        if mortoNoVoid then return end
        mortoNoVoid = true
        esperandoRespawn = true
        
        print("💀 MORREU NO VOID! Aguardando respawn...")
        notificar("💀 Morreu no void! Aguardando respawn...", Color3.fromRGB(255, 255, 0))
    end
end

local function detectarRespawnETeleportar()
    if not esperandoRespawn then return end
    
    local character = player.Character
    if not character then 
        return 
    end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then 
        return 
    end

    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then 
        return 
    end

    if humanoid.Health <= 0 then
        return
    end

    local altura = rootPart.Position.Y
    local spawnDetectado = false
    
    if altura > 0 and altura < 30 then
        spawnDetectado = true
    end
    
    if humanoid.Health >= 100 and altura < 50 then
        spawnDetectado = true
    end
    
    if altura < 20 then
        spawnDetectado = true
    end
    
    if spawnDetectado then
        print("🔄 RESPAWN DETECTADO! Tentando teleportar...")
        
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
                rootPart.CFrame = charAlvo.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                notificar("✅ BYPASS SUCEDIDO! Teleportado para: " .. alvo.Name, Color3.fromRGB(0, 255, 0))
                esperandoRespawn = false
                mortoNoVoid = false
                return
            end
        else
            notificar("❌ Nenhum player disponível.", Color3.fromRGB(255, 0, 0))
            esperandoRespawn = false
            mortoNoVoid = false
            return
        end
    end
end

-- ============================================
-- DETECTOR DE RESPAWN
-- ============================================
game:GetService("RunService").Heartbeat:Connect(function()
    verificarVoid()
    if esperandoRespawn then
        detectarRespawnETeleportar()
    end
end)

-- ============================================
-- BOTÕES DA UI
-- ============================================

local function criarBotao(texto, posY, cor, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 38)
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

-- Botão KILL ALL
local btnKill = criarBotao("🌀 KILL ALL", 80, Color3.fromRGB(200, 50, 50), function()
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

-- 🚀 BOTÃO FLY (EXECUTA O FLYGUI V3)
local btnFly = criarBotao("✈️ FLY (FLYGUI V3)", 130, Color3.fromRGB(0, 150, 255), function()
    notificar("🚀 Carregando FLYGUI V3...", Color3.fromRGB(255, 255, 0))
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
end)

-- Botão TESTE BYPASS
criarBotao("🧪 TESTE BYPASS", 180, Color3.fromRGB(255, 150, 0), function()
    testarBypass()
end)

-- Botão FECHAR UI
criarBotao("🔴 FECHAR UI", 230, Color3.fromRGB(200, 50, 50), function()
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
    end
end)

print("✅ NIKKOLAS HUB CARREGADO!")
print("📌 L = Kill All")
print("📌 🚀 Botão FLY = Executa o FLYGUI V3")
print("📌 🧪 TESTE BYPASS = Teleporta pra um player aleatório")
print("📌 💀 VOID BYPASS = Morreu no void, respawnou, teleportou!")
