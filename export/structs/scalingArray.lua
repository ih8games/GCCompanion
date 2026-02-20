local scalingEntry = require("export.structs.scalingEntry")
local int32 = require("export.variableTypes.int32")

local scalingArray = {}
scalingArray.__index = scalingArray

function scalingArray:new(scalingEntries)
  local obj = {
    length = int32:new(#scalingEntries),
    entries = {}
  }
  
  for i,v in pairs (scalingEntries) do
    obj.entries[i] = scalingEntry:new(v)
  end
  
  return setmetatable(obj, self)
end

function scalingArray:toByte()
  local bytes = self.length:toByte()
  
  for _,v in pairs (self.entries) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  return bytes
end

function scalingArray:size()
  return scalingEntry.size() * self.length.x + int32.size()
end

return scalingArray