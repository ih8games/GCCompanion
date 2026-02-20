local lmath = {}

function lmath.round(x)
  return math.floor(x + 0.50)
end

function lmath.clamp(x, min, max)
  return math.max(min, math.min(max, x))
end

return lmath