local color = require("export.variableTypes.color")
local float = require("export.variableTypes.float")
local int32 = require("export.variableTypes.int32")
local int16 = require("export.variableTypes.int16")
local char = require("export.variableTypes.char")

local note = {}
note.__index = note

function note:new(n)
  local obj = {
    unk0 = float:new(n.unk0),
    noteNumber = int32:new(n.noteNumber),
    timestampMs = int32:new(n.timestampMs),
    noteType = char:new(n.noteType),
    adlibType = char:new(n.adlibType),
    adlibVisibleBool = char:new(n.adlibVisibleBool),
    targetStyle = char:new(n.targetStyle),
    hitTrailStyle = int16:new(n.hitTrailStyle),
    hitTrailSize = int16:new(n.hitTrailSize),
    animationType = int16:new(n.animationType),
    unk22 = int16:new(n.unk22),
    unk24 = int16:new(n.unk24),
    unk26 = int16:new(n.unk26),
    unk28 = int16:new(n.unk28),
    unk30 = int16:new(n.unk30),
    unk32 = char:new(n.unk32),
    flyInDistance = float:new(n.flyInDistance),
    rotationFront = float:new(n.rotationFront),
    flyInRotationTop = float:new(n.flyInRotationTop),
    flyInBool = char:new(n.flyInBool),
    showFlyInLineBool = char:new(n.showFlyInLineBool),
    noteAppearanceTimeBeats = float:new(n.noteAppearanceTimeBeats),
    flyDelayTimeBeats = float:new(n.flyDelayTimeBeats),
    flyEndTimeBeats = float:new(n.flyEndTimeBeats),
    holdTimeBeats = float:new(n.holdTimeBeats),
    noteColor = color:new(n.noteColor),
    hitTrailMaskColor = color:new(n.hitTrailMaskColor),
    flyAnimationRepeatCount = int32:new(n.flyAnimationRepeatCount),
    unk75 = float:new(n.unk75),
    unk79 = int32:new(n.unk79),
    unk83 = float:new(n.unk83),
    unk87 = float:new(n.unk87),
    unk91 = float:new(n.unk91),
    unk95 = float:new(n.unk95),
    
    isDualSlide = n.isDualSlide
  }
  
  return setmetatable(obj, self)
end

function note:toByte()
  return string.format("%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
    self.unk0:toByte(),
    self.noteNumber:toByte(),
    self.timestampMs:toByte(),
    self.noteType:toByte(),
    self.adlibType:toByte(),
    self.adlibVisibleBool:toByte(),
    self.targetStyle:toByte(),
    self.hitTrailStyle:toByte(),
    self.hitTrailSize:toByte(),
    self.animationType:toByte(),
    self.unk22:toByte(),
    self.unk24:toByte(),
    self.unk26:toByte(),
    self.unk28:toByte(),
    self.unk30:toByte(),
    self.unk32:toByte(),
    self.flyInDistance:toByte(),
    self.rotationFront:toByte(),
    self.flyInRotationTop:toByte(),
    self.flyInBool:toByte(),
    self.showFlyInLineBool:toByte(),
    self.noteAppearanceTimeBeats:toByte(),
    self.flyDelayTimeBeats:toByte(),
    self.flyEndTimeBeats:toByte(),
    self.holdTimeBeats:toByte(),
    self.noteColor:toByte(),
    self.hitTrailMaskColor:toByte(),
    self.flyAnimationRepeatCount:toByte(),
    self.unk75:toByte(),
    self.unk79:toByte(),
    self.unk83:toByte(),
    self.unk87:toByte(),
    self.unk91:toByte(),
    self.unk95:toByte()
  )
end

function note:size()
  return color.size() * 2 + float.size() * 13 + int32.size() * 4 + int16.size() * 8 + char.size() * 7
end

return note