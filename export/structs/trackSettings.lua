local float = require("export.variableTypes.float")
local color = require("export.variableTypes.color")
local char = require("export.variableTypes.char")

local trackSettings = {}
trackSettings.__index = trackSettings

function trackSettings:new(header)
  local obj = {
    backwardDrawDistance = float:new(header.backwardDrawDistance),
    forwardDrawDistance = float:new(header.forwardDrawDistance),
    trackAheadColor = color:new(header.trackAheadColor),
    trackBehindColor = color:new(header.trackBehindColor),
    audioOffset = char:new(header.audioOffset),
    visualOffset = float:new(header.visualOffset),
    unknownColor = color:new(header.unknownColor)
  }
  
  return setmetatable(obj, self)
end

function trackSettings:toByte()
  return string.format("%s%s%s%s%s%s%s",
    self.backwardDrawDistance:toByte(),
    self.forwardDrawDistance:toByte(),
    self.trackAheadColor:toByte(),
    self.trackBehindColor:toByte(),
    self.audioOffset:toByte(),
    self.visualOffset:toByte(),
    self.unknownColor:toByte()
  )
end

function trackSettings:size()
  return float.size() * 3 + color.size() * 3 + char.size()
end

return trackSettings