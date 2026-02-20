local note = require("export.structs.note")
local int32 = require("export.variableTypes.int32")
local char = require("export.variableTypes.char")

local noteExtArray = {}
noteExtArray.__index = noteExtArray

function noteExtArray:new(notes)
  local obj = {
    noteCount = 0,
    notes = {},
    unkNoteField0 = char:new(0),
    unkNoteField1 = char:new(0),
    unkNoteField2 = char:new(0)
  }
  
  local index = 1
  local takenNotes = {}
  
  for i,v in pairs (notes) do
    if v.noteType == 2 and v.isDualSlide == 1 then
      v.rotationFront = v.rotationFront2
      v.flyInRotationTop = v.flyInRotationTop2
      v.noteNumber = index - 1
      
      takenNotes[index] = v
      index = index + 1
    end
  end
  
  if index > 1 then
    takenNotes[1].noteNumber = index
  
    for i,v in pairs (takenNotes) do
      obj.notes[i] = note:new(v)
    end
    
    obj.noteCount = index
  end

  return setmetatable(obj, self)
end

function noteExtArray:toByte()
  local bytes = ""

  for _,v in pairs (self.notes) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  bytes = string.format("%s%s%s%s",
    bytes,
    self.unkNoteField0:toByte(),
    self.unkNoteField1:toByte(),
    self.unkNoteField2:toByte()
  )
  
  return bytes
end

function noteExtArray:size()
  return note.size() * self.noteCount + char.size() * 3
end

return noteExtArray