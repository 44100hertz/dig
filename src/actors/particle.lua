return {
   ddy = 0,
   lifetime = 12,
   init = function (self)
      if self.fy == 0 then -- dug sand
         self.dy = -1
      elseif self.fy == 4 then -- broke rock
         self.dx = math.random()*6 - 3
         self.dy = -(math.random()+1) * 4
         self.ddy = 0.25
         self.lifetime = 80
      end
   end,

   update = function (self)
      if self.timer == self.lifetime-1 then self.die = true end
      self.dy = self.dy + self.ddy
      self.fx = math.floor(self.timer / self.lifetime * 3) + 7
   end,
}
