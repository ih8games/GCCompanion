local bpmChangeEntry = require("export.structs.bpmChangeEntry")
local int16 = require("export.variableTypes.int16")

local bpmChangeArray = {}
bpmChangeArray.__index = bpmChangeArray

function bpmChangeArray:new(bpmChanges)
  local obj = {
    length = int16:new(#bpmChanges),
    bpmChanges = {}
  }
  
  for i,v in pairs (bpmChanges) do
    obj.bpmChanges[i] = bpmChangeEntry:new(v)
  end
  
  return setmetatable(obj, self)
end

function bpmChangeArray:toByte()
  local bytes = self.length:toByte()
  
  for _,v in pairs (self.bpmChanges) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  return bytes
end

function bpmChangeArray:size()
  return bpmChangeEntry.size() * self.length.x + int16.size()
end

return bpmChangeArray