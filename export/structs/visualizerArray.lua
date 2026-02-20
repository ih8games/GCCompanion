local visualizerObject = require("export.structs.visualizerObject")
local int32 = require("export.variableTypes.int32")

local visualizerArray = {}
visualizerArray.__index = visualizerArray

function visualizerArray:new(visualizerObjects)
  local obj = {
    length = int32:new(#visualizerObjects),
    visualizerObjects = {},
  }
  
  for i,v in pairs (visualizerObjects) do
    obj.visualizerObjects[i] = visualizerObject:new(v)
  end
  
  return setmetatable(obj, self)
end

function visualizerArray:toByte()
  local bytes = self.length:toByte()
  
  for _,v in pairs (self.visualizerObjects) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  return bytes
end

function visualizerArray:size()
  return visualizerObject.size() * self.length.x + int32.size()
end

return visualizerArray