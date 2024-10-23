local testingValue = 0.2

local Skillsets = {
    ["Combat"] = {
        ["M1"] = {Name = "M1", Cooldown = .2, ExtraInfo = { }},
        ["Block"] = {Name = "F", Cooldown = 1, ExtraInfo = { }}
    },

    ["Movement"] = {
        ["Q"] = {Name = "Dash", Cooldown = 1.5, ExtraInfo = { }},
        ["LeftShift"] = {Name = "Sprint", Cooldown = 1, ExtraInfo = { }}
    },
    ["FireSet"] = {
        ["F"] = {Name = "Fireball", Cooldown = 0.8, ExtraInfo = { }},
        ["G"] = {Name = "FireBreath", Cooldown = 0.8, ExtraInfo = { }},
        ["F + LeftShift"] = {Name = "FirebalGiga", Cooldown = 2, ExtraInfo = { }},
        ["C"] = {Name = "FireMissile", Cooldown = 0.4, ExtraInfo = { }},
        ["V"] = {Name = "FireJavalin", Cooldown = 1.2, ExtraInfo = { }},
        ["H"] = {Name = "FireBroly", Cooldown = testingValue, ExtraInfo = { }},
        ["L"] = {Name = "FireVortice", Cooldown = testingValue, ExtraInfo = { }},
        ["P"] = {Name = "Grab", Cooldown = testingValue, ExtraInfo = { }},
    },

}




return Skillsets