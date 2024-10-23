local classes = {}

classes.Projectile = {}
classes.Projectile.__index = classes.Projectile

function classes.Projectile.new(name,Parent)
    local self = setmetatable({},classes.Projectile)
    self.part = Instance.new("Part", Parent)
    self.Name = name
    self.part.Name = name
    return self
end
function classes.Projectile:setsize(x,y,z)
    self.part.Size = Vector3.new(x,y,z)
end
function classes.Projectile:getsize()
    return self.part.Size
end
function classes.Projectile:setPosition(x,y,z)
    self.part.Position = Vector3.new(x,y,z)
end
function classes.Projectile:getPosition()
    return self.part.Position
end

classes.BodyPosition = {}
classes.BodyPosition.__index = classes.BodyPosition

function classes.BodyPosition.new(name,Parent, Position, maxforce,D,P)
    local self = setmetatable({},classes.Projectile)
    self.instance = Instance.new("BodyPosition", Parent)
    self.Name = name
    self.instance.Position = Position or Parent.Position
    self.instance.MaxForce = maxforce or Vector3.one * 999999
    self.instance.D = D or 200
    self.instance.P = P or 800
    return self
end
function classes.BodyPosition:getinstance()
    return self.instance
end


return classes