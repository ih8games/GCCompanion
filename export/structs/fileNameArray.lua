local charArray = require("export.variableTypes.charArray")

local fileNameArray = {}
fileNameArray.__index = fileNameArray

function fileNameArray:new(header)
  local obj = {
    chartName = charArray:new(header.chartName),
    chartName2 = charArray:new(header.chartName),
    bgmName = charArray:new(header.bgmName),
    shotName = charArray:new(header.shotName)
  }
  
  return setmetatable(obj, self)
end

function fileNameArray:toByte()
  return string.format("%s%s%s%s",
    self.chartName:toByte(),
    self.chartName2:toByte(),
    self.bgmName:toByte(),
    self.shotName:toByte()
  )
end

function fileNameArray:size()
  return self.chartName:size() + self.chartName2:size() + self.bgmName:size() + self.shotName:size()
end

return fileNameArray