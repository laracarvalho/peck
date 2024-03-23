function newWorldObject(world, width, height, isDynamic)
  local body = love.physics.newBody(world, width/2, (width-height)/2)
  if isDynamic == true then
    body:setType("dynamic")
  end
  local shape = love.physics.newRectangleShape(width, height)
  return love.physics.newFixture(body, shape)
end