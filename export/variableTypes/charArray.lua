local char = require("export.variableTypes.char")
local int16 = require("export.variableTypes.int16")

local charArray = {}
charArray.__index = charArray

function charArray:new(str)
  local obj = {
    length = string.len(str),
    string = str or ""
  }
  
  return setmetatable(obj, self)
end

function charArray:toByte()
  return love.data.pack("string", ">s2", self.string)
end

function charArray:size()
  return char.size() * self.length + int16.size()
end

return charArray