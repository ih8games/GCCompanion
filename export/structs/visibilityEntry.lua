local int32 = require("export.variableTypes.int32")
local char = require("export.variableTypes.char")

local visibilityEntry = {}
visibilityEntry.__index = visibilityEntry

function visibilityEntry:new(v)
  local obj = {
    timestampMs = int32:new(v[1]),
    fadeOutBool = char:new(v[2]),
    fadeInBool = char:new(v[3]),
    visibleBool = char:new(v[4])
  }
  
  return setmetatable(obj, self)
end

function visibilityEntry:toByte()
  return string.format("%s%s%s%s",
    self.timestampMs:toByte(),
    self.fadeOutBool:toByte(),
    self.fadeInBool:toByte(),
    self.visibleBool:toByte()
  )
end

function visibilityEntry:size()
  return char.size() * 3 + int32.size()
end

return visibilityEntry