local parser

local stack
local objectObject

local objectStack

local scene = {}

function scene.load()
  parser = require("objects.parser")
  
  stack = require("common.stack")
  objectObject = require("objects.objectObject")
  
  objectStack = stack:new("ObjectStack", "Objects", objectObject, "Object Stack Size : ")
end

function scene.update(dt)
  objectStack:update()
end

function scene.saveToFile()
  parser.toFile(objectStack.items)
end

function scene.loadFromFile()
  local newStack = parser.fromFile()
  
  if newStack then
    objectStack = newStack
  end
end

scene.load()

return scene