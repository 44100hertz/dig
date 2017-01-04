local draw = require "draw"

return {
   update = function (self)
      if self.timer == 13 then self.die = true end
   end,

   draw = function (self)
      local frame = math.floor(self.timer / 5) + 7
      draw.add(frame, self.sprite, self.x, self.y, 1, 1, self.flip)
   end,
}
