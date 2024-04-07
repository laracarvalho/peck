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
Gamestate = require("libs.hump.gamestate")

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

-- Game States
game = {}
menu = {}
paused = {}

mapData = {}

function love.load()
  font = love.graphics.newFont(20)
  love.graphics.setFont(font)
  logText = ""

  Gamestate.registerEvents()
  Gamestate.switch(menu)
end

function menu:draw()
  love.graphics.print("Press Enter to continue", 10, 10)
end

function menu:keyreleased(key, code)
  if key == 'return' then
    Gamestate.switch(game)
  end
end

function game:keyreleased(key, code)
  if key == 'tab' then
    Gamestate.switch(menu)
  end

  if key == 'p' then
    state = "dialog"
  end

  if key == 'l' then
    game:goToMap("second", 50, 150)
  end
end

function game:enter()
  -- setup entities here
  mapData = gamemaps:loadMap("main")
end

function game:goToMap(map, x, y)
  mapData = gamemaps:loadMap(map)
  player:transport(x, y)
end

function game:update(dt)
  world:update(dt)
  player:update(dt)
  cam:updateCam(mapData.map)
end

function game:draw()
  cam:attach()
    gamemaps:drawUnderPlayer()
    player:draw()
    gamemaps:drawOverPlayer()
  cam:detach()

  dialog:draw()
end

function love.update(dt)
  --log("test")

  --log(tableInList(gamemaps.maps, "second"))


  if logText:len() >= windowHeight then
    logText = ""
  end

end

function love.draw()
  love.graphics.print(logText, 10, 10)
end

function love.keypressed(key)
  if state == "dialog" then
    dialog:keypressed(key)
  end

  if key == "escape" then
    love.event.quit(0)
  end

  -- if state == "running" and key == "return" then
  --   --if love.physics.getDistance(player.fixture, objects[1].fixture) <= 1 and dialog.open == false then
  --     dialog.open = true
  --     state = "dialog"
  --     --if wall.scenes ~= {} then
  --       dialog:registerScene(scene_hello_world)
  --     --end
  --   --end
  -- end

end