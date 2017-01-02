local draw = require "draw"

return {
   init = function (self)
      self.sx, self.sy = 1,1
      self.fx = self.kind or math.ceil(math.random() * 4) + 3
      self.fy = self.big or math.ceil(math.random() * 2) + 1
   end
}
