camera = require("libs.hump.camera")
cam = camera()

scale = 4

cam:zoom(scale)

function cam:updateCam(map)
  cam:lookAt(player.body:getX(), player.body:getY())

  local w = love.graphics.getWidth()/scale
  local h = love.graphics.getHeight()/scale

    -- Left border
    if cam.x < w/(scale/2) then
      cam.x = w/(scale/2)
    end

    -- Right border
    if cam.y < h/(scale/2) then
      cam.y = h/(scale/2)
    end

    -- -- Get width/height of background
    local mapW = map.width * map.tilewidth
    local mapH = map.height * map.tileheight
    
    -- -- Right border
    if cam.x > (mapW - w/(scale/2)) then
      cam.x = (mapW - w/(scale/2))
    end

    -- Bottom border
    if cam.y > (mapH - h/(scale/2)) then
      cam.y = (mapH - h/(scale/2))
    end
end
