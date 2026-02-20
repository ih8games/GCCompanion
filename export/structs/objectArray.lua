local objectNameArray = require("export.structs.objectNameArray")
local objectEntry = require("export.structs.objectEntry")
local int32 = require("export.variableTypes.int32")

local objectArray = {}
objectArray.__index = objectArray

function objectArray:new(objectNames, objects)
  local obj = {
    objectNameArray = objectNameArray:new(objectNames),
    length = int32:new(#objects),
    objectEntries = {},
  }
  
  for i,v in pairs (objects) do
    obj.objectEntries[i] = objectEntry:new(v)
  end
  
  return setmetatable(obj, self)
end

function objectArray:toByte()
  local bytes = self.objectNameArray:toByte()
  
  bytes = string.format("%s%s", bytes, self.length:toByte())
  
  for _,v in pairs (self.objectEntries) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  return bytes
end

function objectArray:size()
  local size = self.objectNameArray:size()
  
  for _,v in pairs (self.objectEntries) do
    size = size + v:size()
  end
  
  return size + int32.size()
end

return objectArray