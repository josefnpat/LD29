local events = {}

function events.new()
  local o={}
  o.draw=events.draw
  o.update=events.update
  o.step=events.step
  o.add=events.add
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

return events
