-- Scripts made by: voidshadow7587 formerly known as sombra_arcana
-- before everthing i'm using this Module being called from the RemoteMainScript

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")
-- getting all services i need

local Functions = require(script.Parent.Parent.Functions)
local Radius = 7
local load = 1
local RemoteBombs = {}
-- here i just mading some variables to use in RemoteBombs Function

local module = {
    ["Fireball"] = function(Player,...)
        -- getting data like mousePosition and character
        local Data = ...
        local Character = Player.Character
        -- while holding the power the player will be frozen in the same spot till release the skill
        local BodyPosition = Instance.new("BodyPosition", Character.HumanoidRootPart)
        BodyPosition.Position = Character.HumanoidRootPart.Position
        BodyPosition.MaxForce = Vector3.one * 999999
        BodyPosition.D = 200
        BodyPosition.P = 800
        BodyPosition.Name = "FireballLock"
        
        Functions.FireClientWithDistance(
            {
                Origin = Character.HumanoidRootPart.Position,
                Distance = 125,
                Remote = game.ReplicatedStorage.Remotes.Effects},
            {
                "FireballCharge" ,
                {Character = Character}
            }
        )-- Firing all Clients in range funcction to make a parallel Client VFX ocurrence
        local Inputs = require(game.ServerScriptService.Services.ServerHandler.Inputs)
        while Inputs.InputTable[Player]["F"] do
            task.wait(.1)
        end-- after release the button destroying the BP

        -- fireballRealease
        BodyPosition:Destroy()

        Functions.FireClientWithDistance(
            {
                Origin = Character.HumanoidRootPart.Position,
                Distance = 125,
                Remote = game.ReplicatedStorage.Remotes.Effects},
            {
                "FireballRelease" ,
                {Character = Character, }
            }
        )-- shooting the Particles shoot FX

        
    end,
    ["FireballRelease"] = function(Player,Data)
        local Character = Player.Character
        local Endpos = Data.endpos
        local Hummanoidrootpart = Character.HumanoidRootPart

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {workspace.VFX, Character}
        -- getting the params for the skill dont hit other skills , or dont hit the own character

        

        local Fireball = ReplicatedStorage.Assets.VFX.Fireball:Clone()
        -- cloning the Fireball
        
        Fireball.Name = "Fireball"..Player.Name
        Fireball.CFrame = Data.Cframe * CFrame.new(0,0,0)-- Spawning Fireball from the hand of the player

        Fireball.CFrame = CFrame.new(Fireball.Position, Endpos)-- orienting fireball to mouse Destination
        Fireball.Parent = workspace.VFX-- getting his visible on Workspace



        
        Functions.FireClientWithDistance(
            {
                Origin = Character.HumanoidRootPart.Position,
                Distance = 125,
                Remote = game.ReplicatedStorage.Remotes.Effects},
            {
                "FireballRelease" ,
                {Character = Character, Fireball = Fireball}
            }
        )-- only firing the FX if the clients is close
        game.Debris:AddItem(Fireball,10)-- after 10 seconds of non-hiting , destroing it

        local StartTime = tick()
        local Connection
        local velocity = 250
        local grav = 1
        local vel = (Fireball.Position - Endpos).Unit * - velocity
        -- declaring all variables what i gonna use in the trajectory
        task.delay(0.5,function()
            grav = 25
            velocity = 100
            vel = (Fireball.Position - Endpos).Unit * - velocity
        end)-- after 0.5 seconds making the fireball to fall
        -- 
        Connection = RunService.Heartbeat:Connect(function(deltaTime)
            local Result = workspace:Raycast(Fireball.Position, vel * deltaTime - Vector3.new(0,grav,0) * deltaTime * deltaTime,params)

            if Result then -- if found something execute all the logic
                Fireball.Position = Result.Position
                local Explosion = ReplicatedStorage.Assets.VFX.Explosion:Clone()-- get VFX of explosion and setting ccfrrame
                Explosion.Position = Result.Position
                Explosion.CFrame = CFrame.new(Result.Position , Result.Position + Result.Normal) * CFrame.Angles(math.rad(90),0,0)
                Explosion.Parent = workspace.VFX
                Explosion.Name = "Explosão de :"..Player.Name

                for i,v in pairs(Explosion.Attachment:GetChildren()) do
                    task.wait()
                    v:Emit(23)
                end
                -- Emmitting particles

                game.Debris:AddItem(Explosion,3)
                game.Debris:AddItem(Fireball,0.1)
                Connection:Disconnect()-- closing the HeartBeat
                -- iniatializing all system of damage accounting system
                local newparams = OverlapParams.new()
                newparams.FilterType = Enum.RaycastFilterType.Exclude
                newparams.FilterDescendantsInstances = {Player.Character, workspace.mapa}
                local RaycastRadius = workspace:GetPartBoundsInRadius(Result.Position,Radius,newparams) -- searching in radius area
                local hits = {}
                for i,Part in pairs(RaycastRadius) do -- getting all the players who dont be the own of skill
                    if Part.Parent:FindFirstChild("Humanoid") and hits[Part.Parent] == nil then
                        hits[Part.Parent] = true
                        Part.Parent.Humanoid:TakeDamage(10)
                        task.spawn(function()
                            Functions.FireClientWithDistance({Origin = Character.HumanoidRootPart.Position,Distance = 125,Remote = game.ReplicatedStorage.Remotes.Effects},{"BurningEffects" ,{Character = Part.Parent , Time = 4.1}})
                            for v = 0,4 do
                                task.wait(1)

                                Part.Parent.Humanoid:TakeDamage(2)
                            end
                        end) -- execuuting the flame debuff as a thread
                    end
                end
                -- if hit grand or wall , will create an crater
            
                if Result.Instance.Parent:FindFirstChild("Humanoid") == nil then
                    Functions.CreateCrater(35,10,Result,10)
                    Functions.CreateCrater(35,20,Result,10)
                end
                
            else -- if founding nothing will keep moving till found something
                Fireball.Position = Fireball.Position + vel * deltaTime - Vector3.new(0 , grav , 0) * deltaTime * deltaTime
                vel = vel - Vector3.new(0,grav,0) * deltaTime
            end
        end)

        -- game.Debris:AddItem(Fireball,5)

    end,
    ["FireBreath"] = function(Player ,...)
        local Data = ...
        local Character = Player.Character
        
        local Endpos = Data.Data.endpos
        local Hummanoidrootpart = Character.HumanoidRootPart

        print("FireBreath mouse:",Endpos)
        Functions.FireClientWithDistance(
            {
                Origin = Character.HumanoidRootPart.Position,
                Distance = 125,
                Remote = game.ReplicatedStorage.Remotes.Effects},
            {
                "FireBreath" ,
                {Character = Character}
            }
        )

        -- GETPARTSINBOUND

        -- local FireBreath = ReplicatedStorage.Assets.VFX.FireBreath:Clone()
        print("inicio da criação de params")
        local params = OverlapParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {Player.Character, workspace.mapa, workspace.VFX}
        print("inicio da criação do raycastbox")
        local RaycastBox = workspace:GetPartBoundsInBox((Hummanoidrootpart.CFrame * CFrame.Angles(math.rad(90),0,math.rad(90))) * CFrame.new(-2,0,0),Vector3.new(25, 7, 10),params)
        -- beggining An area Hitbox to catch all players from the flame breath
        print("Hitbox criada: ", RaycastBox)
        local hits = {}
        for i,Part in pairs(RaycastBox) do
            print(Part)
            if Part.Parent:FindFirstChild("Humanoid") and hits[Part.Parent] == nil then
                hits[Part.Parent] = true
                Part.Parent.Humanoid:TakeDamage(20)
                task.spawn(function()
                    Functions.FireClientWithDistance({Origin = Character.HumanoidRootPart.Position,Distance = 125,Remote = game.ReplicatedStorage.Remotes.Effects},{"BurningEffects" ,{Character = Part.Parent , Time = 4.1}})
                    for i = 0,4 do
                        task.wait(1)
                        
                        Part.Parent.Humanoid:TakeDamage(2)
                    end
                end)-- appying again the burning stats
            end
        end

        -- my last tests of codes before
        -- FireBreath.Name = "FireBreathFrom"..Player.Name
        -- FireBreath.CFrame = Hummanoidrootpart.CFrame * CFrame.Angles(math.rad(90),0,math.rad(90))
        -- FireBreath.CFrame = FireBreath.CFrame * CFrame.new(-5,0,0)
        -- FireBreath.Size = Vector3.new(12, 7, 10)
        -- FireBreath.Anchored = true
        -- FireBreath.CanCollide = false
        -- FireBreath.CanTouch = false
        -- FireBreath.Parent = workspace.VFX
        -- for i,v in pairs(FireBreath["fire effects"]:GetChildren()) do
        --     task.wait()
        --     v:Emit(150)
        -- end


        -- local hitbox = Instance.new("Part")
        -- hitbox.Name = "HitboxFrom"..Player.Name
        -- hitbox.CFrame = Hummanoidrootpart.CFrame * CFrame.new(0,0,-11)
        -- hitbox.Size = Vector3.new(12, 7, 10)
        -- hitbox.Transparency = 0.5
        -- hitbox.Anchored = true
        -- hitbox.CanCollide = false
        -- hitbox.CanTouch = false
        -- hitbox.Parent = workspace.VFX

        
    end,
    ["FireMissile"] = function(Player,...)
        local Data = ...
        local Character = Player.Character
        local Endpos = Data.Data.endpos
        local Hummanoidrootpart = Character.HumanoidRootPart
        -- getting all data again like all skills

        Functions.FireClientWithDistance(
            {
                Origin = Character.HumanoidRootPart.Position,
                Distance = 125,
                Remote = game.ReplicatedStorage.Remotes.Effects},
            {
                "FireMissile" ,
                {Character = Character}
            }
        )
        local FireMissile
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {workspace.VFX, Character}
        
        
        if not workspace.VFX:FindFirstChild("FireMissileFrom"..Player.Name..3) then -- searching if the player already have 3 fire missiles
            for i = -1 , 1 do -- aways creating 3 fireballs
            local FireMissile = ReplicatedStorage.Assets.VFX.FireMissile:Clone()
            FireMissile.Anchored = false

            local Attachment = Instance.new("Attachment")
            Attachment.Name = "FireMissile"..tostring(i + 2)..Player.Name
            Attachment.Parent = FireMissile

            local Attach = Instance.new("Attachment")
            Attach.Name = "ancora"..tostring(i + 2)..Player.Name
            Attach.CFrame = CFrame.new(i*4,5-(3*(i*i)),2)
            Attach.Parent = Hummanoidrootpart
            
            
  
            FireMissile.Name = "FireMissileFrom"..Player.Name..(i+2)
            FireMissile.CFrame = Hummanoidrootpart.CFrame * CFrame.new(i*4,5-(3*(i*i)),1)
            FireMissile.Parent = workspace.VFX



            FireMissile:SetAttribute("Activated" , false)

            table.insert(RemoteBombs,FireMissile)

            local alingPosition = Instance.new("AlignPosition")
            alingPosition.Attachment0 = Attachment
            alingPosition.Attachment1 = Attach
            alingPosition.Name = "Forca"..tostring(i + 2)
            alingPosition.Parent = Attach
            
            alingPosition.MaxForce = 500
            alingPosition.MaxVelocity = 100
            alingPosition.Responsiveness = 1
            -- aling all the 3 firemissiles in back of the player

            end

        else
            print("excessão")
            

            -- local weld = Instance.new("Weld", FireMissile)
            -- weld.Part0 = Hummanoidrootpart
            -- weld.Part1 = FireMissile

            local Holding = tick()

            local Inputs = require(game.ServerScriptService.Services.ServerHandler.Inputs)
            while Inputs.InputTable[Player]["C"] do
                task.wait()
            end-- if already existe all the 3 missiles, will read time who player hold the Key
            -- quando arremessar = clicar

            -- if click will release
            if tick() - Holding  < 0.2 and workspace.VFX["FireMissileFrom"..Player.Name..load]:GetAttribute("Activated") == false then
                local StartTime = tick()

                local FireMissileLoad = workspace.VFX["FireMissileFrom"..Player.Name..load]

                local Attach = Hummanoidrootpart:FindFirstChild("ancora"..load..Player.Name)
                local alingPosition = Attach:FindFirstChild("Forca"..load)
                Attach:Destroy()
                alingPosition:Destroy()
                FireMissileLoad.Anchored = true
                local Connection
                local velocity = 100
                local grav = 3
                local vel = (FireMissileLoad.Position - Endpos).Unit * - velocity

                -- local alingPosition1 = Hummanoidrootpart:FindFirstChild("Força1")
                -- local alingPosition2 = Hummanoidrootpart:FindFirstChild("Força2")
                -- local alingPosition3 = Hummanoidrootpart:FindFirstChild("Força3")

                -- alingPosition1.Active = true
                -- alingPosition2.Active = true
                -- alingPosition3.Active = true

                
                

                -- FireMissile:FindFirstChild("RigidConstraint"):Destroy()

                load = load + 1
                if load > 3 then
                    load = 1
                end
                Connection = RunService.Heartbeat:Connect(function(deltaTime)
                    


                    local Result = workspace:Raycast(FireMissileLoad.Position, vel * deltaTime ,params)
                    task.delay(7, function()
                        Connection:Disconnect()
                        FireMissileLoad:Destroy()
                        return
                    end)
                    if Result then
                        FireMissileLoad.Position = Result.Position
                        FireMissileLoad:SetAttribute("Activated" , true)

                        -- if Result.Instance.Parent:FindFirstChild("Humanoid") == nil then
                        --     Functions.CreateCrater(35,10,Result,10)
                        -- end
                        Connection:Disconnect()
                    else
                        FireMissileLoad.Position = FireMissileLoad.Position + vel * deltaTime
                        vel = vel - Vector3.new(0,grav,0) * deltaTime
                    end
                end)
            else-- if hold more than 0.2 seconds , will explode all the bombs who are ready to detonate
                for i,v in pairs(RemoteBombs) do
                    if v:GetAttribute("Activated") then -- check if remote bomb is ready to explode
                        local Explosion = ReplicatedStorage.Assets.VFX.Explosion:Clone()
                        Explosion.Position = v.Position
                        Explosion.CFrame = CFrame.new(v.Position ) * CFrame.Angles(0,0,0)
                        Explosion.Parent = workspace.VFX
                        Explosion.Name = "Explosão de :"..Player.Name
                        v:Destroy()
                        v:SetAttribute("Activated", false)

                        for i,v in pairs(Explosion.Attachment:GetChildren()) do
                            task.wait()
                            v:Emit(23)
                        end
                        -- iniatializing the hitbox to get all the players in radius of the remote bombs
                        game.Debris:AddItem(Explosion,1)
                        local newparams = OverlapParams.new()
                        newparams.FilterType = Enum.RaycastFilterType.Exclude
                        newparams.FilterDescendantsInstances = {Player.Character, workspace.mapa}
                        local RaycastRadius = workspace:GetPartBoundsInRadius(v.Position,Radius,newparams)
                        local hits = {}
                        for i,Part in pairs(RaycastRadius) do
                            if Part.Parent:FindFirstChild("Humanoid") and hits[Part.Parent] == nil then
                                hits[Part.Parent] = true
                                Part.Parent.Humanoid:TakeDamage(10)
                                task.spawn(function()
                                    Functions.FireClientWithDistance({Origin = Character.HumanoidRootPart.Position,Distance = 125,Remote = game.ReplicatedStorage.Remotes.Effects},{"BurningEffects" ,{Character = Part.Parent , Time = 4.1}})
                                    for i = 0,4 do
                                        task.wait(1)

                                        Part.Parent.Humanoid:TakeDamage(2)
                                    end
                                end)
                            end
                        end

                        
                    end
                end
            end
        end

        


    end,
    ["FireJavalin"] = function(Player,...) -- this like the Fireball fisrt function , its only to frozen the player and play the FX on clients
        local Data = ...
        local Character = Player.Character
        -- frozing the player in location
        local BodyPosition = Instance.new("BodyPosition", Character.HumanoidRootPart)
        BodyPosition.Position = Character.HumanoidRootPart.Position
        BodyPosition.MaxForce = Vector3.one * 999999
        BodyPosition.D = 200
        BodyPosition.P = 800
        BodyPosition.Name = "FireJavelinCharge"
        
        Functions.FireClientWithDistance(
            {
                Origin = Character.HumanoidRootPart.Position,
                Distance = 125,
                Remote = game.ReplicatedStorage.Remotes.Effects},
            {
                "FireJavelinCharge" ,
                {Character = Character}
            }
        )-- fire FX only for players in Radius

        local Inputs = require(game.ServerScriptService.Services.ServerHandler.Inputs)
        while Inputs.InputTable[Player]["V"] do
            task.wait(.1)
        end-- wait till player release the Key

        -- FireJavalinRelease
        BodyPosition:Destroy()
    end,
    ["FireJavalinRelease"] = function(Player,Data)
        -- this function is firing from the client after release the V key
        local Character = Player.Character
        local Endpos = Data.endpos
        local Hummanoidrootpart = Character.HumanoidRootPart

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {workspace.VFX, Character}
        -- gettin the params of the player again , mouse , CFrame and etc..
        local FireJavalin = ReplicatedStorage.Assets.VFX.FireJavalin:Clone()

        FireJavalin.Name = "FireJavalinFrom"..Player.Name
        FireJavalin.CFrame = Data.Cframe * CFrame.new(0,0,0)

        FireJavalin.CFrame = CFrame.new(FireJavalin.Position, Endpos)
        FireJavalin.Parent = workspace.VFX
        -- clone the only part hitbox
        Functions.FireClientWithDistance(
            {
                Origin = Character.HumanoidRootPart.Position,
                Distance = 125,
                Remote = game.ReplicatedStorage.Remotes.Effects},
            {
                "FireJavalinRelease" ,
                {Character = Character, FireJavalin = FireJavalin}
            }
        )-- firing the FX to close players to active on Real part

        local StartTime = tick()
        local Connection
        local velocity = 750
        local grav = 1
        local vel = (FireJavalin.Position - Endpos).Unit * - velocity
        local target 
        local ForcaKB = 300
        -- declaring all the variables of the skill
        -- Saving the Connect to disconnect when the skill end
        Connection = RunService.Heartbeat:Connect(function(deltaTime)
            local Result = workspace:Raycast(FireJavalin.Position, vel * deltaTime ,params)
            if tick() - StartTime > 3 then
                Connection:Disconnect()
                return
            end -- ending after 3 seconds if founding nothing
            if Result then
                FireJavalin.Position = Result.Position
                -- checking the target if is an other humanoid
                if Result.Instance.Parent:FindFirstChild("Humanoid") or Result.Instance.Parent.Parent:FindFirstChild("Humanoid") then
                    local char = Result.Instance.Parent
                    local HretaPaarte
                    FireJavalin.Position = FireJavalin.Position + vel * deltaTime
                    print("FODA")
                    if char:FindFirstChild("HumanoidRootPart") then -- i was mad with this because i forgot that exist handles in the player can be Acessory or tool
                        print("não é uma Handle")
                        HretaPaarte = char:FindFirstChild("HumanoidRootPart")
                        print(Result.Instance)
                        print(char)
                        print(char.Parent)
                    else
                        print("WAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA É UMA HANDLE")
                        HretaPaarte = char.Parent:FindFirstChild("HumanoidRootPart")
                    end
                    
                    Functions.KB(HretaPaarte, ((HretaPaarte.Position - Hummanoidrootpart.Position).Unit * Vector3.new(ForcaKB,0,ForcaKB) + Vector3.new(0,1))) -- Aply Knockback when impale the Oponent
                    print("Acertastes:",Result.Instance)-- debugging my code
                    
                    
                    
                    task.delay(0.1,function()
                        game.Debris:AddItem(FireJavalin,0.3)
                        Connection:Disconnect()
                    end)
                    
                    
                else-- this else is not working bc i didn't all the system who will wall throught map to stick the player in wall
                    if target ~= nil and target.Name == "HumanoidRootPart" then
                        -- ter que resolver depois
                        local kb = target:FindFirstChild("KB")
                        kb:Destroy()
                        if kb then
                            print("TEM KB PORRA")
                        end
                        print(kb)
                        kb:Destroy()
                        print("ele achou o:", target)
                        print(target:FindFirstChild("RootAttachment"))
                        local alingPosition = Instance.new("AlignPosition", target:FindFirstChild("RootAttachment"))
                        alingPosition.Attachment0 = target:FindFirstChild("RootAttachment")
                        alingPosition.Attachment1 = FireJavalin:FindFirstChild("0")
                        alingPosition.Responsiveness = 200
                        game.Debris:AddItem(alingPosition,0.1)
                        task.delay(0.5, function()
                        end)
                        
                    else
                        print(Result.Instance)
                        print(target.Parent)
                        print(target.Parent.Parent)
                        print(target)
                    end
                    
                    game.Debris:AddItem(FireJavalin,0.3)
                    Connection:Disconnect()
                end
                -- explosão
                
                -- emitir  porr das particulas



                -- local newparams = OverlapParams.new()
                -- newparams.FilterType = Enum.RaycastFilterType.Exclude
                -- newparams.FilterDescendantsInstances = {Player.Character, workspace.mapa}
                -- local RaycastRadius = workspace:GetPartBoundsInRadius(Result.Position,Radius,newparams)
                -- local hits = {}
                
                
            else -- if founding nothing keep foward
                FireJavalin.Position = FireJavalin.Position + vel * deltaTime
            end
        end)
        
    end,

    -- FireBroly foward its on test , dont have keys for this yet
    -- FireBroly foward its on test , dont have keys for this yet
    -- FireBroly foward its on test , dont have keys for this yet

    -- FireBroly foward its on test , dont have keys for this yet
    ["FireBroly"] = function(Player,...)
        local Data = ...
        local Character = Player.Character
        print("[",script.Name,"]firing FireBroly")
        

        -- local newparams = OverlapParams.new()
        -- newparams.FilterType = Enum.RaycastFilterType.Exclude
        -- newparams.FilterDescendantsInstances = {Player.Character, workspace.mapa}
        -- local RaycastRadius = workspace:GetPartBoundsInRadius(Result.Position,Radius,newparams)

        -- get parts in radius

        local hits = {}
        local newparams = OverlapParams.new()
        newparams.FilterType = Enum.RaycastFilterType.Exclude
        newparams.FilterDescendantsInstances = {Character, workspace.mapa}
        
        local RaycastRadius = workspace:GetPartBoundsInRadius(Character.HumanoidRootPart.Position,50,newparams)
        print("AAAAAAAAAAAAAAAAAAAAAAAAAAAA")

        for i,Part in pairs(RaycastRadius) do
            if Part.Parent:FindFirstChild("Humanoid") and hits[Part.Parent] == nil then
                
                -- Character.Position - Part.Parent.Position
                local EnemyCharacter = Part.Parent
                hits[EnemyCharacter] = true

                EnemyCharacter.HumanoidRootPart.Anchored = false

                for i = 0 , 4 do
                    local attach =  Instance.new("Attachment")
                    attach.Parent = EnemyCharacter.HumanoidRootPart

                    -- alying position
                    local AssemblyLinearVelocity = Instance.new("LinearVelocity")
                    AssemblyLinearVelocity.Parent = attach
                    AssemblyLinearVelocity.MaxForce = 999999

                    AssemblyLinearVelocity.VectorVelocity = (Character.HumanoidRootPart.Position - EnemyCharacter.HumanoidRootPart.Position).Unit * Vector3.new(40,40,40)
                    print("AAAAAAAAAA22222AAAAAAAAAAAAAA")
                    AssemblyLinearVelocity.Attachment0 = attach

                    -- EnemyCharacter.HumanoidRootPart.CFrame = EnemyCharacter.HumanoidRootPart.CFrame * CFrame.Angles(math.rad(90),0,0)

                    game.Debris:AddItem(attach,0.3)
                    game.Debris:AddItem(AssemblyLinearVelocity,0.3)
                    -- EnemyCharacter.HumanoidRootPart.Anchored = true
                end
                task.delay(1,function()
                    local attach =  Instance.new("Attachment")
                    attach.Parent = EnemyCharacter.HumanoidRootPart

                    -- alying position
                    local AssemblyLinearVelocity = Instance.new("LinearVelocity")
                    AssemblyLinearVelocity.Parent = attach
                    AssemblyLinearVelocity.MaxForce = 999999

                    AssemblyLinearVelocity.VectorVelocity = (EnemyCharacter.HumanoidRootPart.Position - Character.HumanoidRootPart.Position ).Unit * Vector3.new(70,70,70)
                    print("AAAAAAAAAA22222AAAAAAAAAAAAAA")
                    AssemblyLinearVelocity.Attachment0 = attach

                    -- EnemyCharacter.HumanoidRootPart.CFrame = EnemyCharacter.HumanoidRootPart.CFrame * CFrame.Angles(math.rad(90),0,0)

                    game.Debris:AddItem(attach,0.3)
                    game.Debris:AddItem(AssemblyLinearVelocity,0.3)
                end)
                
                
            end
        end
    end,
    ["FireVortice"] = function(Player,...)
        
    end,
    ["FireVorticeRelease"] = function(Player,Data)
        local Character = Player.Character
        local Endpos = Data.endpos
        local Hummanoidrootpart = Character.HumanoidRootPart

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {workspace.VFX, Character}

        -- local charge = workspace.VFX["FireballChargefrom"..Player.Name]
        -- game.Debris:AddItem(charge,1)

        local FireVortice = ReplicatedStorage.Assets.VFX.FireVortice:Clone()

        -- local function Rename(i)
        --     if FireVortice.Name == "FireVortice"..Player.Name..i then
        --         Rename(i+1)
        --     else
        --         FireVortice.Name = "FireVortice"..Player.Name..i
        --     end
        -- end
        -- if workspace.VFX:FindFirstChild("FireVortice"..Player.Name) then
        --     Rename(1)
        -- else
        --     FireVortice.Name = "FireVortice"..Player.Name
        -- end
        
        FireVortice.Name = "FireVortice"..Player.Name
        FireVortice.CFrame = Data.Cframe * CFrame.new(0,0,0)

        FireVortice.CFrame = CFrame.new(FireVortice.Position, Endpos)
        FireVortice.Parent = workspace.VFX
        -- FireVortice.Massless = true
        -- FireVortice.Anchored = true
        -- FireVortice.CanQuery = false
        -- FireVortice.CanTouch = false

        -- FireVortice.AssemblyLinearVelocity = Vector3.new(math.sin(math.atan2(Endpos.Z - Hummanoidrootpart.Position.Z, Endpos.X - Hummanoidrootpart.Position.X)), 0.2, math.cos(Endpos.Z - Hummanoidrootpart.Position.Z, Endpos.X - Hummanoidrootpart.Position.X)) * 50

        
        Functions.FireClientWithDistance(
            {
                Origin = Character.HumanoidRootPart.Position,
                Distance = 125,
                Remote = game.ReplicatedStorage.Remotes.Effects},
            {
                "FireVorticeRelease" ,
                {Character = Character, FireVortice = FireVortice}
            }
        )
        game.Debris:AddItem(FireVortice,10)

        local StartTime = tick()
        local Connection
        local velocity = 250
        local grav = 1
        local vel = (FireVortice.Position - Endpos).Unit * - velocity

        task.delay(0.5,function()
            grav = 25
            velocity = 100
            vel = (FireVortice.Position - Endpos).Unit * - velocity
        end)

        Connection = RunService.Heartbeat:Connect(function(deltaTime)
            local Result = workspace:Raycast(FireVortice.Position, vel * deltaTime - Vector3.new(0,grav,0) * deltaTime * deltaTime,params)
            
            if Result then
                local hits = {}
                local newparams = OverlapParams.new()
                newparams.FilterType = Enum.RaycastFilterType.Exclude
                newparams.FilterDescendantsInstances = {Character, workspace.mapa}
                
                local RaycastRadius = workspace:GetPartBoundsInRadius(Character.HumanoidRootPart.Position,50,newparams)
                print("AAAAAAAAAAAAAAAAAAAAAAAAAAAA")

                for i,Part in pairs(RaycastRadius) do
                    if Part.Parent:FindFirstChild("Humanoid") and hits[Part.Parent] == nil then
                        
                        -- Character.Position - Part.Parent.Position
                        local EnemyCharacter = Part.Parent
                        hits[EnemyCharacter] = true

                        EnemyCharacter.HumanoidRootPart.Anchored = false

                        for i = 0 , 4 do
                            local attach =  Instance.new("Attachment")
                            attach.Parent = EnemyCharacter.HumanoidRootPart

                            -- alying position
                            local AssemblyLinearVelocity = Instance.new("LinearVelocity")
                            AssemblyLinearVelocity.Parent = attach
                            AssemblyLinearVelocity.MaxForce = 999999

                            AssemblyLinearVelocity.VectorVelocity = (Character.HumanoidRootPart.Position - EnemyCharacter.HumanoidRootPart.Position).Unit * Vector3.new(40,40,40)
                            print("AAAAAAAAAA22222AAAAAAAAAAAAAA")
                            AssemblyLinearVelocity.Attachment0 = attach

                            -- EnemyCharacter.HumanoidRootPart.CFrame = EnemyCharacter.HumanoidRootPart.CFrame * CFrame.Angles(math.rad(90),0,0)

                            game.Debris:AddItem(attach,0.3)
                            game.Debris:AddItem(AssemblyLinearVelocity,0.3)
                            -- EnemyCharacter.HumanoidRootPart.Anchored = true
                        end
                    end
                end
            else
                FireVortice.Position = FireVortice.Position + vel * deltaTime - Vector3.new(0 , grav , 0) * deltaTime * deltaTime
                vel = vel - Vector3.new(0,grav,0) * deltaTime
            end
        end)
    end,
    ["Grab"] = function(Player,...)
        local Data = ...
        local Character = Player.Character

        local HumanoidRootPart = Character.HumanoidRootPart
        Functions.FireClientWithDistance(
            {
                Origin = Character.HumanoidRootPart.Position,
                Distance = 125,
                Remote = game.ReplicatedStorage.Remotes.Effects},
            {
                "FireBreath" ,
                {Character = Character}
            }
        )

        -- GETPARTSINBOUND

        -- local FireBreath = ReplicatedStorage.Assets.VFX.FireBreath:Clone()
        print("inicio da criação de params")
        local params = OverlapParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {Player.Character, workspace.mapa, workspace.VFX}
        print("inicio da criação do raycastbox")
        local RaycastBox = workspace:GetPartBoundsInBox((HumanoidRootPart.CFrame * CFrame.Angles(math.rad(90),0,math.rad(90))) * CFrame.new(-2,0,0),Vector3.new(25, 7, 10),params)
        print("Hitbox criada: ", RaycastBox)
        local hits = {}
        for i,Part in pairs(RaycastBox) do
            if Part.Parent:FindFirstChild("Humanoid") and hits[Part.Parent] == nil then
                hits[Part.Parent] = true
                task.spawn(function()
                    Functions.Grab(Part.Parent:FindFirstChild("HumanoidRootPart"),HumanoidRootPart,CFrame.new(0,0,-4),100)
                end)
            end
        end
    end,
}

return module