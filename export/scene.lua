local csvParser = require("common.csvParser")
local noteRotation = require("export.noteRotation")

local stageConfig = require("export.structs.stageConfig")
local fileNameArray = require("export.structs.fileNameArray")
local trackSettings = require("export.structs.trackSettings")
local trackDrawDistance = require("export.structs.trackDrawDistance")
local trackPieceArray = require("export.structs.trackPieceArray")
local noteArray = require("export.structs.noteArray")
local cameraArray = require("export.structs.cameraArray")
local particleArray = require("export.structs.particleArray")
local visualizerArray = require("export.structs.visualizerArray")
local colorTableArray = require("export.structs.colorTableArray")
local objectArray = require("export.structs.objectArray")
local colorTable2Array = require("export.structs.colorTable2Array")

local noteExtHeader = require("export.structs.noteExtHeader")
local noteExtArray = require("export.structs.noteExtArray")
local noteExtUnknownType = require("export.structs.noteExtUnknownType")

local int32 = require("export.variableTypes.int32")

function getObjectArray(objects)
  local objectNames = {}

  for _,object in pairs (objects) do
    local modelIndex = -1
    
    if object.modelName == "" or object.modelName == nil then
      goto SKIP
    end
    
    for i,name in pairs (objectNames) do
      if name == object.modelName then
        modelIndex = i - 1
        break
      end
    end
    
    if modelIndex == -1 then
      modelIndex = #objectNames
      objectNames[modelIndex + 1] = object.modelName
    end
    
    ::SKIP::
    
    object.model = modelIndex
  end
  
  return objectArray:new(objectNames, objects)
end

local scene = {}

-- all hell breaks loose here, abandon all hope
function scene.toStageFile()
  local files = {
    header = csvParser.parseHeader(),
    courseline = csvParser.parseCourseline(),
    cameras = csvParser.parseCameras(),
    bpmChanges = csvParser.parseBPMChanges(),
    notes = csvParser.parseNotes(),
    particles = csvParser.parseParticles(),
    visualizers = csvParser.parseVisualizers(),
    colorTable = csvParser.parseColorTable(),
    colorTable2 = csvParser.parseColorTable2(),
    objects = csvParser.parseObjects()
  }
  
  for i,v in pairs (files) do
    if not v then
      return
    end
  end
  
  
  -- this would be accurate if i knew the game's camera parameters to build a rough projection matrix
  files.notes = noteRotation.calculateNoteRotations(files.cameras, files.courseline, files.notes)
  
  local stageConfigPointer = int32:new(int32.size() * 13)
  local fileHeader = {
    stageConfig = stageConfig:new(files.header, files.bpmChanges),
    fileNameArray = fileNameArray:new(files.header),
    trackSettings = trackSettings:new(files.header),
    trackDrawDistance = trackDrawDistance:new(files.header.drawDistanceChanges)
  }
  
  local trackDrawDistancePointer = int32:new(
    stageConfigPointer.x
    + fileHeader.stageConfig:size() 
    + fileHeader.fileNameArray:size() 
    + fileHeader.trackSettings:size()
  )
  
  local trackPointer = int32:new(trackDrawDistancePointer.x + fileHeader.trackDrawDistance:size())
  local trackPieces = trackPieceArray:new(files.courseline)
  
  local notePointer = int32:new(trackPointer.x + trackPieces:size())
  local notes = noteArray:new(files.notes)
  
  local cameraPointer = int32:new(notePointer.x + notes:size())
  local cameras = cameraArray:new(files.cameras)
  
  local particlePointer = int32:new(cameraPointer.x + cameras:size())
  local particles = particleArray:new(files.particles)
  
  local visualizerPointer = int32:new(particlePointer.x + particles:size())
  local visualizers = visualizerArray:new(files.visualizers)
  
  local unkPointer1 = int32:new(visualizerPointer.x + visualizers:size())
  
  local colorTablePointer = int32:new(unkPointer1.x + (int32.size() * 2))
  local colorTable = colorTableArray:new(files.colorTable)
  
  local objectPointer = int32:new(colorTablePointer.x + colorTable:size())
  local objects = getObjectArray(files.objects)
  
  local unkPointer2 = int32:new(48)
  
  local colorTable2Pointer = int32:new(objectPointer.x + objects:size())
  local colorTable2 = colorTable2Array:new({}, files.colorTable2, {}, {})
  
  local unk4 = int32:new(10705)
  
  --[[
  local difficulty = files.header.difficulty
  local difficultyName = "_hard"
  
  if difficulty == 0 then
    difficultyName = "_easy"
    
  elseif difficulty == 1 then
    difficultyName = "_normal"
    
  elseif difficulty == 2 then
    difficultyName = "_hard"
    
  elseif difficulty == 3 then
    difficultyName = "_ex"
  end
  ]]
  
  local file = love.filesystem.newFile(string.format("%s.dat", files.header.chartName))
  file:open("w")
  
  file:write(stageConfigPointer:toByte())
  file:write(trackDrawDistancePointer:toByte())
  file:write(trackPointer:toByte())
  file:write(notePointer:toByte())
  file:write(cameraPointer:toByte())
  file:write(particlePointer:toByte())
  file:write(visualizerPointer:toByte())
  file:write(unkPointer1:toByte())
  file:write(colorTablePointer:toByte())
  file:write(objectPointer:toByte())
  file:write(unkPointer2:toByte())
  file:write(colorTable2Pointer:toByte())
  file:write(unk4:toByte())
  
  file:write(fileHeader.stageConfig:toByte())
  file:write(fileHeader.fileNameArray:toByte())
  file:write(fileHeader.trackSettings:toByte())
  file:write(fileHeader.trackDrawDistance:toByte())
  
  file:write(trackPieces:toByte())
  file:write(notes:toByte())
  file:write(cameras:toByte())
  file:write(particles:toByte())
  file:write(visualizers:toByte())
  
  file:write(int32:new(0):toByte())
  file:write(int32:new(0):toByte())
  
  file:write(colorTable:toByte())
  file:write(objects:toByte())
  file:write(colorTable2:toByte())
  
  file:close()
  
  local extHeader = noteExtHeader:new()
  local extNotes = noteExtArray:new(files.notes)
  local extUnknownType = noteExtUnknownType:new(#files.objects)
  
  if extNotes.noteCount <= 0 then
    return
  end
  
  extHeader.unkPointer.x = extHeader:size() + extNotes:size()
  
  local extFile = love.filesystem.newFile(string.format("%s_ext.dat", files.header.chartName))
  extFile:open("w")
  
  extFile:write(extHeader:toByte())
  extFile:write(extNotes:toByte())
  extFile:write(extUnknownType:toByte())
  
  extFile:close()
end

return scene