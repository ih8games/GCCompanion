local stackObject = require("common.stackObject")
local event = require("common.event")

local drawDistanceObject = stackObject:new()
drawDistanceObject.__index = drawDistanceObject

function drawDistanceObject:new()
  local obj = stackObject:new()
  
  obj.changedEvent = event:new()
  obj.timestampMs = 0
  obj.drawDistance = 8
  
  return setmetatable(obj, self)
end

function drawDistanceObject:fromArguments(args)
  local obj = stackObject:new()
  
  obj.timestampMs = args.timestampMs
  obj.drawDistance = args.drawDistance
  
  return setmetatable(obj, self)
end

function drawDistanceObject:output()
  return string.format("%d,%f",
    self.timestampMs,
    self.drawDistance
  )
end

function drawDistanceObject:update(i)
  self.header = string.format("[%d] : Draw Distance Object", i)
  stackObject.update(self)
  
  if not self.expanded then
    return
  end
  
  Slab.Separator()
  Slab.BeginLayout("DrawDistanceLayout" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Timestamp MS : ")

  Slab.SetLayoutColumn(2)

  if Slab.Input("MSInput" .. self.id, {W = 240, Text = self.timestampMs, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    local old = self.timestampMs
    
    self.timestampMs = math.floor(math.abs(input))
    
    if input ~= old then
      self.changedEvent:fire()
    end
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Draw Distance : ")

  Slab.SetLayoutColumn(2)

  if Slab.Input("DrawDistanceInput" .. self.id, {W = 240, Text = self.drawDistance, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 8
    self.drawDistance = math.abs(input)
  end
  
  Slab.EndLayout()
  Slab.Separator()
end

return drawDistanceObject