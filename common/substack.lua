local stack = require("common.stack")

local substack = stack:new()
substack.__index = substack

function substack:new(...)
  local obj = stack:new(...)

  return setmetatable(obj, self)
end

function substack:update()
  Slab.BeginLayout(self.name .. "Layout", {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
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
end

return substack

