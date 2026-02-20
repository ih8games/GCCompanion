local trackPiece = require("export.structs.trackPiece")
local int32 = require("export.variableTypes.int32")

local trackPieceArray = {}
trackPieceArray.__index = trackPieceArray

function trackPieceArray:new(trackPieces)
  local obj = {
    length = int32:new(#trackPieces),
    trackPieces = {}
  }
  
  for i,v in pairs (trackPieces) do
    obj.trackPieces[i] = trackPiece:new(v)
  end
  
  return setmetatable(obj, self)
end

function trackPieceArray:toByte()
  local bytes = self.length:toByte()
  
  for _,v in pairs (self.trackPieces) do
    bytes = string.format("%s%s", bytes, v:toByte())
  end
  
  return bytes
end

function trackPieceArray:size()
  return trackPiece.size() * self.length.x + int32.size()
end

return trackPieceArray