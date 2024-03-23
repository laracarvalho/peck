if os.getenv "LOCAL_LUA_DEBUGGER_VSCODE" == "1" then
  local lldebugger = require "lldebugger"
  lldebugger.start()
  local run = love.run
  function love.run(...)
      local f = lldebugger.call(run, false, ...)
      return function(...) return lldebugger.call(f, false, ...) end
  end
end

love.graphics.setDefaultFilter("nearest", "nearest")

world = love.physics.newWorld(0, 0, true)
lang = "en"

-- libraries
anim8 = require("libs.anim8.anim8")
sti = require("libs.Simple-Tiled-Implementation/sti")
camera = require("libs.hump.camera")

require("game_state")
require("utils")
require("physics")
require("player")
require("dialog")
-- Content
require("scenes.scripts.scripts")
require("scenes.scenes")

cam = camera()
camZoom = 3
cam:zoom(camZoom)

gameMap = sti("assets/maps/test.lua", {"box2d"})
gameMap:box2d_init(world)
walls = {}

--wall[1].scenes = {scene_hello_world, scene_choice_three}

function love.load()
  state = "init"

  logText = ""

  if gameMap.layers["walls"] then
    for i, obj in pairs(gameMap.layers["walls"].objects) do
      local wall = {}
      wall.x = obj.x
      wall.y = obj.y
      wall.width = obj.width
      wall.height = obj.height
      wall.body = love.physics.newBody(world, wall.width, wall.height, "static")
      wall.shape = love.physics.newRectangleShape(wall.width, wall.height)
      wall.fixture = love.physics.newFixture(wall.body, wall.shape)
      wall.fixture:setUserData("Wall")
      table.insert(walls, wall)
    end
  end
end

function love.update(dt)
  if state == "init" then
    state = "running"
  end

  if state == "init" or state == "running" then
    world:update(dt)
    player:update(dt)
    gameMap:update(dt)
    --dialog:update(dt)
  end

  if logText:len() >= gameHeight then
    logText = ""
  end

  cam:updateCam()
end

function cam:updateCam()
  cam:lookAt((player.body:getX() + player.width / 2), (player.body:getY() + player.height / 2))

  -- Get width/height of background
  local mapW = gameMap.width * gameMap.tilewidth
  local mapH = gameMap.height * gameMap.tileheight

  -- Left border
  if cam.x < gameWidth/2/camZoom then
    cam.x = gameWidth/2/camZoom
  end

  -- Right border
  if cam.y < gameHeight/2/camZoom then
    cam.y = gameHeight/2/camZoom
  end

  -- Right border
  if cam.x > (mapW - gameWidth/2/camZoom) then
    cam.x = (mapW - gameWidth/2/camZoom)
  end
  -- Bottom border
  if cam.y > (mapH - gameHeight/2/camZoom) then
    cam.y = (mapH - gameHeight/2/camZoom)
  end
end

function love.draw()
  cam:attach()
    gameMap:drawLayer(gameMap.layers["ground"])
    gameMap:drawLayer(gameMap.layers["overview"])

    -- for i, obj in pairs(walls) do
    --   log(dump({
    --     obj.width,
    --     obj.height,
    --     obj.x,
    --     obj.y
    --   }))
    -- end

    player:draw()
    dialog:draw()

    gameMap:box2d_draw()

    love.graphics.print(logText, 10, 10)
  cam:detach()

end

function love.keypressed(key)
  if state == "dialog" then
    dialog:keypressed(key)
  end

  if key == "escape" then
    love.event.quit(0)
  end

  if state == "running" and key == "return" then
    if love.physics.getDistance(player.fixture, wall.fixture) <= 1 and dialog.open == false then
      dialog.open = true
      state = "dialog"
      if wall.scenes ~= {} then
        dialog:registerScene(wall.scenes[1])
      end
    end
  end

end