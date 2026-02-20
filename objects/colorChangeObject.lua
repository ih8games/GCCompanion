local stackObject = require("common.stackObject")

local colorChangeObject = stackObject:new()
colorChangeObject.__index = colorChangeObject

function colorChangeObject:new()
  local obj = stackObject:new()
  
  obj.timestampMs = 0
  obj.fadeOutBool = 0
  obj.fadeInBool = 0
  obj.color = {0, 0, 0, 1}
  
  obj.displayColor = false
  
  return setmetatable(obj, self)
end

function colorChangeObject:fromArguments(args)
  local obj = stackObject:new()
  
  obj.timestampMs = args[1]
  obj.fadeOutBool = args[2]
  obj.fadeInBool = args[3]
  obj.color = {args[4] / 255, args[5] / 255, args[6] / 255, args[7] / 255}
  
  obj.displayColor = false
  
  return setmetatable(obj, self)
end

function colorChangeObject:output()
  return string.format("%d,%d,%d,%d,%d,%d,%d",
    self.timestampMs,
    self.fadeOutBool,
    self.fadeInBool,
    math.floor(self.color[1] * 255 + 0.50),
    math.floor(self.color[2] * 255 + 0.50),
    math.floor(self.color[3] * 255 + 0.50),
    math.floor(self.color[4] * 255 + 0.50)
  )
end

function colorChangeObject:update(i)
  self.header = string.format("[%d] : Color Change Object", i)
  stackObject.update(self)
  
  if not self.expanded then
    return
  end
  
  Slab.Separator()
  Slab.BeginLayout("ColorChangeLayout" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Timestamp MS : ")
  
  Slab.SetLayoutColumn(2)

  if Slab.Input("MSInput" .. self.id, {W = 240, Text = self.timestampMs, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.timestampMs = math.floor(math.abs(input))
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Color : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Button("", {W = 240, H = 16, Color = self.color}) then
    self.displayColor = not self.displayColor
  end
  
  Slab.EndLayout()
  
  Slab.Separator()
  Slab.BeginLayout("ColorChangeLayout2" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  
  if Slab.CheckBox(self.fadeOutBool == 1, "Repeat", {Tooltip = "Used to repeat a series of color changes"}) then
    self.fadeOutBool = (self.fadeOutBool + 1) % 2
  end
  
  Slab.SetLayoutColumn(2)
  
  if Slab.CheckBox(self.fadeInBool == 1, "Tween To", {Tooltip = "Tween to the next color value"}) then
    self.fadeInBool = (self.fadeInBool + 1) % 2
  end
  
  Slab.EndLayout()
  Slab.Separator()
  
  if not self.displayColor then
    return
  end
  
  local out = Slab.ColorPicker({Color = self.color})
  
  if out.Button == 1 then
    self.color = out.Color
    self.displayColor = false
    
  elseif out.Button == -1 then
    self.displayColor = false
  end
end

return colorChangeObject