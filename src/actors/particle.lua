return {
   ddy = 0,
   lifetime = 12,
   init = function (self)
      if self.fy == 0 then -- dug sand
         self.dy = -1
      elseif self.fy == 4 then -- broke rock
        self.dx = math.random()*6 - 3
        self.dy = -(math.random()+1) * 4 + 1
        self.ddy = 0.25
        self.lifetime = 80
      end
      self.anim_offset = math.random()
   end,

   update = function (self)
      if self.timer == self.lifetime-1 then self.die = true end
      self.dy = self.dy + self.ddy
      if self.fy == 4 then
        self.fx = math.floor((4 * self.timer / self.lifetime + self.anim_offset) % 1.0 * 3) + 7
      else
        self.fx = math.floor(self.timer / self.lifetime * 3) + 7
      end
   end,
}
