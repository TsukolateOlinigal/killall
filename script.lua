-- ============================================
-- KILL ALL (WITH GOJO) - NIKKOLAS HUB
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

-- ============================================
-- BOLINHA (COMEÇA OCULTA)
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

-- Deixar a bolinha REDONDA
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = bolinha

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
frame.Size = UDim2.new(0, 320, 0, 300)
frame.Position = UDim2.new(0.5, -160, 0.4, -150)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = gui

-- BARRA DE TÍTULO
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

-- TÍTULO (NIKKOLAS HUB)
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
-- FUNÇÃO DO LOOP (KILL ALL WITH GOJO)
-- ============================================
local function iniciarLoop()
    if loopAtivo then 
        statusLabel.Text = "⚠️ Loop já rodando!"
        return 
    end
    
    loopAtivo = true
    statusLabel.Text = "🔄 Kill All: ON (70ms)"
    
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
        statusLabel.Text = "⏹️ Kill All: OFF"
    end
end

-- ============================================
-- FUNÇÃO ABRIR/FECHAR UI
-- ============================================

local function fecharUI()
    frame.Visible = false
    bolinha.Visible = true
    print("❌ UI FECHADA - Bolinha apareceu!")
end

local function abrirUI()
    frame.Visible = true
    bolinha.Visible = false
    print("✅ UI ABERTA - Bolinha escondida!")
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
    return btn
end

-- Botão KILL ALL (WITH GOJO)
criarBotao("🌀 KILL ALL (WITH GOJO)", 75, Color3.fromRGB(200, 50, 50), function()
    if loopAtivo then
        pararLoop()
    else
        iniciarLoop()
    end
    -- Mudar texto do botão dinamicamente
    local btn = frame:FindFirstChild("TextButton")
    if btn then
        btn.Text = loopAtivo and "⏹️ PARAR KILL ALL" or "🌀 KILL ALL (WITH GOJO)"
        btn.BackgroundColor3 = loopAtivo and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(0, 180, 80)
    end
end)

-- Botão FECHAR UI
criarBotao("🔴 FECHAR UI", 130, Color3.fromRGB(200, 50, 50), function()
    fecharUI()
end)

-- ============================================
-- BOLINHA ABRE A UI
-- ============================================
bolinha.MouseButton1Click:Connect(function()
    abrirUI()
end)

-- ============================================
-- SISTEMA DE ARRASTE (UI E BOLINHA)
-- ============================================

-- Arraste da UI
local draggingUI = false
local dragStartUI = nil
local startPosUI = nil

local function startDragUI(input)
    draggingUI = true
    dragStartUI = input.Position
    startPosUI = frame.Position
end

local function updateDragUI(input)
    if not draggingUI then return end
    local delta = input.Position - dragStartUI
    frame.Position = UDim2.new(
        startPosUI.X.Scale, startPosUI.X.Offset + delta.X,
        startPosUI.Y.Scale, startPosUI.Y.Offset + delta.Y
    )
end

local function endDragUI()
    draggingUI = false
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or 
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        startDragUI(input)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or 
       input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDragUI(input)
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or 
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        endDragUI()
    end
end)

-- Arraste da BOLINHA
local draggingBolinha = false
local dragStartBolinha = nil
local startPosBolinha = nil

local function startDragBolinha(input)
    draggingBolinha = true
    dragStartBolinha = input.Position
    startPosBolinha = bolinha.Position
end

local function updateDragBolinha(input)
    if not draggingBolinha then return end
    local delta = input.Position - dragStartBolinha
    bolinha.Position = UDim2.new(
        startPosBolinha.X.Scale, startPosBolinha.X.Offset + delta.X,
        startPosBolinha.Y.Scale, startPosBolinha.Y.Offset + delta.Y
    )
end

local function endDragBolinha()
    draggingBolinha = false
end

bolinha.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or 
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        startDragBolinha(input)
    end
end)

bolinha.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or 
       input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDragBolinha(input)
    end
end)

bolinha.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or 
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        endDragBolinha()
    end
end)

-- ============================================
-- ATALHO L = LOOP
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

print("✅ NIKKOLAS HUB CARREGADO!")
print("📌 Clique em 'FECHAR UI' para esconder a UI e mostrar a bolinha")
print("📌 Clique na bolinha para reabrir a UI")
print("📌 Arraste a bolinha ou a UI para mover")
print("📌 Pressione L para ligar/desligar o Kill All")
