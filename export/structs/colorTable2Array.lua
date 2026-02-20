local colorTable2Entries1Array = require("export.structs.colorTable2Entries1Array")
local colorTable2Entries2Array = require("export.structs.colorTable2Entries2Array")
local colorTable2Entries3Array = require("export.structs.colorTable2Entries3Array")
local colorTable2Entries4Array = require("export.structs.colorTable2Entries4Array")

local int32 = require("export.variableTypes.int32")

local colorTable2Array = {}
colorTable2Array.__index = colorTable2Array

function colorTable2Array:new(ct1, ct2, ct3, ct4)
  local obj = {
    nearPtr1 = int32:new(0),
    nearPtr2 = int32:new(0),
    nearPtr3 = int32:new(0),
    nearPtr4 = int32:new(0),
    nearPtr5 = int32:new(0),
    
    colorTable2Array1 = colorTable2Entries1Array:new(ct1),
    colorTable2Array2 = colorTable2Entries2Array:new(ct2),
    colorTable2Array3 = colorTable2Entries3Array:new(ct3),
    colorTable2Array4 = colorTable2Entries4Array:new(ct4)
  }

  obj.nearPtr1.x = int32.size() * 5
  obj.nearPtr2.x = obj.nearPtr1.x + obj.colorTable2Array1:size()
  obj.nearPtr3.x = obj.nearPtr2.x + obj.colorTable2Array2:size()
  obj.nearPtr4.x = obj.nearPtr3.x + obj.colorTable2Array3:size()
  obj.nearPtr5.x = obj.nearPtr4.x + obj.colorTable2Array4:size()
  
  return setmetatable(obj, self)
end

function colorTable2Array:toByte()
  local bytes = string.format("%s%s%s%s%s",
    self.nearPtr1:toByte(),
    self.nearPtr2:toByte(),
    self.nearPtr3:toByte(),
    self.nearPtr4:toByte(),
    self.nearPtr5:toByte()
  )
  
  return string.format("%s%s%s%s%s",
    bytes,
    self.colorTable2Array1:toByte(),
    self.colorTable2Array2:toByte(),
    self.colorTable2Array3:toByte(),
    self.colorTable2Array4:toByte()
  )
end

function colorTable2Array:size()
  return int32.size() * 5
    + self.colorTable2Array1:size()
    + self.colorTable2Array2:size()
    + self.colorTable2Array3:size()
    + self.colorTable2Array4:size()
end

return colorTable2Array