map = {
  {0, 2}
}
ply = {
  x = 0,
  y = 0,
  angle = 0
}

function dot_product(vec1, vec2)
  return vec1[1] * vec2[1]
  + vec1[2] * vec2[2]
  + vec1[3] * vec2[3]
  + vec1[4] * vec2[4]
end

function mat_vec_mult(mat, vec)
  return
  { dot_product(mat[1], vec)
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
      dot_product(mat1[3], { mat2[1][1], mat2[2][1], mat2[3][1], mat2[4][1] }),
      dot_product(mat1[3], { mat2[1][2], mat2[2][2], mat2[3][2], mat2[4][2] }),
      dot_product(mat1[3], { mat2[1][3], mat2[2][3], mat2[3][3], mat2[4][3] }),
      dot_product(mat1[3], { mat2[1][4], mat2[2][4], mat2[3][4], mat2[4][4] })
    } }
end

function love.load()
  mat_t =
  {
    {1, 0, 0, 1},
    {0, 1, 0, 2},
    {0, 0, 1, 3},
    {0, 0, 0, 1}
  }
  mat_s =
  {
    {2, 0, 0, 0},
    {0, 2, 0, 0},
    {0, 0, 2, 0},
    {0, 0, 0, 1}
  }
  mat = mat_mat_mult(mat_t, mat_s)
  print( mat[1][1], mat[1][2], mat[1][3], mat[1][4] )
  print( mat[2][1], mat[2][2], mat[2][3], mat[2][4] )
  print( mat[3][1], mat[3][2], mat[3][3], mat[3][4] )
  print( mat[4][1], mat[4][2], mat[4][3], mat[4][4] )
end

function love.update(dt)
  if love.keyboard.isDown("q") then
    love.event.push("quit")
  end
end

function love.draw()
  love.graphics.print('Hello World!', 400, 300)
end

-- vim: et:sw=2

