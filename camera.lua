camera = require("libs.hump.camera")
cam = camera()

cam:zoom(4)

function cam:updateCam(map)
  cam:lookAt(player.body:getX(), player.body:getY())

  local w = love.graphics.getWidth()/4
  local h = love.graphics.getHeight()/4

    -- Left border
    if cam.x < w/2 then
      cam.x = w/2
    end

    -- Right border
    if cam.y < h/2 then
      cam.y = h/2
    end

    -- -- Get width/height of background
    local mapW = map.width * map.tilewidth
    local mapH = map.height * map.tileheight

    log(dump({
      cam.x,
      cam.y,
      w,
      h,
      mapW,
      mapH
    }))

    -- -- Right border
    if cam.x > (mapW - w/2) then
      cam.x = (mapW - w/2)
    end

    -- Bottom border
    if cam.y > (mapH - h/2) then
      cam.y = (mapH - h/2)
    end
end
