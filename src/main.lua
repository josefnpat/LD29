love.graphics.setBackgroundColor(255,255,0)

require("lovepixlr").init()

fakedoom = require("fakedoom")

playerclass = require("playerclass")
mapclass = require("mapclass")

player = playerclass.new()
map = mapclass.new()

obmap = fakedoom.new()

function love.load()
  LovePixlr.bind(320,240,"nearest")
  info_img = love.graphics.newImage("assets/info.png")
end

function love.draw()
  local submap = map:submap(player:getX(),player:getY(),player:getDirection())
  s = "p: "..player:getX()..","..player:getY().."\n"..player:getDirection()
  obmap:draw(0,0,submap)
  love.graphics.draw(info_img,240,0)
  map:mini(240,0,player:getX(),player:getY())
  love.graphics.print(s,240,80)
end

function love.keypressed(key)
  if key == "`" then
    debug_mode = not debug_mode
  elseif key == "up" then
    player:moveForward(map:getData())
  elseif key == "down" then
    player:moveBackward(map:getData())
  elseif key == "right" then
    player:turnRight()
  elseif key == "left" then
    player:turnLeft()
  end
end
