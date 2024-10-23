local Functions = require(script.Parent.Parent.Functions)

local module = {
    ["M1"] = function(Player,...)
        local Data = ...
        print("chegamos em: ", script, " [Server]")
        local Character = Player.Character
        Functions.FireClientWithDistance(
            {
                Origin = Character.HumanoidRootPart.Position,
                Distance = 125,
                Remote = game.ReplicatedStorage.Remotes.Effects},
            {
                "M1" ,
                {Params = nil}
            }
        )
    end
}

return module