local noteImages = require("notes.noteImages")
local noteArgs = require("notes.noteArgs")
local lmath = require("libraries.lmath")

local tap = require("notes.objects.tap")

local slide = tap:new(noteArgs.get())
slide.__index = slide

function slide:new(args)
  local obj = tap:new(args)
  
  obj.noteType = 2 -- SLIDE
  obj.targetStyle = 10 -- DIAMOND_TARGET
  obj.animationType = 22
  
  -- differences between tap and slide ??
  obj.unk24 = 19
  obj.unk26 = 17
  obj.unk28 = 0
  
  obj.image = noteImages.slideBase
  obj.arrow = noteImages.slideArrow
  
  return setmetatable(obj, self)
end

function slide:draw(t)
  local offset = self:getOffset(t, self.timestampMs)
  local w, h = love.graphics.getDimensions()
  
  local position = h * 0.60 - offset
  
  if position < -10 or position > h + 10 then
    return
  end
  
  local baseW, baseH = self.image:getDimensions()
  local arrowW, arrowH = self.arrow:getDimensions()
  
  love.graphics.setColor(self.noteColor)
  
  love.graphics.draw(self.arrow, w / 2, position, math.rad(-self.rotationFront), 1, 1, arrowW / 2, arrowH)
  love.graphics.draw(self.image, w / 2, position, 0, 1, 1, baseW / 2, baseH / 2)
  
  love.graphics.setColor(1, 1, 1)
end

function slide:update()
  Slab.BeginLayout("SelectedFlickLayout", {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Slide Rotation : ")
  
  Slab.SetLayoutColumn(2)

  if Slab.Input("RotationInput", {W = 120, Text = self.rotationFront, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.rotationFront = lmath.clamp(input, -180, 180)
  end
  
  Slab.EndLayout()
  
  tap.update(self)
end

return slide
