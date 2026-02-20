local int32 = require("export.variableTypes.int32")
local char = require("export.variableTypes.char")

local unknownObjectArray = {}
unknownObjectArray.__index = unknownObjectArray

function unknownObjectArray:new(size)
  local obj = {
    count = int32:new(size)
  }
  
  return setmetatable(obj, self)
end

function unknownObjectArray:toByte()
  local bytes = self.count:toByte()
  local zero = char:new(0):toByte()
  
  for i = 1, self.count.x do
    bytes = string.format("%s%s", bytes, zero)
  end
  
  return bytes
end

function unknownObjectArray:size()
  return char.size() * self.count.x + int32.size()
end

return unknownObjectArray