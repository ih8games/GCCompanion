local float = require("export.variableTypes.float")
local int16 = require("export.variableTypes.int16")
local int32 = require("export.variableTypes.int32")

local bpmChangeArray = require("export.structs.bpmChangeArray")
local noteSettingArray = require("export.structs.noteSettingArray")

local stageConfig = {}
stageConfig.__index = stageConfig

local noteSettings = {
  {0, 0, 0.50},
  {0, 0, 0.50},
  {0, 0, 0.50},
  {0, 0, 0.50},
}

function stageConfig:new(header, bpmChanges)
  local obj = {
    endTime = float:new(header.endTime),
    outroTime = float:new(header.outroTime),
    bpmChangeArray = bpmChangeArray:new(bpmChanges),
    noteSettingArray = noteSettingArray:new(noteSettings)
  }
  
  return setmetatable(obj, self)
end

function stageConfig:toByte()
  local bytes = string.format("%s%s%s%s%s",
    self.endTime:toByte(),
    self.endTime:toByte(),
    self.outroTime:toByte(),
    self.bpmChangeArray:toByte(),
    self.noteSettingArray:toByte()
  )
  
  return bytes
end

function stageConfig:size()
  return float.size() * 3 + self.bpmChangeArray:size() + self.noteSettingArray:size()
end

return stageConfig