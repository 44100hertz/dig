local draw = require "draw"

return {
   init = function (self)
      self.kind = self.kind or math.ceil(math.random() * 4)
      self.big = self.big or math.ceil(math.random() * 2)
   end,

   update = function () end,
   
   draw = function (self)
      -- type must be 4, 5, 6
      draw.add(self.kind+3, self.big+1, self.x, self.y)
   end
}
