local player = {}

player._dir = {"left","up","right","down"}

function player.new(x,y,dir)
  local o={}
  o._x=x --init
  o.getX=player.getX
  o.setX=player.setX
  o._y=y --init
  o.getY=player.getY
  o.setY=player.setY
  o._direction=dir --init
  o.getDirection=player.getDirection
  o.setDirection=player.setDirection
  o.moveForward=player.moveForward
  o.moveBackward=player.moveBackward
  o.turnLeft=player.turnLeft
  o.turnRight=player.turnRight

  o.level=player.level
  o:level(1)

  return o
end

function player:level(lvl)
  self._level = lvl

  self._maxhp = lvl*10
  self._bhp = self._bhp or self._maxhp
  self._hp = self._hp or self._bhp

  self._maxatk = lvl*10
  self._batk = self._batk or self._maxatk
  self._atk = self._atk or self._batk

  self._maxdef = lvl*10
  self._bdef = self._bdef or self._maxdef
  self._def = self._def or self._bdef

  self._gold = self._gold or 0
  
  self._exp = 0
  self._next_level_exp = lvl*100
end

function player:getX()
  return self._x
end

function player:setX(val)
  self._x=val
end

function player:getY()
  return self._y
end

function player:setY(val)
  self._y=val
end

function player:getDirection()
  return player._dir[self._direction]
end

function player:setDirection(val)
  self._direction=val
end

player._move_offset = {
  {x=-1,y=0},
  {x=0,y=-1},
  {x=1,y=0},
  {x=0,y=1},
}

function player:moveForward(map)
  local move_offset = player._move_offset[self._direction]
  local nx = self:getX()+move_offset.x
  local ny = self:getY()+move_offset.y
  if map[ny] and map[ny][nx] == 0 then
    self:setX(nx)
    self:setY(ny)
    return true
  end
end

function player:moveBackward(map)
  local move_offset = player._move_offset[self._direction]
  local nx = self:getX()-move_offset.x
  local ny = self:getY()-move_offset.y
  if map[ny] and map[ny][nx] == 0 then
    self:setX(nx)
    self:setY(ny)
    return true
  end
end

function player:turnLeft()
  self._direction = self._direction - 1
  if self._direction < 1 then
    self._direction = #player._dir
  end
end

function player:turnRight()
  self._direction = self._direction + 1
  if self._direction > #player._dir then
    self._direction = 1
  end
end

return player
