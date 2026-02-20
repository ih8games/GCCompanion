local stack = require("common.stack")
local substack = require("common.substack")

local stackObject = require("common.stackObject")
local visibilityObject = require("objects.visibilityObject")
local movementObject = require("objects.movementObject")
local scalingObject = require("objects.scalingObject")
local rotationObject = require("objects.rotationObject")
local colorChangeObject = require("objects.colorChangeObject")

local objectObject = stackObject:new()
objectObject.__index = objectObject

function objectObject:new()
  local obj = stackObject:new()
  
  obj.modelName = ""
  obj.fs = -1
  obj.wireframeBool = 0
  obj.flashingBool = 0
  obj.unkBool1 = 0
  obj.position = {0, 0, 0}
  obj.scale = {1, 1, 1}
  obj.rotation = {0, 0, 0}
  obj.color = {0, 0, 0, 1}
  obj.unk = {0, 0, 0}
  
  obj.visibilityStack = substack:new("VisibilityStack", "Visibility", visibilityObject, "Visibility Stack Size : ")
  obj.movementStack = substack:new("MovementStack", "Movement", movementObject, "Movement Stack Size : ")
  obj.scalingStack = substack:new("ScalingStack", "Scaling", scalingObject, "Scaling Stack Size : ")
  obj.rotationStack = substack:new("RotationStacK", "Rotation", rotationObject, "Rotation Stack Size : ")
  obj.colorStack = substack:new("ColorStack", "Color", colorChangeObject, "Color Stack Size : ")
  
  obj.displayColor = false
  
  return setmetatable(obj, self)
end

