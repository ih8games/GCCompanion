local color = require("export.variableTypes.color")
local char = require("export.variableTypes.char")

local colorTable2Entry1 = {}
colorTable2Entry1.__index = colorTable2Entry1

function colorTable2Entry1:new(ct1)
  local obj = {
    color = color:new(ct1.color),
    unk4 = char:new(ct1.unk4)
  }
  
  return setmetatable(obj, self)
end

function colorTable2Entry1:toByte()
  return string.format("%s%s",
    self.color:toByte(),
    self.unk4:toByte()
  )
end

function colorTable2Entry1:size()
  return color.size() + char.size()
end

return colorTable2Entry1