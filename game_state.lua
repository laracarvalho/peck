-- game properties
gameWidth = love.graphics.getWidth()
gameHeight = love.graphics.getHeight()
-- game states: init | start | paused | dialog | menu | running | over
state = "init"

function getTLen(tbl)
  local getN = 0
  for n in pairs(tbl) do 
    getN = getN + 1 
  end
  return getN
end

function dump(o)
  if type(o) == 'table' then
     local s = '{ '
     for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump(v) .. ','
     end
     return s .. '} '
  else
     return tostring(o)
  end
end

