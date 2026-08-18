-- ============================================
-- SCRIPT DELTA - TELEPORTE LOOP + FLY + UI
-- ============================================

local player = game:GetService("Players").LocalPlayer
local userInput = game:GetService("UserInputService")
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

-- ============================================
-- VARIÁVEIS
-- ============================================
local loopAtivo = false
local intervalo = 1
local threadLoop = nil
local voando = false
local corpoVoo = nil
local uiBloqueada = false
local uiVisivel = true
local dragging = false
local dragStart = nil
local startPos = nil

-- ============================================
-- FLY
-- ============================================
local function ativarFly()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    if voando then
        voando = false
        if corpoVoo then
            corpoVoo:Destroy()
            corpoVoo = nil
        end
        humanoid.PlatformStand = false
        statusLabel.Text = "✈️ Fly: OFF"
        return
    end
    
    voando = true
    humanoid.PlatformStand = true
    statusLabel.Text = "✈️ Fly: ON"
    
    corpoVoo = Instance.new("BodyVelocity")
    corpoVoo.MaxForce = Vector3.new(4000, 4000, 4000)
    corpoVoo.Velocity = Vector3.new(0, 0, 0)
    corpoVoo.Parent = rootPart
    
    local flyConnection
    flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not voando or not character or not rootPart or not corpoVoo then
            if flyConnection then flyConnection:Disconnect() end
            return
        end
        
        local moveDirection = Vector3.new(0, 0, 0)
        local speed = 50
        
        if userInput:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + Vector3.new(0, 0, -speed) end
        if userInput:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection + Vector3.new(0, 0, speed) end
        if userInput:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection + Vector3.new(-speed, 0, 0) end
        if userInput:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + Vector3.new(speed, 0, 0) end
        if userInput:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, speed, 0) end
        if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection + Vector3.new(0, -speed, 0) end
        
        if moveDirection ~= Vector3.new(0, 0, 0) then
            local camera = workspace.CurrentCamera
            if camera then
                local camCF = camera.CFrame
                local forward = camCF.LookVector
                local right = camCF.RightVector
                local up = camCF.UpVector
                
                local moveCF = CFrame.new(Vector3.new(0, 0, 0), 
                    forward * moveDirection.Z + right * moveDirection.X + up * moveDirection.Y)
                
                corpoVoo.Velocity = moveCF.Position * 0.5
            end
        else
            corpoVoo.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

-- ============================================
-- LOOP DE TELEPORTE (A PARTE MAIS IMPORTANTE)
-- ============================================
local function iniciarLoop()
    if loopAtivo then 
        statusLabel.Text = "⚠️ Loop já rodando!"
        return 
    end
    
    loopAtivo = true
    statusLabel.Text = "🔄 Loop: ON"
    
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
                index = 1 -- LOOP INFINITO
            end
            
            local alvo = playersList[index]
            local character = player.Character
            
            if character and character:FindFirstChild("HumanoidRootPart") and alvo then
                local charAlvo = alvo.Character
                if charAlvo and charAlvo:FindFirstChild("HumanoidRootPart") then
                    -- TELEPORTE AQUI!
                    character.HumanoidRootPart.CFrame = charAlvo.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    statusLabel.Text = "🎯 " .. alvo.Name .. " (" .. index .. "/" .. #playersList .. ")"
                end
            end
            
            index = index + 1
            wait(intervalo) -- Espera 1 segundo (ou o valor definido)
        end
    end)
    
    coroutine.resume(threadLoop)
end

local function pararLoop()
    if loopAtivo then
        loopAtivo = false
        threadLoop = nil
        statusLabel.Text = "🔄 Loop: OFF"
    end
end

-- ============================================
-- UI PRINCIPAL
-- ============================================

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 480)
frame.Position = UDim2.new(0.5, -175, 0.5, -240)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.Parent = gui

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(0.6, 0, 1, 0)
titulo.Position = UDim2.new(0, 10, 0, 0)
titulo.Text = "🌀 DELTA LOOP"
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.BackgroundTransparency = 1
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 18
titulo.TextXAlignment = Enum.TextXAlignment.Left
titulo.Parent = titleBar

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 45)
statusLabel.Text = "✅ Pronto!"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 13
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

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

