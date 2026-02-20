local parser

local stack
local cameraObject

local cameraStack

local scene = {}

function scene.load()
  parser = require("camera.parser")
  
  stack = require("common.stack")
  cameraObject = require("camera.cameraObject")
  
  cameraStack = stack:new("CameraStack", "Camera", cameraObject, "Camera Stack Size : ")
end

function scene.update(dt)
  cameraStack:update()
end

function scene.saveToFile()
  parser.toFile(cameraStack.items)
end

function scene.loadFromFile()
  local newStack = parser.fromFile()
  
  if newStack then
    cameraStack = newStack
  end
end

scene.load()

return scene