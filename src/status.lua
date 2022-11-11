local draw = require "draw"

local score_h = 6
local depth_h = 15

local status = {
   points = 0,
   depth = 0,
   top_points = 2500,
   top_depth = 200,
}

function status:init ()
   self.points = 0
   self.depth = 0
end

function status:update(points, depth)
   self.points = points
   self.depth = math.max(self.depth, depth)
   self.top_points = math.max(points, self.top_points)
   self.top_depth = math.max(depth, self.top_depth)
end

function status:draw()
   draw.add(10, 0.5, 5, score_h, 2.5, 0.5) -- text 'score'
   self:draw_num(math.floor(self.points), 35, score_h)
   draw.add(12.5, 0.5, 5, depth_h, 2.5, 0.5) -- text 'depth'
   self:draw_num(math.floor(self.depth), 35, depth_h)

   draw.add(10, 1, 210, 1, 1, 0.5) -- text 'top'
   self:draw_num(math.floor(self.top_points), 235, score_h, true)
   self:draw_num(math.floor(self.top_depth), 235, depth_h, true)
   draw.draw()
end

function status:draw_num(num, x, y, right_align)
   if right_align then
      local width = #string.format(num)
      x = x - width * 8 - 8
   end
   local offx = 10
   local offy = 0
   local s = string.format(num)
   local off0 = string.byte("0")
   for i = 1,s:len() do
      local coffx = (s:byte(i)-off0) * 0.5
      if coffx < 0 then coffx = 5 end
      draw.add(coffx + offx, offy, x+i*8, y, 0.5, 0.5)
   end
end

return status
