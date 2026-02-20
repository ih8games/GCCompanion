local particleObject = require("export.structs.particleObject")
local int32 = require("export.variableTypes.int32")

local particleArray = {}
particleArray.__index = particleArray

function particleArray:new(particleObjects)
  local obj = {
    length = int32:new(#particleObjects),
    particleObjects = {},
  }
  
  for i,v in pairs (particleObjects) do
    obj.particleObjects[i] = particleObject:new(v)
  end
  
  return setmetatable(obj, self)
end

function particleArray:toByte()
  local bytes = self.length:toByte()
  
  for _,v in pairs (self.particleObjects) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  return bytes
end

function particleArray:size()
  return particleObject.size() * self.length.x + int32.size()
end

return particleArray