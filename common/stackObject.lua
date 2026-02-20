local stackObject = {}
stackObject.__index = stackObject

function stackObject:new()
  local obj = {
    header = "Stack Object",
    expanded = false
  }
  
  obj.id = tostring(obj)
  
  return setmetatable(obj, self)
end

function stackObject:update()
  local expanded = Slab.Button(self.header, {W = 596})
  
  if expanded then
    self.expanded = not self.expanded
  end
end

return stackObject