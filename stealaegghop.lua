local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

TeleportService:Teleport(game.PlaceId, player)
