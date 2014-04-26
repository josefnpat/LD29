local fakedoom = {}

fakedoom = {}
fakedoom.walls = {}

function fakedoom.load_wall(name)
  fakedoom.walls[name] = {}
  for i,v in pairs({"wall","lwall","rwall","bg"}) do
    fakedoom.walls[name][v] = love.graphics.newImage("assets/walls/"..name.."/"..v..".png")
  end
  return data
end

fakedoom.load_wall("default")
fakedoom.load_wall("scarey")

function fakedoom.new()
  local f = {}
  f.draw = fakedoom.draw
  f.offset = fakedoom.offset
  f.depth = 3
  f.side_depth = 1
  f.size = 240
  return f
end

function fakedoom:offset(depth)
  -- http://en.wikipedia.org/wiki/1/2_%2B_1/4_%2B_1/8_%2B_1/16_%2B_%E2%8B%AF
  return (1 - 1 / (2^(depth-1)))/2
end

function fakedoom:draw(x,y,map)
  local name = "scarey"
  love.graphics.draw(fakedoom.walls[name].bg,x,y)
  for depth = self.depth,1,-1 do
    local offset = fakedoom:offset(depth)*self.size
    local intensity = 255 / depth
    love.graphics.setColor(intensity,intensity,intensity)
    for drawn = -self.side_depth,self.side_depth do
      local draw_map_off = 1
      local scale = 1/(2^(depth-1))
      local edge = scale*self.size
      local left_of = map[depth][drawn+draw_map_off] and
        map[depth][drawn+draw_map_off] ~= 0 or false
      local right_of = map[depth][drawn+draw_map_off+2] and
        map[depth][drawn+draw_map_off+2] ~= 0 or false
      local center = map[depth][drawn+draw_map_off+1] ~= 0 or false

      if center then
        love.graphics.draw(fakedoom.walls[name].wall,offset+drawn*edge,offset,0,scale)
      else
        if left_of then
          love.graphics.draw(fakedoom.walls[name].lwall,offset+drawn*edge,offset,0,scale)
        end
        if right_of then
          love.graphics.draw(fakedoom.walls[name].rwall,offset+drawn*edge,offset,0,scale)
        end
      end
      --love.graphics.print(depth..","..drawn,offset+drawn*edge,offset)
    end
  end
end



return fakedoom
