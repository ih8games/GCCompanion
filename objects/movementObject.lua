local stackObject = require("common.stackObject")

local movementObject = stackObject:new()
movementObject.__index = movementObject

function movementObject:new()
  local obj = stackObject:new()
  
  obj.timestampMs = 0
  obj.tweenTowardsBool = 0
  obj.tweenAwayBool = 0
  obj.position = {0, 0, 0}
  
  return setmetatable(obj, self)
end

function movementObject:fromArguments(args)
  local obj = stackObject:new()
  
  obj.timestampMs = args[1]
  obj.tweenTowardsBool = args[2]
  obj.tweenAwayBool = args[3]
  obj.position = {args[4], args[5], args[6]}
  
  return setmetatable(obj, self)
end

function movementObject:output()
  return string.format("%d,%d,%d,%f,%f,%f",
    self.timestampMs,
    self.tweenTowardsBool,
    self.tweenAwayBool,
    self.position[1],
    self.position[2],
    self.position[3]
  )
end

function movementObject:update(i)
  self.header = string.format("[%d] : Movement Object", i)
  stackObject.update(self)
  
  if not self.expanded then
    return
  end
  
  Slab.Separator()
  Slab.BeginLayout("MovementLayout" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Timestamp MS : ")
  
  Slab.SetLayoutColumn(2)

  if Slab.Input("MSInput" .. self.id, {W = 240, Text = self.timestampMs, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.timestampMs = math.floor(math.abs(input))
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Offset Position (X, Y, Z) : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("PositionX" .. self.id, {W = 75, Text = self.position[1], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.position[1] = input
  end
  
  Slab.SameLine()
  
  if Slab.Input("PositionY" .. self.id, {W = 75, Text = self.position[2], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.position[2] = input
  end
  
  Slab.SameLine()
  
  if Slab.Input("PositionZ" .. self.id, {W = 75, Text = self.position[3], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.position[3] = input
  end
  
  Slab.EndLayout()
  
  Slab.Separator()
  Slab.BeginLayout("MovementLayout2" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  
  if Slab.CheckBox(self.tweenTowardsBool == 1, "Repeat", {Tooltip = "Used to repeat a series of position changes"}) then
    self.tweenTowardsBool = (self.tweenTowardsBool + 1) % 2
  end
  
  Slab.SetLayoutColumn(2)
  
  if Slab.CheckBox(self.tweenAwayBool == 1, "Tween To", {Tooltip = "Tween to the next position"}) then
    self.tweenAwayBool = (self.tweenAwayBool + 1) % 2
  end
  
  Slab.EndLayout()
end

return movementObject