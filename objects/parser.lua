local stack = require("common.stack")
local objectObject = require("objects.objectObject")
local csvParser = require("common.csvParser")

local parser = {}

function parser.toFile(objects)
  local file = love.filesystem.newFile("objects.csv")
  
  file:open("w")
  
  for _,v in pairs (objects) do
    file:write(v:output())
  end
  
  file:close()
  
  return file
end

function parser.fromFile()
  local objects = csvParser.parseObjects(file)
  
  if not objects then
    return
  end
  
  local objectStack = stack:new("ObjectStack", "Objects", objectObject, "Object Stack Size : ")
  objectStack:set(#objects)
  
  for i,v in pairs (objectStack.items) do
    local r = objects[i].rotation
    
    objects[i].rotation = {r[2], r[1], r[3]}
    
    objectStack.items[i] = objectObject:fromArguments(objects[i])
  end
  
  return objectStack  
end

return parser