require("lovepixlr").init()
require("json")

font = love.graphics.newFont("assets/fonts/RobotoSlab-Regular.ttf",14)
love.graphics.setFont(font)

git,git_count = "missing git.lua",0
pcall( function() return require("git") end );

game_name = "Advanced Cave Crawler"

love.window.setTitle(game_name.." - git-v"..git_count.." ["..git.."]")

fakedoom = require("fakedoom")

playerclass = require("playerclass")
mapclass = require("mapclass")
eventsclass = require("eventsclass")

events = eventsclass.new()
require("encounters")

-- SPLASH SCREENS
events:force(
  function() end,
  function()
    events:force(
      function() end,
      function() love.load() end,
      "",
      nil,
      love.graphics.newImage("assets/mss-logo.png"),
      2
    )
  end,
  "",
  nil,
  love.graphics.newImage("assets/love-logo.png"),
  2
)


function love.load()
  if not LovePixlr:isBound() then
    LovePixlr.bind(320,240,"nearest")
    LovePixlr.setMaxScale()
    info_img = love.graphics.newImage("assets/info.png")
  end

  map = mapclass.new(1,1,4,2,2,"s")
  map:load("s")
  player = playerclass.new(map:getStartX(),map:getStartY(),map:getStartDirection())
  observablemap = fakedoom.new()
  observablemap:setbg(2)

  game = {
    start_time = love.timer.getTime(),
    encounters = 0,
  }
  events:force(
    function() end,
    function() end,
    "Advanced Cave Crawler\n"..
    "by @josefnpat for LD29\n\n"..
    "Keyboard: Arrow keys & space|return\n"..
    "(Supports Controllers)",
    {
      {text="New Game",exec=function()
         events:force(
           function() end,
           function()
             events:force(
               function() end,
               function()
               end,
               "Escape the maze and get to the surface...\n\nif you can survive."
             )
           end,
           "Difficulty Level",
           {
             {text="Mommy! Hold my hand!",exec=function() end},
             {text="My body is ready.",exec=function() end},
             {text="I shall exterminate everything around me that restricts me from being the master.",exec=function() end},
           }
         )
       end},
      {text="Quit",exec=function() love.event.quit() end},
    }
  )
end

function love.draw()
  local submap = map:submap(player:getX(),player:getY(),player:getDirection())
  local s = "p: "..player:getX()..","..player:getY().."\n"..
    player:getDirection()
  observablemap:draw(0,0,submap)
  love.graphics.draw(info_img,240,0)
  map:mini(240,0,player:getX(),player:getY())
  love.graphics.print(s,240,80)
  events:draw()
  if debug_mode then
    love.graphics.print(
      "number .. set +\n"..
      "lshift+key .. save to file\n"..
      "lctrl+key .. load from file\n"..
      "marker: "..(debug_map_place or "+"),0,12)
  end
end

function love.keypressed(key)
  if key == "`" then
    debug_mode = not debug_mode
  end

  if not events:running() then
    if key == "up" then
      if player:moveForward(map:getData()) then
        if events:step() then
          game.encounters = game.encounters + 1
        end
      end
    elseif key == "down" then
      if player:moveBackward(map:getData()) then
        if events:step() then
          game.encounters = game.encounters + 1
        end
      end
    elseif key == "right" then
      player:turnRight()
    elseif key == "left" then
      player:turnLeft()
    end
  else
    events:keypressed(key)
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
  events:update(dt)
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
      events:force(
        function() end,
        function()
          map:load(next_map)
        end,
        "You find a set of stairs that hopefully leads to the surface."
      )
    else
      events:force(
        function() game.stop_time = love.timer.getTime() end,
        function() 
          events:force(
            function() end,
            function() love.load() end,
            "YOU WIN!\n\n"..
            "Time: "..math.floor(game.stop_time-game.start_time).."s\n"..
            "Encounters: "..(game.encounters)
          )
        end,
        "You find a set of stairs that leads to the surface ... but do you really want to leave?"
      )
    end
  end
end
