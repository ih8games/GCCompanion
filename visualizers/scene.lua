local parser

local stack
local visualizerObject

local visualizerStack

local scene = {}

function scene.load()
  stack = require("common.stack")
  visualizerObject = require("visualizers.visualizerObject")
  
  parser = require("visualizers.parser")
  
  visualizerStack = stack:new("VisualizerStack", "Visualizers", visualizerObject, "Visualizer Stack Size : ")
end

function scene.update(dt)
  visualizerStack:update()
end

function scene.saveToFile()
  parser.toFile(visualizerStack.items)
end

function scene.loadFromFile()
  local newStack = parser.fromFile()
  
  if newStack then
    visualizerStack = newStack
  end
end

scene.load()

return scene