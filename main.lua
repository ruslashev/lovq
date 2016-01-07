require "gfx"

local wind_width = 800
local wind_height = 600

function love.load()
  love.window.setMode(wind_width, wind_height, { vsync = false })
  love.graphics.setLineStyle("rough")
end

local map = {
  {   0,   0,   0, 100},
  {   0, 100, 100, 100},
  { 100, 100, 100,   0},
  { 100,   0,   0,   0},
  {  11,  21,  22,  80},
  {  33,  60,  67,  64},
  {  82,  17,  72,  80},
}

local t = 0
function love.update(dt)
  t = t + dt
  if love.keyboard.isDown("q") then
    love.event.push("quit")
  end
end

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

function love.draw()
  local step = 1 / #map
  local h = 0
  for _,v in ipairs(map) do
    local sx, sy, ex, ey = v[1], v[2], v[3], v[4]
    sy = wind_height - sy
    ey = wind_height - ey
    sx = sx + 1
    ex = ex + 1
    love.graphics.setColor(hsv2rgb(h, 0.6, 1))
    h = h + step
    love.graphics.line(sx, sy, ex, ey)
  end
end

-- vim: et:sw=2

