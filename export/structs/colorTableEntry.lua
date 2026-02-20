local int32 = require("export.variableTypes.int32")
local color = require("export.variableTypes.color")
local char = require("export.variableTypes.char")

local colorTableEntry = {}
colorTableEntry.__index = colorTableEntry

function colorTableEntry:new(ct)
  local obj = {
    timestampMs = int32:new(ct.timestampMs),
    topRight = color:new(ct.topRight),
    topLeft = color:new(ct.topLeft),
    bottomRight = color:new(ct.bottomRight),
    bottomLeft = color:new(ct.bottomLeft),
    fadeOutBool = char:new(ct.fadeOutBool),
    fadeInBool = char:new(ct.fadeInBool)
  }
  
  return setmetatable(obj, self)
end

function colorTableEntry:toByte()
  return string.format("%s%s%s%s%s%s%s",
    self.timestampMs:toByte(),
    self.topRight:toByte(),
    self.topLeft:toByte(),
    self.bottomRight:toByte(),
    self.bottomLeft:toByte(),
    self.fadeOutBool:toByte(),
    self.fadeInBool:toByte()
  )
end

function colorTableEntry:size()
  return color.size() * 4 + char.size() * 2 + int32.size()
end

return colorTableEntry