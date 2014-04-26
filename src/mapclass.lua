local map = {}

function map.new()
  local o={}
  o.mini=map.mini
  o.submap=map.submap
  o._data={
    {1,1,1,1,1},
    {1,0,0,0,1},
    {1,0,0,0,1},
    {1,1,1,0,1},
    {1,0,0,0,1},
    {1,1,1,1,1},
  } --init
  o.getData=map.getData
  o.setData=map.setData
  return o
end

function map:mini(ox,oy,px,py,submap)
  local scale=4
  for y,row in pairs(self._data) do
    for x,v in pairs(row) do
      local color = v == 0 and {255,255,255} or {0,0,0}
      love.graphics.setColor(color)
      love.graphics.rectangle("fill",ox+(x-1)*scale,oy+(y-1)*scale,scale,scale)
    end
  end
  love.graphics.setColor(255,0,0)
  love.graphics.rectangle("fill",ox+(px-1)*scale,oy+(py-1)*scale,scale,scale)
  love.graphics.setColor(255,255,255)
end

function map:submap(px,py,direction)
  local s = {}
  map._debug_submap = {}
  for y = 1,3 do
    s[y] = {}
    map._debug_submap = {}
    for x = 1,3 do
      local rx,ry
      if direction == "down" then
        rx,ry = px+2-x,py-1+y
      elseif direction == "up" then
        rx,ry = px+x-2,py-y+1
      elseif direction == "right" then
        rx,ry = py+y-1,px+x-2
      elseif direction == "left" then
        rx,ry = py-y+1,px-x+2
      end
      s[y][x] = (self._data[ry] and self._data[ry][rx]) and
        self._data[ry][rx] or -- there is data
        3 -- offscreen
    end
  end
  return s
end

function map:getData()
  return self._data
end

function map:setData(val)
  self._data=val
end

return map
