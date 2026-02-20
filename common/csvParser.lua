local csvParser = {}
local isFused = love.filesystem.isFused()

function csvParser.splitCSV(line)
  local parsedLine = {}
  
  for str in string.gmatch(line, "([^,]+)") do
    local num = tonumber(str)
    
    if num then
      table.insert(parsedLine, num)
      
    else
      table.insert(parsedLine, str)
    end
  end

  return parsedLine
end

function csvParser.parseHeader()
  local header
  
  if not love.filesystem.getInfo("header.csv") then
    return 
  end
  
  local i = 0
  
  for line in love.filesystem.lines("header.csv") do
    if i > 0 then
      break
    end
    
    local parsedLine = csvParser.splitCSV(line)
    
    header = {
      endTime = parsedLine[1],
      outroTime = parsedLine[2],
      chartName = parsedLine[3],
      bgmName = parsedLine[4],
      shotName = parsedLine[5],
      backwardDrawDistance = parsedLine[6],
      forwardDrawDistance = parsedLine[7],
      trackAheadColor = {parsedLine[8], parsedLine[9], parsedLine[10], parsedLine[11]},
      trackBehindColor = {parsedLine[12], parsedLine[13], parsedLine[14], parsedLine[15]},
      audioOffset = parsedLine[16],
      visualOffset = parsedLine[17],
      unknownColor = {parsedLine[18], parsedLine[19], parsedLine[20], parsedLine[21]},
      drawDistanceChanges = {}
    }
    
    local drawDistancePointer = 22
    
    for j = 0, parsedLine[drawDistancePointer] - 1 do
      local n = drawDistancePointer + (j * 2)
      
      local entry = {
        timestampMs = parsedLine[n + 1],
        drawDistance = parsedLine[n + 2]
      }
      
      header.drawDistanceChanges[j + 1] = entry
    end
    
    i = i + 1
  end
  
  return header
end

function csvParser.parseCourseline()
  local trackPieces = {}
  local i = 0
  
  if not love.filesystem.getInfo("courseline.csv") then
    return 
  end
  
  for line in love.filesystem.lines("courseline.csv") do
    local parsedLine
    
    if i == 0 then
      goto SKIP
    end
    
    parsedLine = csvParser.splitCSV(line)
    
    trackPieces[i] = {
      timestampMs = parsedLine[2],
      position = {parsedLine[3], parsedLine[4], parsedLine[5]}
    }
    
    ::SKIP::
    
    i = i + 1
  end
  
  return trackPieces
end

function csvParser.parseBPMChanges()
  local bpmChanges = {}
  local i = 1
  
  if not love.filesystem.getInfo("bpmChanges.csv") then
    return 
  end
  
  for line in love.filesystem.lines("bpmChanges.csv") do
    local parsedLine = csvParser.splitCSV(line)
    
    bpmChanges[i] = {
      timestampMs = parsedLine[1],
      bpm = parsedLine[2]
    }
    
    i = i + 1
  end

  return bpmChanges
end

function csvParser.parseNotes()
  local notes = {}
  local i = 1
  
  if not love.filesystem.getInfo("notes.csv") then
    return
  end
  
  for line in love.filesystem.lines("notes.csv") do
    local parsedLine = csvParser.splitCSV(line)
    
    notes[i] = {
      unk0 = parsedLine[1],
      noteNumber = parsedLine[2],
      timestampMs = parsedLine[3],
      endTimestampMs = parsedLine[4],
      noteType = parsedLine[5],
      adlibType = parsedLine[6],
      adlibVisibleBool = parsedLine[7],
      targetStyle = parsedLine[8],
      hitTrailStyle = parsedLine[9],
      hitTrailSize = parsedLine[10],
      animationType = parsedLine[11],
      unk22 = parsedLine[12],
      unk24 = parsedLine[13],
      unk26 = parsedLine[14],
      unk28 = parsedLine[15],
      unk30 = parsedLine[16],
      unk32 = parsedLine[17],
      flyInDistance = parsedLine[18],
      rotationFront = parsedLine[19],
      rotationFront2 = parsedLine[20],
      flyInRotationTop = parsedLine[21],
      flyInRotationTop2 = parsedLine[22],
      flyInBool = parsedLine[23],
      showFlyInLineBool = parsedLine[24],
      noteAppearanceTimeBeats = parsedLine[25],
      flyDelayTimeBeats = parsedLine[26],
      flyEndTimeBeats = parsedLine[27],
      holdTimeBeats = parsedLine[28],
      noteColor = {parsedLine[29], parsedLine[30], parsedLine[31], parsedLine[32]},
      hitTrailMaskColor = {parsedLine[33], parsedLine[34], parsedLine[35], parsedLine[36]},
      flyAnimationRepeatCount = parsedLine[37],
      unk75 = parsedLine[38],
      unk79 = parsedLine[39],
      unk83 = parsedLine[40],
      unk87 = parsedLine[41],
      unk91 = parsedLine[42],
      unk95 = parsedLine[43],
      isDualSlide = parsedLine[44]
    }
    
    i = i + 1
  end
  
  return notes
