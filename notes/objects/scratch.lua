local noteImages = require("notes.noteImages")
local noteArgs = require("notes.noteArgs")

local hold = require("notes.objects.hold")

local scratch = hold:new(noteArgs.get())
scratch.__index = scratch

function scratch:new(args)
  local obj = hold:new(args)
  
  obj.noteType = 4 -- SCRATCH
  obj.targetStyle = 11 -- ???
  obj.hitTrailSize = 4
  
  obj.image = noteImages.scratchHead
  obj.tail = noteImages.scratchTail
  
  obj.unk24 = 20
  obj.unk26 = 18
  obj.unk28 = 0
  
  return setmetatable(obj, self)
end

return scratch