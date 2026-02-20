local int32 = require("export.variableTypes.int32")
local float = require("export.variableTypes.float")

local drawDistance = {}
drawDistance.__index = drawDistance

function drawDistance:new(tdd)
  local obj = {
    timestampMs = int32:new(tdd.timestampMs),
    drawDistance = float:new(tdd.drawDistance)
  }
  
  return setmetatable(obj, self)
end

function drawDistance:toByte()
  return string.format("%s%s",
    self.timestampMs:toByte(),
    self.drawDistance:toByte()
  )
end

function drawDistance:size()
  return int32.size() + float.size()
end

return drawDistance