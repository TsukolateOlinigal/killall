-- ============================================
-- TENTATIVA FINAL DE INVISIBILIDADE
-- ============================================

local player = game:GetService("Players").LocalPlayer

-- MÉTODO: TROCAR DE PERSONAGEM (Gojo)
local function trocarParaGojo()
    local args = {
        [1] = "Honored One"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SelectCharacter"):FireServer(unpack(args))
end

-- MÉTODO: USAR HABILIDADE DO GOJO (TELEPORTE)
local function usarTeleporteGojo()
    local args = {
        [1] = "R" -- Habilidade R do Gojo
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UseAbility"):FireServer(unpack(args))
end

-- BOTÃO DE TESTE
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0.5, -100, 0.5, -25)
btn.Text = "TESTE GOJO"
btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 18
btn.Parent = gui

btn.MouseButton1Click:Connect(function()
    trocarParaGojo()
    wait(0.5)
    usarTeleporteGojo()
    print("🧪 TESTE GOJO EXECUTADO!")
end)

print("✅ TESTE GOJO CARREGADO!")
