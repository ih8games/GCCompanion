local lmath = require("libraries.lmath")

local measureBar = require("notes.measure")

local measureController = {}

local measureSnappings = {1, 1/4, 1/8, 1/12, 1/16, 1/24, 1/32}
local measureSnapStrings = {"Whole", "4th", "8th", "12th", "16th", "24th", "32nd"}
local measureBars = {}

local endTime = 120000
local endMeasure = 100

local bpm = 100
local time = 0
local scaledMeasure = 0
local measure = 0
local measureSnap = 1

local font = love.graphics.newFont(14)
local infoString = love.graphics.newText(font, string.format("Snap: %s, Measure: %f, Time: %d", measureSnapStrings[measureSnap], measure, time))

function measureController.buildMeasures(bpmChanges)
  bpmChanges = bpmChanges or scenes[3].getBPMChanges()
  
  local minimum = 0
  
  for i,v in pairs (bpmChanges) do
    if v.timestampMs < minimum then
      return
    end
    
    minimum = v.timestampMs
  end

  local currentMeasure = 0
  local currentTime = 0
  
  local i = 1
  local newMeasures = {}
  
  while currentTime < endTime do
    newMeasures[i] = measureBar:new(currentMeasure, currentTime)
    
    currentMeasure = currentMeasure + 0.250
    currentTime = measureController.measureToTime(currentMeasure, bpmChanges)
    
    i = i + 1
  end
  
  newMeasures[i] = measureBar:new(currentMeasure, endTime)
  
  measureBars = newMeasures
  measureController.calculateEndMeasure(bpmChanges)
end

function measureController.calculateEndMeasure(bpmChanges)
  bpmChanges = bpmChanges or scenes[3].getBPMChanges()
  
  local measureCount = 0

  for i,v in pairs (bpmChanges) do
    local nextTime
    
    if bpmChanges[i + 1] then
      nextTime = bpmChanges[i + 1].timestampMs
      
    else
      nextTime = endTime
    end
    
    local difference = (nextTime - v.timestampMs) / 1000
    measureCount = measureCount + lmath.round(difference / (60 / v.bpm)) / 4
  end
  
  endMeasure = measureCount
end

function measureController.measureToTime(m, bpmChanges)
  bpmChanges = bpmChanges or scenes[3].getBPMChanges()
  local t = 0
  
  while m > 0 do
    local o = math.min(m, 0.25)
    m = m - o
    
    local bpm
    
    for i,v in pairs (bpmChanges) do
      if v.timestampMs <= math.floor(t * 1000) then
        bpm = v.bpm
      end
    end
    
    t = t + ((60 / bpm) * (o / 0.25))
  end
  
  t = lmath.clamp(math.floor(t * 1000), 0, endTime)

  return t
end

function measureController.setEndTime(newTime)
  endTime = math.floor(newTime * 1000)
  measureController.buildMeasures()
end

function measureController.changeSnap(dir)
  measureSnap = lmath.clamp(measureSnap + dir, 1, #measureSnappings)
  scaledMeasure = math.floor(measure / measureSnappings[measureSnap])
  
  measureController.updateInfo()
end

function measureController.changeMeasure(dir)
  scaledMeasure = lmath.clamp(scaledMeasure + dir, 0, math.floor(endMeasure / measureSnappings[measureSnap]))
  
  measure = scaledMeasure * measureSnappings[measureSnap]
  time = measureController.measureToTime(measure)

  measureController.updateInfo()
end

function measureController.updateInfo()
  infoString:set(string.format("Snap: %s, Measure: %.3f, Time: %dms", measureSnapStrings[measureSnap], measure, time))
end

function measureController.draw()
  for _,v in pairs (measureBars) do
    v:draw(-time)
  end
  
  local w, h = love.graphics.getDimensions()
  local w1, h1 = infoString:getDimensions()
  
  local x = w * 0.50 - w1 / 2
  local y = h * 0.90 - h1 / 2
  
  local w2 = w1 + 16
  local h2 = h1 + 16
  
  local x1 = x - 8
  local y1 = y - 8
  
  love.graphics.setColor(1, 0, 0, 1)
  love.graphics.line(w * 0.50 - 80, h * 0.60, w * 0.50 + 80, h * 0.60)
  
  love.graphics.setColor(0.80, 0.80, 0.80, 0.10)
  love.graphics.rectangle("fill", x1, y1, w2, h2)
  
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(infoString, x, y)
end

function measureController.getTime()
  return time
end

function measureController.getMeasure()
  return measure
end

return measureController