if os.getenv "LOCAL_LUA_DEBUGGER_VSCODE" == "1" then
  local lldebugger = require "lldebugger"
  lldebugger.start()
  local run = love.run
  function love.run(...)
      local f = lldebugger.call(run, false, ...)
      return function(...) return lldebugger.call(f, false, ...) end
  end
end


world = love.physics.newWorld(0, 0, true)
lang = "en"

require("game_state")
require("utils")
require("physics")
require("player")
require("dialog")

require("scenes.scripts.scripts")
require("scenes.scenes")


wall = {}
wall.x = 100
wall.y = 100
wall.width = 150
wall.height = 150
wall.body = love.physics.newBody(world, wall.width, wall.height, "static")
wall.shape = love.physics.newRectangleShape(wall.width, wall.height)
wall.fixture = love.physics.newFixture(wall.body, wall.shape)
wall.fixture:setUserData("Wall")

wall.scenes = {scene_hello_world, scene_choice_three}

points = 0
dialogTimer = 0

function love.load()
  state = "init"

  logText = ""
end

function love.update(dt)
  if state == "init" then
    state = "running"
  end

  dialogTimer = dialogTimer + dt
  if dialogTimer > 2 then
    dialogTimer = 0
  end

  if state == "init" or state == "running" then
    world:update(dt)
    player:update(dt)
    --dialog:update(dt)
  end

  if logText:len() >= gameHeight then
    logText = ""
  end
end

function love.draw()
  love.graphics.setColor(255, 255, 0)
  love.graphics.rectangle("line", wall.x, wall.y, wall.width, wall.height)

  player:draw()
  dialog:draw()

  love.graphics.print(logText, 10, 10)
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