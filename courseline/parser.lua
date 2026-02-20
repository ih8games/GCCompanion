local parser = {}

local vertices = {}

local startingIndex = 0
local header = "INDEX,MS,X,Y,Z\r\n"
local block = "%d,%d,%f,%f,%f\r\n"

local totalLines = 0

function parser.parseLine(line)
  local t = {}
  
  for str in string.gmatch(line, "([^%s]+)") do
    table.insert(t, str)
  end
  
  if t[1] == "v" then
    local p = { tonumber(t[2]), tonumber(t[4]), tonumber(t[3]) }
    
    vertices[#vertices + 1] = p
    return
  end
end

function parser.generateCSV()
  local file = love.filesystem.newFile("courseline.csv")
  
  file:open("w")
  file:write(header)
  
  local currentIndex = 1
  
  while currentIndex <= #vertices do
    local point = vertices[currentIndex]
    
    file:write(string.format(block, currentIndex, 0, point[1], point[2], point[3]))
    currentIndex = currentIndex + 1
  end
  
  file:close()
  
  return file
end

function parser.toFile(file)
  for line in file:lines() do
    parser.parseLine(line)
  end
  
  parser.generateCSV()
  
  vertices = {}
  lines = {}
  
  startingIndex  = 0
end

return parser