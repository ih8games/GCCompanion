local event = require("common.event")
local stack = require("common.stack")

local bpmStack = stack:new()
bpmStack.__index = bpmStack

function bpmStack:new(...)
  local obj = stack:new(...)
  
  obj.changedEvent = event:new()
  obj.connections = {}
  
  return setmetatable(obj, self)
end

function bpmStack:set(amount)
  if amount < 1 then
    return
  end
  
  if amount == #self.items then
    return
  end
  
  stack.set(self, amount)
  local newConnections = {}
  
  for _,v in pairs (self.connections) do
    v:disconnect()
  end
  
  for i,v in pairs (self.items) do
    newConnections[i] = v.changedEvent:connect(function()
      self:changed()
    end)
  end
  
  self.connections = newConnections
end

function bpmStack:changed()
  self.changedEvent:fire(self.items)
end

function bpmStack:update()
  local w, h = love.graphics.getDimensions()
  
  local x = 50
  local y = h - 300
  
  Slab.BeginWindow(self.name, {Title = self.title, X = x, Y = y, W = 300, H = 300, AutoSizeWindow = false, AutoSizeWindowH = true, AllowMove = true, AllowResize = false})
  
    Slab.BeginLayout("StackLayout" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
    
    Slab.SetLayoutColumn(1)
    Slab.Text(self.inputText)
    
    Slab.SetLayoutColumn(2)
    
    if Slab.Input("StackSizeInput" .. self.id, {W = 100, AlignX = "center", Text = self.amount, ReturnOnText = false, NumbersOnly = true}) then
      local input = tonumber(Slab.GetInputText())
      
      if input then
        self:set(input)
      end
    end
    
    Slab.EndLayout()
    Slab.Separator()

    for i,v in pairs (self.items) do
      v:update(i)
    end
  
  Slab.EndWindow()
end

return bpmStack