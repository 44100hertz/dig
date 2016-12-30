local draw = require "draw"

return {
   init = function (self)
      self.timer = 0
      self.dy = -1
   end,

   update = function (self)
      self.timer = self.timer + 1
      if self.timer >= 15 then self.die = true end
   end,

   draw = function (self)
      local frame = math.floor(self.timer / 5) + 4
      draw.add(frame, 4, self.x, self.y)
   end,
}
