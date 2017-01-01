local draw = require "draw"

return {
   init = function (self)
      self.flip = self.flip and true or false
      self.sprite = self.sprite or 0
      self.timer = 0
   end,

   update = function (self)
      if self.timer >= 15 then self.die = true end
   end,

   draw = function (self)
      local frame = math.floor(self.timer / 5) + 7
      draw.add(frame, self.sprite, self.x, self.y, 1, 1, self.flip)
   end,
}
