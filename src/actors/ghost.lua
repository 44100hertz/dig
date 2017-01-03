return {
   init = function (self)
      if self.left then
         self.x = -10
         self.dx = 0.5
         self.flip = true
      else
         self.x = 250
         self.dx = -0.5
      end
      self.y_origin = self.y
      self.y_off = 20
      self.dy, self.ddy = 0,0
      self.fy = 10
      self.timer = 0
   end,

   update = function (self)
      self.dy = self.dy - self.y_off * (1/256)
      self.y_off = self.y_off + self.dy
      if self.timer == 600 then self.die = true end
   end,

   draw = function (self)
      self.y = self.y_origin + self.y_off
      self.fx = math.floor(self.dy*2 + 0.5) + 3
   end,
}
