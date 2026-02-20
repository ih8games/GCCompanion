local float = require("export.variableTypes.float")

local floatColor = {}
floatColor.__index = floatColor

function floatColor:new(c)
  local obj = {
    r = float:new(c[1]),
    g = float:new(c[2]),
    b = float:new(c[3]),
    a = float:new(c[4])
  }
  
  return setmetatable(obj, self)
end

function floatColor:toByte()
  return string.format("%s%s%s%s",
    self.r:toByte(),
    self.g:toByte(),
    self.b:toByte(),
    self.a:toByte()
  )
end

function floatColor:size()
  return float.size() * 4
end

return floatColor