end

function csvParser.parseCameras()
  local cameraObjects = {}
  local i = 1
  
  if not love.filesystem.getInfo("cameras.csv") then
    return 
  end
  
  for line in love.filesystem.lines("cameras.csv") do
    local parsedLine = csvParser.splitCSV(line)
    
    cameraObjects[i] = {
      timestampMs = parsedLine[1],
      aMode = parsedLine[2],
      fMode = parsedLine[3],
      cameraDistance = parsedLine[4],
      rotation = {parsedLine[5], parsedLine[6], parsedLine[17]},
      originOffset = {parsedLine[7], parsedLine[8], parsedLine[9]},
      projectionType = parsedLine[10],
      globalFieldFar = {parsedLine[11], parsedLine[12], parsedLine[13]},
      globalFieldNear = {parsedLine[14], parsedLine[15], parsedLine[16]}
    }
    
    i = i + 1
  end

  return cameraObjects
end

function csvParser.parseParticles()
  local particles = {}
  local i = 1
  
  if not love.filesystem.getInfo("particles.csv") then
    return 
  end
  
  for line in love.filesystem.lines("particles.csv") do
    local parsedLine = csvParser.splitCSV(line)
    
    particles[i] = {
      timestampMs = parsedLine[1],
      unk4 = parsedLine[2],
      groupShape = parsedLine[3],
      particleTexture = parsedLine[4],
      color = {parsedLine[5], parsedLine[6], parsedLine[7], parsedLine[8]},
      velocity = {parsedLine[9], parsedLine[10], parsedLine[11]},
      repeatMeasure = parsedLine[12],
      lifespanMeasure = parsedLine[13],
      groupShapeSize = parsedLine[14]
    }
    
    i = i + 1
  end
  
  return particles
end

function csvParser.parseVisualizers()
  local visualizerObjects = {}
  local i = 1
  
  if not love.filesystem.getInfo("visualizers.csv") then
    return 
  end
  
  for line in love.filesystem.lines("visualizers.csv") do
    local parsedLine = csvParser.splitCSV(line)
    
    visualizerObjects[i] = {
      timestampMs = parsedLine[1],
      visualizerType = parsedLine[2],
      color = {parsedLine[3], parsedLine[4], parsedLine[5], parsedLine[6]}
    }
    
    i = i + 1
  end
  
  return visualizerObjects
end

function csvParser.parseColorTable()
  local colorTableEntries = {}
  local i = 1
  
  if not love.filesystem.getInfo("colorTable.csv") then
    return 
  end
  
  for line in love.filesystem.lines("colorTable.csv") do
    local parsedLine = csvParser.splitCSV(line)
    
    colorTableEntries[i] = {
      timestampMs = parsedLine[1],
      topRight = {parsedLine[2], parsedLine[3], parsedLine[4], parsedLine[5]},
      topLeft = {parsedLine[6], parsedLine[7], parsedLine[8], parsedLine[9]},
      bottomRight = {parsedLine[10], parsedLine[11], parsedLine[12], parsedLine[13]},
      bottomLeft = {parsedLine[14], parsedLine[15], parsedLine[16], parsedLine[17]},
      fadeOutBool = parsedLine[18],
      fadeInBool = parsedLine[19]
    }
    
    i = i + 1
  end
  
  return colorTableEntries
end