-- Botão Fly
local btnFly = criarBotao("✈️ FLY (WASD + Espaço/Shift)", 80, Color3.fromRGB(0, 150, 255), function()
    ativarFly()
    btnFly.BackgroundColor3 = voando and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(0, 150, 255)
    btnFly.Text = voando and "✈️ FLY: ON" or "✈️ FLY (WASD + Espaço/Shift)"
end)

-- Botão Loop (PRINCIPAL)
local btnLoop = criarBotao("🔄 TELEPORTE LOOP (1s)", 130, Color3.fromRGB(0, 180, 80), function()
    if loopAtivo then
        pararLoop()
        btnLoop.Text = "🔄 TELEPORTE LOOP (1s)"
        btnLoop.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
    else
        iniciarLoop()
        btnLoop.Text = "⏹️ PARAR LOOP"
        btnLoop.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

-- Botão Velocidade +
criarBotao("⚡ + RÁPIDO (-0.2s)", 178, Color3.fromRGB(255, 150, 0), function()
    if intervalo > 0.3 then
        intervalo = intervalo - 0.2
        intervalo = math.round(intervalo * 10) / 10
        statusLabel.Text = "⏱️ Intervalo: " .. intervalo .. "s"
    end
end)

-- Botão Velocidade -
criarBotao("🐢 + DEVAGAR (+0.2s)", 224, Color3.fromRGB(0, 150, 255), function()
    if intervalo < 5.0 then
        intervalo = intervalo + 0.2
        intervalo = math.round(intervalo * 10) / 10
        statusLabel.Text = "⏱️ Intervalo: " .. intervalo .. "s"
    end
end)

-- Botão Cadeado
local btnCadeado = criarBotao("🔓 DESBLOQUEADO", 270, Color3.fromRGB(100, 100, 100), function()
    uiBloqueada = not uiBloqueada
    btnCadeado.Text = uiBloqueada and "🔒 BLOQUEADO" or "🔓 DESBLOQUEADO"
    btnCadeado.BackgroundColor3 = uiBloqueada and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(100, 100, 100)
    statusLabel.Text = uiBloqueada and "🔒 UI Bloqueada" or "🔓 UI Desbloqueada"
end)

-- Botão Ocultar
local btnOcultar = criarBotao("👁️ OCULTAR UI", 316, Color3.fromRGB(150, 0, 200), function()
    uiVisivel = not uiVisivel
    btnOcultar.Text = uiVisivel and "👁️ OCULTAR UI" or "👁️ MOSTRAR UI"
    
    for _, child in pairs(frame:GetChildren()) do
        if child ~= btnOcultar and child ~= titleBar and child ~= titulo then
            child.Visible = uiVisivel
        end
    end
    titulo.Visible = true
    titleBar.Visible = true
    
    if uiVisivel then
        frame.Size = UDim2.new(0, 350, 0, 480)
        statusLabel.Visible = true
    else
        frame.Size = UDim2.new(0, 350, 0, 80)
        statusLabel.Visible = false
    end
end)

-- Botão Fechar
criarBotao("❌ FECHAR", 362, Color3.fromRGB(80, 80, 80), function()
    pararLoop()
    if voando then ativarFly() end
    gui:Destroy()
end)

-- ============================================
-- SISTEMA DE ARRASTE
-- ============================================

local function startDrag(input)
    if uiBloqueada then return end
    dragging = true
    dragStart = input.Position
    startPos = frame.Position
end

local function updateDrag(input)
    if not dragging or uiBloqueada then return end
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

local function endDrag()
    dragging = false
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        startDrag(input)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDrag(input)
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        endDrag()
    end
end)

-- ============================================
-- ATALHOS
-- ============================================
userInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.L then
        if loopAtivo then
            pararLoop()
            btnLoop.Text = "🔄 TELEPORTE LOOP (1s)"
            btnLoop.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
        else
            iniciarLoop()
            btnLoop.Text = "⏹️ PARAR LOOP"
            btnLoop.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
    elseif input.KeyCode == Enum.KeyCode.F then
        ativarFly()
        btnFly.BackgroundColor3 = voando and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(0, 150, 255)
        btnFly.Text = voando and "✈️ FLY: ON" or "✈️ FLY (WASD + Espaço/Shift)"
    elseif input.KeyCode == Enum.KeyCode.H then
        btnOcultar:Click()
    end
end)

print("✅ SCRIPT CARREGADO NO DELTA!")
print("📌 Atalhos: L = Loop | F = Fly | H = Ocultar")
print("📌 Arraste a barra azul para mover a UI")
