local scene = {}

local header

local drawDistanceStack
local drawDistanceObject
local parser

local displayColor
local difficulties = {"Simple", "Normal", "Hard", "Extra"}

function scene.load()
  drawDistanceStack = require("header.drawDistanceStack")
  drawDistanceObject = require("header.drawDistanceObject")
  parser = require("header.parser")
  
  header = {
    chartName = "chartName",
    bgmName = "chartName_bgm",
    shotName = "chartName_shot",
    difficulty = 2,
    
    endTime = 120,
    outroTime = 120,
    
    trackAheadColor = {0, 1, 1, 1},
    trackBehindColor = {1, 1, 1, 1},
    unknownColor = {0, 0, 0, 1},
    
    forwardDrawDistance = 8,
    backwardDrawDistance = 6,
    
    audioOffset = 0,
    visualOffset = 0,
    
    drawDistanceStack = drawDistanceStack:new("DrawDistance", "Draw Distance", drawDistanceObject, "Draw Distance Stack Size : "),
  }
  
  connection = header.drawDistanceStack.changedEvent:connect(function(items)
    scene.drawDistanceChanged(items)
  end)
  
  displayColor = false
end

function scene.update(dt)
  local w, h = love.graphics.getDimensions()
  
  local x = (w / 2) - 300
  local y = (h / 2) - 300
  
  Slab.BeginWindow("Header", {Title = "Header", X = x, Y = y, W = 600, H = 600, AutoSizeWindow = false, AllowMove = false, AllowResize = false})
  
  Slab.BeginLayout("HeaderLayout", {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
    
  Slab.SetLayoutColumn(1)
  Slab.Text("Chart Name : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("ChartNameInput", {W = 240, AlignX = "center", Text = header.chartName, ReturnOnText = false, NumbersOnly = false}) then
    local input = tostring(Slab.GetInputText())
    
    if input == "" then
      input = "chartName"
    end
    
    header.chartName = input
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("BGM Name : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("BGMNameInput", {W = 240, AlignX = "center", Text = header.bgmName, ReturnOnText = false, NumbersOnly = false}) then
    local input = tostring(Slab.GetInputText())
    
    if input == "" then
      input = "chartName_bgm"
    end
    
    header.bgmName = input
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("SHOT Name : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("ShotNameInput", {W = 240, AlignX = "center", Text = header.shotName, ReturnOnText = false, NumbersOnly = false}) then
    local input = tostring(Slab.GetInputText())
    
    if input == "" then
      input = "chartName_shot"
    end
    
    header.shotName = input
  end
  
  --[[
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Difficulty : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.BeginComboBox("DifficultyInput", {W = 240, Selected = difficulties[header.difficulty + 1]}) then
    for i,v in pairs (difficulties) do
      if Slab.TextSelectable(v) then
        header.difficulty = i - 1
      end
    end
    
    Slab.EndComboBox()
  end
  
  ]]
  
  Slab.EndLayout()
  Slab.Separator()
  
  Slab.BeginLayout("HeaderLayout2", {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("End Time : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("EndTime", {W = 240, Text = header.endTime, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 120.000
    header.endTime = math.abs(input)
    
    scenes[3].setEndTime(header.endTime)
  end
    
  Slab.SetLayoutColumn(1)
  Slab.Text("Outro Time : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("OutroTime", {W = 240, Text = header.outroTime, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 120.000
    header.outroTime = math.abs(input)
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Audio Offset : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("AudioOffset", {W = 240, Text = header.audioOffset, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    header.audioOffset = input
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Visual Offset : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("VisualOffset", {W = 240, Text = header.visualOffset, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 0
    header.visualOffset = input
  end
  
  Slab.EndLayout()
  Slab.Separator()
  
  Slab.BeginLayout("HeaderLayout3", {AlignX = "center", AnchorX = true, ExpandW = false, Columns = 2})
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Courseline Forward Color : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Button("", {W = 240, H = 16, Color = header.trackAheadColor}) then
    if displayColor == "trackAheadColor" then
      displayColor = false
      
    else
      displayColor = "trackAheadColor"
    end
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Forward Draw Distance : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("ForwardDrawDistance", {W = 240, Text = header.forwardDrawDistance, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 8
    header.forwardDrawDistance = input
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Courseline Behind Color : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Button("", {W = 240, H = 16, Color = header.trackBehindColor}) then
    if displayColor == "trackBehindColor" then
      displayColor = false
      
    else
      displayColor = "trackBehindColor"
    end
  end
  
  Slab.SetLayoutColumn(1)
  Slab.Text("Backward Draw Distance : ")
  
  Slab.SetLayoutColumn(2)
  
  if Slab.Input("BackwardDrawDistance", {W = 240, Text = header.backwardDrawDistance, ReturnOnText = false, NumbersOnly = true}) then
    local input = tonumber(Slab.GetInputText()) or 6
    header.backwardDrawDistance = input
  end
    
  Slab.EndLayout()
  Slab.Separator()
  
  header.drawDistanceStack:update()
  
  if #header.drawDistanceStack.items > 0 then
    Slab.Separator()
  end
  
  Slab.EndWindow()
  
  if not displayColor then
    return
  end
  
  local out = Slab.ColorPicker({Color = header[displayColor]})
  
  if out.Button == 1 then
    header[displayColor] = out.Color
    displayColor = false
    
  elseif out.Button == -1 then
    displayColor = false
  end
end

function scene.saveToFile()
  parser.toFile(header)
end

function scene.loadFromFile()
  local newHeader = parser.fromFile()
  
  if newHeader then
    header = newHeader

    scenes[3].setEndTime(header.endTime)
  end
end

function scene.drawDistanceChanged(items)
  --scenes[9].set(items)
  --scenes[10].set(items)
end

scene.load()

return scene