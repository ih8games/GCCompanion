local stackObject = require("common.stackObject")

local visualizers = {"NONE", "RADIATING", "MIST", "SOUNDWAVE", "RIPPLES", "ROUND_EQUALIZER", "LIGHTS", "CYCLONE"}

local visualizerObject = stackObject:new()
visualizerObject.__index = visualizerObject

function visualizerObject:new()
  local obj = stackObject:new()
  
  obj.timestampMs = 0
  obj.visualizerType = 0
  obj.color = {1, 1, 1, 1}

  obj.displayColor = false
  
  return setmetatable(obj, self)
end

function visualizerObject:fromArguments(args)
  local obj = stackObject:new()
  
  obj.timestampMs = args.timestampMs
  obj.visualizerType = args.visualizerType
  obj.color = args.color
  
  obj.displayColor = false
  
  return setmetatable(obj, self)
end

function visualizerObject:output()
  return string.format("%d,%d,%d,%d,%d,%d\r\n",
    self.timestampMs,
    self.visualizerType,
    math.floor(self.color[1] * 255 + 0.50),
    math.floor(self.color[2] * 255 + 0.50),
    math.floor(self.color[3] * 255 + 0.50),
    math.floor(self.color[4] * 255 + 0.50)
  )
end

function visualizerObject:update(i)
  self.header = string.format("[%d] : Visualizer Object", i)
  stackObject.update(self)
  
  if not self.expanded then
    return
  end
  
  Slab.Separator()
  Slab.BeginLayout("VisualizerLayout" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Timestamp MS : ")

  Slab.SetLayoutColumn(2)

  if Slab.Input("MSInput" .. self.id, {W = 240, Text = self.timestampMs, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.timestampMs = math.floor(math.abs(input))
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Visualizer : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.BeginComboBox("Visualizer" .. self.id, {W = 240, Selected = visualizers[self.visualizerType + 1]}) then
    for i,v in pairs (visualizers) do
      if Slab.TextSelectable(v) then
        self.visualizerType = i - 1
      end
    end
    
    Slab.EndComboBox()
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

return visualizerObject