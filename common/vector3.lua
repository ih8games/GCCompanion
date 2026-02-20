local vector3 = {}

local mt = {
  __name = "Vector3",
  __index = vector3,
}

function vector3:new(x, y, z)
  local vector = 
    {
      x = x or 0,
      y = y or 0,
      z = z or 0
    }
  
  return setmetatable(vector, mt)
end

function vector3:magnitude()
  return math.sqrt((self.x * self.x) + (self.y * self.y) + (self.z * self.z))
end

function vector3:unit()
  local mag = self:magnitude()
  
  if mag == 0 then
    return self
  end
  
  return self / mag
end

function vector3:cross(b)
  local x = self.y * b.z - self.z * b.y
  local y = self.z * b.x - self.x * b.z
  local z = self.x * b.y - self.z * b.x
  
  return vector3:new(x, y, z)
end

function vector3:dot(b)
  return (self.x * b.x) + (self.y * b.y) + (self.z * b.z)
end

function vector3:angle(b)
  local angle = math.atan2(b.z, self.x) - math.atan2(self.z, b.x)
  
  if angle > math.pi then
    angle = angle - (2 * math.pi)
    
  elseif angle <= -math.pi then
    angle = angle + (2 * math.pi)
  end
  
  return math.deg(angle)

  --return math.deg(math.atan2((self.x * b.z) - (self.z * b.x), (self.x * b.x) + (self.z * b.z)))
  
  --return math.deg(math.acos(self:dot(b) / (self:magnitude() * b:magnitude())))
end

mt.__add = function(a, b)
  return vector3:new(a.x + b.x, a.y + b.y, a.z + b.z)
end
mt.__sub = function(a, b)
  return vector3:new(a.x - b.x, a.y - b.y, a.z - b.z)
end

mt.__mul = function(a, b)
  if type(a) == type(b) and a.__name == b.__name then
    return vector3:new(a.x * b.x, a.y * b.y, a.z * b.z)
  end
  
  if type(a) == "number" then
    return vector3:new(b.x * a, b.y * a, b.z * a)
  end
  
  return vector3:new(a.x * b, a.y * b, a.z * b)
end

mt.__div = function(a, b)
  if type(a) == type(b) and a.__name == b.__name then
    return vector3:new(a.x / b.x, a.y / b.y, a.z / b.z)
  end
  
  if type(a) == "number" then
    return vector3:new(b.x / a, b.y / a, b.z / a)
  end
  
  return vector3:new(a.x / b, a.y / b, a.z / b)
end

mt.__tostring = function(a)
  return string.format("{%0.3f, %0.3f, %0.3f}", a.x, a.y, a.z)
end

return vector3