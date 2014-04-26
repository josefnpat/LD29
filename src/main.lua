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
  local s = ""
  for i,v in pairs(submap) do 
    for j,w in pairs(v) do
--    s = s.."("..i..","..j..")"..w
      s = s..w
    end
    s = s .. "\n";
  end
  s = s.. "\np: "..player:getX()..","..player:getY().."\n"..player:getDirection()
  obmap:draw(0,0,submap)
  love.graphics.draw(info_img,240,0)
  map:mini(240,0,player:getX(),player:getY(),submap)
  love.graphics.print(s,240,60)
end

function love.keypressed(key)
  if key == "up" then
    player:moveForward()
  elseif key == "down" then
    player:moveBackward()
  elseif key == "right" then
    player:turnRight()
  elseif key == "left" then
    player:turnLeft()
  end
end
