local float = require("export.variableTypes.float")
local color = require("export.variableTypes.color")
local char = require("export.variableTypes.char")

local colorTable2Entry4 = {}
colorTable2Entry4.__index = colorTable2Entry4

function colorTable2Entry4:new(ct4)
  local obj = {
    unk0 = char:new(ct4.unk0),
    color = color:new(ct4.color),
    unk5 = float:new(ct4.unk5),
    unk9 = char:new(ct4.unk9),
    unk10 = char:new(ct4.unk10)
  }
  
  return setmetatable(obj, self)
end

function colorTable2Entry4:toByte()
  return string.format("%s%s%s%s%s",
    self.unk0:toByte(),
    self.color:toByte(),
    self.unk5:toByte(),
    self.unk9:toByte(),
    self.unk10:toByte()
  )
end

function colorTable2Entry4:size()
  return char.size() * 3 + float.size() + color.size()
end

return colorTable2Entry4