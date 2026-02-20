local connection = require("common.connection")

local event = {}
event.__index = event

function event:new()
    local obj = {
        connectedFunctions = {},
        connectionsMade = 1,
    }
    
  return setmetatable(obj, self)
end

function event:connect(func)
  self.connectedFunctions[self.connectionsMade] = func

  local connection = connection:new(self, self.connectionsMade)
  self.connectionsMade = self.connectionsMade + 1

  return connection
end

function event:disconnect(id)
    self.connectedFunctions[id] = nil
end

function event:fire(...)
    for _,func in pairs (self.connectedFunctions) do
        func(...)
    end
end

return event