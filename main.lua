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
windowWidth, windowHeight = love.window.getDesktopDimensions()


-- libraries
anim8 = require("libs.anim8.anim8")

require("gamestate")
require("utils")
require("physics")
require("player")
require("dialog")
require("tilemap")
require("camera")
require("gamemaps.main")
-- Content
require("scenes.scripts.scripts")
require("scenes.scenes")

function love.load()
  font = love.graphics.newFont(20)
  love.graphics.setFont(font)

  state = "init"
  logText = ""
  mapData = gamemaps:loadMap("main")
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

  if logText:len() >= windowHeight then
    logText = ""
  end

  cam:updateCam(mapData.map)
end

function love.draw()
  cam:attach()

    gamemaps:drawUnderPlayer()
    player:draw()
    gamemaps:drawOverPlayer()

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
    --if love.physics.getDistance(player.fixture, objects[1].fixture) <= 1 and dialog.open == false then
      dialog.open = true
      state = "dialog"
      --if wall.scenes ~= {} then
        dialog:registerScene(scene_hello_world)
      --end
    --end
  end

end