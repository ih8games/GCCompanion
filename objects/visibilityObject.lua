local stackObject = require("common.stackObject")

local visibilityObject = stackObject:new()
visibilityObject.__index = visibilityObject

function visibilityObject:new()
  local obj = stackObject:new()
  
  obj.timestampMs = 0
  obj.fadeOutBool = 0
  obj.fadeInBool = 0
  obj.visibleBool = 0
  
  return setmetatable(obj, self)
end

function visibilityObject:fromArguments(args)
  local obj = stackObject:new()
  
  obj.timestampMs = args[1]
  obj.fadeOutBool = args[2]
  obj.fadeInBool = args[3]
  obj.visibleBool = args[4]
  
  return setmetatable(obj, self)
end

function visibilityObject:output()
  return string.format("%d,%d,%d,%d",
    self.timestampMs,
    self.fadeOutBool,
    self.fadeInBool,
    self.visibleBool
  )
end

function visibilityObject:update(i)
  self.header = string.format("[%d] : Visibility Object", i)
  stackObject.update(self)
  
  if not self.expanded then
    return
  end
  
  Slab.Separator()
  Slab.BeginLayout("VisibilityLayout" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Timestamp MS : ")
  
  Slab.SetLayoutColumn(2)

  if Slab.Input("MSInput" .. self.id, {W = 240, Text = self.timestampMs, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.timestampMs = math.floor(math.abs(input))
  end
  
  Slab.EndLayout()
  
  Slab.Separator()
  Slab.BeginLayout("VisibilityLayout2" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 3})
  
  Slab.SetLayoutColumn(1)
  
  if Slab.CheckBox(self.fadeOutBool == 1, "Repeat", {Tooltip = "Used for repeating a series of visibility changes"}) then
    self.fadeOutBool = (self.fadeOutBool + 1) % 2
  end
  
  Slab.SetLayoutColumn(2)
  
  if Slab.CheckBox(self.fadeInBool == 1, "Fade In", {Tooltip = "Fade in or out, depending on the visibility"}) then
    self.fadeInBool = (self.fadeInBool + 1) % 2
  end
  
  Slab.SetLayoutColumn(3)
  
  if Slab.CheckBox(self.visibleBool == 1, "Visible", {Tooltip = "Visible or not"}) then
    self.visibleBool = (self.visibleBool + 1) % 2
  end
  
  Slab.EndLayout()
  Slab.Separator()
end

return visibilityObject