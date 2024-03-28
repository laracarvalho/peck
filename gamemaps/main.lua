gamemaps = {}

gamemaps.maps = {
  {"main", "assets.maps.test" },
}

gamemaps.mapData = {}

gamemaps.overPlayer = {
  "overview",
  "trees",
  "sky"
}

gamemaps.underPlayer = {
  "ground",
  "trinkets"
}


function gamemaps:load()
  local cur = 1
  if cur <= getLen(gamemaps.maps) then
    gamemaps.mapData.map = tilemap:load(gamemaps.maps[cur][2])
    gamemaps.mapData.objects = tilemap:loadObjects(world, gamemaps.mapData.map)

    cur = cur + 1

    return gamemaps.mapData
  end

end

function gamemaps:loadMap(name)

  local index = tableInList(gamemaps.maps, name)

  if index ~= 0 then
    gamemaps.mapData.map = tilemap:load(gamemaps.maps[index][2])
    gamemaps.mapData.objects = tilemap:loadObjects(world, gamemaps.mapData.map)

    return gamemaps.mapData
  end
end

function gamemaps:drawUnderPlayer()
  for _, layer in pairs(self.mapData.map.layers) do

    if inList(gamemaps.underPlayer, layer.name) then
      tilemap:draw(self.mapData.map, layer.name)
    end
  end
end

function gamemaps:drawOverPlayer()
  for _, layer in pairs(self.mapData.map.layers) do
    if inList(gamemaps.overPlayer, layer.name) then
      tilemap:draw(self.mapData.map, layer.name)
    end
  end
end
