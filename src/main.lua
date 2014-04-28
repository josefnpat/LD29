require("lovepixlr").init()
require("json")

sfx = {
  choice = love.audio.newSource('assets/sfx/choice.wav','static'),
  good = love.audio.newSource('assets/sfx/good.wav','static'),
  bad = love.audio.newSource('assets/sfx/bad.wav','static'),
  action =love.audio.newSource('assets/sfx/action.wav','static'),
  step = love.audio.newSource('assets/sfx/step.wav','static'),
  play = function(f)
    sfx[f]:stop()
    sfx[f]:play()
  end
}

music = love.audio.newSource("assets/inudge-arecord.ogg","stream")
music:setLooping(true)
music:play()

dong2lib = require("dong2lib")

font = love.graphics.newFont("assets/fonts/RobotoSlab-Regular.ttf",14)

font_small = love.graphics.newFont("assets/fonts/RobotoSlab-Regular.ttf",10)

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

-- INPUT DEVICES!
function love.joystickadded(joystick)
  local ndong = dong2lib.new(joystick)
  if ndong then 
    setBindings(ndong)
    table.insert(dongs,ndong)
  end
end

function setBindings(dong)

  dong:setBind("action",
    function(self,data)
      for _,v in pairs(data) do
        if v then return true end
      end
    end,
    {
      XBOX_360={args={"A"}},
      OUYA={args={"O"}},
      PS3={args={"CROSS"}},
      KEYBMOUSE={args={"return"," "}},
    })

  dong:setBind("left",
    function(self,data) return unpack(data) end,
    {
      XBOX_360={args={"DL"}},
      OUYA={args={"DL"}},
      PS3={args={"DL"}},
      KEYBMOUSE={args={"left"}},
    })
    
  dong:setBind("up",
    function(self,data) return unpack(data) end,
    {
      XBOX_360={args={"DU"}},
      OUYA={args={"DU"}},
      PS3={args={"DU"}},
      KEYBMOUSE={args={"up"}},
    })
    
  dong:setBind("right",
    function(self,data) return unpack(data) end,
    {
      XBOX_360={args={"DR"}},
      OUYA={args={"DR"}},
      PS3={args={"DR"}},
      KEYBMOUSE={args={"right"}},
    })
    
  dong:setBind("down",
    function(self,data) return unpack(data) end,
    {
      XBOX_360={args={"DD"}},
      OUYA={args={"DD"}},
      PS3={args={"DD"}},
      KEYBMOUSE={args={"down"}},
    })

end

dongs = {}
local keyb_dong = dong2lib.new()
setBindings(keyb_dong)
table.insert(dongs,keyb_dong) -- Keyboard and mouse

function love.load()
  if not LovePixlr:isBound() then
    LovePixlr.bind(320,240,"nearest")
    LovePixlr.setMaxScale()
    info_img = love.graphics.newImage("assets/info.png")
  end

  map = mapclass.new(10,1,10,20,2,"s")
  map:load("1")
  player = playerclass.new(map:getStartX(),map:getStartY(),map:getStartDirection())
  observablemap = fakedoom.new()
  observablemap:setbg(2)

  game = {
    start_time = love.timer.getTime(),
    encounters = 0,
    steps = 0,
  }
  global_random_step = 8
  events:force(
    function() end,
    function() end,
    "-------------\n"..
    game_name.."\n"..
    "-------------\n\n"..
    "@josefnpat #LD48 LD29",
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
             {text="Mommy! Hold my hand!",exec=function() global_diff=3 end},
             {text="My body is ready.",exec=function() global_diff=5 end},
             {text="I shall exterminate everything around me that restricts me from being the master.",exec=function() global_diff=7 end},
           }
         )
       end},
      {text="Quit",exec=function() love.event.quit() end},
    }
  )
end

bar_img = love.graphics.newImage("assets/bar.png")

function draw_bar(x,y,w,h,text,ratio,color)
  love.graphics.draw(bar_img,x,y,0,w,h/20)
  love.graphics.setColor(color)
  love.graphics.draw(bar_img,x,y,0,w*ratio,h/20)
  love.graphics.setColor(255,255,255)
  love.graphics.printf(text,x,y+4,w,"center")
