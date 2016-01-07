function hsv2rgb(h, s, v)
  local i = math.floor(h * 6 + 0.5)
  local f = h * 6 - i
  local p = v * (1 - s)
  local q = v * (1 - f * s)
  local t = v * (1 - (1 - f) * s)

  local r, g, b
  local w = i % 6
  if w == 0 then r = v; g = t; b = p
  elseif w == 1 then r = q; g = v; b = p;
  elseif w == 2 then r = p; g = v; b = t;
  elseif w == 3 then r = p; g = q; b = v;
  elseif w == 4 then r = t; g = p; b = v;
  elseif w == 5 then r = v; g = p; b = q;
  end

  return {r * 255, g * 255, b * 255}
end

-- vim: et:sw=2

