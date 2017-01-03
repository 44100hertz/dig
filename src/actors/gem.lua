local actors = require "actors"
local draw = require "draw"

local gem_collect = {
   init = function (self)
      self.dy = -1
      self.timer = 0
   end,

   update = function (self)
      if self.timer == 30 then self.dy = 0 end
      if self.timer == 60 then self.die = true end
   end
}

return {
   init = function (self)
      self.fx = self.kind+4
      self.fy = math.ceil(math.random() * 2) + 1
   end,

   destroy = function (self)
      self.die = true
      actors.add({
            class = gem_collect,
            x = self.x, y = self.y,
            fx = self.fx,
            fy = self.fy + 2,
      })
   end
}
