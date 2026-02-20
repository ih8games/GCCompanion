local char = require("export.variableTypes.char")

local color = {}
color.__index = color

function color:new(c)
  local obj = {
    r = char:new(c[1]),
    g = char:new(c[2]),
    b = char:new(c[3]),
    a = char:new(c[4])
  }
  
  return setmetatable(obj, self)
end

function color:toByte()
  return string.format("%s%s%s%s",
    self.r:toByte(),
    self.g:toByte(),
    self.b:toByte(),
    self.a:toByte()
  )
end

function color:size()
  return char.size() * 4
end

return color