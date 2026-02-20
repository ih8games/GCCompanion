local stack = require("common.stack")

local staticStack = stack:new()
staticStack.__index = staticStack

function staticStack:new(...)
  local obj = stack:new(...)
  
  return setmetatable(obj, self)
end

function staticStack:update()
  local w, h = love.graphics.getDimensions()
  
  local x = (w / 2) - 300
  local y = (h / 2) - 300
  
  Slab.BeginWindow(self.name, {Title = self.title, X = x, Y = y, W = 600, H = 600, AutoSizeWindow = false, AllowMove = false, AllowResize = false})
  
    Slab.BeginLayout("StackLayout", {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
    
    Slab.SetLayoutColumn(1)
    Slab.Text(self.inputText)
    
    Slab.SetLayoutColumn(2)
    
    if Slab.Input("StackSizeInput" .. self.id, {W = 240, AlignX = "center", Text = self.amount, ReturnOnText = false, NumbersOnly = true}) then
      -- user cannot change the stack size directly
    end
    
    Slab.EndLayout()
    Slab.Separator()

    for i,v in pairs (self.items) do
      v:update(i)
    end
  
  Slab.EndWindow()
end

return staticStack