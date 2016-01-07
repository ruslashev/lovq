require "gfx"
require "misc"

local wind_width = 800
local wind_height = 600

local tree = {}
function make_bsp(list)
  local head = list[1]
  table.remove(list, 1)
  local k = (head[4] - head[2]) / (head[3] - head[1])
  local node = { head }
  if #list ~= 0 then
    for _,v in ipairs(list) do
      local sx, sy, ex, ey = v[1], v[2], v[3], v[4]
      local first_in_front = (sy <= k * sx)
      local second_in_front = (ey <= k * ex)
      if first_in_front and second_in_front then
        node.right = v
        table.insert(node.right, make_bsp(list))
      elseif not first_in_front and not second_in_front then
        node.left = v
        table.insert(node.left, make_bsp(list))
      else
        local k2 = (ey - sy) / (ex - sx)
        local b2 = sy - k * sx
        local x_int = b2 / (k - k2)
        local y_int = k * x_int
        node.left = {sx, sy, x_int, y_int}
        node.right = {x_int, y_int, ex, ey}
        table.insert(node.right, make_bsp(list))
        table.insert(node.left, make_bsp(list))
      end
    end
  end
  table.insert(tree, node)
  return node
end

local bsp
function love.load()
  love.window.setMode(wind_width, wind_height, { vsync = false })
  love.graphics.setLineStyle("rough")

  local map = {
    {   0,   0,   0, 100},
    {   0, 100, 100, 100},
    { 100, 100, 100,   0},
    { 100,   0,   0,   0},
    {  11,  21,  22,  80},
    {  33,  60,  67,  64},
    {  82,  17,  72,  80},
  }

  bsp = make_bsp(map)
end

local t = 0
function love.update(dt)
  t = t + dt
  if love.keyboard.isDown("q") then
    love.event.push("quit")
  end
end

function draw_bsp(bsp)
  local lines
  table.insert(lines, bsp[1])
  table.remove(bsp, 1)
  if not bsp.right then
    table.insert(lines, draw_bsp(bsp.right))
  end
  if not bsp.left then
    table.insert(lines, draw_bsp(bsp.left))
  end
  return lines
end

function love.draw()
  lines = draw_bsp(bsp)
  local step = 1 / #lines
  local h = 0
  for _,v in ipairs(lines) do
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

