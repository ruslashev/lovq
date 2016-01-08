require "gfx"

local wind_width = 800
local wind_height = 600

function parse_file()
  io.input("su.obj")
  vertices = {}
  triangles = {}
  while true do
    local line = io.read()
    if line == nil then
      break
    end
    local first = line:sub(1,1)
    if first == "v" then
      v1, v2, v3 = line:match("^v (.-) (.-) (.-)$")
      table.insert(vertices, { tonumber(v1), tonumber(v2), tonumber(v3) })
    elseif first == "f" then
      f1, f2, f3 = line:match("^f (%d-) (%d-) (%d-)$")
      table.insert(triangles, { tonumber(f1), tonumber(f2), tonumber(f3) })
    end
  end
  return vertices, triangles
end

local vertices, triangles
function love.load()
  love.window.setMode(wind_width, wind_height, { vsync = false })
  love.graphics.setLineStyle("rough")

  vertices, triangles = parse_file()
  direct_vertices = {}
  for _,v in ipairs(triangles) do
    table.insert(direct_vertices, { vertices[v[1]], vertices[v[2]], vertices[v[3]] })
  end
end

local t = 0
local mvp
function love.update(dt)
  t = t + dt
  if love.keyboard.isDown("q") then
    love.event.push("quit")
  end

  local dist = 3
  local fovx = math.pi/2
  local fovy = 2 * math.atan((wind_height * math.tan(fovx / 2))/wind_width)
  view = lookAt({ dist * math.cos(t), 0, dist * math.sin(t), 1 },
      { 0, 0, 0, 1 }, { 0, 1, 0, 0 })
  projection = perspective(fovy, wind_width/wind_height, 0.1, 100)
  mvp = mat_mat_mult(projection, view)
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
  local step = 1 / #direct_vertices
  local h = 0
  for i = 1, #direct_vertices do
    v = direct_vertices[i]
    v1x, v1y = vertex_to_screen(v[1], mvp, wind_width, wind_height)
    v2x, v2y = vertex_to_screen(v[2], mvp, wind_width, wind_height)
    v3x, v3y = vertex_to_screen(v[3], mvp, wind_width, wind_height)
    love.graphics.setColor(hsv2rgb(h, 0.6, 1))
    h = h + step
    love.graphics.line({ v1x, v1y, v2x, v2y, v3x, v3y })
  end
  --[[
  for _,v in ipairs(direct_vertices) do
    vx = { v[1], v[2], v[3], 1 }
    v_s = mat_vec_mult(mvp, vx)
    v_s = vec_scalar_divide(v_s, v_s[4])
    love.graphics.points(wind_width*(v_s[1]+1)/2, wind_height*(v_s[2]+1)/2)
  end
  ]]
end

-- vim: et:sw=2

