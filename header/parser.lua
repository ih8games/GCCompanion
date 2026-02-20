local substack = require("common.substack")
local drawDistanceObject = require("header.drawDistanceObject")
local csvParser = require("common.csvParser")

local parser = {}

function parser.fromFile()  
  local header = csvParser.parseHeader()
  
  if not header then
    return
  end
  
  header.trackAheadColor = {
    header.trackAheadColor[1] / 255,
    header.trackAheadColor[2] / 255,
    header.trackAheadColor[3] / 255,
    header.trackAheadColor[4] / 255
  }
  
  header.trackBehindColor = {
    header.trackBehindColor[1] / 255,
    header.trackBehindColor[2] / 255,
    header.trackBehindColor[3] / 255,
    header.trackBehindColor[4] / 255
  }
  
  header.unknownColor = {
    header.unknownColor[1] / 255,
    header.unknownColor[2] / 255,
    header.unknownColor[3] / 255,
    header.unknownColor[4] / 255
  }
  
  local drawDistanceStack = substack:new("DrawDistance", "Draw Distance", drawDistanceObject, "Draw Distance Stack Size : ")
  drawDistanceStack:set(#header.drawDistanceChanges)
  
  for i,v in pairs (drawDistanceStack.items) do
    drawDistanceStack.items[i] = drawDistanceObject:fromArguments(header.drawDistanceChanges[i])
  end
  
  header.drawDistanceStack = drawDistanceStack
  header.drawDistanceChanges = nil
  
  return header  
end

function parser.toFile(header)
  local file = love.filesystem.newFile("header.csv")
  
  file:open("w")
  
  local output
  
  output = string.format("%f,%f,%s,%s,%s,%f,%f,%d,%d,%d,%d,%d,%d,%d,%d,%d,%f,%d,%d,%d,%d,%d",
    header.endTime,
    header.outroTime,
    header.chartName,
    header.bgmName,
    header.shotName,
    header.backwardDrawDistance,
    header.forwardDrawDistance,
    header.trackAheadColor[1] * 255,
    header.trackAheadColor[2] * 255,
    header.trackAheadColor[3] * 255,
    header.trackAheadColor[4] * 255,
    header.trackBehindColor[1] * 255,
    header.trackBehindColor[2] * 255,
    header.trackBehindColor[3] * 255,
    header.trackBehindColor[4] * 255,
    header.audioOffset,
    header.visualOffset,
    header.unknownColor[1] * 255,
    header.unknownColor[2] * 255,
    header.unknownColor[3] * 255,
    header.unknownColor[4] * 255,
    #header.drawDistanceStack.items
  )
  
  for _,v in pairs (header.drawDistanceStack.items) do
    output = string.format("%s,%s", output, v:output())
  end
  
  file:write(output)
  file:close()
  
  return file
end

return parser