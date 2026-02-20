local colorTable2Entry4 = require("export.structs.colorTable2Entry4")
local int32 = require("export.variableTypes.int32")

local colorTable2Array4 = {}
colorTable2Array4.__index = colorTable2Array4

function colorTable2Array4:new(ct4)
  local obj = {
    length = int32:new(#ct4),
    colorTableEntries = {},
  }
  
  for i,v in pairs (ct4) do
    obj.colorTableEntries[i] = colorTable2Entry4:new(v)
  end
  
  return setmetatable(obj, self)
end

function colorTable2Array4:toByte()
  local bytes = self.length:toByte()
  
  for _,v in pairs (self.colorTableEntries) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  return bytes
end

function colorTable2Array4:size()
  return colorTable2Entry4.size() * self.length.x + int32.size()
end

return colorTable2Array4