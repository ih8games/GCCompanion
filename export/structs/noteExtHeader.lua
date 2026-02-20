local int16 = require("export.variableTypes.int16")
local int32 = require("export.variableTypes.int32")
local float = require("export.variableTypes.float")
local char = require("export.variableTypes.char")

local noteSettingArray = require("export.structs.noteSettingArray")

local extHeader = {}
extHeader.__index = extHeader

local noteSettings = {
  {0, 0, 0.50},
  {0, 0, 0.50},
  {0, 0, 0.50},
  {0, 0, 0.50},
}

function extHeader:new()
  local obj = {
    unk0 = char:new(2),
    unkPointer = int32:new(),
    unk5 = char:new(1),
    noteSettingArray = noteSettingArray:new(noteSettings)
  }
  
  return setmetatable(obj, self)
end

function extHeader:toByte()
  return string.format("%s%s%s%s",
    self.unk0:toByte(),
    self.unkPointer:toByte(),
    self.unk5:toByte(),
    self.noteSettingArray:toByte()
  )
end

function extHeader:size()
  return char.size() * 2 + int32.size() + noteSettingArray.size()
end

return extHeader