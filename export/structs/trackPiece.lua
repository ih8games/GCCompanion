local int32 = require("export.variableTypes.int32")
local float = require("export.variableTypes.float")

local trackPiece = {}
trackPiece.__index = trackPiece

function trackPiece:new(piece)
  local obj = {
    timestampMs = int32:new(piece.timestampMs),
    position = {
      float:new(piece.position[1]),
      float:new(piece.position[2]),
      float:new(piece.position[3]),
    }
  }
  
  return setmetatable(obj, self)
end

function trackPiece:toByte()
  return string.format("%s%s%s%s",
    self.timestampMs:toByte(),
    self.position[1]:toByte(),
    self.position[2]:toByte(),
    self.position[3]:toByte()
  )
end

function trackPiece:size()
  return float.size() * 3 + int32.size()
end

return trackPiece