local parser

local stack
local colorObject

local colorStack

local scene = {}

function scene.load()
  parser = require("colorTable.parser")
  
  stack = require("common.stack")
  colorObject = require("colorTable.colorObject")
  
  colorStack = stack:new("ColorStack", "Background Color Table", colorObject, "Color Table Stack Size : ")
end

function scene.update(dt)
  colorStack:update()
end

function scene.saveToFile()
  parser.toFile(colorStack.items)
end

function scene.loadFromFile()
  local newStack = parser.fromFile()
  
  if newStack then
    colorStack = newStack
  end
end

scene.load()

return scene