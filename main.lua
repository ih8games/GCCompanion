local currentScene
local output

function swapScene(scene)
  local newScene = scenes[scene]
  
  if not newScene then
    return
  end
  
  currentScene = newScene
end

function saveFile()
  currentScene.saveToFile()
end

function saveFiles()
  for _,v in pairs (scenes) do
    if v.saveToFile then
      v.saveToFile()
    end
  end
end

function loadFile()
  currentScene.loadFromFile()
end

function loadFiles()
  for _,v in pairs (scenes) do
    if v.loadFromFile then
      v.loadFromFile()
    end
  end
end

function love.load(args)
  love.window.setMode(1280, 720, {})
  love.window.setTitle("GCCompanion")
  
  if love.filesystem.isFused() then
    local path = love.filesystem.getSourceBaseDirectory()
    local success = love.filesystem.mount(path, "GCCompanion", true)
    
    if not success then
      print("NOT mounted, files will NOT save or load")
    end
  end
  
  print(love.getVersion())
  
  Slab = require("Slab.Slab")
  
  Slab.SetINIStatePath(nil)
  Slab.Initialize(args)
  
  scenes = {
    [1] = require("header.scene"),
    [2] = require("courseline.scene"),
    [3] = require("notes.scene"),
    [4] = require("camera.scene"),
    [5] = require("visualizers.scene"),
    [6] = require("particles.scene"),
    [7] = require("colorTable.scene"),
    [8] = require("objects.scene")
    --[9] = require("avatarColor.scene"),
    --[10] = require("objectColor.scene")
  }
  
  output = require("export.scene")
  currentScene = scenes[1]
end

function love.draw()
  if currentScene.draw then
    currentScene.draw()
  end
  
  Slab.Draw()
end

function love.update(dt)
  Slab.Update(dt)
  
  if currentScene.update then
    currentScene.update(dt)
  end
  
   if Slab.BeginMainMenuBar() then
    if Slab.BeginMenu("File") then
      if Slab.MenuItem("Save") then
        saveFiles()
      end
      
      if Slab.MenuItem("Save All") then
        saveFiles()
      end
      
      if Slab.MenuItem("Load") then
        loadFile()
      end
      
      if Slab.MenuItem("Load All") then
        loadFiles()
      end
      
      if Slab.MenuItem("Export") then
        saveFiles()
        output.toStageFile()
      end
      
      Slab.EndMenu()
    end
  
    if Slab.BeginMenu("View") then
      if Slab.MenuItem("Header (F1)") then
        swapScene(1)
      end
      
      if Slab.MenuItem("Course Line (F2)") then
        swapScene(2)
      end
      
      if Slab.MenuItem("Notes (F3)") then
        swapScene(3)
      end
      
      if Slab.MenuItem("Camera (F4)") then
        swapScene(4)
      end
      
      if Slab.MenuItem("Visualizers (F5)") then
        swapScene(5)
      end
      
      if Slab.MenuItem("Particles (F6)") then
        swapScene(6)
      end
      
      if Slab.MenuItem("Background Color (F7)") then
        swapScene(7)
      end
      
      if Slab.MenuItem("Stage Objects (F8)") then
        swapScene(8)
      end
      
      --[[
      if Slab.MenuItem("Avatar Color (F9)") then
        swapScene(9)
      end
      
      if Slab.MenuItem("Object Color (F10)") then
        swapScene(10)
      end
      ]]
      
      Slab.EndMenu()
    end
    
    Slab.EndMainMenuBar()
  end
end

function love.keypressed(key)
  if Slab.IsAnyInputFocused() then
    return
  end
  
  if currentScene.keypressed then
    currentScene.keypressed(key)
  end
end

function love.keyreleased(key)
  if Slab.IsAnyInputFocused() then
    return
  end
  
  if currentScene.keyreleased then
    currentScene.keyreleased(key)
  end
  
  if key == "f1" then
    swapScene(1)
    
  elseif key == "f2" then
    swapScene(2)
    
  elseif key == "f3" then
    swapScene(3)
    
  elseif key == "f4" then
    swapScene(4)
    
  elseif key == "f5" then
    swapScene(5)
    
  elseif key == "f6" then
    swapScene(6)
    
  elseif key == "f7" then
    swapScene(7)
    
  elseif key == "f8" then
    swapScene(8)
  
  --[[
  elseif key == "f9" then
    swapScene(9)
    
  elseif key == "f10" then
    swapScene(10)
  ]]
  
  end
end

function love.wheelmoved(x, y)
  if currentScene.wheelmoved then
    currentScene.wheelmoved(x, y)
  end
end

function love.filedropped(file)
  if currentScene.filedropped then
    currentScene.filedropped(file)
  end
end