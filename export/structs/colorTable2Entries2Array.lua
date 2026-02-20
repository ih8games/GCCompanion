local colorTable2Entry2 = require("export.structs.colorTable2Entry2")
local int32 = require("export.variableTypes.int32")

local colorTable2Array2 = {}
colorTable2Array2.__index = colorTable2Array2

function colorTable2Array2:new(ct2)
  local obj = {
    length = int32:new(#ct2),
    colorTableEntries = {},
  }
  
  for i,v in pairs (ct2) do
    obj.colorTableEntries[i] = colorTable2Entry2:new(v)
  end
  
  return setmetatable(obj, self)
end

function colorTable2Array2:toByte()
  local bytes = self.length:toByte()
  
  for _,v in pairs (self.colorTableEntries) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  return bytes
end

function colorTable2Array2:size()
  return colorTable2Entry2.size() * self.length.x + int32.size()
end

return colorTable2Array2