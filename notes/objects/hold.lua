local noteImages = require("notes.noteImages")
local noteArgs = require("notes.noteArgs")

local tap = require("notes.objects.tap")

local hold = tap:new(noteArgs.get())
hold.__index = hold

function hold:new(args)
  local obj = tap:new(args)
  
  obj.noteType = 3 -- HOLD
  obj.targetStyle = 9 -- MULTIRING_TARGET
  obj.hitTrailStyle = 21 -- STYLE_21
  obj.animationType = 25 -- ???
  
  obj.unk24 = 18
  obj.unk26 = 16
  obj.unk28 = 2
  
  obj.image = noteImages.holdHead
  obj.body = noteImages.holdBody
  obj.tail = noteImages.holdTail
  
  return setmetatable(obj, self)
end

function hold:check(note)
  if note.endTimestampMs > 0 then
    if note.endTimestampMs < self.timestampMs or note.timestampMs > self.endTimestampMs then
      return false
    end
    
    return true
  end
  
  return self.timestampMs <= note.timestampMs and self.endTimestampMs >= note.timestampMs
end

function hold:draw(t)
  local offsetHead = self:getOffset(t, self.timestampMs)
  local offsetTail = self:getOffset(t, self.endTimestampMs)
  
  local w, h = love.graphics.getDimensions()
  
  local headPosition = h * 0.60 - offsetHead
  local tailPosition = h * 0.60 - offsetTail
  
  if (headPosition < -10 and tailPosition < -10) or (headPosition > h + 10 and tailPosition > h + 10) then
    return
  end
  
  local headW, headH = self.image:getDimensions()
  local bodyW, bodyH = self.body:getDimensions() 
  local tailW, tailH = self.tail:getDimensions()
  
  local bodyScale = offsetTail - offsetHead
  
  love.graphics.setColor(self.noteColor[1], self.noteColor[2], self.noteColor[3], 0.40)
  
  love.graphics.draw(self.body, w / 2, headPosition, 0, 1, bodyScale, bodyW / 2, bodyH)
  
  love.graphics.setColor(self.noteColor)
  
  love.graphics.draw(self.image, w / 2, headPosition, 0, 1, 1, headW / 2, headH / 2)
  love.graphics.draw(self.tail, w / 2, tailPosition, 0, 1, 1, tailW / 2, tailH / 2) 
  
  love.graphics.setColor(1, 1, 1)
end

return hold