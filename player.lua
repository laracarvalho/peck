player = {}

-- player properties
player.x = 100
player.y = 100
player.width = 16
player.height = 18
player.speed = 100
player.isMoving = false

-- animations
player.ss = {}
player.ss.down = love.graphics.newImage("/assets/flowerbot-sprites-front.png")
player.ss.up = love.graphics.newImage("/assets/flowerbot-sprites-behind.png")
player.ss.left = love.graphics.newImage("/assets/flowerbot-sprites-left.png")
player.ss.right = love.graphics.newImage("/assets/flowerbot-sprites-right.png")

player.downGrid = anim8.newGrid(16, 23, player.ss.down:getWidth(), player.ss.down:getHeight())
player.upGrid = anim8.newGrid(16, 23, player.ss.up:getWidth(), player.ss.up:getHeight())
player.leftGrid = anim8.newGrid(16, 23, player.ss.left:getWidth(), player.ss.left:getHeight())
player.rightGrid = anim8.newGrid(16, 23, player.ss.right:getWidth(), player.ss.right:getHeight())

player.animations = {}
player.animations.down = anim8.newAnimation(player.downGrid:getFrames('1-4',1), 0.2)
player.animations.up = anim8.newAnimation(player.upGrid:getFrames('1-4',1), 0.2)
player.animations.left = anim8.newAnimation(player.leftGrid:getFrames('1-4',1), 0.2)
player.animations.right = anim8.newAnimation(player.rightGrid:getFrames('1-4',1), 0.2)

player.dir = "down"
player.anim = player.animations.down
player.sprite = player.ss.down

-- physics
player.body = love.physics.newBody(world, player.width/2, (player.width-player.height)/2, "dynamic")
player.shape = love.physics.newRectangleShape(player.width, player.height)
player.fixture = love.physics.newFixture(player.body, player.shape)
player.fixture:setUserData("Player")

function player:updateAnim(dir)
  player.anim = player.animations[dir]
  player.sprite = player.ss[dir]
end

function player:update(dt)
  player:move(dt)
end

function player:move(dt)
  local vectorX = 0
  local vectorY = 0

  if love.keyboard.isDown("left") then
    vectorX = -1
    player.dir = "left"
    player:updateAnim("left")
  end

  if love.keyboard.isDown("right") then
    vectorX = 1
    player.dir = "right"
    player:updateAnim("right")
  end

  if love.keyboard.isDown("up") then
    vectorY = -1
    player.dir = "up"
    player:updateAnim("up")
  end

  if love.keyboard.isDown("down") then
    vectorY = 1
    player.dir = "down"
    player:updateAnim("down")
  end

  if player.isMoving == false then
    player.anim:gotoFrame(1)
  else
    player.anim:update(dt)
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
  player.anim:draw(player.ss[player.dir], player.body:getX(), player.body:getY(), nil)
end