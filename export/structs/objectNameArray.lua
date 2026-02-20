local int32 = require("export.variableTypes.int32")
local modelName = require("export.variableTypes.modelName")
local char = require("export.variableTypes.char")

local objectNameArray = {}
objectNameArray.__index = objectNameArray

function objectNameArray:new(objectNames)
  local obj = {
    length = int32:new(#objectNames),
    names = {},
    names2Size = int32:new(1),
    names2 = char:new(0)
  }
  
  for i,v in pairs (objectNames) do
    obj.names[i] = modelName:new(v)
  end
  
  return setmetatable(obj, self)
end

function objectNameArray:toByte()
  local bytes = self.length:toByte()

  for _,v in pairs (self.names) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  bytes = string.format("%s%s%s", bytes, self.names2Size:toByte(), self.names2:toByte())
  
  return bytes
end

function objectNameArray:size()
  local size = int32.size()
  
  for _,v in pairs (self.names) do
    size = size + v:size()
  end
  
  return size + int32.size() * 2 + char.size()
end

return objectNameArray