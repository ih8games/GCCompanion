local int32 = require("export.variableTypes.int32")

local bpmChangeEntry = {}
bpmChangeEntry.__index = bpmChangeEntry

function bpmChangeEntry:new(bpmChange)
  local obj = {
    timestampMs = int32:new(bpmChange.timestampMs),
    newBpm = int32:new(bpmChange.bpm)
  }
  
  return setmetatable(obj, self)
end

function bpmChangeEntry:toByte()
  return string.format("%s%s", self.timestampMs:toByte(), self.newBpm:toByte())
end

function bpmChangeEntry:size()
  return int32.size() * 2
end

return bpmChangeEntry