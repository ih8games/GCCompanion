local stackObject = require("common.stackObject")

local avatarColorObject = stackObject:new()
avatarColorObject.__index = avatarColorObject

function avatarColorObject:new()
  local obj = stackObject:new()
  
  obj.timestampMs = 0
  obj.avatarColor = {1, 1, 1, 1}
  obj.unkBool = 0
  obj.displayColor = false
  
  return setmetatable(obj, self)
end

function avatarColorObject:output()
  return string.format("%d,%d,%d,%d,%d,
    self.timestampMs,
    self.avatarColor[1] * 255,
    self.avatarColor[2] * 255,
    self.avatarColor[3] * 255,
    self.avatarColor[4] * 255,
    self.unkBool
  )
end

function avatarColorObject:update(i)
  self.header = string.format("[%d] : Avatar Color Object", i - 1)
  stackObject.update(self)
  
  if not self.expanded then
    return
  end
  
  Slab.Separator()
  Slab.BeginLayout("AvatarColorLayout" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Timestamp MS : ")

  Slab.SetLayoutColumn(2)

  if Slab.Input("MSInput" .. self.id, {W = 240, Text = self.timestampMs, ReturnOnText = false, NumbersOnly = true}) then
    -- cannot be changed directly
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Avatar Color : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Button("", {W = 240, H = 16, Color = self.avatarColor}) then
    self.displayColor = not self.displayColor
  end
  
  Slab.SetLayoutColumn(1)
  
  if Slab.CheckBox(self.unkBool == 1, "unknown") then
    self.unkBool = (self.unkBool + 1) % 2
  end
  
  Slab.EndLayout()
  Slab.Separator()

  if not self.displayColor then
    return
  end
  
  local w, h = love.graphics.getDimensions()
  
  local x = (w / 2) + 320
  local y = (h / 2) - 300
  
  local out = Slab.ColorPicker({Color = self.color, X = x, Y = y})
  
  if out.Button == 1 then
    self.avatarColor = out.Color
    self.displayColor = false
    
  elseif out.Button == -1 then
    self.displayColor = false
  end
end

return avatarColorObject