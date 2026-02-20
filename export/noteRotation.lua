local vector3 = require("common.vector3")

local noteRotation = {}

local function getObjectIndex(timestampMs, objects)
  local objectIndex = -1
  
  for i,v in pairs (objects) do
    if v.timestampMs == timestampMs then
      objectIndex = i
      break
      
    elseif v.timestampMs > timestampMs then
      objectIndex = i - 1
      break
    end
  end
  
  return objectIndex
end

local function lerp(t, p0, p1)
  return (1 - t) * p0 + t * p1
end

local function getCurrentCameraRotation(timestampMs, cameras, courselines)
  local cameraIndex = getObjectIndex(timestampMs, cameras)
  
  local c0 = cameras[cameraIndex]
  local c1 = cameras[cameraIndex + 1]
  
  local cameraRotation
  local tCam = (timestampMs - c0.timestampMs) / (c1.timestampMs - c0.timestampMs)
  
  -- STATIC_FOLLOW // ROTATION DOES NOT CHANGE
  if c0.fMode == 0 then
    cameraRotation = vector3:new(c0.rotation[1], c0.rotation[2], c0.rotation[3])
    
  else
    local r0 = vector3:new(c0.rotation[1], c0.rotation[2], c0.rotation[3])
    local r1 = vector3:new(c1.rotation[1], c1.rotation[2], c1.rotation[3])
    
    cameraRotation = lerp(tCam, r0, r1)
  end
  
  local rotation = cameraRotation.x + cameraRotation.z
  
  -- gimbal lock
  if cameraRotation.y >= 90 and cameraRotation.y <= 100 then
    return rotation
  end
  
  -- gimbal lock, but mirrored
  -- not sure how you get to these angles without artifacts in the chart
  if cameraRotation.y >= 80 and cameraRotation.y < 90 then
    return rotation + 180
  end
  
  return rotation
end

function noteRotation.calculateNoteRotations(cameras, courselines, notes)
  local newNotes = {}

  for i,note in pairs (notes) do
    local rotation
    
    if note.noteType == 2 or note.noteType == 10 then
      rotation = getCurrentCameraRotation(note.timestampMs, cameras, courselines)
      note.rotationFront = note.rotationFront + rotation
      
      if note.rotationFront > 180 then
        local mod = math.fmod(note.rotationFront, 180)
        
        note.rotationFront = (mod - 180)
      end
      
      if note.isDualSlide == 1 then
        note.rotationFront2 = note.rotationFront2 + rotation
      
        if note.rotationFront2 > 180 then
          local mod = math.fmod(note.rotationFront2, 180)
          
          note.rotationFront2 = (mod - 180)
        end
      end
      
    end
    
    newNotes[i] = note
  end
  
  return newNotes
end

return noteRotation