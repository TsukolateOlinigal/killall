-- ============================================
-- TELEPORTE LOOP 70ms - BOLINHA FLUTUANTE
-- ============================================

local player = game:GetService("Players").LocalPlayer
local userInput = game:GetService("UserInputService")
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.Name = "LoopTeleport"
gui.ResetOnSpawn = false

-- ============================================
-- VARIÁVEIS
-- ============================================
local loopAtivo = false
local threadLoop = nil
local tempoLoop = 0.07
local uiAberta = true -- UI começa aberta

-- ============================================
-- BOLINHA FLUTUANTE (BOTÃO REDONDO)
-- ============================================

local bolinha = Instance.new("ImageButton")
bolinha.Size = UDim2.new(0, 55, 0, 55)
bolinha.Position = UDim2.new(0.9, -27, 0.1, 10) -- Canto superior direito
bolinha.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
bolinha.BackgroundTransparency = 0.1
bolinha.BorderSizePixel = 0
bolinha.Image = "rbxassetid://" -- Deixa vazio pra usar a cor
bolinha.Parent = gui

-- Deixar redondo (arredondamento)
local function arredondar(obj)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = obj
end
arredondar(bolinha)

-- Texto da bolinha
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
frame.Size = UDim2.new(0, 320, 0, 320)
frame.Position = UDim2.new(0.5, -160, 0.4, -160)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = gui

-- Arredondar a UI
arredondar(frame)

-- BARRA DE TÍTULO (ÁREA DE ARRASTE)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame
arredondar(titleBar)

-- TÍTULO
local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(0.8, 0, 1, 0)
titulo.Position = UDim2.new(0, 10, 0, 0)
titulo.Text = "🌀 TELEPORTE 70ms"
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.BackgroundTransparency = 1
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 16
titulo.TextXAlignment = Enum.TextXAlignment.Left
titulo.Parent = titleBar

-- STATUS
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 42)
statusLabel.Text = "✅ Pronto! (70ms)"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 13
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

-- ============================================
-- FUNÇÃO DO LOOP
-- ============================================
local function iniciarLoop()
    if loopAtivo then 
        statusLabel.Text = "⚠️ Loop já rodando!"
        return 
    end
    
    loopAtivo = true
    statusLabel.Text = "🔄 Loop: ON (70ms)"
    
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
                    statusLabel.Text = "🎯 " .. alvo.Name .. " (" .. index .. "/" .. #playersList .. ") 70ms"
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
        statusLabel.Text = "⏹️ Loop: OFF"
    end
end

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
    btn.TextSize = 15
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    arredondar(btn)
    return btn
end

criarBotao("▶️ INICIAR LOOP (70ms)", 75, Color3.fromRGB(0, 180, 80), iniciarLoop)
criarBotao("⏹️ PARAR LOOP", 125, Color3.fromRGB(200, 50, 50), pararLoop)
criarBotao("❌ FECHAR UI", 175, Color3.fromRGB(80, 80, 80), function()
    pararLoop()
    gui:Destroy()
end)

-- ============================================
-- FUNÇÃO ABRIR/FECHAR UI PELA BOLINHA
-- ============================================
bolinha.MouseButton1Click:Connect(function()
    uiAberta = not uiAberta
    frame.Visible = uiAberta
    bolinha.BackgroundColor3 = uiAberta and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 200, 0)
    bolinhaText.Text = uiAberta and "🌀" or "🌀"
    print(uiAberta and "UI ABERTA" or "UI FECHADA")
end)

-- ============================================
-- SISTEMA DE ARRASTE (DRAG)
-- ============================================

local dragging = false
local dragStart = nil
local startPos = nil

local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = frame.Position
end

local function updateDrag(input)
    if not dragging then return end
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
    if input.UserInputType == Enum.UserInputType.Touch or 
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        startDrag(input)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or 
       input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDrag(input)
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or 
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        endDrag()
    end
end)

-- ============================================
-- ATALHO (L = Ligar/Desligar Loop)
-- ============================================
userInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.L then
        if loopAtivo then
            pararLoop()
        else
            iniciarLoop()
        end
    end
end)

print("✅ SCRIPT CARREGADO! BOLINHA FLUTUANTE!")
print("📌 Clique na bolinha vermelha para abrir/fechar a UI")
print("📌 Pressione L para ligar/desligar o loop")
print("📌 Arraste a barra azul para mover a UI")
