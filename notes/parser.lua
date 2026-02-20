local stack = require("notes.bpmStack")
local bpmObject = require("notes.bpmObject")
local csvParser = require("common.csvParser")

local parser = {}

function parser.toFile(bpmChanges, notes)
  local file = love.filesystem.newFile("bpmChanges.csv")
  file:open("w")
  
  for _,v in pairs (bpmChanges) do
    file:write(v:output())
  end
  
  file:close()
  
  file = love.filesystem.newFile("notes.csv")
  file:open("w")
  
  local total = #notes
  
  for i,v in pairs (notes) do
    if i == 1 then
      v.noteNumber = total
      
    else
      v.noteNumber = i - 1
    end
    
    file:write(v:output())
  end
  
  file:close()
end

function parser.fromFile()
  local bpmChanges = csvParser.parseBPMChanges()
  local bpmStack
  
  if bpmChanges then
    bpmStack = stack:new("BPM", "BPM Changes", bpmObject, "BPM Changes : ")
    bpmStack:set(#bpmChanges)
    
    for i,v in pairs (bpmChanges) do
      bpmStack.items[i] = bpmObject:fromArguments(v)
    end
  end
  
  local notes = csvParser.parseNotes()
  
  if notes then
    for i,v in pairs (notes) do
      local nc = v.noteColor
      local hc = v.hitTrailMaskColor
      
      nc = {nc[1] / 255, nc[2] / 255, nc[3] / 255, nc[4] / 255}
      hc = {hc[1] / 255, hc[2] / 255, hc[3] / 255, hc[4] / 255}
      
      v.noteColor = nc
      v.hitTrailMaskColor = hc
    end
  end
  
  return bpmStack, notes
end

return parser