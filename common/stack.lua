local stackObject = require("common.stackObject")

local stack = {}
stack.__index = stack

function stack:new(name, title, object, inputText)
  local obj = {
    name = name or "Stack",
    title = title or "Stack",
    items = {},
    amount = 0,
    object = object or stackObject,
    inputText = inputText or "Stack Size : "
  }
  
  obj.id = tostring(obj)
  
  return setmetatable(obj, self)
end

function stack:assign(object)
  object = object or stackObject
  
  local newItems = {}
  
  if self.amount >= 1 then
    for i = 1, self.amount do
      newItems[i] = object:new()
    end
  end
  
  self.items = newItems
  self.object = object
end

function stack:set(amount)
  if amount < 0 then
    amount = 0
  end
  
  if amount == self.amount then
    return
  end
  
  local newItems = {}
  
  for i = 1, amount do
    newItems[i] = self.items[i] or self.object:new()
  end
  
  self.items = newItems
  self.amount = amount
end

function stack:update()
  local w, h = love.graphics.getDimensions()
  
  local x = (w / 2) - 300
  local y = (h / 2) - 300
  
  Slab.BeginWindow(self.name, {Title = self.title, X = x, Y = y, W = 600, H = 600, AutoSizeWindow = false, AllowMove = false, AllowResize = false})
  
    Slab.BeginLayout("StackLayout", {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
    
    Slab.SetLayoutColumn(1)
    Slab.Text(self.inputText)
    
    Slab.SetLayoutColumn(2)
    
    if Slab.Input("StackSizeInput" .. self.id, {W = 240, AlignX = "center", Text = self.amount, ReturnOnText = false, NumbersOnly = true}) then
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

return stack