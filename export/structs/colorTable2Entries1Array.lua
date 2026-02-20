local colorTable2Entry1 = require("export.structs.colorTable2Entry1")
local int32 = require("export.variableTypes.int32")

local colorTable2Array1 = {}
colorTable2Array1.__index = colorTable2Array1

function colorTable2Array1:new(ct1)
  local obj = {
    length = int32:new(#ct1),
    colorTableEntries = {}
  }
  
  for i,v in pairs (ct1) do
    obj.colorTableEntries[i] = colorTable2Entry1:new(v)
  end
  
  return setmetatable(obj, self)
end

function colorTable2Array1:toByte()
  local bytes = self.length:toByte()
  
  for _,v in pairs (self.colorTableEntries) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  return bytes
end

function colorTable2Array1:size()
  return colorTable2Entry1.size() * self.length.x + int32.size()
end

return colorTable2Array1