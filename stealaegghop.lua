local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local PlaceId = game.PlaceId
local servers = {}

local data = HttpService:JSONDecode(
    game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?limit=100")
)

for _, server in pairs(data.data) do
    if server.id ~= game.JobId and server.playing < server.maxPlayers then
        table.insert(servers, server.id)
    end
end

if #servers > 0 then
    local randomServer = servers[math.random(1, #servers)]
    TeleportService:TeleportToPlaceInstance(PlaceId, randomServer, Players.LocalPlayer)
end
