local draw = require "draw"

return {
   init = function (self)
      self.sprite = self.sprite or 4
      self.timer = 0
      self.dy = -1
   end,

   update = function (self)
      self.timer = self.timer + 1
      if self.timer >= 15 then self.die = true end
   end,

   draw = function (self)
      local frame = math.floor(self.timer / 5) + 4
      draw.add(frame, self.sprite, self.x, self.y)
   end,
}
