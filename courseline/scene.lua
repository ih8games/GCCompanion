local parser

local font
local font2

local drawText
local drawText2

local scene = {}

function scene.load()
  font = love.graphics.newFont(20, "normal", love.graphics.getDPIScale())
  font2 = love.graphics.newFont(14, "normal", love.graphics.getDPIScale())
  
  drawText = love.graphics.newText(font, "Drop your courseline.obj file into the window !")
  drawText2 = love.graphics.newText(font2, "(I hope you followed the instructions for setting up the file correctly ...)")
  
  parser = require("courseline.parser")
end

function scene.draw()
  local w, h = love.graphics.getDimensions()
  
  local x, y = drawText:getDimensions()
  local x2, y2 = drawText2:getDimensions()
  
  local t = os.clock()
  
  x = w / 2 - x / 2
  y = h / 2 - y
  
  y = y + math.sin(t * math.pi * 0.50) * 20
  
  x2 = w / 2 - x2 / 2
  y2 = h * 0.60 - y2
  
  y2 = y2 + math.sin(t * math.pi * 0.50) * 10
  
  love.graphics.draw(drawText, x, y)
  love.graphics.draw(drawText2, x2, y2)
end

function scene.filedropped(file)
  local fileType = file:getFilename():match("%.%w+$")
  
  if fileType == ".obj" then
    parser.toFile(file)
  end
end

scene.load()

return scene