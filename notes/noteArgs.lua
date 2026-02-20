local noteArgs = {}

function noteArgs.get()
  return {
    noteNumber = 0,
    timestampMs = 0,
    endTimestampMs = 0,
    
    rotationFront = 0,
    rotationFront2 = 0,
    holdTimeBeats = 0,
    
    noteColor = {1, 1, 1, 1},
    hitTrailMaskColor = {1, 1, 1, 1},
    
    flyInBool = 0,
    showFlyInLinBool = 0,
    flyInDistance = 0,
    flyInRotationTop = 0,
    flyInRotationTop2 = 0,
    flyDelayTimeBeats = 0,
    flyEndTimeBeats = 0,
    flyAnimationRepeatCount = 0,
    
    isDualFlick = 0
  }
end

return noteArgs