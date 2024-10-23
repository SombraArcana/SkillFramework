local TweenService = game:GetService("TweenService")


local Functions = {
    ["FireMove"] = function(Player, ...)
        local Data , MoveName , Moveset = unpack(...)
        if not Player.Character:GetAttribute("Stunned") then
            local Skill
            local Sucess, Fail = pcall(function()
                print("Moveset: ",Moveset,", Movename: ",MoveName)
                Skill = require(script.Parent.Moves[Moveset])[MoveName](Player,Data)
            end)
            if not Sucess then warn(Fail) end
            return Skill
        end
    end,
    ["FireClientWithDistance"] = function(Args, ...)
        for i,p in pairs(game.Players:GetChildren()) do
            local CharModel = p.Character
            if (Args.Origin - CharModel.HumanoidRootPart.Position).Magnitude <= Args.Distance then
                Args.Remote:FireClient(game.Players:GetPlayerFromCharacter(CharModel), ...)
            end
        end
    end,

    ["CreateCrater"] = function(Rot, Radius, Result, CraterPieces)
        print("CREATERA REQUISITADA")
        for i = 0 , CraterPieces - 1 do
            local Part = Instance.new("Part")
            Part.Parent = workspace.VFX
            Part.Size = Vector3.new((math.random(1,3) * 3.14 * Radius)/CraterPieces, math.random(Radius * 0.1 * 10, Radius* 0.3 * 10)/10, math.random(Radius * 0.1 * 10, Radius* 0.3 * 10)/10)
            Part.Anchored = true
            Part.CFrame = CFrame.new(Result.Position, Result.Position + Result.Normal)
            Part.CFrame = Part.CFrame * CFrame.Angles(math.rad(90), math.rad((i-1)* 360/CraterPieces), 0 ) * CFrame.new(0,0,-Radius) * CFrame.Angles(math.rad(Rot),0,0)
            Part.CanQuery = false
            Part.CanCollide = false
            Part.CanTouch = false
            Part.Name = "CRATERAS"

            local Nparams = RaycastParams.new()
            Nparams.FilterType = Enum.RaycastFilterType.Include
            Nparams.FilterDescendantsInstances = {workspace.mapa}
            
            local Detect = workspace:Raycast(Part.Position + Result.Normal * 4, Result.Normal * -5, Nparams)
            if Detect then
                Part.Position = Detect.Position
                Part.Material = Detect.Material
                Part.Color = Detect.Instance.Color
                Part.Position = Part.Position + Result.Normal * -1
                print("Primeiro Tween")
                TweenService:Create(Part,TweenInfo.new(0.5,Enum.EasingStyle.Cubic , Enum.EasingDirection.Out ,0,true,0),{Position = Part.Position + Result.Normal * 1}):Play()
                task.spawn(function()
                    game.Debris:AddItem(Part,14)
                    task.wait(2)
                    print("Segundo Tween")
                    TweenService:Create(Part,TweenInfo.new(10,Enum.EasingStyle.Cubic, Enum.EasingDirection.Out,0,true,1),{Position = Part.Position + Result.Normal * -4}):Play()
                end)
            else
                task.wait(12)
                Part:Destroy()
            end

        end
    end,
    ["KB"] = function(hrp,Direction)
        if hrp == nil then return end
        local att = Instance.new("Attachment",hrp)
        att.Name = "KB" -- pensamento para tratamento de física no futuro
        local lv = Instance.new("LinearVelocity")
        lv.Parent = att
        lv.MaxForce = math.huge
        lv.VectorVelocity = Direction
        lv.Attachment0 = att
        game.Debris:AddItem(att,0.1)

    end,
    ["AlignPosition"] = function(ToAling,Aling,time)
        local Attachment = Instance.new("Attachment")
        Attachment.Name = "AlignPosition1"
        Attachment.Parent = ToAling

        local Attach = Instance.new("Attachment")
        Attach.Name = "AlignPosition2"
        Attach.CFrame = Aling.CFrame * CFrame.new(0,0,2)
        Attach.Parent = Aling

        local alingPosition = Instance.new("AlignPosition")
        alingPosition.Attachment0 = Attachment
        alingPosition.Attachment1 = Attach
        alingPosition.Name = "AlignPosition2"
        alingPosition.Parent = Attach

        game.Debris:AddItem(Attachment,time)
        game.Debris:AddItem(Attach,time)

    end,
    ["Grab"] = function(ToAling,Aling,Position,time)
        local Attachment = Instance.new("Attachment")
        Attachment.Name = "AlignPositionatt1"
        Attachment.Parent = ToAling

        local Attach = Instance.new("Attachment")
        Attach.CFrame = Position
        Attach.Name = "AlignPositionatt2"
        Attach.Parent = Aling

        local alingPosition = Instance.new("AlignPosition")
        alingPosition.Attachment0 = Attachment
        alingPosition.Attachment1 = Attach
        alingPosition.Name = "AlignPosition2"
        alingPosition.Parent = Attach
        -- alingPosition.MaxForce = 500
        -- alingPosition.MaxVelocity = 100

        alingPosition.Responsiveness = 200
        print(Attachment)
        print(Attach)

        game.Debris:AddItem(Attachment,time)
        game.Debris:AddItem(Attach,time)

    end

}

return Functions