function csvParser.parseColorTable2()
  local colorTable2Entries = {}
  local i = 1
  
  if not love.filesystem.getInfo("colorTable2.csv") then
    return 
  end
  
  for line in love.filesystem.lines("colorTable2.csv") do
    local parsedLine = csvParser.splitCSV(line)
    
    colorTable2Entries[i] = {
      visibleBool = parsedLine[1],
      center = {parsedLine[2], parsedLine[3], parsedLine[4], parsedLine[5]},
      top = {parsedLine[6], parsedLine[7], parsedLine[8], parsedLine[9]},
      bottom = {parsedLine[10], parsedLine[11], parsedLine[12], parsedLine[13]},
      left = {parsedLine[14], parsedLine[15], parsedLine[16], parsedLine[17]},
      right = {parsedLine[18], parsedLine[19], parsedLine[20], parsedLine[21]}
    }
    
    i = i + 1
  end
  
  return colorTable2Entries
end

function csvParser.parseObjects()
  local objects = {}
  local i = 1
  
  if not love.filesystem.getInfo("objects.csv") then
    return 
  end
  
  for line in love.filesystem.lines("objects.csv") do
    local parsedLine = csvParser.splitCSV(line)
    
    local visibilityPointer = 22
    local movementPointer = visibilityPointer + (parsedLine[visibilityPointer] * 4) + 1
    local scalingPointer = movementPointer  + (parsedLine[movementPointer] * 6) + 1
    local rotationPointer = scalingPointer + (parsedLine[scalingPointer] * 6) + 1
    local colorPointer = rotationPointer + (parsedLine[rotationPointer] * 6) + 1
    
    local visibility = {}

    for i = 0, parsedLine[visibilityPointer] - 1 do
      local n = visibilityPointer + (i * 4)
      
      local entry = {
        parsedLine[n + 1],
        parsedLine[n + 2],
        parsedLine[n + 3],
        parsedLine[n + 4]
      }
      
      visibility[i + 1] = entry
    end
    
    local movements = {}
    
    for i = 0, parsedLine[movementPointer] - 1 do
      local n = movementPointer + (i * 6)
      
      local entry = {
        parsedLine[n + 1],
        parsedLine[n + 2],
        parsedLine[n + 3],
        parsedLine[n + 4], 
        parsedLine[n + 5], 
        parsedLine[n + 6]
      }
      
      movements[i + 1] = entry
    end
    
    local scalings = {}
    
    for i = 0, parsedLine[scalingPointer] - 1 do
      local n = scalingPointer + (i * 6)
      
      local entry = {
        parsedLine[n + 1],
        parsedLine[n + 2],
        parsedLine[n + 3],
        parsedLine[n + 4], 
        parsedLine[n + 5], 
        parsedLine[n + 6]
      }
      
      scalings[i + 1] = entry
    end
    
    local rotations = {}
    
    for i = 0, parsedLine[rotationPointer] - 1 do
      local n = rotationPointer + (i * 6)
      
      local entry = {
        parsedLine[n + 1],
        parsedLine[n + 2],
        parsedLine[n + 3],
        parsedLine[n + 4], 
        parsedLine[n + 5], 
        parsedLine[n + 6]
      }
      
      rotations[i + 1] = entry
    end
    
    local colorChanges = {}
    
    for i = 0, parsedLine[colorPointer] - 1 do
      local n = colorPointer + (i * 7)
      
      local entry = {
        parsedLine[n + 1],
        parsedLine[n + 2],
        parsedLine[n + 3],
        parsedLine[n + 4], 
        parsedLine[n + 5], 
        parsedLine[n + 6], 
        parsedLine[n + 7]
      }
      
      colorChanges[i + 1] = entry
    end
    
    objects[i] = {
      modelName = parsedLine[1],
      fs = parsedLine[2],
      wireframeBool = parsedLine[3],
      flashingBool = parsedLine[4],
      unkBool1 = parsedLine[5],
      position = {parsedLine[6], parsedLine[7], parsedLine[8]},
      scale = {parsedLine[9], parsedLine[10], parsedLine[11]},
      rotation = {parsedLine[12], parsedLine[13], parsedLine[14]},
      color = {parsedLine[15], parsedLine[16], parsedLine[17], parsedLine[18]},
      unk = {parsedLine[19], parsedLine[20], parsedLine[21]},
      visibility = visibility,
      movements = movements,
      scalings = scalings,
      rotations = rotations,
      colorChanges = colorChanges
    }
    
    i = i + 1
  end
  
  return objects
end

return csvParser