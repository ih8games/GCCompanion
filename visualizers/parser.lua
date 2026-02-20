local stack = require("common.stack")
local visualizerObject = require("visualizers.visualizerObject")
local csvParser = require("common.csvParser")

local parser = {}

function parser.toFile(visualizerObjects)
  local file = love.filesystem.newFile("visualizers.csv")
  
  file:open("w")

  for _,v in pairs (visualizerObjects) do
    file:write(v:output())
  end
  
  file:close()
  
  return file
end

function parser.fromFile()  
  local visualizers = csvParser.parseVisualizers()
  
  if not visualizers then
    return
  end
  
  local visualizerStack = stack:new("VisualizerStack", "Visualizers", visualizerObject, "Visualizer Stack Size : ")
  visualizerStack:set(#visualizers)
  
  for i,v in pairs (visualizerStack.items) do
    local color = visualizers[i].color
    
    visualizers[i].color = {color[1] / 255, color[2] / 255, color[3] / 255, color[4] / 255}
    visualizerStack.items[i] = visualizerObject:fromArguments(visualizers[i])
  end
  
  return visualizerStack  
end

return parser