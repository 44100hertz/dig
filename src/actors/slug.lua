local tiles = require "tiles"

return {
   hbox={y=-4, w=4, h=2},
   group="enemy",
   priority = true,
   fx=0, fy=11,
   ox=0, oy=15,

   init = function (self)
      if self.x < 120 then
         self.dir = 1
      else
         self.dir = -1
      end
   end,

   update = function (self, scroll)
      if tiles.collide(self.x, self.y) == 0 then
         self.falling = true
         self.fx = math.floor((self.timer / 4) % 2) + 4
         self.dy = math.min(self.dy + 0.1, 2)
      else
         self.falling = false
         self.dy = 0
         self.y = math.floor(self.y / 16) * 16
         self.fx = math.floor(self.timer / 4) % 4
         if tiles.collide(self.x + self.dir, self.y - 8) > 4 or
            self.x + self.dir < 0 or self.x + self.dir > 240
         then
            self.dir = -self.dir
         end
      end
      self.dx = self.falling and 0 or self.dir
      self.flip = self.dir > 0
      self.ox = self.flip and -8 or 8
      if self.y <= scroll or self.y > scroll + 300 then self.die = true end
   end,

   collide = function (self) end
}
