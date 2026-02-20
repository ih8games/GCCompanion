local stackObject = require("common.stackObject")

local colorObject = stackObject:new()
colorObject.__index = colorObject

local defaultColor = {0, 0, 0, 1}

function colorObject:new()
  local obj = stackObject:new()
  
  obj.timestampMs = 0
  
  obj.topRightColor = defaultColor
  obj.topLeftColor = defaultColor
  obj.bottomRightColor = defaultColor
  obj.bottomLeftColor = defaultColor
  
  obj.fadeOutBool = 0
  obj.fadeInBool = 0
  
  obj.colorTable2Visible = 0
  obj.centerColor = defaultColor
  obj.topColor = defaultColor
  obj.bottomColor = defaultColor
  obj.leftColor = defaultColor
  obj.rightColor = defaultColor

  obj.displayColor = nil
  
  return setmetatable(obj, self)
end

function colorObject:fromArguments(args1, args2)
  local obj = stackObject:new()
  
  obj.timestampMs = args1.timestampMs
  
  obj.topRightColor = args1.topRight
  obj.topLeftColor = args1.topLeft
  obj.bottomRightColor = args1.bottomRight
  obj.bottomLeftColor = args1.bottomLeft
  
  obj.fadeOutBool = args1.fadeOutBool
  obj.fadeInBool = args1.fadeInBool
  
  obj.colorTable2Visible = args2.visibleBool
  obj.centerColor = args2.center
  obj.topColor = args2.top
  obj.bottomColor = args2.bottom
  obj.leftColor = args2.left
  obj.rightColor = args2.right

  obj.displayColor = nil
  
  return setmetatable(obj, self)
end

function colorObject:output()
  local ct1
  local ct2
  
  -- another unholy abomination of a function
  
  ct1 = string.format(
    "%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\r\n",
    
    self.timestampMs,
    
    math.floor(self.topRightColor[1] * 255 + 0.50),
    math.floor(self.topRightColor[2] * 255 + 0.50),
    math.floor(self.topRightColor[3] * 255 + 0.50),
    math.floor(self.topRightColor[4] * 255 + 0.50),
    
    math.floor(self.topLeftColor[1] * 255 + 0.50),
    math.floor(self.topLeftColor[2] * 255 + 0.50),
    math.floor(self.topLeftColor[3] * 255 + 0.50),
    math.floor(self.topLeftColor[4] * 255 + 0.50),
    
    math.floor(self.bottomRightColor[1] * 255 + 0.50),
    math.floor(self.bottomRightColor[2] * 255 + 0.50),
    math.floor(self.bottomRightColor[3] * 255 + 0.50),
    math.floor(self.bottomRightColor[4] * 255 + 0.50),
    
    math.floor(self.bottomLeftColor[1] * 255 + 0.50),
    math.floor(self.bottomLeftColor[2] * 255 + 0.50),
    math.floor(self.bottomLeftColor[3] * 255 + 0.50),
    math.floor(self.bottomLeftColor[4] * 255 + 0.50),
    
    self.fadeOutBool,
    self.fadeInBool
  )
  
  ct2 = string.format(
    "%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\r\n",
    
    self.colorTable2Visible,
    
    math.floor(self.centerColor[1] * 255 + 0.50),
    math.floor(self.centerColor[2] * 255 + 0.50),
    math.floor(self.centerColor[3] * 255 + 0.50),
    math.floor(self.centerColor[4] * 255 + 0.50),
    
    math.floor(self.topColor[1] * 255 + 0.50),
    math.floor(self.topColor[2] * 255 + 0.50),
    math.floor(self.topColor[3] * 255 + 0.50),
    math.floor(self.topColor[4] * 255 + 0.50),
    
    math.floor(self.bottomColor[1] * 255 + 0.50),
    math.floor(self.bottomColor[2] * 255 + 0.50),
    math.floor(self.bottomColor[3] * 255 + 0.50),
    math.floor(self.bottomColor[4] * 255 + 0.50),
    
    math.floor(self.leftColor[1] * 255 + 0.50),
    math.floor(self.leftColor[2] * 255 + 0.50),
    math.floor(self.leftColor[3] * 255 + 0.50),
    math.floor(self.leftColor[4] * 255 + 0.50),
    
    math.floor(self.rightColor[1] * 255 + 0.50),
    math.floor(self.rightColor[2] * 255 + 0.50),
    math.floor(self.rightColor[3] * 255 + 0.50),
    math.floor(self.rightColor[4] * 255 + 0.50)
  )
  
  return ct1, ct2
