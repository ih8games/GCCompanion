local parser

local stack
local particleObject

local particleStack

local scene = {}

function scene.load()
  stack = require("common.stack")
  particleObject = require("particles.particleObject")
  
  parser = require("particles.parser")
  
  particleStack = stack:new("ParticleStack", "Particles", particleObject, "Particles Stack Size : ")
end

function scene.update(dt)
  particleStack:update()
end

function scene.saveToFile()
  parser.toFile(particleStack.items)
end

function scene.loadFromFile()
  local newStack = parser.fromFile()
  
  if newStack then
    particleStack = newStack
  end
end

scene.load()

return scene