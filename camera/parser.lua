local stack = require("common.stack")
local cameraObject = require("camera.cameraObject")
local csvParser = require("common.csvParser")

local parser = {}

function parser.toFile(cameraObjects)
  local file = love.filesystem.newFile("cameras.csv")
  
  file:open("w")

  for _,v in pairs (cameraObjects) do
    file:write(v:output())
  end
  
  file:close()
  
  return file
end

function parser.fromFile()
  local cameraObjects = csvParser.parseCameras()
  
  if not cameraObjects then
    return
  end
  
  local cameraStack = stack:new("CameraStack", "Camera", cameraObject, "Camera Stack Size : ")
  cameraStack:set(#cameraObjects)
  
  for i,v in pairs (cameraStack.items) do
    cameraStack.items[i] = cameraObject:fromArguments(cameraObjects[i])
  end
  
  return cameraStack  
end


return parser