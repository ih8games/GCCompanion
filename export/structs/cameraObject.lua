local float = require("export.variableTypes.float")
local int32 = require("export.variableTypes.int32")
local char = require("export.variableTypes.char")

local cameraObject = {}
cameraObject.__index = cameraObject

function cameraObject:new(c)
  local obj = {
    timestampMs = int32:new(c.timestampMs),
    aMode = char:new(c.aMode),
    fMode = char:new(c.fMode),
    cameraDistance = float:new(c.cameraDistance),
    rotation = {float:new(c.rotation[1]), float:new(c.rotation[2]), float:new(c.rotation[3])},
    originOffset = {float:new(c.originOffset[1]), float:new(c.originOffset[2]), float:new(c.originOffset[3])},
    projectionType = char:new(c.projectionType),
    globalFieldFar = {float:new(c.globalFieldFar[1]), float:new(c.globalFieldFar[2]), float:new(c.globalFieldFar[3])},
    globalFieldNear = {float:new(c.globalFieldNear[1]), float:new(c.globalFieldNear[2]), float:new(c.globalFieldNear[3])}
  }
  
  return setmetatable(obj, self)
end

function cameraObject:toByte()
  return string.format("%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
    self.timestampMs:toByte(),
    self.aMode:toByte(),
    self.fMode:toByte(),
    self.cameraDistance:toByte(),
    self.rotation[1]:toByte(),
    self.rotation[2]:toByte(),
    self.originOffset[1]:toByte(),
    self.originOffset[2]:toByte(),
    self.originOffset[3]:toByte(),
    self.projectionType:toByte(),
    self.globalFieldFar[1]:toByte(),
    self.globalFieldFar[2]:toByte(),
    self.globalFieldFar[3]:toByte(),
    self.globalFieldNear[1]:toByte(),
    self.globalFieldNear[2]:toByte(),
    self.globalFieldNear[3]:toByte(),
    self.rotation[3]:toByte()
  )
end

function cameraObject:size()
  return float.size() * 13 + char.size() * 3 + int32.size()
end

return cameraObject