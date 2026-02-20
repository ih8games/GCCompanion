local visibilityEntry = require("export.structs.visibilityEntry")
local int32 = require("export.variableTypes.int32")

local visibilityArray = {}
visibilityArray.__index = visibilityArray

function visibilityArray:new(visibilityEntries)
  local obj = {
    length = int32:new(#visibilityEntries),
    entries = {}
  }
  
  for i,v in pairs (visibilityEntries) do
    obj.entries[i] = visibilityEntry:new(v)
  end
  
  return setmetatable(obj, self)
end

function visibilityArray:toByte()
  local bytes = self.length:toByte()
  
  for _,v in pairs (self.entries) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  return bytes
end

function visibilityArray:size()
  return visibilityEntry.size() * self.length.x + int32.size()
end

return visibilityArray