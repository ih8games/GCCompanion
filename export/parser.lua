local csvParser = require("common.csvParser")

local parser = {}

function parser.splitCSV(line)
  local parsedLine = {}
  
  for str in string.gmatch(line, "([^,]+)") do
    table.insert(parsedLine, str)
  end

  return parsedLine
end

-- FILE 1
function parser.parseHeader()
  local header = require("csvToDat.header")
  
  local stageConfig = require("csvToDat.structs.stageConfig")
  local fileNameArray = require("csvToDat.structs.fileNameArray")
  local trackSettings = require("csvToDat.structs.trackSettings")
  local trackDrawDistance = require("csvToDat.structs.trackDrawDistance")
  
  local parsedHeader = {
    stageConfig = stageConfig:new(header.stageConfig),
    fileNameArray = fileNameArray:new(header.fileNameList),
    trackSettings = trackSettings:new(header.trackSettings),
    trackDrawDistance = trackDrawDistance:new(header.trackDrawDistances)
  }
  
  return parsedHeader
end

-- FILE 2
function parser.parseCourseLine(trackPieces)
  local trackPieceArray = require("csvToDat.structs.trackPieceArray")

  return trackPieceArray:new(trackPieces)
end

-- FILE 3
function parser.parseNotes(notes)
  local noteArray = require("csvToDat.structs.noteArray")

  return noteArray:new(notes)
end

-- FILE 4
function parser.parseCamera(cameraObjects)
  local cameraArray = require("csvToDat.structs.cameraArray")

  return cameraArray:new(cameraObjects)
end

-- FILE 5
function parser.parseParticles(particleObjects)
  local particleArray = require("csvToDat.structs.particleArray")

  return particleArray:new(particleObjects)
end

-- FILE 6
function parser.parseVisualizers(visualizerObjects)
  local visualizerArray = require("csvToDat.structs.visualizerArray")

  return visualizerArray:new(visualizerObjects)
end

-- FILE 7
function parser.parseColorTable(colorTableEntries)
  local colorTableArray = require("csvToDat.structs.colorTableArray")

  return colorTableArray:new(colorTableEntries)
end

-- FILE 8
function parser.parseColorTable2(colorTable2Entries2)
  local colorTable2Array = require("csvToDat.structs.colorTable2Array")
  
  local ct1 = {}
  local ct2 = colorTable2Entries2
  local ct3 = {}
  local ct4 = {}

  return colorTable2Array:new(ct1, ct2, ct3, ct4)
end

-- FILE 9
function parser.parseObjects(objects)
  local objectArray = require("csvToDat.structs.objectArray")
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

function parser.parseToDatFile(parsedFiles)
  local int32 = require("csvToDat.variableTypes.int32")
  
  parsedFiles.courseline = parser.parseCourseLine(parsedFiles.courseline)
  parsedFiles.notes = parser.parseNotes(parsedFiles.notes)
  parsedFiles.camera = parser.parseCamera(parsedFiles.camera)
  parsedFiles.particles = parser.parseParticles(parsedFiles.particles)
  parsedFiles.visualizers = parser.parseVisualizers(parsedFiles.visualizers)
  parsedFiles.colorTable = parser.parseColorTable(parsedFiles.colorTable)
  parsedFiles.objects = parser.parseObjects(parsedFiles.objects)
  parsedFiles.colorTable2 = parser.parseColorTable2(parsedFiles.colorTable2)
  
  local stageConfigPointer = int32:new(int32.size() * 13)
  local trackDrawDistancePointer = int32:new(
    stageConfigPointer.x
    + parsedFiles.header.stageConfig:size() 
    + parsedFiles.header.fileNameArray:size() 
    + parsedFiles.header.trackSettings:size()
  )
  
  local trackPointer = int32:new(
    trackDrawDistancePointer.x 
    + parsedFiles.header.trackDrawDistance:size()
  )
  
  local notePointer = int32:new(
    trackPointer.x 
    + parsedFiles.courseline:size()
  )
  
  local cameraPointer = int32:new(
    notePointer.x 
    + parsedFiles.notes:size()
  )
  
  local particlePointer = int32:new(
    cameraPointer.x 
    + parsedFiles.camera:size()
  )
  
  local visualizerPointer = int32:new(
    particlePointer.x 
    + parsedFiles.particles:size()
  )
  
  local unkPointer1 = int32:new(
    visualizerPointer.x 
    + parsedFiles.visualizers:size()
  )
  
  local colorTablePointer = int32:new(
    unkPointer1.x 
    + (int32.size() * 2)
  )
  
  local objectPointer = int32:new(
    colorTablePointer.x 
    + parsedFiles.colorTable:size()
  )
  
  local unkPointer2 = int32:new(48)
  
  local colorTable2Pointer = int32:new(
    objectPointer.x 
    + parsedFiles.objects:size()
  )
  
  local unk4 = int32:new(10705)
  
  local header = require("csvToDat.header")
  local file = love.filesystem.newFile(header.fileNameList.chartName .. ".dat")
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
  
  file:write(parsedFiles.header.stageConfig:toByte())
  file:write(parsedFiles.header.fileNameArray:toByte())
  file:write(parsedFiles.header.trackSettings:toByte())
  file:write(parsedFiles.header.trackDrawDistance:toByte())
  
  file:write(parsedFiles.courseline:toByte())
  file:write(parsedFiles.notes:toByte())
  file:write(parsedFiles.camera:toByte())
  file:write(parsedFiles.particles:toByte())
  file:write(parsedFiles.visualizers:toByte())
  
  file:write(int32:new(0):toByte())
  file:write(int32:new(0):toByte())
  
  file:write(parsedFiles.colorTable:toByte())
  file:write(parsedFiles.objects:toByte())
  file:write(parsedFiles.colorTable2:toByte())
  
  file:close()
end

return parser