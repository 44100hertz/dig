local draw = require "draw"

return {
   init = function (self)
      self.timer = 0
   end,

   update = function (self)
      self.timer = self.timer + 1
      self.dy = -1
      self.y = self.y + self.dy
      if self.timer >= 15 then self.die = true end
   end,

   draw = function (self)
      local frame = math.floor(self.timer / 5) + 4
      draw.add(frame, 4, self.x, self.y)
   end,
}
