local char = require("export.variableTypes.char")

local modelName = {}
modelName.__index = modelName

function modelName:new(str)
  local obj = {
    length = string.len(str),
    string = str or ""
  }
  
  return setmetatable(obj, self)
end

function modelName:toByte()
  return love.data.pack("string", ">s1", self.string)
end

function modelName:size()
  return char.size() * (self.length + 1)
end

return modelName