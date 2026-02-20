local stackObject = require("common.stackObject")

local aModes = {"TWEEN_FORWARD", "STOP", "TWEEN_BIDIRECTIONAL", "STOP_AND_FACE_PLAYER", "GLOBAL"}
local fModes = {"STATIC", "UNFOLLOW", "FOLLOW"}
local projectionTypes = {"ORTHOGRAPHIC", "PERSPECTIVE"}

local cameraObject = stackObject:new()
cameraObject.__index = cameraObject

function cameraObject:new()
  local obj = stackObject:new()
  
  obj.timestampMs = 0
  
  obj.aMode = 0
  obj.fMode = 0
  obj.projectionType = 1
  
  obj.cameraDistance = 20
  
  obj.rotation = {0, 135, 0}
  obj.originOffset = {0, 0, 0}
  obj.globalFieldFar = {0, 0, 0}
  obj.globalFieldNear = {0, 0, 0}
  
  return setmetatable(obj, self)
end

function cameraObject:fromArguments(args)
  local obj = stackObject:new()
  
  obj.timestampMs = args.timestampMs
  
  obj.aMode = args.aMode
  obj.fMode = args.fMode
  obj.projectionType = args.projectionType
  
  obj.cameraDistance = args.cameraDistance
  
  obj.rotation = args.rotation
  obj.originOffset = args.originOffset
  obj.globalFieldFar = args.globalFieldFar
  obj.globalFieldNear = args.globalFieldNear
  
  return setmetatable(obj, self)
end

function cameraObject:output()
  return string.format("%d,%d,%d,%f,%f,%f,%f,%f,%f,%d,%f,%f,%f,%f,%f,%f,%f\r\n",
    self.timestampMs,
    self.aMode,
    self.fMode,
    self.cameraDistance,
    self.rotation[1],
    self.rotation[2],
    self.originOffset[1],
    self.originOffset[2],
    self.originOffset[3],
    self.projectionType,
    self.globalFieldFar[1],
    self.globalFieldFar[2],
    self.globalFieldFar[3],
    self.globalFieldNear[1],
    self.globalFieldNear[2],
    self.globalFieldNear[3],
    self.rotation[3]
  )
end

function cameraObject:update(i)
  self.header = string.format("[%d] : Camera Object", i - 1)
  stackObject.update(self)
  
  if not self.expanded then
    return
  end
  
  Slab.Separator()
  Slab.BeginLayout("CameraLayout" .. self.id, {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Timestamp MS : ")

  Slab.SetLayoutColumn(2)

  if Slab.Input("MSInput" .. self.id, {W = 240, Text = self.timestampMs, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.timestampMs = math.floor(math.abs(input))
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Animation Mode : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.BeginComboBox("AMode" .. self.id, {W = 240, Selected = aModes[self.aMode + 1]}) then
    for i,v in pairs (aModes) do
      if Slab.TextSelectable(v) then
        self.aMode = i - 1
      end
    end
    
    Slab.EndComboBox()
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Follow Mode : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.BeginComboBox("FMode" .. self.id, {W = 240, Selected = fModes[self.fMode + 1]}) then
    for i,v in pairs (fModes) do
      if Slab.TextSelectable(v) then
        self.fMode = i - 1
      end
    end
    
    Slab.EndComboBox()
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Projection Type : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.BeginComboBox("projectionType" .. self.id, {W = 240, Selected = projectionTypes[self.projectionType + 1]}) then
    for i,v in pairs (projectionTypes) do
      if Slab.TextSelectable(v) then
        self.projectionType = i - 1
      end
    end
    
    Slab.EndComboBox()
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Camera Distance : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("CameraDistance" .. self.id, {W = 240, Text = self.cameraDistance, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.cameraDistance = math.abs(input)
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Rotation (X, Y, Z) : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("RotationX" .. self.id, {W = 75, Text = self.rotation[1], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.rotation[1] = input
  end
  
  Slab.SameLine()
  
  if Slab.Input("RotationY" .. self.id, {W = 75, Text = self.rotation[2], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.rotation[2] = input
  end
  
  Slab.SameLine()
  
  if Slab.Input("RotationZ" .. self.id, {W = 75, Text = self.rotation[3], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.rotation[3] = input
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Origin Offset (X, Y, Z) : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("OriginOffsetX" .. self.id, {W = 75, Text = self.originOffset[1], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.originOffset[1] = input
  end
  
  Slab.SameLine()
  
  if Slab.Input("OriginOffsetY" .. self.id, {W = 75, Text = self.originOffset[2], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.originOffset[2] = input
  end
  
  Slab.SameLine()

  if Slab.Input("OriginOffsetZ" .. self.id, {W = 75, Text = self.originOffset[3], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.originOffset[3] = input
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Global Field Near (X, Y, Z) : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("GlobalFieldNearX" .. self.id, {W = 75, Text = self.globalFieldNear[1], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.globalFieldNear[1] = input
  end
  
  Slab.SameLine()
  
  if Slab.Input("GlobalFieldNearY" .. self.id, {W = 75, Text = self.globalFieldNear[2], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.globalFieldNear[2] = input
  end
  
  Slab.SameLine()
  
  if Slab.Input("GlobalFieldNearZ" .. self.id, {W = 75, Text = self.globalFieldNear[3], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.globalFieldNear[3] = input
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Global Field Far (X, Y, Z) : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("GlobalFieldFarX" .. self.id, {W = 75, Text = self.globalFieldFar[1], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.globalFieldFar[1] = input
  end
  
  Slab.SameLine()
  
  if Slab.Input("GlobalFieldFarY" .. self.id, {W = 75, Text = self.globalFieldFar[2], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.globalFieldFar[2] = input
  end
  
  Slab.SameLine()
  
  if Slab.Input("GlobalFieldFarZ" .. self.id, {W = 75, Text = self.globalFieldFar[3], ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    self.globalFieldFar[3] = input
  end
  
  Slab.EndLayout()
  Slab.Separator()
end

return cameraObject