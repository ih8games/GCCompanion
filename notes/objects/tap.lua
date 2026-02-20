local noteImages = require("notes.noteImages")

local tap = {}
tap.__index = tap

-- what the fuck ?!
function tap:new(args)
  local obj = {
    noteNumber = args.noteNumber or 0,
    timestampMs = args.timestampMs or 0,
    endTimestampMs = args.endTimestampMs or 0,
    noteAppearanceTimeBeats = args.noteAppearanceTimeBeats or 8,
    
    noteType = 1, -- TAP
    adlibType = 0, -- NOT ADLIB
    adlibVisibleBool = 0,
    targetStyle = 1, --TAP
    
    hitTrailStyle = 14, -- REGULAR
    hitTrailSize = 4, -- REGULAR
    animationType = 26,

    rotationFront = args.rotationFront or 0,
    rotationFront2 = args.rotationFront2 or 0,
    holdTimeBeats = args.holdTimeBeats or 0,
    
    noteColor = args.noteColor or {1, 1, 1, 1},
    hitTrailMaskColor = args.hitTrailMaskColor or {1, 1, 1, 1},
    
    flyInBool = args.flyInBool or 0,
    showFlyInLineBool = args.showFlyInLineBool or 0,
    
    flyInDistance = args.flyInDistance or 0,
    flyInRotationTop = args.flyInRotationTop or 0,
    flyInRotationTop2 = args.flyInRotationTop2 or 0,
    flyDelayTimeBeats = args.flyDelayTimeBeats or 0,
    flyEndTimeBeats = args.flyEndTimeBeats or 0,
    flyAnimationRepeatCount = args.flyAnimationRepeatCount or 0,
    
    isDualSlide = args.isDualSlide or 0,
    
    -- not sure what they're for, format has them set to these constants, as far as i can tell
    unk0 = 0,
    unk22 = -1,
    unk24 = -1,
    unk26 = -1,
    unk28 = 1,
    unk30 = -1,
    unk32 = 0,
    unk75 = 1.40,
    unk79 = 4,
    unk83 = 1,
    unk87 = 45,
    unk91 = 0,
    unk95 = 1,
    
    image = noteImages.tap,
    displayColor = false
  }
  
  return setmetatable(obj, self)
end

function tap:getOffset(t, p)
  return (t + p) * 0.10
end

function tap:check(note)
  if note.endTimestampMs > 0 then
    return self.timestampMs >= note.timestampMs and self.timestampMs <= note.endTimestampMs
  end

  return self.timestampMs == note.timestampMs
end

function tap:draw(t)
  local offset = self:getOffset(t, self.timestampMs)
  local w, h = love.graphics.getDimensions()
  
  local position = h * 0.60 - offset
  
  if position < -10 or position > h + 10 then
    return
  end
  
  local imageW, imageH = self.image:getDimensions()
  
  love.graphics.setColor(self.noteColor)
  
  love.graphics.draw(self.image, w / 2, position, 0, 1, 1, imageW / 2, imageH / 2)
  
  love.graphics.setColor(1, 1, 1)
end

function tap:update()
  local displayColor = false
  local h = 16
  
  Slab.BeginLayout("SelectedNoteLayout", {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Note Appearance : ")
  
  Slab.SetLayoutColumn(2)

  if Slab.Input("ApppearanceInput", {W = 120, Text = self.noteAppearanceTimeBeats, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 8
    self.noteAppearanceTimeBeats = math.abs(input)
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Note Color : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Button("", {W = 120, H = h, Color = self.noteColor}) then
    displayColor = "noteColor"
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Hit Trail Color : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Button("", {W = 120, H = h, Color = self.hitTrailColor}) then
    displayColor = "hitTrailColor"
  end
  
  Slab.EndLayout()
  
  if displayColor == self.displayColor then
    self.displayColor = false
    
  elseif displayColor then
    self.displayColor = displayColor
  end
  
  if not self.displayColor then
    return
  end
  
  local w, h = love.graphics.getDimensions()
  
  local x = (w / 2) + 140
  local y = 50
  
  local out = Slab.ColorPicker({Color = self[self.displayColor], X = x, Y = y})
  
  if out.Button == 1 then
    self[self.displayColor] = out.Color
    self.displayColor = false
    
  elseif out.Button == -1 then
    self.displayColor = false
  end
end

-- if i don't look at this it's not that bad actually
function tap:output()
  return string.format("%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%f,%d,%d,%d,%d,%d,%d\r\n",
    self.unk0,
    self.noteNumber,
    self.timestampMs,
    self.endTimestampMs,
    self.noteType,
    self.adlibType,
    self.adlibVisibleBool,
    self.targetStyle,
    self.hitTrailStyle,
    self.hitTrailSize,
    self.animationType,
    self.unk22,
    self.unk24,
    self.unk26,
    self.unk28,
    self.unk30,
    self.unk32,
    self.flyInDistance,
    self.rotationFront,
    self.rotationFront2,
    self.flyInRotationTop,
    self.flyInRotationTop2,
    self.flyInBool,
    self.showFlyInLineBool,
    self.noteAppearanceTimeBeats,
    self.flyDelayTimeBeats,
    self.flyEndTimeBeats,
    self.holdTimeBeats,
    self.noteColor[1] * 255,
    self.noteColor[2] * 255,
    self.noteColor[3] * 255,
    self.noteColor[4] * 255,
    self.hitTrailMaskColor[1] * 255,
    self.hitTrailMaskColor[2] * 255,
    self.hitTrailMaskColor[3] * 255,
    self.hitTrailMaskColor[4] * 255,
    self.flyAnimationRepeatCount,
    self.unk75,
    self.unk79,
    self.unk83,
    self.unk87,
    self.unk91,
    self.unk95,
    self.isDualSlide
    )
end

return tap