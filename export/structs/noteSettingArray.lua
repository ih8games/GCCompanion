local noteSettingEntry = require("export.structs.noteSettingEntry")

local noteSettingArray = {}
noteSettingArray.__index = noteSettingArray

function noteSettingArray:new(noteSettings)
  local obj = {
    noteSettings =  {}
  }
  
  for i,v in pairs (noteSettings) do
    obj.noteSettings[i] = noteSettingEntry:new(v)
  end
  
  return setmetatable(obj, self)
end

function noteSettingArray:toByte()
  local bytes = ""
  
  for _,v in pairs (self.noteSettings) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  return bytes
end

function noteSettingArray:size()
  return noteSettingEntry.size() * 4
end

return noteSettingArray