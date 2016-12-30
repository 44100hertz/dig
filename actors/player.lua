local draw = require "draw"
local tiles = require "tiles"

local origin_x, origin_y = 8, 16

return {
   init = function (self)
      self.dx, self.dy = 0,0
   end,

   update = function (self)
      if tiles.collide(self.x, self.y) then
	 self.dy = 0
      else
	 self.dy = self.dy > 2 and self.dy + 1/8 or 2
      end
   end,

   draw = function (self)
      draw.add(0, 6, self.x - origin_x, self.y - origin_y, 1, 2)
   end
}
