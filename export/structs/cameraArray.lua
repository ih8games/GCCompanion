local cameraObject = require("export.structs.cameraObject")
local int32 = require("export.variableTypes.int32")

local cameraArray = {}
cameraArray.__index = cameraArray

function cameraArray:new(cameraObjects)
  local obj = {
    length = int32:new(#cameraObjects),
    cameraObjects = {},
  }
  
  for i,v in pairs (cameraObjects) do
    obj.cameraObjects[i] = cameraObject:new(v)
  end
  
  return setmetatable(obj, self)
end

function cameraArray:toByte()
  local bytes = self.length:toByte()
  
  for _,v in pairs (self.cameraObjects) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  return bytes
end

function cameraArray:size()
  return cameraObject.size() * self.length.x + int32.size()
end

return cameraArray