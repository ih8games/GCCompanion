local int32 = require("export.variableTypes.int32")
local int16 = require("export.variableTypes.int16")

local colorTable2Array3 = {}
colorTable2Array3.__index = colorTable2Array3

function colorTable2Array3:new(ct3)
  local obj = {
    length = int32:new(#ct3),
    colorTableEntries = {},
  }
  
  for i,v in pairs (ct3) do
    obj.colorTableEntries[i] = int16:new(v)
  end
  
  return setmetatable(obj, self)
end

function colorTable2Array3:toByte()
  local bytes = self.length:toByte()
  
  for _,v in pairs (self.colorTableEntries) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  return bytes
end

function colorTable2Array3:size()
  return int16.size() * self.length.x + int32.size()
end

return colorTable2Array3