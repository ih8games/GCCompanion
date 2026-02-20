local movementEntry = require("export.structs.movementEntry")
local int32 = require("export.variableTypes.int32")

local movementArray = {}
movementArray.__index = movementArray

function movementArray:new(movementEntries)
  local obj = {
    length = int32:new(#movementEntries),
    entries = {}
  }
  
  for i,v in pairs (movementEntries) do
    obj.entries[i] = movementEntry:new(v)
  end
  
  return setmetatable(obj, self)
end

function movementArray:toByte()
  local bytes = self.length:toByte()
  
  for _,v in pairs (self.entries) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  return bytes
end

function movementArray:size()
  return movementEntry.size() * self.length.x + int32.size()
end

return movementArray