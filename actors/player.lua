local draw = require "draw"
local tiles = require "tiles"
local actors = require "actors"

local origin_x, origin_y = 8, 16

local bool2num = function (bool) return bool and 1 or 0 end

local loadstate = function (self, state)
   self.timer = 0
   self.state = state
end

local jump, floor, air, dig

move = function (self)
   self.dx =
      bool2num(love.keyboard.isScancodeDown("right")) -
      bool2num(love.keyboard.isScancodeDown("left"))
end

jump = function (self)
   self.dx = 0
   if self.timer == 4 then
      move(self)
      self.dy = -2
      loadstate(self, air)
   end
end

floor = function (self)
   if self.timer == 1 then
      actors.add({
	    class=require "actors/sandpuff", sprite=5,
	    x=self.x-8,
	    y=self.y,
      })
   end
   if not self.tx then
      loadstate(self, air)
      return
   end
   if self.timer > 4 then
      move(self)
      if love.keyboard.isScancodeDown("x") then
	 loadstate(self, dig)
      elseif love.keyboard.isScancodeDown("z") then
	 loadstate(self, jump)
      end
   end
end

air = function (self)
   if self.y % 16 < 2 and self.tx then
      loadstate(self, floor)
      self.dy = 0
      self.y = math.floor(self.y / 16) * 16
   else
      self.dy = math.min(self.dy + 1/8, 2)
   end
end

local dig_anim = {1,2,3,3,4,5,6,7,8,0}
dig = function (self)
   if self.timer < 11 then
      self.frame = dig_anim[self.timer]
   else
      if self.tx then
	 tiles.destroy(self.tx, self.ty)
      else
	 actors.add({
	       class=require "actors/sandpuff", sprite=5,
	       x=self.x,
	       y=self.y,
	 })
      end
      self.y = self.y + 2
      loadstate(self, air)
   end
   move(self)
end

return {
   init = function (self)
      self.dx, self.dy = 0,0
      loadstate(self, air)
      self.frame = 0
   end,

   update = function (self)
      self.tx, self.ty = tiles.collide(self.x, self.y)
      self.timer = self.timer + 1
      self:state()
   end,

   draw = function (self)
      draw.add(self.frame, 6, self.x - origin_x, self.y - origin_y, 1, 2)
   end
}
