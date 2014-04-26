local player = {}

player._dir = {"left","up","right","down"}

function player.new()
  local o={}
  o._x=2 --init
  o.getX=player.getX
  o.setX=player.setX
  o._y=2 --init
  o.getY=player.getY
  o.setY=player.setY
  o._direction=1 --init
  o.getDirection=player.getDirection
  o.setDirection=player.setDirection
  o.moveForward=player.moveForward
  o.moveBackward=player.moveBackward
  o.turnLeft=player.turnLeft
  o.turnRight=player.turnRight
  return o
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
  for i,v in pairs(player._dir) do
    if val == v then
      self._direction=i
      return
    end
  end
  print("Could not set direction '"..val.."'")
end

player._move_offset = {
  {x=-1,y=0},
  {x=0,y=-1},
  {x=1,y=0},
  {x=0,y=1},
}

function player:moveForward()
  local move_offset = player._move_offset[self._direction]
  self:setX(self:getX()+move_offset.x)
  self:setY(self:getY()+move_offset.y)
end

function player:moveBackward()
  local move_offset = player._move_offset[self._direction]
  self:setX(self:getX()-move_offset.x)
  self:setY(self:getY()-move_offset.y)
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
