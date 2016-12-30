local draw = require "draw"
local origin_x, origin_y = 8, 16

return {
   init = function (self)
   end,

   update = function (self)
   end,

   draw = function (self)
      draw.add(0, 6, self.x - origin_x, self.y - origin_y, 1, 2)
   end
}
