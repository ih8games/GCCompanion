local int32 = require("export.variableTypes.int32")
local color = require("export.variableTypes.color")

local visualizerObject = {}
visualizerObject.__index = visualizerObject

function visualizerObject:new(v)
  local obj = {
    timestampMs = int32:new(v.timestampMs),
    visualizerType = int32:new(v.visualizerType),
    color = color:new(v.color)
  }
  
  return setmetatable(obj, self)
end

function visualizerObject:toByte()
  return string.format("%s%s%s",
    self.timestampMs:toByte(),
    self.visualizerType:toByte(),
    self.color:toByte()
  )
end

function visualizerObject:size()
  return int32.size() * 2 + color.size()
end

return visualizerObject