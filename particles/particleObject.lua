local stackObject = require("common.stackObject")

local groupShapes = {"NONE", "SCATTERED", "GRID", "CIRCLE"}
local particleTextures = {"NONE", "CIRCLE", "DIAMOND", "DIAMOND2", "CIRCLE2"}

local particleObject = stackObject:new()
particleObject.__index = particleObject

function particleObject:new()
  local obj = stackObject:new()
  
  obj.timestampMs = 0
  obj.unk4 = 0
  obj.groupShape = 0
  obj.particleTexture = 34
  obj.color = {1, 1, 1, 1}
  obj.velocity = {0, 0, 0}
  obj.repeatMeasure = 0
  obj.lifespanMeasure = 8
  obj.groupShapeSize = 120
  
  obj.displayColor = false
  
  return setmetatable(obj, self)
end

function particleObject:fromArguments(args)
  local obj = stackObject:new()
  
  obj.timestampMs = args.timestampMs
  obj.unk4 = args.unk4
  obj.groupShape = args.groupShape
  obj.particleTexture = args.particleTexture
  obj.color = args.color
  obj.velocity = args.velocity
  obj.repeatMeasure = args.repeatMeasure
  obj.lifespanMeasure = args.lifespanMeasure
  obj.groupShapeSize = args.groupShapeSize
  
  obj.displayColor = false
  
  return setmetatable(obj, self)
end

function particleObject:output()
  return string.format("%d,%d,%d,%d,%d,%d,%d,%d,%f,%f,%f,%f,%f,%d\r\n",
    self.timestampMs,
    self.unk4,
    self.groupShape,
    self.particleTexture,
    math.floor(self.color[1] * 255 + 0.50),
    math.floor(self.color[2] * 255 + 0.50),
    math.floor(self.color[3] * 255 + 0.50),
    math.floor(self.color[4] * 255 + 0.50),
    self.velocity[1],
    self.velocity[2],
    self.velocity[3],
    self.repeatMeasure,
    self.lifespanMeasure,
    self.groupShapeSize
  )
end

function particleObject:update(i)
  self.header = string.format("[%d] : Particle Object", i)
  stackObject.update(self)
  
  if not self.expanded then
    return
  end
  
  Slab.Separator()
  Slab.BeginLayout("ParticleLayout" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Timestamp MS : ")

  Slab.SetLayoutColumn(2)

  if Slab.Input("MSInput" .. self.id, {W = 240, Text = self.timestampMs, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.timestampMs = math.floor(input)
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("unk4: ")

  Slab.SetLayoutColumn(2)

  if Slab.Input("unk4Input" .. self.id, {W = 240, Text = self.unk4, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.unk4 = math.abs(input)
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Group Shape : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.BeginComboBox("GroupShape" .. self.id, {W = 240, Selected = groupShapes[self.groupShape + 1]}) then
    for i,v in pairs (groupShapes) do
      if Slab.TextSelectable(v) then
        self.groupShape = i - 1
      end
    end
    
    Slab.EndComboBox()
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Particle Texture : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.BeginComboBox("ParticleTexture" .. self.id, {W = 240, Selected = particleTextures[self.particleTexture - 33]}) then
    for i,v in pairs (particleTextures) do
      if Slab.TextSelectable(v) then
        self.particleTexture = i + 33
      end
    end
    
    Slab.EndComboBox()
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Velocity (X, Y, Z) : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("VelocityX" .. self.id, {W = 75, Text = self.velocity[1], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.velocity[1] = input
  end
  
  Slab.SameLine()
  
  if Slab.Input("VelocityY" .. self.id, {W = 75, Text = self.velocity[2], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.velocity[2] = input
  end
  
  Slab.SameLine()
  
  if Slab.Input("VelocityZ" .. self.id, {W = 75, Text = self.velocity[3], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.velocity[3] = input
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Repeat Measure : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("RepeatMeasure" .. self.id, {W = 240, Text = self.repeatMeasure, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.repeatMeasure = math.abs(input)
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Lifespan Measure : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("LifespanMeasure" .. self.id, {W = 240, Text = self.lifespanMeasure, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 8
    self.lifespanMeasure = math.abs(input)
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Group Shape Size : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("GroupShapeSize" .. self.id, {W = 240, Text = self.groupShapeSize, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 120
    self.groupShapeSize = math.max(input, 1)
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Color : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Button("", {W = 240, H = 16, Color = self.color}) then
    self.displayColor = not self.displayColor
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

return particleObject