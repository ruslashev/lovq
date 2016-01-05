function dot_product(vec1, vec2)
  return vec1[1] * vec2[1]
  + vec1[2] * vec2[2]
  + vec1[3] * vec2[3]
  + vec1[4] * vec2[4]
end

function mat_vec_mult(mat, vec)
  return { dot_product(mat[1], vec)
  , dot_product(mat[2], vec)
  , dot_product(mat[3], vec)
  , dot_product(mat[4], vec) }
end

function mat_mat_mult(mat1, mat2)
  return { {
      dot_product(mat1[1], { mat2[1][1], mat2[2][1], mat2[3][1], mat2[4][1] }),
      dot_product(mat1[1], { mat2[1][2], mat2[2][2], mat2[3][2], mat2[4][2] }),
      dot_product(mat1[1], { mat2[1][3], mat2[2][3], mat2[3][3], mat2[4][3] }),
      dot_product(mat1[1], { mat2[1][4], mat2[2][4], mat2[3][4], mat2[4][4] })
    }, {
      dot_product(mat1[2], { mat2[1][1], mat2[2][1], mat2[3][1], mat2[4][1] }),
      dot_product(mat1[2], { mat2[1][2], mat2[2][2], mat2[3][2], mat2[4][2] }),
      dot_product(mat1[2], { mat2[1][3], mat2[2][3], mat2[3][3], mat2[4][3] }),
      dot_product(mat1[2], { mat2[1][4], mat2[2][4], mat2[3][4], mat2[4][4] })
    }, {
      dot_product(mat1[3], { mat2[1][1], mat2[2][1], mat2[3][1], mat2[4][1] }),
      dot_product(mat1[3], { mat2[1][2], mat2[2][2], mat2[3][2], mat2[4][2] }),
      dot_product(mat1[3], { mat2[1][3], mat2[2][3], mat2[3][3], mat2[4][3] }),
      dot_product(mat1[3], { mat2[1][4], mat2[2][4], mat2[3][4], mat2[4][4] })
    }, {
      dot_product(mat1[4], { mat2[1][1], mat2[2][1], mat2[3][1], mat2[4][1] }),
      dot_product(mat1[4], { mat2[1][2], mat2[2][2], mat2[3][2], mat2[4][2] }),
      dot_product(mat1[4], { mat2[1][3], mat2[2][3], mat2[3][3], mat2[4][3] }),
      dot_product(mat1[4], { mat2[1][4], mat2[2][4], mat2[3][4], mat2[4][4] })
    } }
end

function vec_length(vec)
  return math.sqrt(vec[1] * vec[1]
  + vec[2] * vec[2]
  + vec[3] * vec[3]
  + vec[4] * vec[4])
end

function vec_normalize(vec)
  if vec_length(vec) == 0 then
    return { 0, 0, 0, 0 }
  else
    return { vec[1] / vec_length(vec)
    , vec[2] / vec_length(vec)
    , vec[3] / vec_length(vec)
    , vec[4] / vec_length(vec) }
  end
end

function vec_sub(vec1, vec2)
  return { vec1[1] - vec2[1]
  , vec1[2] - vec2[2]
  , vec1[3] - vec2[3]
  , vec1[4] - vec2[4] }
end

function vec_cross(vec1, vec2)
  return { vec1[2]*vec2[3] - vec2[2]*vec1[3]
  , vec1[3]*vec2[1] - vec2[3]*vec1[1]
  , vec1[1]*vec2[2] - vec2[1]*vec1[2]
  , 0 }
end

function lookAt(eye, center, up)
  up = vec_normalize(up)
  local f = vec_normalize(vec_sub(center, eye))
  local s = vec_normalize(vec_cross(f, up))
  local u = vec_cross(s, f)
  local a = dot_product(s, eye)
  local b = dot_product(u, eye)
  local c = dot_product(f, eye)
  return {
    {  s[1],  s[2],  s[3],   0 },
    {  u[1],  u[2],  u[3],   0 },
    { -f[1], -f[2], -f[3],   0 },
    {    -a,    -b,     c,   1 }
  }
end

--[[
function perspective(fovy, aspect, znear, zfar)
  local tan_half_fovy = math.tan(fovy / 2)
  local a = 1 / (aspect * tan_half_fovy)
  local b = 1 / tan_half_fovy
  local c = - (zfar + znear) / (zfar - znear)
  local d = - (2 * zfar * znear) / (zfar - znear)
  return {
    { a, 0, 0, 0 },
    { 0, b, 0, 0 },
    { 0, 0, c, 0 },
    { 0, 0, d, 0 }
  }
end
]]

function perspective(fovy, aspect, znear, zfar)
  local f = 1 / math.tan(fovy / 2)
  local a = (zfar + znear) / (znear - zfar)
  local b = (2 * zfar * znear) / (znear - zfar)
  return {
    { f/aspect, 0,  0,  0 },
    { 0,        f,  0,  0 },
    { 0,        0,  a,  b },
    { 0,        0, -1,  0 }
  }
end

local wind_width = 800
local wind_height = 600

ply = {
  x = 0,
  y = 0,
  angle = 0
}

local cube = {
  {-0.5, -0.5},
  { 0.5, -0.5},
  { 0.5,  0.5},
  {-0.5,  0.5}
}

local t = 0
local mvp

function love.update(dt)
  t = t + dt
  if love.keyboard.isDown("q") then
    love.event.push("quit")
  end

  v = {0, 0, 0, 0}
  view = lookAt({math.cos(t), (1 + math.sin(2*t))/2, math.sin(t), 1}, {0, 0, 0, 0}, {0, 1, 0, 0})
  projection = perspective(90, 800/600, 0.1, 100)
  mvp = mat_mat_mult(projection, view)
end

function love.draw()
  love.graphics.setColor(255, 0, 0)
  love.graphics.circle("fill", wind_width/2, wind_height/2, 2, 5)
  love.graphics.setColor(255, 255, 255)
  for _,v in ipairs(cube) do
    vx = {v[1], v[2], 0, 1}
    v_s = mat_vec_mult(mvp, vx)
    love.graphics.points(wind_width/2 + (-v_s[1])*wind_width/2, wind_height/2 + (-v_s[2])*wind_height/2)
    print(v_s[3])
  end
end

-- vim: et:sw=2

