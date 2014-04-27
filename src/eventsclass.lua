local events = {}

function events.new()
  local o={}
  o.draw=events.draw
  o.update=events.update
  o.step=events.step
  o.add=events.add
  o.running=events.running
  o.force=events.force
  return o
end

function events:draw()
end

function events:update()
end

function events:step()
  print("STEP")
end

function events:add()
end

function events:running()
end

function events:force()

end

return events
