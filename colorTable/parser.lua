local stack = require("common.stack")
local colorObject = require("colorTable.colorObject")
local csvParser = require("common.csvParser")

local parser = {}

function parser.toFile(colorObjects)
  local file = love.filesystem.newFile("colorTable.csv")
  local file2 = love.filesystem.newFile("colorTable2.csv")
  
  file:open("w")
  file2:open("w")

  for _,v in pairs (colorObjects) do
    local table1, table2 = v:output()
    
    file:write(table1)
    file2:write(table2)
  end
  
  file:close()
  file2:close()
  
  return file, file2
end

function parser.fromFile(colorFile, colorFile2)
  local colorObjects = csvParser.parseColorTable(colorFile)
  local colorObjects2 = csvParser.parseColorTable2(colorFile2)
  
  if (not colorObjects) and (not colorObjects2) then
    return
  end
  
  local colorStack = stack:new("ColorStack", "Background Color", colorObject)
  colorStack:set(#colorObjects)
  
  for i,v in pairs (colorStack.items) do
    local tr = colorObjects[i].topRight
    local tl = colorObjects[i].topLeft
    local br = colorObjects[i].bottomRight
    local bl = colorObjects[i].bottomLeft
    
    local c = colorObjects2[i].center
    local t = colorObjects2[i].top
    local b = colorObjects2[i].bottom
    local l = colorObjects2[i].left
    local r = colorObjects2[i].right
    
    colorObjects[i].topRight    = {tr[1] / 255, tr[2] / 255, tr[3] / 255, tr[4] / 255}
    colorObjects[i].topLeft     = {tl[1] / 255, tl[2] / 255, tl[3] / 255, tl[4] / 255}
    colorObjects[i].bottomRight = {br[1] / 255, br[2] / 255, br[3] / 255, br[4] / 255}
    colorObjects[i].bottomLeft  = {bl[1] / 255, bl[2] / 255, bl[3] / 255, bl[4] / 255}
    
    colorObjects2[i].center     = {c[1] / 255, c[2] / 255, c[3] / 255, c[4] / 255}
    colorObjects2[i].top        = {t[1] / 255, t[2] / 255, t[3] / 255, t[4] / 255}
    colorObjects2[i].bottom     = {b[1] / 255, b[2] / 255, b[3] / 255, b[4] / 255}
    colorObjects2[i].left       = {l[1] / 255, l[2] / 255, l[3] / 255, l[4] / 255}
    colorObjects2[i].right      = {r[1] / 255, r[2] / 255, r[3] / 255, r[4] / 255}
    
    colorStack.items[i] = colorObject:fromArguments(colorObjects[i], colorObjects2[i])
  end
  
  return colorStack  
end

return parser