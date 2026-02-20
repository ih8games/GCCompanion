local int32 = require("export.variableTypes.int32")
local char = require("export.variableTypes.char")
local float = require("export.variableTypes.float")

local movementEntry = {}
movementEntry.__index = movementEntry

function movementEntry:new(v)
  local obj = {
    timestampMs = int32:new(v[1]),
    tweenTowardsBool = char:new(v[2]),
    tweenAwayBool = char:new(v[3]),
    position = {float:new(v[4]), float:new(v[5]), float:new(v[6])}
  }
  
  return setmetatable(obj, self)
end

function movementEntry:toByte()
  return string.format("%s%s%s%s%s%s",
    self.timestampMs:toByte(),
    self.tweenTowardsBool:toByte(),
    self.tweenAwayBool:toByte(),
    self.position[1]:toByte(),
    self.position[2]:toByte(),
    self.position[3]:toByte()
  )
end

function movementEntry:size()
  return float.size() * 3 + char.size() * 2 + int32.size()
end

return movementEntry