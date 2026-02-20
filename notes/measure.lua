local measure = {}
measure.__index = measure

function measure:new(count, timestampMs)
  local obj = {
    count = count or 0,
    text = love.graphics.newText(love.graphics.getFont(), count or 0),
    drawNumber = (count or 0) % 1 == 0,
    timestampMs = timestampMs or 0
  }
  
  return setmetatable(obj, self)
end

function measure:draw(t)
  local offset = (t + self.timestampMs) * 0.10
  
  local w, h = love.graphics.getDimensions()
  local w1, h1 = self.text:getDimensions()
  
  local x = w / 2
  local y = h * 0.60 - offset
  
  if self.drawNumber then
    love.graphics.draw(self.text, x - 110, y, 0, 1, 1, w1 / 2, h1 / 2)
  end
  
  love.graphics.setColor(1, 1, 1, 0.50)
  
  love.graphics.line(x - 80, y, x + 80, y)
  
  love.graphics.setColor(1, 1, 1)
end

return measure