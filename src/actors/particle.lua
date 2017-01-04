local draw = require "draw"

return {
   update = function (self)
      if self.timer == 13 then self.die = true end
   end,

   draw = function (self)
      self.fx = math.floor(self.timer / 5) + 7
   end,
}
