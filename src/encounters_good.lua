events:add(
  function() end,--start
  function()
    player._atk = player._atk + 2
    if player._atk > player._batk then
      player._atk = player._batk
    end
  end,--finish
  "You find a whetstone. Your attack goes up.",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "good",--polarity
  5 -- count
)

events:add(
  function() end,--start
  function()
    player._def = player._def + 2
    if player._def > player._bdef then
      player._def = player._bdef
    end
  end,--finish
  "You find a patch. Your defence goes up.",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "good",--polarity
  5 -- count
)

events:add(
  function() end,--start
  function()
    player._gold = player._gold + math.random(50,150)
  end,--finish
  "You find some gold on the ground.",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "good",--polarity
  5 -- count
)

events:add(
  function() end,--start
  function()
    player._atk = player._batk
  end,--finish
  "You find a sword in perfect condition.",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "good"--polarity
)

events:add(
  function() end,--start
  function()
    player._def = player._bdef
  end,--finish
  "You find a shield in perfect condition.",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "good"--polarity
)

events:add(
  function() end,--start
  function() end,--finish
  "You stumble upon a hermit who is selling goods.",--text
  {
    {text="Buy a whetstone (25g)",exec=function()
      if player._gold >= 25 then
        player._gold = player._gold - 25
        events:force(
          function() end,
          function()
            player._atk = player._batk
          end,
          "You buy whetstone. The hermit packs up and leaves."
        )
      else
        events:force(
          function() end,
          function() end,
          "You do not have enough money. The hermit refuses to speak anymore."
        )
      end
    end},
    {text="Buy a patch (25g)",exec=function()
      if player._gold >= 25 then
        player._gold = player._gold - 25
        events:force(
          function() end,
          function()
            player._def = player._bdef
          end,
          "You buy the patch. The hermit packs up and leaves."
        )
      else
        events:force(
          function() end,
          function() end,
          "You do not have enough money. The hermit refuses to speak anymore."
        )
      end
    end},
    {text="Continue on.",exec=function() end},
  },--choices
  nil,--img
  nil,--timeout
  "good",--polarity
  20--count
)

events:add(
  function() end,--start
  function() end,--finish
  "You encounter a monk who is willing to train you.",--text
  {
    {text="Train your sword (100g)",exec=function()
      if player._gold >= 100 then
        player._gold = player._gold - 100
        events:force(
          function() end,
          function()
            player._batk = player._batk + 4
          end,
          "The monk stands and teaches you how to properly use a sword for an hour."
        )
      else
        events:force(
          function() end,
          function() end,
          "You do not have enough money. The monk refuses to speak anymore."
        )
      end
    end},
    {text="Train your shield (100g)",exec=function()
      if player._gold >= 100 then
        player._gold = player._gold - 100
        events:force(
          function() end,
          function()
            player._bdef = player._bdef + 8
          end,
          "The monk stands and teaches you how to properly use your shield for an hour."
        )
      else
        events:force(
          function() end,
          function() end,
          "You do not have enough money. The monk refuses to speak anymore."
        )
      end
    end},
    {text="Continue on.",exec=function() end},
  },--choices
  nil,--img
  nil,--timeout
  "good",--polarity
  20--count
)

-- easter egg
events:add(
  function() end,--start
  function() end,--finish
  "You find a blue cylinder on the ground that has the letters \"PEPSI\" inscribed on the side. You wonder if the owner would pay you to pretend to enjoy using this item. I suppose you could keep water in it?",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "good"--polarity
)

events:add(
  function() end,--start
  function() end,--finish
  "You see a pile of bones. It's rather gruesome.",--text
  nil,--choicesglobal_random_step
  nil,--img
  nil,--timeout
  "good"--polarity
)

events:add(
  function() end,--start
  function() end,--finish
  "\"I've got to get out of here!\" you think to yourself.",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "good"--polarity
)

events:add(
  function() end,--start
  function() end,--finish
  "You see a small fireplace that has hastily been put out.",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "good"--polarity
)

events:add(
  function() end,--start
  function()
    global_random_step = global_random_step + 1
  end,--finish
  "You find some cloth to wrap you feet. Now you are more quiet.",--text
  nil,--choices
  nil,--img
  nil,--timeout
  "good"--polarity
)

events:add(
  function() end,--start
  function() end,--finish
  "You encounter a family who is willing to bathe you.",--text
  {
    {text="Take a bath (50g)",exec=function()
      if player._gold >= 50 then
        player._gold = player._gold - 50
        events:force(
          function() end,
          function()
            global_random_step = global_random_step + 2
          end,
          "The family directs you to their watering hole, and lets you bathe there."
        )
      else
        events:force(
          function() end,
          function() end,
          "You do not have enough money. The family refuses to speak anymore."
        )
      end
    end},
    {text="Continue on.",exec=function() end},
  },--choices
  nil,--img
  nil,--timeout
  "good",--polarity
  20--count
)
