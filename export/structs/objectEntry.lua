local visibilityArray = require("export.structs.visibilityArray")
local movementArray = require("export.structs.movementArray")
local scalingArray = require("export.structs.scalingArray")
local rotationArray = require("export.structs.rotationArray")
local colorChangeArray = require("export.structs.colorChangeArray")

local float = require("export.variableTypes.float")
local int32 = require("export.variableTypes.int32")
local char = require("export.variableTypes.char")
local floatColor = require("export.variableTypes.floatColor")

local objectEntry = {}
objectEntry.__index = objectEntry

function objectEntry:new(o)
  local obj = {
    model = int32:new(o.model),
    fs = int32:new(o.fs),
    wireframeBool = char:new(o.wireframeBool),
    flashingBool = char:new(o.flashingBool),
    unkBool1 = char:new(o.unkBool1),
    position = {float:new(o.position[1]), float:new(o.position[2]), float:new(o.position[3])},
    scale = {float:new(o.scale[1]), float:new(o.scale[2]), float:new(o.scale[3])},
    rotation = {float:new(o.rotation[1]), float:new(o.rotation[2]), float:new(o.rotation[3])},
    color = floatColor:new(o.color),
    unk = {float:new(o.unk[1]), float:new(o.unk[2]), float:new(o.unk[3])},
    visibilityArray = visibilityArray:new(o.visibility),
    movementArray = movementArray:new(o.movements),
    scalingArray = scalingArray:new(o.scalings),
    rotationArray = rotationArray:new(o.rotations),
    colorChangeArray = colorChangeArray:new(o.colorChanges)
  }
  
  return setmetatable(obj, self)
end

function objectEntry:toByte()
  local bytes = string.format("%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
    self.model:toByte(),
    self.fs:toByte(),
    self.wireframeBool:toByte(),
    self.flashingBool:toByte(),
    self.unkBool1:toByte(),
    self.position[1]:toByte(),
    self.position[2]:toByte(),
    self.position[3]:toByte(),
    self.scale[1]:toByte(),
    self.scale[2]:toByte(),
    self.scale[3]:toByte(),
    self.rotation[1]:toByte(),
    self.rotation[2]:toByte(),
    self.rotation[3]:toByte(),
    self.color:toByte(),
    self.unk[1]:toByte(),
    self.unk[2]:toByte(),
    self.unk[3]:toByte()
  )
  
  bytes = string.format("%s%s%s%s%s%s", 
    bytes, 
    self.visibilityArray:toByte(),
    self.movementArray:toByte(),
    self.scalingArray:toByte(),
    self.rotationArray:toByte(),
    self.colorChangeArray:toByte()
  )
  
  return bytes
end

function objectEntry:size()
  return float.size() * 13 + char.size() * 3 + int32.size() 
    + self.visibilityArray:size() 
    + self.movementArray:size() 
    + self.scalingArray:size() 
    + self.rotationArray:size()
    + self.colorChangeArray:size()
end

return objectEntry