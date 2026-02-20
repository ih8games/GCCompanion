local int32 = require("export.variableTypes.int32")
local char = require("export.variableTypes.char")
local float = require("export.variableTypes.float")

local scalingEntry = {}
scalingEntry.__index = scalingEntry

function scalingEntry:new(v)
  local obj = {
    timestampMs = int32:new(v[1]),
    tweenTowardsBool = char:new(v[2]),
    tweenAwayBool = char:new(v[3]),
    scale = {float:new(v[4]), float:new(v[5]), float:new(v[6])}
  }
  
  return setmetatable(obj, self)
end

function scalingEntry:toByte()
  return string.format("%s%s%s%s%s%s",
    self.timestampMs:toByte(),
    self.tweenTowardsBool:toByte(),
    self.tweenAwayBool:toByte(),
    self.scale[1]:toByte(),
    self.scale[2]:toByte(),
    self.scale[3]:toByte()
  )
end

function scalingEntry:size()
  return float.size() * 3 + char.size() * 2 + int32.size()
end

return scalingEntry