local TweensService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Server = ReplicatedStorage.Remotes.Server
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")


-- aqui é pra criação dos efeitos
local FireSet = {
    ["FireballCharge"] = function(Player,Params)
        local Character = Params.Character
        local animator = Character.Humanoid.Animator
        local fireballchargeanimation = Instance.new("Animation")
        fireballchargeanimation.AnimationId = "http://www.roblox.com/asset/?id=16791330695"

        -- local firechargetrack = animator:LoadAnimation(fireballchargeanimation)
        -- firechargetrack:play()
        
        
        local HumanoidRootPart = Character.HumanoidRootPart
        local Mouse =  Player:GetMouse()
        local BodyGyro = Instance.new("BodyGyro", Character.HumanoidRootPart)


        BodyGyro.CFrame = CFrame.new(HumanoidRootPart.Position, Mouse.Hit.lookVector)
        BodyGyro.MaxTorque = Vector3.new(999999,999999,99999)
        BodyGyro.P = 20000
        BodyGyro.D = 0
        BodyGyro.Name = "Alinhamentodecâmera"

        BodyGyro.CFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + (Vector3.new(Mouse.Hit.Position.X, HumanoidRootPart.Position.Y, Mouse.Hit.Position.Z) - HumanoidRootPart.Position).unit)

        Character.Humanoid.AutoRotate = false

        local fireball = game.ReplicatedStorage.Assets.VFX.Fireballcharge:Clone()
        fireball.Parent = workspace.VFX
        fireball.Anchored = false
        fireball.Name = "FireballChargefrom"..Player.Name
        
        fireball.CanCollide = false
        
        local weld = Instance.new("Weld", fireball)
        weld.Part0 = Character:FindFirstChild("Right Arm")
        weld.Part1 = fireball

        fireball.CFrame = fireball.CFrame * CFrame.new(0,0,-5)
        task.wait(0.18)
        -- fireballchargeanimation.AnimationId = "http://www.roblox.com/asset/?id=16791284218"
        -- local firechargetrack = animator:LoadAnimation(fireballchargeanimation)
        -- firechargetrack:play()
        while HumanoidRootPart:FindFirstChild("FireballLock") do
            -- Mouse.Hit.Position
            -- firechargetrack:play()
            BodyGyro.CFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + (Vector3.new(Mouse.Hit.Position.X, HumanoidRootPart.Position.Y, Mouse.Hit.Position.Z) - HumanoidRootPart.Position).unit)
            -- Character:PivotTo()
            task.wait()
        end
        -- firechargetrack:stop()
        fireballchargeanimation.AnimationId = "http://www.roblox.com/asset/?id=16791291362"
        -- firechargetrack = animator:LoadAnimation(fireballchargeanimation)
        -- firechargetrack:play()
        Server:InvokeServer("Skill",nil,{{endpos = Mouse.Hit.Position, Cframe = HumanoidRootPart.CFrame},"FireballRelease", "FireSet"})
        Character.Humanoid.AutoRotate = true
        game.Debris:AddItem(fireball,1)
        BodyGyro:Destroy()
        -- task.delay(1,function()
        --     firechargetrack:stop()
        -- end)

    end,
    ["FireballRelease"] = function(Player,Params)
        
        local Character = Params.Character
        local ardo = Params.Once

        local Fireball = workspace.VFX:WaitForChild("Fireball"..Player.Name)
        -- local Fireball = Params.Fireball

        Fireball:FindFirstChild("trail").inner.Enabled = true
        for i,v in pairs(Fireball["fire effects"]:GetChildren()) do
            v.Enabled = true
        end
        local Connect
    end,
    ["FireBreath"] = function(Player,Params)
        local Character = Params.Character
        local Hummanoidrootpart = Character.HumanoidRootPart
        local Mouse =  Player:GetMouse()

        local FireBreath = ReplicatedStorage.Assets.VFX.FireBreath:Clone()

        FireBreath.Name = "FireBreathFrom"..Player.Name
        FireBreath.CFrame = Hummanoidrootpart.CFrame * CFrame.Angles(math.rad(90),0,math.rad(90))
        FireBreath.CFrame = FireBreath.CFrame * CFrame.new(-5,0,0)
        FireBreath.Size = Vector3.new(12, 7, 10)
        FireBreath.Anchored = true
        FireBreath.CanCollide = false
        FireBreath.CanTouch = false
        FireBreath.Parent = workspace.VFX
        for i,v in pairs(FireBreath["fire effects"]:GetChildren()) do
            task.wait()
            v:Emit(150)
        end

        game.Debris:AddItem(FireBreath,2)
    end,
    ["FireMissile"] = function()
        
    end,
    ["FireJavelinCharge"] = function(Player,Params)
        local Character = Params.Character
        local animator = Character.Humanoid.Animator
        local fireballchargeanimation = Instance.new("Animation")
        fireballchargeanimation.AnimationId = "procuraanimaçãoidiota"

        -- local firechargetrack = animator:LoadAnimation(fireballchargeanimation)
        -- firechargetrack:play()
        
        

        local HumanoidRootPart = Character.HumanoidRootPart
        local Mouse =  Player:GetMouse()
        local BodyGyro = Instance.new("BodyGyro", Character.HumanoidRootPart)


        BodyGyro.CFrame = CFrame.new(HumanoidRootPart.Position, Mouse.Hit.lookVector)
        BodyGyro.MaxTorque = Vector3.new(999999,999999,99999)
        BodyGyro.P = 20000
        BodyGyro.D = 0
        BodyGyro.Name = "Alinhamentodecâmera"

        BodyGyro.CFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + (Vector3.new(Mouse.Hit.Position.X, HumanoidRootPart.Position.Y, Mouse.Hit.Position.Z) - HumanoidRootPart.Position).unit)

        Character.Humanoid.AutoRotate = false

        local fireJavalin = game.ReplicatedStorage.Assets.VFX.FireJavalin:Clone()
        fireJavalin.Parent = workspace.VFX
        fireJavalin.Anchored = false
        fireJavalin.Name = "fireJavalinChargefrom"..Player.Name
        
        fireJavalin.CanCollide = false

        fireJavalin.CFrame = fireJavalin.CFrame * CFrame.Angles(math.rad(180),0,math.rad(180))
        
        local weld = Instance.new("Weld", fireJavalin)
        weld.Part0 = Character:FindFirstChild("Right Arm")
        weld.Part1 = fireJavalin


        -- fireballchargeanimation.AnimationId = "procuraanimaçãoidiota"
        -- local firechargetrack = animator:LoadAnimation(fireballchargeanimation)
        -- firechargetrack:play()
        while HumanoidRootPart:FindFirstChild("FireJavelinCharge") do
            -- Mouse.Hit.Position
            -- firechargetrack:play()
            BodyGyro.CFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + (Vector3.new(Mouse.Hit.Position.X, HumanoidRootPart.Position.Y, Mouse.Hit.Position.Z) - HumanoidRootPart.Position).unit)
            -- Character:PivotTo()
            task.wait()
        end
        -- firechargetrack:stop()
        fireballchargeanimation.AnimationId = "procuraanimaçãoidiota"
        -- firechargetrack = animator:LoadAnimation(fireballchargeanimation)
        -- firechargetrack:play()
        Server:InvokeServer("Skill",nil,{{endpos = Mouse.Hit.Position, Cframe = HumanoidRootPart.CFrame},"FireJavalinRelease", "FireSet"})
        Character.Humanoid.AutoRotate = true

        game.Debris:AddItem(fireJavalin,1)

        BodyGyro:Destroy()
        -- task.delay(1,function()
        --     firechargetrack:stop()
        -- end)
    end,
    ["FireJavalinRelease"] = function(Player,Params)
        
    end,
    ["Grab"] = function(Player,Params)
        local Character = Params.Character
        local HumanoidRootPart = Character.HumanoidRootPart

        local Mouse =  Player:GetMouse()
        Server:InvokeServer("Skill",nil,{{endpos = Mouse.Hit.Position, Cframe = HumanoidRootPart.CFrame},"Grab", "FireSet"})
    end
}

return FireSet