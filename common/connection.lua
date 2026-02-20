local connection = {}
connection.__index = connection

function connection:new(event, id)
    local obj = {
        event = event,
        id = id,
    }
    
  return setmetatable(obj, self)
end

function connection:disconnect()
    self.event:disconnect(self.id)
end

return connection