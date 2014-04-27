local fakedoom = {}

fakedoom = {}
fakedoom.walls = {}

function fakedoom.load_wall(name,color)
  local id = #fakedoom.walls+1
  fakedoom.walls[id] = {}
  fakedoom.walls[id].data = {}
  fakedoom.walls[id].name = name
  for i,v in pairs({"wall","lwall","rwall","bg"}) do
    fakedoom.walls[id].data[v] = love.graphics.newImage("assets/walls/"..name.."/"..v..".png")
    fakedoom.walls[id].color = color or {0,255,0}
  end
  return data
end

fakedoom.load_wall("default",{255,0,255})
fakedoom.load_wall("dirt",{89,66,47})
fakedoom.load_wall("lava",{255,0,0})
fakedoom.load_wall("moss",{49,128,28})

function fakedoom.new()
  local f = {}
  f.draw = fakedoom.draw
  f.offset = fakedoom.offset
  f.setbg = fakedoom.setbg
  f.depth = 3
  f.side_depth = 1
  f.size = 240
  f._cache_bg_id = 1
  return f
end

function fakedoom:offset(depth)
  -- http://en.wikipedia.org/wiki/1/2_%2B_1/4_%2B_1/8_%2B_1/16_%2B_%E2%8B%AF
  return (1 - 1 / (2^(depth-1)))/2
end

function fakedoom:setbg(id)
  if fakedoom.walls[id] then
    self._cache_bg_id = id
  end
end

function fakedoom:draw(x,y,map)
  love.graphics.draw(fakedoom.walls[self._cache_bg_id].data.bg,x,y)
  for depth = self.depth,1,-1 do
    local offset = fakedoom:offset(depth)*self.size
    for drawn = -self.side_depth,self.side_depth do

      local intensity = 255 / (depth + math.abs(drawn))
      love.graphics.setColor(intensity,intensity,intensity)

      local draw_map_off = 1
      local scale = 1/(2^(depth-1))
      local edge = scale*self.size
      local left_of = map[depth][drawn+draw_map_off] and
        map[depth][drawn+draw_map_off] ~= 0 or false
      local right_of = map[depth][drawn+draw_map_off+2] and
        map[depth][drawn+draw_map_off+2] ~= 0 or false
      local center = map[depth][drawn+draw_map_off+1] ~= 0 or false

      if center then
        local center_id = map[depth][drawn+draw_map_off+1] or 1
        love.graphics.draw(fakedoom.walls[center_id].data.wall,offset+drawn*edge,offset,0,scale)
      else
        if left_of then
          local left_id = map[depth][drawn+draw_map_off]
          love.graphics.draw(fakedoom.walls[left_id].data.lwall,offset+drawn*edge,offset,0,scale)
        end
        if right_of then
          local right_id = map[depth][drawn+draw_map_off+2]
          love.graphics.draw(fakedoom.walls[right_id].data.rwall,offset+drawn*edge,offset,0,scale)
        end
      end
      if debug_mode then
        love.graphics.print(depth..","..drawn,offset+drawn*edge,offset)
      end
    end
  end
end



return fakedoom
