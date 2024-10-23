local TweensService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Server = ReplicatedStorage.Remotes.Server
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local activated = {}

local StatsEffects = {
    ["BurningEffects"] = function(Player,Params)
        local Character = Params.Character
        if activated[Character] == true then return end
        for i,v in pairs(Character:GetChildren()) do
            if v:IsA("Part") and v ~= "HumanoidRootPart" then
                activated[Character] = true
                local fogo = ReplicatedStorage.Assets.VFX.fogo:Clone()
                local orba = ReplicatedStorage.Assets.VFX.orba:Clone()
                fogo.Parent = v
                orba.Parent = v
                fogo.Enabled = true
                orba.Enabled = true
                task.delay(Params.Time, function()
                    fogo.Enabled = false
                    orba.Enabled = false
                    task.wait(1)
                    fogo:Destroy()
                    orba:Destroy()
                    activated[Character] = nil
                end)
                
                
            end
            
        end
        
    end
}

return StatsEffects