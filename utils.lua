function contains(_set, key)
  return _set[key] ~= nil
end

function log(text)
  logText = logText .. "\n" .. text
end

function getLen(tbl)
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

