local stackObject = require("common.stackObject")

local rotationObject = stackObject:new()
rotationObject.__index = rotationObject

function rotationObject:new()
  local obj = stackObject:new()
  
  obj.timestampMs = 0
  obj.tweenTowardsBool = 0
  obj.tweenAwayBool = 0
  obj.rotation = {0, 0, 0}
  
  return setmetatable(obj, self)
end

function rotationObject:fromArguments(args)
  local obj = stackObject:new()
  
  obj.timestampMs = args[1]
  obj.tweenTowardsBool = args[2]
  obj.tweenAwayBool = args[3]
  obj.rotation = {args[6], args[4], args[5]}
  
  return setmetatable(obj, self)
end

function rotationObject:output()
  return string.format("%d,%d,%d,%f,%f,%f",
    self.timestampMs,
    self.tweenTowardsBool,
    self.tweenAwayBool,
    self.rotation[2],
    self.rotation[3],
    self.rotation[1]
  )
end

function rotationObject:update(i)
  self.header = string.format("[%d] : Rotation Object", i)
  stackObject.update(self)
  
  if not self.expanded then
    return
  end
  
  Slab.Separator()
  Slab.BeginLayout("RotationLayout" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Timestamp MS : ")
  
  Slab.SetLayoutColumn(2)

  if Slab.Input("MSInput" .. self.id, {W = 240, Text = self.timestampMs, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.timestampMs = math.floor(math.abs(input))
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Rotation (X, Y, Z) : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("RotationX" .. self.id, {W = 75, Text = self.rotation[1], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.rotation[1] = input
  end
  
  Slab.SameLine()
  
  if Slab.Input("RotationY" .. self.id, {W = 75, Text = self.rotation[2], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.rotation[2] = input
  end
  
  Slab.SameLine()
  
  if Slab.Input("RotationZ" .. self.id, {W = 75, Text = self.rotation[3], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.rotation[3] = input
  end
  
  Slab.EndLayout()
  
  Slab.Separator()
  Slab.BeginLayout("RotationLayout2" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  
  if Slab.CheckBox(self.tweenTowardsBool == 1, "Repeat", {Tooltip = "Used to repeat a series of rotation changes"}) then
    self.tweenTowardsBool = (self.tweenTowardsBool + 1) % 2
  end
  
  Slab.SetLayoutColumn(2)
  
  if Slab.CheckBox(self.tweenAwayBool == 1, "Tween To", {Tooltip = "Tween to the next rotation value"}) then
    self.tweenAwayBool = (self.tweenAwayBool + 1) % 2
  end
  
  Slab.EndLayout()
  Slab.Separator()
end

return rotationObject