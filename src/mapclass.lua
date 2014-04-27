local map = {}

map._version = 1

function map.new()
  local o={}
  o.mini=map.mini
  o.miniEdit=map.miniEdit
  o.submap=map.submap
  o._data={
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  } --init
  o.getData=map.getData
  o.setData=map.setData
  o.save=map.save
  o.load=map.load
  o._scale = 4
  return o
end

function map:load(name)
  if love.filesystem.isFile("maps/"..name) then
    local raw = love.filesystem.read("maps/"..name)
    local obj = json.decode(raw)
    if obj.version == map._version then
      self._data = obj.data
      print("Map "..name.." loaded.")
    else
      print("Map "..name.." load failed. Version mismatch.")
    end
  else
    print("Map "..name.." load failed. No file at `maps/"..name.."`.")
  end
end

function map:save(name)
  local obj = {}
  obj.data = self._data
  obj.version = map._version
  local raw = json.encode(obj)
  local output = io.open("maps/"..name, "w")
  output:write(raw)
  output:close()
  print("Map "..name.." saved. `maps/"..name.."`")
end

function map:mini(ox,oy,px,py,submap)
  for y,row in pairs(self._data) do
    for x,v in pairs(row) do
      local color = v == 0 and {255,255,255} or fakedoom.walls[v].color
      love.graphics.setColor(color)
      love.graphics.rectangle("fill",ox+(x-1)*self._scale,oy+(y-1)*self._scale,self._scale,self._scale)
    end
  end
  love.graphics.setColor(255,0,0)
  love.graphics.rectangle("fill",ox+(px-1)*self._scale,oy+(py-1)*self._scale,self._scale,self._scale)
  love.graphics.setColor(255,255,255)
end

function map:miniEdit(x,y,int)
  local rx,ry = math.floor(x/self._scale+0.5),math.floor(y/self._scale+0.5)
  if self._data[ry] and self._data[ry][rx] then
    local newint = int or self._data[ry][rx] + 1
    if newint > #fakedoom.walls then
      newint = 1
    end
    self._data[ry][rx] = newint
  end
end

function map:submap(px,py,direction)
  local s = {}
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
        rx,ry = px+y-1,py+x-2
      elseif direction == "left" then
        rx,ry = px-y+1,py-x+2
      end
      s[y][x] = (self._data[ry] and self._data[ry][rx]) and
        self._data[ry][rx] or -- there is data
        1 -- offscreen
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
