local float = {}
float.__index = float

function float:new(x)
  local obj = {
    x = tonumber(x) or 0
  }
  
  return setmetatable(obj, self)
end

function float:toByte()
  return love.data.pack("string", ">f", self.x)
end

function float:size()
  return 4
end

return float