tilemap = {}

sourceFolder = "/assets/maps/"

function tilemap:load(path, source)
  local map = require(path)

  map.quads = {}

  local tileset = map.tilesets[1]
  if source then
    sourceFolder = source
  end
  map.image = love.graphics.newImage(sourceFolder .. tileset.image)

  for y = 0, (tileset.imageheight / tileset.tileheight) - 1 do
    for x = 0, (tileset.imagewidth / tileset.tilewidth) - 1 do
      local quad = love.graphics.newQuad(
          x * tileset.tilewidth,
          y * tileset.tileheight,
          tileset.tilewidth,
          tileset.tileheight,
          tileset.imagewidth,
          tileset.imageheight
      )
      table.insert(map.quads, quad)
    end
  end

  return map
end

function tilemap:draw(map, name)
  for _, layer in ipairs(map.layers) do
    if layer.type == "tilelayer" and layer.name == name then
      for y = 0, layer.height - 1 do
        for x = 0, layer.width - 1 do
          local index = (x + y * layer.width) + 1
          local tid = layer.data[index]

          if tid ~= 0 then
            local quad = map.quads[tid]
            local xx = x * map.tilewidth
            local yy = y * map.tileheight
            love.graphics.draw(
                map.image,
                quad,
                xx,
                yy
            )
          end
        end
      end
    end
  end
end

function tilemap:loadObjects(world, map)
  local objects = {}
  for i, layer in ipairs(map.layers) do
    if layer.type == "objectgroup" and layer.objects then
      for _, obj in pairs(layer.objects) do
        mapObj = {}
        mapObj.x = math.floor(obj.x+0.5)
        mapObj.y = math.floor(obj.y+0.5)
        mapObj.width = math.floor(obj.width+0.5)
        mapObj.height = math.floor(obj.height+0.5)

        body = love.physics.newBody(world, mapObj.x, mapObj.y - 10, "static")
        shape = love.physics.newRectangleShape(mapObj.width, mapObj.height)
        mapObj.body = body
        mapObj.shape = shape
        mapObj.fixture = love.physics.newFixture(body, shape)

        table.insert(objects, mapObj)
      end
    end
  end

  return objects
end
