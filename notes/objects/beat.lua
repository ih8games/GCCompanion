local noteImages = require("notes.noteImages")
local noteArgs = require("notes.noteArgs")

local hold = require("notes.objects.hold")

local beat = hold:new(noteArgs.get())
beat.__index = beat

function beat:new(args)
  local obj = hold:new(args)
  
  obj.noteType = 5 -- BEAT
  obj.targetStyle = 21 -- ???
  obj.hitTrailSize = 10
  
  obj.image = noteImages.beatHead
  obj.tail = noteImages.beatTail
  
  obj.unk24 = 21
  obj.unk26 = 19
  obj.unk28 = 1
  
  return setmetatable(obj, self)
end

return beat