local map = {}

map._version = 5
map._size = 20

function map.new(startx,starty,startdir,finishx,finishy,next_level)
  local o={}
  o.mini=map.mini
  o.miniEdit=map.miniEdit
  o.submap=map.submap
  o._data={} --init
  for y = 1,map._size do
    o._data[y] = {}
    for x = 1,map._size do
      o._data[y][x] = 1
    end
  end
  o._init_fog = map._init_fog
  o:_init_fog()
  o.clearFog = map.clearFog

  o._start={x=startx,y=starty,dir=startdir}
  o.getStartX=map.getStartX
  o.getStartY=map.getStartY
  o.getStartDirection=map.getStartDirection

  o._finish={x=finishx,y=finishy}
  o.getFinishX=map.getFinishX
  o.getFinishY=map.getFinishY

  o._next_level = next_level
  o.getNextLevel = map.getNextLevel
  o.setNextLevel = map.setNextLevel

  o.getData=map.getData
  o.setData=map.setData
  o.save=map.save
  o.load=map.load
  o._scale = 4
  return o
end

function map:_init_fog()
  self._fog={}
  for y = 1,map._size do
    self._fog[y] = {}
    for x = 1,map._size do
      self._fog[y][x] = 0
    end
  end
end

function map:clearFog(x,y)
  for a = -1,1 do
    for b = -1,1 do
      if self._fog[y+a] and self._fog[y+a][x+b] then
        self._fog[y+a][x+b] = 1/2
      end
    end
  end
  self._fog[y][x] = 0
end

function map:load(name)
  global_random_step = global_random_step - 1
  if global_random_step < 1 then
    global_random_step = 1
  end
  if love.filesystem.isFile("maps/"..name) then
    local raw = love.filesystem.read("maps/"..name)
    local obj = json.decode(raw)
    if obj.version == map._version then
      self._data = obj.data
      self._start = obj.start
      self._finish = obj.finish
      self._next_level = obj.next_level
      self:_init_fog()
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

  obj.version = map._version

  obj.data = self._data
  obj.start = self._start
  obj.finish = self._finish
  obj.next_level = self._next_level
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
      local fog = debug_mode and 1 or self._fog[y][x]
      color[1]=color[1]*fog
      color[2]=color[2]*fog
      color[3]=color[3]*fog
      love.graphics.setColor(color)
      love.graphics.rectangle("fill",ox+(x-1)*self._scale,oy+(y-1)*self._scale,self._scale,self._scale)
    end
  end

  local fx,fy = self._finish.x,self._finish.y
  love.graphics.setColor(0,255,0)
  love.graphics.rectangle("fill",ox+(fx-1)*self._scale,oy+(fy-1)*self._scale,self._scale,self._scale)

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

function map:getStartX()
  return self._start.x
end

function map:getStartDirection()
  return self._start.dir
end

function map:getStartY()
  return self._start.y
end

function map:getFinishX()
  return self._finish.x
end

function map:getFinishY()
  return self._finish.y
end

function map:getNextLevel()
  return self._next_level
end

function map:setNextLevel(level)
  self._next_level = level
end

return map
