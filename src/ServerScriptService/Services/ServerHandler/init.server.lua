local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ServerRemote = ReplicatedStorage.Remotes.Server

local Inputs = require(script.Inputs)
local Functions = require(script.Functions)
local classes = require(ServerScriptService.Services.Modules.classes)
-- local bolot = workspace.bolot
-- bolot.Color = Color3.new(0,0,0)
-- bolot.Anchored = true
-- task.wait(5)
-- bolot.Anchored = false
-- print('DISPARADO')
-- bolot.AssemblyLinearVelocity = Vector3.new(0,100,20)
local projetil = classes
local projetil = classes.Projectile.new("Projetil",workspace)
projetil:setsize(10,10,10)
projetil:setPosition(30,0.5,100)

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAppearanceLoaded:Connect(function(Character)
        Inputs.InputTable[player] = {}
        Character:SetAttribute("Attacking" , false)
        Character:SetAttribute("Stunned" , false)
        Character:SetAttribute("Charging" , false)
    end)
end)

ServerRemote.OnServerInvoke = function(Player, Action, Input, Params)
    if Action == "InputBegan" then
        Inputs.InputTable[Player][Input] = true
    elseif Action == "EndInput" then
        Inputs.InputTable[Player][Input] = nil
    elseif Action == "Skill" then
        if Player.Character:GetAttribute("Stunned") == false and Player.Character:GetAttribute("Attacking") == false then
            local Move = Functions.FireMove(Player,Params)
            return Move
        end
    end
end