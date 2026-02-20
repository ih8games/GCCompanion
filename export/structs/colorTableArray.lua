local colorTableEntry = require("export.structs.colorTableEntry")
local int32 = require("export.variableTypes.int32")

local colorTableArray = {}
colorTableArray.__index = colorTableArray

function colorTableArray:new(colorTableEntries)
  local obj = {
    length = int32:new(#colorTableEntries),
    colorTableEntries = {},
  }
  
  for i,v in pairs (colorTableEntries) do
    obj.colorTableEntries[i] = colorTableEntry:new(v)
  end
  
  return setmetatable(obj, self)
end

function colorTableArray:toByte()
  local bytes = self.length:toByte()
  
  for _,v in pairs (self.colorTableEntries) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  return bytes
end

function colorTableArray:size()
  return colorTableEntry.size() * self.length.x + int32.size()
end

return colorTableArray