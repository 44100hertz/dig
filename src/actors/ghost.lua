return {
   init = function (self)
      if math.random() > 0.5 then
         self.x = -100
         self.dx = 0.5
         self.flip = true
      else
         self.x = 340
         self.dx = -0.5
      end
      self.y_origin = self.y
      self.y_off = 20
      self.dy, self.ddy = 0,0
      self.fy = 10
   end,

   update = function (self)
      self.dy = self.dy - self.y_off * (1/512)
      self.y_off = self.y_off + self.dy
   end,

   draw = function (self)
      self.y = self.y_origin + self.y_off
      self.fx = math.floor(self.dy * 2 + 0.5) + 2
   end,
}
