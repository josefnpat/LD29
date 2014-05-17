events:add(
  function() end,--start
  function()
    player._atk = player._atk - 2
    if player._atk < 0 then
      player._atk = 0
    end
  end,--finish
  "Your sword notches. Your attack goes down.",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "bad",--polarity,
  5 -- count
)

events:add(
  function() end,--start
  function()
    player._def = player._def - 2
    if player._def < 0 then
      player._def = 0
    end
  end,--finish
  "Your shield cracks. Your defence goes down.",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "bad",--polarity,
  5 -- count
)

events:add(
  function() end,--start
  function()
    player._gold = player._gold - math.random(5,15)
    if player._gold < 0 then
      player._gold = 0
    end
  end,--finish
  "You notice your gold purse has a broken seam.",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "bad",--polarity,
  5 -- count
)

events:add(
  function() end,--start
  function()
    player._atk = 0
  end,--finish
  "Your sword breaks.",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "bad"--polarity
)

events:add(
  function() end,--start
  function()
    player._def = 0
  end,--finish
  "Your shield breaks.",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "bad"--polarity
)

events:add(
  function() end,--start
  function() end,--finish
  "You encounter a small scarey monster.",--text
  {
    {text="Attack it!",exec=function()
    
      player._def = player._def - math.random(2,4)
      if player._def < 0 then
        player._def = 0
        events:force(
          function() end,
          function() love.load() end,
          "GAME OVER.\n\nYou are killed, your bones left to be gnawned on by the creatures of the caves."
        )
      else
        if player._atk > math.random(5,15) then
          events:force(
            function() end,
            function()
              player._gold = player._gold + math.random(50,150)
              if math.random(0,1)==1 then
                player._batk = player._batk + 1
              else
                player._bdef = player._bdef + 2
              end
            end,
            "You kill the monster and find some gold!\nYou feel a little stronger now."
          )
        else
          events:force(
            function() end,
            function() end,
            "You wound the monster, but it manages to escape."
          )
        end
      end
    
    end},
    {text="Run Away!",exec=function()
      player._def = player._def - math.random(1,2)
      if player._def < 0 then
        player._def = 0
        events:force(
          function() end,
          function() love.load() end,
          "GAME OVER.\n\nYou are killed, your bones left to be gnawned on by the creatures of the caves."
        )
      elseif math.random(1,8) == 1 then
        events:force(
          function() end,
          function() end,
          "You manage to escape, but just barely."
        )
      else
        if math.random(1,2) == 1 then
          events:force(
            function() end,
            function() player._atk = 0 end,
            "You escape. In the panic, you drop your sword."
          )
        else
          events:force(
            function() end,
            function() player._def = 0 end,
            "You escape. In the panic, you drop your shield."
          )
        end
      end
    end},
  },--choices
  nil,--img
  nil,--timeout
  "bad",--polarity
  30--count
)

events:add(
  function() end,--start
  function() end,--finish
  "You encounter a scarey monster.",--text
  {
    {text="Attack it!",exec=function()
    
      player._def = player._def - math.random(4,8)
      if player._def < 0 then
        player._def = 0
        events:force(
          function() end,
          function() love.load() end,
          "GAME OVER.\n\nYou are killed, your bones left to be gnawned on by the creatures of the caves."
        )
      else
        if player._atk > math.random(10,30) then
          events:force(
            function() end,
            function()
              player._gold = player._gold + math.random(100,300)
              if math.random(0,1)==1 then
                player._batk = player._batk + 2
              else
                player._bdef = player._bdef + 4
              end
            end,
            "You kill the monster and find some gold!\nYou feel a little stronger now."
          )
        else
          events:force(
            function() end,
            function() end,
            "You wound the monster, but it manages to escape."
          )
        end
      end
    
    end},
    {text="Run Away!",exec=function()
      player._def = player._def - math.random(2,4)
      if player._def < 0 then
        player._def = 0
        events:force(
          function() end,
          function() love.load() end,
          "GAME OVER.\n\nYou are killed, your bones left to be gnawned on by the creatures of the caves."
        )
      elseif math.random(1,8) == 1 then
        events:force(
          function() end,
          function() end,
          "You manage to escape, but just barely."
        )
      else
        if math.random(1,2) == 1 then
          events:force(
            function() end,
            function() player._atk = 0 end,
            "You escape. In the panic, you drop your sword."
          )
        else
          events:force(
            function() end,
            function() player._def = 0 end,
            "You escape. In the panic, you drop your shield."
          )
        end
      end
    end},
  },--choices
  nil,--img
  nil,--timeout
  "bad",--polarity
  20--count
)

events:add(
  function() end,--start
  function() end,--finish
  "You encounter a big scarey monster.",--text
  {
    {text="Attack it!",exec=function()
    
      player._def = player._def - math.random(8,16)
      if player._def < 0 then
        player._def = 0
        events:force(
          function() end,
          function() love.load() end,
          "GAME OVER.\n\nYou are killed, your bones left to be gnawned on by the creatures of the caves."
        )
      else
        if player._atk > math.random(20,60) then
          events:force(
            function() end,
            function()
              player._gold = player._gold + math.random(200,600)
              if math.random(0,1)==1 then
                player._batk = player._batk + 4
              else
                player._bdef = player._bdef + 8
              end
            end,
            "You kill the monster and find some gold!\nYou feel a little stronger now."
          )
        else
          events:force(
            function() end,
            function() end,
            "You wound the monster, but it manages to escape."
          )
        end
      end
    
    end},
    {text="Run Away!",exec=function()
      player._def = player._def - math.random(4,8)
      if player._def < 0 then
        player._def = 0
        events:force(
          function() end,
          function() love.load() end,
          "GAME OVER.\n\nYou are killed, your bones left to be gnawned on by the creatures of the caves."
        )
      elseif math.random(1,8) > 1 then
        events:force(
          function() end,
          function() end,
          "You manage to escape, but just barely."
        )
      else
        if math.random(1,2) == 1 then
          events:force(
            function() end,
            function() player._atk = 0 end,
            "You escape. In the panic, you drop your sword."
          )
        else
          events:force(
            function() end,
            function() player._def = 0 end,
            "You escape. In the panic, you drop your shield."
          )
        end
      end
    end},
  },--choices
  nil,--img
  nil,--timeout
  "bad",--polarity
  10--count
)

-- easter egg
events:add(
  function() end,--start
  function() end,--finish
  "You find written on the wall;\n\"ABANDON HOPE, ALL YE WHO TRAVELS HERE.. SOME CRAZY PROGRAMMER WANTS YOU DEAD.\"\nWhat's a programmer?",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "bad"--polarity
)

events:add(
  function() end,--start
  function() end,--finish
  "You hear heavy breathing coming from somewhere.",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "bad"--polarity
)

events:add(
  function() end,--start
  function() end,--finish
  "You feel a cool wind on your face. Surely you must be going the right way.",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "bad"--polarity
)

events:add(
  function() end,--start
  function() end,--finish
  "I feel like I've been here before...",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "bad"--polarity
)

events:add(
  function() end,--start
  function()
    global_random_step = global_random_step - 1
    if global_random_step < 1 then
      global_random_step = 1
    end
  end,--finish
  "You step in something disgusting. Surely everything will smell you now.",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "bad"--polarity
)
