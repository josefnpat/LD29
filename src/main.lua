require("lovepixlr").init()
require("json")

fakedoom = require("fakedoom")

playerclass = require("playerclass")
mapclass = require("mapclass")
eventsclass = require("eventsclass")

map = mapclass.new(1,1,4,2,2,"s")
map:load("s")
player = playerclass.new(map:getStartX(),map:getStartY(),map:getStartDirection())
events = eventsclass.new()
observablemap = fakedoom.new()
observablemap:setbg(2)

function love.load()
  LovePixlr.bind(320,240,"nearest")
  info_img = love.graphics.newImage("assets/info.png")
end

function love.draw()
  local submap = map:submap(player:getX(),player:getY(),player:getDirection())
  local s = "p: "..player:getX()..","..player:getY().."\n"..
    player:getDirection().."\n"..
    (debug_map_place or "+")
  observablemap:draw(0,0,submap)
  love.graphics.draw(info_img,240,0)
  map:mini(240,0,player:getX(),player:getY())
  love.graphics.print(s,240,80)
  if debug_mode then
    love.graphics.print(
      "number .. set +\n"..
      "lshift+key .. save to file\n"..
      "lctrl+key .. load from file\n",0,12)
  end
end

function love.keypressed(key)
  if key == "`" then
    debug_mode = not debug_mode
  elseif key == "up" then
    if player:moveForward(map:getData()) then
      events:step()
    end
  elseif key == "down" then
    if player:moveBackward(map:getData()) then
      events:step()
    end
  elseif key == "right" then
    player:turnRight()
  elseif key == "left" then
    player:turnLeft()
  end
  if debug_mode then
   if love.keyboard.isDown("lshift") and key ~= "lshift" then
      map:save(key)
    elseif love.keyboard.isDown("lctrl") and key ~= "lcrtrl" then
      map:load(key)
    elseif type(tonumber(key)) == "number" then
      debug_map_place = tonumber(key)
    end
  end
end

function love.update(dt)
  --require("lovebird").update()
  if debug_mode then
    if love.mouse.isDown("r") then -- clear
      map:miniEdit(love.mouse.getX()-240,love.mouse.getY(),0)
    end
    if love.mouse.isDown("m") then
      debug_map_place = nil
    end
    if love.mouse.isDown("l") and debug_lmb then --inc
      map:miniEdit(love.mouse.getX()-240,love.mouse.getY(),debug_map_place)
      debug_lmb = nil
    end
    if not love.mouse.isDown("l") then
      debug_lmb = true
    end
  end
  if player:getX() == map:getFinishX() and player:getY() == map:getFinishY() then
    local next_map = map:getNextLevel()
    player:setX(map:getStartX())
    player:setY(map:getStartY())
    player:setDirection(map:getStartDirection())
    if next_map then
      map:load(next_map)
    else
      print("YOU WIN")
    end
  end
end
