local char = {}
char.__index = char

function char:new(x)
  local obj = {
    char = x or 0
  }
  
  return setmetatable(obj, self)
end

function char:toByte()
  return love.data.pack("string", "B", self.char)
end

function char:size()
  return 1
end

return char