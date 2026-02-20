local int32 = {}
int32.__index = int32

function int32:new(x)
  local obj = {
    x = tonumber(x) or 0
  }
  
  return setmetatable(obj, self)
end

function int32:toByte()
  return love.data.pack("string", ">i4", self.x)
end

function int32:size()
  return 4
end

return int32