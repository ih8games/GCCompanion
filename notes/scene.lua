local stack
local bpmObject
local measureController
local noteController
local parser

local bpmStack
local connection

local scene = {}

function scene.load()
  stack = require("notes.bpmStack")
  bpmObject = require("notes.bpmObject")
  
  measureController = require("notes.measureController")
  noteController = require("notes.noteController")
  
  parser = require("notes.parser")
  
  bpmStack = stack:new("BPM", "BPM Changes", bpmObject, "BPM Changes : ")
  bpmStack:set(1)
  
  connection = bpmStack.changedEvent:connect(function(items)
    scene.bpmChanged(items)
  end)

  measureController.buildMeasures(bpmStack.items)
end

function scene.bpmChanged(items)
  measureController.buildMeasures(items)
end

function scene.getBPMChanges()
  return bpmStack.items
end

function scene.setEndTime(endTime)
  measureController.setEndTime(endTime)
end

function scene.update()
  bpmStack:update()
  
  local time = measureController.getTime()
  
  noteController.update(time)
end

function scene.draw()
  measureController.draw()
  
  local time = measureController.getTime()
  
  noteController.draw(time)
end

function scene.keypressed(key)
  if key == "up" then
    measureController.changeMeasure(1)
    
  elseif key == "down" then
    measureController.changeMeasure(-1)
    
  elseif key == "right" then
    measureController.changeSnap(1)
    
  elseif key == "left" then
    measureController.changeSnap(-1)
    
  elseif key == "lshift" or key == "rshift" then
    local measure, time = measureController.getMeasure(), measureController.getTime()
    
    noteController.startPlacement(measure, time)
    
  elseif key == "delete" then
    local time = measureController.getTime()
    
    noteController.deleteNote(time)
  end
end

function scene.keyreleased(key)
  if key == "lshift" or key == "rshift" then
    local measure, time = measureController.getMeasure(), measureController.getTime()
    
    noteController.finishPlacement(measure, time)
  end
end

function scene.wheelmoved(x, y)
  measureController.changeMeasure(y)
end

function scene.saveToFile()
  local notes = noteController.getNotes()
  
  parser.toFile(bpmStack.items, notes)
end

function scene.loadFromFile()
  local newStack, newNotes = parser.fromFile()
  
  if newStack then
    if connection then
      connection:disconnect()
    end
    
    bpmStack = newStack

    connection = bpmStack.changedEvent:connect(function(items)
      scene.bpmChanged(items)
    end)
  
    measureController.buildMeasures(bpmStack.items)
  end
  
  if newNotes then
    noteController.setNotes(newNotes)
  end
end

scene.load()

return scene