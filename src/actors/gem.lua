local draw = require "draw"

return {
   init = function (self)
      self.kind = self.kind or 1
      self.big = self.big or 1
   end,

   update = function () end,

   draw = function (self)
      -- type must be 4, 5, 6
      --      draw.add(self.kind+3, self.big+1, self.x, self.y)
      draw.add(4, 2, self.x, self.y)
   end
}
