local drawDistance = require("export.structs.drawDistance")
local int32 = require("export.variableTypes.int32")

local trackDrawDistance = {}
trackDrawDistance.__index = trackDrawDistance

function trackDrawDistance:new(tdd)
  local obj = {
    length = int32:new(#tdd),
    drawDistances = {}
  }
  
  for i,v in pairs (tdd) do
    obj.drawDistances[i] = drawDistance:new(v)
  end
  
  return setmetatable(obj, self)
end

function trackDrawDistance:toByte()
  local bytes = self.length:toByte()
  
  for _,v in pairs (self.drawDistances) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  return bytes
end

function trackDrawDistance:size()
  return drawDistance.size() * self.length.x + int32.size()
end

return trackDrawDistance