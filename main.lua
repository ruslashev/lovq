require "gfx"
require "misc"

local wind_width = 800
local wind_height = 600

function pop_front(list)
  local elem = table.remove(list, 1)
  return elem
end

function make_bsp(list)
  local root = { list = list }
  bsp_recursive_function(root)
  return root
end

function bsp_recursive_function(branch)
  if #branch.list ~= 0 then
    local head = pop_front(branch.list)
    branch.line = head
    local k = (head[4] - head[2]) / (head[3] - head[1])
    while true do
      if #branch.list == 0 then
        branch.list = nil
        break
      end
      local v = branch.list[1]
      local sx, sy, ex, ey = v[1], v[2], v[3], v[4]
      local first_in_front = (sy <= k * sx)
      local second_in_front = (ey <= k * ex)
      if first_in_front and second_in_front then
        if branch.front == nil then -- same as 'no element in table'
          branch.front = { list = {} }
        end
        table.insert(branch.front.list, v)
      elseif not first_in_front and not second_in_front then
        if branch.back == nil then
          branch.back = { list = {} }
        end
        table.insert(branch.back.list, v)
      else
        local k2 = (ey - sy) / (ex - sx)
        local b2 = sy - k * sx
        local x_int = b2 / (k - k2)
        local y_int = k * x_int
        if branch.front == nil then
          branch.front = { list = {} }
        end
        if branch.back == nil then
          branch.back = { list = {} }
        end
        table.insert(branch.front.list, { x_int, y_int, ex, ey })
        table.insert(branch.back.list, { sx, sy, x_int, y_int })
      end
      table.remove(branch.list, 1)
    end
    if branch.front ~= nil then
      bsp_recursive_function(branch.front)
    elseif branch.back ~= nil then
      bsp_recursive_function(branch.back)
    end
  end
end

local bsp
function love.load()
  love.window.setMode(wind_width, wind_height, { vsync = false })
  love.graphics.setLineStyle("rough")

  local map = {
    -- sx   sy   ex   ey
    --[[
    {   0,   0,   0, 100},
    {   0, 100, 100, 100},
    { 100, 100, 100,   0},
    { 100,   0,   0,   0},
    ]]
    {  11,  21,  22,  80},
    {  33,  60,  67,  64},
    {  82,  17,  72,  80},
  }

  bsp = make_bsp(map)
  print(DataDumper(bsp))
  love.event.push("quit")
end

local t = 0
function love.update(dt)
  t = t + dt
  if love.keyboard.isDown("q") then
    love.event.push("quit")
  end
end

function draw_bsp(bsp)
  if #bsp == 0 then
    return {}
  end
  local lines = {}
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

