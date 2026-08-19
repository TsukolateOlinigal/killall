-- ============================================
-- TELEPORTE LOOP 1s - DELTA/XENO
-- ============================================

local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.Name = "LoopTeleport"

-- UI
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 300)
frame.Position = UDim2.new(0.5, -160, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = gui

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 40)
titulo.Position = UDim2.new(0, 0, 0, 0)
titulo.Text = "🌀 TELEPORTE LOOP 1s"
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 18
titulo.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0, 45)
statusLabel.Text = "✅ Pronto!"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 13
statusLabel.Parent = frame

-- VARIÁVEIS
local loopAtivo = false
local threadLoop = nil

-- FUNÇÃO DO LOOP
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
            -- Pegar todos os players (exceto você)
            local playersList = {}
            for _, p in pairs(game:GetService("Players"):GetPlayers()) do
                if p ~= player then
                    local char = p.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        table.insert(playersList, p)
                    end
                end
            end
            
            -- Se não tiver players, espera
            if #playersList == 0 then
                statusLabel.Text = "⏳ Aguardando players..."
                wait(0.5)
                continue
            end
            
            -- Se passou do último, volta pro primeiro (LOOP)
            if index > #playersList then
                index = 1
            end
            
            -- Teleportar para o player atual
            local alvo = playersList[index]
            local character = player.Character
            
            if character and character:FindFirstChild("HumanoidRootPart") and alvo then
                local charAlvo = alvo.Character
                if charAlvo and charAlvo:FindFirstChild("HumanoidRootPart") then
                    -- TELEPORTE AQUI!
                    character.HumanoidRootPart.CFrame = charAlvo.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    statusLabel.Text = "🎯 " .. alvo.Name .. " (" .. index .. "/" .. #playersList .. ")"
                    print("📡 Teleportado para: " .. alvo.Name)
                end
            end
            
            -- Próximo player
            index = index + 1
            
            -- ESPERA 1 SEGUNDO (a parte mais importante!)
            wait(1)
        end
    end)
    
    coroutine.resume(threadLoop)
end

local function pararLoop()
    if loopAtivo then
        loopAtivo = false
        threadLoop = nil
        statusLabel.Text = "⏹️ Loop: OFF"
        print("⏹️ Loop parado!")
    end
end

-- BOTÕES
local function criarBotao(texto, posY, cor, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 40)
    btn.Position = UDim2.new(0.075, 0, 0, posY)
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = cor
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Botão INICIAR
criarBotao("▶️ INICIAR LOOP (1s)", 85, Color3.fromRGB(0, 180, 80), function()
    iniciarLoop()
end)

-- Botão PARAR
criarBotao("⏹️ PARAR LOOP", 140, Color3.fromRGB(200, 50, 50), function()
    pararLoop()
end)

-- Botão FECHAR
criarBotao("❌ FECHAR UI", 195, Color3.fromRGB(80, 80, 80), function()
    pararLoop()
    gui:Destroy()
end)

-- ATALHO (L = Ligar/Desligar)
userInput = game:GetService("UserInputService")
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

print("✅ SCRIPT CARREGADO!")
print("📌 Pressione L para ligar/desligar o loop")
