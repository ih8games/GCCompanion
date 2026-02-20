local int32 = require("export.variableTypes.int32")
local char = require("export.variableTypes.char")
local color = require("export.variableTypes.color")

local colorChangeEntry = {}
colorChangeEntry.__index = colorChangeEntry

function colorChangeEntry:new(v)
  local obj = {
    timestampMs = int32:new(v[1]),
    tweenTowardsBool = char:new(v[2]),
    tweenAwayBool = char:new(v[3]),
    color = color:new({v[4], v[5], v[6], v[7]})
  }
  
  return setmetatable(obj, self)
end

function colorChangeEntry:toByte()
  return string.format("%s%s%s%s",
    self.timestampMs:toByte(),
    self.tweenTowardsBool:toByte(),
    self.tweenAwayBool:toByte(),
    self.color:toByte()
  )
end

function colorChangeEntry:size()
  return char.size() * 2 + color.size() + int32.size()
end

return colorChangeEntry