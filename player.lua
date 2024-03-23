player = {}

-- player properties
player.x = gameWidth / 2
player.y = gameHeight / 2
player.width = 50
player.height = 50
player.speed = 360
player.isMoving = false
player.dir = "down"
-- physics
player.body = love.physics.newBody(world, player.width/2, (player.width-player.height)/2, "dynamic")
player.shape = love.physics.newRectangleShape(player.width, player.height)
player.fixture = love.physics.newFixture(player.body, player.shape)
player.fixture:setUserData("Player")

function player:update(dt)
  local vectorX = 0
  local vectorY = 0

  if love.keyboard.isDown("left") then
    vectorX = -1
    player.dir = "left"
  end

  if love.keyboard.isDown("right") then
    vectorX = 1
    player.dir = "right"
  end

  if love.keyboard.isDown("up") then
    vectorY = -1
    player.dir = "up"
  end

  if love.keyboard.isDown("down") then
    vectorY = 1
    player.dir = "down"
  end

  player.body:setLinearVelocity(vectorX * player.speed, vectorY * player.speed)

  -- Check if player is moving
  if vectorX == 0 and vectorY == 0 then
    player.isMoving = false
  else
    player.isMoving = true
  end
end

function player:draw()
  love.graphics.setColor(255, 0, 255)
  love.graphics.rectangle("fill", player.body:getX(), player.body:getY(), player.width, player.height)
end