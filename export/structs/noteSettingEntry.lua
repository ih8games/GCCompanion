local int16 = require("export.variableTypes.int16")
local int32 = require("export.variableTypes.int32")
local float = require("export.variableTypes.float")

local noteSettingEntry = {}
noteSettingEntry.__index = noteSettingEntry

function noteSettingEntry:new(noteSetting)
  local obj = {
    length = int16:new(1),
    unk0 = int32:new(noteSetting[1]),
    unk4 = int32:new(noteSetting[2]),
    unk8 = float:new(noteSetting[3])
  }
  
  return setmetatable(obj, self)
end

function noteSettingEntry:toByte()
  return string.format("%s%s%s%s",
    self.length:toByte(),
    self.unk0:toByte(), 
    self.unk4:toByte(), 
    self.unk8:toByte()
  )
end

function noteSettingEntry:size()
  return int32.size() * 2 + float.size() + int16.size()
end

return noteSettingEntry