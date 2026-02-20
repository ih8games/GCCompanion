local event = require("common.event")
local stackObject = require("common.stackObject")

local bpmObject = stackObject:new()
bpmObject.__index = bpmObject

function bpmObject:new()
  local obj = stackObject:new()
  
  obj.changedEvent = event:new()
  obj.timestampMs = 0
  obj.bpm = 100
  
  return setmetatable(obj, self)
end

function bpmObject:fromArguments(args)
  local obj = stackObject:new()
  
  obj.changedEvent = event:new()
  obj.timestampMs = args.timestampMs
  obj.bpm = args.bpm
  
  return setmetatable(obj, self)
end

function bpmObject:changed()
  self.changedEvent:fire()
end

function bpmObject:output()
  return string.format("%d,%f",
    self.timestampMs,
    self.bpm
  )
end

function bpmObject:update(i)
  self.header = string.format("[%d] : BPM Object", i)

  local expanded = Slab.Button(self.header, {W = 296})
  
  if expanded then
    self.expanded = not self.expanded
  end
  
  if not self.expanded then
    return
  end
  
  Slab.Separator()
  Slab.BeginLayout("BPMLayout" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Timestamp MS : ")

  Slab.SetLayoutColumn(2)

  if Slab.Input("MSInput" .. self.id, {W = 100, Text = self.timestampMs, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    local timestampMs = math.floor(math.abs(input))
    
    if i == 1 then
      timestampMs = 0
    end
    
    local old = self.timestampMs
    self.timestampMs = timestampMs
    
    if old ~= self.timestampMs then
      self.changedEvent:fire()
    end
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("BPM : ")

  Slab.SetLayoutColumn(2)

  if Slab.Input("BPM" .. self.id, {W = 100, Text = self.bpm, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 100
    local bpm = math.abs(input)
    
    local old = self.bpm
    self.bpm = bpm
    
    if old ~= self.bpm then
      self.changedEvent:fire()
    end
  end
  
  Slab.EndLayout()
  Slab.Separator()
end

return bpmObject