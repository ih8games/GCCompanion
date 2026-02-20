local note = require("export.structs.note")
local int32 = require("export.variableTypes.int32")

local noteArray = {}
noteArray.__index = noteArray

function noteArray:new(notes)
  local obj = {
    notes = {},
    unkNotesField0 = int32:new(0),
    noteCount2 = int32:new(#notes)
  }

  for i,v in pairs (notes) do
    obj.notes[i] = note:new(v)
  end
  
  return setmetatable(obj, self)
end

function noteArray:toByte()
  local bytes = ""

  for _,v in pairs (self.notes) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  bytes = string.format("%s%s%s",
    bytes,
    self.unkNotesField0:toByte(),
    self.noteCount2:toByte()
  )
  
  return bytes
end

function noteArray:size()
  return note.size() * self.noteCount2.x + int32.size() * 2
end

return noteArray