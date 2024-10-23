if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Player = game.Players.LocalPlayer
local Character = script.Parent

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Server = ReplicatedStorage.Remotes.Server
local EffectEvent = ReplicatedStorage.Remotes.Effects

local Cooldown = require(ReplicatedStorage.Replicated.Cooldown)
local Skillsets = require(ReplicatedStorage.Replicated.Skillsets)
local VFX = require(script:WaitForChild("FX"))

local Mouse =  Player:GetMouse()

local AvaibleSets = {
    "Movement",
    "Combat",
    "FireSet"
}

local InputBegan = coroutine.create(function()
    UserInputService.InputBegan:Connect(function(UserInput, gpe)
        if gpe then return end
        local Skill , Set , Info , Input = nil, nil, nil, nil
        if UserInput.UserInputType == Enum.UserInputType.MouseButton1 then
            Input = "M1"
            if Cooldown:CheckCooldown("M1", Player) == false and Character:GetAttribute("Stunned") == false and Character:GetAttribute("Attacking") == false then
                Info = {Data = "Fireballs"}
            end
        -- elseif UserInput.UserInputType == Enum.UserInputType.KeyCode.F then
        --     Input = "F"
        --     if Cooldown:CheckCooldown("F", Player) == false and Character:GetAttribute("Stunned") == false and Character:GetAttribute("Attacking") == false then
        --         Info = {Data = "Fireballs"}
        --     end
        elseif UserInput.KeyCode == Enum.KeyCode.G then
            Input = UserInput.KeyCode.Name
            Info = {Data = {endpos = Mouse.Hit.Position}}
        elseif UserInput.KeyCode == Enum.KeyCode.C then
            Input = UserInput.KeyCode.Name
            Info = {Data = {endpos = Mouse.Hit.Position}}
        else
            Input = UserInput.KeyCode.Name
            Info = {Data = "Default",}
        end
        -- puxado diretamente de: ReplicatedStorage.Replicated.Skillsets
        for i,v in pairs(AvaibleSets) do
            if Skillsets[v] then
                if Skillsets[v][Input] then
                    Skill = Skillsets[v][Input]
                    Set = v
                end
            end
        end
        if Skill then
            if Cooldown:CheckCooldown(Skill.Name, Player) == false and Character:GetAttribute("Stunned") == false and Character:GetAttribute("Attacking") == false then
                
                Server:InvokeServer("InputBegan", Input)
                Character:SetAttribute("Attacking", true)
                local Fire = Server:InvokeServer("Skill", nil , {Info,Skill["Name"],Set}) -- see this
                local speed = Server:InvokeServer("Getspeed")
                if Info then
                    Cooldown:AddCooldown(Skill.Name, Skill.Cooldown, Player)
                end
                Character:SetAttribute("Attacking",false)
            else
                print("TA EM COOLDOWN PORRA")
            end
        end
    end)
end)

local InputEnded = coroutine.create(function()
    UserInputService.InputEnded:Connect(function(Input,gpe)
        if Character:GetAttribute("Attacking") == true then
            Server:InvokeServer("EndInput", Input.KeyCode.Name)
        end
        
    end)
end)

coroutine.resume(InputBegan)
coroutine.resume(InputEnded)

EffectEvent.OnClientEvent:Connect(function(...)
    local FXName , Params = unpack(...)
    VFX[FXName](Player , Params)
end)