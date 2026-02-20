local int16 = {}
int16.__index = int16

function int16:new(x)
  local obj = {
    x = tonumber(x) or 0
  }
  
  return setmetatable(obj, self)
end

function int16:toByte()
  return love.data.pack("string", ">i2", self.x)
end

function int16:size()
  return 2
end

return int16