local tiles = require "tiles"
local sound = require 'sound'

local slug = {
   hbox={x=-0.5, y=-3, w=1, h=3},
   group="enemy",
   priority = true,
   fx=0, fy=11,
   ox=4, oy=15,
}

function slug:init()
   self.turnaround = false
   if self.x < 120 then
      self.dir = 1
   else
      self.dir = -1
   end
end

function slug:update (scroll)
   if self.turnaround then
      self.dx = 0
      self.fx = 8
      self.ox = 8
      local t = self.turnaround
      self.turnaround = t - 1
      self.flip = (t > 2 and self.dir > 0) or (t <= 2 and self.dir < 0)
      if t <= 0 then
         self.dir = -self.dir
         self.turnaround = false
      end
      return
   end
   if tiles.collide(self.x, self.y) == 0 then
      self.falling = true
      self.fx = math.floor((self.timer / 4) % 2) + 4
      self.dy = math.min(self.dy + 0.1, 2)
   else
      if self.falling then
         sound.play_at_xy('slugland', self.x, self.y)
         if math.random() > 0.6 then self.turnaround = 4 end
         self.falling = false
      end
      self.dy = 0
      self.y = math.floor(self.y / 16) * 16
      self.fx = math.floor(self.timer / 4) % 4
      if tiles.collide(self.x + self.dir, self.y - 8) > 4 or
         self.x + self.dir < 0 or self.x + self.dir > 240
      then
         self.turnaround = 4
         self.dx = -self.dir
         return
      end
   end
   self.dx = self.falling and 0 or self.dir
   self.flip = self.dir > 0
   if self.y <= scroll then self.die = true end
end

function slug:collide()
end

return slug
