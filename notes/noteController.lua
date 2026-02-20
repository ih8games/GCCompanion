local noteController = {}

local startTime
local startMeasure

local endTime
local endMeasure

local notes = {"Tap", "Critical", "Slide", "Dual Slide", "Adlib"}
local selectedNote = 1

local holds = {"Hold", "Beat", "Dual Hold", "Slide Hold", "Scratch"}
local selectedHold = 1

local placedNotes = {}

local noteObjects = {
  ["Tap"] = require("notes.objects.tap"),
  ["Critical"] = require("notes.objects.critical"),
  ["Slide"] = require("notes.objects.slide"),
  ["Dual Slide"] = require("notes.objects.dualSlide"),
  ["Adlib"] = require("notes.objects.adlib"),
  
  ["Hold"] = require("notes.objects.hold"),
  ["Beat"] = require("notes.objects.beat"),
  ["Dual Hold"] = require("notes.objects.dualHold"),
  ["Slide Hold"] = require("notes.objects.slideHold"),
  ["Scratch"] = require("notes.objects.scratch")
}

local noteColors = {
 ["Tap"] = {1, 1, 1, 1},
 ["Critical"] = {0, 0.50, 1, 1},
 ["Slide"] = {1, 0, 1, 1},
 ["Dual Slide"] = {0, 1, 1, 1},
 ["Adlib"] = {1, 1, 1, 1},
 
 ["Hold"] = {1, 1, 0, 1},
 ["Beat"] = {0, 1, 1, 1},
 ["Dual Hold"] = {1, 0.50, 0, 1},
 ["Slide Hold"] = {1, 0, 1, 1},
 ["Scratch"] = {0, 1, 0, 1}
}

local noteArgs = require("notes.noteArgs")

function noteController.startPlacement(measure, time)
  startMeasure = measure
  startTime = time
end

function noteController.finishPlacement(measure, time)
  endMeasure = measure
  endTime = time
  
  if startTime == endTime then
    noteController.placeNote(startTime)
    return
  end
  
  if endMeasure < startMeasure then
    local t = startMeasure
    
    startMeasure = endMeasure
    endMeasure = t
    
    t = startTime
    
    startTime = endTime
    endTime = t
  end
  
  noteController.placeHold(startTime, endTime, (endMeasure - startMeasure) * 4)
end

function noteController.getNoteIndex(note)
  local index = 1
  
  for i,v in pairs (placedNotes) do
    if v:check(note) then
      return -1
    end
    
    if v.timestampMs < note.timestampMs then
      index = i + 1
      
    elseif v.timestampMs > note.timestampMs then
      index = i
      break
    end
  end
  
  return index
end

function noteController.placeNote(time)
  local args = noteArgs.get()
  args.timestampMs = time
  args.noteColor = noteColors[notes[selectedNote]]
  
  if notes[selectedNote] == "Dual Slide" then
    args.rotationFront = 10
    args.rotationFront2 = -10
    args.isDualSlide = 1
  end
  
  local note = noteObjects[notes[selectedNote]]:new(args)
  local index = noteController.getNoteIndex(note)
  
  if index == -1 then
    return
  end

  table.insert(placedNotes, index, note)
end

function noteController.placeHold(time, endTime, holdMeasure)
  local args = noteArgs.get()
  args.timestampMs = time
  args.endTimestampMs = endTime
  args.noteColor = noteColors[holds[selectedHold]]
  args.holdTimeBeats = holdMeasure
  
  local note = noteObjects[holds[selectedHold]]:new(args)
  local index = noteController.getNoteIndex(note)
  
  if index == -1 then
    return
  end

  table.insert(placedNotes, index, note)
end

function noteController.deleteNote(time)
  local index = -1
  
  for i,v in pairs (placedNotes) do
    if v.timestampMs == time then
      index = i
      break
    end
    
    if v.timestampMs > time then
      break
    end
  end
  
  if index == -1 then
    return
  end
  
  table.remove(placedNotes, index)
end

function noteController.update(time)
  local w, h = love.graphics.getDimensions()
  
  local w1, h1 = 128, 200
  
  local x = w - 200
  
  local y1 = 50
  local y2 = y1 + 170
  
  Slab.BeginWindow("NoteList", {X = x, Y = y1})
  Slab.BeginListBox("Notes")
  
  for i = 1, #notes do
    Slab.BeginListBoxItem("ListItem" .. i, {Selected = (i == selectedNote)})
    
    Slab.Text(notes[i])
    
    if Slab.IsListBoxItemClicked() then
      selectedNote = i
    end
    
    Slab.EndListBoxItem()
  end
  
  Slab.EndListBox()
  Slab.EndWindow()
  
  Slab.BeginWindow("HoldList", {X = x, Y = y2})
  Slab.BeginListBox("Holds")
  
  for i = 1, #holds do
    Slab.BeginListBoxItem("ListItem" .. i, {Selected = (i == selectedHold)})
    
    Slab.Text(holds[i])
    
    if Slab.IsListBoxItemClicked() then
      selectedHold = i
    end
    
    Slab.EndListBoxItem()
  end
  
  Slab.EndListBox()
  Slab.EndWindow()
  
  for _,v in pairs (placedNotes) do
    if v.timestampMs == time then
      local x2, y2 = 50, 50
      local w2, h2 = 300, 150
      
      Slab.BeginWindow("SelectedNote", {Title = "Note", X = x2, Y = y2, W = w2, H = h2, AutoSizeWindow = false, AllowMove = true, AllowResize = false})
      
      v:update()
      
      Slab.EndWindow()
      
      break
    end
  end
end

function noteController.draw(time)
  for _,v in pairs (placedNotes) do
    v:draw(-time)
  end
end

function noteController.getNotes()
  return placedNotes
end

function noteController.setNotes(notes)
  local index = 1
  local newNotes = {}
  
  for i,v in pairs (notes) do
    local noteType
    
    if v.noteType == 1 and v.adlibType == 0 then
      noteType = noteObjects["Tap"]
      
    elseif v.noteType == 9 then
      noteType = noteObjects["Critical"]
      
    elseif v.noteType == 2 and v.isDualSlide == 0 then
      noteType = noteObjects["Slide"]
      
    elseif v.noteType == 2 and v.isDualSlide == 1 then
      noteType = noteObjects["Dual Slide"]
      
    elseif v.noteType == 1 and v.adlibType == 2 then
      noteType = noteObjects["Adlib"]
      
    elseif v.noteType == 3 then
      noteType = noteObjects["Hold"]
      
    elseif v.noteType == 5 then
      noteType = noteObjects["Beat"]
      
    elseif v.noteType == 15 then
      noteType = noteObjects["Dual Hold"]
      
    elseif v.noteType == 10 then
      noteType = noteObjects["Slide Hold"]
      
    elseif v.noteType == 4 then
      noteType = noteObjects["Scratch"]
    end
    
    if noteType then
      newNotes[index] = noteType:new(v)
      index = index + 1
    end
  end
  
  placedNotes = newNotes
end

return noteController