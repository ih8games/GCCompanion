local event = require("common.event")
local substack = require("common.substack")

local drawDistanceStack = substack:new()
drawDistanceStack.__index = drawDistanceStack

function drawDistanceStack:new(...)
  local obj = substack:new(...)
  
  obj.changedEvent = event:new()
  obj.connections = {}
  
  return setmetatable(obj, self)
end

function drawDistanceStack:set(amount)
  substack.set(self, amount)
  self:changed()
  
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

function drawDistanceStack:changed()
  self.changedEvent:fire(self.items)
end

return drawDistanceStack