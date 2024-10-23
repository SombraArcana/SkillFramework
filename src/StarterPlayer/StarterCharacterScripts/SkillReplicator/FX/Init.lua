local BaseEffects = {}

local function fetchEffect(FXName)
    return BaseEffects[FXName]
end

local function load(module)
    local Effect = require(module)
    for i,v in pairs(Effect) do
        BaseEffects[i] = v
    end
    Effect.getfx = fetchEffect()
end

for i,v in pairs(script:GetChildren()) do
    if v:IsA("ModuleScript") then
        load(v)
    end
end

return BaseEffects