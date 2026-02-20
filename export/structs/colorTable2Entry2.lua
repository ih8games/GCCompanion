local color = require("export.variableTypes.color")
local char = require("export.variableTypes.char")

local colorTable2Entry2 = {}
colorTable2Entry2.__index = colorTable2Entry2

function colorTable2Entry2:new(ct2)
  local obj = {
    visibleBool = char:new(ct2.visibleBool),
    center = color:new(ct2.center),
    top = color:new(ct2.top),
    bottom = color:new(ct2.bottom),
    left = color:new(ct2.left),
    right = color:new(ct2.right)
  }
  
  return setmetatable(obj, self)
end

function colorTable2Entry2:toByte()
  return string.format("%s%s%s%s%s%s",
    self.visibleBool:toByte(),
    self.center:toByte(),
    self.top:toByte(),
    self.bottom:toByte(),
    self.left:toByte(),
    self.right:toByte()
  )
end

function colorTable2Entry2:size()
  return color.size() * 5 + char.size()
end

return colorTable2Entry2