function objectObject:fromArguments(args)
  local obj = stackObject:new()
  
  obj.modelName = args.modelName
  obj.fs = args.fs
  obj.wireframeBool = args.wireframeBool
  obj.flashingBool = args.flashingBool
  obj.unkBool1 = args.unkBool1
  obj.position = args.position
  obj.scale = args.scale
  obj.rotation = args.rotation
  obj.color = args.color
  obj.unk = args.unk
  
  local visibilityStack = substack:new("VisibilityStack", "Visibility", visibilityObject, "Visibility Stack Size : ")
  visibilityStack:set(#args.visibility)
  
  for i,v in pairs (visibilityStack.items) do
    visibilityStack.items[i] = visibilityObject:fromArguments(args.visibility[i])
  end
  
  local movementStack = substack:new("MovementStack", "Movement", movementObject, "Movement Stack Size : ")
  movementStack:set(#args.movements)
  
  for i,v in pairs (movementStack.items) do
    movementStack.items[i] = movementObject:fromArguments(args.movements[i])
  end
  
  local scalingStack = substack:new("ScalingStack", "Scaling", scalingObject, "Scaling Stack Size : ")
  scalingStack:set(#args.scalings)
  
  for i,v in pairs (scalingStack.items) do
    scalingStack.items[i] = scalingObject:fromArguments(args.scalings[i])
  end
  
  local rotationStack = substack:new("RotationStack", "Rotation", rotationObject, "Rotation Stack Size : ")
  rotationStack:set(#args.rotations)
  
  for i,v in pairs (rotationStack.items) do
    rotationStack.items[i] = rotationObject:fromArguments(args.rotations[i])
  end
  
  local colorStack = substack:new("ColorStack", "Color", colorChangeObject, "Color Stack Size : ")
  colorStack:set(#args.colorChanges)
  
  for i,v in pairs (colorStack.items) do
    colorStack.items[i] = colorChangeObject:fromArguments(args.colorChanges[i])
  end
  
  obj.visibilityStack = visibilityStack
  obj.movementStack = movementStack
  obj.scalingStack = scalingStack
  obj.rotationStack = rotationStack 
  obj.colorStack = colorStack
  
  return setmetatable(obj, self)
end

function objectObject:output()
  local csvLine = string.format("%s,%d,%d,%d,%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,",
    self.modelName,
    self.fs,
    self.wireframeBool,
    self.flashingBool,
    self.unkBool1,
    self.position[1], -- position confirmed correct
    self.position[2],
    self.position[3],
    self.scale[1],
    self.scale[2],
    self.scale[3],
    self.rotation[2],
    self.rotation[1],
    self.rotation[3],
    self.color[1],
    self.color[2],
    self.color[3],
    self.color[4],
    self.unk[1],
    self.unk[2],
    self.unk[3]
  )
  
  local visibilityLine = string.format("%d,", #self.visibilityStack.items)
  
  for i,v in pairs (self.visibilityStack.items) do
    visibilityLine = string.format("%s%s,", visibilityLine, v:output())
  end
  
  local movementLine = string.format("%d,", #self.movementStack.items)
  
  for i,v in pairs (self.movementStack.items) do
    movementLine = string.format("%s%s,", movementLine, v:output())
  end
  
  local scalingLine = string.format("%d,", #self.scalingStack.items)
  
  for i,v in pairs (self.scalingStack.items) do
    scalingLine = string.format("%s%s,", scalingLine, v:output())
  end
  
  local rotationLine = string.format("%d,", #self.rotationStack.items)
  
  for i,v in pairs (self.rotationStack.items) do
    rotationLine = string.format("%s%s,", rotationLine, v:output())
  end
  
  local colorLine = string.format("%d,", #self.colorStack.items)
  
  for i,v in pairs (self.colorStack.items) do
    colorLine = string.format("%s%s,", colorLine, v:output())
  end
  
  csvLine = string.format("%s%s%s%s%s%s\r\n",
    csvLine,
    visibilityLine,
    movementLine,
    scalingLine,
    rotationLine,
    colorLine
  )
  
  return csvLine
end

function objectObject:update(i)
  if self.modelName == "" or self.modelName == nil then
    self.header = string.format("[%d] : %s", i, "Object")
    
  else
    self.header = string.format("[%d] : %s", i, self.modelName)
  end
  
  stackObject.update(self)
  
  if not self.expanded then
    return
  end
  
  Slab.Separator()
  Slab.BeginLayout("ObjectLayout" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Model Name : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("ModelNameInput" .. self.id, {W = 240, Text = self.modelName, ReturnOnText = false}) then
    self.modelName = tostring(Slab.GetInputText()) or ""
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Position (X, Y, Z) : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("PositionX" .. self.id, {W = 75, Text = self.position[1], ReturnOnText = false, NumbersOnly = true}) then
    self.position[1] = Slab.GetInputText()
  end
  
  Slab.SameLine()
  
  if Slab.Input("PositionY" .. self.id, {W = 75, Text = self.position[2], ReturnOnText = false, NumbersOnly = true}) then
    self.position[2] = Slab.GetInputText()
  end
  
  Slab.SameLine()
  
  if Slab.Input("PositionZ" .. self.id, {W = 75, Text = self.position[3], ReturnOnText = false, NumbersOnly = true}) then
    self.position[3] = Slab.GetInputText()
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Scale (X, Y, Z) : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("ScaleX" .. self.id, {W = 75, Text = self.scale[1], ReturnOnText = false, NumbersOnly = true}) then
    self.scale[1] = Slab.GetInputText()
  end
  
  Slab.SameLine()
  
  if Slab.Input("ScaleY" .. self.id, {W = 75, Text = self.scale[2], ReturnOnText = false, NumbersOnly = true}) then
    self.scale[2] = Slab.GetInputText()
  end
  
  Slab.SameLine()
  
  if Slab.Input("ScaleZ" .. self.id, {W = 75, Text = self.scale[3], ReturnOnText = false, NumbersOnly = true}) then
    self.scale[3] = Slab.GetInputText()
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Rotation (X, Y, Z) : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("RotationX" .. self.id, {W = 75, Text = self.rotation[1], ReturnOnText = false, NumbersOnly = true}) then
    self.rotation[1] = Slab.GetInputText()
  end
  
  Slab.SameLine()
  
  if Slab.Input("RotationY" .. self.id, {W = 75, Text = self.rotation[2], ReturnOnText = false, NumbersOnly = true}) then
    self.rotation[2] = Slab.GetInputText()
  end
  
  Slab.SameLine()
  
  if Slab.Input("RotationZ" .. self.id, {W = 75, Text = self.rotation[3], ReturnOnText = false, NumbersOnly = true}) then
    self.rotation[3] = Slab.GetInputText()
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Color : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Button("", {W = 240, H = 16, Color = self.color}) then
    self.displayColor = not self.displayColor
  end
  
  Slab.EndLayout()
  
  Slab.Separator()
  Slab.BeginLayout("ObjectLayout2" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  
  if Slab.CheckBox(self.wireframeBool == 1, "Wireframe", {Tooltip = "Solid or Wireframe"}) then
    self.wireframeBool = (self.wireframeBool + 1) % 2
  end
  
  Slab.SetLayoutColumn(2)

  if Slab.CheckBox(self.flashingBool == 1, "Flashing", {Tooltip = "Flash object to the beat of the song"}) then
    self.flashingBool = (self.flashingBool + 1) % 2
  end
  
  Slab.EndLayout()
  Slab.Separator()
  
  self.visibilityStack:update()
  
  if #self.visibilityStack.items > 0 then
    Slab.Separator()
  end
  
  self.movementStack:update()
  
   if #self.movementStack.items > 0 then
    Slab.Separator()
  end
  
  self.scalingStack:update()
  
   if #self.scalingStack.items > 0 then
    Slab.Separator()
  end
  
  self.rotationStack:update()
  
   if #self.rotationStack.items > 0 then
    Slab.Separator()
  end
  
  self.colorStack:update()
  
   if #self.colorStack.items > 0 then
    Slab.Separator()
  end
  
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

return objectObject