local noteImages = require("notes.noteImages")
local noteArgs = require("notes.noteArgs")

local tap = require("notes.objects.tap")

local adlib = tap:new(noteArgs.get())
adlib.__index = adlib

function adlib:new(args)
  local obj = tap:new(args)
  
  obj.adlibType = 2
  obj.hitTrailSize = 4
  obj.animationType = 25
  
  obj.unk28 = 1
  
  obj.image = noteImages.adlib
  
  return setmetatable(obj, self)
end

return adlib