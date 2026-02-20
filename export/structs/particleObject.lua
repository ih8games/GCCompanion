local float = require("export.variableTypes.float")
local int32 = require("export.variableTypes.int32")
local color = require("export.variableTypes.color")

local particleObject = {}
particleObject.__index = particleObject

function particleObject:new(p)
  local obj = {
    timestampMs = int32:new(p.timestampMs),
    unk4 = int32:new(p.unk4),
    groupShape = int32:new(p.groupShape),
    particleTexture = int32:new(p.particleTexture),
    color = color:new(p.color),
    velocity = {float:new(p.velocity[1]), float:new(p.velocity[2]), float:new(p.velocity[3])},
    repeatMeasure = float:new(p.repeatMeasure),
    lifespanMeasure = float:new(p.lifespanMeasure),
    groupShapeSize = int32:new(p.groupShapeSize)
  }
  
  return setmetatable(obj, self)
end

function particleObject:toByte()
  return string.format("%s%s%s%s%s%s%s%s%s%s%s",
    self.timestampMs:toByte(),
    self.unk4:toByte(),
    self.groupShape:toByte(),
    self.particleTexture:toByte(),
    self.color:toByte(),
    self.velocity[1]:toByte(),
    self.velocity[2]:toByte(),
    self.velocity[3]:toByte(),
    self.repeatMeasure:toByte(),
    self.lifespanMeasure:toByte(),
    self.groupShapeSize:toByte()
  )
end

function particleObject:size()
  return float.size() * 5 + int32.size() * 5 + color.size()
end

return particleObject