end

dir_img = love.graphics.newImage("assets/dir.png")

function love.draw()
  local submap = map:submap(player:getX(),player:getY(),player:getDirection())
  observablemap:draw(0,0,submap)
  love.graphics.draw(info_img,240,0)
  map:mini(240,0,player:getX(),player:getY())
  love.graphics.draw(dir_img,280,120,player._direction*math.pi/2+math.pi*3/2,1,1,40,40)
  local cfont = love.graphics.getFont()
  local cardinal = {"west","north","east","south"}
  love.graphics.printf("FACING\n"..string.upper(cardinal[player._direction]),240,
    80+(80-cfont:getHeight()*2)/2,80,"center")
  
  love.graphics.setFont(font_small)
  draw_bar(240,160+20*0,80,20,"ATK "..player._atk.."/"..player._batk,
    (player._atk/player._batk),{255,0,0})
  draw_bar(240,160+20*1,80,20,"DEF "..player._def.."/"..player._bdef,
    (player._def/player._bdef),{54,74,196})
  draw_bar(240,160+20*2,80,20,"GOLD "..player._gold,1,{122,104,59})
  draw_bar(240,160+20*3,80,20,"SCORE "..math.floor(player._gold/(love.timer.getTime()-game.start_time))*10,1,{72,215,73})
  love.graphics.setFont(font)

  events:draw()
  if debug_mode then
    love.graphics.print(
      "number .. set +\n"..
      "lshift+key .. save to file\n"..
      "lctrl+key .. load from file\n"..
      "global_random_step:" ..global_random_step .."\n"..
      "marker: "..(debug_map_place or "+"),0,12)
  end
end

function love.keypressed(key)

  for _,dong in pairs(dongs) do
    dong:keypressed(key)
  end

  if key == "`" then
    debug_mode = not debug_mode
  end

  if debug_mode then
   if love.keyboard.isDown("lshift") and key ~= "lshift" then
      map:save(key)
    elseif love.keyboard.isDown("lctrl") and key ~= "lcrtrl" then
      map:load(key)
    elseif type(tonumber(key)) == "number" then
      debug_map_place = tonumber(key)
    elseif love.keyboard.isDown("g") then
      local re = events._random_encounters_good[#events._random_encounters_good]
      events:force(re.start,re.finish,re.text,re.choices)
    elseif love.keyboard.isDown("b") then
      local re = events._random_encounters_bad[#events._random_encounters_bad]
      events:force(re.start,re.finish,re.text,re.choices)
    end
  end

end

function check_all_dongs(bind)
  for i,v in pairs(dongs) do
    if v:getBind(bind) then
      return true
    end
  end
end

function love.update(dt)

  for _,dong in pairs(dongs) do
    dong:update(dt)
  end

  events:update(dt)

  if not events:running() then

    if check_all_dongs("up") then --key == "up" then
      if input_up then
        input_up = false
        if player:moveForward(map:getData()) then
          if events:step() then
            game.encounters = game.encounters + 1
          end
        end
      end
    else
      input_up = true
    end

    if check_all_dongs("down") then --key == "down" then
      if input_down then
        input_down = false
        if player:moveBackward(map:getData()) then
          if events:step() then
            game.encounters = game.encounters + 1
          end
        end
      end
    else
      input_down = true
    end

    if check_all_dongs("right") then --key == "right" then
      if input_right then
        input_right = false
        player:turnRight()
      end
    else
      input_right = true
    end

    if check_all_dongs("left") then --key == "left" then
      if input_left then
        input_left = false
        player:turnLeft()
      end
    else
      input_left = true
    end

  end

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
            "Encounters: "..(game.encounters).."\n"..
            "Gold: "..(player._gold).."\n"..
            "Steps: "..(game.steps).."\n"..
            "Score: "..math.floor(player._gold/(game.stop_time-game.start_time))*10
          )
        end,
        "You find a set of stairs that leads to the surface ... but do you really want to leave?"
      )
    end
  else
  end

end
