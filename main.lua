if os.getenv "LOCAL_LUA_DEBUGGER_VSCODE" == "1" then
  local lldebugger = require "lldebugger"
  lldebugger.start()
  local run = love.run
  function love.run(...)
      local f = lldebugger.call(run, false, ...)
      return function(...) return lldebugger.call(f, false, ...) end
  end
end

scale = 5
updatedScale = 2
love.graphics.setDefaultFilter("nearest", "nearest")

world = love.physics.newWorld(0, 0, true)
lang = "en"
fullscreen = false

gameWidth, gameHeight = 540/2, 320/2 --fixed game resolution
windowWidth, windowHeight = love.window.getDesktopDimensions()


-- libraries
anim8 = require("libs.anim8.anim8")
push = require("libs.push-master.push")

require("gamestate")
require("utils")
require("physics")
require("player")
require("dialog")
require("tilemap")
require("camera")
-- Content
require("scenes.scripts.scripts")
require("scenes.scenes")

function love.load()
  state = "init"
  logText = ""
  map = tilemap:load("assets.maps.test")
  objects = tilemap:loadObjects(world, map)
end

function love.update(dt)
  --log("test")
  if state == "init" then
    state = "running"
  end

  if state == "init" or state == "running" then
    world:update(dt)
    player:update(dt)
  end

  if logText:len() >= gameHeight then
    logText = ""
  end

  cam:updateCam(map)

end

function love.draw()
  cam:attach()

    tilemap:draw(map)
    player:draw()

  --love.graphics.pop()
  cam:detach()
  
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
    log("You clicked it!")
    --if love.physics.getDistance(player.fixture, objects[1].fixture) <= 1 and dialog.open == false then
      dialog.open = true
      state = "dialog"
      --if wall.scenes ~= {} then
        dialog:registerScene(scene_hello_world)
      --end
    --end
  end

end