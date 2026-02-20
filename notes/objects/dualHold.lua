local noteImages = require("notes.noteImages")
local noteArgs = require("notes.noteArgs")

local hold = require("notes.objects.hold")

local dualhold = hold:new(noteArgs.get())
dualhold.__index = dualhold

function dualhold:new(args)
  local obj = hold:new(args)
  
  obj.noteType = 15 -- DUAL_HOLD
  obj.targetStyle = 37 -- LARGE_CRITICAL
  obj.hitTrailSize = 10
  
  obj.image = noteImages.dualHoldHead
  obj.body = noteImages.dualHoldBody
  obj.tail = noteImages.dualHoldTail
  
  return setmetatable(obj, self)
end

return dualhold