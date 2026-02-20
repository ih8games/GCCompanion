local stackObject = require("common.stackObject")

local scalingObject = stackObject:new()
scalingObject.__index = scalingObject

function scalingObject:new()
  local obj = stackObject:new()
  
  obj.timestampMs = 0
  obj.tweenTowardsBool = 0
  obj.tweenAwayBool = 0
  obj.scale = {1, 1, 1}
  
  return setmetatable(obj, self)
end

function scalingObject:fromArguments(args)
  local obj = stackObject:new()
  
  obj.timestampMs = args[1]
  obj.tweenTowardsBool = args[2]
  obj.tweenAwayBool = args[3]
  obj.scale = {args[4], args[5], args[6]}
  
  return setmetatable(obj, self)
end

function scalingObject:output()
  return string.format("%d,%d,%d,%f,%f,%f",
    self.timestampMs,
    self.tweenTowardsBool,
    self.tweenAwayBool,
    self.scale[1],
    self.scale[2],
    self.scale[3]
  )
end

function scalingObject:update(i)
  self.header = string.format("[%d] : Scaling Object", i)
  stackObject.update(self)
  
  if not self.expanded then
    return
  end
  
  Slab.Separator()
  Slab.BeginLayout("ScalingLayout" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Timestamp MS : ")
  
  Slab.SetLayoutColumn(2)

  if Slab.Input("MSInput" .. self.id, {W = 240, Text = self.timestampMs, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.timestampMs = math.floor(math.abs(input))
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Scale (X, Y, Z) : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("ScaleX" .. self.id, {W = 80, Text = self.scale[1], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 1
    self.scale[1] = input
  end
  
  Slab.SameLine()
  
  if Slab.Input("ScaleY" .. self.id, {W = 80, Text = self.scale[2], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 1
    self.scale[2] = input
  end
  
  Slab.SameLine()
  
  if Slab.Input("ScaleZ" .. self.id, {W = 80, Text = self.scale[3], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 1
    self.scale[3] = input
  end
  
  Slab.EndLayout()
  
  Slab.Separator()
  Slab.BeginLayout("ScalingLayout2" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  
  if Slab.CheckBox(self.tweenTowardsBool == 1, "Repeat", {Tooltip = "Used to repeat a series of scaling changes"}) then
    self.tweenTowardsBool = (self.tweenTowardsBool + 1) % 2
  end
  
  Slab.SetLayoutColumn(2)
  
  if Slab.CheckBox(self.tweenAwayBool == 1, "Tween To", {Tooltip = "Tween to the next scaling value"}) then
    self.tweenAwayBool = (self.tweenAwayBool + 1) % 2
  end
  
  Slab.EndLayout()
  Slab.Separator()
end

return scalingObject