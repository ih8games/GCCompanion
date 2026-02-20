local rotationEntry = require("export.structs.rotationEntry")
local int32 = require("export.variableTypes.int32")

local rotationArray = {}
rotationArray.__index = rotationArray

function rotationArray:new(rotationEntries)
  local obj = {
    length = int32:new(#rotationEntries),
    entries = {}
  }
  
  for i,v in pairs (rotationEntries) do
    obj.entries[i] = rotationEntry:new(v)
  end
  
  return setmetatable(obj, self)
end

function rotationArray:toByte()
  local bytes = self.length:toByte()
  
  for _,v in pairs (self.entries) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  return bytes
end

function rotationArray:size()
  return rotationEntry.size() * self.length.x + int32.size()
end

return rotationArray