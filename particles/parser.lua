local stack = require("common.stack")
local particleObject = require("particles.particleObject")
local csvParser = require("common.csvParser")

local parser = {}

function parser.toFile(particleObjects)
  local file = love.filesystem.newFile("particles.csv")
  
  file:open("w")

  for _,v in pairs (particleObjects) do
    file:write(v:output())
  end
  
  file:close()
  
  return file
end

function parser.fromFile()
  local particles = csvParser.parseParticles()
  
  if not particles then
    return
  end
 
  local particleStack = stack:new("ParticleStack", "Particles", particleObject, "Particles Stack Size : ")
  particleStack:set(#particles)
  
  for i,v in pairs (particleStack.items) do
    local color = particles[i].color
    
    particles[i].color = {color[1] / 255, color[2] / 255, color[3] / 255, color[4] / 255}
    particleStack.items[i] = particleObject:fromArguments(particles[i])
  end
  
  return particleStack  
end

return parser