local int16 = require("export.variableTypes.int16")
local int32 = require("export.variableTypes.int32")
local char = require("export.variableTypes.char")

local unknownObjectArray = require("export.structs.unknownObjectArray")

local unkType = {}
unkType.__index = unkType

function unkType:new(size)
  local obj = {
    unk0 = int16:new(0),
    unk2 = int16:new(0),
    unk4 = char:new(0),
    moreData = char:new(0),
    bytesRemaining = int32:new(),
    unknownArray = unknownObjectArray:new(size),
    unk = char:new(0)
  }
  
  return setmetatable(obj, self)
end

function unkType:toByte()
  return string.format("%s%s%s%s%s%s%s",
    self.unk0:toByte(),
    self.unk2:toByte(),
    self.unk4:toByte(),
    self.moreData:toByte(),
    self.bytesRemaining:toByte(),
    self.unknownArray:toByte(),
    self.unk:toByte()
  )
end

function unkType:size()
  return char.size() * 3 + int16.size() * 2 + int32.size() + self.unknownArray:size()
end

return unkType