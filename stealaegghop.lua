-- ============================================
-- SERVER HOP - STEAL AN EGG
-- ============================================

local function trocarServidor()
    local jogoId = 711719359042 -- ID do Steal an Egg
    local url = "https://games.roblox.com/v1/games/" .. jogoId .. "/servers/Public?sortOrder=1&limit=100"
    
    local success, result = pcall(function()
        return game:GetService("HttpService"):GetAsync(url)
    end)
    
    if not success then
        print("❌ Erro ao buscar servidores!")
        return
    end
    
    local data = game:GetService("HttpService"):JSONDecode(result)
    local servidores = data.data
    
    local servidoresVazios = {}
    for _, server in pairs(servidores) do
        if server.playing < 5 then -- Servidores com menos de 5 pessoas
            table.insert(servidoresVazios, server)
        end
    end
    
    if #servidoresVazios == 0 then
        print("❌ Nenhum servidor vazio encontrado!")
        return
    end
    
    -- Escolhe um servidor aleatório vazio
    local server = servidoresVazios[math.random(1, #servidoresVazios)]
    local joinUrl = "https://www.roblox.com/games/" .. jogoId .. "?serverId=" .. server.id
    
    print("🔄 Trocando para servidor: " .. server.id)
    print("👥 Jogadores: " .. server.playing .. "/" .. server.maxPlayers)
    
    -- Teleporta para o servidor
    game:GetService("TeleportService"):TeleportToGameInstance(jogoId, server.id, player)
end

-- Executa o Server Hop
trocarServidor()