end

function colorObject:update(i)
  self.header = string.format("[%d] : Color Object", i)
  stackObject.update(self)
  
  if not self.expanded then
    return
  end
  
  local h = 16
  local displayColor
  
  Slab.Separator()
  Slab.BeginLayout("BackgroundColorLayout" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Timestamp MS : ")
  
  Slab.SetLayoutColumn(2)

  if Slab.Input("MSInput" .. self.id, {W = 240, Text = self.timestampMs, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.timestampMs = math.floor(math.abs(input))
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Top Right Color : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Button("", {W = 240, H = h, Color = self.topRightColor}) then
    displayColor = "topRightColor"
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Top Left Color : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Button("", {W = 240, H = h,  Color = self.topLeftColor}) then
    displayColor = "topLeftColor"
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Bottom Right Color : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Button("", {W = 240, H = h, Color = self.bottomRightColor}) then
    displayColor = "bottomRightColor"
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Bottom Left Color : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Button("", {W = 240, H = h, Color = self.bottomLeftColor}) then
    displayColor = "bottomLeftColor"
  end
  
  Slab.EndLayout()
  
  Slab.Separator()
  Slab.BeginLayout("ExpandLayout2" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 3})
  
  Slab.SetLayoutColumn(1)
  
  if Slab.CheckBox(self.fadeOutBool == 1, "Fade Out", {Tooltip = "Tween to the next Color Values"}) then
    self.fadeOutBool = (self.fadeOutBool + 1) % 2
  end

  Slab.SetLayoutColumn(2)
  
  if Slab.CheckBox(self.fadeInBool == 1, "Flash Colors", {Tooltip = "Flash colors to the beat of the song"}) then
    self.fadeInBool = (self.fadeInBool + 1) % 2
  end

  Slab.SetLayoutColumn(3)
  
  if Slab.CheckBox(self.colorTable2Visible == 1, "Use Extra Table", {Tooltip = "Gain access to extra Gradient points"}) then
    self.colorTable2Visible = (self.colorTable2Visible + 1) % 2
  end
  
  Slab.EndLayout()
  Slab.Separator()
  
  if self.colorTable2Visible == 0 then
    goto SKIP_COLOR_TABLE_2
  end
  
  Slab.BeginLayout("ExpandLayout3" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Center Color : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Button("", {W = 240, H = h, Color = self.centerColor}) then
    displayColor = "centerColor"
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Top Color : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Button("", {W = 240, H = h, Color = self.topColor}) then
    displayColor = "topColor"
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Bottom Color : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Button("", {W = 240, H = h,  Color = self.bottomColor}) then
    displayColor = "bottomColor"
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Left Color : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Button("", {W = 240, H = h, Color = self.leftColor}) then
    displayColor = "leftColor"
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Right Color : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Button("", {W = 240, H = h, Color = self.rightColor}) then
    displayColor = "rightColor"
  end
  
  Slab.EndLayout()
  Slab.Separator()
  
  ::SKIP_COLOR_TABLE_2::
  
  if displayColor == self.displayColor then
    self.displayColor = nil
    
  elseif displayColor then
    self.displayColor = displayColor
  end
  
  if not self.displayColor then
    return
  end
  
  local w, h = love.graphics.getDimensions()
  
  local x = (w / 2) + 320
  local y = (h / 2) - 300
  
  local out = Slab.ColorPicker({Color = self[self.displayColor], X = x, Y = y})
  
  if out.Button == 1 then
    self[self.displayColor] = out.Color
    self.displayColor = nil
    
  elseif out.Button == -1 then
    self.displayColor = nil
  end
end

return colorObject