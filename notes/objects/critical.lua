local noteImages = require("notes.noteImages")
local noteArgs = require("notes.noteArgs")

local tap = require("notes.objects.tap")

local critical = tap:new(noteArgs.get())
critical.__index = critical

function critical:new(args)
  local obj = tap:new(args)
  
  obj.noteType = 9 -- CRITICAL
  obj.targetStyle = 32 -- TARGET_CRITICAL
  obj.hitTrailStyle = 15 -- STYLE_CRITICAL
  obj.hitTrailSize = 19
  obj.unk28 = 0
  
  obj.image = noteImages.critical
  
  return setmetatable(obj, self)
end

return critical