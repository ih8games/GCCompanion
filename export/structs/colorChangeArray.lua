local colorChangeEntry = require("export.structs.colorChangeEntry")
local int32 = require("export.variableTypes.int32")

local colorChangeArray = {}
colorChangeArray.__index = colorChangeArray

function colorChangeArray:new(colorChangeEntries)
  local obj = {
    length = int32:new(#colorChangeEntries),
    entries = {}
  }
  
  for i,v in pairs (colorChangeEntries) do
    obj.entries[i] = colorChangeEntry:new(v)
  end
  
  return setmetatable(obj, self)
end

function colorChangeArray:toByte()
  local bytes = self.length:toByte()
  
  for _,v in pairs (self.entries) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  return bytes
end

function colorChangeArray:size()
  return colorChangeEntry.size() * self.length.x + int32.size()
end

return colorChangeArray