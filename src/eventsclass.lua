local events = {}

events.padding = 2

function events.new()
  local o={}
  o.draw=events.draw
  o.update=events.update
  o.keypressed=events.keypressed
  o.step=events.step
  o.add=events.add
  o.running=events.running
  o.force=events.force

  o._queue = {}
  o._random_encounters_good = {}
  o._random_encounters_bad = {}
  return o
end

function events:draw()
  if self._current then

    if self._current.img then
      love.graphics.draw(self._current.img,0,0)
    else
      love.graphics.setColor(0,0,0,127)
      local cfont = love.graphics.getFont()
      local font_h = cfont:getHeight()

      local _,text_l = cfont:getWrap(self._current.text,240-events.padding*4)
      local text_h = font_h*text_l

      local choice_l = 0
      for i,v in pairs(self._current.choices or {}) do
        local _,vchoice_l = cfont:getWrap(v.text,240-events.padding*4)
        choice_l = choice_l + vchoice_l
      end
      local choice_h = font_h*choice_l

      local hoff = (240 - text_h - choice_h)/2

      love.graphics.rectangle("fill",
        events.padding,hoff-events.padding,
        240-events.padding*2,
        (text_l+choice_l+(self._current.choices and 1 or 0))*
          font_h+events.padding*2)

      love.graphics.setColor(255,255,255)
      love.graphics.printf(self._current.text,events.padding*2,hoff,240-events.padding*4,"center")

      local cur_l = 0
      if self._current.choices then
        for i,v in pairs(self._current.choices) do
          love.graphics.setColor(
            self._current_choice == i and {0,255,255} or {127,127,127}
          )
          love.graphics.printf(v.text,events.padding*2,hoff+font_h*(text_l+cur_l+1),
            240-events.padding*4,"center")
          local _,l = cfont:getWrap(v.text,240-events.padding*4)
          cur_l = cur_l + l
        end
      end
      love.graphics.setColor(255,255,255)
    end

  end
end

function events:update(dt)

  if #self._queue > 0 then
    self._current = table.remove(self._queue)
    self._current_choice = 1
    self._current.start()
  end

  if self._current and self._current.timeout then
    self._current.timeout = self._current.timeout - dt
    if self._current.timeout < 0 then
      self._current.finish()
      self._current = nil
    end
  end

  if self._current then

    if self._current.choices then

      if check_all_dongs("up")  then
        if input_up then
          sfx.play("choice")
          input_up = false
          self._current_choice = self._current_choice - 1
          if self._current_choice < 1 then
            self._current_choice = #self._current.choices
          end
        end
      else
        input_up = true
      end

      if check_all_dongs("down") then
        if input_down then
          sfx.play("choice")
          input_down = false
          self._current_choice = self._current_choice + 1
          if self._current_choice > #self._current.choices then
            self._current_choice = 1
          end
        end
      else
        input_down = true
      end

    end

    if check_all_dongs("action") then
      if input_action then
        sfx.play("action")
        input_action = false
        if self._current.choices then
          self._current.choices[self._current_choice].exec()
        end
        self._current.finish()
        self._current = nil
      end
    else
      input_action = true
    end

  end

end

function events:step()
  game.steps = game.steps + 1
  if math.random(1,global_random_step) == 1 and not (map:getFinishX() == player:getX() and map:getFinishY() == player:getY())then
    local re
    if math.random(1,10) > global_diff then -- good
      re = self._random_encounters_good[math.random(1,#self._random_encounters_good)]
      sfx.play("good")
    else -- bad
      re = self._random_encounters_bad[math.random(1,#self._random_encounters_bad)]
      sfx.play("bad")
    end
    self:force(re.start,re.finish,re.text,re.choices)
    return true
  end
  sfx.play("step")
end

function events:add(start,finish,text,choices,img,timeout,polarity)
  local target = self._random_encounters_good
  if polarity == "bad" then
    target = self._random_encounters_bad
  end
  table.insert(target,
    {start=start,finish=finish,text=text,choices=choices,img=img,timeout=timeout}
  )
end

function events:running()
  if self._current then return true else return false end
end

function events:force(start,finish,text,choices,img,timeout)
  table.insert(self._queue,
    {start=start,finish=finish,text=text,choices=choices,img=img,timeout=timeout}
  )
end

return events
