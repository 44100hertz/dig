local game = require "game"
local actors = require "actors"
local sound = require "sound"

local pts = {
   [0] = {10, 20},
   {20, 40},
   {30, 60},
}

local gem_collect = {
   dy = -1,
   update = function (self)
      if self.timer == 30 then
        function self:draw ()
          love.graphics.printf(self.score, self.x+8-25, self.y, 50, 'center')
          self.fx = nil
        end
      elseif self.timer == 60 then
        self.die = true
      end
   end
}

return {
   init = function (self)
      self.fx = self.kind+4
      self.big = math.ceil(math.random() * 2)
      self.fy = self.big+1
   end,

   destroy = function (self)
     sound.play('gem')
      self.die = true
      local score = pts[self.kind][self.big]
      game.score(score)
      local gem = {
         x = self.x, y = self.y,
         fx = self.fx,
         fy = self.fy + 2,
         score = score,
      }
      actors.add(gem_collect, gem)
   end
}
