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
    {  s[1],  s[2],  s[3],  -a },
    {  u[1],  u[2],  u[3],  -b },
    { -f[1], -f[2], -f[3],   c },
    {     0,     0,     0,   1 }
  }
end

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

function vec_scalar_divide(vec, scalar)
  return { vec[1] / scalar, vec[2] / scalar, vec[3] / scalar, vec[4] / scalar }
end

-- vim: et:sw=2

