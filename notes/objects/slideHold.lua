local noteImages = require("notes.noteImages")
local noteArgs = require("notes.noteArgs")
local lmath = require("libraries.lmath")

local hold = require("notes.objects.hold")

local slideHold = hold:new(noteArgs.get())
slideHold.__index = slideHold

function slideHold:new(args)
  local obj = hold:new(args)
  
  obj.noteType = 10 -- SLIDE HOLD
  obj.targetStyle = 21 -- ???
  obj.hitTrailSize = 4
  
  obj.image = noteImages.slideBase
  obj.arrow = noteImages.slideArrow
  
  obj.unk24 = 20
  obj.unk26 = 18
  obj.unk28 = 0
  
  return setmetatable(obj, self)
end

function slideHold:draw(t)
  local offsetHead = self:getOffset(t, self.timestampMs)
  local offsetTail = self:getOffset(t, self.endTimestampMs)
  
  local w, h = love.graphics.getDimensions()
  
  local headPosition = h * 0.60 - offsetHead
  local tailPosition = h * 0.60 - offsetTail
  
  if (headPosition < -10 and tailPosition < -10) or (headPosition > h + 10 and tailPosition > h + 10) then
    return
  end
  
  local baseW, baseH = self.image:getDimensions()
  local arrowW, arrowH = self.arrow:getDimensions()
  local bodyW, bodyH = self.body:getDimensions()
  
  local bodyScale = offsetTail - offsetHead
  
  love.graphics.setColor(self.noteColor[1], self.noteColor[2], self.noteColor[3], 0.40)
  
  love.graphics.draw(self.body, w / 2, headPosition, 0, 1, bodyScale, bodyW / 2, bodyH)
  
  love.graphics.setColor(self.noteColor)
  
  love.graphics.draw(self.arrow, w / 2, headPosition, math.rad(-self.rotationFront), 1, 1, arrowW / 2, arrowH)
  love.graphics.draw(self.image, w / 2, headPosition, 0, 1, 1, baseW / 2, baseH / 2)
  
  love.graphics.draw(self.arrow, w / 2, tailPosition, math.rad(-self.rotationFront), 1, 1, arrowW / 2, arrowH)
  love.graphics.draw(self.image, w / 2, tailPosition, 0, 1, 1, baseW / 2, baseH / 2)
  
  love.graphics.setColor(1, 1, 1)
end

function slideHold:update()
  Slab.BeginLayout("SelectedSlideHoldLayout", {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Slide Rotation : ")
  
  Slab.SetLayoutColumn(2)

  if Slab.Input("RotationInput", {W = 120, Text = self.rotationFront, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.rotationFront = lmath.clamp(input, -180, 180)
  end
  
  Slab.EndLayout()
  
  hold.update(self)
end

return slideHold